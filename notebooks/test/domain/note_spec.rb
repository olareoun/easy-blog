require 'rspec'
require 'evernote_oauth'
require_relative '../../lib/note'

describe 'Note' do
	it 'when created with not null Evernote Note should have same title and content' do
		evnote = Evernote::EDAM::Type::Note.new
		evnote.title = 'title'
		evnote.content = 'content'
		evnote.guid = 'id1'
		note = Notebooks::Note.new(evnote)
		note.getTitle().should == 'title'
		note.getContent().should == 'content'
		note.getId().should == 'id1'
	end

	it 'when created with nil parameter' do
		note = Notebooks::Note.new
		note.entitle('title')
		note.putContent('content')
		note.getTitle().should == 'title'
		note.getContent().should == 'content'
	end

	it 'does not have content when just evernote note tag' do
		evnote = Evernote::EDAM::Type::Note.new
		evnote.title = 'title'
		evnote.content = '<?xml version="1.0" encoding="UTF-8"?><!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd"><en-note><div><br clear="none"/></div></en-note>'
		note = Notebooks::Note.new(evnote)
		note.getTitle().should == 'title'
		note.getContent().should == '<div><br clear="none"/></div>'
	end
end