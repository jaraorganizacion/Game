extends CharacterBody2D

var damage := 10  # Cuánto daño hace el slime
var damage_cooldown := 1.0
var can_deal_damage := true



var speed = 50
var max_health = 100
var health = max_health


@onready var slime = $slime_collectable
@export var itemRes: InvItem
@onready var health_bar = $ProgressBar

var dead = false
var player_in_area = false
var player

func _ready():
	dead = false
	
	
func _on_damage_area_body_entered(body):
	if body.is_in_group("player") and can_deal_damage:
		if body.has_method("take_damage_player"):
			body.take_damage_player(damage)
			can_deal_damage = false
			await get_tree().create_timer(damage_cooldown).timeout
			can_deal_damage = true

func _physics_process(delta):
	if !dead:
		$detection_area/CollisionShape2D.disabled = false
		if player_in_area:
			position += (player.position - position) / speed
			$AnimatedSprite2D.play("move")
		else:
			$AnimatedSprite2D.play("idle")
	if dead:
		$detection_area/CollisionShape2D.disabled = true
		




func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
		player = body



func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		player_in_area = false
		player = null


func _on_hitbox_area_entered(area):
	var damage
	if area.has_method("arrow_deal_damage"):
		damage = 50
		take_damage(damage)


func take_damage(damage):
	#health = health - damage
	#if health <= 0 and !dead:
		#death()
		
	health -= damage
	health = clamp(health, 0, max_health)
	
	# Actualiza la barra
	health_bar.value = health

	if health <= 0 and !dead:
		death()
		

func death():
	dead = true
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(1).timeout
	drop_slime()
	
	$AnimatedSprite2D.visible = false
	$hitbox/CollisionShape2D.disabled = true
	$detection_area/CollisionShape2D.disabled = true
	
	

	
	
func drop_slime():
	slime.visible = true
	$slime_collect_area/CollisionShape2D.disabled = false
	slime_collect()
	
	
func slime_collect():
	await get_tree().create_timer(1.5).timeout
	slime.visible = false
	
	# Verifica que el jugador esté presente antes de llamar a collect
	if player != null:
		# Si 'player' tiene el método 'collect', lo llamamos
		if player.has_method("collect"):
			player.collect(itemRes)
	queue_free()

	


func _on_slime_collect_area_body_entered(body):
	if body.has_method("player"):
		player = body
