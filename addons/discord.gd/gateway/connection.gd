extends Node

# A gateway connection. This will be instanced once for each shard, and handles
# the communication between the client and the gateway. It also handles
# heartbeats and resuming for a single shard.


#### Configuration ####


#### Websocket client ####
# @return [WebSocketClient] Websocket client.
var client = WebSocketClient.new()
# @return [Timer] Timer for polling the connection
var polling_timer = Timer.new()


#### Opcodes & scripts for packets ####
const PAYLOADS = {
	# Sorted by OPCODE number
	0: preload('opcode_dispatch.gd'),
	1: preload('opcode_heartbeat.gd'),
	2: preload('opcode_identify.gd'),
	3: null, # STATUS_UPDATE
	4: null, # VOICE_STATE_UPDATE
	6: null, # RESUME
	7: preload('opcode_reconnect.gd'),
	8: null, # REQUEST_GUILD_MEMBERS
	9: preload('opcode_invalid_session.gd'),
	10: preload('opcode_hello.gd'),
	11: preload('opcode_heartbeat_ack.gd'),
	
	UNKNOWN = preload('opcode_unknown.gd')
}


#### Signals ####
# Emitted when a dispatch opcode is received.
# @param type [String] The event name for this payload
# @param data [Variant] The data for this payload (what's within the `d` key)
signal dispatch(type, data)

# Emitted when a heartbeat is sent on this connection
signal heartbeat

# Emitted when a heartbeat_ack is received on this connection
signal heartbeat_ack

# Emitted when an unknown opcode is received. If this is ever emitted, that 
# typically means that discord.gd needs an update.
# @param payload [Variant] The entire payload.
signal unknown_opcode(payload)


#### Heartbeating ####
# @return [Timer] Heartbeat timer
var heartbeat_timer = Timer.new()
# @return [bool] If we've received a heartbeat ACK since our last heartbeat
var received_ack_since_last_heartbeat = false


#### Other state information ####
# @return [int] Last sequence number received
var last_seq = null

# @return [String] The session ID for this connection
# @return [null] if there is no session id
var session_id = null

#### Debugging ####
# @return [Array<String>] Debugging, the names of the servers connected to
var _trace = []



func _ready():
	add_child(heartbeat_timer)
	heartbeat_timer.connect("timeout", self, "_on_heartbeat_timer_tick")
	add_child(polling_timer)
	polling_timer.connect("timeout", self, "_on_polling_timer_tick")
	
	client.connect("connection_closed", self, "_on_connection_closed")
	client.connect("connection_error", self, "_on_connection_error")
	client.connect("connection_established", self, "_on_connection_established")
	client.connect("data_received", self, "_on_data_received")
	#client.verify_ssl = false
	

func gateway_connect():
	print('(Re)Connecting to Discord...')
	polling_timer.start(.1)
	# TODO: Get Gateway endpoint from API
	client.connect_to_url('wss://gateway.discord.gg/?v=6&encoding=json')

func gateway_reconnect(should_resume = false):
	# TODO: Resume on reconnect logic here
	gateway_disconnect(should_resume)
	# Wait until the connection is actually closed before reconnecting
	yield(get_tree(), "idle_frame")
	gateway_connect()

func gateway_disconnect(will_resume = false):
	#print('DISCONNECTING')
	# Unfortunately Godot doesn't seem to send a close frame currently.
	# So we can't disconnect gracefully, and Discord will see the client
	# time out on their end after a while. Sorry!
	client.disconnect_from_host()
	
	# Cleanup the connection
	if !will_resume:
		# It might be better to queue_free() here...
		# We aren't cleaning up _trace here because debugging.
		last_seq = null
		session_id = null

func connection():
	return client.get_peer(1)

func bot():
	return get_parent()

func _on_connection_closed():
	print('CONNECTION_CLOSED')
	# Godot doesn't let us read the close event codes currently. Sorry!
	polling_timer.stop()
	heartbeat_timer.stop()
func _on_connection_error():
	print('CONNECTION_ERROR')
	polling_timer.stop()
	heartbeat_timer.stop()
	# TODO: Reconnect
func _on_connection_established(protocol):
	print('CONNECTION ESTABLISHED: ', protocol)
func _on_data_received():
	var pc = connection().get_available_packet_count()
	for __ in range(pc):
		var data = get_payload()
		print(" -> ", data)
		
		var payload = parse_json(data)
		var payload_op = int(payload.op)
		
		if PAYLOADS.has(payload_op):
			# Don't do anything if we haven't added a script for that number
			if PAYLOADS[payload_op]:
				PAYLOADS[payload_op].new().receive(self, payload)
		else:
			PAYLOADS.UNKNOWN.new().receive(self, payload)

func get_payload():
	return connection().get_packet().get_string_from_utf8()

func put_payload(payload_dict):
	var j = to_json(payload_dict)
	print(" <- ", j)
	return connection().put_packet(j.to_utf8())

func _on_polling_timer_tick():
	# Tick... Tick... Tick...
	if client.get_connection_status() != NetworkedMultiplayerPeer.CONNECTION_DISCONNECTED:
		client.poll()

func _on_heartbeat_timer_tick():
	PAYLOADS[1].new().send(self)

func sleep(length = 0.1):
	var t = Timer.new()
	t.one_shot = true
	t.wait_time = length
	add_child(t)
	# Wait for timer to timeout, then remove it from the scene tree
	t.start()
	yield(t, 'timeout')
	t.queue_free()