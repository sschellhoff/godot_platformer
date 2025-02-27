class_name StateMachine
extends Node


signal transitioned(new_state: String)


@export var initial_state := NodePath()

@onready var state: State = get_node(initial_state)


func _ready() -> void:
	await owner.ready
	for state in get_children():
		state.connect("transition_requested", transition)
		state.entity = owner as CharacterBody2D
	state.enter()
	emit_signal(state.name)


func _physics_process(delta: float) -> void:
	# TODO move this code
	state.physic(delta)
	if is_zero_approx(owner.velocity.x):
		pass
	elif owner.velocity.x > 0:
		$"../WallDetector/Top".scale.y = 1
		$"../WallDetector/Bottom".scale.y = 1
		$"../AttackShape/AttackCollider".position.x = 28
	elif owner.velocity.x < 0:
		$"../WallDetector/Top".scale.y = -1
		$"../WallDetector/Bottom".scale.y = -1
		$"../AttackShape/AttackCollider".position.x = -28


func _process(delta: float) -> void:
	state.update(delta)


func _unhandled_input(event: InputEvent) -> void:
	state.unhandled_input(event)


func _unhandled_key_input(event: InputEvent) -> void:
	state.unhandled_key_input(event)


func transition(name: String, data:= {}) -> void:
	var new_state = get_node(name) as State
	if new_state == null:
		return
	state.exit()
	state = new_state
	state.enter(data)
	emit_signal("transitioned", name)


func _on_player_animation_height_change(is_small: bool):
	# TODO move this code
	# TODO fix when slide stops below flat ceiling
	if is_small:
		$"../SlideCollision".disabled = false
		$"../StandCollision".disabled = true
	else:
		$"../StandCollision".disabled = false
		$"../SlideCollision".disabled = true


func _on_player_animation_attack_state_change(is_attack_active):
	$"../AttackShape/AttackCollider".disabled = !is_attack_active
