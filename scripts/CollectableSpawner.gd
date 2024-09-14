extends Node2D

#@ONREADIES
@onready var SpawnTimer: Timer = $SpawnTimer

#VARS
var CurrentSpawnedItem: Node2D
var CollectableList: Array[PackedScene] = []  

func _ready() -> void:
	CollectableList.append(preload("res://scenes/Guns/Collectable/CollectableGunAssaultRifle.tscn"))
	CollectableList.append(preload("res://scenes/Guns/Collectable/CollectableGunPistol.tscn"))
	CollectableList.append(preload("res://scenes/HealthBox.tscn"))
	
	SpawnTimer.connect("timeout", SpawnCollectable)
	SpawnCollectable()

func _process(_delta: float) -> void:
	if CurrentSpawnedItem == null && SpawnTimer.time_left <= 0:
		SpawnTimer.start()

func SpawnCollectable() -> void:
	if CurrentSpawnedItem == null:
		var collectableRef: PackedScene = CollectableList.pick_random() as PackedScene
		var collectableInstance: Node2D = collectableRef.instantiate()
		get_tree().get_root().get_node("Game").add_child.call_deferred(collectableInstance)
		collectableInstance.global_position = global_position
		CurrentSpawnedItem = collectableInstance
