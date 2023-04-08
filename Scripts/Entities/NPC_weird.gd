extends "res://Scripts/Entities/NPC.gd"

export (int) var teehee

func _ready():
	if Global.weird < teehee:
		self.queue_free()
	else: Global.weird = 0
