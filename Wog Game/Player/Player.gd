extends Entity2D

enum {
	USING_LEFT_HAND,
	USING_RIGHT_HAND,
	USING_NO_HAND
}
var state = USING_NO_HAND

func _physics_process(delta):
	var x = Input.get_action_strength("right")-Input.get_action_strength("left")
	var y = Input.get_action_strength("down")-Input.get_action_strength("up")
	move(Vector2(x, y))
	setHandDir(get_local_mouse_position())

	if state == USING_LEFT_HAND:
		useLeftHand()
	elif state == USING_RIGHT_HAND:
		useRightHand()
	else:
		pass
		
	if Input.is_action_just_pressed("left_click"):
		state = USING_LEFT_HAND
	elif Input.is_action_just_pressed("right_click"):
		state = USING_RIGHT_HAND
	if Input.is_action_just_released("left_click"):
		if state != USING_RIGHT_HAND:
			state = USING_NO_HAND
	if Input.is_action_just_released("right_click"):
		if state != USING_LEFT_HAND:
			state = USING_NO_HAND
	#print(state)
			
