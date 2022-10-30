extends Node

export (String) var pname

export (int) var timeleft

#attributes
export (int,0,10) var speed #how much time passes between houses
export (int,0,10) var charm #how much candy is dropped
export (int,0,10) var skill #likihood of door being answered
export (int) var apoints

#inventory
export (int,0,999) var kingsize
export (int,0,999) var cans
export (int,0,999) var treatbags
export (int,0,999) var snacksize
export (int,0,999) var chips
export (int,0,999) var candies
export (int,0,999) var water
export (int,0,999) var veggies
export (int,0,999) var fruit
 
signal spdchange
signal chachange
signal sklchange

signal changefail

signal outoftime

# Called when the node enters the scene tree for the first time.
func _ready():
	timeleft = 420
	apoints = 10
	
	return

func calctimeloss():
	var umtloss = 30
	umtloss -= speed*2
	
	timeleft = timeleft - umtloss
	
	if timeleft < 0:
		timeleft = 0
		emit_signal("outoftime")
	
	yield(get_tree(), "idle_frame")
	return

func _on_SKLButton_pressed():
	if apoints > 0 && skill <= 10:
		apoints -= 1
		skill += 1
		emit_signal("sklchange")
	else:
		emit_signal("changefail")


func _on_CHAButton_pressed():
	if apoints > 0 && charm <= 10:
		apoints -= 1
		charm += 1
		emit_signal("chachange")
	else:
		emit_signal("changefail")


func _on_SPDButton_pressed():
	if apoints > 0 && speed <= 10:
		apoints -= 1
		speed += 1
		emit_signal("spdchange")
	else:
		emit_signal("changefail")
