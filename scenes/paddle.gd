extends CharacterBody2D

var direction_x: float
var speed: float = 500.0


func _physics_process(_delta: float) -> void:
	input_move()
	velocity.x = direction_x * speed
	velocity.y = 0
	move_and_slide()

func input_move():
	direction_x = Input.get_axis("left", "right")
