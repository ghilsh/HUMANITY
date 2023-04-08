extends Area2D

func _ready():
	var _err = connect("area_exited", self, "_on_Bullet_area_exited")

func _on_Bullet_area_exited(area: Area2D):
	if area.is_in_group("bullets"):
		area.queue_free()
