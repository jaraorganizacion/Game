extends Node2D


func _on_out_house_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		get_tree().change_scene_to_file("res://scene/world.tscn")
