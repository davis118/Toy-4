extends Control

var an
func open():
	#print("opening")
	an.play("credsin")

	
func close():
	#print("closing")
	if visible == true:
		an.play("credsout")
	
# Called when the node enters the scene tree for the first time.
func _ready():
	an = $AnimationPlayer
	bus.connect("start",close)
	#print(get_signal_connection_list("start"))
	bus.connect("mainmenu",close)
	bus.connect("credits",open)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(get_signal_connection_list("start"))
	pass


