@icon("res://addons/godOSC/images/OSCReciever.svg")
class_name OSCClientTCP
extends Node
## Client for sending and recieiving Open Sound Control messages over TCP. Use one OSCClientTCP per server you want to connect to.

## The IP Address of the server to connect to.
@export var ip_address: String = "127.0.0.1":
	set(new_ip_address):
		if ip_address != new_ip_address:
			connect_socket(new_ip_address, port)
		ip_address = new_ip_address
## The port to connect to.
@export var port: int = 4646:
	set(new_port):
		if port != new_port:
			connect_socket(ip_address, new_port)
		port = new_port
var client: StreamPeerTCP = StreamPeerTCP.new()
## How long to wait before attempting to reconnect to the server.
@export var reconnect_timeout: float = 5.0:
	set(new_reconnect_timeout):
		if reconnect_timer:
			reconnect_timer.wait_time = reconnect_timeout
		
		reconnect_timeout = new_reconnect_timeout

## A dictionary containing all recieved messages.
var incoming_messages := {}

# Used to attempt to reconnect after a delay.
var reconnect_timer: Timer


func _ready() -> void:
	connect_socket(ip_address, port)
	
	reconnect_timer = Timer.new()
	reconnect_timer.wait_time = reconnect_timeout
	add_child(reconnect_timer)
	reconnect_timer.timeout.connect(_reconnect_socket)


func _process(_delta):
	client.poll()
	_parse()
	
	if (client.get_status() == StreamPeerTCP.STATUS_NONE || client.get_status() == StreamPeerTCP.STATUS_ERROR):
		if reconnect_timer.is_stopped():
			reconnect_timer.start()
	else:
		reconnect_timer.stop()


## Connect to an OSC server. Can only connect to one OSC server at a time.
func connect_socket(new_ip = "127.0.0.1", new_port = 4646) -> void:
	close_socket()
	client.connect_to_host(new_ip, new_port)


## Disconnects from a server.
func close_socket() -> void:
	client.disconnect_from_host()


## Attempts to reconnect to the configured IP and port.
func _reconnect_socket() -> void:
	print("Attempting reconnect!")
	connect_socket(ip_address, port)


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
func send_message(osc_address : String, args : Array):
	var packet = _prepare_message(osc_address, args)
	client.put_data(packet)


## Parses an OSC packet. This is not intended to be called directly outside of the OSCServerTCP
func _parse():
	if client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		if client.get_available_bytes() > 0:
			var data = client.get_data(client.get_available_bytes())
			# Parse data if it was recieved correctly
			if data[0] == Error.OK:
				var packets: Array[PackedByteArray] = _parse_packets(data[1])
				for packet in packets:
					_parse_message(packet)


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
	var address = packet.slice(0, comma_index).get_string_from_ascii()
	var args = packet.slice(comma_index, packet.size())
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
	
	incoming_messages[address] = vals
