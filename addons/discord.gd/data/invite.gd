

var approximate_member_count
var approximate_presence_count
var channel
var code
var guild

# Metadata included with the invite objects from the Get Guild Invites API
var metadata

class Metadata:
	var created_at
	var inviter
	var max_age
	var max_uses
	var revoked
	var temporary
	var uses