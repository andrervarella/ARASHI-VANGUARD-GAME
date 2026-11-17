extends StaticBody2D
# Obstáculo quebrável: caixa (katana) ou parede rachada (só Golpe da Fúria).

signal broken(id)

var kind := "caixa"
var id := ""
var size := Vector2(120, 120)
var hp := 2
var level: Node
var _shake := 0.0
var _tex: Texture2D

func _ready() -> void:
	collision_layer = 1
	var cs := CollisionShape2D.new()
	var rs := RectangleShape2D.new()
	rs.size = size
	cs.shape = rs
	cs.position = Vector2(size.x / 2.0, -size.y / 2.0)
	add_child(cs)
	add_to_group("breakable")

func get_rect() -> Rect2:
	return Rect2(global_position + Vector2(0, -size.y), size)

func hit_by(k: String) -> void:
	if kind == "nevoa":
		_shake = 0.2
		Game.sfx("absorb", -10.0)
		if level:
			level.toast("Névoa envenenada... só algo que a engula a dissiparia.")
		return
	if kind == "selo":
		if level and level.player and level.player.carmesim:
			hp = 0
			Game.sfx("sino", -4.0)
			_break()
			return
		Game.sfx("clash", -6.0)
		_shake = 0.2
		if level:
			level.toast("Um selo tingido pela Lua Carmesim. Só um sangue igual o rompe.")
		return
	if kind == "rachada" and k != "furia":
		Game.sfx("clash", -6.0)
		_shake = 0.2
		if level:
			level.toast("Rachada... precisa de um golpe com mais fúria.")
		return
	hp -= 1 if k == "katana" else 3
	_shake = 0.2
	Game.sfx("hit1", -6.0)
	if hp <= 0:
		_break()

func _break() -> void:
	Game.sfx("break", -2.0)
	for i in range(5):
		load("res://src/fx.gd").spawn(level, "dust", get_rect().get_center() + Vector2(randf_range(-40, 40), randf_range(-40, 40)), {"r": 70.0, "life": 0.5})
	remove_from_group("breakable")
	broken.emit(id)
	queue_free()

func _process(dt: float) -> void:
	_shake = maxf(0.0, _shake - dt)
	# a Bocarra de Jade engole a névoa quando Ren chega perto
	if kind == "nevoa" and level and level.player and is_in_group("breakable"):
		var p = level.player
		if p.jade_t > 0.0 and p.global_position.distance_to(get_rect().get_center()) < 280.0:
			Game.sfx("absorb", 0.0)
			p.gain_ki(10.0)
			_break()
			return
	queue_redraw()

func _draw() -> void:
	var o := Vector2(randf_range(-3, 3), 0) if _shake > 0.0 else Vector2.ZERO
	var r := Rect2(Vector2(0, -size.y) + o, size)
	var tp := "res://assets/props/%s.png" % {"caixa": "caixa", "nevoa": "nevoa", "selo": "selo_carmesim"}.get(kind, "parede_rachada")
	if _tex == null and ResourceLoader.exists(tp):
		_tex = load(tp)
	if _tex and kind in ["nevoa", "selo"]:
		# barreira alta: a arte é empilhada na vertical, sem esticar
		var tw := r.size.x + 12.0
		var th := tw * float(_tex.get_height()) / float(_tex.get_width())
		var y := r.end.y - th
		var a := 0.75 + 0.25 * sin(Time.get_ticks_msec() * 0.004) if kind == "nevoa" else 1.0
		while y > r.position.y - th + 1.0:
			draw_texture_rect(_tex, Rect2(Vector2(r.position.x - 6.0, y) + o, Vector2(tw, th)), false, Color(1, 1, 1, a))
			y -= th * 0.92
		return
	if _tex:
		draw_texture_rect(_tex, Rect2(r.position - Vector2(6, 8), r.size + Vector2(12, 12)), false)
		if kind == "rachada":
			var c := r.get_center()
			draw_circle(c, 40.0, Color(1, 0.45, 0.1, 0.10 + 0.08 * sin(Time.get_ticks_msec() * 0.005)))
		return
	if kind == "caixa":
		var wood := Color(0.36, 0.22, 0.13)
		draw_rect(r, wood)
		draw_rect(r, Color(0.12, 0.07, 0.05), false, 4.0)
		draw_line(r.position, r.end, Color(0.2, 0.12, 0.07), 6.0)
		draw_line(Vector2(r.position.x, r.end.y), Vector2(r.end.x, r.position.y), Color(0.2, 0.12, 0.07), 6.0)
		draw_rect(Rect2(r.position + Vector2(6, 6), r.size - Vector2(12, 12)), Color(0.5, 0.32, 0.18), false, 2.0)
	else:
		draw_rect(r, Color(0.22, 0.2, 0.18))
		for i in range(int(size.y / 40.0)):
			var y := r.position.y + i * 40.0
			draw_line(Vector2(r.position.x, y), Vector2(r.end.x, y), Color(0.12, 0.11, 0.1), 3.0)
			var xo := 50.0 if i % 2 == 0 else 0.0
			var x := r.position.x + xo
			while x < r.end.x:
				draw_line(Vector2(x, y), Vector2(x, y + 40.0), Color(0.12, 0.11, 0.1), 3.0)
				x += 100.0
		var c := r.get_center()
		var pts := PackedVector2Array([c + Vector2(-10, -130), c + Vector2(12, -70), c + Vector2(-8, -20), c + Vector2(20, 40), c + Vector2(-4, 90), c + Vector2(14, 140)])
		draw_polyline(pts, Color(1, 0.45, 0.1, 0.55 + 0.25 * sin(Time.get_ticks_msec() * 0.005)), 5.0)
		draw_rect(r, Color(0.08, 0.07, 0.06), false, 4.0)
