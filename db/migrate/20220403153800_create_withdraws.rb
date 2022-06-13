class CreateWithdraws < ActiveRecord::Migration[6.0]
  def change
    create_table :withdraws do |t|
      t.references :user
      t.references :updater_admin_user
      t.references :currency
      t.references :receivable_method, polymorphic: true, index: {name: 'index_receivable_method'}
      t.integer :gross_amount, limit: 8
      t.integer :net_amount, limit: 8
      t.integer :fee, limit: 8
      t.integer :receivable_currency_amount, limit: 8
      t.integer :status
      t.datetime :status_update_at
    end
  end
end
