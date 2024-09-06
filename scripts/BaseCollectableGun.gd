class_name BaseCollectableGun extends Area2D

var CollectableGun: PackedScene;

func _ready() -> void:
	connect("body_entered", OnBodyEntered)

func OnBodyEntered(body: BaseCharacter) -> void:
	if body.is_in_group(Constants.GROUPS_PLAYER) or body.is_in_group(Constants.GROUPS_ENEMY):
		body.EquipGun(CollectableGun)
		queue_free()
