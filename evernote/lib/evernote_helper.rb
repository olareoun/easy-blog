require_relative "evernote_config"
require_relative 'public_url'

class EvernoteHelper

	def initialize(publicUrl)
		@url = PublicUrl.new publicUrl
	end

	def getNotebook(sortedIds = nil)
    user_info = getUserInfo(@url.user_name, @url.host)
    note_store = getNotestore(user_info, @url.host)
    if sortedIds.nil?
	    getNotebookNotes(user_info, note_store, @url.notebook_name)
		else
	    getNotes(note_store, sortedIds)
		end
	end

	def getNote noteId
    user_info = getUserInfo(@url.user_name, @url.host)
    note_store = getNotestore(user_info, @url.host)
		note_store.getNote('', noteId, true, true, false, false)
	end

	def getNotebookName
		@url.notebook_name
	end

	def getNotebookOwner
		@url.user_name
	end

private

  def getNotebookNotes(user_info, note_store, notebook_name)
		notes_metadata = getNotesMetadata(user_info, note_store, notebook_name)
		ids = notes_metadata.notes.map(&:guid)
		getNotes(note_store, ids)
  end

  def getNotes(note_store, ids)
		ids.map do |noteId|
		 note_store.getNote('', noteId, true, true, false, false)
		end
  end

  def getUserInfo(user_name, host)
    userStoreUrl = host + "/edam/user"
    userStoreTransport = Thrift::HTTPClientTransport.new(userStoreUrl)
    userStoreProtocol = Thrift::BinaryProtocol.new(userStoreTransport)
    userStore = Evernote::EDAM::UserStore::UserStore::Client.new(userStoreProtocol)
    userStore.getPublicUserInfo(user_name)
  end

  def getNotestore(user_info, host)
  	sharedId = user_info.shardId
    noteStoreTransport = Thrift::HTTPClientTransport.new(host + "/shard/" + sharedId + "/notestore")
    noteStoreProtocol = Thrift::BinaryProtocol.new(noteStoreTransport)
    noteStore = Evernote::EDAM::NoteStore::NoteStore::Client.new(noteStoreProtocol)
    noteStore
  end

  def getNotesMetadata(user_info, note_store, notebook_name)
    public_notebook = note_store.getPublicNotebook(user_info.userId, notebook_name)
    filter = Evernote::EDAM::NoteStore::NoteFilter.new
    filter.notebookGuid = public_notebook.guid
    resultSpec = Evernote::EDAM::NoteStore::NotesMetadataResultSpec.new
    note_store.findNotesMetadata('', filter, 0, 25, resultSpec)
  end
end
