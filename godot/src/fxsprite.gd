extends Node2D
# Efeito em folha de quadros (PixelLab VFX workbench, assets/fx/<nome>.png).
# Toca uma vez (ou em laço) e some. Também serve de desenhador para projéteis.

# nome: [largura do quadro, altura, colunas, quadros, fps, âncora x, âncora y, laço]
const SHEETS := {
	"onda_brasa": [56, 39, 3, 8, 12, 28, 34, true],
	"brasa_oni": [74, 28, 4, 12, 12, 63, 15, true],
	"acerto": [45, 43, 3, 6, 16, 21, 22, false],
	"aparo": [66, 69, 3, 8, 16, 35, 30, false],
	"vapor": [54, 25, 3, 8, 12, 41, 12, true],
	"choque": [116, 50, 3, 8, 14, 58, 25, false],
	"defesa": [61, 82, 4, 10, 18, 0, 41, false],
}
static var _tex := {}

var sheet := "acerto"
var t := 0.0
var scale_px := 2.0
var flip := false
var follow: Node2D
var loop_override := -1
var tint := Color.WHITE

static func tex(name: String) -> Texture2D:
	if not _tex.has(name):
		_tex[name] = load("res://assets/fx/%s.png" % name)
	return _tex[name]

static func play(parent: Node, name: String, pos: Vector2, opts := {}) -> Node2D:
	var f = load("res://src/fxsprite.gd").new()
	f.sheet = name
	f.position = pos
	for k in opts:
		f.set(k, opts[k])
	f.z_index = 22
	parent.add_child(f)
	return f

func _process(dt: float) -> void:
	t += dt
	var m: Array = SHEETS[sheet]
	var looping: bool = m[7] if loop_override == -1 else loop_override == 1
	if not looping and t * float(m[4]) >= float(m[3]):
		queue_free()
		return
	queue_redraw()

func frame_rect() -> Rect2:
	var m: Array = SHEETS[sheet]
	var n := int(t * float(m[4])) % int(m[3])
	return Rect2((n % int(m[2])) * m[0], (n / int(m[2])) * m[1], m[0], m[1])

func _draw() -> void:
	draw_sheet(self, sheet, frame_rect(), Vector2.ZERO, scale_px, flip, tint)

static func draw_sheet(ci: CanvasItem, name: String, src: Rect2, at: Vector2, sc: float, flp: bool, col := Color.WHITE) -> void:
	var m: Array = SHEETS[name]
	var ax := float(m[5])
	var ay := float(m[6])
	var size := Vector2(m[0], m[1]) * sc
	var pos := at - Vector2(ax, ay) * sc
	if flp:
		pos.x = at.x - (float(m[0]) - ax) * sc
		size.x = -size.x
		pos.x -= size.x
	ci.draw_texture_rect_region(tex(name), Rect2(pos, size), src, col)
