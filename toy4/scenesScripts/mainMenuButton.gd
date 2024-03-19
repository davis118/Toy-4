extends Button
var bus

# Called when the node enters the scene tree for the first time.
func _ready():
	bus = $"/root/Main/bus"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	bus.emit_signal("mainMenu")
