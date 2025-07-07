class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.string :reading_status
      t.text :chapter_summary
      t.date :target_date
      t.references :book, null: false, foreign_key: true

      t.timestamps
    end
  end
end
