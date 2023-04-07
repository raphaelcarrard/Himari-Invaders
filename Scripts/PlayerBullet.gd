extends Sprite

export var speed = 1000

func _process(delta):
	position += Vector2(0, -speed) * delta
	
func _on_Area2D_area_entered(_area):
	queue_free()
