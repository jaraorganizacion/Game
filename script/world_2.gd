extends Node2D


func _on_portal_2_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		call_deferred("_change_scene_world_1")
		

func _change_scene_world_1():
	get_tree().change_scene_to_file("res://scene/world.tscn")
