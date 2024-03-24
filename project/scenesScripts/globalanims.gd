extends AnimationPlayer


# Called when the nod
#e enters the scene tree for the first time.
func lvlup(level):
	speed_scale = 1
	play("slow")
	
	pass
func powerup():
	#print("AAAAAAAISDAIFJEF")
	
	play("resume")
	pass
func died():
	if get_meta("tween") != 1:
		play("resume")
func _ready():
	
	bus.connect("levelup",lvlup)
	bus.connect("resume",powerup)
	bus.connect("died",died)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tween = get_meta("tween")
	if tween != 0:
		speed_scale = 1/tween
	
	pass
