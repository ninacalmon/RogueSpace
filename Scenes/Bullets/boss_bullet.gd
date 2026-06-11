extends Bullet
class_name BossBullet

func _on_body_entered(body: PhysicsBody2D):
	if !(body is Enemy) and !(body is Boss):
		queue_free()
