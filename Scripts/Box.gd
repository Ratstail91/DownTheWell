extends KinematicBody2D

const gravity = Vector2(0, 10)
var motion = Vector2(0, 0)
var _submergedFrames = 0

func _physics_process(_delta):
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
	
	#max speed
	if abs(motion.x) > 100:
		motion.x = 100 * sign(motion.x)
	if abs(motion.y) > 250:
		motion.y = 250 * sign(motion.y)
	
	#actually move
	move_and_slide(motion)
	
	#friction
	var collision = null
	if get_slide_count() > 0:
		collision = get_slide_collision( get_slide_count() -1 )
	
	if (collision && collision.remainder.y > 0) || $Submerged.is_colliding():
		motion *= 0.9
	
	if collision && collision.travel.length() == 0:
		motion = Vector2()

func push(x: Vector2):
	motion += Vector2(x.x, 0)
