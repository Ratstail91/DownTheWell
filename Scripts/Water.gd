extends Area2D

func get_surface():
	return self.transform.origin.y - self.scale.y * $Collider.shape.extents.y
	
