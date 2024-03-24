extends Control

var grid
var owedLevels = 0
func open():
	#print("opening")
	visible = true
	#$AnimationPlayer.play("upgradein")
	print("yahoo")

	
func close():
	#print("closing")
	if Engine.time_scale != 1:
		bus.emit_signal("resume")
	

	visible == false


func levelup():
	
	owedLevels -=1

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
	if owedLevels <=0:
		close()
		visible = false
	else:
		levelup() #number doesnt actually matter i just realized
	
func incoming(level):
	owedLevels+=1
	if visible == false:
		open()
		levelup()
	pass
func oof():
	visible = false
# Called when the node enters the scene tree for the first time.
func _ready():
	grid = $MarginContainer/HBoxContainer

	#print(get_signal_connection_list("start"))
	bus.connect("died",oof)
	bus.connect("levelup",incoming)
	bus.connect("powerup",powerup)
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print(get_signal_connection_list("start"))
	pass


