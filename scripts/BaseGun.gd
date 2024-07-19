class_name BaseGun extends Node2D

var ProjectileBase: PackedScene
var Muzzle: Node2D
var ShootCooldownTimer: Timer
# -1 is infinite bullet
var BulletCount: int 

func InitiateGun(
	projectileBase: PackedScene, 
	muzzle: Node2D, 
	shootCooldownTimer: Timer, 
	bulletCount: int = -1):
		
	ProjectileBase = projectileBase
	Muzzle = muzzle
	BulletCount = bulletCount
	ShootCooldownTimer = shootCooldownTimer
	

## returns remaining bullet count
## -1 is infinite bullet
## -2 waiting to cooldown
func Shoot(direction: int) -> int:
	if ShootCooldownTimer.time_left > 0: return -2
	
	if(BulletCount == -1 || BulletCount > 0):
		if BulletCount != -1: BulletCount = BulletCount - 1
		
		ShootCooldownTimer.start()
		
		var bullet_instance = ProjectileBase.instantiate();
		var bullet: BaseProjectile = bullet_instance as BaseProjectile
		
		bullet.set_scale(Vector2(direction, 1))
		bullet.Direction = direction
		
		if(get_parent().get_parent().is_in_group("enemy")):
			bullet.IsGunOnEnemyHands = true
		elif(get_parent().get_parent().is_in_group("player")):
			bullet.IsGunOnEnemyHands = false
		
		bullet.global_position = Muzzle.global_position
		

			
		get_tree().get_root().add_child(bullet)
	
	return BulletCount
