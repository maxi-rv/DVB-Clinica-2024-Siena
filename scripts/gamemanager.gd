extends Node

signal hp_changed(new_hp: int)

var player_hp = 100
var plyaing_music = true

func change_player_hp(new_hp: int) -> void:
	player_hp += new_hp
	if player_hp < 0:
		player_hp = 0 
	# Emit the signal with the updated HP value	
	emit_signal("hp_changed", player_hp)	
