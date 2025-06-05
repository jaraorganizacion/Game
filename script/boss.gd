extends CharacterBody2D

var speed = 100  # Velocidad de movimiento
var chase_speed = 50
var player # Variable para almacenar al jugador
var player_in_area = false
var dead = false
var damage := 30  # Cuánto daño hace el boss
var damage_cooldown := 1.0
var can_deal_damage := true
var max_health = 100
var health = max_health
var is_attacking = false
var attack_duration := 1
var attack_range = 20  # Rango de ataque del boss
@onready var detection_area_boss = $detection_area_boss  # Ahora está con el nombre correcto "DetectionAreaBoss"
@onready var attack_area = $AttackArea  # Área de ataque (Area2D)
@onready var health_bar = $bar_boss

func _ready():
	dead = false
# Cuando un cuerpo entra en el área de detección
func _on_detection_area_body_entered(body):
	if body.has_method("player"):  # Verifica si el cuerpo que entra es el jugador
		print("¡El jugador está aquí!")
		player_in_area = true
		player = body  # Guardamos la referencia al jugador

# Cuando un cuerpo sale del área de detección
func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):  # Verifica si el cuerpo que salió es el jugador
		print("¡El jugador se fue!")
		player_in_area = false
		player = null





func _physics_process(delta):
	if !dead:
		$detection_area_boss/CollisionShape2D.disabled = false
		
		# Si el jugador está cerca y no está atacando, atacamos
		if player_in_area and player:
			var distance = position.distance_to(player.position)
			
			# Si está dentro del rango de ataque, ataca
			if distance < attack_range and can_deal_damage and !is_attacking:
				attack_player()  # Llamamos a la función de ataque
			# Si está fuera del rango de ataque, mueve al boss hacia el jugador
			elif distance >= attack_range:
				move_towards_player(delta)  # Función para mover al jugador
		else:
			$AnimatedSprite2D.play("idle")


func move_towards_player(delta):
	# Mueve al boss hacia el jugador a una velocidad más baja
	position += (player.position - position).normalized() * chase_speed * delta
	$AnimatedSprite2D.play("walk")
# Cuando un cuerpo entra al área de ataque (AttackArea)
func _on_attack_area_body_entered(body):
	if body.is_in_group("player") and can_deal_damage and !is_attacking:
		attack_player()  # Ataca si el jugador entra al área de ataque

func attack_player():
	if is_attacking:
		return  # Si ya está atacando, no hace otro ataque.

	is_attacking = true
	can_deal_damage = false
	$AnimatedSprite2D.play("cleave")  # Reproducir animación de ataque
	
	# Esperar la duración de la animación antes de aplicar el daño
	await get_tree().create_timer(attack_duration).timeout
	
	# Si el jugador está cerca y en el área de daño, aplica el daño
	if player and player.is_in_group("player") and player.has_method("take_damage_player"):
		player.take_damage_player(damage)  # Aplica el daño

	# Termina el ataque
	can_deal_damage = true
	is_attacking = false

func _on_damage_area_body_entered(body):
	if body.has_method("player") and can_deal_damage:
		if body.has_method("take_damage_player"):
			body.take_damage_player(damage)
			can_deal_damage = false
			await get_tree().create_timer(damage_cooldown).timeout
			can_deal_damage = true
			
			
func take_damage(damage):
	
	health -= damage
	health = clamp(health, 0, max_health)

	# Actualiza la barra
	health_bar.value = health
	# Reproducir animación "recibie" al recibir daño
	if !$AnimatedSprite2D.is_playing() or $AnimatedSprite2D.animation != "take_hit":
		$AnimatedSprite2D.play("take_hit")
	if health <= 0 and !dead:
		death()
		
func death():
	dead = true
	$AnimatedSprite2D.play("death")
	await get_tree().create_timer(1).timeout
	drop_boss()
	
	$AnimatedSprite2D.visible = false
	$hitbox/CollisionShape2D.disabled = true
	$detection_area_boss/CollisionShape2D.disabled = true

func drop_boss():
	print("desaparece el boss por que se bananeo")
	


func _on_hitbox_area_entered(area):
	
	var damage
	if area.has_method("arrow_deal_damage"):
		damage = 4
		take_damage(damage)
		
