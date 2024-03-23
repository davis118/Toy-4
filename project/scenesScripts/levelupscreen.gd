extends Control

var grid
func open():
	#print("opening")
	visible = true

	
func close():
	#print("closing")
	visible = false

func levelup(level):
	print(level)
	if level > 0:
		visible = true
		
	var childs = grid.get_children()
	
	for i in range(childs.size()):
		childs[i].visible = false
		pass
	
	var first = randi_range(0,childs.size()-1)
	
	var second = randi_range(0,childs.size()-1)
	while second == first:
		second = randi_range(0,childs.size()-1)
		#so second isnt first
	childs[first].visible = true
	childs[second].visible = true
		
	
func powerup():
	close()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	grid = $MarginContainer/HBoxContainer

	#print(get_signal_connection_list("start"))
	bus.connect("died",close)
	bus.connect("levelup",levelup)
	bus.connect("powerup",powerup)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(get_signal_connection_list("start"))
	pass


