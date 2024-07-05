extends StaticBody2D


func _on_area_2d_area_entered(area):
	$AnimationPlayer.play("destroy")
	await $AnimationPlayer.animation_finished
	queue_free()
