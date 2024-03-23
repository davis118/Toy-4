extends Button

var v 
var hover = preload("res://internalResources/buttonhover.tres")

func mousein():
	$VBoxContainer2/title.add_theme_stylebox_override("normal",hover)
	$VBoxContainer2/box.add_theme_stylebox_override("normal",hover)
	
	pass
func mouseout():
	$VBoxContainer2/title.remove_theme_stylebox_override("normal")
	$VBoxContainer2/box.remove_theme_stylebox_override("normal")
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	v = get_meta("v")
	connect("mouse_entered",mousein)
	connect("mouse_exited",mouseout)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	if get_meta("value"):
		
		bus.emit_signal(get_meta("v"),get_meta("value"))
	else:
		bus.emit_signal(get_meta("v"))
	bus.emit_signal("powerup")
	#print("aAAAAAA")
	
	pass # Replace with function body.

