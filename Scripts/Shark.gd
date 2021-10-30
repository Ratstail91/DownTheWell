extends KinematicBody2D

var motion = Vector2(10, 0)

func _physics_process(delta):
	if $First.is_colliding() || $Second.is_colliding():
		motion *= -1
		$First.cast_to *= -1
		$Second.cast_to *= -1
	
	transform.origin += motion * delta
