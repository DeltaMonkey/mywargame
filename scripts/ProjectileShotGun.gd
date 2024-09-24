class_name ProjectileShotGun extends BaseProjectile

#CONSTS
const SPEED: float = 200;
const DAMAGE: int = 5;

#@ONREADIES
@onready var DestroyBulletTimerNode = $DestroyBulletTimer
@onready var Sprite2DNode: Sprite2D = $Sprite2D
@onready var CollisionShape2DNode: CollisionShape2D = $CollisionShape2D

func _ready():
	InitiateProjectile(SPEED, DAMAGE, DestroyBulletTimerNode, Sprite2DNode, CollisionShape2DNode);
	super()

func _process(delta):
	super(delta)
