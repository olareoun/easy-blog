require 'sinatra/base'

require_relative 'notebook_2_reveal_domain'
require_relative 'lib/notifier'
require_relative 'lib/posts'
require_relative 'lib/post'
require_relative 'lib/post_thumbnail'
require_relative '../evernote/lib/bad_argument_exception'
require_relative '../evernote/lib/bad_public_notebook_url_exception'

class Web < Sinatra::Base
  set :public_folder, './web/public'
  set :static, true

  domain = Notebook2RevealDomain.new

  not_found do
    erb :'404', :layout => :blog_layout
  end

  error do
    @error = request.env['sinatra_error'].name
    erb :'500', :layout => :blog_layout
  end

  get '/index.html' do
    erb :index , :layout => :blog_layout
  end

  get '/' do
    @blogName = "Ever"
    @url = "/"
    @message = Notifier.message_for params['alert_signal']
    erb :index , :layout => :blog_layout
  end

  post '/blogify' do
    begin
      @publicUrl = params['publicUrl']
      @blogName = domain.getBlogName(@publicUrl)
      @posts = domain.getNotes(@publicUrl)
      @url = @posts.url
      erb :blogify , :layout => :blog_layout
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
      @posts = domain.getNotes(@publicUrl)
      @url = @posts.url
      erb :blogify , :layout => :blog_layout
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
      erb :post , :layout => :post_layout
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
    erb :index , :layout => :blog_layout
  end

  def note_id
    params['noteId']
  end

  def public_url
    "http://www.evernote.com/pub/#{params['owner']}/#{params['blogName']}"
  end

end
