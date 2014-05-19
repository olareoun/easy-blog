require 'crafty'
require 'htmlentities'

module Blog
  class Posts

    include Crafty::HTML::All

    def initialize notebook
      notes = notebook.notes
      sorted = notes.sort_by { |a| - a.updated }
      @url = "/#{notebook.owner}/#{notebook.name}"
      @posts = sorted.map do |note|
        post = Blog::PostThumbnail.new
        post.entitle note.getTitle
        post.putContent note.getContent
        post.putImages [note.getMainImage] if note.hasImages?
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

    def url
      @url
    end

  end
end