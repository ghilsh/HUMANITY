extends Node2D

var dialogStatus := false
var paused := 0

func _ready():
	dramatic_pause(5)
	Global.Textbox.change_text_sound("normal")
	Ngio.request("Medal.unlock", {"id": 73354})
	if Global.death_count == 0:
		Ngio.request("Medal.unlock", {"id": 73355})
	if Global.time < 180:
		Ngio.request("Medal.unlock", {"id": 73357})

func _input(_event):
	if Global.Textbox.text_queue.empty() && Global.Textbox.is_visible() == false && dialogStatus:
		if Global.death_count == 0:
			if paused <= 1:
				dramatic_pause(2)
			else: Global.to_title()
		else:
			Global.TransitionScreen.transition("res://Scenes/Rooms/Room_1.tscn", "ambience")
			Global.timer_on = true
			Global.reset()
		dialogStatus = false

func _on_DramaticPause_timeout():
	if paused == 0:
		get_tree().call_group("dialogtree", "get_dialog", "ending", 0)
	else: true_ending()
	paused += 1

func true_ending():
	Global.change_music("trueend")
	get_tree().call_group("dialogtree", "get_dialog", "trueending", 0)

func dialog_status():
	dialogStatus = true

func dramatic_pause(time: int):
	$DramaticPause.wait_time = time
	$DramaticPause.start()
