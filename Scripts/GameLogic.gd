extends Node2D

signal win
signal lose
signal pause

onready var player_scene = preload("res://Scenes/GameObjects/Player.tscn")

onready var persistent = get_node("/root/Persistent")

onready var previous_health

var enemy_wave
var player

func _ready():
	connect("lose", $Menu, "_on_Game_lose")
	connect("win", $Menu, "_on_Game_win")
	connect("pause", $Menu, "_on_Game_pause")
	
	_start(persistent.current_wave_number)
	
func _on_spawn_bullet(bullet, type):
	persistent._play_shoot_sound(type)
	add_child(bullet)
	
func _on_Enemy_die():
	persistent._play_explode_sound(1)
	
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() <= 1:
		_win()
		
func _win():
	emit_signal("win")
	
	persistent.current_wave_number += 1
	if persistent.wave_number < persistent.current_wave_number:
		persistent._save_wave_number(persistent.current_wave_number)
		
func _lose():
	emit_signal("lose")
	
func _on_Player_die():
	persistent._play_explode_sound(0)
	_lose()
	
func _start(enemy_wave_number):
	$UI/LevelNumber.text = "Level " + str(enemy_wave_number)
	
	if enemy_wave_number <= persistent.max_level:
		enemy_wave = load("res://Scenes/EnemyWaves/Wave" + str(enemy_wave_number) + ".tscn").instance()
	else:
		get_tree().change_scene("res://Scenes/WinScreen.tscn")
		return
		
	add_child(enemy_wave)
	
	player = player_scene.instance()
	player.connect("die", self, "_on_Player_die")
	player.connect("spawn_bullet", self, "_on_spawn_bullet")
	player.connect("update_health", self, "_on_update_health")
	add_child(player)
	
	previous_health = player.health
	
	_on_update_health(player.health)
	
func _restart(enemy_wave_number):
	enemy_wave.queue_free()
	player.queue_free()
	
	for bullet in get_tree().get_nodes_in_group("bullets"):
		bullet.queue_free()
		
	_start(enemy_wave_number)
	
func _on_update_health(health):
	if health < previous_health:
		persistent._play_hurt_sound()
	
	previous_health = health
	
	for i in 3:
		get_node("UI/Heart" + str(i + 1)).visible = health > i
