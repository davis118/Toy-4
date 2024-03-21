extends TextureProgressBar

var bus

var amount = 1
var level = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	bus = $"/root/Main/bus"
	bus.connect("gainxp",gainxp)
	bus.connect("clear", clear)
	max_value = 7
	value = 0

func clear():
	max_value=7
	value = 0
	amount=1
	level=0
	$Label.text="Level: " + str(level)
	
func gainxp():
	print("whyyy")
	value += amount
	while value >= max_value:
		value -= max_value
		max_value += 2
		level += 1
		print("leveled up")
		$Label.text="Level: " + str(level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
