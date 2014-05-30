class BlogsCache

  def initialize
    @blogs = {}
  end

  def get url
    @blogs[url]
  end

  def add url, posts
    @blogs.merge!({ url => posts })
  end

end