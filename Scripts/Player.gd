extends Sprite

signal spawn_bullet(bullet)
signal update_health(health)
signal die()

onready var bullet_scene = preload("res://Scenes/GameObjects/PlayerBullet.tscn")

export var speed = 500
export var bullet_speed = 1000
export var y_bullet_offset = 30
export var time_between_bullets = 0.25
export var health = 3
export var x_distance_from_edge = 20

var time_to_next_bullet = -1
var screen_width = ProjectSettings.get_setting("display/window/size/width")

var pause_time

func _ready():
	get_node("../Menu").connect("pause", self, "_pause")
	get_node("../Menu").connect("resume", self, "_resume")
	
func _process(delta):
	if Input.is_action_pressed("ui_left"):
		position += Vector2(-speed, 0) * delta
	if Input.is_action_pressed("ui_right"):
		position += Vector2(speed, 0) * delta
		
	if position.x < x_distance_from_edge:
		position.x = x_distance_from_edge
	elif position.x > screen_width - x_distance_from_edge:
		position.x = screen_width - x_distance_from_edge
		
	if Input.is_action_pressed("ui_accept") and OS.get_ticks_usec() > time_to_next_bullet:
		time_to_next_bullet = OS.get_ticks_usec() + time_between_bullets * 1000000
		var bullet = bullet_scene.instance();
		bullet.position = position + Vector2(0, -y_bullet_offset)
		bullet.speed = bullet_speed
		bullet.z_index = -10
		bullet.add_to_group("bullets")
		
		emit_signal("spawn_bullet", bullet, 0)
		
func _on_Area2D_area_entered(_area):
	health -= 1
	emit_signal("update_health", health)
	if health <= 0:
		_die()
		
func _die():
	emit_signal("die")
	visible = false
	time_to_next_bullet = INF
	
func _pause():
	pause_time = OS.get_ticks_usec()
	
func _resume():
	time_to_next_bullet += OS.get_ticks_usec() - pause_time
