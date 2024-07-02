class_name State
extends Node


signal transition_requested(name: String, data: Dictionary)


var entity: CharacterBody2D


func enter(data:= {}) -> void:
	pass


func exit() -> void:
	pass


func update(delta: float) -> void:
	pass


func physic(delta: float) -> void:
	pass


func unhandled_input(event) -> void:
	pass


func unhandled_key_input(event) -> void:
	pass


func request_transition(name: String, data:= {}) -> void:
	emit_signal("transition_requested", name, data)
