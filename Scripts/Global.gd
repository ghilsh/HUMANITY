extends Node

var debug = false
var first_time = true
var weird = 0
var player_pos = Vector2()
var death_pos = Vector2()
var death_count = 0
var global_sprite = 0
var default_sprite
var time = 0
var timer_on = true
var timer_initiated = false
var triggered_cutscene = false
var music_enabled = true
var camera_on = true
var perma_death = false
var current_song: String
var fading_out := false
var killerfish = 0

var configpath = "res://keybinds.ini"
var configfile
var keybinds = {}

onready var TransitionScreen = $TransitionScreen
onready var Textbox = $Textbox
onready var Pause = $Pause/Paused

func _ready():
	randomize()

func _process(_delta):
	adjust_music_volume()

func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	
	if just_pressed:
		if Input.is_key_pressed(KEY_F4):
			OS.window_fullscreen = !OS.window_fullscreen
		if Input.is_key_pressed(KEY_ESCAPE):
			Pause.toggle_pause()

func change_music(song: String):
	if song == "stop":
		$MusicPlayer.stop()
	elif song == "fade":
		fade_music()
	elif song == "pause":
		$MusicPlayer.stream_paused = not $MusicPlayer.stream_paused
	else:
		end_fade()
		var stream: AudioStreamSample
		stream = load("res://Assets/Sounds/mus_"+song+".wav")
		if song != current_song:
			$MusicPlayer.set_stream(stream)
			$MusicPlayer.play()
			current_song = song

func adjust_music_volume():
	if fading_out == false:
		if music_enabled:
			if get_tree().paused:
				$MusicPlayer.volume_db = -20
			else: $MusicPlayer.volume_db = 0
		else: $MusicPlayer.volume_db = -1000000

func fade_music():
	if music_enabled:
		fading_out = true
		$MusicFadeOut.play("music_fade_out")
	else:
		change_music("stop")

func end_fade():
	$MusicFadeOut.stop()
	if music_enabled: 
		$MusicPlayer.volume_db = 0

func _on_MusicFadeOut_animation_finished(_anim_name):
	$MusicPlayer.stop()
	$MusicPlayer.volume_db = 0
	fading_out = false

func activate_overlay():
	var overlay = load("res://Scenes//UI/Overlay.tscn").instance()
	add_child(overlay)
	overlay.include_timer(timer_initiated)

func to_title():
	reset()
	TransitionScreen.transition("res://Scenes/Rooms/Title.tscn")
	for Node in get_tree().get_nodes_in_group("overlay"):
		Node.queue_free()

func reset():
	death_count = 0
	time = 0
	player_pos = Vector2(0, 0)
	triggered_cutscene = false
	camera_on = true
	randomize_weird()

func randomize_weird():
	weird = randi() % 50
