class DropOldTables < ActiveRecord::Migration[7.2]
  def up
    drop_table :old_tasks if table_exists?(:old_tasks)
    drop_table :books if table_exists?(:books)
  end
  
  def down
    # This is irreversible - we've already migrated the data
    raise ActiveRecord::IrreversibleMigration, "Cannot recreate dropped tables"
  end
end