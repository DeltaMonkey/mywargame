extends BaseCollectableGun

const ASSAULT_RIFLE_COLLECTED_GUN = preload("res://scenes/Guns/Collected/AssaultRifle_CollectedGun.tscn")

func _ready():
	super()
	collectable_gun = ASSAULT_RIFLE_COLLECTED_GUN
