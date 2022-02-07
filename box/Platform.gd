tool
extends Area2D


onready var game := get_tree().current_scene # Game Node Scene


export (String, 'red', 'blue', 'green') var color = 'red' setget set_color


var occupied = false


func set_color(val: String) -> void:
	var base_path = "res://assets/Boxes/base_%s.png"
	var path = base_path % val
	color = val
	var texture = load(path)
	$Sprite.texture = texture
	print(path)


func _ready() -> void:
	var _entered_error_code =  .connect("area_entered", self, "_on_Platform_area_entered")
	var _exited_error_code =.connect("area_exited", self, "_on_Platform_area_exited")


func _on_Platform_area_entered(area: Area2D) -> void:
	if area is Box:
		if area.color == color:
			occupied = true
			game.add_platform()


func _on_Platform_area_exited(area: Area2D) -> void:
	if area is Box:
		if area.color == color:
			occupied = false
			game.remove_platform()
