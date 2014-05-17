require_relative 'bad_argument_exception'
require_relative 'extractor'

class PublicUrl

	attr_accessor :user_name, :notebook_name, :host

	def initialize(publicUrl)
		raise BadArgumentException, 'empty.url' if notValid publicUrl
    @user_name = Extractor.extractUsername(publicUrl)
    @notebook_name = Extractor.extractNotebookName(publicUrl)
    @host = Extractor.extractHost(publicUrl)
	end

private 

	def notValid(publicUrl)
		publicUrl.nil? || publicUrl.empty?
	end

end
