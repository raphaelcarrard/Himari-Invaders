extends Sprite

signal enemy_died
signal spawn_bullet(bullet)

onready var bullet_scene = preload("res://Scenes/GameObjects/EnemyBullet.tscn")

export var bullet_speed = 1000
export var time_between_bullets = [0.75, 1.25]
export var y_bullet_offset = 40
export var wave_speed_range = [10, 13]
export var wave_amount_range = [10, 15]

var wave_speed
var wave_amount
var time_of_next_bullet = 0
var save_time_of_next_bullet = 0
var origin

var pause_time
var time_in_pause = 0

func _ready():
	connect("enemy_died", get_node("../../../Game"), "_on_Enemy_die")
	connect("spawn_bullet", get_node("../../../Game"), "_on_spawn_bullet")
	get_node("../../Menu").connect("pause", self, "_pause")
	get_node("../../Menu").connect("resume", self, "_resume")
	wave_speed = rand_range(wave_speed_range[0], wave_speed_range[1])
	wave_amount = rand_range(wave_amount_range[0], wave_amount_range[1])
	origin = position
	add_to_group("enemies")
	_set_time_of_next_bullet()
	
func _process(delta):
	position.x = origin.x + sin((((OS.get_ticks_usec() - time_in_pause) * 0.000001) + 9999) * ((PI * 2) / wave_speed)) * wave_amount
	
	if OS.get_ticks_usec() > time_of_next_bullet:
		_set_time_of_next_bullet()
		var bullet = bullet_scene.instance()
		bullet.position = position + Vector2(0, y_bullet_offset)
		bullet.speed = bullet_speed
		bullet.z_index = -10
		bullet.add_to_group("bullets")
		emit_signal("spawn_bullet", bullet, 1)
		
func _on_Area2D_area_entered(_area):
	emit_signal("enemy_died")
	queue_free()
	
func _set_time_of_next_bullet():
	time_of_next_bullet = OS.get_ticks_usec() + rand_range(time_between_bullets[0], time_between_bullets[1]) * 1000000

func _pause():
	pause_time = OS.get_ticks_usec()
	save_time_of_next_bullet = time_of_next_bullet
	time_of_next_bullet = INF
	
func _resume():
	time_in_pause += OS.get_ticks_usec() - pause_time
	time_of_next_bullet = save_time_of_next_bullet + OS.get_ticks_usec() - pause_time
