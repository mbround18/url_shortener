class AddIndexesToUrlSource < ActiveRecord::Migration[5.0]
	def self.up
		add_index :urls, :source, unique: true
	end

	def self.down
		remove_index :urls, :source, unique: false
	end
end
