extends KinematicBody2D

class_name PlayerBody

onready var racket = load("res://src/Racket.gd").new()
#onready var progress_bar = load("res://scenes/Progressbar.tscn").new()
onready var head = find_node("head")
onready var progress_bar = find_node("Progressbar")
const MAX_ANGLE_LOOK_UP = -0.75
const MAX_ANGLE_LOOK_DOWN = 1

onready var state_machine = $Node2D/AnimationTree.get("parameters/playback")
onready var player_sounds = $AudioStreamPlayer2D
onready var racket_audio = $RacketAudioStreamPlayer2D

var audio_attacks = Vector2(0,4)
var audio_yays = Vector2(10,14)
var audio_ojes = Vector2(15,19)
var audio_schlaege = Vector2(0,6)

onready var randomi = 0

# Vektor für Bewegung, Sprungkraft und Gravity
var vel = Vector2() setget ,get_velocity

var side setget set_side, get_side

func set_side(_side):
	side = _side
	
func get_side():
	return side
	
func get_service_impulse():
	return progress_bar.get_value() * (-20000)

func make_random_nr(von, bis) :
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randomi = rng.randi_range(von, bis)
	return randomi
	
func PlayerAudio(start_tc, end_tc, length) :
	if player_sounds.playing == false :
		player_sounds.play(make_random_nr(start_tc, end_tc))
		yield(get_tree().create_timer(length), "timeout")
		player_sounds.stop()

func RacketAudio(start_tc, end_tc, length) :
	racket_audio.play(make_random_nr(start_tc, end_tc))
	yield(get_tree().create_timer(length), "timeout")
	racket_audio.stop()

func Jump():
	state_machine.travel("Jump")
	PlayerAudio(audio_attacks.x, audio_attacks.y, 0.5)

func Walk():
	if state_machine.get_current_node() != ("Walking"):
		state_machine.travel("Walking")

func Schlag():
	state_machine.travel("Schlag")
	RacketAudio(audio_schlaege.x, audio_schlaege.y,1)
	PlayerAudio(audio_attacks.x, audio_attacks.y,0.5)

func Cheer():
	state_machine.travel("Winning")
	PlayerAudio(audio_yays.x, audio_yays.y,1)

func Sad():
	state_machine.travel("Lose")
	PlayerAudio(audio_ojes.x, audio_ojes.y,1)

func stare_at(point):
	var angle = head.get_angle_to(point)
	var rotation = 0
	if(angle < 0):
		rotation = max(angle, MAX_ANGLE_LOOK_UP)
	else:
		rotation = min(angle, MAX_ANGLE_LOOK_DOWN)
	head.rotate(rotation)
	
#	if look_position.x < players[Player.Side.LEFT].get_body_position().x :
#		F_head.flip_h = true
#	else:
#		F_head.flip_h = false

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
	
func is_left():
	return side == Player.Side.LEFT

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
