extends KinematicBody2D

export var speed = 300
signal fire(dir)
export (float, 0.0, 1.0) var acceleracao = 0.0
export (float, 0.0, 1.0) var atrito = 0.0
var shootA = true
var move = Vector2.ZERO
var life = 5



	
func playerMovement():
	var dir = Vector2.ZERO
	dir.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	dir = dir.normalized()
	if dir != Vector2.ZERO:
		move.x = lerp(move.x, dir.x * speed, acceleracao)
		move.y = lerp(move.y, dir.y * speed, acceleracao)
	else:
		move.x = lerp(move.x, 0, atrito)
		move.y = lerp(move.y, 0, atrito)
	animationManager(dir)

func animationManager(dir):
	if Input.is_action_pressed("shoot") and shootA:
		$Gunsprite.play("shoot")
		var gundir = ( get_global_mouse_position() - $".".global_position).normalized()
		emit_signal("fire", gundir)
	if dir.x != 0:
		$PlayerSkin.visible = false
		$Moving.visible = true
		$Moving.play("MoveH")
		if dir.x > 0:
			$Moving.flip_h= false
		else:
			$Moving.flip_h = true
	elif dir.y != 0:
		$Moving.visible = true
		$PlayerSkin.visible = false
		if dir.y > 0:
			$Moving.play("MoveV")
			$Moving.flip_v = false
		if dir.y < 0:
			$Moving.play("Move-V")
	else:
		$Moving.visible = false
		$PlayerSkin.flip_h = $Moving.flip_h
		$PlayerSkin.flip_v = $Moving.flip_v
		$PlayerSkin.visible = true
		
func lookatmouse():
	var mousePosition = get_global_mouse_position()
	if mousePosition.x < $".".global_position.x:
		$Gunsprite.flip_v = true
	else:
		$Gunsprite.flip_v = false
	$Gunsprite.look_at(mousePosition)
	
func _process(_delta):
	playerMovement()
	lookatmouse()
	
func _physics_process(_delta):
	move = move_and_slide(move)

	


func _on_Gunsprite_animation_finished():
	$Gunsprite.stop()
	$Gunsprite.frame = 0
