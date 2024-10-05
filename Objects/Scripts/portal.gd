extends Node2D

# Managers
@onready var worldNode

# Enemies

@export var SkeletonScene : PackedScene
@onready var enemyList = load("res://NPC/enemyTypeList.tres")
# Timers

@onready var spawnTimer = $spawnTimer
@onready var relaxTimer = $relaxTimer

# Markers
@onready var spawnMarker = $SpawnPoint

# UI
@onready var waveUI = $"../CanvasLayer/Panel/Wave_text"
@onready var startWaveBtn = $"../CanvasLayer/Button2"

# Waves related
var current_wave = 1
var wave_stages = 5 
var current_wave_stage = 1
var current_wave_complexity = 100

var possible_wave_enemies = []
var current_stage_enemies = []

func _ready():
	worldNode = get_tree().root.get_child(1)
	worldNode.portal = self
	waveUI.set_text('[center]' + str(current_wave) + '[/center]')

func _on_spawn_timer_timeout():
	if current_stage_enemies.size() > 0:
		var instance = current_stage_enemies[0].enemyScene.instantiate()
		instance.position = spawnMarker.position
		add_child(instance)
		current_stage_enemies.erase(current_stage_enemies[0])
	else:
		spawnTimer.stop()
		finish_stage()

func startWave():
	possible_wave_enemies.clear()
	for enemy in enemyList.enemies:
		if enemy.minimumWaveComplexity <= current_wave_complexity:
			possible_wave_enemies.append(enemy)
	start_stage()

func start_stage():
	var complexity_this_stage = current_wave_complexity / wave_stages
	
	var stage_enemies = []
	var stage_enemies_complexity = 0
	
	while(stage_enemies_complexity < complexity_this_stage):
		var new_enemy = possible_wave_enemies.pick_random()
		current_stage_enemies.append(new_enemy)
		stage_enemies_complexity += new_enemy.enemyComplexityPrice
		
	spawn_stage()

func spawn_stage():
	spawnTimer.start(0.1)
	print('Wave: ', current_wave, ' | Stage: ', current_wave_stage, '/', wave_stages, ' | Complexity ', current_wave_complexity)
	print('Amount of enemies in this stage: ', current_stage_enemies.size())
	
func finish_stage():
	current_wave_stage += 1
	print('Next stage: ', current_wave_stage)
	relaxTimer.start(7)

func finish_wave():
	print('Wave finished!')
	relaxTimer.stop()
	current_wave += 1
	current_wave_stage = 1
	current_wave_complexity += current_wave_complexity*0.35
	waveUI.set_text('[center]' + str(current_wave) + '[/center]')
	startWaveBtn.visible = true

func _on_relax_timer_timeout():
	print('Current stage: ', current_wave_stage)
	if current_wave_stage > wave_stages:
		finish_wave()
	else:
		start_stage()
