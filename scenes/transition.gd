extends CanvasLayer

signal transition_finished

@onready var animation = $AnimationPlayer

@export var is_game_starting = true

func _ready() -> void:
	animation.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(_anim_name: StringName):
	transition_finished.emit()

func fade_in():
	print("[Transition]: Fade In...")
	animation.play("diagonal_transition")

func fade_out():
	print("[Transition]: Fade Out...")
	animation.play_backwards("diagonal_transition")

func restart_in():
	animation.play("restart_transition")

func restart_out():
	animation.play_backwards("restart_transition")
