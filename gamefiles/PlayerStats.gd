extends Node

export (String) var pname

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
 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
