class_name ProjectileRocket extends BaseProjectile

#CONSTS
const SPEED: float = 75;
const DAMAGE: int = 10;
const PROJECTILE_ROCKET_LAUNCHER_EXPLOTION = preload("res://scenes/Guns/Projectiles/ProjectileRocketExplotion.tscn")

#@ONREADIES
@onready var DestroyBulletTimerNode = $DestroyBulletTimer
@onready var Sprite2DNode: Sprite2D = $Sprite2D
@onready var CollisionShape2DNode: CollisionShape2D = $CollisionShape2D

func _ready():
	InitiateProjectile(SPEED, DAMAGE, DestroyBulletTimerNode, Sprite2DNode, CollisionShape2DNode);
	super()

func _process(delta):
	super(delta)
	
func ProjectileHit(body) -> void:
	var explotionInstance: Node2D = PROJECTILE_ROCKET_LAUNCHER_EXPLOTION.instantiate()
	get_tree().get_root().get_node("Game").add_child.call_deferred(explotionInstance)
	explotionInstance.global_position = global_position
	super(body)
