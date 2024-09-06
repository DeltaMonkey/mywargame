extends Camera2D

#@EXPORTS
@export var TileMapLayerNode: TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready():
	var mapRectSize = TileMapLayerNode.get_used_rect().size
	var tileSize = TileMapLayerNode.rendering_quadrant_size
	var worldSizeInPixels = mapRectSize * tileSize
	limit_top = 0
	limit_left = 0
	limit_right = worldSizeInPixels.x
	limit_bottom = worldSizeInPixels.y
