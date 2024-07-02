extends CharacterBody2D


const SPEED = 160.0
const ACCEL = 15
const JUMP_VELOCITY = -250.0
const MAX_FALLING_SPEED = 1000

# Get the gravity from the project settings to be synced with RigidBody nodes.
const GRAVITY = 20


var facing_right = true

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if velocity.y < 0:
			velocity.y += 3 *GRAVITY / 4
		else:
			velocity.y += GRAVITY

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	velocity.y = clampf(velocity.y, -MAX_FALLING_SPEED, MAX_FALLING_SPEED)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_pressed("left"):
		velocity.x -= ACCEL
		facing_right = false
	elif Input.is_action_pressed("right"):
		velocity.x += ACCEL
		facing_right = true
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.2)
	velocity.x = clampf(velocity.x, -SPEED, SPEED)
	
	if facing_right:
		$Sprite2D.scale.x = 1
	else:
		$Sprite2D.scale.x = -1
	
	if is_on_floor():
		if abs(velocity.x) < 5:
			$AnimationPlayer.play("idle")
		else:
			$AnimationPlayer.play("walk")
	else:
		if velocity.y > 0:
			$AnimationPlayer.play("fall")
		else:
			$AnimationPlayer.play("jump")
			
	

	move_and_slide()
