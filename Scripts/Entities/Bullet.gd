extends Area2D

onready var path_follow = get_parent()
onready var path = get_parent().get_parent()
onready var wait_timer = $"Wait Timer"
onready var spawn_timer = $"Spawner Timer"
onready var bulletspawn_scene = preload("res://Scenes/Entities/BulletSpawn.tscn")

export(int) var speed = 250
export(float) var wait = 0.0
export(float) var spawn_time = 0.0
export(int) var spawn_speed = 0
export(Vector2) var spawn_direction 

var previous_offset = 0.0
var waiting = false
var newDirection = false

func _ready():
	if wait > 0:
		wait_timer.wait_time = wait
	if spawn_time > 0.0:
		spawn_timer.wait_time = spawn_time
		spawn_timer.start()
		spawn_bullet()

func _physics_process(delta):
	if get_parent() is PathFollow2D:
		previous_offset = path_follow.offset
		
		if waiting == false:
			path_follow.set_offset(path_follow.get_offset() + speed * delta)
			
		if path_follow.offset < previous_offset and newDirection:
			newDirection = false
			trigger_wait()
		if path_follow.unit_offset > 0.5 and newDirection == false:
			newDirection = true
			trigger_wait()

func _on_Bullet_body_entered(body):
	if body.is_in_group("player"):
		get_tree().call_group("player", "on_death")

func trigger_wait():
	if wait > 0:
		waiting = true
		wait_timer.start()

func spawn_bullet():
	var bulletspawn = bulletspawn_scene.instance()
	add_child(bulletspawn)
	bulletspawn.set_speed(spawn_speed, spawn_direction)

func _on_Wait_Timer_timeout():
	waiting = false

func _on_Spawner_Timer_timeout():
	spawn_bullet()
	spawn_timer.start()
