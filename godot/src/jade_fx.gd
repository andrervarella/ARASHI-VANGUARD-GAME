extends Node2D
# Bocarra de Jade (DEC-026): mandíbula de dragão de jade diante do Ren, cúpula de escamas
# girando, vórtice que suga, contas orbitando. Morde (chomp) quando absorve um projétil.

var life := 1.8
var t := 0.0
var facing := 1
var _chomp := 0.0
const C := Vector2(0, -72)
const R := 150.0
const J_DARK := Color(0.04, 0.3, 0.19)
const J_MID := Color(0.16, 0.78, 0.5)
const J_LIGHT := Color(0.78, 1.0, 0.88)
const GOLD := Color(0.98, 0.86, 0.5)

func _ready() -> void:
	z_index = 12
	# estilhaços de jade na abertura
	var b := CPUParticles2D.new()
	b.one_shot = true
	b.emitting = true
	b.amount = 36
	b.lifetime = 0.55
	b.explosiveness = 1.0
	b.position = C
	b.spread = 180.0
	b.initial_velocity_min = 260.0
	b.initial_velocity_max = 520.0
	b.damping_min = 300.0
	b.damping_max = 500.0
	b.scale_amount_min = 3.0
	b.scale_amount_max = 7.0
	b.color = J_LIGHT
	add_child(b)
	# motas sendo sugadas para dentro da bocarra
	var s := CPUParticles2D.new()
	s.amount = 40
	s.lifetime = 0.7
	s.position = C
	s.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE_SURFACE
	s.emission_sphere_radius = R * 1.05
	s.gravity = Vector2.ZERO
	s.radial_accel_min = -520.0
	s.radial_accel_max = -380.0
	s.tangential_accel_min = 120.0
	s.tangential_accel_max = 200.0
	s.scale_amount_min = 2.0
	s.scale_amount_max = 4.0
	var g := Gradient.new()
	g.set_color(0, Color(J_MID.r, J_MID.g, J_MID.b, 0.0))
	g.set_color(1, Color(J_LIGHT.r, J_LIGHT.g, J_LIGHT.b, 0.9))
	s.color_ramp = g
	s.name = "suga"
	add_child(s)

func chomp() -> void:
	_chomp = 1.0

func _process(dt: float) -> void:
	t += dt
	_chomp = maxf(0.0, _chomp - dt * 3.5)
	if t > life - 0.35 and has_node("suga"):
		get_node("suga").emitting = false
	queue_redraw()
	if t >= life:
		queue_free()

