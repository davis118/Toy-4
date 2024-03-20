extends Node2D





var playerScene = preload("res://scenesScripts/player.tscn")
var smallEnemyScene = preload("res://scenesScripts/smallenemy.tscn")
var laserEnemyScene = preload("res://scenesScripts/laserenemy.tscn")
var bus

var player
var playing = false

var diff = 0
var type = 0

var hdiff = 0
var htype = 0
var flights = 0

var chilling = false

#uncomment following for save capabilities
func save():
	var dict = {
		"hdiff": hdiff,
		"htype": htype,
		"flights": flights
	}
	return dict
	
func save_game():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
		# JSON provides a static method to serialized JSON string.
	var json_string = JSON.stringify(save())
		# Store the save dictionary as a new line in the save file.
	save_game.store_line(json_string)

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return #who cares, no save
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		# Get the data from the JSON object
		var data = json.get_data()
		hdiff = data["hdiff"]
		htype = data["htype"]
		flights = data["flights"]
	
func spawnEnemies(): #difficulty and type of wave
	#difficulty increases number of enemies
	#type decides what arrangement/types of enemies
	#it is generated by the game, this way there are infinite levels, arcade-style
	print("spawning in: " + str(diff+1)+"-"+str(type+1))
	$"Canvas/ingamegui/MarginContainer/counter".text =  str(diff+1)+"-"+str(type+1)
	

	if type < 1:
#type 0 - first row of straight shooters, back row of angled shooters
		for i in range(diff+3):
		
			var enemy = smallEnemyScene.instantiate()
			add_child(enemy)
			enemy.spawn(Vector2(1100,(140 + i*(800/(diff+3-1)))))
			enemy.set_meta("straight", true)
		
		for i in range(diff+2):
		
			var enemy = smallEnemyScene.instantiate()
			add_child(enemy)
			enemy.spawn(Vector2(1600,(140 + i*(800/(diff+2-1)))))
			enemy.set_meta("straight", false)
	else: if type < 2:
#type 1 - straight shooters in front, lasers in back
		for i in range(diff+2):
		
			var enemy = smallEnemyScene.instantiate()
			add_child(enemy)
			enemy.spawn(Vector2(1100,(140 + i*(800/(diff+2-1)))))
			enemy.set_meta("straight", true)
		
		for i in range(diff+2):
		
			var enemy = laserEnemyScene.instantiate()
			add_child(enemy)
			enemy.spawn(Vector2(1600,(140 + i*(800/(diff+2-1)))))
	else: if type < 3:
#type 2 - straight shooter SWARM
		for i in range(diff*2+3):
		
			var enemy = smallEnemyScene.instantiate()
			add_child(enemy)
			enemy.spawn(Vector2(1100,(140 + i*(800/(diff*2+3-1)))))
			enemy.set_meta("straight", true)
		
		for i in range(diff*2+4):
		
			var enemy = smallEnemyScene.instantiate()
			add_child(enemy)
			enemy.spawn(Vector2(1600,(140 + i*(800/(diff*2+4-1)))))
			enemy.set_meta("straight", true)
	else: if type < 4:
#type 3 - laser swarm. back row does not aim
		for i in range(diff*2+2):
		
			var enemy = laserEnemyScene.instantiate()
			add_child(enemy)
			enemy.spawn(Vector2(1100,(140 + i*(800/(diff*2+2-1)))))
		
		for i in range(diff*2+3):
		
			var enemy = laserEnemyScene.instantiate()
			add_child(enemy)
			enemy.spawn(Vector2(1600,(140 + i*(800/(diff*2+3-1)))))
			enemy.goStraight()
	else: if type < 5:
#type 4 - lasers in back, aimed shooters in front
		for i in range(diff+4):
		
			var enemy = smallEnemyScene.instantiate()
			add_child(enemy)
			enemy.spawn(Vector2(1100,(140 + i*(800/(diff+4-1)))))
			enemy.set_meta("straight", false)
		
		for i in range(diff+2):
		
			var enemy = laserEnemyScene.instantiate()
			add_child(enemy)
			enemy.spawn(Vector2(1600,(140 + i*(800/(diff+2-1)))))

func startGame():
	
	player = playerScene.instantiate()
	add_child(player)
	player.global_position = Vector2(200,540)
	
	diff = 0
	type = 0
	spawnEnemies()
	playing = true
		#this was for circle spawn, but i changed to line!!
		#var theta = i * 2 * PI /amount
		#var r = 480
		#print(Vector2(r*cos(i),r*sin(i)))
		#enemy.spawn(Vector2(r*cos(theta),r*sin(theta)),) #relative to center!!

func updateStatsBox():
		$"Canvas/helpscreen/Control/VBoxContainer/HBoxContainer/VBoxContainer2/statsbox".text = "\ntotal flights: "+str(flights)+"\nhighest wave: " + str(hdiff+1)+"-"+str(htype+1)+"\n\n"
# Called when the node enters the scene tree for the first time.

func over():
	flights += 1
	if diff * 5 + type + 1 > hdiff * 5 + htype + 1:
		hdiff = diff
		htype = type
		
		
		
	$"Canvas/gameover/Control/VBoxContainer/stats".text = "you made it to wave: " + str(diff+1)+"-"+str(type+1) +"\n highest wave: " + str(hdiff+1)+"-"+str(htype+1)
	save_game()
	updateStatsBox()
	playing = false
	
func _ready():
	bus = $"/root/Main/bus"
	bus.connect("start", startGame)
	bus.connect("died", over)
	load_game()
	updateStatsBox()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playing == true and get_tree().get_nodes_in_group("enemies").size() == 0 and chilling == false:
		chilling = true
		$chillTimer.start()
		type +=1
		if type > 4:
			diff +=1
			type = 0
		spawnEnemies()
		pass




func _on_chill_timer_timeout():
	chilling = false
	pass # Replace with function body.


func _input(event):
	if event.is_action_pressed("menu"):
		
		if playing == false:
			print("m")
			bus.emit_signal("mainmenu")
	pass

func _on_resetstats_doit():
	hdiff = 0
	htype = 0
	flights = 0
	save_game()
	updateStatsBox()
	pass # Replace with function body.

#
#func _on_bus_main_menu():
	#if playing == true:
		#over();
	#var plr = get_tree().get_first_node_in_group("player")
	#
	#
	#if plr:
		#print("a")
		#plr.queue_free()
	#pass # Replace with function body.
