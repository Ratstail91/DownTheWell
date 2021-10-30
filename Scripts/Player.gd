extends KinematicBody2D

const gravity = Vector2(0, 10)
var motion = Vector2(0, 0)
var _submergedFrames = 0 #for bobbing up and down

func _physics_process(delta):
	#float or fall
	if $Submerged.is_colliding():
		#hitting the water
		if _submergedFrames == 0:
			motion.y /= 2
		_submergedFrames += 1
		
		#get the surface position
		if $Submerged.get_collider().has_method("get_surface"):
			#float
			motion.y += $Submerged.get_collider().get_surface() - self.transform.origin.y
	else:
		#fall normally
		_submergedFrames = 0
		motion += gravity
	
	#left and right
	if Input.is_action_pressed("input_left"):
		motion.x -= 10
	if Input.is_action_pressed("input_right"):
		motion.x += 10
	
	if !Input.is_action_pressed("input_left") && !Input.is_action_pressed("input_right"):
		motion.x = 0
	
	#jump
	if Input.is_action_just_pressed("input_jump") && ($GroundedFirst.is_colliding() || $GroundedSecond.is_colliding() || $Submerged.is_colliding()):
		motion.y = -250
	
	#max speed
	if abs(motion.x) > 100:
		motion.x = 100 * sign(motion.x)
	if abs(motion.y) > 250:
		motion.y = 250 * sign(motion.y)
	
	#actually move
	move_and_slide(motion)
	
	#get collision data
	var pushStrength = Vector2()
	
	var collision = null
	if get_slide_count() > 0:
		collision = get_slide_collision( get_slide_count() -1 )
		pushStrength = collision.remainder * 4
	
	#check for pushables or diggables
	if Input.is_action_pressed("input_left") && $Left.is_colliding():
		if $Left.get_collider().has_method("push"):
			$Left.get_collider().push(pushStrength)
		
		_dig($Left)
	
	if Input.is_action_pressed("input_right") && $Right.is_colliding():
		if $Right.get_collider().has_method("push"):
			$Right.get_collider().push(pushStrength)
		
		_dig($Right)
	
	if Input.is_action_pressed("input_up") && $Up.is_colliding():
		_dig($Up)
	
	if Input.is_action_pressed("input_down") && $Down.is_colliding():
		_dig($Down)
	
	#BUGFIX: catching on the tops of boxes
	if collision && !$Left.is_colliding() && !$Right.is_colliding():
		move_and_collide(Vector2(collision.remainder.x, -1) * delta)

#utility functions
func _dig(node: RayCast2D):
	if Input.is_action_just_pressed("input_dig") && node.get_collider().has_method("dig"):
		node.get_collider().dig(self.transform.origin + node.cast_to)
