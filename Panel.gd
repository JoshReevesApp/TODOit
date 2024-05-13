extends Panel
var InSign = true
var Acctry = ""
func  _ready() -> void:
	Server.Message.connect(func(a):process(a))


func _on_other_pressed():
	InSign = !InSign
	update()
func update():
	$Label.text = 'Create an Account' if InSign else 'Login to your Account'
	$other.text = 'Login' if InSign else 'Sign up'
	

func process(a):
	if a == "OK":
		Server.CurrentAccount = Acctry
		gotoMain()
		

func _on_button_pressed():
	InSign = true
	$AnimationPlayer.play("new_animation")
	update()


func _on_button_2_pressed():
	InSign = false
	$AnimationPlayer.play("new_animation")
	update()


func _on_conf_pressed():
	if $user.text == "..":
		gotoMain()
	if $other.text == 'Sign up':#we are in Login
		Acctry = $user.text+"/"+$pass.text
		Server.Send("/TODO/LOGIN/"+Acctry)
		await Server.Message
		
	if $other.text == 'Login':#we are in signup
		Acctry = $user.text+"/"+$pass.text
		Server.Send("/TODO/SIGNUP/"+Acctry)
		await Server.Message
	
func gotoMain():
	$"../TextureRect/AnimationPlayer".play_backwards("new_animation_2")
	await $"../TextureRect/AnimationPlayer".animation_finished
	get_tree().change_scene_to_file("res://main.tscn")
