class AddNameFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :first_name, :string, null: false, default: 'User'
    add_column :users, :last_name, :string, null: false, default: 'Name'
    add_column :users, :is_admin, :boolean, default: false, null: false
    
    reversible do |dir|
      dir.up do
        User.update_all(first_name: 'User', last_name: 'Name')
      end
    end
    
    change_column_default :users, :first_name, from: 'User', to: nil
    change_column_default :users, :last_name, from: '', to: nil
  end
end