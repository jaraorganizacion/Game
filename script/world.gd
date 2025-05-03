extends Node2D


func _on_entrar_house_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		# Posponemos el cambio de escena para evitar conflictos con la física
		call_deferred("_change_scene")
		
func _change_scene() -> void:
	get_tree().change_scene_to_file("res://scene/house.tscn")


#trasladarse al otro mapa
func _on_portal_body_entered(body):
	if body.has_method("player"):
		call_deferred("_change_scene_world_2")
		
func _change_scene_world_2():
	get_tree().change_scene_to_file("res://scene/world_2.tscn")
