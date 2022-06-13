class CreateAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses do |t|
      t.string :zipcode, default: ''
      t.string :street, default: ''
      t.string :number, default: ''
      t.string :complement, default: ''
      t.string :district, default: ''
      t.string :city, default: ''
      t.string :state, default: ''
      t.string :country, default: ''
    end
  end
end
