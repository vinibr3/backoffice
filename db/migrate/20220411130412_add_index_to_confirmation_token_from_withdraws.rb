class AddIndexToConfirmationTokenFromWithdraws < ActiveRecord::Migration[6.0]
  def change
    add_index :withdraws, :confirmation_token
  end
end
