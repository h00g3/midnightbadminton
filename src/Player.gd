class_name Player

enum Side {LEFT, RIGHT}

var name = "Player" setget set_name, get_name
var score = 0 setget ,get_score
var score_satz = 0 setget ,get_score_satz
var physics_body setget set_physics_body, get_physics_body
var side setget set_side, get_side

func _init(_name, body, _side):
	name = _name
	physics_body = body
	side = _side

func set_name(_name):
	name = _name
	
func get_name():
	return name

func score():
	score+=1
	return score

func get_score():
	return score

func reset_score():
	score = 0
	return score

func reset_all():
	reset_score()
	score_satz = 0
	return score_satz

func score_satz():
	score_satz+=1
	return score_satz
	
func get_score_satz():
	return score_satz

func set_physics_body(body):
	physics_body = body

func get_physics_body():
	return physics_body

func set_side(_side):
	side = _side
	
func get_side():
	return side

func get_body_position():
	var collisionShape = getPlayerCollisionShape()
	return collisionShape.position

func getPlayerCollisionShape():
	for child in physics_body.get_children():
		if child is CollisionShape2D:
			return child
	push_error ( "no collision shape found for player %s" % name)
