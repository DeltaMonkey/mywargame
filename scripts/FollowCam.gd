extends Camera2D

@export var tilemap: TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	var mapRectSize = tilemap.get_used_rect().size
	var tileSize = tilemap.rendering_quadrant_size
	var worldSizeInPixels = mapRectSize * tileSize
	limit_top = 0
	limit_left = 0
	limit_right = worldSizeInPixels.x
	limit_bottom = worldSizeInPixels.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
