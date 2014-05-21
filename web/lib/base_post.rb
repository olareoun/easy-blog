module BasePost

    def entitle aTitle
      @title = aTitle
    end

    def putContent aContent
      @content = aContent
    end

    def putImages images
      @images = images
    end

    def putAudio audio
      @audio = audio
    end

    def putUpdated updated
      @updated = Time.at(updated / 1000)
    end

    def hasImage?
      !(@images.nil? || @images.empty?) && @images.first
    end

    def hasTitle
      !@title.nil? && !@title.empty?
    end

    def hasContent
      !@content.nil? && !@content.empty? && !contentWithoutHtmlTags.empty?
    end

    def contentWithoutHtmlTags
      @content.gsub(%r{</?[^>]+?>}, '')
    end

    def empty?
      to_s.empty?
    end

end