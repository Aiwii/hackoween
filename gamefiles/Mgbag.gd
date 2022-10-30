extends Sprite

var mospos

signal mUP

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(_delta):
	mospos = get_global_mouse_position()
	position.x = mospos.x
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	emit_signal("mUP")
	body.die()
