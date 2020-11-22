extends Node2D

onready var players = {}
onready var shuttle = $Shuttle
onready var serviceOffset = Vector2(0,-200)
onready var winscore = 10

func _ready():
	add_player("Fanny", $PlayerF, Player.Side.LEFT)
	add_player("Kenny", $PlayerK, Player.Side.RIGHT)

func add_player(name, physics_body, side):
	players[side] = load("res://src/Player.gd").new(name, physics_body, side)

func _process(delta):
	if Input.is_action_pressed("restart") :
		get_tree().reload_current_scene()
	show_scores()

func _on_Rechts_body_entered(body):
	if isShuttle(body):
		score(Player.Side.LEFT)
		players[Player.Side.LEFT].get_physics_body().Cheer()

func _on_Links_body_entered(body):
	if isShuttle(body):
		score(Player.Side.RIGHT)
		players[Player.Side.LEFT].get_physics_body().Sad()

func score(side):
	var player = players[side]
	var score = player.score()
	if score < winscore:
		var other_side = other_side(side)
		var other_player = players[other_side]
		abschlag(other_player)
	else:
		win(side)

func other_side(side):
	if(side == Player.Side.LEFT):
		return Player.Side.RIGHT
	else:
		return Player.Side.LEFT
	

func abschlag(player):
	var collisionShape = getPlayerCollisionShape(player.physics_body)
	var position = collisionShape.position + serviceOffset
	shuttle.hitGround(position)

func win(side):
	print ("%s wins!" % players[side].name)
	get_tree().reload_current_scene()
	
func show_scores():
	$Scoreboard/Fscore.text = str(players[Player.Side.LEFT].score)
	$Scoreboard/Kscore.text = str(players[Player.Side.RIGHT].score)

func isShuttle(body):
	return body.get_name() == "Shuttle"

func getPlayerCollisionShape(player):
	for child in player.get_children():
		if child is CollisionShape2D:
			return child
	push_error ( "no collision shape found for player " % player)
