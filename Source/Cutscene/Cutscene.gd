extends Node2D

onready var animation_player = $AnimationPlayer
var current_frame = 1

func _ready():
	$AudioStreamPlayer.play()
	$AnimatedSprite.play("default")
	$AnimatedSprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	animation_player.connect("animation_finished", self, "_on_fade_out_finished")

func _process(delta):
	if Input.is_action_just_pressed("leftclick") and current_frame != 11:
		$AnimatedSprite.frame = current_frame
		$AnimatedSprite.play("default")
		current_frame += 1
	

func _on_AnimatedSprite_animation_finished():
	animation_player.play("fade_out")

func _on_fade_out_finished(anim_name):
	if anim_name == "fade_out":
		SaveSettings._change_scene("res://Source/Level/Level1.tscn")
