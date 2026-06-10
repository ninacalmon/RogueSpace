extends Bullet
class_name BossBullet

func _on_body_entered(body: RigidBody2D):
	if (body is Player):
		queue_free()
