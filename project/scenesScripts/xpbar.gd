extends TextureProgressBar



var amount = 1
var level = 0
var label


# Called when the node enters the scene tree for the first time.
func _ready():
	
	bus.connect("gainxp",gainxp)
	bus.connect("clear", clear)
	label = $Label2
	max_value = 7
	value = 0

func clear():
	max_value=7
	value = 0
	amount=1
	level=0
	label.text="Level: " + str(level)
	
	
func gainxp():
	
	value += amount
	if value >= max_value:
		value -= max_value
		max_value = round(max_value * 1.1)
		
		level += 1
		print("leveled up")
		label.text="Level: " + str(level)
		
		bus.emit_signal("levelup",level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
