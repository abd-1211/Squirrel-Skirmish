extends Node2D


func _ready():
	Game.playerHP = 10
	Game.XP =0
	Utils.saveGame()
	Utils.loadGame()
	$Menumusic.play()
func _on_quit_pressed() -> void:
	get_tree().quit() # Replace with function body.


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://level_1.tscn")
