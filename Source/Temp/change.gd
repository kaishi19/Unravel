extends Node2D

func _on_Button_pressed():
	get_tree().change_scene("res://Source/Level/Level1.tscn")


func _on_Button2_pressed():
	get_tree().change_scene("res://Source/Interface/MainMenu.tscn")
