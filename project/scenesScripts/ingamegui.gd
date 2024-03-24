extends Control

var an
var lives
const lifecircle = preload("res://scenesScripts/lifecircle.tscn")
var hbox 
func open():
	#print("opening")
	an.play("ingamein")

	
func close():
	#print("closing")
	if visible == true:
		an.play("ingameout")
	
func lifeupdate(newlives):
	
	if hbox:
		for kid in hbox.get_children():
			kid.queue_free()
		for i in range(newlives):
			if lifecircle:
				var circle = lifecircle.instantiate()
				hbox.add_child(circle)
				pass
			else:
				#print("no lifecirc")
				pass
	else:
		#print("no")
		pass
	
func clear():
	if hbox:
		for kid in hbox.get_children():
			kid.queue_free()
	else:
		#print("no hbox!!!!")
		pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	hbox = $MarginContainer/VBoxContainer/PanelContainer/MarginContainer/Control/HBoxContainer
	bus.connect("start",open)
	#print(get_signal_connection_list("start"))
	bus.connect("mainmenu",close)
	bus.connect("credits",close)
	bus.connect("help",close)
	bus.connect("livesChanged",lifeupdate)
	bus.connect("died",clear)
	
	an = $AnimationPlayer
	if an:
		print("theres an")
	else:
		print("no an")
		print(name)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(get_signal_connection_list("start"))
	pass


