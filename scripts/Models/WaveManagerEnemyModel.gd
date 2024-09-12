class_name WaveManagerEnemyModel extends Node

var Gun: PackedScene
var SpawnPoint: Node2D

func _init(gun: PackedScene, spawnPoint: Node2D):
	Gun = gun
	SpawnPoint = spawnPoint
