extends Label

@onready var audio_stream_player = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Gamemanager.connect("score_changed", _on_score_change)

func _on_score_change(new_score, playSFX):
	text = str(new_score)
	if playSFX:
		audio_stream_player.play()
