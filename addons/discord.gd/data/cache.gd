extends Node

#### Configuration ####
# [Todo] The API instance that will be used if data is missing
#var 

export (bool) var cache_messages = false

#### Cache arrays ####
var guild_channels = []
var emojis = []
var guilds = []
var messages = []
var roles = []

func _ready():
	pass