extends Node2D

signal restart
signal pause
signal resume

onready var persistent = get_tree().get_root().get_node("/root/Persistent")

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("ui_select"):
		if get_tree().paused:
			if get_node("VBoxContainer/HBoxContainer/ResumeButton").visible:
				_on_ResumeButton_pressed()
			else:
				_on_RestartButton_pressed()
		else:
				_on_PauseButton_pressed()
				
func _on_PauseButton_pressed():
	persistent._play_select_sound()
	get_tree().paused = true
	$VBoxContainer/HBoxContainer/RestartButton.text = "Restart"
	_show_resume()
	_rename_title("Pause")
	visible = true
	emit_signal("pause")
	
func _on_ResumeButton_pressed():
	persistent._play_select_sound()
	get_tree().paused = false
	visible = false
	emit_signal("resume")
	
func _on_RestartButton_pressed():
	persistent._play_select_sound()
	get_tree().paused = false
	emit_signal("restart", persistent.current_wave_number)
	visible = false
	
func _on_LevelSelectButton_pressed():
	persistent._play_select_sound()
	get_tree().change_scene("res://Scenes/LevelSelect.tscn")
	
func _on_MenuButton_pressed():
	persistent._play_select_sound()
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	
func _on_Game_lose():
	get_tree().paused = true
	emit_signal("pause")
	_hide_resume()
	_rename_title("You Lose")
	$VBoxContainer/HBoxContainer/RestartButton.text = "Restart"
	visible = true
	
func _on_Game_win():
	get_tree().paused = true
	emit_signal("pause")
	_hide_resume()
	_rename_title("You Win!")
	$VBoxContainer/HBoxContainer/RestartButton.text = "Next Level"
	visible = true

func _hide_resume():
	get_node("VBoxContainer/HBoxContainer/ResumeButton").visible = false
	get_node("VBoxContainer/HBoxContainer/Spacer").visible = false
	
func _show_resume():
	get_node("VBoxContainer/HBoxContainer/ResumeButton").visible = true
	get_node("VBoxContainer/HBoxContainer/Spacer").visible = true
	
func _rename_title(title):
	get_node("VBoxContainer/Title").text = title
