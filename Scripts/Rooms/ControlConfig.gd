extends Node2D

onready var _BackButton = $MainMenu/VBoxContainer/Back

onready var transitionScreen = Global.TransitionScreen

func _ready():
	$MainMenu/VBoxContainer/Up.grab_focus()

func _on_Back_pressed():
	transitionScreen.transition("res://Scenes/Rooms/Options.tscn")
