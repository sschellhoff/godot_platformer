extends PlayerState


const JUMP_STRENGTH := 400

const MAX_JUMPS := 2

const JUMP_CAP_FACTOR := 0.2
const JUMP_RELEASE_STRENGTH := 10

const GRAVITY = 20
const AIR_HANG_THRESHOLD := 100
const AIR_HANG_FACTOR := 0.5
const MAX_FALL_SPEED := 600

const SPEED = 160

const COYOTE_TIME := 0.5
const EARLY_JUMP_TIME := 0.05


var coyote_timer: Timer
var can_coyote_jump := false

var buffered_jump_timer: Timer
var is_jump_buffered := false

var forced_speed_timer: Timer
var is_forced_speed := false

var can_cap_jump := false

var was_on_wall := false

var jump_number := MAX_JUMPS

func _ready():
	coyote_timer = Timer.new()
	coyote_timer.connect("timeout", _on_coyote_timer_timeout)
	coyote_timer.one_shot = true
	add_child(coyote_timer)
	buffered_jump_timer = Timer.new()
	buffered_jump_timer.connect("timeout", _on_buffered_jump_timer_timeout)
	buffered_jump_timer.one_shot = true
	add_child(buffered_jump_timer)
	forced_speed_timer = Timer.new()
	forced_speed_timer.connect("timeout", _on_forced_speet_timer_timeout)
	forced_speed_timer.one_shot = true
	add_child(forced_speed_timer)


func enter(data:= {}) -> void:
	if data.has("jump"):
		entity.velocity.y = -JUMP_STRENGTH
		can_cap_jump = true
		jump_number = data.get("jump")
		if data.has("speed"):
			entity.velocity.x = data.get("speed")
			is_forced_speed = true
			forced_speed_timer.start(0.2)
	elif data.has("coyote") && data.get("coyote") == true:
		can_coyote_jump = true
		coyote_timer.start(COYOTE_TIME)


func exit() -> void:
	coyote_timer.stop()
	can_coyote_jump = false
	buffered_jump_timer.stop()
	is_jump_buffered = false
	forced_speed_timer.stop()
	is_forced_speed = false
	can_cap_jump = false
	was_on_wall = false
	jump_number = MAX_JUMPS


func physic(delta: float) -> void:
	if !is_forced_speed:
		move_horizontal_fixed(SPEED)
	
	entity.move_and_slide()
	
	entity.velocity.y += get_gravity(GRAVITY, AIR_HANG_FACTOR, AIR_HANG_THRESHOLD)
	entity.velocity.y = min(MAX_FALL_SPEED, entity.velocity.y)
	
	handle_jump_cap()
	
	# if move up and outer_left_raycast is colliding and other raycasts are not colliding
	# move slightly right
	# same for other direction
	
	if want_jump() and can_coyote_jump:
		request_jump()
	elif want_attack():
		request_attack(true)
	elif want_move_on_wall():
		request_wall()
	elif want_jump():
		handle_jump_from_air()
	elif want_and_can_dash():
		request_dash(get_horizontal_input_strength())
	elif entity.is_on_floor():
		handle_grounding()


func handle_jump_cap() -> void:
	if can_cap_jump:
		if want_jump():
			can_cap_jump = false
		if Input.is_action_just_released("jump") && !is_falling():
			entity.velocity.y *= JUMP_CAP_FACTOR


func handle_jump_from_air():
	if jump_number + 1 < MAX_JUMPS:
		request_jump(jump_number + 1)
	else:
		buffered_jump_timer.start(EARLY_JUMP_TIME)
		is_jump_buffered = true


func handle_grounding():
	if is_jump_buffered:
		request_jump()
	elif is_zero_approx(entity.velocity.x):
		request_idle()
	else:
		request_walk()


func _on_coyote_timer_timeout():
	can_coyote_jump = false


func _on_buffered_jump_timer_timeout():
	is_jump_buffered = false


func _on_forced_speet_timer_timeout():
	is_forced_speed = false


func want_move_on_wall() -> bool:
	return on_wall() && get_horizontal_input_direction() == facing_direction()


func on_wall() -> bool:
	var top_detector := $"../../WallDetector/Top" as RayCast2D
	var bottom_detector := $"../../WallDetector/Bottom" as RayCast2D
	return top_detector.is_colliding() && bottom_detector.is_colliding()
