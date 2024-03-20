extends CharacterBody2D


var health = 100
var accM = 8

const fastSpeed = 3000
var player
const center = Vector2(960,540)
var bus
var r
var traveling = true
var expl = preload("res://scenesScripts/explodepart.tscn")
var pos
var floatPos
var floatRad = 50
var acc = Vector2(0,0)
var rotationalSpeed = 0.002
var laser
var frozenLaser = false
var straight = false

func spawn(newPos:Vector2):
	pos = newPos
	position = (pos - center).normalized()*4000 + center
	
	velocity = (center - pos).normalized() * fastSpeed
	
	r = pos.length()



func floatAround():
	floatPos = pos + Vector2(randf_range(-1,1),randf_range(-1,1)).normalized() 
	acc = (floatPos - global_position).normalized() * accM
	
	pass

func clear():
	var part = expl.instantiate()
	$"/root/Main".add_child(part)
	part.go(velocity,global_position,2)
	queue_free()

func goStraight():
	straight = true
	pass
	
func _ready():
	bus = $"/root/Main/bus"
	laser = $laser
	bus.connect("clear",clear)
	
	
	
	pass

func _physics_process(delta):
	if traveling == true && pos:
		
		if (position - pos).length() <= fastSpeed*delta:
			
			traveling = false
			velocity = Vector2(0,0)
			position = pos
			$AttackTimer.start()
			$MoveTimer.start()
			floatAround()
			if has_node("/root/Main/player"):
				player = $"/root/Main/player"
		move_and_slide()
	else: if floatPos:
		
		velocity += acc * delta 
		move_and_slide()
		position.x = clamp(position.x, 0 , 1920)
		position.y = clamp(position.y, 0 , 1080)
		
		if frozenLaser == false and player != null and player.is_inside_tree() and straight == false:
			var dir = player.global_position - global_position
			var desiredAng = atan2(dir.y,dir.x) 
			
			if desiredAng > 2*PI:
				desiredAng -= 2*PI
			if desiredAng < 0:
				desiredAng += 2*PI
			
			if desiredAng - laser.rotation > PI:
				laser.rotation = move_toward(laser.rotation,-PI/2,rotationalSpeed)
				
			else: if laser.rotation - desiredAng > PI:
				laser.rotation = move_toward(laser.rotation,PI*2.5,rotationalSpeed)
			else:
				laser.rotation = move_toward(laser.rotation,desiredAng,rotationalSpeed)
			#print(laser.rotation)
			if laser.rotation < 0:
				laser.rotation += 2*PI
			if laser.rotation > 2 * PI:
				laser.rotation -= 2*PI
			
			pass
		else: if straight == true and frozenLaser == false:
			laser.rotation = PI


func _on_timer_timeout():
	laser.get_node("CollisionShape2D/sprite").modulate = Color(1,1,1)
	$GlowTimer.start()
	
	


func _on_move_timer_timeout():
	floatAround()


func _on_fin_timer_timeout():
	#laser stops
	laser.set_collision_layer_value(4, false)
	frozenLaser = false
	laser.get_node("CollisionShape2D/sprite").modulate = Color(1,1,1,0.5)
	pass # Replace with function body.


func _on_glow_timer_timeout():
	frozenLaser = true
	#laser starts
	laser.set_collision_layer_value(4, true)
	laser.get_node("CollisionShape2D/sprite").modulate = Color(1,0,0)
	$FinTimer.start()


func _on_area_2d_body_entered(body):
	var damage = body.get_meta("damage")


	health -= damage
	body.clear()
	if health <= 0:
		queue_free()
	pass # Replace with function body.
