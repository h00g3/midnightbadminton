#extends Node

class_name Racket

var side
var minimum_impulse = 20000
var maximum_impulse = 70000

func _init(_side):
	side = _side

func hit_shuttle(shuttle):
	var x = 35000
	if(side == Player.Side.RIGHT):
		x = -x
	var y = 35000
	var impulse = Vector2(x,y)
	shuttle.apply_central_impulse(impulse)
