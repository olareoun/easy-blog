require 'rspec'

require_relative '../../lib/public_url'

describe 'Public Url' do

	it 'has name, notebook and host when created with a correct evernote public notebook url' do
		publicUrl = PublicUrl.new('https://www.evernote.com/pub/olareoun/mipublicnotebook')
		publicUrl.user_name.should_not be_empty
		publicUrl.notebook_name.should_not be_empty
		publicUrl.host.should_not be_empty
	end

	it 'raises BadArgumentException when nil url' do
		expect{PublicUrl.new(nil)}.to raise_error(BadArgumentException)
	end
	
end