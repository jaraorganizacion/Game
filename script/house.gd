extends Node2D


func _on_out_house_body_entered(body):
	if body.has_method("player"):
		# Posponemos la eliminación de nodos o el cambio de escena para evitar conflictos
		call_deferred("_exit_house")
		
func _exit_house() -> void:
	# Aquí puedes poner el código que causa el error, por ejemplo, cambiar la escena o eliminar nodos.
	get_tree().change_scene_to_file("res://scene/world.tscn")  # Cambia a la escena exterior
