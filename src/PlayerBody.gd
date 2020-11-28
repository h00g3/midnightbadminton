extends KinematicBody2D

class_name PlayerBody

onready var racket = load("res://src/Racket.gd").new()

onready var state_machine = $Node2D/AnimationTree.get("parameters/playback")

# Vektor für Bewegung, Sprungkraft und Gravity
var vel = Vector2() setget ,get_velocity

var side setget set_side, get_side

#func state_machine() :
#	return $Node2D/AnimationTree.get("parameters/playback")

func set_side(_side):
	side = _side
	
func get_side():
	return side

func Jump():
	state_machine.travel("Jump")

func Walk():
	if state_machine.get_current_node() != ("Walking"):
		state_machine.travel("Walking")

func Schlag():
	state_machine.travel("Schlag")

func Cheer():
	state_machine.travel("Winning")

func Sad():
	state_machine.travel("Lose")

func _on_Area2D_body_entered(body):
	if isShuttle(body):
		Schlag()
		racket.hit_shuttle(body, self)
		var timer = get_parent().get_node("Scoreboard/Time/Timer")
		timer.start()
		
func isShuttle(body):
	return body.get_name() == "Shuttle"

func get_velocity():
	return vel

func is_right():
	return side == Player.Side.RIGHT

func is_moving_towards_net():
	return (side == Player.Side.LEFT and is_moving_right()) or (side == Player.Side.RIGHT and is_moving_left())

func is_moving_away_from_net():
	return (side == Player.Side.LEFT and is_moving_left()) or (side == Player.Side.RIGHT and is_moving_right())

func is_moving_left():
	return vel.x < 0
	
func is_moving_right():
	return vel.x > 0
	
# sometimes we get really small values on the y-axis, for some reason.
# they're between -5 and 5.
# to be safe, we check for values < -10 for jumping and values > 10 for falling.
# a nicer solution would be to fix the small values, ofc...
func is_jumping():
	return vel.y < -10

func is_falling():
	return vel.y > 10
