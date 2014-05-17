require_relative '../../evernote/lib/evernote_helper'
require_relative 'notebook'
require_relative 'note'
require_relative 'notebook_not_found_exception'

module Notebooks
	class NotebooksDomain
		def self.getNotebookData publicUrl
			PublicUrl.new publicUrl
		end

		def self.get(publicUrl, sortedIds = nil)
			evernoteHelper = EvernoteHelper.new publicUrl
			evernoteNotes = evernoteHelper.getNotebook(sortedIds)
			notes = evernoteNotes.map {|evernoteNote| Notebooks::Note.new evernoteNote}
			Notebook.new evernoteHelper.getNotebookOwner, evernoteHelper.getNotebookName, notes
		rescue Evernote::EDAM::Error::EDAMNotFoundException
			raise NotebookNotFoundException
		end

		def self.getNote(publicUrl, noteId)
			evernoteHelper = EvernoteHelper.new publicUrl
			evernoteNote = evernoteHelper.getNote(noteId)
			Notebooks::Note.new evernoteNote
		rescue Evernote::EDAM::Error::EDAMNotFoundException
			raise NotebookNotFoundException
		end

		def self.getNotebookName url
			notebook_url = PublicUrl.new url
			notebook_url.notebook_name
		end
	end
end
