require 'evernote_oauth'
require_relative 'attachment'

module Notebooks

	EN_XML_HEADER = '<?xml version="1.0" encoding="UTF-8"?>'
	EN_NOTE_HEADER = '<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">'
	EN_NOTE_EMPTY_CONTENT = '<en-note><div><br clear="none"/></div></en-note>'


	class Note

		def initialize(note = nil)
			@note = Evernote::EDAM::Type::Note.new
			@note = note if note.instance_of? Evernote::EDAM::Type::Note
		end

		def entitle(title)
			@note.title = title
		end

		def putContent(content)
			@note.content = content
		end

		def getId()
			@note.guid
		end

		def getTitle
			@note.title
		end

		def getContent
			return '' if @note.content.nil?
			content = transformEvernoteTodo(@note.content)
			content = stripEvernoteMarkup(content)
			content
		end

		def transformEvernoteTodo(content)
			content = content.gsub('</en-todo>', '')
			content = content.gsub('<en-todo', '<input type="checkbox" class="regular-checkbox big-checkbox"')
			content
		end

		def stripEvernoteMarkup(content)
			content = content.gsub(EN_XML_HEADER, '')
			content = content.gsub(EN_NOTE_HEADER, '')
			content = content.gsub(/\n/, '')
 			content = content.gsub(%r{</?en-[^>]+?>}, '')
			content
		end

		def hasImages?
			!getImages.nil?
		end

		def hasAudio?
			!getAudio.nil?
		end

		def getImages
			getAttachment 'image'
		end

		def getMainImage
			getImages.first if hasImages?
		end

		def getAudio
			getAttachment 'audio'
		end

		def notValid?
			not_valid(@note.title) && not_valid(@note.content)
		end

		def updated
			@note.updated
		end

		private

			def getAttachment(type)
				return [] if noResources
				resources = extractResources type
				extractAttachments resources
			end

			def extractAttachments(resources)
				resources.map{ |resource| Attachment.new(resource.attributes.fileName, resource.mime, resource.data.body, resource.guid) }
			end

			def extractResources(type)
				@note.resources.find_all{ |item| item.mime.match(type) }
			end

			def noResources
				@note.resources.nil?
			end

			def not_valid(str)
				str.nil? || str.empty?
			end

	end
end