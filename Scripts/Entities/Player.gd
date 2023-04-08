extends KinematicBody2D

var velocity := Vector2.ZERO
var speed := 200

enum { STATE_BLOCKED, STATE_IDLE, STATE_WALKING }
var state = STATE_IDLE

onready var scene_deathanim = preload("res://Scenes/Particles/DeathAnim.tscn")

func _ready():
	if Global.player_pos != Vector2(0, 0):
		 position = Global.player_pos
	else: Global.player_pos = position
	
	$Sprite.frame = Global.global_sprite

func _physics_process(_delta):
	Global.death_pos = position
	Global.global_sprite = $Sprite.get_frame()
	
	# MOVEMENT
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if state != STATE_BLOCKED:
		velocity = move_and_slide(velocity)
	
	# STATES
	match state:
		STATE_BLOCKED:
			velocity = Vector2.ZERO
		STATE_IDLE:
			if input_vector != Vector2.ZERO:
				change_state("WALKING")
		STATE_WALKING:
			velocity = input_vector * speed
			if input_vector == Vector2.ZERO:
				change_state("IDLE")
	
	# ANIMATION
	if velocity != Vector2.ZERO:
		$AnimationTree.set("parameters/Idle/blend_position", velocity)
		$AnimationTree.set("parameters/Walk/blend_position", velocity)
		$AnimationTree.get("parameters/playback").travel("Walk")
	else:
		$AnimationTree.get("parameters/playback").travel("Idle")
	
	# DEBUG STUFF
	if Global.debug:
		if Input.is_action_pressed("ui_cancel"):
			speed = 400
		else: speed = 200
		
		if Input.is_action_pressed("ui_select") && state == STATE_BLOCKED:
			change_state("IDLE")
		
		if Input.is_action_pressed("ui_end"):
			collision_layer = 2
			collision_mask = 2
		else:
			collision_layer = 1
			collision_mask = 1
		
		if Input.is_action_just_pressed("debug_overlay"):
			Global.activate_overlay()

func change_state(new_state: String):
	match new_state:
		"BLOCKED":
			state = STATE_BLOCKED
		"IDLE":
			state = STATE_IDLE
		"WALKING":
			state = STATE_WALKING

func on_death():
	if state != STATE_BLOCKED && (Global.debug == false || !Input.is_action_pressed("ui_select")):
		Ngio.request("Medal.unlock", {"id": 73359})
		Global.camera_on = false
		Global.death_count += 1
		death_anim()
		change_state("BLOCKED")
		position = Global.player_pos
		$AnimationPlayer.play("death")
		get_tree().call_group("camera", "toggle_smoothing", true)

func death_anim():
	var root = get_tree().get_root()
	var current_scene = root.get_child(3)
	
	var deathanim = scene_deathanim.instance()
	current_scene.add_child(deathanim)
	deathanim.z_index = 999

func respawn():
	$AnimationPlayer.play("respawn")
	change_state("IDLE")
	Global.camera_on = true

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death" && Global.perma_death:
		Global.TransitionScreen.transition("res://Scenes/Rooms/Room_1.tscn", "ambience")
		Global.reset()
	if anim_name == "respawn":
		get_tree().call_group("camera", "toggle_smoothing", false)
