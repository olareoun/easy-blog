require 'crafty'
require 'htmlentities'

module Blog
  class Posts

    include Crafty::HTML::All

    def initialize notebook
      @posts = notebook.notes.map do |note|
        post = Blog::PostThumbnail.new
        post.entitle note.getTitle
        post.putContent note.getContent
        post.putImages [note.getMainImage]
        post.url = "/#{notebook.owner}/#{notebook.name}/#{note.getId}"
        post
      end
    end

    def to_html
      html = section class: ['articles'] do
        @posts.inject(""){ |concatenation, post_thumb| concatenation + post_thumb.to_html }
      end
      HTMLEntities.new.decode(html)
    end

  end
end