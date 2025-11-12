extends CharacterBody2D
class_name Player

signal player_moved
signal reset_requested

const tile_size: Vector2 = Vector2(16, 16)
var sprite_tween: Tween

@export var tween_duration := 0.185
@onready var ray_up = $RayCastUp
@onready var ray_down := $RayCastDown
@onready var ray_left := $RayCastLeft
@onready var ray_right := $RayCastRight

var can_move = false

func _physics_process(_delta: float) -> void:
	if !can_move:
		return
	if !sprite_tween or !sprite_tween.is_running():
		if Input.is_action_pressed("up"):
			_handle_move(Vector2(0, -1), ray_up)
		elif Input.is_action_pressed("down"):
			_handle_move(Vector2(0, 1), ray_down)
		elif Input.is_action_pressed("left"):
			_handle_move(Vector2(-1, 0), ray_left)
		elif Input.is_action_pressed("right"):
			_handle_move(Vector2(1, 0), ray_right)
		elif Input.is_action_just_pressed("reset"):
			reset_requested.emit()

## Handles collision check before Player moves,[br]
## interacting with movable [Box] when detected.[br]
## [br]
## [param dir]: Target direction for Player movement as a [Vector2]. [br]
## [param raycast]: [RayCast2D] that will detect collision with walls and boxes.
func _handle_move(dir: Vector2, raycast: RayCast2D) -> void:
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider is Box:
			if collider.can_move(dir):
				collider.push(dir)
				_move(dir)
	else:
		_move(dir)

## Moves Player to specified direction.
func _move(dir: Vector2) -> void:
	global_position += dir * tile_size
	$AnimatedSprite2D.global_position -= dir * tile_size # Don't move Sprite2d yet
	
	if sprite_tween:
		sprite_tween.kill()
	sprite_tween = create_tween()
	sprite_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_tween.tween_property($AnimatedSprite2D, "global_position", global_position, tween_duration).set_trans(Tween.TRANS_SINE)
	sprite_tween.tween_callback(func():
		player_moved.emit()
	)
