extends Node

onready var music_player = $MusicPlayer
onready var select_sound_player = $SelectSoundPlayer
onready var shoot_sound_player = $ShootSoundPlayer
onready var explode_sound_player = $ExplodeSoundPlayer
onready var hurt_sound_player = $HurtSoundPlayer

export(Array, AudioStream) var explode_sounds
export(Array, AudioStream) var shoot_sounds
export(AudioStream) var player_hurt_sound
export(AudioStream) var select_sound

var settings
var wave_number
var current_wave_number
export var max_level = 10

func _ready():
	_load_settings()
	_load_wave_number()
	current_wave_number = wave_number

func _process(delta):
	if Input.is_action_just_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen

func _save_settings(to_save):
	settings = to_save
	var file = File.new()
	file.open("user://settings.save", File.WRITE)
	file.store_var(settings)
	file.close()
	
func _load_settings():
	var file = File.new()
	if file.file_exists("user://settings.save"):
		file.open("user://settings.save", File.READ)
		settings = file.get_var()
		file.close()
	else:
		settings = {"music": true, "sfx": true}
		_save_settings(settings)
		
func _save_wave_number(to_save):
	wave_number = to_save
	if wave_number > max_level:
		wave_number = max_level
	var file = File.new()
	file.open("user://level.save", File.WRITE)
	file.store_var(wave_number)
	file.close()
	
func _load_wave_number():
	var file = File.new()
	if file.file_exists("user://level.save"):
		file.open("user://level.save", File.READ)
		wave_number = file.get_var()
		file.close()
	else:
		wave_number = 1
		_save_wave_number(wave_number)
		
func _play_select_sound():
	if(settings["sfx"]):
		if select_sound_player.stream != select_sound:
			select_sound_player.stream = select_sound
		select_sound_player.play()
		yield(select_sound_player, "finished")
		
func _play_shoot_sound(number):
	if(settings["sfx"]):
		if shoot_sound_player.stream != shoot_sounds[number]:
			shoot_sound_player.stream = shoot_sounds[number]
		shoot_sound_player.play()
		yield(select_sound_player, "finished")
		
func _play_explode_sound(number):
	if(settings["sfx"]):
		if explode_sound_player.stream != explode_sounds[number]:
			explode_sound_player.stream = explode_sounds[number]
		explode_sound_player.play()
		yield(select_sound_player, "finished")
		
func _play_hurt_sound():
	if(settings["sfx"]):
		if hurt_sound_player.stream != player_hurt_sound:
			hurt_sound_player.stream = player_hurt_sound
		hurt_sound_player.play()
		yield(select_sound_player, "finished")
