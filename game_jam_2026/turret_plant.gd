extends Plant

func _ready():
	sprite = $AnimatedSprite2D

@export var damage: int = 5
var x2 = self.global_position.x
var y2 = self.global_position.y
var time = 0
var wished_rotation = 0

var enemies_inside_range: Array[PathFollow2D]

func calc_dist_from(x1: float, y1: float) -> float:
	return sqrt((x2-x1)**2+(y2-y1)**2)
	
func calc_radians_from(body: CharacterBody2D) -> float:
	var x1 = body.global_position.x
	var y1 = body.global_position.y
	return atan2((y2-y1),(x2-x1))+(PI/2)

func _on_range_body_entered(body: Node2D) -> void:
	print("%s entered the range" % body.name)
	enemies_inside_range.append(body.get_parent())
	enemies_inside_range.sort_custom(compare_progress)

func _check_rotation(target: CharacterBody2D) -> float:
	var rad_to_target = calc_radians_from(target)
	return rad_to_target
	
func _process(delta: float) -> void:
	time += delta
	if !enemies_inside_range.is_empty():
		var target: CharacterBody2D = _choose_target().get_child(0)
		self.global_rotation = _check_rotation(target)
		print("Turning to %s" % self.global_rotation_degrees)
		_damage_enemies(target)
		

func _choose_target() -> PathFollow2D:
	return enemies_inside_range.front()

func compare_progress(a, b) -> bool:
	return a.progress > b.progress

func _on_range_body_exited(_body: Node2D) -> void:
	enemies_inside_range.pop_front()
	
func _damage_enemies(target: CharacterBody2D) -> void:
	if (time >= 1):
		target.health -= damage
		time = 0
		$AnimationPlayer.play("shoot")
