extends Control

var bus

func open():
	#print("opening")
	visible = true

	
func close():
	#print("closing")
	visible = false
	
# Called when the node enters the scene tree for the first time.
func _ready():
	bus = $"/root/Main/bus"
	bus.connect("start",open)
	#print(get_signal_connection_list("start"))
	bus.connect("mainmenu",close)
	bus.connect("credits",close)
	bus.connect("help",close)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(get_signal_connection_list("start"))
	pass

