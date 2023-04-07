extends Control

onready var persistent = get_node("/root/Persistent")

func _ready():
	get_tree().paused = false
	
	if OS.has_feature("web"):
		$VBoxContainer/HBoxContainer2.visible = false
	
func _on_PlayButton_pressed():
	persistent._play_select_sound()
	persistent.current_wave_number = persistent.wave_number
	get_tree().change_scene("res://Scenes/Levels/Level1.tscn")
	
func _on_QuitButton_pressed():
	persistent._play_select_sound()
	get_tree().quit()
	
func _on_SettingsButton_pressed():
	persistent._play_select_sound()
	get_tree().change_scene("res://Scenes/Settings.tscn")
	
func _on_LevelSelect_pressed():
	persistent._play_select_sound()
	get_tree().change_scene("res://Scenes/LevelSelect.tscn")
	
	
