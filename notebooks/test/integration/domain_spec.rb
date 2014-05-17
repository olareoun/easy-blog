require 'rspec'
require 'evernote_oauth'

require_relative '../../lib/notebook'
require_relative '../../lib/notebooks_domain'

describe 'Notebooks Domain' do
	it 'obtains an existent public notebook from evernote' do
		notebook = Notebooks::NotebooksDomain.get('https://www.evernote.com/pub/wilthor/wilthorsnotebook')
		notebook.nil?.should be_false
		notebook.getName().should == 'wilthorsnotebook'
		notebook.getNotes().length.should == 3
	end
	it 'obtains an existent public notebook from sandbox' do
		notebook = Notebooks::NotebooksDomain.get('https://sandbox.evernote.com/pub/olareoun/mipublicnotebook')
		notebook.nil?.should be_false
		notebook.getName().should == 'mipublicnotebook'
		notebook.getNotes().length.should == 2
	end
	it 'raises a notebook not found exception when non existing notebook' do
		expect{Notebooks::NotebooksDomain.get('https://sandbox.evernote.com/pub/olareoun/non-existing')}.to raise_error(NotebookNotFoundException)
	end
end