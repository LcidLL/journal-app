class ChangePendingToPriority < ActiveRecord::Migration[7.2]
  def up
    # Update all existing 'pending' tasks to 'priority'
    Task.where(status: 'pending').update_all(status: 'priority')
    
    # Also update any tasks with nil status to 'priority' (default)
    Task.where(status: nil).update_all(status: 'priority')
  end

  def down
    # Reverse the change if needed
    Task.where(status: 'priority').update_all(status: 'pending')
  end
end