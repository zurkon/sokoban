extends Node2D
class_name Level

signal level_completed
signal level_reset_requested

@export var goals: Array[Platform]
@export var player: Player

func _ready() -> void:
	print("[Level]: signal connected.")
	player.player_moved.connect(_on_player_moved)
	player.reset_requested.connect(_on_reset_requested)

func init_player():
	player.can_move = true

func _on_player_moved():
	#print("[Level]: Player moved...")
	var finished = goals.all(_check_goals_status)
	#print("[Level]: goal status is " + str(finished))
	if finished:
		player.can_move = false
		level_completed.emit()

func _on_reset_requested():
	print("[Level]: Reset requested...")
	level_reset_requested.emit()

func _check_goals_status(goal: Platform):
	return goal.occupied == true
