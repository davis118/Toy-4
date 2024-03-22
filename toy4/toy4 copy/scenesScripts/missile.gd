extends CharacterBody2D


var speed = 25000
const JUMP_VELOCITY = -400.0
var acc 

var initialVel = Vector2(0,100)
var turn = 1


var topSpeed = 300
var target
var bus
var expl = preload("res://scenesScripts/explodepart.tscn")
var enemies
var ovel #original velocity, before speed multiplier!
var home = true


func clear():
	var part = expl.instantiate()
	$"/root/Main".add_child(part)
	part.go(velocity,global_position,1)
	queue_free()
	
	
func goStraight():
	home = false
	speed = 40000
	
	velocity = Vector2(1,0) * speed
	
func _ready():
	#velocity = initialVel
	var player = $AnimationPlayer
	bus = $"/root/Main/bus"
	bus.connect("clear",clear)
	
	player.play("spawn")
	pass
	
	
func getClosest():
	#print("yayaya")
	enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() > 0:
		var topEnemy = enemies[0]
		var topDist = 10000
		for en in range(enemies.size()-1):
			var dist = (enemies[en].global_position - global_position).length()
			if dist < topDist:
				topDist = dist
				topEnemy = enemies[en]
		return topEnemy
	
	

func _physics_process(delta):
	if target != null and target.is_inside_tree() and home == true:
		  
		var direction = (target.global_position - global_position).normalized()
		velocity.x = lerp(velocity.x,direction.x*velocity.length(),turn*delta*Glob.gamespeed)
		velocity.y = lerp(velocity.y,direction.y*velocity.length(),turn*delta*Glob.gamespeed)
		turn += 2*delta * Glob.gamespeed
		#velocity *= Vector2(delta*acc+1,delta*acc+1)
		
		
		velocity = velocity.normalized() * speed *delta * Glob.gamespeed
	else: if home == false:
		velocity = velocity.normalized() * speed *delta * Glob.gamespeed
		pass
	else:
		target = getClosest()
		
	rotation = atan2(velocity.y,velocity.x)
	
	# Add the gravity.

	move_and_slide()
