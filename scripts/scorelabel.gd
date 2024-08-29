extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	Gamemanager.connect("score_changed", _on_score_change)

func _on_score_change(new_score):
	print("Coins UI!", new_score)
	text = str(new_score)
