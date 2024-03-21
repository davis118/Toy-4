extends CharacterBody2D

var bus

func init(pos):
	global_position = pos + Vector2(randf_range(-50,50),randf_range(-50,50))
	velocity = Vector2(0, 0)

func _ready():
	bus = $"/root/Main/bus"
	bus.connect("clear",clear)

func clear():
	queue_free()

func _physics_process(delta):
	velocity = velocity + Vector2(randf_range(-100,100), randf_range(-100,100))*delta
	global_position += velocity*delta



func pickup():
	bus.emit_signal("gainxp")
	queue_free()
