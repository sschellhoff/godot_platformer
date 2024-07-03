extends Node2D

var last_animation = ""
var current_animation = "idle"

signal height_change(is_small: bool)

signal attack_state_change(is_attack_active: bool)

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
	
	if last_animation != current_animation:
		emit_signal("height_change", current_animation == "slide" || current_animation == "crouch")
		emit_signal("attack_state_change", current_animation == "attack")
	


func _on_statemachine_transitioned(new_state):
	last_animation = current_animation
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
		"Crouch":
			current_animation = "crouch"
		"Wall":
			current_animation = "wall_slide"
		"Attack":
			current_animation = "attack"

