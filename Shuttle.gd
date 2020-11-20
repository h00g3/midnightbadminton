extends RigidBody2D

export (int) var max_speed = 200
var motion = Vector2()

func _physics_process(delta):
	
	#print (motion)
	
	var movecurve = get_linear_velocity().normalized()
	self.rotation = movecurve.angle()
	
	
	
