class_name SettingsSaver extends Node

@export var settings: Settings = Settings.new()

const FILE_PATH := "user://settings.tres"


func _ready() -> void:
	load_settings()
	settings.settings_updated.connect(save_settings)


func save_settings() -> void:
	ResourceSaver.save(settings, FILE_PATH)
	
	print("Settings saved")


func load_settings() -> void:
	if FileAccess.file_exists(FILE_PATH):
		settings = ResourceLoader.load(FILE_PATH)
