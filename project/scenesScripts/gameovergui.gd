extends Control

var bus

func exist():
	visible = true

	
func stopExist():
	visible = false
	
# Called when the node enters the scene tree for the first time.
func _ready():
	bus = $"/root/Main/bus"
	bus.connect("died", exist)
	bus.connect("start", stopExist)
	bus.connect("mainMenu", stopExist)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

