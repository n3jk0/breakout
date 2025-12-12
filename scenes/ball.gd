extends CharacterBody2D

var speed: int = 450
var max_bounce_angle: float = 75.0
var direction: Vector2 = Vector2.DOWN
var ball_hit: int = 0
var game: Node2D

func _ready() -> void:
	direction = Vector2.ZERO
	game = get_parent();

func _physics_process(_delta: float) -> void:
	start()
	var collision: KinematicCollision2D = move_and_collide(direction * speed * _delta)
	if collision:
		direction = calculate_bounce_angle(collision)


func calculate_bounce_angle(collision: KinematicCollision2D) -> Vector2:
		var collider: PhysicsBody2D = collision.get_collider();
		if collider.is_in_group("Down"):
			end_game()
			return Vector2.ZERO
		if collider.is_in_group("Paddles"):
			ball_hit += 1
			if ball_hit % 5 == 0:
				speed += 20
			# Get the collision point in global coordinates
			var collision_point: Vector2 = collision.get_position()
			
			# Get paddle's global position and size
			var paddle_pos: Vector2 = collider.global_position
			var paddle_width = collider.get_node("Body").texture.get_width()
					
			# Calculate relative hit position (-1.0 to 1.0)
			# -1.0 = left edge, 0.0 = center, 1.0 = right edge
			var relative_hit = (collision_point.x - paddle_pos.x) / (paddle_width / 2.0)
			var bounce_angle = relative_hit * max_bounce_angle
			
			# Convert to radians and create direction vector
			# Assuming paddle is horizontal at bottom, ball bounces upward
			var angle_rad: float = deg_to_rad(bounce_angle)
			return Vector2(sin(angle_rad), -cos(angle_rad))
		else:
			var parent: Node = collider.get_parent()
			if parent && parent.name == "Blocks":
				game.score += 1
				collider.queue_free()
				if parent.get_children().size() <= 1:
					win_game()
					return Vector2.ZERO
				
			# UP / DOWN
			if abs(collision.get_normal().y) > 0.45:
				return Vector2(direction.x, -direction.y)
			# LEFT / RIGHT
			else:
				return Vector2(-direction.x, direction.y)
		
func start():
	if direction == Vector2.ZERO:
		var paddle: CharacterBody2D = get_tree().get_first_node_in_group("Paddles")
		position = paddle.position
		position.y -= 40
		if Input.is_action_just_pressed("continue"):
			game.is_pause = false
			direction = Vector2.UP

func end_game():
	game.lives -= 1
	game.is_pause = true
	
func win_game():
	game.is_win = true
	game.is_pause = true
