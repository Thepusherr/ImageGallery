class UpdateExistingUsersWithUniqueUsername < ActiveRecord::Migration[7.1]
  def up
    # Сначала обновим пользователей без username
    execute <<-SQL
      UPDATE users 
      SET username = CONCAT(name, '_', surname, '_', id) 
      WHERE username IS NULL OR username = '';
    SQL
    
    # Теперь обработаем дублирующиеся username
    User.find_each do |user|
      # Пропускаем пользователей с уникальными username
      next if User.where(username: user.username).count <= 1
      
      # Для дублирующихся username добавляем уникальный суффикс
      user.update_column(:username, "#{user.username}_#{user.id}")
    end
    
    # Обновляем slug для всех пользователей
    User.find_each(&:save)
  end

  def down
    # Этот метод не отменяет изменения, так как это может привести к потере данных
  end
end
