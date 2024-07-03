class_name Projectile_AssaultRifle extends BaseProjectile

const SPEED: int = 200;
const DAMAGE: int = 2;

@onready var destroy_bullet_timer = $DestroyBulletTimer

func _ready():
	InitiateProjectile(SPEED, DAMAGE, destroy_bullet_timer);
	super()

func _process(delta):
	super(delta)
