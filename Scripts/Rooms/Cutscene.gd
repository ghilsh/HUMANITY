extends VideoPlayer

func _ready():
	Global.change_music("pause")

func _on_VideoPlayer_finished():
	Global.change_music("pause")
	Global.TransitionScreen.transition("res://Scenes/Rooms/Room_5.tscn")
