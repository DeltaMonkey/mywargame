class_name Projectile_AssaultRifle extends BaseProjectile

const SPEED: float = 200;
const DAMAGE: int = 2;

@onready var destroy_bullet_timer = $DestroyBulletTimer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready():
	InitiateProjectile(SPEED, DAMAGE, destroy_bullet_timer, sprite_2d, collision_shape_2d);
	super()

func _process(delta):
	super(delta)
