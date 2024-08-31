extends ScrollContainer


func _ready():
	# Scrolling enabled but scrollbar is hidden
	vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	scroll_to_botton()

func on_tween_end():
	await get_tree().create_timer(1.5).timeout
	Gamemanager.loadLevel("menu")

# Scroll to bottom animation
func scroll_to_botton():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	var scrollbar = get_v_scroll_bar()
	tween.connect("finished", on_tween_end)
	
	if scrollbar:
		scrollbar.value = scrollbar.min_value
		tween.tween_property(scrollbar, "value", (scrollbar.max_value+200), 2.0)
		tween.finished
