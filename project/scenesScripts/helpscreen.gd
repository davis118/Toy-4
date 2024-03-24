extends Control
var an

func open():

	an.play("helpin")

	
func close():
	if visible == true:
	#print("closing")
		an.play("helpout")
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	an = $AnimationPlayer
	bus.connect("start",close)
	#print(get_signal_connection_list("start"))
	bus.connect("mainmenu",close)
	bus.connect("credits",close)
	bus.connect("help",open)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(get_signal_connection_list("start"))
	pass


