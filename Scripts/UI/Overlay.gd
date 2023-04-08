extends CanvasLayer

onready var _Deaths = $VBoxContainer/Deaths
onready var _Timer = $VBoxContainer/Timer
var time = Global.time
var timer_enabled = true

func _process(delta):
	time = Global.time
	
	if Global.perma_death:
		_Deaths.visible = false
	else:  _Deaths.visible = true
	if Global.timer_initiated:
		_Timer.visible = true
	else: _Timer.visible = false
	
	if Global.timer_on:
		Global.time += delta
	
	update_deaths()
	update_timer()

func update_deaths():
	_Deaths.text = "DEATHS: "+str(Global.death_count)

func update_timer():
	var mils = fmod(time,1)*1000
	var secs = fmod(time,60)
	var mins = fmod(time, 60*60)/60
	
	var time_passed = "%02d:%02d:%03d" % [mins, secs, mils]
	_Timer.text = time_passed

func include_timer(toggle: bool):
	if toggle:
		Global.timer_initiated = true
	else: Global.timer_initiated = false

func stop_timer():
	Global.timer_on = false
