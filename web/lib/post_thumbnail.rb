require 'crafty'
require 'htmlentities'

module Blog
  class PostThumbnail

    include Crafty::HTML::All
    include BasePost

    attr_accessor :title, :content

    def initialize 
    end

    def url= a_url
      @url = a_url
    end

    def to_html
      html = article class: ['post-thumbnail'], "data-url" => [@url] do
        div class: ['post-image'] do
          renderImage @images.first
          div class: ["post-update"] do
            @updated.strftime("%v")
          end
        end
        div class: ['post-content'] do
          renderTitle if hasTitle
          renderContent if hasContent
          a href: [@url] do
            img src: ['/img/021.png'], class: "read" do
            end
          end
        end
      end

      HTMLEntities.new.decode(html)
    end

    def renderContent
      div class: ['summary'] do
         p @content.slice(0, 250) + "..."
      end
    end

    def renderTitle
      h1 do
        @title
      end
    end

    def renderImage(image)
      src = "/img/no-image.png"
      src = image.getSrc if image
      img src: [src], id: ['custom-img'] do
      end
    end

  end
end