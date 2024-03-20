extends CPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func go(dir,pos,mult):
	#print("a")
	global_position = pos
	emitting = true
	amount *= mult
	lifetime *= mult
	initial_velocity_max *= mult
	direction = dir.normalized()
	$Timer.start()
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	queue_free()
	pass # Replace with function body.
