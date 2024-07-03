class_name BaseGun extends Node2D

var ProjectileBase: PackedScene
var Muzzle: Node2D

func Shoot(direction: int):
	var bullet: BaseProjectile = ProjectileBase.instantiate() as BaseProjectile
	bullet.set_scale(Vector2(direction, 1))
	bullet.Direction = direction
	bullet.global_position = Muzzle.global_position;
	get_tree().get_root().add_child(bullet)
