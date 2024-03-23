extends Timer
var originalTime 
var time

# Called when the node enters the scene tree for the first time.
func _ready():
	originalTime = wait_time


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	wait_time = originalTime * 1
