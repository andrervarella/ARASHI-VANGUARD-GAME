extends Node2D
# Onda do Corte da Tempestade (golpe carregado no nível máximo): viaja reto, fere cada inimigo uma vez.

var level: Node
var dir := 1
var dmg := 3
var life := 0.55
var _hit := {}
const SPEED := 900.0

func _ready() -> void:
	z_index = 21

func _physics_process(dt: float) -> void:
	life -= dt
	position.x += dir * SPEED * dt
	var r := Rect2(global_position + Vector2(-40, -70), Vector2(80, 140))
	for f in get_tree().get_nodes_in_group("foes"):
		if _hit.has(f) or not is_instance_valid(f) or f.get("dead"):
			continue
		if r.intersects(f.hurt_rect()):
			_hit[f] = true
			f.take_hit(dmg, dir, "onda")
			load("res://src/fxsprite.gd").play(level, "acerto", f.hurt_rect().get_center(), {"scale_px": 2.0})
			level.hitstop(0.07)
	for b in get_tree().get_nodes_in_group("breakable"):
		if not _hit.has(b) and r.intersects(b.get_rect()):
			_hit[b] = true
			b.hit_by("katana")
	queue_redraw()
	if life <= 0.0:
		queue_free()

func _draw() -> void:
	var a := clampf(life / 0.55, 0.0, 1.0)
	for i in range(3):
		var off := -dir * i * 22.0
		draw_arc(Vector2(off, 0), 70.0 - i * 8.0, -PI / 2.0 + (0.0 if dir > 0 else PI), PI / 2.0 + (0.0 if dir > 0 else PI), 18, Color(1, 0.35 + 0.2 * i, 0.2, a * (0.9 - i * 0.25)), 10.0 - i * 3.0)
	draw_arc(Vector2.ZERO, 64.0, -PI / 2.0 + (0.0 if dir > 0 else PI), PI / 2.0 + (0.0 if dir > 0 else PI), 18, Color(1, 0.95, 0.8, a), 3.0)
