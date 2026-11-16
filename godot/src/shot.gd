extends Node2D
# Projétil inimigo: brasa (arco), vapor (lento), onda no chão, comida caindo.

var level: Node
var vel := Vector2.ZERO
var grav := 0.0
var radius := 18.0
var dmg := 1
var kind := "ember"
var col := Color(1, 0.45, 0.1)
var life := 4.0
var ground_wave := false
var _t := 0.0
var absorbable := true

func _ready() -> void:
	add_to_group("enemy_shot")
	z_index = 15

func _physics_process(dt: float) -> void:
	if level and level.frozen:
		return
	_t += dt
	life -= dt
	vel.y += grav * dt
	position += vel * dt
	if life <= 0.0:
		queue_free()
		return
	if not ground_wave and level and position.y > level.ground_at(position.x) - radius * 0.5:
		load("res://src/fx.gd").spawn(level, "spark", position, {"r": 40.0, "col": col})
		queue_free()
		return
	var p = level.player if level else null
	if p and p.state != "dead":
		if absorbable and p.absorbs(position):
			load("res://src/fx.gd").spawn(level, "ring", position, {"r": 40.0, "col": Color(0.3, 1, 0.6), "life": 0.25})
			queue_free()
			return
		var r := Rect2(position - Vector2(radius, radius), Vector2(radius, radius) * 2.0)
		if ground_wave:
			r = Rect2(position + Vector2(-radius, -60), Vector2(radius * 2.0, 60))
		if r.intersects(p.hurt_rect()):
			p.take_damage(dmg, position.x - signf(vel.x) * 10.0)
			queue_free()
			return
	queue_redraw()

func _draw() -> void:
	match kind:
		"ember":
			draw_circle(Vector2.ZERO, radius * 1.4, Color(col.r, col.g, col.b, 0.25))
			draw_circle(Vector2.ZERO, radius, col)
			draw_circle(Vector2.ZERO, radius * 0.5, Color(1, 0.95, 0.6))
			draw_line(Vector2.ZERO, -vel.normalized() * radius * 2.2, Color(col.r, col.g, col.b, 0.5), radius * 0.8)
		"vapor":
			var s := 1.0 + 0.15 * sin(_t * 9.0)
			for i in range(4):
				var o := Vector2(cos(_t * 3.0 + i * 1.6), sin(_t * 2.6 + i * 1.6)) * radius * 0.45
				draw_circle(o, radius * 0.7 * s, Color(col.r, col.g, col.b, 0.55))
			draw_circle(Vector2.ZERO, radius * 0.45, Color(0.85, 1, 0.6, 0.8))
		"wave":
			var hgt := 54.0 + 8.0 * sin(_t * 30.0)
			var pts := PackedVector2Array([Vector2(-radius, 0), Vector2(-radius * 0.4, -hgt), Vector2(0, -hgt * 0.6), Vector2(radius * 0.5, -hgt * 0.9), Vector2(radius, 0)])
			draw_colored_polygon(pts, Color(col.r, col.g, col.b, 0.75))
			draw_polyline(pts, Color(1, 0.9, 0.6, 0.9), 2.0)
		"food":
			draw_circle(Vector2.ZERO, radius, col)
			draw_circle(Vector2(-radius * 0.3, -radius * 0.3), radius * 0.35, Color(1, 1, 1, 0.5))
			draw_line(Vector2(0, -radius), Vector2(4, -radius - 8), Color(0.3, 0.5, 0.2), 3.0)
