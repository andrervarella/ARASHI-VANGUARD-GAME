extends Node2D
# Primeiro plano em paralaxe (DEC-026): silhuetas escuras que passam na frente da câmera,
# mais rápido que o mundo, para dar profundidade. Finas e espaçadas para não esconder o jogo.

var level: Node
var theme := "ferreiros"
var largura := 6000.0
var GY := 900.0
const K := 0.35
const SIL := Color(0.03, 0.02, 0.04, 0.93)

func _ready() -> void:
	z_index = 23

func _process(_dt: float) -> void:
	if level and level.cam:
		position.x = -level.cam.get_screen_center_position().x * K

func _glow(c: Vector2, r: float, col: Color) -> void:
	for i in range(6):
		var f := 1.0 - i / 6.0
		draw_circle(c, r * (0.4 + f * 1.6), Color(col.r, col.g, col.b, 0.05 + 0.03 * (1.0 - f)))
	draw_circle(c, r * 0.45, Color(col.r, col.g, col.b, 0.85))

func _draw() -> void:
	# (v0.14) nada de colunas de cima a baixo: elas pareciam faixas pretas (defeito).
	# Agora: galhos/cortinas pendendo do alto e arbustos/pedras baixos, só nas bordas da tela.
	var n := int(largura * (1.0 + K) / 900.0) + 2
	for i in range(n):
		var x := 500.0 + i * 900.0 + (i % 3) * 120.0
		if i % 2 == 0:
			_top(x, i)
		else:
			_low(x, i)
	_grass()

func _sil(a := 0.9) -> Color:
	var c: Color = {"torii": Color(0.10, 0.03, 0.05), "palacio": Color(0.07, 0.03, 0.06), "vila": Color(0.03, 0.05, 0.06)}.get(theme, Color(0.07, 0.04, 0.03))
	return Color(c.r, c.g, c.b, a)

func _top(x: float, i: int) -> void:
	var y0 := GY - 360.0
	match theme:
		"torii":
			# galho de bordo pendendo, com folhas vermelhas
			draw_line(Vector2(x - 160, y0), Vector2(x + 40, y0 + 70), _sil(), 10.0)
			draw_line(Vector2(x - 40, y0 + 40), Vector2(x + 30, y0 + 120), _sil(), 5.0)
			for k in range(9):
				var p := Vector2(x - 120 + k * 22, y0 + 30 + (k % 3) * 22 + k * 6)
				draw_colored_polygon(PackedVector2Array([p, p + Vector2(10, 14), p + Vector2(-4, 18)]), Color(0.45, 0.06, 0.08, 0.85))
		"palacio":
			# borla de seda e cordão pendendo do alto
			draw_line(Vector2(x, y0 - 40), Vector2(x, y0 + 90), Color(0.5, 0.36, 0.12, 0.9), 4.0)
			draw_circle(Vector2(x, y0 + 96), 10.0, Color(0.5, 0.36, 0.12, 0.95))
			draw_colored_polygon(PackedVector2Array([Vector2(x - 10, y0 + 100), Vector2(x + 10, y0 + 100), Vector2(x + 16, y0 + 170), Vector2(x - 16, y0 + 170)]), Color(0.35, 0.03, 0.06, 0.92))
		"vila":
			draw_line(Vector2(x - 180, y0 + 10), Vector2(x + 60, y0 + 50), _sil(), 9.0)
			for k in range(6):
				var p := Vector2(x - 150 + k * 36, y0 + 16 + k * 6)
				draw_colored_polygon(PackedVector2Array([p + Vector2(-26, 20), p + Vector2(0, -14), p + Vector2(26, 20)]), _sil())
		_:
			# fio de lanternas de papel
			draw_line(Vector2(x - 200, y0), Vector2(x + 200, y0 + 30), _sil(), 3.0)
			for k in range(3):
				var p := Vector2(x - 120 + k * 120, y0 + 8 + k * 10)
				draw_line(p, p + Vector2(0, 20), _sil(), 2.0)
				draw_circle(p + Vector2(0, 46), 34.0, Color(1, 0.5, 0.2, 0.06))
				draw_rect(Rect2(p + Vector2(-13, 20), Vector2(26, 48)), Color(0.55, 0.16, 0.07, 0.95))
				draw_rect(Rect2(p + Vector2(-13, 20), Vector2(26, 48)), Color(1, 0.6, 0.3, 0.25), false, 2.0)

func _low(x: float, i: int) -> void:
	# arbusto/pedras escuros na beira de baixo (passam na frente dos pés)
	var y := GY + 128.0
	var c := _sil(0.92)
	draw_circle(Vector2(x, y - 20), 46.0, c)
	draw_circle(Vector2(x + 48, y - 8), 38.0, c)
	draw_circle(Vector2(x - 46, y - 4), 34.0, c)
	if theme == "torii" or theme == "vila":
		for k in range(5):
			var bx := x - 50 + k * 25
			draw_line(Vector2(bx, y - 30), Vector2(bx + (k - 2) * 8, y - 78 - (k % 2) * 18), c, 4.0)

func _grass() -> void:
	# capim / entulho escuro na beira de baixo da tela (tufos em triângulos simples)
	var w := largura * (1.0 + K) + 1400.0
	var col := Color(0.02, 0.015, 0.03, 0.9)
	draw_rect(Rect2(-200, GY + 122, w + 200, 400), col)
	var x := -200.0
	var k := 0
	while x < w:
		var hgt := 30.0 + 14.0 * sin(k * 1.7) + 8.0 * sin(k * 0.6)
		draw_colored_polygon(PackedVector2Array([Vector2(x, GY + 124), Vector2(x + 18, GY + 128 - hgt), Vector2(x + 38, GY + 124)]), col)
		x += 38.0
		k += 1
