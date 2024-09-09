extends ProgressBar

#@EXPORTS
@export var Player: BasePlayer

func _ready():
	value = Player.CurrentHealth * 100 / Player.MaxHealth
	Player.HealthChanged.connect(update)
	
func update():
	value = Player.CurrentHealth * 100 / Player.MaxHealth
