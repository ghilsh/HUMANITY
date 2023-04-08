extends Control

onready var _Continue = $PauseMenu/Continue
onready var _Options = $PauseMenu/Options
onready var _Menu = $PauseMenu/Menu
onready var _Quit = $PauseMenu/Quit
onready var SelectSound = $"../SelectSound"

enum {STATE_MAIN, STATE_OPTIONS}
var state = STATE_MAIN

func _ready():
	var _err0 = _Continue.connect("focus_entered", self, "_on_focus_entered")
	var _err1 = _Options.connect("focus_entered", self, "_on_focus_entered")
	var _err2 = _Menu.connect("focus_entered", self, "_on_focus_entered")
	var _err3 = _Quit.connect("focus_entered", self, "_on_focus_entered")

func _process(_delta):
	match state:
		STATE_MAIN:
			$Options.visible = false
			$Title.visible = true
			$PauseMenu.visible = true
		STATE_OPTIONS:
			$Options.visible = true
			$Title.visible = false
			$PauseMenu.visible = false

func toggle_pause():
	var scene = get_tree().get_current_scene()
	if !scene.is_in_group("cantpause"):
		if state == STATE_MAIN:
			var new_pause_state = !get_tree().paused
			get_tree().paused = !get_tree().paused
			self.visible = new_pause_state
			
			_Continue.grab_focus()
			change_state("MAIN")
		else:
			get_tree().call_group("paused", "change_state", "MAIN")
			_Continue.grab_focus()

func close_pause():
	get_tree().paused = false
	self.visible = false

func change_state(new_state: String):
	match new_state:
		"MAIN":
			state = STATE_MAIN
			_Continue.grab_focus()
		"OPTIONS":
			state = STATE_OPTIONS
			$Options.grab_focus()

func _on_focus_entered():
	SelectSound.play()

func _on_Continue_pressed():
	toggle_pause()

func _on_Menu_pressed():
	Global.to_title()

func _on_Options_pressed():
	change_state("OPTIONS")

func _on_Quit_pressed():
	if OS.has_feature("web"):
		$DenySound.play()
	else: get_tree().quit()
