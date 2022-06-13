class UsersController < ApplicationController
  include AuthorizableConcern

  def render_user(user)
    render jsonapi: user,
           include: [:unilevel_node, :address, :profile, :wallets, :pixes, :bank_accounts]
  end
end
