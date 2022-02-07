extends Node


onready var clear_control := $UI/ClearControl


var _occupied_platforms = 0


func add_platform() -> void:
	_occupied_platforms += 1
	print(_occupied_platforms)
	yield(get_tree().create_timer(0.5), "timeout")
	check_clear()


func remove_platform() -> void:
	_occupied_platforms -= 1
	print(_occupied_platforms)


func check_clear() -> void:
	if _occupied_platforms == 3:
		clear_control.visible = true
		print('CLEAR')
