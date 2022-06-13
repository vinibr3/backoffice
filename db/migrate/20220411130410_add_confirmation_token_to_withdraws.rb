class AddConfirmationTokenToWithdraws < ActiveRecord::Migration[6.0]
  def change
    add_column :withdraws, :confirmation_token, :string, default: ''
  end
end
