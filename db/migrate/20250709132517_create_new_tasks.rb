class CreateNewTasks < ActiveRecord::Migration[7.2]
  def change
    # Rename the existing tasks table to preserve data during migration
    rename_table :tasks, :old_tasks
    
    create_table :tasks do |t|
      t.string :task_name, null: false
      t.text :description
      t.date :due_date
      t.string :status, default: 'pending', null: false
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end

    add_index :tasks, [:category_id, :due_date]
    add_index :tasks, :status
    add_index :tasks, :due_date
  end
end