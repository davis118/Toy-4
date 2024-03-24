extends Control


func exist():
	$AnimationPlayer.play("gameoverin")

	
func stopExist():
	if visible == true:
		$AnimationPlayer.play("gameoverout")
	
# Called when the node enters the scene tree for the first time.
func _ready():
	bus.connect("died", exist)
	bus.connect("start", stopExist)
	bus.connect("mainmenu", stopExist)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

