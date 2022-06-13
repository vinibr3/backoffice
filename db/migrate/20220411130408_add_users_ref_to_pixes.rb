class AddUsersRefToPixes < ActiveRecord::Migration[6.0]
  def change
    add_reference :pixes, :user, null: false, foreign_key: true
  end
end
