extends Control

var full_text = "Dear diary,\n\n Today mommy, daddy, and me went to the a big aquarium. There were dolphins and sharks and pretty fishes. Everything was blue. Daddy bought me a teddy bear too. Then we went to eat. Mommy got fish. Daddy got lobster. But I didn't eat them because it feels like eating aquarium friends. I ate chicken. Then we had ice cream. I had fun today."
var typewriting_speed = 0.05
var timer = null
var current_text = ""
var current_label = null

onready var animation_player = $AnimationPlayer
onready var label = $RichTextLabel

func _input(event):
	if Input.is_action_just_pressed("leftclick"):
		animation_player.play("fade_out")

func _ready():
	$AudioStreamPlayer.play()
	$AudioStreamPlayer2.play()
	animation_player.connect("animation_finished", self, "_on_fade_out_finished")
	
	if is_instance_valid(label):
		label.bbcode_text = ""

	timer = Timer.new()
	timer.wait_time = typewriting_speed
	timer.connect("timeout", self, "_on_Timer_timeout")
	add_child(timer)
	start_typewriting(full_text, label)

func start_typewriting(text, target_label):
	if not is_instance_valid(target_label):
		return

	current_text = text
	current_label = target_label
	current_label.bbcode_text = ""
	timer.start()

func _on_Timer_timeout():
	if not is_instance_valid(current_label):
		timer.stop()
		return

	if len(current_label.bbcode_text) < len(current_text):
		current_label.bbcode_text += current_text[len(current_label.bbcode_text)]
	else:
		timer.stop()

func update_text(new_text, target_label):
	if not is_instance_valid(target_label):
		return

	if timer.is_stopped():
		start_typewriting(new_text, target_label)
	else:
		timer.stop()
		current_text = new_text
		current_label = target_label
		current_label.bbcode_text

func _on_fade_out_finished(anim_name):
	if anim_name == "fade_out":
		SaveSettings._change_scene("res://Source/Temp/End.tscn")

