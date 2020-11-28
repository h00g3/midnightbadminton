class_name Player

enum Side {LEFT, RIGHT}

var name = "Player" setget set_name, get_name
var score = 0 setget ,get_score
var physics_body setget set_physics_body, get_physics_body

func _init(_name, body, _side):
	name = _name
	physics_body = body
	body.set_side(_side)

func set_name(_name):
	name = _name
	
func get_name():
	return name

func score():
	score+=1
	return score

func get_score():
	return score

func set_physics_body(body):
	physics_body = body

func get_physics_body():
	return physics_body

func get_side():
	return physics_body.get_side()

func get_body_position():
	var collisionShape = getPlayerCollisionShape()
	return collisionShape.position

func getPlayerCollisionShape():
	for child in physics_body.get_children():
		if child is CollisionShape2D:
			return child
	push_error ( "no collision shape found for player %s" % name)
