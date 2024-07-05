extends Node


@onready var heart = preload("res://collectables/heart/heart.tscn")

func _ready():
	for child in get_children():
		child.connect("destroyed", _on_bag_destroyed)


func _on_bag_destroyed(position):
	var heart_instance = heart.instantiate()
	heart_instance.position = position
	add_child(heart_instance)
