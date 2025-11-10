extends Area2D
class_name Platform

var occupied = false

func _ready() -> void:
	connect("body_entered", _on_platform_entered)
	connect("body_exited", _on_platform_exited)

func _on_platform_entered(body: Node2D):
	if body is Box:
		occupied = true

func _on_platform_exited(body: Node2D):
	if body is Box:
		occupied = false
