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
	
	print("[GameController]: ready " + str(current_level))
	current_level.level_completed.connect(_on_level_completed)
	current_level.level_reset_requested.connect(_on_level_reset_requested)
	
	get_tree().root.size_changed.connect(_on_size_changed)
	
	if transition.is_game_starting:
		transition.get_child(0).material.set("shader_parameter/progress", 1.0)
		transition.get_child(0).material.set("shader_parameter/diagonal", true)
		transition.fade_out()
		await  transition.transition_finished
		audioplayer.play()

func _on_size_changed():
	if get_tree().root.size > Vector2i(1280, 720):
		camera.zoom = Vector2(0.7,0.7)
	else:
		camera.zoom = Vector2(1, 1)

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
	
	Global.goto_scene(Global.levels[Global.current_level])
	
	# Hide Bottom UI to show credits on thanks.tscn
	if Global.current_level == Global.levels.size() - 1:
		$UI/LeftContainer.hide()
		$UI/RightContainer.hide()
	else:
		$UI/LeftContainer.show()
		$UI/RightContainer.show()
	
	transition.fade_out()

func _on_level_reset_requested():
	print("[GameController]: Level Reset!")
	transition.restart_in()
	await transition.transition_finished
	
	Global.goto_scene(Global.levels[Global.current_level])
	
	transition.restart_out()

func connect_scene(new_scene: Level):
	current_level = new_scene
	new_scene.level_completed.connect(_on_level_completed)
	new_scene.level_reset_requested.connect(_on_level_reset_requested)
