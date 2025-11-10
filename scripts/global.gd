extends Node

var current_scene: Node = null
var gameplay: Node = null
var gamecontroller: GameController = null

var levels = [
	#"res://levels/sandbox.tscn",
	"res://levels/level_1.tscn",
	"res://levels/level_2.tscn",
	"res://levels/level_3.tscn",
	"res://levels/level_4.tscn",
	"res://levels/level_5.tscn",
	"res://levels/level_6.tscn",
	"res://levels/level_7.tscn",
	"res://levels/level_8.tscn",
	"res://levels/level_9.tscn",
	"res://levels/level_10.tscn",
	"res://levels/thanks.tscn",
]
var current_level := 0

func _ready() -> void:
	# get the last index ("GameController")
	gamecontroller = get_tree().root.get_child(-1)

	# second child ("Gameplay Node")
	gameplay = gamecontroller.get_child(1)
	# then its first child ("Sandbox")
	current_scene = gameplay.get_child(0)
	
	print("[Global]: " + str(current_scene))

func goto_scene(path: String) -> void:
	# Deleting the current scene can be a bad idea,
	# because it may still be executing code.
	# This will result in a crash or unexpected behavior.
	
	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running.
	_deferred_goto_scene.call_deferred(path)

func _deferred_goto_scene(path):
	# Remove scene safely.
	current_scene.free()
	
	# Load the new scene.
	var s = ResourceLoader.load(path)
	
	# Instance the new scene.
	current_scene = s.instantiate()
	
	# Add it to the gameplay node.
	gameplay.add_child(current_scene)

	# Connect level signal to GameController
	gamecontroller.connect_scene(current_scene)
