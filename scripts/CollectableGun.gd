class_name BaseCollectableGun extends Area2D

var collectable_gun;

func _ready():
	connect("body_entered", on_body_entered)

func on_body_entered(body: BasePlayer) -> void:
	body.equip_gun(collectable_gun)
	queue_free()
	
func shoot():
	print("base gun shoot")
