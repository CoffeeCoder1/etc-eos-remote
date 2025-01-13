extends Node

@onready var osc_client_tcp: OSCClientTCP = $OSCClientTCP
@onready var osc_user: OSCUser = $OSCUser


func get_client() -> OSCClientTCP:
	return osc_client_tcp


func get_user() -> OSCUser:
	return osc_user
