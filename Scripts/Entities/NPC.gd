extends StaticBody2D

var active = false
var dialogStatus = false
var talkedto = 0
var death_count = Global.death_count
var dialog_trigger_active = false

onready var Textbox = Global.Textbox

export (String, "intro", "bullets", "deaths", "patience", "lastroom", "final", "weird", "cool", "placeholder") var dialog = "placeholder"

func _ready():
	talkedto = 0

func _process(_delta):
	death_count = Global.death_count
	if Textbox.current_state == Textbox.State.READING && (active || dialog_trigger_active):
		$AnimationPlayer.play("talk")
	if Textbox.current_state == Textbox.State.FINISHED:
		$Sprite.frame = 0

func _input(event):
	if Textbox.is_visible() == false:
		if event.is_action_pressed("ui_accept") && active:
			get_dialog()
		if Textbox.text_queue.empty() && dialogStatus:
			dialog_status()
			if self.is_in_group("final"):
				get_tree().call_group("transitionscreen", "final_transition")
				get_tree().call_group("overlay", "stop_timer")
			elif self.is_in_group("intro") && dialog_trigger_active:
				get_tree().call_group("camera", "tween_down")
			else: get_tree().call_group("player", "change_state", "IDLE")

func get_dialog():
	Global.Textbox.change_text_sound("npc")
	get_tree().call_group("dialogtree", "get_dialog", dialog, talkedto)
	get_tree().call_group("player", "change_state", "BLOCKED")
	talkedto += 1

func _on_Hitbox_body_entered(body):
	if body.is_in_group("dialogHBox"):
		active = true

func _on_Hitbox_body_exited(body):
	if body.is_in_group("dialogHBox"):
		active = false

func _on_BlinkTimer_timeout():
	if Textbox.current_state != Textbox.State.READING:
		$AnimationPlayer.play("blink")
	$BlinkTimer.wait_time = [2,3,4,5,6,7,8,9,10][randi() % 8]
	$BlinkTimer.start()

func _on_DialogTrigger_body_entered(body):
	if body.is_in_group("player") && (Global.triggered_cutscene == false || !$DialogTrigger.is_in_group("cutscene1")):
		dialog_trigger_active = true
		get_tree().call_group("camera", "tween_up")
		get_tree().call_group("player", "change_state", "BLOCKED")

func _on_DialogTrigger_body_exited(body):
	if body.is_in_group("player"):
		dialog_trigger_active = false

func dialog_status():
	dialogStatus = not dialogStatus

func spoooooooky():
	var randint = randi() % 1000
	if randint == 1:
		$BlinkTimer.stop()
		$Sprite.frame = 3
