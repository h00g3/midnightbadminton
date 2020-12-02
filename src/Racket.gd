class_name Racket

var maximum_x_impulse = 70000
var minimum_x_impulse = 10000
var average_x_impulse = 35000

var minimum_y_impulse = -20000
var average_y_impulse = -50000
var smash_y_impulse = -20000

func hit_shuttle(shuttle, player):
	var impulse = calculate_impulse(shuttle, player)
	shuttle.apply_central_impulse(impulse)

func calculate_impulse(shuttle, player):
	var x = calculate_x_impulse(player)
	var y = calculate_y_impulse(player)
	return Vector2(x,y)

func calculate_x_impulse(player):
	var result = average_x_impulse
	if player.is_moving_towards_net():
		result = maximum_x_impulse
	elif player.is_moving_away_from_net():
		result = minimum_x_impulse
	
	if player.is_right():
		result = -result
	
	return result
	
func calculate_y_impulse(player):
	if player.is_jumping():
		return smash_y_impulse
	elif player.is_falling():
		return minimum_y_impulse
	else:
		return average_y_impulse
