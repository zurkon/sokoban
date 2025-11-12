extends Node
class_name GameController

@onready var gameplay = $Gameplay
@onready var transition = $UI/SceneTransition
@onready var audioplayer = $AudioStreamPlayer
@onready var camera = $Camera2D

var current_level: Level = null

func _ready() -> void:
	if current_level == null:
		current_level = gameplay.get_child(0)
	
	# Connect viewport signal
	get_tree().root.size_changed.connect(_on_size_changed)
	# Connect current level signals
	current_level.level_completed.connect(_on_level_completed)
	current_level.level_reset_requested.connect(_on_level_reset_requested)
	print("[GameController]: loaded " + str(current_level))
	
	_set_camera_zoom()
	
	# Opening transition and Start Game
	if transition.is_game_starting:
		transition.get_child(0).material.set("shader_parameter/progress", 1.0)
		transition.get_child(0).material.set("shader_parameter/diagonal", true)
		transition.fade_out()
		await  transition.transition_finished
		audioplayer.play()
		current_level.init_player()

# Changes camera zoom based on viewport size
func _set_camera_zoom():
	# On higher screen resolution zoom out a little
	if get_tree().root.size > Vector2i(1280, 720):
		camera.zoom = Vector2(0.7,0.7)
	# Smaller  screen, maintain the default value
	else:
		camera.zoom = Vector2(1, 1)

func _goto_scene(path: String) -> void:
	# Deleting the current scene can be a bad idea,
	# because it may still be executing code.
	# This will result in a crash or unexpected behavior.
	
	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running.
	_deferred_goto_scene.call_deferred(path)

func _deferred_goto_scene(path):
	# Remove scene safely.
	current_level.free()
	
	# Load the new scene.
	var s = ResourceLoader.load(path)
	
	# Instance the new scene.
	current_level = s.instantiate()
	
	# Add it to the gameplay node.
	gameplay.add_child(current_level)

	# Connect level signal to GameController
	_connect_scene(current_level)

# Connects new scene signals before loading
# It's called inside _deferred_goto_scene()
func _connect_scene(new_scene: Level):
	current_level = new_scene
	new_scene.level_completed.connect(_on_level_completed)
	new_scene.level_reset_requested.connect(_on_level_reset_requested)

# SIGNALS Methods 

# Handles camera zoom when screen resize
func _on_size_changed():
	_set_camera_zoom()

# Handles scene loading and transition
func _on_level_completed():
	print("[GameController]: Level Completed!")
	await get_tree().create_timer(0.5).timeout
	
	transition.fade_in()
	await transition.transition_finished
	
	await get_tree().create_timer(0.5).timeout
	
	Global.current_level += 1
	
	if Global.current_level > Global.levels.size() - 1:
		# Go back to start
		Global.current_level = 0
	
	_goto_scene(Global.levels[Global.current_level])
	
	# Hide Bottom UI to show credits on thanks.tscn
	if Global.current_level == Global.levels.size() - 1:
		$UI/LeftContainer.hide()
		$UI/RightContainer.hide()
	else:
		$UI/LeftContainer.show()
		$UI/RightContainer.show()
	
	transition.fade_out()
	await transition.transition_finished
	current_level.init_player()

func _on_level_reset_requested():
	print("[GameController]: Level Reset!")
	transition.restart_in()
	await transition.transition_finished
	
	_goto_scene(Global.levels[Global.current_level])
	
	transition.restart_out()
	await transition.transition_finished
	current_level.init_player()
