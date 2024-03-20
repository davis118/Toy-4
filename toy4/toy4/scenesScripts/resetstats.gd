extends Button

signal doit
var conf = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	if conf == true:
		text = "stats reset"
		emit_signal("doit")
		pass
	else:
		text = "confirm reset?"
		conf = true
		pass 


func _on_visibility_changed():
	text = "reset stats"
	conf = false
	pass # Replace with function body.
