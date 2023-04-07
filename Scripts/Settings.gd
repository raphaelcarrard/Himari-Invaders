extends Control

onready var sfx_setting = $VBoxContainer/HBoxContainer/SettingsBox/SFXSettingBox/SFXSetting
onready var persistent = get_node("/root/Persistent")

func _ready():
	var settings = persistent.settings
	sfx_setting.pressed = settings["sfx"]
	
func _on_MenuButton_pressed():
	persistent._play_select_sound()
	get_tree().change_scene("res://Scenes/MainMenu.tscn")

func _on_SFXSetting_toggled(_button_pressed):
	var settings = {"sfx": sfx_setting.pressed}
	persistent._save_settings(settings)
	persistent._play_select_sound()
	
func _on_ResetProgressButton_pressed():
	persistent._play_select_sound()
	persistent._save_wave_number(1)

func _on_OnButton_pressed():
	 persistent.music_player.play()

func _on_OffButton_pressed():
	persistent.music_player.stop()
