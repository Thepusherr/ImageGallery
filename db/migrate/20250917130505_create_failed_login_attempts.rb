class CreateFailedLoginAttempts < ActiveRecord::Migration[7.1]
  def change
    create_table :failed_login_attempts do |t|
      t.string :ip_address
      t.string :email
      t.integer :attempts_count, default: 1
      t.datetime :last_attempt_at
      t.datetime :blocked_until

      t.timestamps
    end

    add_index :failed_login_attempts, :ip_address
    add_index :failed_login_attempts, :email
    add_index :failed_login_attempts, :last_attempt_at
  end
end
