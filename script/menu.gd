extends Control




func _on_play_pressed():
	get_tree().change_scene_to_file("res://scene/house.tscn")


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_quit_pressed():
	get_tree().quit()


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/creditos.tscn")
