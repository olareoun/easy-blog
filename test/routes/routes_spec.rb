require_relative '../../web/app'

require 'rack/test'
require 'rspec'

describe "Notes2Reveal Routes" do
  include Rack::Test::Methods

  before do
  	@app ||= Web.new!
  end

  def app
  	@app
  end

  describe "/arrange" do

    it "goes to / when no public url" do
      post "/arrange", "publicUrl" => ""
      last_response.body.include?('We need a public evernote notebook url to make your presentation.')
    end

    it "goes to / when bad formed public url" do
      post "/arrange", "publicUrl" => "wwww.notevernotedomain.com/pub/xaviuzz/tal"
      last_response.body.include?('We can not do a presentation with a non evernote public notebook url.')
    end

    it "goes to / when non existing notebook" do
      post "/arrange", "publicUrl" => "https://sandbox.evernote.com/pub/olareoun/non-existing"
      last_response.body.include?('Could not find that notebook. Be sure that it exists and it is public.')
    end


  end

  describe "/generate" do

    it "goes to / when no public url" do
      post "/generate", "publicUrl" => ""
      last_response.body.include?('We need a public evernote notebook url to make your presentation.')
    end

    it "goes to / when bad formed public url" do
      post "/generate", "publicUrl" => "wwww.notevernotedomain.com/pub/xaviuzz/tal"
      last_response.body.include?('We can not do a presentation with a non evernote public notebook url.')
    end

    it "goes to / when non existing notebook" do
      post "/generate", "publicUrl" => "https://sandbox.evernote.com/pub/olareoun/non-existing"
      last_response.body.include?('Could not find that notebook. Be sure that it exists and it is public.')
    end

  end

end