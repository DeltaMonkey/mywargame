class_name BaseCollectableGun extends Area2D

var CollectableGun: PackedScene;

func _ready():
	connect("body_entered", on_body_entered)

func on_body_entered(body: BasePlayer) -> void:
	body.EquipGun(CollectableGun)
	queue_free()
