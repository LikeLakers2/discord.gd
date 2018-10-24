

var afk_channel_id
var afk_timeout
var application_id
var channels
var default_message_notifications
var embed_channel_id
var embed_enabled
var emojis
var explicit_content_filter
var features
var icon
var id
var joined_at
var large
var members
var member_count
var mfa_level
var name
var owner
var owner_id
var permissions
var presences
var region
var roles
var splash
var system_channel_id
var unavailable
var verification_level
var voice_states
var widget_channel_id
var widget_enabled

enum DEFAULT_MESSAGE_NOTIFICATION_LEVELS {
	ALL_MESSAGES
	ONLY_MENTIONS
}

enum EXPLICIT_CONTENT_FILTER_LEVELS {
	DISABLED
	MEMBERS_WITHOUT_ROLES
	ALL_MEMBERS
}

enum MFA_LEVEL {
	NONE
	ELEVATED
}

enum VERIFICATION_LEVEL {
	# Note: NO_VERIFICATION is normally titled NONE but I can't use NONE as MFA_LEVEL already is
	NO_VERIFICATION
	LOW = 1
	MEDIUM
	HIGH
	VERY_HIGH
}

class Ban:
	var reason
	var user

class Integration:
	var account
	var enabled
	var expire_behavior
	var expire_grace_period
	var id
	var name
	var role_id
	var synced_at
	var syncing
	var type
	var user
	
	class Account:
		var id
		var name

class Member:
	var deaf
	var joined_at
	var mute
	var nick
	var roles
	var user