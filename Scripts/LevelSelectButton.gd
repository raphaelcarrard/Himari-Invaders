extends Button

export(int) var level

onready var persistent = get_node("/root/Persistent")

func _ready():
	get_tree().paused = false
	connect("pressed", self, "_on_click")
	
	if level > persistent.wave_number:
		disabled = true
		
func _on_click():
	persistent.current_wave_number = level
	get_tree().change_scene("res://Scenes/Levels/Level1.tscn")
