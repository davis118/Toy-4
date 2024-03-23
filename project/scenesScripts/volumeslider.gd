extends HSlider

var audio
var strn
# Called when the node enters the scene tree for the first time.
func _ready():

	audio = AudioServer.get_bus_index(name)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func newv(val):
	AudioServer.set_bus_volume_db(audio,val)
	if val <= -30:
		AudioServer.set_bus_mute(audio,true)
	else:
		AudioServer.set_bus_mute(audio,false)
	pass
func up(music, sfx):
	if get_meta("type") == 0:
		value = sfx
	else: if get_meta("type") == 1:
		value = music
	

func _on_value_changed(val):
	newv(val)
	bus.emit_signal("updatevolume",get_meta("type"),val)
	#1 for music, 0 for sfx
	
	pass # Replace with function body.
