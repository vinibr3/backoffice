class CreateUnilevelNodes < ActiveRecord::Migration[6.0]
  def change
    create_table :unilevel_nodes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :sponsored, null: false, foreign_key: { to_table: :users }
      t.text       :ancestry, index: true
      t.integer    :ancestry_depth, default: 0

      t.timestamps
    end
  end
end
