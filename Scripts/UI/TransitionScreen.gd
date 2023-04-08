extends CanvasLayer

signal transitioned
signal transitioned_final
var new_scene
var current_song

func transition(to_scene: String, new_song: String = ""):
	$AnimationPlayer.play("fade_to_black")
	new_scene = to_scene
	current_song = new_song

func final_transition():
	$AnimationPlayer.play("final_transition")
	$AudioStreamPlayer.play()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		emit_signal("transitioned")
		$AnimationPlayer.play("fade_to_normal")
	if anim_name == "final_transition":
		emit_signal("transitioned_final")
		$AnimationPlayer.play("final_transition_end")

func _on_TransitionScreen_transitioned():
	var _err = get_tree().change_scene(new_scene)
	if current_song != "":
		Global.change_music(current_song)
	if new_scene == "res://Scenes/Rooms/Room_1.tscn":
		if get_tree().get_nodes_in_group("overlay") == []:
			Global.activate_overlay()
	get_tree().call_group("paused", "close_pause")

func _on_TransitionScreen_transitioned_final():
#	var _err = get_tree().change_scene("res://Scenes/Rooms/Cutscene.tscn")
	var _err = get_tree().change_scene("res://Scenes/Rooms/Room_End.tscn")
