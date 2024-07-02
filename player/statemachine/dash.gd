extends PlayerState


const SPEED = 500

const DASH_TIME := 0.3
const VERTICAL_DUMPING := 0.015


var dash_timer: Timer

var direction := 0.0


func _ready() -> void:
	dash_timer = Timer.new()
	dash_timer.connect("timeout", _on_dash_timer_stopped)
	dash_timer.one_shot = true
	add_child(dash_timer)


func enter(data:= {}) -> void:
	if !data.has("direction"):
		stop_dash()
		return
	direction = data["direction"]
	entity.velocity.y *= VERTICAL_DUMPING
	dash_timer.start(DASH_TIME)


func exit() -> void:
	dash_timer.stop()


func physic(delta: float) -> void:
	entity.velocity.x = SPEED * direction
	entity.move_and_slide()
	
	if entity.is_on_wall():
		stop_dash()


func stop_dash():
	if entity.is_on_floor():
		request_idle()
	else:
		request_fall()


func _on_dash_timer_stopped():
	stop_dash()
