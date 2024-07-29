extends Node2D

@onready var jump_path = $JumpPath as Path2D

# 1 right, -1 left
@export var Direction = 1;

var dedectedArray: Array[int]

func _on_enemy_dedector_body_entered(body):
	var enemyObj = body as BaseEnemy
	
	if(enemyObj.Direction == Direction):
		if(enemyObj.is_in_group('enemy') && dedectedArray.find(enemyObj.get_instance_id()) == -1):
			dedectedArray.push_back(enemyObj.get_instance_id())
			var pathFollow2d = PathFollow2D.new()
			pathFollow2d.rotates = false
			jump_path.add_child(pathFollow2d)
			enemyObj.ReparentNode = pathFollow2d;
			enemyObj.gravity = 0
			enemyObj.velocity.y = 0

func _physics_process(delta):
	for followPath in jump_path.get_children():
		var followPath2D = followPath as PathFollow2D
		var enemy: BaseEnemy = null;
		if 0 < followPath.get_child_count():
			enemy = followPath.get_child(0) as BaseEnemy
		if followPath && followPath2D && enemy:
			var jumpVelocity = enemy.JumpVelocity;
			followPath2D.progress_ratio += 1 * jumpVelocity * delta
			if(followPath2D.progress_ratio >= 1 - (jumpVelocity * delta)):
				var tree_root = get_tree().get_root()
				enemy.ReparentNode = tree_root
				enemy.DeleteOldParentNodeRef = followPath2D
				enemy.gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
				var enemyIndexAtDedectedArray = dedectedArray.find(enemy.get_instance_id());
				if(enemyIndexAtDedectedArray != -1):
					dedectedArray.remove_at(enemyIndexAtDedectedArray)
		#path.set_progress(path.get_progress() + followPath.get_child(0).JumpVelocity * delta)
	
