class_name PingLabel extends Label

## The time to wait between pings.
@export var ping_time: float = 1.0

var timer: Timer


func _init() -> void:
	timer = Timer.new()
	add_child(timer)


func _ready() -> void:
	if OSCGlobals.get_client().is_connected:
		_on_connected()
	else:
		_on_disconnected()
	
	OSCGlobals.connected.connect(_on_connected)
	OSCGlobals.disconnected.connect(_on_disconnected)
	OSCGlobals.get_client().message_recieved.connect(_on_message_recieved)
	
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = ping_time
	timer.start()


func _on_connected() -> void:
	show()


func _on_disconnected() -> void:
	hide()


func _on_message_recieved(address: String, args: Array) -> void:
	if address == "/eos/out/ping":
		if args.get(0) is int:
			text = "Ping {0}ms".format([Time.get_ticks_msec() - args.get(0)])


## Sends a ping to the server with the current engine timestamp to see how long it takes for it to
## respond and us to parse the message.
func _on_timer_timeout() -> void:
	OSCGlobals.get_client().send_message("/eos/ping", [Time.get_ticks_msec()])
