extends StaticBody2D
@onready var marker_2d = $Marker2D
@onready var marker_2d_2 = $Marker2D2
@onready var marker_2d_3 = $Marker2D3


func _ready():
	return
	var p = [marker_2d,marker_2d_2,marker_2d_3]
	for i in range(3):
		await get_tree().create_timer(2.0).timeout
		var shape:RigidBody2D = preload("res://tri.tscn").instantiate()
		add_child(shape)
		var x = p.pick_random()
		shape.position = x.position
		shape.rotation = x.rotation
		shape.apply_central_force(Vector2(500,500))
	
