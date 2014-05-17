class BadArgumentException < Exception
	attr_reader :exception_key
	def initialize(exception_key)
		@exception_key = exception_key
	end
end