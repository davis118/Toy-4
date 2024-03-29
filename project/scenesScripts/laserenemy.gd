extends CharacterBody2D


var health = 100
var accM = 8

const fastSpeed = 3000
var player
const center = Vector2(960,540)
const xpDropped = 7

var r
var traveling = true
var expl = preload("res://scenesScripts/explodepart.tscn")
var xpScene = preload("res://scenesScripts/xp.tscn")
var pos
var floatPos
var floatRad = 50
var acc = Vector2(0,0)
var rotationalSpeed = 0.05
var laser
var frozenLaser = false
var straight = false
var ogfps = 8

func spawn(newPos:Vector2):
	pos = newPos
	position = (pos - center).normalized()*4000 + center
	
	velocity = (center - pos).normalized() * fastSpeed * 1
	
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
	
	laser = $laser
	bus.connect("clear",clear)
	
	
	
	pass

func _physics_process(delta):
	$VisualSprite.speed_scale = 1
	if traveling == true && pos:
		
		if (position - pos).length() <= fastSpeed*delta * 1:
			
			traveling = false
			velocity = Vector2(0,0)
			position = pos
			#$AttackTimer.start()
			$MoveTimer.start()
			$VisualSprite.play("default")
			floatAround()
			if has_node("/root/Main/player"):
				player = $"/root/Main/player"
			$randomTimer.wait_time = randf_range(2,8)
			$randomTimer.start()
		move_and_slide()
	else: if floatPos:
		
		velocity += acc * delta * 1
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
				laser.rotation = move_toward(laser.rotation,-PI/2,rotationalSpeed*delta*1)
				
			else: if laser.rotation - desiredAng > PI:
				laser.rotation = move_toward(laser.rotation,PI*2.5,rotationalSpeed*delta*1)
			else:
				laser.rotation = move_toward(laser.rotation,desiredAng,rotationalSpeed*delta*1)
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
	$VisualSprite.play("default")
	laser.set_collision_layer_value(4, false)
	frozenLaser = false
	laser.get_node("CollisionShape2D/sprite").modulate = Color(1,1,1,0.5)
	pass # Replace with function body.


func _on_glow_timer_timeout():
	frozenLaser = true
	#laser starts
	$VisualSprite.play("laser")
	laser.set_collision_layer_value(4, true)
	laser.get_node("CollisionShape2D/sprite").modulate = Color(1,0,0)
	$FinTimer.start()

func damage_flash():
	pass

func _on_area_2d_body_entered(body):
	#something is inside!!
	var damage = body.get_meta("damage")
	damage_flash()
	health -= damage
	body.clear()
	if health <= 0:
		for i in xpDropped+bus.extraxp:
			var xporb = xpScene.instantiate()
			$"/root/Main".add_child(xporb)
			xporb.init(global_position)
			xporb.set_meta("isorb", true)
		queue_free()
	pass # Replace with function body.


func _on_random_timer_timeout():
	laser.get_node("CollisionShape2D/sprite").modulate = Color(1,1,1)
	$GlowTimer.start()
	$AttackTimer.start()
	pass # Replace with function body.
