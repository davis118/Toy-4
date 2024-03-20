extends CharacterBody2D


const SPEED = 500
const JUMP_VELOCITY = -400.0

var missileSc = preload("res://scenesScripts/missile.tscn")
var expl = preload("res://scenesScripts/explodepart.tscn")
var attacks
var misSpeed = 400
var bus
<<<<<<<< HEAD:project/scenesScripts/player.gd
var xp = 0
var xpamount = 1
========
var visSprite
var current = 0 #current animation. -1 for back, 0 stop, 1 for
>>>>>>>> KateA:toy4/toy4/scenesScripts/player.gd

func clear():
	var part = expl.instantiate()
	$"/root/Main".add_child(part)
	part.go(velocity,global_position,2)
	queue_free()
	
func _ready():
	attacks = $"/root/Main/playerAttacks"
	bus = $"/root/Main/bus"
	bus.connect("clear",clear)
	visSprite = $VisualSprite
	visSprite.play("default")
func _physics_process(delta):

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector2(Input.get_axis("left", "right"),Input.get_axis("up", "down")).normalized()
	if direction:
		velocity = direction * SPEED
	else:
		velocity = Vector2(0,0)
	if velocity.x < 0 and current != -1:
		current = -1
		visSprite.play("backward")
	else: if velocity.x > 0 and current != 1:
		current = 1
		visSprite.play("forward")
	else: if velocity.x == 0 and current != 0:
		current = 0
		visSprite.play("default")
	

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
	if body.get_meta("isorb"):
		xp += xpamount
		body.pickup()
	else:
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
