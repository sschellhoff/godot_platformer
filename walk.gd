extends PlayerState


const SPEED := 200.0
const ACCELERATION := 10
const DECELERATION := 10
const ACCELERATE_OTHER_DIRECTION_FACTOR := 1.5


func physic(delta: float) -> void:
	if not entity.is_on_floor():
		request_fall(true)
		return
	
	move_horizontal(SPEED, ACCELERATION, ACCELERATE_OTHER_DIRECTION_FACTOR, DECELERATION)

	entity.move_and_slide()
	
	if want_jump():
		request_jump()
	elif stands_still():
		request_idle()
	elif want_and_can_slide():
		request_slide(get_horizontal_input_strength())

