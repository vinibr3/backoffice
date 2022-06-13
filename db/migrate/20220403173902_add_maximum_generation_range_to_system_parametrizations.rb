class AddMaximumGenerationRangeToSystemParametrizations < ActiveRecord::Migration[6.0]
  def change
    add_column :system_parametrizations, :maximum_generation_range_to_query_unilevel_nodes, :integer, limit: 2, default: 5
  end
end
