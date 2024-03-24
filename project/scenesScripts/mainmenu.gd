extends Control
var animp

func open():
	#print("opening")
	animp.play("menuin")
	visible = true

	
func pl():
	#print("closing")
	if visible == true:
		animp.play("menuout")
	#visible = false
func close():
	if visible == true:
		animp.play("menuclose")
# Called when the node enters the scene tree for the first time.
func _ready():
	animp = $AnimationPlayer
	animp.play("menuin")
	bus.connect("start",pl)
	#print(get_signal_connection_list("start"))
	bus.connect("mainmenu",open)
	bus.connect("credits",close)
	bus.connect("help",close)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(get_signal_connection_list("start"))
	pass




func _on_animation_player_animation_finished(anim_name):
	if anim_name == "menuout":
		visible = false
	pass # Replace with function body.
