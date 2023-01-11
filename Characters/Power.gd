extends KinematicBody2D

#Estados del personaje
enum STATE {IDLE, ATTACK}
var current_state = STATE.IDLE

onready var animationSprite = $AnimatedSprite

var motion = Vector2()

var vida = 9

#Variables de movimientos
const gravity : int = 40
const jump : int = -1000
const max_jump : int = -1400
const acceleration : int = 2
const max_speed : int = 150
const up = Vector2(0,-1)

func _physics_process(delta):
	
	var overlap
	var friction = false
	
	motion.y += gravity
	if Input.is_action_just_pressed("ui_accept"):
		motion.x = motion.x * 2
		_change_state(STATE.ATTACK)
		attack()
		
	if current_state == STATE.ATTACK :
		
		pass
		
	if Input.is_action_pressed("ui_right"):
		animationSprite.flip_h=false
		motion.x = 500
	elif Input.is_action_pressed("ui_left"):
		animationSprite.flip_h = true
		motion.x = -500
	else:
		motion.x = 0
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = min(motion.y + jump, max_jump)	
		if friction==true:
			motion.x = lerp(motion.x,0,0.05)
	else:
		if friction == true:
			motion.x = lerp(motion.x,0,0.01)
	
	motion = move_and_slide(motion, up)

func attack():
	animationSprite.play("attack")
	pass
	
	
func _change_state(new_state):
	current_state = new_state
	
	match current_state:
		STATE.IDLE: 
			animationSprite.play("idle")
			$AnimatedSprite/Area_attack.position.y = 1000
		STATE.ATTACK:
			animationSprite.play("attack")
			$AnimatedSprite/Area_attack.position.y = 4
			
func _ready():
	pass 

func addVida():
	vida = vida+1
	actualizarHUD()

func _on_Area_vida_body_entered(body):
	if body.is_in_group("enemy"):
		vida = vida - 1
		if vida == 0:
			get_tree().change_scene("res://Escenas/EscenaTrain.tscn")
		else:	
			actualizarHUD();
	if body.is_in_group("blood"):
		vida = vida+1
		actualizarHUD();
		

func actualizarHUD():
	pass
	#for node in self.get_parent():
	#	if node.is_in_group("marcador"):
	#		node._changeVida(vida)
	

func _on_AnimatedSprite_animation_finished():
	_change_state(STATE.IDLE)

func _on_Area_attack_area_entered(area):
	if area.is_in_group("enemy"):
		area.get_parent().take_damage()
	
