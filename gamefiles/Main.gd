extends Node

enum states {HOUSE, MINIGAME, OVERVIEW, TIMER}
var curstate


# Called when the node enters the scene tree for the first time.
func _ready():
	curstate = states.OVERVIEW

func runOverview():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
