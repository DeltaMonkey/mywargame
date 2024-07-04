class_name BaseCollectableGun extends Area2D

var CollectableGun: PackedScene;

func _ready():
	connect("body_entered", on_body_entered)

func on_body_entered(body: BaseCharacter) -> void:
	if body.is_in_group("player") or body.is_in_group("enemy"):
		body.EquipGun(CollectableGun)
		queue_free()
