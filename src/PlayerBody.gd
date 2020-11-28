extends KinematicBody2D

class_name PlayerBody

onready var racket = load("res://src/Racket.gd").new()

onready var state_machine = $Node2D/AnimationTree.get("parameters/playback")
onready var player_sounds = $AudioStreamPlayer2D

var audio_attacks = Vector2(1,4)
var audio_yays = Vector2(5,9)
var audio_ojes = Vector2(10,14)
var audio_schlaege = Vector2(1,6)

onready var randomi = 0

# Vektor für Bewegung, Sprungkraft und Gravity
var vel = Vector2() setget ,get_velocity

var side setget set_side, get_side

func set_side(_side):
	side = _side
	
func get_side():
	return side

func make_random_nr(von, bis) :
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randomi = rng.randi_range(von, bis)
	return randomi
	
func PlayAudio(start_tc, length) :
	if player_sounds.playing == false :
		player_sounds.play(start_tc)
		yield(get_tree().create_timer(length), "timeout")
		player_sounds.stop()

func Jump():
	state_machine.travel("Jump")
	PlayAudio(make_random_nr(audio_attacks.x, audio_attacks.y),0.5)

func Walk():
	if state_machine.get_current_node() != ("Walking"):
		state_machine.travel("Walking")

func Schlag():
	state_machine.travel("Schlag")
	PlayAudio(make_random_nr(audio_schlaege.x, audio_schlaege.y),1)

func Cheer():
	state_machine.travel("Winning")
	PlayAudio(make_random_nr(audio_yays.x, audio_yays.y),1)

func Sad():
	state_machine.travel("Lose")
	PlayAudio(make_random_nr(audio_ojes.x, audio_ojes.y),1)

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
