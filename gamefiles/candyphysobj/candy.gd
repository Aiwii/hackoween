extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity.y = 1000
	pass # Replace with function body.

func set_pos(pos):
	position = pos

func die():
	sleeping = true
	$CollisionShape2D.queue_free()
	$Tween.interpolate_property($Sprite, "scale", Vector2(1,1), Vector2(0,0), 1,Tween.TRANS_CIRC,Tween.EASE_OUT)
	$Tween.interpolate_property($Sprite, "rotation_degrees", 0, 360, 2,Tween.TRANS_CIRC,Tween.EASE_OUT)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	self.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
