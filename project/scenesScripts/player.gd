extends CharacterBody2D

@export var lives = 2
var immune = false
var level = 0

var bulletDamage = 5
var bulletFiringSpeed = .3
var bulletSpeed = 500
var missileDamage = 8
var missileAmount = 4






const SPEED = 500
const JUMP_VELOCITY = -400.0

var missileSc = preload("res://scenesScripts/missile.tscn")
var expl = preload("res://scenesScripts/explodepart.tscn")
var attacks
var misSpeed = 400
var xp = 0
var xpamount = 1
var visSprite
var current = 0 #current animation. -1 for back, 0 stop, 1 for



func clear():
	var part = expl.instantiate()
	$"/root/Main".add_child(part)
	part.go(velocity,global_position,2)
	queue_free()
	
func imm(): #activates immunity!!
	immune = true
	visSprite.modulate = Color(1,1,0)
	$immunityTimer.start()
	
	
#UPGRADE FUNCTIONS

func extralife():
	lives +=1
	bus.emit_signal("livesChanged",lives)
	pass
func bd(value):
	bulletDamage += value
func bfs(value):
	bulletFiringSpeed *= value
func bs(value):
	bulletSpeed *= value
func md(value):
	missileDamage += value
func ma(value):
	missileAmount += value
	
	
func _ready():
	attacks = $"/root/Main/playerAttacks"
	bus.connect("clear",clear)
	bus.connect("levelup",imm)
	visSprite = $VisualSprite
	visSprite.play("default")
	bus.connect("extralife",extralife)
	bus.connect("bulletDamage",bd)
	bus.connect("bulletFiringSpeed",bfs)
	bus.connect("bulletSpeed",bs)
	bus.connect("missileDamage",md)
	bus.connect("missileAmount",ma)

func _physics_process(delta):
	$VisualSprite.speed_scale = 1
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector2(Input.get_axis("left", "right"),Input.get_axis("up", "down")).normalized()
	
	if direction:
		velocity = direction * SPEED * 1
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
	var iterations
	if int(missileAmount) % 2 != 0:
		#odd amount of missiles
		iterations = (missileAmount + 1)/2
	else:
		iterations = missileAmount/2
	$missileshing.pitch_scale = randf_range(1.2,1.5)
	$missileshing.play()
	
		
	for i in range (iterations):
		#spawn two missiles, unless there's an odd number...
		var m = missileSc.instantiate()
		attacks.add_child(m)
		m.global_position = global_position
		m.set_meta("damage",missileDamage)
		var ang = PI/4 +((PI/4) * ((float(i)+1)/float(iterations)))
		var y = tan(ang)
		m.velocity = Vector2(1,y).normalized()*Vector2(misSpeed,misSpeed)
		
		#second missile
		
		if (i+1)*2 <= missileAmount:
			#only spawn second missile if not odd number
			m = missileSc.instantiate()
			attacks.add_child(m)
			m.global_position = global_position
			m.set_meta("damage",missileDamage)
			ang = PI/4 +((PI/4) * ((float(i)+1)/float(iterations)))
			y = tan(ang)
			m.velocity = Vector2(1,-y).normalized()*Vector2(misSpeed,misSpeed)
			
		
		pass
	
	
	
	
	#spawn 4 missiles
	#
	#var m = missileSc.instantiate()
	#attacks.add_child(m)
	#m.global_position = global_position
	#m.set_meta("damage",missileDamage)
	#m.velocity = Vector2(1,1).normalized()*Vector2(misSpeed,misSpeed)
	#
	#m = missileSc.instantiate()
	#attacks.add_child(m)
	#m.global_position = global_position
	#m.set_meta("damage",missileDamage)
	#m.velocity = Vector2(1,2).normalized()*Vector2(misSpeed,misSpeed)
	#
	#m = missileSc.instantiate()
	#attacks.add_child(m)
	#m.global_position = global_position
	#m.set_meta("damage",missileDamage)
	#m.velocity = Vector2(1,-1).normalized()*Vector2(misSpeed,misSpeed)
	#
	#m = missileSc.instantiate()
	#attacks.add_child(m)
	#m.global_position = global_position
	#m.set_meta("damage",missileDamage)
	#m.velocity = Vector2(1,-2).normalized()*Vector2(misSpeed,misSpeed)



func _on_area_2d_body_entered(body):
	if body.get_meta("isorb"):
		xp += xpamount
		bus.emit_signal("gainxp")
		body.pickup()
		
	else:
		#you got hit hahahaha you sucker
		
		lives -= 1
		if lives > 0 and immune == false:
			imm()
			bus.emit_signal("livesChanged",lives)
		else: if immune == false:
			bus.emit_signal("died")
			#print("bleHHH")
			clear()


func _on_fast_attack_timeout():
	var m = missileSc.instantiate()
	attacks.add_child(m)
	m.global_position = global_position
	m.scale = Vector2(1,4)
	m.set_meta("damage",bulletDamage)
	m.goStraight(bulletSpeed)
	pass # Replace with function body.


func _on_immunity_timer_timeout():
	immune = false
	visSprite.modulate = Color(1,1,1)
	pass # Replace with function body.
