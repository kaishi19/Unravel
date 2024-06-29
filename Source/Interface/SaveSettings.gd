extends Node2D

var audio_volume_db: float = -15

func _ready():
	load_settings()

func save_settings():
	var file = File.new()
	file.open("user://settings.cfg", File.WRITE)
	file.store_line(to_json({"audio_volume_db": audio_volume_db}))
	file.close()

func load_settings():
	var file = File.new()
	if file.file_exists("user://settings.cfg"):
		file.open("user://settings.cfg", File.READ)
		var data = parse_json(file.get_line())
		audio_volume_db = data.get("audio_volume_db", 0)
		file.close()

func _change_scene(scene_path):
	var result = get_tree().change_scene(scene_path)
