module Notebooks
	class Notebook

		attr_accessor :owner, :name, :notes
		
		def initialize(owner, name, notes)
			@owner = owner
			@name = name
			@notes = notes
		end

		def getNotes
			@notes
		end

		def getName
			@name
		end
	end
end