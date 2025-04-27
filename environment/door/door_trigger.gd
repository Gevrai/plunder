extends Area3D

@export var animation_player: AnimationPlayer

func _on_body_entered(_body: Node) -> void:
	animation_player.play("open")

func _on_body_exited(_body:Node3D) -> void:
	if has_overlapping_bodies():
		return
	animation_player.play_backwards("open")
