class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :title, null: false
      t.string :tags
      t.integer :price, default: 0, null: false
      t.boolean :promoted, null: false, default: false

      t.timestamps
    end
    add_index :products, :title, unique: true
    add_index :products, :promoted
  end
end
