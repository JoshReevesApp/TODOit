extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Server.Send("/TODO")
	Server.Message.connect(func(a):if(a=="ONLINE"):$Offline.hide())


func  _process(delta: float) -> void:
	if not DisplayServer.is_touchscreen_available(): return
	if DisplayServer.virtual_keyboard_get_height()>0:
		$Panel.position.y = 1613-DisplayServer.virtual_keyboard_get_height()
	else:
		$Panel.position.y = 1613
