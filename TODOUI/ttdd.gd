extends Panel



func _on_check_box_pressed():
	var t = create_tween()
	t.tween_property($".","position",Vector2(720,position.y),1).set_trans(Tween.TRANS_SPRING)
	await t.finished
	queue_free()
