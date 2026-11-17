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

var _hinted := false
func _process(dt: float) -> void:
	_shake = maxf(0.0, _shake - dt)
	# explica a barreira quando Ren chega perto (uma vez por visita)
	if kind in ["nevoa", "selo"] and not _hinted and level and level.player:
		if level.player.global_position.distance_to(get_rect().get_center()) < 420.0:
			_hinted = true
			var tem: bool = Game.data["poderes"].has("jade" if kind == "nevoa" else "carmesim")
			if kind == "nevoa":
				level.toast("Névoa da Gula: envenena quem passa. A Bocarra de Jade a devora." if tem else "Névoa da Gula... um dia, um poder que engula tudo a devorará. Lembre-se deste lugar.")
			else:
				level.toast("Selo de sangue da Lua Vermelha: só a Forma Carmesim o rompe." if tem else "Um selo de sangue. Nenhuma lâmina comum o corta... ainda.")
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
	var tp := "res://assets/props/%s.png" % {"caixa": "caixa", "nevoa": "nevoa", "selo": "selo_carmesim", "jaula": "jaula"}.get(kind, "parede_rachada")
	if _tex == null and ResourceLoader.exists(tp):
		_tex = load(tp)
	if kind == "nevoa":
		_draw_nevoa(r, o)
		return
	if kind == "selo":
		_draw_selo(r, o)
		return
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
	if _tex and kind == "jaula":
		var jh := r.size.y + 30.0
		var jw := jh * float(_tex.get_width()) / float(_tex.get_height())
		draw_texture_rect(_tex, Rect2(Vector2(r.get_center().x - jw / 2.0, r.end.y - jh + 2.0) + o, Vector2(jw, jh)), false)
		return
	if _tex and kind == "caixa":
		# pilhas de caixas vistas de frente, sem esticar
		var asp := float(_tex.get_width()) / float(_tex.get_height())
		var n := maxi(1, int(round(r.size.x / (r.size.y * asp))))
		var cw := r.size.x / n
		for i in range(n):
			draw_texture_rect(_tex, Rect2(Vector2(r.position.x + i * cw, r.position.y + 2.0) + o, Vector2(cw, r.size.y + 2.0)), false)
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


# Névoa da Gula: sai de uma fenda no chão, sobe em nuvens suaves (sem bordas retas)
func _draw_nevoa(r: Rect2, o: Vector2) -> void:
	var t := Time.get_ticks_msec() * 0.001
	var cx := r.get_center().x + o.x
	var base := r.end.y
	# fenda brilhante no chão
	draw_rect(Rect2(cx - 70, base - 6, 140, 8), Color(0.05, 0.03, 0.06, 0.9))
	draw_line(Vector2(cx - 60, base - 3), Vector2(cx + 60, base - 3), Color(0.5, 1.0, 0.7, 0.55 + 0.2 * sin(t * 3.0)), 3.0)
	# nuvens que sobem: jade embaixo, violeta em cima
	for i in range(26):
		var ph := fmod(t * (0.10 + (i % 5) * 0.015) + i * 0.137, 1.0)
		var y := base - ph * r.size.y * 1.05
		var x := cx + sin(t * 0.8 + i * 1.7) * (30.0 + ph * 40.0)
		var rad := 34.0 + ph * 46.0 + (i % 3) * 8.0
		var a := sin(ph * PI) * 0.16
		var col := Color(0.25, 0.85, 0.55).lerp(Color(0.55, 0.3, 0.75), ph)
		draw_circle(Vector2(x, y), rad, Color(col.r, col.g, col.b, a))
		draw_circle(Vector2(x, y), rad * 0.55, Color(col.r, col.g, col.b, a * 0.9))
	# brilhos venenosos
	for i in range(10):
		var ph2 := fmod(t * 0.35 + i * 0.1, 1.0)
		var p := Vector2(cx + sin(i * 2.3 + t) * 50.0, base - ph2 * r.size.y)
		draw_circle(p, 2.5, Color(0.7, 1.0, 0.8, sin(ph2 * PI) * 0.8))
	# poste de pedra com talismã de aviso ao lado
	var px := r.position.x - 34.0 + o.x
	draw_rect(Rect2(px, base - 120, 26, 120), Color(0.32, 0.31, 0.3))
	draw_rect(Rect2(px - 4, base - 128, 34, 12), Color(0.24, 0.23, 0.22))
	draw_rect(Rect2(px + 5, base - 104, 16, 44), Color(0.92, 0.88, 0.78))
	draw_line(Vector2(px + 13, base - 98), Vector2(px + 13, base - 66), Color(0.1, 0.5, 0.3), 3.0)
	draw_line(Vector2(px + 8, base - 86), Vector2(px + 18, base - 80), Color(0.1, 0.5, 0.3), 2.0)

# Selo de sangue: duas estacas, correntes e um talismã vermelho pulsando no meio
func _draw_selo(r: Rect2, o: Vector2) -> void:
	var t := Time.get_ticks_msec() * 0.001
	var base := r.end.y
	var x0 := r.position.x - 10.0 + o.x
	var x1 := r.end.x + 10.0 + o.x
	var top := base - minf(r.size.y, 360.0)
	var wood := Color(0.18, 0.1, 0.08)
	for x in [x0, x1]:
		draw_rect(Rect2(x - 12, top - 20, 24, base - top + 20), wood)
		draw_rect(Rect2(x - 16, top - 28, 32, 10), Color(0.12, 0.06, 0.05))
	# correntes (elos alternados) em catenária
	for k in range(5):
		var yy := top + 30.0 + k * (base - top - 60.0) / 4.0
		var n := 9
		for j in range(n + 1):
			var f := j / float(n)
			var p := Vector2(lerpf(x0, x1, f), yy + sin(f * PI) * 18.0)
			if j % 2 == 0:
				draw_arc(p, 7.0, 0, TAU, 10, Color(0.42, 0.38, 0.36), 3.0)
			else:
				draw_line(p - Vector2(6, 0), p + Vector2(6, 0), Color(0.5, 0.46, 0.44), 4.0)
	# talismã com o selo vermelho
	var c := Vector2((x0 + x1) / 2.0, top + (base - top) * 0.45)
	var pulse := 0.5 + 0.5 * sin(t * 4.0)
	draw_circle(c, 70.0 + pulse * 10.0, Color(1, 0.1, 0.08, 0.10 + 0.08 * pulse))
	draw_rect(Rect2(c - Vector2(22, 46), Vector2(44, 92)), Color(0.93, 0.88, 0.78))
	draw_arc(c, 16.0, 0, TAU, 24, Color(0.85, 0.08, 0.06), 4.0)
	draw_line(c + Vector2(0, -34), c + Vector2(0, 34), Color(0.85, 0.08, 0.06), 3.0)
	draw_line(c + Vector2(-12, 22), c + Vector2(12, 30), Color(0.85, 0.08, 0.06), 3.0)
