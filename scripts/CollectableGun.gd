extends Area2D

var collected_gun = preload("res://scenes/CollectedGun.tscn")

func _on_body_entered(body):
	body.equip_gun(collected_gun)
	queue_free()
