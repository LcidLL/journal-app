class MigrateBooksToCategories < ActiveRecord::Migration[7.2]
  def up
    return unless table_exists?(:books)
    
    # Create categories from books
    execute <<-SQL
      INSERT INTO categories (category_name, description, user_id, created_at, updated_at)
      SELECT 
        CONCAT(title, ' by ', author) as category_name,
        CASE 
          WHEN summary IS NOT NULL AND summary != '' 
          THEN CONCAT('Book: ', title, E'\\n', 'Author: ', author, E'\\n\\n', summary)
          ELSE CONCAT('Book: ', title, E'\\n', 'Author: ', author)
        END as description,
        user_id,
        created_at,
        updated_at
      FROM books
      ORDER BY created_at;
    SQL
    
    # Create a mapping between books and categories
    book_category_mapping = {}
    
    # Get the mapping
    books = ActiveRecord::Base.connection.select_all("SELECT id, title, author, user_id FROM books ORDER BY created_at")
    categories = ActiveRecord::Base.connection.select_all("SELECT id, category_name, user_id FROM categories ORDER BY created_at")
    
    books.each_with_index do |book, index|
      category = categories[index]
      if category && category['user_id'] == book['user_id']
        book_category_mapping[book['id']] = category['id']
      end
    end
    
    # Migrate old tasks to new tasks table
    if table_exists?(:old_tasks)
      old_tasks = ActiveRecord::Base.connection.select_all("SELECT * FROM old_tasks")
      
      old_tasks.each do |task|
        category_id = book_category_mapping[task['book_id']]
        next unless category_id
        
        # Map reading_status to new status
        new_status = case task['reading_status']
                    when 'not_started' then 'pending'
                    when 'reading' then 'in_progress'
                    when 'completed' then 'completed'
                    when 'on_hold' then 'pending'
                    else 'pending'
                    end
        
        # Create task name based on original data
        task_name = if task['chapter_summary'].present?
                     task['chapter_summary'].truncate(50)
                   else
                     "Reading Task"
                   end
        
        execute <<-SQL
          INSERT INTO tasks (task_name, description, due_date, status, category_id, created_at, updated_at)
          VALUES (
            #{ActiveRecord::Base.connection.quote(task_name)},
            #{ActiveRecord::Base.connection.quote(task['chapter_summary'])},
            #{task['target_date'] ? ActiveRecord::Base.connection.quote(task['target_date']) : 'NULL'},
            #{ActiveRecord::Base.connection.quote(new_status)},
            #{category_id},
            #{ActiveRecord::Base.connection.quote(task['created_at'])},
            #{ActiveRecord::Base.connection.quote(task['updated_at'])}
          )
        SQL
      end
    end
  end
  
  def down
    # This migration is not easily reversible
    raise ActiveRecord::IrreversibleMigration, "Cannot reverse the migration from books to categories"
  end
end