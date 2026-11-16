extends Node2D
# Efeitos rápidos desenhados por código: corte, faísca, onda, poeira, texto.

var kind := "spark"
var t := 0.0
var life := 0.25
var col := Color.WHITE
var dir := 1
var r := 80.0
var txt := ""
var low := false
var _seed := 0

static func spawn(parent: Node, k: String, pos: Vector2, opts := {}) -> Node2D:
	var f = load("res://src/fx.gd").new()
	f.kind = k
	f.position = pos
	for key in opts:
		f.set(key, opts[key])
	f._seed = randi()
	f.z_index = 20
	parent.add_child(f)
	return f

func _process(dt: float) -> void:
	t += dt
	if t >= life:
		queue_free()
		return
	if kind == "text":
		position.y -= 60.0 * dt
	queue_redraw()

func _draw() -> void:
	var k := t / life
	var a := 1.0 - k
	match kind:
		"slash":
			# meia-lua do corte da katana
			var a0 := deg_to_rad(-75.0 if not low else -25.0)
			var a1 := deg_to_rad(70.0 if not low else 40.0)
			var pts := PackedVector2Array()
			var n := 18
			var grow := 0.75 + 0.25 * minf(1.0, k * 3.0)
			for i in range(n + 1):
				var ang := lerpf(a0, a1, float(i) / n)
				pts.append(Vector2(cos(ang) * dir, sin(ang)) * r * grow)
			for i in range(n, -1, -1):
				var ang := lerpf(a0, a1, float(i) / n)
				var th := sin(PI * float(i) / n) * 0.32 + 0.04
				pts.append(Vector2(cos(ang) * dir, sin(ang)) * r * grow * (1.0 - th))
			draw_colored_polygon(pts, Color(col.r, col.g, col.b, 0.85 * a))
			var inner := PackedVector2Array()
			for i in range(n + 1):
				var ang := lerpf(a0, a1, float(i) / n)
				inner.append(Vector2(cos(ang) * dir, sin(ang)) * r * grow * 0.97)
			draw_polyline(inner, Color(1, 1, 1, 0.9 * a), 3.0)
		"spark":
			var rng := RandomNumberGenerator.new()
			rng.seed = _seed
			for i in range(9):
				var ang := rng.randf() * TAU
				var l := rng.randf_range(0.5, 1.0) * r * (0.4 + k)
				var d := Vector2(cos(ang), sin(ang))
				draw_line(d * l * 0.3, d * l, Color(col.r, col.g, col.b, a), 3.0)
			draw_circle(Vector2.ZERO, r * 0.25 * a, Color(1, 1, 1, a))
		"ring":
			draw_arc(Vector2.ZERO, r * (0.2 + k), 0, TAU, 48, Color(col.r, col.g, col.b, a), 6.0 * a + 1.0)
		"wave":
			# onda de choque no chão (meia-elipse)
			var w := r * (0.3 + k * 1.2)
			draw_arc(Vector2.ZERO, w, PI, TAU, 32, Color(col.r, col.g, col.b, a), 8.0 * a + 1.0)
		"dust":
			var rng2 := RandomNumberGenerator.new()
			rng2.seed = _seed
			for i in range(6):
				var off := Vector2(rng2.randf_range(-1, 1) * r * (0.3 + k), -rng2.randf() * r * 0.4 * k)
				draw_circle(off, r * 0.18 * (1.0 - k * 0.5), Color(0.7, 0.62, 0.55, 0.5 * a))
		"text":
			var font := Game.FONT_SERIF
			draw_string_outline(font, Vector2(-80, 0), txt, HORIZONTAL_ALIGNMENT_CENTER, 160, 30, 8, Color(0, 0, 0, a))
			draw_string(font, Vector2(-80, 0), txt, HORIZONTAL_ALIGNMENT_CENTER, 160, 30, Color(col.r, col.g, col.b, a))
		"rise":
			# corte ascendente: arco de baixo para cima
			var pts2 := PackedVector2Array()
			var n2 := 16
			for i in range(n2 + 1):
				var ang := lerpf(deg_to_rad(80.0), deg_to_rad(-80.0), float(i) / n2)
				pts2.append(Vector2(cos(ang) * dir, sin(ang)) * r * (0.8 + 0.2 * k))
			draw_polyline(pts2, Color(col.r, col.g, col.b, 0.8 * a), 16.0 * a + 2.0)
			draw_polyline(pts2, Color(1, 1, 1, 0.9 * a), 3.0)
		"thrust":
			# estocada: lança de luz para a frente
			var ln := r * (0.5 + 0.5 * minf(1.0, k * 3.0))
			draw_line(Vector2.ZERO, Vector2(dir * ln, 0), Color(col.r, col.g, col.b, 0.5 * a), 18.0)
			draw_line(Vector2.ZERO, Vector2(dir * ln, 0), Color(1, 1, 1, 0.95 * a), 4.0)
			for j in range(3):
				var yy := (j - 1) * 14.0
				draw_line(Vector2(-dir * 20.0, yy), Vector2(dir * ln * 0.6, yy), Color(1, 1, 1, 0.35 * a), 2.0)
		"streak":
			# rastro de luz subindo ao céu (selos se rompendo)
			var d := Vector2(cos(r), sin(r))
			var head := d * 1400.0 * minf(1.0, k * 1.6)
			var tail := d * 1400.0 * maxf(0.0, k * 1.6 - 0.45)
			draw_line(tail, head, Color(col.r, col.g, col.b, 0.35 * a), 26.0)
			draw_line(tail, head, Color(col.r, col.g, col.b, 0.9 * a), 9.0)
			draw_circle(head, 14.0, Color(1, 1, 1, a))
		"aura":
			draw_circle(Vector2.ZERO, r * (0.6 + 0.4 * k), Color(col.r, col.g, col.b, 0.25 * a))
