extends CharacterBody2D

var speed = 100  # Velocidad de movimiento
var player # Variable para almacenar al jugador
var player_in_area = false
var dead = false
var damage := 10  # Cuánto daño hace el boss
var damage_cooldown := 1.0
var can_deal_damage := true
var max_health = 100
var health = max_health
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



# Lógica de movimiento (mueve al Boss hacia el jugador)
func _physics_process(delta):
	if !dead:
		$detection_area_boss/CollisionShape2D.disabled = false
		if player_in_area:
			position += (player.position - position) / speed 
			$AnimatedSprite2D.play("walk") 
		else:
			#velocity = Vector2.ZERO  # Si no hay jugador, el Boss no se mueve
			$AnimatedSprite2D.play("idle")  # Reproducimos la animación de estar quieto


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
