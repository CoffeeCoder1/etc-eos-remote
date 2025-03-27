@icon("res://addons/godOSC/images/OSCReceiver.svg")
class_name OSCClientTCP
extends Node
## Client for sending and recieiving Open Sound Control messages over TCP. Use one OSCClientTCP per
## server you want to connect to.

## How long to wait before attempting to reconnect to the server.
@export var reconnect_timeout: float = 5.0:
	set(new_reconnect_timeout):
		reconnect_timeout = _on_reconnect_timeout_change(new_reconnect_timeout)
## Regular expression that causes matched addresses to not be written to the [member _incoming_messages]
## dictionary.
@export var ignore_expression: String:
	set(new_ignore_expression):
		ignore_expression = _on_ignore_expression_change(new_ignore_expression)


## Emitted when a connection is made to a server and messages can be sent.
signal connected
## Emitted when the connection to the server is lost.
signal disconnected
## Emitted when a message has been recieved from the server.
signal message_recieved(address: String, args: Array)

## A dictionary containing all recieved messages.
var _incoming_messages := {}
## A mutex used to block access to the [member _incoming_messages] dictionary.
var _messages_mutex: Mutex

## General mutex used for signalling things to threads.
var _mutex: Mutex
## Tells threads to exit.
var _exit_threads: bool = false
## Used to store data that's waiting to be parsed.
var _incoming_packets: Array[PackedByteArray]
## Mutex used for the [member _incoming_packets] array
var _incoming_packets_mutex: Mutex
## The StreamPeer used to communicate with the server.
var client: StreamPeerTCP
## Thread used for parsing messages.
var parser_thread: Thread
## Used to attempt to reconnect after a delay.
var reconnect_timer: Timer
## Should the client attempt to reconnect to the server?
var reconnect_timer_enabled: bool = false
## Was the server connected the last time we checked? Used so the connected signal is only sent once.
var last_connected: bool
## Used to ignore certain addresses when writing to the [member incoming_messages] dictionary.
var ignore_regex: RegEx
## The IP Address of the server to connect to.
var _ip_address: String
## The port to connect to.
var _port: int


func _init() -> void:
	client = StreamPeerTCP.new()
	
	_mutex = Mutex.new()
	_messages_mutex = Mutex.new()
	_incoming_packets_mutex = Mutex.new()
	parser_thread = Thread.new()
	
	reconnect_timer = Timer.new()
	add_child(reconnect_timer)
	reconnect_timer.timeout.connect(_reconnect_socket)
	
	ignore_regex = RegEx.new()


func _ready() -> void:
	# Initialize things
	_on_reconnect_timeout_change(reconnect_timeout)
	
	# Start the parser thread
	parser_thread.start(_parse)


func _process(_delta):
	client.poll()
	
	if client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		if client.get_available_bytes() > 0:
			var data = client.get_data(client.get_available_bytes())
			# Parse data if it was recieved correctly
			if data[0] == Error.OK:
				var packets: Array[PackedByteArray] = _parse_packets(data[1])
				_incoming_packets_mutex.lock()
				_incoming_packets.append_array(packets)
				_incoming_packets_mutex.unlock()
	
	# Start the reconnection timer if disconnected from the server
	if (client.get_status() == StreamPeerTCP.STATUS_NONE || client.get_status() == StreamPeerTCP.STATUS_ERROR):
		if reconnect_timer.is_stopped() and reconnect_timer_enabled:
			reconnect_timer.start()
	else:
		reconnect_timer.stop()
	
	# Check if a connection has just been made or lost.
	var current_connected = client.get_status() == StreamPeerTCP.STATUS_CONNECTED
	if (current_connected != last_connected):
		# If it has been, emit the corresponding signal.
		if current_connected:
			print("Connected to server")
			connected.emit()
		else:
			print("Disconnected from server!")
			disconnected.emit()
		last_connected = current_connected


func _exit_tree():
	# Tell threads to exit
	_mutex.lock()
	_exit_threads = true
	_mutex.unlock()
	
	parser_thread.wait_to_finish()


## Connect to an OSC server. Can only connect to one OSC server at a time.
func connect_socket(new_ip = "127.0.0.1", new_port = 4646) -> void:
	_ip_address = new_ip
	_port = new_port
	_connect_socket(new_ip, new_port)


func _connect_socket(new_ip = "127.0.0.1", new_port = 4646) -> void:
	close_socket()
	client.connect_to_host(new_ip, new_port)
	reconnect_timer_enabled = true


## Disconnects from a server.
func close_socket() -> void:
	reconnect_timer_enabled = false
	reconnect_timer.stop()
	client.disconnect_from_host()


