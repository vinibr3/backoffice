class AddProfileRefToUsers < ActiveRecord::Migration[6.0]
  def change
    add_reference :users, :profile, null: true, foreign_key: true
  end
end
