extends KinematicBody2D


onready var ray := $RayCast2D
onready var tween := $Tween


export var grid_size := 32
export var sliding_time = 0.2


var is_sliding = false
var inputs = {
	'move_up': Vector2.UP,
	'move_down': Vector2.DOWN,
	'move_left': Vector2.LEFT,
	'move_right': Vector2.RIGHT,
}


func _unhandled_input(event: InputEvent) -> void:
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			_update(dir)
	if event.get_action_strength('reset'):
		var _error_code = get_tree().reload_current_scene()


func _update(dir: String) -> void:
	if is_sliding:
		return
	var vector_dir = inputs[dir] * 32
	ray.cast_to = vector_dir
	ray.force_raycast_update()
	tween.interpolate_property(
		self, "position",
		position, position + vector_dir, sliding_time,
		Tween.TRANS_CUBIC,
		Tween.EASE_IN
	)
	
	if !ray.is_colliding():
		_move()
	else:
		var collider = ray.get_collider()
		if collider is Box:
			if collider.can_move(vector_dir):
				collider.push(vector_dir)
				_move()


func _move() -> void:
	tween.start()
	is_sliding = true
	yield(tween, "tween_completed")
	is_sliding = false
