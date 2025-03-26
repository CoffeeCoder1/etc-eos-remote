extends PanelContainer

## How long to wait between each poll to the server. Low delays seem to cause the response time of
## the server to become very long.
@export var polling_delay: float = 0.2

const CHANNEL_FADER = preload("res://scenes/elements/channel_fader/channel_fader.tscn")

@onready var channel_container: HBoxContainer = %FaderContainer

## Incremented each process loop and used to space out polls.
var timer: float
## Regular expression used to match patch data addresses.
var patch_regex: RegEx

## The list of fader nodes by channel index string.
var faders: Dictionary[String, ChannelFader]


func _init() -> void:
	patch_regex = RegEx.new()


func _ready() -> void:
	OSCGlobals.connected.connect(_setup)
	OSCGlobals.get_client().message_recieved.connect(_on_message_recieved)
	
	patch_regex.compile("/eos/out/get/patch/(?'channel'\\d+)/(?'part'\\d+)/list/(?'list_index'\\d+)/(?'list_count'\\d+)")


func _process(delta: float) -> void:
	if visible and OSCGlobals.get_client().client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
		timer += delta
		if timer >= polling_delay:
			_poll()
			timer = 0


## Polls the board for patch info.
func _poll() -> void:
	var count = OSCGlobals.get_user().get_global_feedback("/eos/out/get/patch/count").get(0)
	if count:
		for i in count:
			OSCGlobals.get_client().send_message("/eos/get/patch", [i + 1])


## Checks to see if a message matches a channel's patch info and, if it does, updates the channel
## from the info in that message.
func _on_message_recieved(address: String, args: Array) -> void:
	var regex_match = patch_regex.search(address)
	if regex_match:
		# Only parse data for channel part 1
		if regex_match.get_string("part") == "1":
			var channel: String = regex_match.get_string("channel")
			var fader = faders.get(channel)
			if is_instance_valid(fader):
				fader.set_label(str(args.get(2)))
				fader.set_value(float(args.get(7)))
			elif fader == null:
				fader = CHANNEL_FADER.instantiate()
				channel_container.add_child(fader)
				fader.value_changed.connect(_send_channel_value.bind(int(channel)))
				faders.set(channel, fader)


## Sends a value to the given fader index. Intended to be called by the child faders.
func _send_channel_value(value: float, channel: int) -> void:
	OSCGlobals.get_client().send_message("/eos/chan/" + str(channel), [value])


## Sends initial setup messages to the server.
func _setup() -> void:
	OSCGlobals.get_client().send_message("/eos/get/patch/count", [])
