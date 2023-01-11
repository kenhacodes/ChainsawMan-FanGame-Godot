extends Node2D



func _on_Area2D_area_entered(area):
	get_tree().change_scene("res://Escenas/EscenaTrain.tscn")
