extends Node

@export var is_multiplayer: bool = false

@onready var multiplayer_scene: PackedScene = load("res://multiplayer.tscn")
@onready var singleplayer_scene: PackedScene = load("res://FPSCharacter.tscn")

func _unhandled_input(_event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func _ready():
	if is_multiplayer:
		print("Multi player mode")
		add_child(multiplayer_scene.instantiate())
	else:
		print("Single player mode")
		var player = singleplayer_scene.instantiate()

		var spawns = $Spawns.get_children()
		var spawn = spawns[randi() % spawns.size()]
		player.position = spawn.position

		add_child(player)

	
	if OS.has_feature("web"):
		# On browsers we need to capture the mouse from a button press
		var button = load("res://scenes/ui/web_capture_mouse.tscn").instantiate()
		add_child(button)
