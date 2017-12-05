class CreateUrls < ActiveRecord::Migration[5.0]
	def self.up
		create_table :urls do |t|
			t.string :source
			t.string :destination
			t.string :email
			t.boolean :active
			t.integer :clicks
			t.timestamps null: false
		end
	end

	def self.down
		drop_table :urls
	end
end
