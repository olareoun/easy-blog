require_relative '../notebooks/lib/notebooks_domain'

class Notebook2RevealDomain

  def get_blog(url, sortedIds = nil)
    notebook = Notebooks::NotebooksDomain.get(url, sortedIds)
    Blog::Posts.new notebook
  end

  def get_notebook(url, sortedIds = nil)
    Notebooks::NotebooksDomain.get(url, sortedIds)
  end

  def getNote(url, noteId)
      @note = Notebooks::NotebooksDomain.getNote(url, noteId)
      post = Blog::Post.new
      post.entitle @note.getTitle
      post.putContent @note.getContent
      post.putImages [@note.getMainImage] if @note.hasImages?
      post
  end

  def getBlogName url
    Notebooks::NotebooksDomain.getNotebookName url
  end

end