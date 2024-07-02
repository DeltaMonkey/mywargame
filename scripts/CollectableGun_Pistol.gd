extends BaseCollectableGun

const PISTOL_COLLECTED_GUN = preload("res://scenes/Guns/Collected/CollectedGun_Pistol.tscn")

func _ready():
	super()
	collectable_gun = PISTOL_COLLECTED_GUN
