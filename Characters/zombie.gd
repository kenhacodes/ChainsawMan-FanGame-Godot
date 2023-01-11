extends KinematicBody2D

onready var animationSprite = $AnimatedSprite

var vidaZombie = 10

var scene = preload("res://Escenas/Extra/blood.tscn")

const MAX_SPEED : float = 300.0
const GRAVITY : float = 25.0
const up = Vector2(0,-1)

var motion = Vector2()

enum STATE {LEFT, RIGHT}
var current_state 

func take_damage():
	
	vidaZombie = vidaZombie-5
	if vidaZombie < 1:
		_dead()

func _dead():
	blood()
	
	
func blood():
	
	var instance = scene.instance()
	instance.position = self.position
	self.get_parent().add_child(instance)
	queue_free()
	
func _ready():
	$AnimatedSprite.scale.x *= -1
	motion.x = -MAX_SPEED
	

func _next_to_left_player() -> bool:
	if $RayCast2DLeft.collide_with_bodies:
		return false
	else:
		return true
	
func _next_to_right_player() -> bool:
	if $RayCast2DRight.collide_with_bodies:
		return false
	else:
		return true
	
func _flip():
	if _next_to_left_player() or _next_to_right_player():
		motion.x *= -1
		$AnimatedSprite.scale.x *= -1
		
func _process(delta):
	motion.y += GRAVITY
	if (motion.x == 0):
		motion.x += MAX_SPEED
		if (motion.x == 0):
			motion.x += -MAX_SPEED
	
	_flip()
	motion = move_and_slide(motion)
	
	pass




