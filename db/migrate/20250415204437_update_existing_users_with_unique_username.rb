class UpdateExistingUsersWithUniqueUsername < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      UPDATE users 
      SET username = CONCAT(name, '_', surname, '_', id) 
      WHERE username IS NULL OR username = '';
    SQL
    
    User.find_each do |user|
      next if User.where(username: user.username).count <= 1
      
      user.update_column(:username, "#{user.username}_#{user.id}")
    end
    
    User.find_each(&:save)
  end

  def down
  end
end
