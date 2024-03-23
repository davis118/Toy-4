extends CharacterBody2D
var player
var speed = 20000
var expl = preload("res://scenesScripts/explodepart.tscn")
var acc = 0
var direction
var animp



func setDir(dir):
	direction = dir
	rotation = atan2(direction.y,direction.x)

func clear():
	var part = expl.instantiate()
	$"/root/Main".add_child(part)
	part.go(velocity,global_position,0.5)
	$AudioStreamPlayer.play()
	
	visible = false
	set_collision_layer_value(4,false)

func _ready():
	
	bus.connect("clear",clear)
	$CollisionShape2D.scale = Vector2(0,0)
	
	if has_node("/root/Main/player"):
		player = $"/root/Main/player"
		
		direction = (player.global_position - global_position).normalized()
		rotation = atan2(direction.y,direction.x)
		animp = $AnimationPlayer
		animp.current_animation = "spawn"
		animp.speed_scale = 3
		
	else:
		queue_free()


func _physics_process(delta):
	animp.speed_scale = 1
	if player:
		speed += acc*delta*1
		velocity = direction * speed * delta * 1
	move_and_slide()


func _on_audio_stream_player_finished():
	queue_free()
	pass # Replace with function body.
