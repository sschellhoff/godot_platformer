extends PlayerState


const SPEED = 500

const SLIDE_TIME := 0.4
const VERTICAL_DUMPING := 0.015


var slide_timer: Timer

var direction := 0.0


func _ready() -> void:
	slide_timer = Timer.new()
	slide_timer.connect("timeout", _on_slide_timer_stopped)
	slide_timer.one_shot = true
	add_child(slide_timer)


func enter(data:= {}) -> void:
	if !data.has("direction"):
		stop_slide()
		return
	direction = data["direction"]
	entity.velocity.y *= VERTICAL_DUMPING
	slide_timer.start(SLIDE_TIME)


func exit() -> void:
	slide_timer.stop()


func physic(delta: float) -> void:
	entity.velocity.x = SPEED * direction
	
	entity.move_and_slide()
	
	if entity.is_on_wall() || !entity.is_on_floor():
		stop_slide()
		


func stop_slide():
	if entity.is_on_floor():
		if can_stand():
			request_walk()
		else:
			request_crouch()
	else:
		request_fall(true)


func _on_slide_timer_stopped():
	stop_slide()
