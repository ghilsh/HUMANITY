extends Area2D

export(String, FILE, "*.tscn") var to_scene = ""
export(Vector2) var spawnpoint
export(String) var song

onready var transitionScreen = Global.TransitionScreen

func _ready():
	var _err = connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.is_in_group("player"):
		transitionScreen.transition(to_scene, song)
		get_tree().call_group("player", "change_state", "BLOCKED")
		get_tree().call_group("npc", "spoooooooky")
		Global.player_pos = spawnpoint
		
		if self.is_in_group("killerfish"):
			killerfish()

func killerfish():
	if self.is_in_group("killerfish"):
		Global.killerfish += 1
		if Global.killerfish >= 4:
			var randint = randi() % 2
			if randint == 0:
				Global.TransitionScreen.transition("res://Scenes/Rooms/Cutscene.tscn")
				Global.killerfish = 0
