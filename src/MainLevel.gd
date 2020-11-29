extends Node2D

onready var players = {}
onready var shuttle = null
onready var service_side = Player.Side.RIGHT
onready var serviceOffset = Vector2(-50,-50)

var shuttle_hit_ground = false
var timeSpentOnGround = 0

export (int) var winscore
export (int) var satzno

onready var name_title = $Scoreboard/EventTitleContainer/Sprite_unten
onready var point_title = $Scoreboard/EventTitleContainer/Sprite_oben

const SATZSPRITE = preload("res://scenes/SatzSprite.tscn")

var formation = Vector2(5, 1)

func _ready():
	$PlayerK/Node2D.scale.x = -$PlayerK/Node2D.scale.x # Mirror Player
	$Scoreboard/Time.connect("TIMEOVER", self, "_on_Timer_Timeout")
	add_player("Fanny", $PlayerF, Player.Side.LEFT)
	add_player("Kenny", $PlayerK, Player.Side.RIGHT)
	add_shuttle()
	service()
	add_base_satz_sprites()

func add_player(name, physics_body, side):
	players[side] = load("res://src/Player.gd").new(name, physics_body, side)

func add_shuttle():
	if shuttle == null:
		shuttle = load("res://scenes/Shuttle.tscn").instance()

func delete_shuttle():
	if shuttle != null:
		shuttle.free()
		shuttle = null

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
		shuttle.apply_central_impulse(Vector2(0,-20000))
	show_scores()
	players_stare_at_shuttle()
	
func _on_Timer_Timeout():
	if players[Player.Side.LEFT].score > players[Player.Side.RIGHT].score :
		win(players[Player.Side.LEFT])
	elif players[Player.Side.LEFT].score < players[Player.Side.RIGHT].score :
		print ("%s Wins" %players[Player.Side.RIGHT].name)
		win(players[Player.Side.RIGHT])
	else:
		print ("Gleichstand")

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
	$Scoreboard/StatusLabel.text = "Punkt für %s!" % player.name
	
	if score >= winscore:
		if two_score_difference() :
			win(player)
	if player.get_score_satz() >= satzno :
		total_win(player)

func two_score_difference() :
	var difference = players[Player.Side.LEFT].score - players[Player.Side.RIGHT].score
	return abs(difference) > 1 

func score_animations(scoring_side):
	players[scoring_side].get_physics_body().Cheer()
	players[other_side(scoring_side)].get_physics_body().Sad()

func other_side(side):
	if(side == Player.Side.LEFT):
		return Player.Side.RIGHT
	else:
		return Player.Side.LEFT

func decide_title_color(player):
	if player.name == "Kenny" :
		point_title.set_texture(load("res://Menue/POINT_red.png"))
	else :
		point_title.set_texture(load("res://Menue/point_black.png"))

func apply_animation_textures(player, sequence):
	var is_black : bool
	if player.name == "Kenny" :
		is_black = false
	else :
		is_black = true
	
	if sequence == "Point1" :
		if is_black == false :
			point_title.set_texture(load("res://Menue/POINT_red.png"))
			name_title.set_texture(load("res://Menue/kenny_Title.png"))
		else :
			point_title.set_texture(load("res://Menue/point_black.png"))
			name_title.set_texture(load("res://Menue/fanny_Title.png"))
	elif sequence == "Totalwin1" :
		if is_black == false :
			point_title.set_texture(load("res://Menue/kenny_Title.png"))
			name_title.set_texture(load("res://Menue/WINS_red.png"))
		else :
			point_title.set_texture(load("res://Menue/fanny_Title.png"))
			name_title.set_texture(load("res://Menue/WINS_blue.png"))
			
	point_title.visible = true
	name_title.visible = true

func play_animation_and_sound(animation):
	$Scoreboard/EventTitleContainer/AnimationPlayer.play(animation)
	$AudioStreamPlayer.set_stream(load("res://Audio/sound_"+animation+".wav"))
	$AudioStreamPlayer.play()

func win(player):
	player.score_satz()
	count_satz(player)
	print ("%s wins!" % player.name)
	players[Player.Side.LEFT].reset_score()
	players[Player.Side.RIGHT].reset_score()
	apply_animation_textures(player, "Point1")
	play_animation_and_sound("Point1")
	#get_tree().reload_current_scene()
	
func total_win(player):
	$Scoreboard/StatusLabel.text = "%s gewinnt das Spiel!" % player.name
	apply_animation_textures(player, "Totalwin1")
	play_animation_and_sound("Totalwin1")

	players[Player.Side.LEFT].reset_all()
	players[Player.Side.RIGHT].reset_all()
	remove_satz_sprites()
	add_base_satz_sprites()

func show_scores():
	$Scoreboard/Fscore.text = str(players[Player.Side.LEFT].score)
	$Scoreboard/Kscore.text = str(players[Player.Side.RIGHT].score)

func isShuttle(body):
	return body.get_name() == "Shuttle"

func players_stare_at_shuttle():
	var look_position = shuttle.global_position
	for player in players.values():
		player.get_physics_body().stare_at(look_position)

func count_satz(player):
	var satz_status = Vector2(players[Player.Side.LEFT].score_satz, players[Player.Side.RIGHT].score_satz)
	$Scoreboard/StatusLabel.text = "Stand: "+(str(satz_status.x)+" : "+(str(satz_status.y)))
	
	for x in (satz_status.x) :
		add_satz_sprite(x, -30, 655, 160, 0.037, Color(1,1,1,1))
	for y in (satz_status.y) :
		add_satz_sprite(y, 30, 800, 200, 0.037, Color(1,1,1,1))
func add_base_satz_sprites():
	for i in (satzno) :
		add_satz_sprite(i, -30, 655, 160, 0.044, Color(0,0,0,0.2))
		add_satz_sprite(i, 30, 800, 200, 0.044, Color(0,0,0,0.2))
func add_satz_sprite(y, direction, pos, rot, scale, color) :
	var new_satzsprite_pos = Vector2(0, 20)
	new_satzsprite_pos.x = y*(direction)
	var new_satzsprite = SATZSPRITE.instance()
	new_satzsprite.rotation_degrees = rot
	new_satzsprite.position = new_satzsprite_pos + Vector2(pos, 0)
	new_satzsprite.scale = Vector2(scale, scale)
	new_satzsprite.modulate = color
	$Scoreboard.add_child(new_satzsprite)
func remove_satz_sprites():
	var scoreboard = get_node("Scoreboard")
	for child in scoreboard.get_children() :
		print (child.get_name())
		if child.get_name().begins_with("@SatzSprite") :
			child.free()


func _on_AnimationPlayer_animation_finished(anim_name):
	point_title.visible = false
	name_title.visible = false
	pass # Replace with function body.
