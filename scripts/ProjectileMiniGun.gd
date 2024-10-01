class_name ProjectileMiniGun extends BaseProjectile

#CONSTS
const SPEED: float = 200;
const DAMAGE: int = 1;

#@ONREADIES
@onready var DestroyBulletTimer: Timer = $DestroyBulletTimer
@onready var Sprite2DNode: Sprite2D = $Sprite2D
@onready var CollisionShape2DNode: CollisionShape2D = $CollisionShape2D

func _ready():
	InitiateProjectile(SPEED, DAMAGE, DestroyBulletTimer, Sprite2DNode, CollisionShape2DNode);
	super()

func _process(delta):
	super(delta)
