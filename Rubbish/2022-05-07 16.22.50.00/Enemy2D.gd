extends Entity2D

const SPEED = 300
const FORCE = 0.052
export var equip_left : String
export var equip_right : String
var velocity : Vector2

onready var player_vars = get_node("/root/PlayerVars")
#var target = player_vars.position

func _ready():
	randomize()
	equip_left = 'hand'
	equip_right = 'hand'
	addLeftHandItem(equip_left, self)
	addRightHandItem(equip_right, self)

func _process(delta):
	#player = get_node(player_path)
	if player_vars.position != null:
		match state:
			IDLE:
				pass
			CHASE:
				look(delta)
				
			FIGHT:
				fight(delta)
			
			DEAD:
				pass


func _physics_process(delta):
	var target = get_global_mouse_position()
	velocity = steer(target)
	#move_and_slide(velocity)
	
	if Input.is_action_just_pressed("left_click"):
		wander()


func steer(target : Vector2) -> Vector2:
	var helper = (target - get_position()).normalized() * SPEED 
	var desired_velocity = Vector2(helper.x, helper.y)
	
	var steer = desired_velocity - velocity
	var target_velocity = velocity + (steer * FORCE )
	return target_velocity
	


func move_to(pos : Vector2):
	if position != pos:
		for i in range(10):
			move_and_slide(pos - position)
			#yield(get_tree().create_timer(0.5), "timeout")
			if position == pos:
				break

func combat():
	pass
	
func stab():
	useHand('right')

func block():
	useHand('left')
	
#
#func _on_AttackArea_body_entered(body):
#	if body.is_in_group('player'):
#		if player_vars.state != 'USING_NO_HAND':
#			var randomNumber = randi()%100
#			if randomNumber > 50:
#				block()
#			else:
#				stab()

enum {
	IDLE
	CHASE,
	FIGHT,
	DEAD
}

var state = CHASE
var dir
export var equip_left : String
export var equip_right : String

export var player_path : NodePath
var player : Entity2D = null

onready var player_vars = get_node("/root/PlayerVars")

func init(path):
	player_path = path

func _ready():
	equip_left = 'hand'
	equip_right = 'hand'
	addLeftHandItem(equip_left, self)
	addRightHandItem(equip_right, self)


func idle():
#	var look = get_node("RayCast2D")
#	look.cast_to = (player.position - position)
#	look.force_raycast_update()
#
#	var length = player.position - position
#	if length.length() < 15:
#		state = FIGHT
#
#  # if we can see the target, chase it
#	if look.is_colliding() == false:
#		dir = look.cast_to.normalized()
#		return dir
	pass

func look(delta):
	if health <= 0:
		state = DEAD
	
	setHandDir(player_vars.position - position)
	dir = find_target()
	
	if dir:
		var motion = dir * speed/4
		move(motion)
	
func find_target():
	
	var look = get_node("PlayerCast")
	look.cast_to = (player_vars.position - position)
	look.force_raycast_update()
	
	var length = player_vars.position - position
	if length.length() < 15:
		state = FIGHT
	
  # if we can see the target, chase it
	if look.is_colliding() == false:
		dir = look.cast_to.normalized()
		return dir

  # or chase first scent we can see	
	else:
		for scent in player_vars.scent_trail:
			look.cast_to = (scent.position - position)
			look.force_raycast_update()
			if look.is_colliding() == false:
				dir = look.cast_to.normalized()
				return dir
				break


func fight(delta):
	
	
	if health <= 0:
		state = DEAD
	
	
	setHandDir(player_vars.position - position)
	var look = get_node("PlayerCast")
	look.cast_to = (player_vars.position - position)
	look.force_raycast_update()
	
	var length = player_vars.position - position
	item_in_use = false
	if length.length() > 15:
		useHand("left")
		state = CHASE
		
	if length.length() > 10:
		useHand("right")
		
		


