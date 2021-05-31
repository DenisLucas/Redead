extends KinematicBody2D

export var speed = 300
var dir = Vector2.ZERO
var move = Vector2.ZERO


func _physics_process(_delta):
	$Sprite.rotation = dir.angle() - 80
	move.x = speed * dir.x
	move.y = speed * dir.y
	move = move_and_slide(move)
	


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Area2D_body_entered(body):
	if body.is_in_group("enemy"):
		body.hitted(body)
		$AnimatedSprite.visible = true
		$Sprite.visible = false
		dir = Vector2.ZERO
		$AnimatedSprite/Light2D.enabled = true
		
		$AnimatedSprite.play("default")
	if body.is_in_group("wall"):
		queue_free()


func _on_AnimatedSprite_animation_finished():
	queue_free()
