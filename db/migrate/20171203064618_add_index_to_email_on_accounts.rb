class AddIndexToEmailOnAccounts < ActiveRecord::Migration[5.0]
	def self.up
		add_index :accounts, :email, unique: true
	end

	def self.down
		remove_index :accounts, :email
	end
end
