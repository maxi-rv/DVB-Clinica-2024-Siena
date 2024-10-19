extends Node

signal hp_changed(new_hp: int)
signal score_changed(new_score: int)

var player_hp = 100
var plyaing_music = true
var score: int = 0

func change_player_hp(new_hp: int) -> void:
	player_hp += new_hp
	if player_hp < 0:
		player_hp = 0 
	# Emit the signal with the updated HP value	
	emit_signal("hp_changed", player_hp)	

func loadLevel(scene_name: String) -> void:
	var scene_path = "res://scenes/"+str(scene_name)+".tscn"
	get_tree().change_scene_to_file(scene_path)

# Function to update score
func score_change(new_score: int) -> void:
	score += new_score
	# Signal emitted with the updated score
	emit_signal("score_changed", score, true)
	
func reset_score() -> void:
	score = 0
	emit_signal("score_changed", score, false)
