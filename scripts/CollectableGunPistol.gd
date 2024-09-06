extends BaseCollectableGun

#CONSTS
const PISTOL_COLLECTED_GUN = preload("res://scenes/Guns/Collected/CollectedGunPistol.tscn")

func _ready():
	super()
	CollectableGun = PISTOL_COLLECTED_GUN
