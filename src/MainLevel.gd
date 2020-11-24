extends Node2D

onready var players = {}
onready var shuttle = null
onready var service_side = Player.Side.LEFT
onready var serviceOffset = Vector2(0,-200)
onready var winscore = 2
var shuttle_hit_ground = false
var timeSpentOnGround = 0

func _ready():
	$PlayerK/Node2D.scale.x = -0.2
	add_player("Fanny", $PlayerF, Player.Side.LEFT)
	add_player("Kenny", $PlayerK, Player.Side.RIGHT)
	add_shuttle()
	service()

func add_player(name, physics_body, side):
	players[side] = load("res://src/Player.gd").new(name, physics_body, side)

func add_shuttle():
	if shuttle == null:
		print("getting shuttle instance")
		shuttle = load("res://scenes/Shuttle.tscn").instance()

func delete_shuttle():
	if shuttle != null:
		shuttle.free()
		shuttle = null
		print("shuttle deleted")

func service():
	shuttle.set_mode(RigidBody2D.MODE_STATIC)
	parent_shuttle_with_service_player()
	shuttle.set_position(serviceOffset)

func parent_shuttle_with_service_player():
	var player_shape = get_service_player_shape()
	parent_shuttle_with(player_shape)
	
func get_service_player_shape():
	var player = players[service_side]
	return player.getPlayerCollisionShape()

func parent_shuttle_with(node):
	var parent = shuttle.get_parent()
	if parent != null:
		parent.remove_child(shuttle)
	node.add_child(shuttle)

func _process(delta):
	if Input.is_action_pressed("restart") :
		get_tree().reload_current_scene()
	if(shuttle_hit_ground):
		shuttle_on_ground(delta)
	# do this only if a player is currently having their service
	elif is_player_performing_service() and pressed_service():
		parent_shuttle_with_main_level()
		shuttle.set_mode(RigidBody2D.MODE_RIGID)
	show_scores()

func is_player_performing_service():
	return shuttle.get_parent() == get_service_player_shape()

# checks if the service input pressed also matches the player currently
# having their service
func pressed_service():
	return (Input.is_action_just_pressed("2_down") and service_side == Player.Side.LEFT) or (Input.is_action_just_pressed("ui_down") and service_side == Player.Side.RIGHT)

func parent_shuttle_with_main_level():
	var shuttle_position = shuttle.get_global_position()
	parent_shuttle_with(self)
	shuttle.set_global_position(shuttle_position)

func shuttle_on_ground(delta):
	timeSpentOnGround += delta
	if timeSpentOnGround >= 1:
		print("shuttle on ground for more than 1 second")
		delete_shuttle()
		add_shuttle()
		timeSpentOnGround = 0
		shuttle_hit_ground = false
		service()
	
func _on_Rechts_body_entered(body):
	shuttle_hit_ground(body, Player.Side.RIGHT)

func _on_Links_body_entered(body):
	shuttle_hit_ground(body, Player.Side.LEFT)

func shuttle_hit_ground(body, side):
	if isShuttle(body):
		var scoring_side = other_side(side)
		score(scoring_side)
		service_side = side
		shuttle_hit_ground = true

func score(scoring_side):
	score_animations(scoring_side)
	var player = players[scoring_side]
	var score = player.score()
	if score >= winscore:
		win(player)

func score_animations(scoring_side):
	players[scoring_side].get_physics_body().Cheer()
	players[other_side(scoring_side)].get_physics_body().Sad()

func other_side(side):
	if(side == Player.Side.LEFT):
		return Player.Side.RIGHT
	else:
		return Player.Side.LEFT

func win(player):
	print ("%s wins!" % player.name)
	get_tree().reload_current_scene()
	
func show_scores():
	$Scoreboard/Fscore.text = str(players[Player.Side.LEFT].score)
	$Scoreboard/Kscore.text = str(players[Player.Side.RIGHT].score)

func isShuttle(body):
	return body.get_name() == "Shuttle"


