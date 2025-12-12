extends Node2D

@export var score: int = 0
@export var lives: int = 3
@export var is_pause: bool = true
@export var is_win: bool = false
var heart: PackedScene = preload("res://scenes/heart.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	if lives == 0:
		$ContinueLabel.text = "You lost !!"

	# TODO: Not the most efficient!!	
	for n in $Lives.get_children():
		n.queue_free()
		
	for i in lives:
		var h: Node2D = heart.instantiate()
		h.position.x += 60 * (i + 1)
		$Lives.add_child(h)
	
	$ScoreLabel.text = str(score)
	
	if is_win:
		$ContinueLabel.text = "You won the game!!"
	
	if !is_pause:
		$ContinueLabel.hide()
	else: 
		$ContinueLabel.show()
	
