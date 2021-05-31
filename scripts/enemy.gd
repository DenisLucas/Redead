extends KinematicBody2D

signal destroy(body)
signal onhit(body)
signal damagereduz(damage)
export var speed = 300
export var boostspeed = 400 
export (float, 0.0, 1.0) var acceleracao = 0.0
export (float, 0.0, 1.0) var atrito = 0.0
var dir = Vector2.ZERO
var dead = false
var onboost = false
var move = Vector2.ZERO
export var damage = 1
export var life = 2


func animationmanager():
	if dir.x != 0:
		$Sprite.frame = 1
		if dir.x > 0:
			$Sprite.flip_h = false
		else:
			$Sprite.flip_h = true
	elif dir.y != 0:
		if dir.y > 0:
			$Sprite.frame = 0
		else:
			$Sprite.frame = 2
		
func _physics_process(_delta):
	if life <= 0:
		emit_signal("destroy", self)
	if !dead:
		if !onboost:
			move.x = lerp(move.x, dir.x * speed, acceleracao)
			move.y = lerp(move.y, dir.y * speed, acceleracao)
		else:
			move.x = lerp(move.x, dir.x * boostspeed, acceleracao)
			move.y = lerp(move.y, dir.y * boostspeed, acceleracao)
		animationmanager()
		move = move_and_slide(move)
	else:
		move = Vector2.ZERO

func _on_Area2D_body_entered(body):
	if body.is_in_group("bullet"):
		hitted(body)



func hitted(body):
	emit_signal("onhit", body)
	
func _on_Area2D2_body_entered(_body):
	$detectarea/attacktimer.start()
	



func _on_attacktimer_timeout():
	$HitArea/AnimationPlayer.play("damage")


func _on_HitArea_body_entered(_body):
	emit_signal("damagereduz",damage)


func _on_boostArea_body_entered(body):
	if body.name == "Player":
		onboost = true

func _on_boostArea_body_exited(body):
	if body.name == "Player":
		onboost = false