func _draw() -> void:
	var k_in := clampf(t / 0.22, 0.0, 1.0)
	var k_out := clampf((life - t) / 0.35, 0.0, 1.0)
	var a := minf(ease(k_in, 0.4), k_out)
	var r := R * (0.55 + 0.45 * ease(k_in, 0.3)) * (1.0 + 0.06 * _chomp)
	# brilho externo e cúpula
	for i in range(5):
		draw_circle(C, r * (1.02 + i * 0.06), Color(J_MID.r, J_MID.g, J_MID.b, 0.035 * a))
	draw_circle(C, r, Color(J_DARK.r, J_DARK.g, J_DARK.b, 0.22 * a))
	# vórtice: quatro braços em espiral girando para dentro
	for arm in range(4):
		var pts := PackedVector2Array()
		for k in range(22):
			var f := k / 21.0
			var ang := -t * 5.0 + arm * TAU / 4.0 + f * 3.2
			pts.append(C + Vector2(cos(ang), sin(ang)) * r * (0.92 - f * 0.8))
		draw_polyline(pts, Color(J_LIGHT.r, J_LIGHT.g, J_LIGHT.b, 0.28 * a), 3.0, true)
	# escamas de jade em três anéis, girando em sentidos opostos
	for ring in range(3):
		var rr := r * (0.5 + ring * 0.19)
		var n := 10 + ring * 5
		var rot := t * (0.9 - ring * 0.5) * (1.0 if ring % 2 == 0 else -1.0)
		for j in range(n):
			var ang := rot + j * TAU / n
			var p := C + Vector2(cos(ang), sin(ang)) * rr
			var sr := 15.0 - ring * 2.5
			draw_arc(p, sr, ang - 1.1, ang + 1.1, 8, Color(J_MID.r, J_MID.g, J_MID.b, 0.55 * a), 3.0)
			draw_arc(p, sr - 3.0, ang - 0.8, ang + 0.8, 6, Color(J_LIGHT.r, J_LIGHT.g, J_LIGHT.b, 0.25 * a), 1.5)
	# aro duplo com runas girando
	draw_arc(C, r, 0, TAU, 72, Color(J_LIGHT.r, J_LIGHT.g, J_LIGHT.b, 0.85 * a), 4.0, true)
	draw_arc(C, r * 0.93, 0, TAU, 72, Color(J_MID.r, J_MID.g, J_MID.b, 0.6 * a), 2.0, true)
	for i in range(16):
		var ang := t * 1.4 + i * TAU / 16.0
		var d := Vector2(cos(ang), sin(ang))
		draw_line(C + d * r * 0.93, C + d * r * (0.99 if i % 2 == 0 else 0.96), Color(GOLD.r, GOLD.g, GOLD.b, 0.8 * a), 2.0)
	# mandíbula de dragão na frente do Ren: abre e fecha respirando; morde ao absorver
	var front := 0.0 if facing > 0 else PI
	var open := (0.2 + 0.07 * sin(t * 9.0)) * (1.0 - _chomp * 0.95)
	_jaw(front - open, -1.0, r, a)
	_jaw(front + open, 1.0, r, a)
	# contas orbitando com rastro
	for i in range(8):
		for tr in range(4):
			var ang := t * 3.4 - tr * 0.07 + i * TAU / 8.0
			var p := C + Vector2(cos(ang) * r * 0.82, sin(ang) * r * 0.82)
			var al := a * (1.0 - tr * 0.25)
			draw_circle(p, 7.0 - tr * 1.2, Color(J_DARK.r, J_DARK.g, J_DARK.b, al))
			draw_circle(p, 5.5 - tr * 1.2, Color(J_MID.r, J_MID.g, J_MID.b, al))
		var p0 := C + Vector2(cos(t * 3.4 + i * TAU / 8.0), sin(t * 3.4 + i * TAU / 8.0)) * r * 0.82
		draw_circle(p0 + Vector2(-2, -2), 1.8, Color(J_LIGHT.r, J_LIGHT.g, J_LIGHT.b, a))
	# clarão da mordida
	if _chomp > 0.0:
		var fp := C + Vector2(cos(front), sin(front)) * r * 0.75
		draw_circle(fp, 40.0 * _chomp, Color(J_LIGHT.r, J_LIGHT.g, J_LIGHT.b, 0.6 * _chomp))
	# estilhaços no fim
	if k_out < 1.0:
		for i in range(14):
			var ang := i * TAU / 14.0 + 0.3
			var d := Vector2(cos(ang), sin(ang))
			var dist := r * (1.0 + (1.0 - k_out) * 0.6)
			draw_line(C + d * dist, C + d * (dist + 18.0), Color(J_LIGHT.r, J_LIGHT.g, J_LIGHT.b, k_out), 3.0)

# uma mandíbula: crescente de jade com presas douradas (side = -1 em cima, +1 embaixo)
func _jaw(edge: float, side: float, r: float, a: float) -> void:
	var span := 0.95
	var a0 := edge
	var a1 := edge + side * span
	var outer := PackedVector2Array()
	var inner := PackedVector2Array()
	for k in range(13):
		var f := k / 12.0
		var ang := lerpf(a0, a1, f)
		var d := Vector2(cos(ang), sin(ang))
		outer.append(C + d * r * 1.08)
		inner.append(C + d * r * (0.74 + 0.14 * f))
	var poly := PackedVector2Array(outer)
	for k in range(inner.size() - 1, -1, -1):
		poly.append(inner[k])
	draw_colored_polygon(poly, Color(J_DARK.r, J_DARK.g, J_DARK.b, 0.92 * a))
	draw_polyline(outer, Color(J_LIGHT.r, J_LIGHT.g, J_LIGHT.b, 0.9 * a), 3.0, true)
	draw_polyline(inner, Color(J_MID.r, J_MID.g, J_MID.b, 0.9 * a), 2.0, true)
	# presas douradas: apontam através da boca, para a outra mandíbula (mordida)
	for k in range(0, 7):
		var f := k / 7.0
		var ang := lerpf(a0, a1, f * 0.8)
		var d := Vector2(cos(ang), sin(ang))
		var tng := Vector2(-d.y, d.x)
		var base := C + d * r * (0.8 + 0.1 * f)
		var dirt := (tng * -side * 0.85 - d * 0.35).normalized()
		var ln := 26.0 - f * 14.0
		var wv := tng * (7.0 - f * 3.0)
		draw_colored_polygon(PackedVector2Array([base - wv, base + wv, base + dirt * ln]), Color(GOLD.r, GOLD.g, GOLD.b, 0.95 * a))
		draw_line(base, base + dirt * ln * 0.8, Color(1, 1, 0.9, 0.6 * a), 1.5)
	# olho do dragão na mandíbula de cima, com brilho
	if side < 0.0:
		var ep := C + Vector2(cos(edge - 0.45), sin(edge - 0.45)) * r * 0.93
		draw_circle(ep, 14.0, Color(GOLD.r, GOLD.g, GOLD.b, 0.25 * a))
		draw_circle(ep, 8.0, Color(GOLD.r, GOLD.g, GOLD.b, a))
		draw_circle(ep, 3.5, Color(0.7, 0.05, 0.05, a))
