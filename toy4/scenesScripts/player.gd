extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var missileSc = preload("res://scenesScripts/missile.tscn")
var expl = preload("res://scenesScripts/explodepart.tscn")
var attacks
var misSpeed = 400
var bus

func clear():
	var part = expl.instantiate()
	$"/root/Main".add_child(part)
	part.go(velocity,global_position,2)
	queue_free()
	
func _ready():
	attacks = $"/root/Main/playerAttacks"
	bus = $"/root/Main/bus"
	bus.connect("clear",clear)
func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector2(Input.get_axis("left", "right"),Input.get_axis("up", "down")).normalized()
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2(0,0)
	

	move_and_slide()
	position.x = clamp(position.x, 0 , 1920)
	position.y = clamp(position.y, 0 , 1080)



func _on_attack_timeout():
	#spawn 4 missiles
	var m = missileSc.instantiate()
	attacks.add_child(m)
	m.global_position = global_position
	m.velocity = Vector2(1,1).normalized()*Vector2(misSpeed,misSpeed)
	
	m = missileSc.instantiate()
	attacks.add_child(m)
	m.global_position = global_position
	m.velocity = Vector2(1,2).normalized()*Vector2(misSpeed,misSpeed)
	
	m = missileSc.instantiate()
	attacks.add_child(m)
	m.global_position = global_position
	m.velocity = Vector2(1,-1).normalized()*Vector2(misSpeed,misSpeed)
	
	m = missileSc.instantiate()
	attacks.add_child(m)
	m.global_position = global_position
	m.velocity = Vector2(1,-2).normalized()*Vector2(misSpeed,misSpeed)



func _on_area_2d_body_entered(body):
	#you got hit hahahaha you sucker
	bus.emit_signal("died")
	clear()
	pass # Replace with function body.


func _on_fast_attack_timeout():
	var m = missileSc.instantiate()
	attacks.add_child(m)
	m.global_position = global_position
	m.scale = Vector2(1,4)
	m.set_meta("damage",7)
	m.goStraight()
	pass # Replace with function body.
