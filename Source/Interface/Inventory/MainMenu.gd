extends Control
const GLOW_COLOR = Color(1, 1, 1, 0.8)  
const NORMAL_COLOR = Color(1, 1, 1, 1)  

onready var audio_stream_player = $AudioStreamPlayer
onready var volume_slider = $VBoxContainer2/HSlider
onready var volume_button = $VBoxContainer2/Save
onready var animation_player = $AnimationPlayer
onready var new_button = $VBoxContainer/NewButton
onready var load_button = $VBoxContainer/LoadButton
onready var Setting_button = $VBoxContainer/Settings
onready var quit_button = $VBoxContainer/QuitButton

func _ready():
	# Signals
	new_button.connect("mouse_entered", self, "_on_button_mouse_entered")
	new_button.connect("mouse_exited", self, "_on_button_mouse_exited")
	new_button.connect("pressed", self, "_on_NewButton_pressed")
	
	load_button.connect("mouse_entered", self, "_on_button_mouse_entered")
	load_button.connect("mouse_exited", self, "_on_button_mouse_exited")
	load_button.connect("pressed", self, "_on_LoadButton_pressed")
	
	quit_button.connect("mouse_entered", self, "_on_button_mouse_entered")
	quit_button.connect("mouse_exited", self, "_on_button_mouse_exited")
	quit_button.connect("pressed", self, "_on_QuitButton_pressed")
	
	Setting_button.connect("mouse_entered", self, "_on_button_mouse_entered")
	Setting_button.connect("mouse_exited", self, "_on_button_mouse_exited")
	Setting_button.connect("pressed", self, "_on_Settings_pressed")
	
	volume_button.connect("pressed", self, "_on_Button_pressed")

	volume_slider.connect("value_changed", self, "_on_volume_slider_value_changed")
	
	# Volume
	audio_stream_player.volume_db = SaveSettings.audio_volume_db

	# Volume Setting
	volume_slider.min_value = -80
	volume_slider.max_value = 0
	volume_slider.value = audio_stream_player.volume_db

func _input(event):
	# Exit game on Esc key press
	if event.is_action_pressed("ui_cancel"): 
		get_tree().quit()

func _on_QuitButton_pressed():
	# Quit the game
	get_tree().quit()

func _on_button_mouse_entered():
	self.modulate = GLOW_COLOR

func _on_button_mouse_exited():
	self.modulate = NORMAL_COLOR
	
func _on_NewButton_pressed():
	# Change to Level1 scene
	animation_player.connect("animation_finished", self, "_on_fade_out_finished")
	animation_player.play("fade_out")
	
func _on_LoadButton_pressed():
	pass 
	
func _on_Settings_pressed():
	$VBoxContainer2.visible = true

func _on_Button_pressed():
	$VBoxContainer2.visible = false

func _on_Option_pressed():
	$VBoxContainer.visible = true
	
func _on_volume_slider_value_changed(value):
	if audio_stream_player == null:
		return
	audio_stream_player.volume_db = value
	SaveSettings.audio_volume_db = value
	SaveSettings.save_settings()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_out":
		get_tree().change_scene("res://Source/Cutscene/Cutscene.tscn")
