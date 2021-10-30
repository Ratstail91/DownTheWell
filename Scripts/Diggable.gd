extends TileMap

func dig(position: Vector2):
	self.set_cellv(self.world_to_map(position), -1)
