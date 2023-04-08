extends Area2D

var speed
var direction
var velocity

#onready var new_parent = get_parent().get_parent().get_parent()
#onready var spawner = get_parent()

#func _ready():
#	position = spawner.position
#	get_parent().remove_child(self)
#	new_parent.add_child(self)

func _physics_process(_delta):
	position += direction

func _on_Bullet_Spawn_body_entered(body):
	if body.is_in_group("player"):
		get_tree().call_group("player", "on_death")

func set_speed(new_speed, new_direction):
	speed = new_speed
	direction = new_direction
	direction *= speed
