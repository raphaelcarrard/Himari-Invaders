extends Button

func _on_ReturnButton_pressed():
	$"/root/Persistent"._play_select_sound()
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
