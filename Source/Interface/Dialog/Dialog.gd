extends Control

var full_text = "I'm Plush. I need immediate help! Please find me!!!"
var full_text2 = "Hint: Left Click to Interact. Right Click to Walk.\nSelect inventory items using your left mouse button."
var typewriting_speed = 0.09
var timer = null
var current_text = ""
var current_label = null
var typed_length = 0
var is_typewriting = false

onready var label = $Container/RichTextLabel
onready var label2 = $Container/Tutorial

func _input(event):
	if event.is_action_pressed("leftclick"):
		if is_typewriting:
			finish_typewriting()
		elif $Container.get_child_count() == 3:
			if is_instance_valid($Container/Tutorial):
				$Container/Tutorial.queue_free()

func _ready():
	if is_instance_valid(label):
		label.bbcode_text = ""
	if is_instance_valid(label2):
		label2.bbcode_text = ""

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
	current_label.bbcode_text = "[center]"
	typed_length = 0
	is_typewriting = true
	timer.start()

func _on_Timer_timeout():
	if not is_instance_valid(current_label):
		timer.stop()
		return

	if typed_length < len(current_text):
		typed_length += 1
		current_label.bbcode_text = "[center]" + current_text.substr(0, typed_length)
	else:
		current_label.bbcode_text += "[/center]"
		timer.stop()
		is_typewriting = false
		if current_label == label:
			start_typewriting(full_text2, label2)

func finish_typewriting():
	if not is_instance_valid(current_label):
		return

	timer.stop()
	current_label.bbcode_text = "[center]" + current_text + "[/center]"
	is_typewriting = false
	if current_label == label:
		start_typewriting(full_text2, label2)

func update_text(new_text, target_label):
	if not is_instance_valid(target_label):
		return

	if is_typewriting:
		timer.stop()
		current_text = new_text
		current_label = target_label
		current_label.bbcode_text = "[center]"
		typed_length = 0
		timer.start()
	else:
		start_typewriting(new_text, target_label)


