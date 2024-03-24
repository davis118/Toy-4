extends CharacterBody2D



#---------------------
var health = 200
var accM = 9
var xpDropped = 20
#---------------------




const fastSpeed = 3000
var player
const center = Vector2(960,540)


var ovel
var r
var traveling = true
var pos
var bulletScene = preload("res://scenesScripts/bullet.tscn")
var xpScene = preload("res://scenesScripts/xp.tscn")
var expl = preload("res://scenesScripts/explodepart.tscn")
var floatPos
var floatRad = 50
var acc = Vector2(0,0)
var ang = 0




func clear():
	var part = expl.instantiate()
	$"/root/Main".add_child(part)
	part.go(velocity,global_position,2)
	queue_free()
	
func spawn(newPos:Vector2):
	pos = newPos
	position = (pos - center).normalized()*4000 + center
	
	velocity = (center - pos).normalized() * fastSpeed
	
	r = pos.length()



func floatAround():
	floatPos = pos + Vector2(randf_range(-1,1),randf_range(-1,1)).normalized() 
	acc = (floatPos - global_position).normalized() * accM
	
	pass



func _ready():
	bus.connect("clear",clear)
	
	
	pass

func _physics_process(delta):
	$triangle.rotation += get_meta("spinspeed")*delta
	$VisualSprite.speed_scale = 1
	if traveling == true && pos:
		
		if (position - pos).length() <= fastSpeed*delta:
			
			traveling = false
			ovel = Vector2(0,0)
			position = pos
			$AttackTimer.start()
			$MoveTimer.start()
			$VisualSprite.play("default")
			$triangle.play("default")
			_on_timer_timeout()
			floatAround()
			if has_node("/root/Main/player"):
				player = $"/root/Main/player"
		move_and_slide()
	else: if floatPos:
		move_and_slide()
		position.x = clamp(position.x, 0 , 1920)
		position.y = clamp(position.y, 0 , 1080)
		ovel += acc * delta * 1
		velocity = ovel * 1
		#velocity += acc * delta * 1
		
		


func _on_timer_timeout():
	$AttackTimer/warmup.play("warm")
	


func _on_move_timer_timeout():
	floatAround()


func damage_flash():
	pass

func _on_area_2d_body_entered(body):
	#something is inside!!
	var damage = body.get_meta("damage")
	damage_flash()
	health -= damage
	body.clear()
	if health <= 0:
		for i in xpDropped + bus.extraxp:
			var xporb = xpScene.instantiate()
			$"/root/Main".add_child(xporb)
			xporb.init(global_position)
			xporb.set_meta("isorb", true)
		queue_free()
	pass # Replace with function body.


func _on_tiny_timer_timeout():
	ang += get_meta("spinspeed") * $AttackTimer/TinyTimer.wait_time
	var bullet = bulletScene.instantiate()
	bullet.global_position = global_position
	$"/root/Main/enemyAttacks".add_child(bullet)
	bullet.setDir(Vector2(cos(ang),sin(ang)))
	
	#spawn BULLETS
	pass # Replace with function body.




func _on_warmup_animation_finished(anim_name):
	if anim_name == "warm":
		$AttackTimer/CapacityTimer.start()
		$AttackTimer/TinyTimer.start()
	pass # Replace with function body.


func _on_capacity_timer_timeout():
	$AttackTimer/warmup.play("cool")
	$AttackTimer/TinyTimer.stop()
	pass # Replace with function body.
