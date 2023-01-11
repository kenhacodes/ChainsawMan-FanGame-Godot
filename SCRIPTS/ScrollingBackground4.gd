extends Node

export (float) var scroll_speed = 1.0

func _ready():
	self.material.set_shader_param("scroll_speed", scroll_speed)

