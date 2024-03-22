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
	velocity = velocity + Vector2(randf_range(-100,100), randf_range(-100,100))*delta*Glob.gamespeed
	global_position += velocity*delta*Glob.gamespeed



func pickup():
	visible = false
	$noise.pitch_scale = randf_range(1.5,2.0)
	$noise.play()

func _on_audio_stream_player_finished():
	queue_free()
	pass # Replace with function body.
