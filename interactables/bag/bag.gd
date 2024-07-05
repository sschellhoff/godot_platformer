extends StaticBody2D

signal destroyed(position: Vector2)


func _on_area_2d_area_entered(area):
	$AnimationPlayer.play("destroy")
	await $AnimationPlayer.animation_finished
	emit_signal("destroyed", position)
	queue_free()
