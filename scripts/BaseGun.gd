class_name BaseGun extends Node2D

var ProjectileBase: PackedScene
var Muzzle: Node2D
# -1 is infinite bullet
var BulletCount: int 

func InitiateGun(projectileBase: PackedScene, muzzle: Node2D, bulletCount: int = -1):
	ProjectileBase = projectileBase
	Muzzle = muzzle
	BulletCount = bulletCount

## returns remaining bullet count
func Shoot(direction: int) -> int:
	if(BulletCount == -1 || BulletCount > 0):
		if BulletCount != -1: BulletCount = BulletCount - 1
		var bullet: BaseProjectile = ProjectileBase.instantiate() as BaseProjectile
		bullet.set_scale(Vector2(direction, 1))
		bullet.Direction = direction
		bullet.global_position = Muzzle.global_position
		get_tree().get_root().add_child(bullet)
	
	return BulletCount
