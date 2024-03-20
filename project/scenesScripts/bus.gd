extends Node


signal start()

signal died(posX,posY)

signal mainMenu()

signal clear()

signal credits()
signal help()


func _on_start():
	emit_signal("clear")
	pass # Replace with function body.
