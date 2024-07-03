extends PlayerState


const SPEED = 120

const COYOTE_TIME := 0.25

var coyote_timer: Timer


func _ready():
	coyote_timer = Timer.new()
	coyote_timer.connect("timeout", _on_coyote_timer_timeout)
	coyote_timer.one_shot = true
	add_child(coyote_timer)


func enter(data:= {}) -> void:
	entity.velocity = Vector2.ZERO


func exit() -> void:
	coyote_timer.stop()


func physic(delta: float) -> void:
	if want_jump():
		request_wall_jump(SPEED * facing_direction() * -1)
	elif (!want_move_horizontal() || want_move_in_other_direction()) && coyote_timer.is_stopped():
		coyote_timer.start(COYOTE_TIME)
	elif want_jump():
		request_wall_jump(SPEED * facing_direction() * -1)
	elif entity.is_on_floor():
		request_walk()


func _on_coyote_timer_timeout():
	request_fall()
