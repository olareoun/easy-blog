module Notebooks
	class Attachment

		attr_accessor :name, :mimeType, :bin

		def initialize(name, mimeType, bin, guid)
			@name = name
			@mimeType = mimeType
			@bin = bin
      @guid = guid
		end

    def getSrc
      'data:' + @mimeType + ';base64,' + Base64.encode64(@bin)
    end
    
    def getGuid
      @guid
    end

	end
end