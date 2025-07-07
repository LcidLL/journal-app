class CreateBooks < ActiveRecord::Migration[7.2]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.date :publish_date
      t.text :summary
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
