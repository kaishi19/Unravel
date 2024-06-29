extends Label

var wave_amplitude = 10
var wave_frequency = 1.5
var spooky_color = Color(1, 0, 0)  
var original_color = Color(1, 1, 1)  

func _ready():
	start_waving()
	start_spooky_effect()

func start_waving():
	var tween = $Tween
	tween.interpolate_method(self, "update_wave", 0.0, 1.0, wave_frequency, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0)
	tween.start()

func update_wave(delta):
	var offset = sin(OS.get_ticks_msec() / 1000.0 * wave_frequency * PI * 2) * wave_amplitude
	rect_position.y = (get_viewport_rect().size.y / 2) - (rect_size.y / 2) + offset

func start_spooky_effect():
	var tween = $Tween
	tween.interpolate_property(self, "modulate", original_color, spooky_color, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	tween.start()
	tween.interpolate_property(self, "modulate", spooky_color, original_color, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1)
	tween.start()
