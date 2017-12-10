require 'securerandom'
class Url < ActiveRecord::Base

	after_initialize :set_defaults

	validates_presence_of :source
	validates_presence_of :destination
	# validates_presence_of :active
	validates_presence_of :clicks

	validates :source, :uniqueness => true
	validates :active, :inclusion => { :in => [true, false] }

	validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ix, allow_nil: true
	validates_format_of :destination, with: /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix


	def set_defaults
		self.source ||= SecureRandom.hex(4)
		self.active = true if self.active.nil?
		self.clicks ||= 0
	end

end
