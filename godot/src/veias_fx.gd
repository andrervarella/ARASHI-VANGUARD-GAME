extends Node2D
# Veias vermelhas que se espalham da marca no peito do Ren (transformação Carmesim)
var t := 0.0
var power := 0.0   # 0..1 cresce durante a crise
var _seeds: Array = []

func _ready() -> void:
	z_index = 14
	for i in range(9):
		_seeds.append([randf_range(-PI, PI), randf_range(50.0, 120.0), randi()])

func _process(dt: float) -> void:
	t += dt
	queue_redraw()

func _draw() -> void:
	var c := Vector2(0, -92)
	var beat := pow(maxf(0.0, sin(t * 7.0)), 6.0)
	var a := clampf(power, 0.0, 1.0)
	# brilho da marca
	for i in range(4):
		draw_circle(c, (18.0 + i * 12.0) * (1.0 + beat * 0.4), Color(1, 0.08, 0.05, (0.22 - i * 0.05) * (0.4 + a)))
	draw_circle(c, 7.0 + beat * 4.0, Color(1, 0.6, 0.5, 0.8 * (0.3 + a)))
	# veias em zigue-zague, crescendo com a crise
	for s in _seeds:
		var rng := RandomNumberGenerator.new()
		rng.seed = s[2] + int(t * 10.0)
		var ang: float = s[0]
		var ln: float = s[1] * (0.2 + a * 0.8)
		var p := c
		var pts := PackedVector2Array([p])
		for k in range(6):
			ang += rng.randf_range(-0.5, 0.5)
			p += Vector2(cos(ang), sin(ang) * 1.3) * ln / 6.0
			pts.append(p)
		draw_polyline(pts, Color(1, 0.12, 0.08, 0.75 * (0.3 + a)), 2.5)
		draw_polyline(pts, Color(1, 0.7, 0.6, 0.35 * (0.3 + a)), 1.0)
