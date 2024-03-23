extends Node

#game
signal start()
signal died(posX,posY)
signal gainxp()
signal levelup(level)
signal clear()
signal livesChanged(lives) #mainly to update gui
signal powerup()

#GUI and sound
signal mainmenu()
signal credits()
signal help()
signal updatevolume(type, val)


#upgrade signals
signal xpup()
signal bulletSpeed()
signal bulletDamage()
signal bulletFiringSpeed()
signal missileAmount()
signal missileDamage()
signal extralife() #life addition





#this is a singleton so i might as well add some global variables~~~
var extraxp = 0
func _on_xpup():
	extraxp += 1
func _on_clear():
	extraxp = 0