## Attempts to reconnect to the configured IP and port.
func _reconnect_socket() -> void:
	if reconnect_timer_enabled:
		print("Attempting reconnect!")
		connect_socket(_ip_address, _port)


## Parses incoming OSC packets. This is intended to be run in a thread internal to OSCServerTCP.
func _parse() -> void:
	while true:
		_mutex.lock()
		var should_exit = _exit_threads
		_mutex.unlock()
		
		if should_exit:
			break
		
		while !_incoming_packets.is_empty():
			_incoming_packets_mutex.lock()
			var packet = _incoming_packets.pop_front()
			_incoming_packets_mutex.unlock()
			call_thread_safe("_parse_message", packet)


## Process a message to be sent. Returns a PackedByteArray to be sent to the server.
func _prepare_message(osc_address : String, args : Array) -> PackedByteArray:
	var packet = PackedByteArray()
	
	packet.append(0xC0)
	
	packet.append_array(osc_address.to_ascii_buffer())
	
	packet.append(0)
	while fmod(packet.size(), 4):
		packet.append(0)
	
	packet.append(0x2C)
	for arg in args:
		match typeof(arg):
			TYPE_INT:
				packet.append(0x69)
			TYPE_FLOAT:
				packet.append(0x66)
			TYPE_STRING:
				packet.append(0x73)
			TYPE_PACKED_BYTE_ARRAY:
				packet.append(0x62)
	
	packet.append(0x00)
	while fmod(packet.size(), 4):
		packet.append(0x00)
	
	for arg in args:
		var pack = PackedByteArray()
		match typeof(arg):
			TYPE_INT:
				pack.append_array([0, 0, 0, 0])
				pack.encode_s32(0, arg)
				pack.reverse()
			TYPE_FLOAT:
				pack.append_array([0, 0, 0, 0])
				pack.encode_float(0, arg)
				pack.reverse()
			TYPE_STRING:
				pack.append_array(arg.to_ascii_buffer())
				pack.append(0)
				while fmod(pack.size(), 4):
					pack.append(0)
			TYPE_PACKED_BYTE_ARRAY:
				pack.append_array(arg)
				while fmod(pack.size(), 4):
					pack.append(0)
		packet.append_array(pack)
	
	packet.append(0xC0)
	
	return packet


## Send an OSC message over TCP.
func send_message(osc_address : String, args : Array) -> void:
	var packet = _prepare_message(osc_address, args)
	client.put_data(packet)


## Gets the [member _incoming_messages] dictionary.
func get_incoming_messages() -> Dictionary:
	_messages_mutex.lock()
	var messages = _incoming_messages
	_messages_mutex.unlock()
	return messages


## Parses packets out of SLIP encoded data.
func _parse_packets(data: PackedByteArray) -> Array[PackedByteArray]:
	var packets: Array[PackedByteArray] = []
	
	# Find packets and slice them out
	var start_index: int = 0
	var end_index: int = 0
	while end_index < data.size():
		start_index = data.find(0xC0, end_index)
		end_index = data.find(0xC0, start_index + 1) + 1
		if (end_index == -1):
			break
		packets.append(data.slice(start_index + 1, end_index - 1))
	
	return packets


## Parses the data out of an OSC packet.
func _parse_message(packet: PackedByteArray):
	var comma_index = packet.find(44)
	var address: String = packet.slice(0, comma_index).get_string_from_ascii()
	var args := packet.slice(comma_index, packet.size())
	var tags = args.get_string_from_ascii()
	var vals = []

	args = args.slice(ceili((tags.length() + 1) / 4.0) * 4, args.size())
	
	for tag in tags.to_ascii_buffer():
		match tag:
			44: #,: comma
				pass
			105: #i: int32
				var val = args.slice(0, 4)
				val.reverse()
				vals.append(val.decode_s32(0))
				args = args.slice(4, args.size())
			102: #f: float32
				var val = args.slice(0, 4)
				val.reverse()
				vals.append(val.decode_float(0))
				args = args.slice(4, args.size())
			115: #s: string
				var val = args.get_string_from_ascii()
				vals.append(val)
				args = args.slice(ceili((val.length() + 1) / 4.0) * 4, args.size())
			98:  #b: blob
				vals.append(args)
	
	message_recieved.emit(address, vals)
	
	if not ignore_regex.search(address):
		_messages_mutex.lock()
		_incoming_messages[address] = vals
		_messages_mutex.unlock()


## Sets the reconnect timeout.
func _on_reconnect_timeout_change(timeout: float) -> float:
	if is_instance_valid(reconnect_timer):
			reconnect_timer.wait_time = timeout
	
	return timeout


## Sets the ignore regex.
func _on_ignore_expression_change(regex: String) -> String:
	if is_instance_valid(reconnect_timer):
			ignore_regex.compile(regex)
	
	return regex
