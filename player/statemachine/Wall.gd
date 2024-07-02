extends PlayerState


const SPEED = 80


func enter(data:= {}) -> void:
	entity.velocity = Vector2.ZERO


func physic(delta: float) -> void:
	if !want_move_horizontal():
		request_fall()
	elif want_jump():
		request_wall_jump(SPEED * facing_direction() * -1)
	elif want_move_in_other_direction():
		request_fall(true)
	elif entity.is_on_wall() && !want_move_in_other_direction():
		request_wall()
	elif entity.is_on_floor():
		request_walk()

