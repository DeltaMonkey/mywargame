extends Node2D

#@ONREADIES
@onready var JumpPathNode = $JumpPath as Path2D

#@EXPORTS
@export var Direction = 1; # 1 right, -1 left

#VARS
var dedectedEnemyObjIdsArray: Array[int]

func _on_enemy_dedector_body_entered(body) -> void:
	var enemyObj = body as BaseEnemy
	
	if(enemyObj.Direction == Direction):
		if(enemyObj.is_in_group('enemy') && dedectedEnemyObjIdsArray.find(enemyObj.get_instance_id()) == -1 && enemyObj.JumpRequest()):
			
			dedectedEnemyObjIdsArray.push_back(enemyObj.get_instance_id())
			var pathFollow2d = PathFollow2D.new()
			pathFollow2d.rotates = false
			JumpPathNode.add_child(pathFollow2d)
			# A frame must be runned before the follow path, 
			# to be sure properly created
			enemyObj.ReparentNode = pathFollow2d;
			# gravity must be zero to follow path right
			enemyObj.gravity = 0
			# must clear the velocity to stop enemy
			# or collision cannot work properly
			enemyObj.velocity.y = 0

func _physics_process(delta) -> void:
	for followPath in JumpPathNode.get_children():
		var followPath2D = followPath as PathFollow2D
		
		# null control required cuz it's working once for null obj
		var enemy: BaseEnemy = null;
		if 0 < followPath.get_child_count():
			enemy = followPath.get_child(0) as BaseEnemy
			
		if followPath && followPath2D && enemy:
			var jumpVelocity = enemy.JumpVelocity;
			# this calculation important for ratio, it is just basic numeric calc
			followPath2D.progress_ratio += 1 * jumpVelocity * delta
			if(followPath2D.progress_ratio >= 1 - (jumpVelocity * delta)):
				var tree_root = get_tree().get_root()
				enemy.ReparentNode = tree_root
				# We are getting sure with DeleteOldParentNodeRef
				# that we changed enemy parent to root and
				# now we can remove the floowPath the enemy created to jump
				enemy.DeleteOldParentNodeRef = followPath2D
				# taking the gravity back
				enemy.gravity = enemy.DEFAULT_GRAVITY
				var enemyIndexAtDedectedArray = dedectedEnemyObjIdsArray.find(enemy.get_instance_id());
				if(enemyIndexAtDedectedArray != -1):
					dedectedEnemyObjIdsArray.remove_at(enemyIndexAtDedectedArray)
