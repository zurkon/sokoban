extends AnimatableBody2D
class_name Box

const tile_size: Vector2 = Vector2(16, 16)
var sprite_tween: Tween
var moving = false

@export var tween_duration := 0.185
@onready var ray_up := $RayCastUp
@onready var ray_down := $RayCastDown
@onready var ray_left := $RayCastLeft
@onready var ray_right := $RayCastRight

## Returns [code]True[/code] if theres no collision on specified direction.
func can_move(dir: Vector2) -> bool:
	if dir == Vector2(0, -1):
		return !ray_up.is_colliding()
	elif dir == Vector2(0, 1):
		return !ray_down.is_colliding()
	elif dir == Vector2(-1, 0):
		return !ray_left.is_colliding()
	else:
		return !ray_right.is_colliding()

## Moves this object to specified direction. [br]
func push(dir: Vector2) -> void:
	moving = true
	global_position += dir * tile_size
	$Sprite2D.global_position -= dir * tile_size # Don't move Sprite2d yet
	
	if sprite_tween:
		sprite_tween.kill()
	sprite_tween = create_tween()
	sprite_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_tween.tween_property($Sprite2D, "global_position", global_position, tween_duration).set_trans(Tween.TRANS_SINE)
	sprite_tween.tween_callback(func():
		moving = false
	)
