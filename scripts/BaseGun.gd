class_name BaseGun extends Node2D

#VARS
var ProjectileBase: PackedScene
var MuzzleNodeBaseGun: Node2D
var ShootCooldownTimerNodeBaseGun: Timer
var BulletCount: int # -1 is infinite bullet

func InitiateGun(
	projectileBase: PackedScene, 
	muzzleNode: Node2D, 
	shootCooldownTimerNode: Timer, 
	bulletCount: int = -1):
		
	ProjectileBase = projectileBase
	MuzzleNodeBaseGun = muzzleNode
	BulletCount = bulletCount
	ShootCooldownTimerNodeBaseGun = shootCooldownTimerNode
	

## returns remaining bullet count
## -1 is infinite bullet
## -2 waiting to cooldown
func Shoot(direction: int) -> int:
	if ShootCooldownTimerNodeBaseGun.time_left > 0: return -2
	
	if(BulletCount == -1 || BulletCount > 0):
		if BulletCount != -1: BulletCount = BulletCount - 1
		
		ShootCooldownTimerNodeBaseGun.start()
		
		var bullet_instance = ProjectileBase.instantiate();
		var bullet: BaseProjectile = bullet_instance as BaseProjectile
		
		bullet.set_scale(Vector2(direction, 1))
		bullet.Direction = direction
		
		if(get_parent().get_parent().get_parent().is_in_group(Constants.GROUPS_ENEMY)):
			bullet.IsGunOnEnemyHands = true
		elif(get_parent().get_parent().get_parent().is_in_group(Constants.GROUPS_PLAYER)):
			bullet.IsGunOnEnemyHands = false
		
		bullet.global_position = MuzzleNodeBaseGun.global_position
		
		get_tree().get_root().get_node("Game").add_child(bullet)
		
	return BulletCount
