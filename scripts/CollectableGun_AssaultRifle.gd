extends BaseCollectableGun

const ASSAULT_RIFLE_COLLECTED_GUN = preload("res://scenes/Guns/Collected/CollectedGun_AssaultRifle.tscn")

func _ready():
	super()
	collectable_gun = ASSAULT_RIFLE_COLLECTED_GUN
