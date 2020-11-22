extends RigidBody2D

export (int) var max_speed = 200
var motion = Vector2()
var hitGround = false
var timeSpentOnGround = 0
var servicePosition = null
var originalBounce = 1

func _ready():
	originalBounce = get_physics_material_override().get_bounce()

func _physics_process(delta):
	
	if(not hitGround):
		var movecurve = get_linear_velocity().normalized()
		self.rotation = movecurve.angle()
		$Schlagpartikel.direction = -movecurve
		var shuttle_speed = get_linear_velocity().length()
		$Schlagpartikel.amount = shuttle_speed/10
		$Schlagpartikel.initial_velocity = shuttle_speed
		$Schlagpartikel.emitting = true
	else:
		timeSpentOnGround += delta
		if(timeSpentOnGround > 1):
			setServicePosition()
			clearGround()

func clearGround():
	hitGround = false
	timeSpentOnGround = 0
	get_physics_material_override().set_bounce(originalBounce)

func hitGround(position):
	cancelAllForces()
	hitGround = true
	servicePosition = position


func setServicePosition():
	set_sleeping(true)
	set_deferred("global_position", servicePosition)

func cancelAllForces():
	get_physics_material_override().set_bounce(0)
	add_central_force(-linear_velocity)
	add_torque(-applied_torque)

#func printForces():
#	print("linear velocity: %s" % linear_velocity)
#	print("inertia: %s" % inertia)
#	print("bounce: %s" % bounce)
#	print("torque: %s" % applied_torque)
#	print("gravity scale: %s " % gravity_scale)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
