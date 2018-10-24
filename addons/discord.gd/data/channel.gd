


#### General ####
var guild_id
var id
var name
var parent_id
var position
var permission_overwrites
var type

#### Text only ####
var last_message_id
var last_pin_timestamp
var nsfw
var topic

#### Voice only ####
var bitrate
var rate_limit_per_user
var user_limit

#### Group DM only ####
var application_id
var icon
var owner_id
var recipients

#### Data ####
enum CHANNEL_TYPES {
	GUILD_TEXT
	DM
	GUILD_VOICE
	GROUP_DM
	GUILD_CATEGORY
}

class Overwrite:
	var allow
	var deny
	var id
	var type

