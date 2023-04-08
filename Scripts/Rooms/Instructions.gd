extends Node2D

onready var transitionScreen = Global.TransitionScreen

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		Global.first_time = false
		transitionScreen.transition("res://Scenes/Rooms/Room_1.tscn", "ambience")
		Global.timer_on = true
