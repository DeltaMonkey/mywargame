class_name BaseGun extends Node2D

var projectile_base: PackedScene
var muzzle: Node2D

func shoot(direction: int):
	var bullet: BaseProjectile = projectile_base.instantiate() as BaseProjectile
	bullet.set_scale(Vector2(direction, 1))
	bullet.direction = direction
	bullet.global_position = muzzle.global_position;
	get_tree().get_root().add_child(bullet)
