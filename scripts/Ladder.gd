extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if(body.is_in_group('player')):
		var playerObj = body as BasePlayer
		playerObj.LaddersCollidingAppend()
		

func _on_body_exited(body: Node2D) -> void:
	if(body.is_in_group('player')):
		var playerObj = body as BasePlayer
		playerObj.LaddersCollidingPopFirst()
