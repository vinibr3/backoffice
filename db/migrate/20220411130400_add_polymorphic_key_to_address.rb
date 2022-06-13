class AddPolymorphicKeyToAddress < ActiveRecord::Migration[6.0]
  def change
    add_reference :addresses, :addressable, polymorphic: true
  end
end
