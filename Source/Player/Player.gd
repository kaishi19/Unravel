extends KinematicBody2D

onready var animatedSprite = $AnimatedSprite

export (int) var speed = 100
var target = Vector2()
var velocity = Vector2()
var last_audio_played_time = 0
var audio_interval = 0.55
var last_sound_index = 0  

var audio_players = []

func _ready():
	target = position
	audio_players.append($AudioStreamPlayer2D)
	audio_players.append($AudioStreamPlayer2D2)

func _process(_delta):
	if Input.is_action_just_pressed('rightclick'):
		target.x = get_global_mouse_position().x
		target.y = position.y
	velocity = (target - position).normalized() * speed
	velocity.y = 0
	if (target - position).length() > 5:
		velocity = move_and_slide(velocity)
		animatedSprite.play("Walk")
		if velocity.x > 0:
			animatedSprite.flip_h = false
		elif velocity.x < 0:
			animatedSprite.flip_h = true
		if OS.get_ticks_msec() - last_audio_played_time >= audio_interval * 1000:
			last_sound_index = (last_sound_index + 1) % audio_players.size()
			audio_players[last_sound_index].play()
			last_audio_played_time = OS.get_ticks_msec()
	else:
		animatedSprite.play("Idle")
