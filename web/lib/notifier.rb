class Notifier

	Messages = {
		'empty.url' => 'We need a public evernote notebook url to make your presentation.',
		'no.evernote.url' => 'We can not do a presentation with a non evernote public notebook url.',
		'non.existing.notebook' => 'Could not find that notebook. Be sure that it exists and it is public.',
	}

	def self.message_for(alert_signal)
	    message = Messages[alert_signal]
		message = '' if message.nil?
		message
	end
end