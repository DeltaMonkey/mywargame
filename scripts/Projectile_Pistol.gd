class_name Projectile_Pistol extends BaseProjectile

const SPEED: float = 150.0;
const DAMAGE: int = 1;

@onready var destroy_bullet_timer = $DestroyBulletTimer

func _ready():
	InitiateProjectile(SPEED, DAMAGE, destroy_bullet_timer);
	super()

func _process(delta):
	super(delta)
