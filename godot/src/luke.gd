extends Node2D
# Luke — cão do Ren. Segue o dono, late de vez em quando.

var target: Node2D
var level: Node
var spr: AnimatedSprite2D
var _bark := 4.0
var vx := 0.0

func _ready() -> void:
	spr = load("res://src/actor_sprite.gd").new()
	spr.setup("luke")
	add_child(spr)
	spr.play_anim("idle")
	z_index = 1

func _physics_process(dt: float) -> void:
	if target == null or level == null:
		return
	var tx: float = target.global_position.x - 90.0 * target.get("facing")
	var dx: float = tx - global_position.x
	if absf(dx) > 900.0:
		global_position.x = tx
		dx = 0.0
	var want := 0.0
	if absf(dx) > 40.0:
		want = signf(dx) * minf(560.0, absf(dx) * 3.0)
	vx = move_toward(vx, want, 2400.0 * dt)
	global_position.x += vx * dt
	var gy: float = level.ground_at(global_position.x)
	if gy > 5000.0:
		gy = target.global_position.y
	global_position.y = move_toward(global_position.y, gy, 1400.0 * dt)
	if absf(vx) > 30.0:
		spr.play_anim("run", false, clampf(absf(vx) / 400.0, 0.7, 1.4))
		spr.set_facing(1 if vx > 0 else -1)
	else:
		spr.play_anim("idle")
		spr.set_facing(1 if target.global_position.x > global_position.x else -1)
	_bark -= dt
	if _bark <= 0.0:
		_bark = randf_range(9.0, 18.0)
		if not level.frozen:
			Game.sfx("bark", -16.0)
