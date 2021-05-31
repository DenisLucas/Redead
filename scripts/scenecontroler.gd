extends Node2D

onready var bullet = load("res://actors/bullet.tscn")
onready var enemy = load("res://actors/enemy.tscn")
onready var spawnpoints = [$enemyspawn,$enemyspawn2,$enemyspawn4,$enemyspawn5]
onready var Itenspawn = [$"iten spawn",$"iten spawn2",$"iten spawn3",$"iten spawn4",$"iten spawn5"]
onready var Recharge = load("res://scenes/Ammo.tscn")
onready var Iten = load("res://scenes/damage+.tscn")

var Cshoot = true
var spawn = true
var playerpos = Vector2.ZERO
var enemies = []

var cameraextends = false
onready var fireRate = $Player/timeOut
export var fire_rate = 0.5
export var damage = 1
export var Espeed = 150
export var Elife = 2
var wave = 1
var ammo = 20
var ammopos = []
var itempos = []



	
func _physics_process(_delta):
	fireRate.wait_time = fire_rate
	camerafollow()

func _process(_delta):
	$Camera2D/Control/VBoxContainer/Life.text = "Life: %s " % $Player.life
	$Camera2D/Control/VBoxContainer/ammo.text = "Ammo: %s " % ammo
	$Camera2D/Control/VBoxContainer2/Wave.text = "Wave: %s" % wave
	enemyspawn()
	if $Player.life <= 0:
		var _Nscene = get_tree().reload_current_scene()
	playerpos = $Player.global_position 
	for I in enemies:
		I.dir = (playerpos - I.global_position).normalized()


func camerafollow():
		$Camera2D.global_position = $Player.global_position

	
func _on_Player_fire(dir):
	if Cshoot and ammo > 0:
		var fire = bullet.instance()
		add_child(fire)
		fire.add_to_group("bullet")
		fire.dir = dir
		fire.global_position = $Player/Gunsprite/Position2D.global_position
		fireRate.start()
		Cshoot = false
		$Player.shootA = false
		ammo -= 1
		
	
func enemyspawn():
	if spawn:
		var zombies = enemy.instance()
		add_child(zombies)
		zombies.speed = Espeed
		zombies.add_to_group("enemy")
		zombies.life = Elife
		zombies.global_position = spawnpoints[rand_range(0, spawnpoints.size())].global_position
		$"spawn timer".start()
		spawn = false
		zombies.connect("onhit",self,"onhit")
		zombies.connect("destroy", self,"destroy")
		zombies.connect("damagereduz", self,"damagereduz")
		enemies.append(zombies)
		
		
		
func ammospawn():
	var newcharge = Recharge.instance()
	add_child(newcharge)
	newcharge.connect("raiseamm", self, "raiseamm")
	newcharge.ammo = 10
	var chargepos = Itenspawn[randi()%Itenspawn.size()+0]
	newcharge.global_position = chargepos.global_position
	for I in ammopos:
		if I[1] == chargepos:
			if I[0] != null:
				I[0].queue_free()
			ammopos.erase(I)
	ammopos.append([newcharge,chargepos])
	
	
	
func Itempawn():
	var newcharge = Iten.instance()
	add_child(newcharge)
	newcharge.connect("raisedam", self, "raisedam")
	var chargepos = spawnpoints[randi()%spawnpoints.size()+0]
	newcharge.global_position = chargepos.global_position
	for I in ammopos:
		if I[1] == chargepos:
			if I[0] != null:
				I[0].queue_free()
			itempos.erase(I)
	itempos.append([newcharge,chargepos])
	
func _on_timeOut_timeout():
	Cshoot = true
	$Player.shootA = true


func _on_spawn_timer_timeout():
	spawn = true
	
func destroy(body):
	enemies.erase(body)
	body.queue_free()
	
func damagereduz(_damage):
	$Player.life -= 1

func onhit(body):
	body.life -= damage


func _on_wavetimer_timeout():
	$"spawn timer".wait_time -= 0.2
	Elife += 1
	wave += 1
	$ammospawn.wait_time += 1
	$wavetimer.start()

func raiserate(amm):
	if fire_rate - amm > 0.0:
		fire_rate -= amm


func raisedam(dam):
	damage += dam



func raiseamm(muni):
	if ammo + muni < 20:
		ammo += muni
	else:
		ammo = 20

func _on_ammospawn_timeout():
	ammospawn()


func _on_Itempos_timeout():
	Itempawn()
