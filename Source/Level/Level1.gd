extends Node2D

# Inventory Slots
onready var first_slot = $CanvasLayer/Inventory/GridContainer/Slot1
onready var second_slot = $CanvasLayer/Inventory/GridContainer/Slot2
onready var third_slot = $CanvasLayer/Inventory/GridContainer/Slot3
onready var fourth_slot = $CanvasLayer/Inventory/GridContainer/Slot4
onready var fifth_slot = $CanvasLayer/Inventory/GridContainer/Slot5
onready var sixth_slot = $CanvasLayer/Inventory/GridContainer/Slot6

onready var dialog_slot = $CanvasLayer/Dialog/Container/RichTextLabel
onready var dialog = $CanvasLayer/Dialog

var item = null

# Item Conditions
var levelTriggered = false
var levelFinished = false

var rakeFinished = false
var rakeTriggered = false

var snakeFinished = false
var snakeTriggered = false

var plushFinished = false
var plushTriggered = false
var plushPicked = false

var mailFinished = false
var mailTriggered = false

var ladderFinished = false
var ladderTriggered = false

var potFinished = false
var potTriggered = false

# Item preload
var rake = preload("res://Source/Interface/Inventory Item/Rake.tscn")
var plank = preload("res://Source/Interface/Inventory Item/Plank.tscn")
var plush = preload("res://Source/Interface/Inventory Item/Plush.tscn")
var page = preload("res://Source/Interface/Inventory Item/Page.tscn")
var key = preload("res://Source/Interface/Inventory Item/Key.tscn")

# Items
onready var rake_node = $Rake
onready var snake_node = $Snake
onready var plush_node = $Plush
onready var mailbox_node = $MailBox
onready var ladder_node = $Ladder
onready var pot_node = $Pot
onready var level_complete_node = $LevelComplete

# Audio and animations
onready var audio_player = $AudioStreamPlayer2
onready var audio_stream_player = $AudioStreamPlayer
onready var volume_slider = $CanvasLayer/VBoxContainer2/HSlider
onready var volume_label = $CanvasLayer/VBoxContainer2/Label
onready var animation_player = $AnimationPlayer

# Settings
onready var save = $CanvasLayer/VBoxContainer2/Save
onready var menu = $CanvasLayer/VBoxContainer2/Menu
onready var option = $CanvasLayer/Option

func _ready():
	# Signals
	rake_node.connect("body_entered", self, "_on_body_entered", ["rake"])
	rake_node.connect("body_exited", self, "_on_body_exited", ["rake"])
	
	snake_node.connect("body_entered", self, "_on_body_entered", ["snake"])
	snake_node.connect("body_exited", self, "_on_body_exited", ["snake"])
	
	plush_node.connect("body_entered", self, "_on_body_entered", ["plush"])
	plush_node.connect("body_exited", self, "_on_body_exited", ["plush"])
	
	mailbox_node.connect("body_entered", self, "_on_body_entered", ["mail"])
	mailbox_node.connect("body_exited", self, "_on_body_exited", ["mail"])
	
	ladder_node.connect("body_entered", self, "_on_body_entered", ["ladder"])
	ladder_node.connect("body_exited", self, "_on_body_exited", ["ladder"])
	
	pot_node.connect("body_entered", self, "_on_body_entered", ["pot"])
	pot_node.connect("body_exited", self, "_on_body_exited", ["pot"])
	
	level_complete_node.connect("body_entered", self, "_on_body_entered", ["level"])
	level_complete_node.connect("body_exited", self, "_on_body_exited", ["level"])
	
	save.connect("pressed", self, "_on_Save_pressed")
	menu.connect("pressed", self, "_on_Menu_pressed")
	option.connect("pressed", self, "_on_Option_pressed")
	volume_slider.connect("value_changed", self, "_on_volume_slider_value_changed")
	
	animation_player.connect("animation_finished", self, "_on_fade_out_finished")
	
	# Volume
	audio_stream_player.volume_db = SaveSettings.audio_volume_db

	# Volume Settings
	volume_slider.min_value = -80
	volume_slider.max_value = 0
	volume_slider.value = audio_stream_player.volume_db
	


func _input(event):
	if event.is_action_pressed("Esc"):
		get_tree().quit()

