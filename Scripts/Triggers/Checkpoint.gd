extends Area2D

export(Vector2) var new_spawnpoint

func _ready():
	var _err = connect("body_entered", self, "_on_body_entered") 

func _on_body_entered(body):
	if body.is_in_group("player"):
		Global.player_pos = new_spawnpoint
