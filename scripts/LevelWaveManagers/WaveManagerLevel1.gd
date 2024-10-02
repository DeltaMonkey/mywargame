class_name WaveManagerLevel1 extends BaseWaveManager

var LEVEL_1_BOSS_FIGHT = preload("res://scenes/Level1BossFight.tscn")

func _ready() -> void:
	InitilizeWaveManager()
	
	WaveEnemyCounts = [
		2,
		#3
	]
	
	WaveEnemyModels = [
		#WAVE 1
		WaveManagerEnemyModel.new(GUN1, SpawnPoints[0]),
		WaveManagerEnemyModel.new(GUN1, SpawnPoints[2]),
		#WAVE 2
		#WaveManagerEnemyModel.new(GUN1, SpawnPoints[0]),
		#WaveManagerEnemyModel.new(GUN2, SpawnPoints[1]),
		#WaveManagerEnemyModel.new(GUN1, SpawnPoints[2]),
	]
	
	call_deferred("OnStart")
	
func OnStart():
	NextLevel = LEVEL_1_BOSS_FIGHT
