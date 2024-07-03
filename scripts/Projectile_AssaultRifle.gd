extends BaseProjectile

const SPEED: int = 200;
@onready var destroy_bullet_timer = $DestroyBulletTimer

func _ready():
	InitiateProjectile(SPEED, destroy_bullet_timer);
	super()

func _process(delta):
	super(delta)
