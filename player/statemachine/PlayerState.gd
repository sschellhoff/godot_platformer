class_name PlayerState
extends State

# ===== Transitions =====

func request_walk() -> void:
	request_transition("Walk")


func request_idle() -> void:
	request_transition("Idle")


func request_fall(with_coyote := false) -> void:
	request_transition("Fall" , {coyote = with_coyote})


func request_jump(jump_number := 0) -> void:
	request_transition("Fall", {jump = jump_number})


func request_wall_jump(speed: float) -> void:
	request_transition("Fall", {jump = 0, speed = speed})


func request_dash(direction: float) -> void:
	request_transition("Dash", {direction = sign(direction)})


func request_slide(direction: float) -> void:
	request_transition("Slide", {direction = sign(direction)})



func request_wall() -> void:
	request_transition("Wall")


# ===== Input =====


func want_move_horizontal() -> bool:
	return want_move_left() || want_move_right()


func want_move_right() -> bool:
	return Input.is_action_pressed("right")


func want_move_left() -> bool:
	return Input.is_action_pressed("left")


func want_jump() -> bool:
	return Input.is_action_just_pressed("jump")


func want_and_can_dash() -> bool:
	return want_dash() and !is_zero_approx(get_horizontal_input_strength())


func want_dash() -> bool:
	return Input.is_action_just_pressed("dash")


func want_and_can_slide() -> bool:
	return want_slide() and !is_zero_approx(get_horizontal_input_strength())


func want_slide() -> bool:
	return Input.is_action_just_pressed("dash")


func stands_still() -> bool:
	return is_zero_approx(get_horizontal_input_strength()) && is_zero_approx(entity.velocity.x)


func get_horizontal_input_strength() -> float:
	return Input.get_action_strength("right") - Input.get_action_strength("left")


func get_horizontal_input_direction() -> float:
	return sign(get_horizontal_input_strength())


func want_move_in_current_direction() -> bool:
	var current_direction = entity.velocity.x
	var wanted_direction = get_horizontal_input_direction()
	return sign(current_direction) == wanted_direction && wanted_direction != 0


func want_move_in_other_direction() -> bool:
	return facing_direction() != get_horizontal_input_direction()


# ===== State =====


func is_falling() -> bool:
	return entity.velocity.y >= 0


func facing_direction() -> int:
	return sign($"../../WallDetectorTop".scale.y)

# ===== Movement =====


func move_horizontal(speed: float, acceleration: float, acceleration_other_direction_factor:float, deceleration: float) -> void:
	var horizontal_input_direction := get_horizontal_input_strength()
	
	if is_zero_approx(horizontal_input_direction):
		entity.velocity.x = move_toward(entity.velocity.x, 0.0, deceleration)
	elif horizontal_input_direction < 0:
		entity.velocity.x = max(-speed, entity.velocity.x - get_acceleration(acceleration, acceleration_other_direction_factor)) #get_acceleration(horizontal_input_direction))
	elif horizontal_input_direction > 0:
		entity.velocity.x = min(speed, entity.velocity.x + get_acceleration(acceleration, acceleration_other_direction_factor)) #(horizontal_input_direction))


func move_horizontal_fixed(speed: float) -> void:
	var horizontal_input_strength := get_horizontal_input_strength()
	entity.velocity.x = speed * horizontal_input_strength


func get_acceleration(acceleration: float, acceleration_other_direction_factor) -> float:
	if want_move_in_current_direction():
		return acceleration
	return acceleration * acceleration_other_direction_factor

