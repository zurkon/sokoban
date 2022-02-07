tool
extends Area2D
class_name Box


onready var ray := $RayCast2D
onready var tween := $Tween


export var sliding_time = 0.15
export (String, 'red', 'blue', 'green') var color = 'red' setget set_color


var is_sliding = false


func set_color(val: String) -> void:
	var base_path = "res://assets/Boxes/crate_%s.png"
	var path = base_path % val
	color = val
	var texture = load(path)
	$Sprite.texture = texture
	print(path)


func push(dir: Vector2) -> void:
	if is_sliding:
		return
	tween.interpolate_property(
		self, "position",
		position, position + dir * 2, sliding_time,
		Tween.TRANS_CUBIC,
		Tween.EASE_IN
	)
	tween.start()
	is_sliding = true
	yield(tween, "tween_completed")
	is_sliding = false


func can_move(dir: Vector2) -> bool:
	ray.cast_to = dir
	ray.force_raycast_update()
#	print(ray.get_collider())
	return !ray.is_colliding()

