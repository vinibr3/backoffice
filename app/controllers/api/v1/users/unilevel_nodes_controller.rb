# frozen_string_literal: true

class Api::V1::Users::UnilevelNodesController < UsersController
  before_action :authenticate!

  def index
    nodes = unilevel_nodes.page(page)
                          .per(per_page)

    render jsonapi: nodes,
           include: [user: [:profile, orders: [items: [:product]]],
                     sponsored: [:profile, orders: [items: [:product]]]],
           links: pagination_links(nodes)
  end

  private

  def unilevel_nodes
    unilevel_node = UnilevelNode.find(valid_params[:unilevel_node_id])
    query = unilevel_node.descendants
                         .includes(user: [:profile, orders: [items: [:product]]],
                                  sponsored: [:profile, orders: [items: [:product]]])
                         .joins(:user, :sponsored)

    active = valid_params[:active]
    query.merge!(UnilevelNode.by_active_sponsored) if active == 'true'

    inactive = valid_params[:inactive]
    query.merge!(UnilevelNode.by_inactive_sponsored) if inactive == 'true'

    from = valid_params[:created_at_from]
    from = Time.zone.parse(from.present? ? from : 100.years.ago.to_s)
    untill = valid_params[:created_at_until]
    untill = Time.parse(untill.present? ? untill : Time.now.end_of_day.to_s)
    query.merge!(UnilevelNode.by_sponsored_created_at_between(from, untill))

    current_ancestry_depth = unilevel_node.try(:ancestry_depth).to_i
    if valid_params[:generation].present?
      generation = valid_params[:generation].to_i

      query.merge!(UnilevelNode.by_ancestry_depth(current_ancestry_depth + generation))
    else
      default_maximum_generation =
        SystemParametrization.current.maximum_generation_range_to_query_unilevel_nodes
      generation = valid_params[:maximum_generation]
      generation = generation.present? ? generation.to_i : default_maximum_generation
      generation = [generation, default_maximum_generation].min

      query.merge!(UnilevelNode.by_ancestry_depth_until(current_ancestry_depth + generation))
    end

    key = valid_params[:unique_key]
    query.merge!(UnilevelNode.by_user_unique_key(key)) if key.present?

    query
  end

  def valid_params
    params.permit(:unilevel_node_id, :active, :inactive, :created_at_from,
                  :created_at_until, :maximum_generation, :unique_key,
                  :generation)
  end
end
