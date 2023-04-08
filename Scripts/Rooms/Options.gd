extends Node2D

onready var _ControlConfig = $Menu/VBoxContainer/ControlConfig
onready var _MusicToggle = $Menu/VBoxContainer/MusicToggle
onready var _FullScreenToggle = $Menu/VBoxContainer/FullScreenToggle
onready var _TimerToggle = $Menu/VBoxContainer/TimerToggle
onready var _PermaDeath = $Menu/VBoxContainer/PermaDeath
onready var _Back = $Menu/VBoxContainer/Back

onready var transitionScreen = Global.TransitionScreen

func _ready():
#	$Menu/VBoxContainer/ControlConfig.grab_focus()
	grab_focus()
	
	var _err0 = _ControlConfig.connect("focus_entered", self, "_on_focus_entered")
	var _err1 = _MusicToggle.connect("focus_entered", self, "_on_focus_entered")
	var _err2 = _FullScreenToggle.connect("focus_entered", self, "_on_focus_entered")
	var _err3 = _TimerToggle.connect("focus_entered", self, "_on_focus_entered")
	var _err4 = _PermaDeath.connect("focus_entered", self, "_on_focus_entered")
	var _err5 = _Back.connect("focus_entered", self, "_on_focus_entered")

func _process(_delta):
	match Global.music_enabled:
		true: _MusicToggle.text = "Music: ON"
		false: _MusicToggle.text = "Music: OFF"
	match Global.timer_initiated:
		true: _TimerToggle.text = "Timer: ON"
		false: _TimerToggle.text = "Timer: OFF"
	match OS.window_fullscreen:
		true: _FullScreenToggle.text = "Full Screen: ON"
		false: _FullScreenToggle.text = "Full Screen: OFF"
	match Global.perma_death:
		true: _PermaDeath.text = "Perma Death: ON"
		false: _PermaDeath.text = "Perma Death: OFF"

func grab_focus():
	$Menu/VBoxContainer/MusicToggle.grab_focus()

func _on_focus_entered():
	$SelectSound.play()

func _on_Control_Config_pressed():
	transitionScreen.transition("res://Scenes/Rooms/ControlConfig.tscn")

func _on_MusicToggle_pressed():
	Global.music_enabled = not Global.music_enabled

func _on_FullScreenToggle_pressed():
	OS.window_fullscreen = not OS.window_fullscreen

func _on_TimerToggle_pressed():
	Global.timer_initiated = not Global.timer_initiated

func _on_PermaDeath_pressed():
	Global.perma_death = not Global.perma_death

func _on_Back_pressed():
	if get_tree().paused == true:
		get_tree().call_group("paused", "change_state", "MAIN")
	else:
		transitionScreen.transition("res://Scenes/Rooms/Title.tscn")
