extends CharacterBody2D



#---------------------
var health = 30
var accM = 9
#---------------------




const fastSpeed = 3000
var player
const center = Vector2(960,540)
const xpDropped = 3
var bus
var r
var traveling = true
var pos
var bulletScene = preload("res://scenesScripts/bullet.tscn")
var xpScene = preload("res://scenesScripts/xp.tscn")
var expl = preload("res://scenesScripts/explodepart.tscn")
var floatPos
var floatRad = 50
var acc = Vector2(0,0)




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
	bus = $"/root/Main/bus"
	bus.connect("clear",clear)
	$CoreSprite.play("default")
	pass

func _physics_process(delta):
	if traveling == true && pos:
		
		if (position - pos).length() <= fastSpeed*delta:
			
			traveling = false
			velocity = Vector2(0,0)
			position = pos
			$AttackTimer.start()
			$MoveTimer.start()
			$VisualSprite.play("default")
			floatAround()
			if has_node("/root/Main/player"):
				player = $"/root/Main/player"
		move_and_slide()
	else: if floatPos:
		move_and_slide()
		position.x = clamp(position.x, 0 , 1920)
		position.y = clamp(position.y, 0 , 1080)
		velocity += acc * delta 
		


func _on_timer_timeout():
	if player:
		var bullet = bulletScene.instantiate()
		bullet.global_position = global_position
		$"/root/Main/enemyAttacks".add_child(bullet)
		if get_meta("straight") == true:
			bullet.setDir(Vector2(-1,0))
		
	else:
		#print("cant shoot, no player")
		pass


func _on_move_timer_timeout():
	floatAround()


func damage_flash():
	$CoreSprite.play("damage")
	await get_tree().create_timer(0.1).timeout
	$CoreSprite.play("default")

func _on_area_2d_body_entered(body):
	#something is inside!!
	var damage = body.get_meta("damage")
	damage_flash()
	health -= damage
	body.clear()
	if health <= 0:
		for i in xpDropped:
			var xporb = xpScene.instantiate()
			$"/root/Main".add_child(xporb)
			xporb.init(global_position)
			xporb.set_meta("isorb", true)
		queue_free()
	pass # Replace with function body.
