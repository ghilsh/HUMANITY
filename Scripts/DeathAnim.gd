extends Particles2D

func _ready():
	animate()

func animate():
	$AnimationPlayer.play("explosion")
	$DeathSound.play()
	visible = true
	position = Global.death_pos - Vector2(25,57)
	$Sprite.frame = Global.global_sprite

func _on_AnimationPlayer_animation_finished(anim_name):
		if anim_name == "explosion":
			if Global.perma_death == false:
				get_tree().call_group("player", "respawn")
			queue_free()
