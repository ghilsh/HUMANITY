extends Camera2D

var is_tweening_down = false

func _ready():
	add_to_group("camera")
	smoothing_enabled = false
	if get_child_count() > 0:
		var _err = $Tween.connect("tween_all_completed", self, "_on_tween_completed")

func _process(_delta):
	current = Global.camera_on

func toggle_smoothing(smoothing: bool):
	smoothing_enabled = smoothing

func tween_up():
	$Tween.interpolate_property(self, "position", Vector2(0,0), Vector2(0,-100), 1.0, Tween.EASE_OUT)
	if !$Tween.is_active():
		$Tween.start()

func tween_down():
	$Tween.interpolate_property(self, "position", Vector2(0,-100), Vector2(0,0), 1.0, Tween.EASE_OUT)
	if !$Tween.is_active():
		$Tween.start()
		is_tweening_down = true

func _on_tween_completed():
	if is_tweening_down == false:
		get_tree().call_group("npc", "get_dialog")
	if is_tweening_down == true:
		get_tree().call_group("player", "change_state", "IDLE")
		is_tweening_down = false
