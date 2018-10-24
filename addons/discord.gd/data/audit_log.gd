

var audit_log_entries
var users
var webhooks

class Entry:
	var action_type
	var changes
	var id
	var options
	var reason
	var target_id
	var user_id
	
	enum AUDIT_LOG_EVENTS {
		GUILD_UPDATE = 1
		
		CHANNEL_CREATE = 10
		CHANNEL_UPDATE
		CHANNEL_DELETE
		CHANNEL_OVERWRITE_CREATE
		CHANNEL_OVERWRITE_UPDATE
		CHANNEL_OVERWRITE_DELETE
		
		MEMBER_KICK = 20
		MEMBER_PRUNE
		MEMBER_BAN_ADD
		MEMBER_BAN_REMOVE
		MEMBER_UPDATE
		MEMBER_ROLE_UPDATE
		
		ROLE_CREATE = 30
		ROLE_UPDATE
		ROLE_DELETE
		
		INVITE_CREATE = 40
		INVITE_UPDATE
		INVITE_DELETE
		
		WEBHOOK_CREATE = 50
		WEBHOOK_UPDATE
		WEBHOOK_DELETE
		
		EMOJI_CREATE = 60
		EMOJI_UPDATE
		EMOJI_DELETE
		
		MESSAGE_DELETE = 72
	}
	
	class Change:
		# TODO
		var key
		var new_value
		var old_value
	
	class Options:
		# CHANNEL_OVERWRITE_*
		var id
		var role_name
		var type
		
		# MEMBER_PRUNE
		var delete_member_days
		var members_removed
		
		# MESSAGE_DELETE
		var channel_id
		var count