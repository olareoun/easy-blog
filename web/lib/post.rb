require 'crafty'
require 'htmlentities'
require_relative 'base_post'

module Blog
  class Post

    include Crafty::HTML::All
    include BasePost

    attr_accessor :title, :content

    def initialize 
    end

    def to_s
      description = ''
      description += @title.to_s unless @title.nil?
      description += ' - ' unless (description.empty? || @content.nil?)
      description += @content.to_s unless @content.nil?
      description
    end

    def to_html
      html = ''
      html += renderTitle if hasTitle
      html += renderContent if hasContent
      HTMLEntities.new.decode(html)
    end

    def renderContent
      if hasContent
        section class: ['post-content'] do
          @content
        end
      end
    end

    def renderTitle
      if hasTitle 
        section class: ['post-header', 'hideme'] do
          renderImage
          p class: ['post-title'] do
            @title
          end
        end
      end
    end

    def renderAudios
      return if @audio.nil?
      @audio.each do |audio|
        renderAudio audio
      end
    end

    def renderImages
      return if @images.nil?
      @images.each do |image|
        renderImage image
      end
    end

    def imageSrc
      src = ""
      src = @images.first.getSrc if hasImage?
      src
    end

    def renderImage
      img src: [imageSrc], id: ['custom-img'] do
      end
    end

    def renderAudio(audio)
      src = 'data:' + audio.mimeType + ';base64,' + Base64.encode64(audio.bin)
      section do
        audio do
          source src: [src], type: [audio.mimeType]
        end
      end
    end

  end
end