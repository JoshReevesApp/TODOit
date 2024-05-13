extends Control
var currEdit = null
var All = ""
var Q = ["Start where you are. Use what you have. Do what you can. — Arthur Ashe",
		 "Productivity is being able to do things that you were never able to do before. — Franz Kafka",
		 "Do the hard jobs first. The easy jobs will take care of themselves. — Dale Carnegie",
		"Amateurs sit and wait for inspiration, the rest of us just get up and go to work. — Stephen King",
		"Focus on being productive instead of busy. — Tim Ferriss",
		"The way to get started is to quit talking and begin doing. — Walt Disney",
		"It's not always that we need to do more but rather that we need to focus on less. — Nathan W. Morris",
		"Your mind is for having ideas, not holding them. — David Allen",
		"You don’t need a new plan for next year. You need a commitment. — Seth Godin",
		"Simplicity boils down to two steps: Identify the essential. Eliminate the rest. — Leo Babauta"]
func _ready():
	$ColorRect/Label3.text = Server.CurrentAccount.split("/")[0]
	$ColorRect/Q.text = Q.pick_random()
	Server.Send("/TODO/GET/"+Server.CurrentAccount.split("/")[0])
	Server.Message.connect(func (a:String):if a.begins_with("!Get"):
		print(a)
		var data = a.replace("!Get/","")
		All = data
		var elems = data.split("|")
		SetTodos(elems)
		)
	await Server.Message
	
	
	
func _on_button_pressed():
	$Addpanel/Panel/task.grab_focus()
	$Addpanel.show()
	var g = create_tween()
	g.tween_property($Addpanel,"modulate",Color8(255,255,255,255),.2).set_ease(Tween.EASE_OUT_IN)
func _on_back_pressed():
	var g = create_tween()
	g.tween_property($Addpanel,"modulate",Color8(255,255,255,0),.2).set_ease(Tween.EASE_OUT_IN)
	await g.finished
	$Addpanel.hide()
func AddTodo(_new_text):
	var l = [$Addpanel/Panel/task,$Addpanel/Panel/reminder,$Addpanel/Panel/important]
	var t = ""
	for i in l:
		if i.modulate == Color8(255,255,255,255):
			t = i.name
	var x = load("res://TODOUI/"+t+".tscn").instantiate()
	x.get_node("Label").text = "#TODO "+str($Scroll/VBoxContainer.get_child_count()+1) +"\n"+ _new_text
	x.get_node("Button").pressed.connect(func ():openedit(x))
	$Scroll/VBoxContainer.add_child(x)
	_on_back_pressed()
	$Addpanel/Panel/LineEdit.text = ""
func Addtodo():
	All += "|"+$Addpanel/Panel/LineEdit.text 
	AddTodo($Addpanel/Panel/LineEdit.text)
	UpdateServer()

func SetTodos(list):
	if len(list) == 0: return
	for i in list:
		if len(i) > 0:
			AddTodo(i)
	
func UpdateServer():
	Server.Send("/TODO/UPDATE/"+Server.CurrentAccount.split("/")[0]+"/"+GetTODOS())
	
	
func grapS(pos):
	var l = [$Addpanel/Panel/task,$Addpanel/Panel/reminder,$Addpanel/Panel/important]
	var e = [$EditPanel/Panel/task,$EditPanel/Panel/reminder,$EditPanel/Panel/important]
	
	for i in range(len(l)):
		if i == pos:
			l[i].modulate = Color8(255,255,255,255)
			e[i].modulate = Color8(255,255,255,255)
		else:
			l[i].modulate = Color8(255,255,255,120)
			e[i].modulate = Color8(255,255,255,120)
func openedit(x):
	currEdit = x
	$EditPanel.show()
	$EditPanel/Panel/LineEdit.text = currEdit.get_node("Label").text.split('\n')[1]
	var g = create_tween()
	g.tween_property($EditPanel,"modulate",Color8(255,255,255,255),.2).set_ease(Tween.EASE_OUT_IN)
func _on_task_pressed():grapS(0)
func _on_reminder_pressed():grapS(1)
func _on_important_pressed():grapS(2)
func _on_buttoneditback_pressed():
	var g = create_tween()
	g.tween_property($EditPanel,"modulate",Color8(255,255,255,0),.2).set_ease(Tween.EASE_OUT_IN)
	await g.finished
	$EditPanel.hide()
func editTODO():
	EditTodo($EditPanel/Panel/LineEdit.text)
func EditTodo(_new_text):
	var l = [$EditPanel/Panel/task,$EditPanel/Panel/reminder,$EditPanel/Panel/important]
	var t = ""
	for i in l:
		if i.modulate == Color8(255,255,255,255):
			t = i.name
	var x = currEdit
	x.get_node("Label").text = "#TODO "+str($Scroll/VBoxContainer.get_child_count()+1) +"\n"+ _new_text     
	_on_buttoneditback_pressed()
	$EditPanel/Panel/LineEdit.text = ""
	UpdateServer()

func GetTODOS():
	var a = ""
	for i in $Scroll/VBoxContainer.get_children():
		a += i.get_child(0).text.split("\n")[1]+"|"
	return a.substr(0,len(a)-1)
	
func _on_logout_pressed():
	$TextureRect/AnimationPlayer.play_backwards("new_animation_2")
	await $TextureRect/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://splash.tscn")
