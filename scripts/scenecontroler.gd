extends Node2D

onready var bullet = load("res://actors/bullet.tscn")
onready var enemy = load("res://actors/enemy.tscn")
onready var spawnpoints = [$enemyspawn,$enemyspawn2,$enemyspawn4,$enemyspawn5]
onready var Itenspawn = [$"iten spawn",$"iten spawn2",$"iten spawn3",$"iten spawn4",$"iten spawn5"]
onready var Recharge = load("res://scenes/Ammo.tscn")
onready var Iten = load("res://scenes/damage+.tscn")
onready var health = load("res://scenes/Health.tscn")
var Cshoot = true
var spawn = true
var playerpos = Vector2.ZERO
var enemies = []
var playempty = false

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
var GO = false


	
func _physics_process(_delta):
	fireRate.wait_time = fire_rate
	if !GO:
		camerafollow()

func _process(_delta):
	$Camera2D/Control/VBoxContainer/Life.text = "Life: %s/5 " % $Player.life
	$Camera2D/Control/VBoxContainer/ammo.text = "Ammo: %s/20 " % ammo
	$Camera2D/Control/VBoxContainer2/Wave.text = "Wave: %s" % wave
	enemyspawn()
	if $Player.life <= 0:
		gameOver()
	if !GO:
		playerpos = $Player.global_position 
		for I in enemies:
			I.dir = (playerpos - I.global_position).normalized()


func camerafollow():
		$Camera2D.global_position = $Player.global_position

func gameOver():
	GO = true
	spawn = false
	$wavetimer.stop()
	$"spawn timer".stop()
	for I in enemies:
		if I != null:
			I.queue_free()
	$Camera2D/Gover.visible = true
	$"Camera2D/Gover/CenterContainer/VBoxContainer/waves won".text = "Wave:%s" % wave 
	
func _on_Player_fire(dir):
	fireRate.start()
	if Cshoot and ammo > 0:
		var fire = bullet.instance()
		add_child(fire)
		fire.add_to_group("bullet")
		fire.dir = dir
		fire.global_position = $Player/Gunsprite/Position2D.global_position
		Cshoot = false
		$Player.shootA = false
		ammo -= 1
		audioManager(0)
	elif ammo <= 0 and playempty:
		audioManager(1)
		playempty = false
	$Player.shootA = false
		
	
func enemyspawn():
	if spawn and enemies.size() < 20:
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
	var random = randi()%2
	var newcharge
	if random == 0:
		newcharge = Iten.instance()
		add_child(newcharge)
		newcharge.connect("raisedam", self, "raisedam")
	else:
		newcharge = health.instance()
		add_child(newcharge)
		newcharge.connect("raisehealth", self, "raisehealth")
	var chargepos = spawnpoints[randi()%spawnpoints.size()+0]
	newcharge.global_position = chargepos.global_position
	for I in itempos:
		if I[1] == chargepos:
			if I[0] != null:
				I[0].queue_free()
			itempos.erase(I)
	itempos.append([newcharge,chargepos])
	
func _on_timeOut_timeout():
	Cshoot = true
	playempty = true
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
	if $"spawn timer".wait_time - 0.2 > 0:
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
	
func raisehealth(life):
	if $Player.life + life < 5:
		$Player.life += life
	else:
		$Player.life = 5


func audioManager(index):
	if index == 0:
		$fire.volume_db = rand_range(0.5, 2.0)
		$fire.play()
	elif index == 1:
		$empty.play()
	elif index == 2:
		$breathing.play()
	elif index == 3:
		$Moan.play()

func raiseamm(muni):
	if ammo + muni < 20:
		ammo += muni
	else:
		ammo = 20

func _on_ammospawn_timeout():
	ammospawn()


func _on_Itempos_timeout():
	Itempawn()


func _on_Timer_timeout():
	audioManager(2)


func _on_Moantimer_timeout():
	audioManager(3)
