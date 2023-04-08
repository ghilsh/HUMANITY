extends CanvasLayer

#const CHAR_READ_RATE = 0.05
const CHAR_READ_RATE = 0.035

onready var textbox_container = $TextboxContainer
onready var start_symbol = $TextboxContainer/MarginContainer/HBoxContainer/Start
onready var label = $TextboxContainer/MarginContainer/HBoxContainer/Label
onready var borders = $Borders

enum State {
	READY,
	READING,
	FINISHED
}

var current_state = State.READY
var text_queue = []

func _ready():
	$TextSoundPlayer.play("Pause")
	hide_textbox()
	
func _process(_delta):
	$TextSoundPlayer.play("Pause")
	match current_state:
		State.READY:
			if !text_queue.empty():
				display_text()
		State.READING:
			$TextSoundPlayer.play("Play")
			if Input.is_action_just_pressed("ui_cancel"):
				label.percent_visible = 1.0
				$Tween.remove_all()
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept") or !is_visible():
				change_state(State.READY)
				if text_queue.empty():
					hide_textbox()

func queue_text(next_text):
	text_queue.push_back(next_text)

func hide_textbox():
	start_symbol.text = " "
	label.text = " "
	textbox_container.hide()
	borders.hide()
	text_queue = []

func show_textbox():
	start_symbol.text = "*"
	textbox_container.show()
	borders.show()
	
func display_text():
	var next_text = text_queue.pop_front()
	label.text = next_text
	label.percent_visible = 0.0
	change_state(State.READING)
	show_textbox()
	$Tween.interpolate_property(label, "percent_visible", 0.0, 1.0, len(next_text) * CHAR_READ_RATE, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Tween_tween_completed(_object, _key):
	change_state(State.FINISHED)

func change_state(next_state):
	current_state = next_state

func change_text_sound(sound):
	var stream: AudioStream
	stream = load("res://Assets/Sounds/snd_text_"+sound+".wav")
	$TextSound.set_stream(stream)

func is_visible():
	return $TextboxContainer.is_visible()
