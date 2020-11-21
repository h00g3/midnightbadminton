extends RigidBody2D

export (int) var max_speed = 200
var motion = Vector2()
var hitGround = false
var timeSpentOnGround = 0
var servicePosition = null
var originalBounce = 0

func _ready():
	var physicsMaterial = get_physics_material_override()
	physicsMaterial.set_bounce(originalBounce)
	physicsMaterial.set_friction(1)
	physicsMaterial.set_rough(true)
	print("gravity scale: %s " % gravity_scale)
	#set_sleeping(true)

func _physics_process(delta):
#	print(is_sleeping())
#	print(mode)
#	print("linear velocity: %s" % linear_velocity)
#	print("torque: %s" % applied_torque)
	
	
	if(not hitGround):
		var movecurve = get_linear_velocity().normalized()
		self.rotation = movecurve.angle()
	else:
		print("time spent on ground: %s" % [timeSpentOnGround])
		printForces()
		timeSpentOnGround += delta
		if(timeSpentOnGround > 1):
			setServicePosition()
			clearGround()

func clearGround():
	hitGround = false
	timeSpentOnGround = 0
	get_physics_material_override().set_bounce(0)

func hitGround(position):
	cancelAllForces()
	hitGround = true
	servicePosition = position
	set_mode(RigidBody2D.MODE_STATIC)

func setServicePosition():
	printForces()
	set_sleeping(true)
	set_deferred("global_position", servicePosition)
	set_axis_velocity(clearSmallValues(linear_velocity))
	set_gravity_scale(0)
#	set_deferred("global_position", position)
#	set_deferred("linear_velocity", Vector2())
#	set_deferred("angular_velocity", 0.0)
#	set_deferred("weight", 0)
#	set_deferred("mass", 0)
#	add_force(Vector2(), Vector2(50000, 50000))
#	apply_central_impulse(Vector2(50000,50000))
#	set_sleeping(true)
#	set_deferred("applied_force", Vector2())
#	set_global_position(position)
#	set_linear_velocity(Vector2(0,0))
#	set_angular_velocity(0.0)
#	set_applied_force(Vector2())

func cancelAllForces():
#	print("applied force: %s" % applied_force)
	printForces()
	get_physics_material_override().set_bounce(0)
	
	var inverseVelocity = (-linear_velocity)
	add_central_force(inverseVelocity)
	var inverseTorque = (-applied_torque)
	add_torque(inverseTorque)

func clearSmallValues(vector):
	var x = abs(vector.x)
	var y = abs(vector.x)
	
	if(x <= 0.1):
		x = 0
	if(y <= 0):
		y = 0
	return Vector2(x,y)
	
func printForces():
	print("linear velocity: %s" % linear_velocity)
	print("inertia: %s" % inertia)
	print("bounce: %s" % bounce)
	print("torque: %s" % applied_torque)
	print("gravity scale: %s " % gravity_scale)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
