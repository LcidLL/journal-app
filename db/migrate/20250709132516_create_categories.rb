class CreateCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :categories do |t|
      t.string :category_name, null: false
      t.text :description
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :categories, [:user_id, :category_name]
    add_index :categories, :category_name
  end
end