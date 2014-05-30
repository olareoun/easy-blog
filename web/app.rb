require 'sinatra/base'
require 'haml'
require 'sass'
require 'json'

require_relative 'notebook_2_reveal_domain'
require_relative 'lib/notifier'
require_relative 'lib/posts'
require_relative 'lib/post'
require_relative 'lib/post_thumbnail'
require_relative 'lib/blogs_cache'
require_relative '../evernote/lib/bad_argument_exception'
require_relative '../evernote/lib/bad_public_notebook_url_exception'

class Web < Sinatra::Base
  set :public_folder, './web/public'
  set :static, true

  domain = Notebook2RevealDomain.new

  blogs_cache = BlogsCache.new

  get '/index.html' do
    haml :index , :layout => :blog_layout
  end

  get '/' do
    @blogName = "Ever"
    @url = "/"
    @message = Notifier.message_for params['alert_signal']
    haml :index , :layout => :blog_layout
  end

  post '/blogify' do
    begin
      @publicUrl = params['publicUrl']
      @blogName = domain.getBlogName(@publicUrl)
      @posts = domain.get_blog(@publicUrl)
      @url = @posts.url
      haml :blogify , :layout => :blog_layout
    rescue BadArgumentException => e
      showError e.exception_key
    rescue BadPublicNotebookUrlException => e
      showError 'no.evernote.url'
    rescue NotebookNotFoundException => e
      showError 'non.existing.notebook'
    end
  end

  get '/:owner/:blogName' do
    begin
      @blogName = params['blogName']
      @publicUrl = public_url
      haml :blog , :layout => :blog_layout
    rescue BadArgumentException => e
      showError e.exception_key
    rescue BadPublicNotebookUrlException => e
      showError 'no.evernote.url'
    rescue NotebookNotFoundException => e
      showError 'non.existing.notebook'
    end
  end

  get '/:owner/:blogName/json', :provides => :json do
    begin
      @blogName = params['blogName']
      @publicUrl = public_url
      posts_cache = blogs_cache.get public_url
      if posts_cache.nil?
        notebook = domain.get_notebook(@publicUrl)
        posts_cache = notebook.getNotes.map do |post|
          {
            :title => post.getTitle,
            :content => post.getContent,
            :updated => Time.at(post.updated / 1000).strftime("%v"),
            :image => post.getMainImage.getSrc,
            :url => "/#{notebook.owner}/#{notebook.name}/#{post.getId}",
            :id => post.getId
          }
        end
        blogs_cache.add(public_url, posts_cache)
      end
      posts_cache.to_json
    rescue BadArgumentException => e
      showError e.exception_key
    rescue BadPublicNotebookUrlException => e
      showError 'no.evernote.url'
    rescue NotebookNotFoundException => e
      showError 'non.existing.notebook'
    end
  end

  get '/:owner/:blogName/:noteId' do
    begin
      @publicUrl = public_url
      noteId = note_id
      @post = domain.getNote @publicUrl, noteId
      haml :post , :layout => :post_layout
    rescue BadArgumentException => e
      showError e.exception_key
    rescue BadPublicNotebookUrlException => e
      showError 'no.evernote.url'
    rescue NotebookNotFoundException => e
      showError 'non.existing.notebook'
    end
  end

  def showError(messageKey)
    @blogName = "Ever"
    @message = Notifier.message_for messageKey
    haml :index , :layout => :blog_layout
  end

  def note_id
    params['noteId']
  end

  def public_url
    "http://www.evernote.com/pub/#{params['owner']}/#{params['blogName']}"
  end

end
