extends Node2D

onready var _StartButton = $MainMenu/VBoxContainer/Start
onready var _OptionsButton = $MainMenu/VBoxContainer/Options
onready var _QuitButton = $MainMenu/VBoxContainer/Quit

onready var transitionScreen = Global.TransitionScreen
onready var pauseMenu = Global.Pause

func _physics_process(_delta):
	if ParticlesCache.loaded:
		set_physics_process(false)
		get_tree().call_group("textbox", "hide_textbox")
		get_tree().call_group("textbox", "change_state", 0)
		Global.change_music("title")
		if pauseMenu.get_tree().paused:
			pauseMenu.close_pause()
		
		$MainMenu/VBoxContainer/Start.grab_focus()
		
		var _err0 = _StartButton.connect("focus_entered", self, "_on_focus_entered")
		var _err1 = _OptionsButton.connect("focus_entered", self, "_on_focus_entered")
		var _err2 = _QuitButton.connect("focus_entered", self, "_on_focus_entered")

func _on_focus_entered():
	$SelectSound.play()

func _on_Start_pressed():
	if Global.first_time == true:
		transitionScreen.transition("res://Scenes/Rooms/Instructions.tscn")
	else:
		transitionScreen.transition("res://Scenes/Rooms/Room_1.tscn", "ambience")
		Global.timer_on = true

func _on_Options_pressed():
	transitionScreen.transition("res://Scenes/Rooms/Options.tscn")

func _on_Quit_pressed():
	if OS.has_feature("web"):
		$DenySound.play()
	else: get_tree().quit()
