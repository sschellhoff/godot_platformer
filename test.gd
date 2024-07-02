extends Node2D

var current_animation = "idle"

func _physics_process(delta):
	if owner.velocity.x < 0:
		$Sprite2D.flip_h = true
	elif owner.velocity.x > 0:
		$Sprite2D.flip_h = false
	elif Input.is_action_pressed("left") && current_animation == "wall_slide":
		$Sprite2D.flip_h = false
	elif Input.is_action_pressed("right") && current_animation == "wall_slide":
		$Sprite2D.flip_h = true
	if current_animation == "fall" && owner.velocity.y < 0:
		$AnimationPlayer.play("jump")
	else:
		$AnimationPlayer.play(current_animation)


func _on_statemachine_transitioned(new_state):
	match new_state:
		"Fall":
			current_animation = "fall"
		"Idle":
			current_animation = "idle"
		"Dash":
			current_animation = "dash"
		"Walk":
			current_animation = "run"
		"Slide":
			current_animation = "slide"
		"Wall":
			current_animation = "wall_slide"
		"Attack":
			current_animation = "attack"
			
