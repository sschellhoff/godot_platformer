extends Area2D


func _ready():
	#wait is_node_ready()
	$AnimationPlayer.play("normal")

func _on_body_entered(body):
	$AnimationPlayer.play("collected")
	await $AnimationPlayer.animation_finished
	queue_free()
