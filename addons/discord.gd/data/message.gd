

var activity
var application
var attachments
var author
var channel_id
var content
var edited_timestamp
var embeds
var guild_id
var id
var member
var mentions
var mention_everyone
var mention_roles
var pinned
var reactions
var timestamp
var type
var tts
var webhook_id

enum MESSAGE_TYPES {
	DEFAULT
	RECIPIENT_ADD
	RECIPIENT_REMOVE
	CALL
	CHANNEL_NAME_CHANGE
	CHANNEL_ICON_CHANGE
	CHANNEL_PINNED_MESSAGE
	GUILD_MEMBER_JOIN
}

class Attachment:
	var filename
	var height
	var id
	var proxy_url
	var size
	var url
	var width

class Reaction:
	var count
	var emoji
	var me