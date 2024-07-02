extends PlayerState


const ATTACK_TIME := 0.4

const GRAVITY = 20
const AIR_HANG_THRESHOLD := 50
const AIR_HANG_FACTOR := 0.8

var attack_timer: Timer


func _ready() -> void:
	attack_timer = Timer.new()
	attack_timer.connect("timeout", _on_attack_timer_stopped)
	attack_timer.one_shot = true
	add_child(attack_timer)


func enter(data:= {}) -> void:
	if !data.has("keep_speed") || !data.get("keep_speed"):
		entity.velocity.x = 0
	attack_timer.start(ATTACK_TIME)


func exit() -> void:
	attack_timer.stop()


func physic(delta: float) -> void:
	entity.velocity.y += get_gravity(GRAVITY, AIR_HANG_FACTOR, AIR_HANG_THRESHOLD)
	
	entity.move_and_slide()


func _on_attack_timer_stopped():
	request_fall(false)
