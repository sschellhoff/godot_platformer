extends PlayerState


const SPEED = 80


func enter(data:= {}) -> void:
	entity.velocity = Vector2.ZERO


func physic(delta: float) -> void:
	if !want_move_horizontal():
		request_fall()
	elif want_jump():
		request_wall_jump(SPEED * facing_direction() * -1)
	elif want_away():
		request_fall(true)
	elif entity.is_on_floor():
		request_walk()
		entity.is_on_wall()
		return


func facing_direction() -> int:
	return sign($"../../WallDetectorTop".scale.y)


func want_away() -> bool:
	return facing_direction() != get_horizontal_input_direction()
