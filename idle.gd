extends PlayerState


func enter(data:= {}) -> void:
	entity.velocity = Vector2.ZERO


func physic(delta: float) -> void:
	if not entity.is_on_floor():
		request_fall()
		return
	
	if want_jump():
		request_jump()
	elif want_move_horizontal():
		request_walk()
