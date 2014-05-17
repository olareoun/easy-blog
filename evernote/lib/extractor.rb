require_relative 'bad_public_notebook_url_exception'

class Extractor

	DOMAIN_PATTERN = /www\.evernote\.com|sandbox\.evernote\.com/ 
	PUBLIC_NOTEBOOK_PATH_PATTERN = /\/pub\/(\w+)\/([a-zA-Z0-9_\-]+)\/?\Z/

	def self.extractUsername(url)
		match(url)[0]
	end

	def self.extractNotebookName(url)
		match(url)[1]
	end

	def self.extractHost(url)
		uri = URI(url)
		check(uri)
		uri.scheme + '://' + uri.host
	end

	def self.match(url)
		uri = URI(url)
		check(uri)
		scaned = uri.path.scan(PUBLIC_NOTEBOOK_PATH_PATTERN)[0]
	end

	def self.check(uri)
		raise BadPublicNotebookUrlException unless (uri.host =~ DOMAIN_PATTERN) && (uri.path =~ PUBLIC_NOTEBOOK_PATH_PATTERN)
	end

end