func _process(_delta):
	if Input.is_action_just_pressed("leftclick"):
		if rakeTriggered and not rakeFinished:
			$Rake.queue_free()
			first_slot.add_child(rake.instance())
			rakeFinished = true
			dialog.update_text("You found a rake! Hurry up and use the rake to find me!", dialog_slot)
			play_item_obtained_audio()
		elif snakeTriggered and not snakeFinished and rakeFinished and first_slot.pressed:
			$Snake/AnimatedSprite.play("Animate")
			snakeFinished = true
		elif snakeTriggered and snakeFinished and rakeFinished and first_slot.pressed:
			if not second_slot.has_node("Plank"):
				second_slot.add_child(plank.instance())
				$Snake/AnimatedSprite.play("Finish")
				if plushPicked:
					dialog.update_text("You found a wood plank! This might be useful later.", dialog_slot)
				else:
					dialog.update_text("You found a wood plank! I'll tell you about it later. Please get me first!", dialog_slot)
				play_item_obtained_audio()
		elif plushTriggered and not plushFinished and rakeFinished and first_slot.pressed:
			$Plush/AnimatedSprite.play("Animate")
			plushFinished = true
			dialog.update_text("Thank you for finding me! Now get me out of here!", dialog_slot)
		elif plushTriggered and plushFinished and rakeFinished and first_slot.pressed:
			if not third_slot.has_node("Plush"):
				third_slot.add_child(plush.instance())
				$Plush/AnimatedSprite.play("Finish")
				plushPicked = true
				dialog.update_text("Let's go home! I remember seeing Lily place a key in the hanging pot.\n\nBut the ladder seems to be missing two steps. We need two wood planks for it!", dialog_slot)
				play_item_obtained_audio()
		elif mailTriggered and not mailFinished and plushFinished:
			$MailBox/AnimatedSprite.play("Animate")
			mailFinished = true
		elif mailTriggered and mailFinished and plushFinished:
			if not fourth_slot.has_node("Page"):
				fourth_slot.add_child(page.instance())
				fifth_slot.add_child(plank.instance())
				$MailBox/AnimatedSprite.play("Finish")
				dialog.update_text("Let's read this diary page later. For now let's focus on getting the key.\n\nIf you have enough wood planks, I can help you fix the ladder.", dialog_slot)
				play_item_obtained_audio()
		elif ladderTriggered and not ladderFinished and mailFinished and third_slot.pressed:
			if second_slot.has_node("Plank"):
				$CanvasLayer/Inventory/GridContainer/Slot2/Plank.queue_free()
			if fifth_slot.has_node("Plank"):
				$CanvasLayer/Inventory/GridContainer/Slot5/Plank.queue_free()
			$FixEffect.play()
			$Ladder/AnimatedSprite.play("Finish")
			ladderFinished = true
		elif potTriggered and not potFinished and ladderFinished and third_slot.pressed:
			if not sixth_slot.has_node("Key"):
				$KeyEffect.play()
				sixth_slot.add_child(key.instance())
				potFinished = true
				dialog.update_text("We got it! Let's go inside and read the diary page.", dialog_slot)
				play_item_obtained_audio()
		elif levelTriggered and not levelFinished and potFinished and sixth_slot.pressed:
			levelFinished = true
			animation_player.play("fade_out 2")

# Function to play item obtained audio
func play_item_obtained_audio():
	if not audio_player.playing:
		audio_player.play()

func _on_body_entered(body, name):
	match name:
		"rake":
			rakeTriggered = true
		"snake":
			snakeTriggered = true
		"plush":
			plushTriggered = true
		"mail":
			mailTriggered = true
		"ladder":
			ladderTriggered = true
		"pot":
			potTriggered = true
		"level":
			levelTriggered = true

func _on_body_exited(body, name):
	match name:
		"rake":
			rakeTriggered = false
		"snake":
			snakeTriggered = false
		"plush":
			plushTriggered = false
		"mail":
			mailTriggered = false
		"ladder":
			ladderTriggered = false
		"pot":
			potTriggered = false
		"level":
			levelTriggered = false
			
func _on_Settings_pressed():
	$VBoxContainer2.visible = true

func _on_volume_slider_value_changed(value):
	if audio_stream_player == null:
		return
	audio_stream_player.volume_db = value
	$AudioStreamPlayer2.volume_db = value
	SaveSettings.audio_volume_db = value
	SaveSettings.save_settings()

func _on_Save_pressed():
	$CanvasLayer/VBoxContainer2.visible = false

func _on_Option_pressed():
	$CanvasLayer/VBoxContainer2.visible = true


func _on_Menu_pressed():
	animation_player.play("fade_out")

func _on_fade_out_finished(anim_name):
	if anim_name == "fade_out":
		SaveSettings._change_scene("res://Source/Interface/MainMenu.tscn")
	if anim_name == "fade_out 2":
		SaveSettings._change_scene("res://Source/Cutscene/Diary.tscn")

