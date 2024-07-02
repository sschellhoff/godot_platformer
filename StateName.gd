extends Label


func _on_statemachine_transitioned(new_state):
	text = new_state
