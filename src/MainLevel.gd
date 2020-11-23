extends Node2D

onready var players = {}
onready var shuttle = null# = $Shuttle
onready var serviceOffset = Vector2(0,-200)
onready var winscore = 10
onready var service_side = Player.Side.LEFT
var shuttle_rigid = false
var hitGround = false
var timeSpentOnGround = 0

func _ready():
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
		print("shuttle deleted")
		shuttle = null

func service():
	shuttle.set_mode(RigidBody2D.MODE_STATIC)
	parent_shuttle_with_service_player()
	shuttle.set_position(serviceOffset)
	shuttle_rigid = false

func parent_shuttle_with_service_player():
	var player = players[service_side]
	var player_shape = player.getPlayerCollisionShape()
	parent_shuttle_with(player_shape)

func parent_shuttle_with(node):
	var parent = shuttle.get_parent()
	if parent != null:
		parent.remove_child(shuttle)
	node.add_child(shuttle)

func _process(delta):
	if Input.is_action_pressed("restart") :
		get_tree().reload_current_scene()
	if !shuttle_rigid and (Input.is_action_just_pressed("2_down") and service_side == Player.Side.LEFT) or (Input.is_action_just_pressed("ui_down") and service_side == Player.Side.RIGHT):
		parent_shuttle_with_main_level()
		shuttle.set_mode(RigidBody2D.MODE_RIGID)
		shuttle_rigid = true
	if(hitGround):
		timeSpentOnGround += delta
	show_scores()

func parent_shuttle_with_main_level():
	var shuttle_position = shuttle.get_global_position()
	parent_shuttle_with(self)
	shuttle.set_global_position(shuttle_position)

func _on_Rechts_body_entered(body):
	shuttle_hit_ground(body, Player.Side.RIGHT)

func _on_Links_body_entered(body):
	shuttle_hit_ground(body, Player.Side.LEFT)

func shuttle_hit_ground(body, side):
	if isShuttle(body):
		score(side)
		hitGround = true
		players[side].get_physics_body().Sad()
		players[other_side(side)].get_physics_body().Cheer()

func score(side):
	var player = players[side]
	var score = player.score()
	if score < winscore:
		if timeSpentOnGround >= 1:
			print("shuttle on ground for more than 1 second")
			delete_shuttle()
			add_shuttle()
			timeSpentOnGround = 0
			hitGround = false
			service_side = other_side(side)
			service()
	else:
		win(side)

func other_side(side):
	if(side == Player.Side.LEFT):
		return Player.Side.RIGHT
	else:
		return Player.Side.LEFT

func win(side):
	print ("%s wins!" % players[side].name)
	get_tree().reload_current_scene()
	
func show_scores():
	$Scoreboard/Fscore.text = str(players[Player.Side.LEFT].score)
	$Scoreboard/Kscore.text = str(players[Player.Side.RIGHT].score)

func isShuttle(body):
	return body.get_name() == "Shuttle"


