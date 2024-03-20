extends CharacterBody2D
var player
var speed = 300
var expl = preload("res://scenesScripts/explodepart.tscn")
var acc = 0
var direction


var bus
func setDir(dir):
	direction = dir
	rotation = atan2(direction.y,direction.x)

func clear():
	var part = expl.instantiate()
	$"/root/Main".add_child(part)
	part.go(velocity,global_position,0.5)
	queue_free()

func _ready():
	bus = $"/root/Main/bus"
	bus.connect("clear",clear)
	$CollisionShape2D.scale = Vector2(0,0)
	
	if has_node("/root/Main/player"):
		player = $"/root/Main/player"
		
		direction = (player.global_position - global_position).normalized()
		rotation = atan2(direction.y,direction.x)
		var animp = $AnimationPlayer
		animp.current_animation = "spawn"
		animp.speed_scale = 3
		
	else:
		queue_free()


func _physics_process(delta):
	if player:
		speed += acc*delta
		velocity = direction * speed
	move_and_slide()
