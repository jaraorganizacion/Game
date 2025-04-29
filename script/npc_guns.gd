extends CharacterBody2D

@onready var sprite = $animated
@onready var area = $Area2D
@onready var interaction_label = $Label  # O $TextureRect si usas imagen
var player_near = false
const DIALOGUE_PATH = "res://dialogues/npc1.dialogue"

func _ready():
	sprite.play("idle2")
	
	interaction_label.visible = false
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "player":
		player_near = true
		interaction_label.visible = true

func _on_body_exited(body):
	if body.name == "player":
		player_near = false
		interaction_label.visible = false

func _process(delta):
	if player_near and Input.is_action_just_pressed("interact"):  # "interact" debe ser "ui_accept" o "E"
		start_dialogue()

func start_dialogue():
	sprite.play("idle")
	interaction_label.visible = false
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	DialogueManager.show_dialogue_balloon(load(DIALOGUE_PATH))  # Cambié el método a show_dialogue()



func _on_dialogue_ended(arg=null):
	sprite.play("dialogue")  # Vuelve a la animación "idle2" al finalizar el diálogo
	DialogueManager.dialogue_ended.disconnect(_on_dialogue_ended)  # Desconecta la señal correctamente
