extends CharacterBody2D
# Ren Arashi — corpo provisório desenhado por código (NÃO é o sprite final).
# Será trocado pelo sprite piloto quando for aprovado.

const SPEED := 270.0
const JUMP_V := -560.0
const GRAVITY := 1650.0
const ATTACK_TIME := 0.34
const HIT_START := 0.08
const HIT_END := 0.22

var ctl: Control
var facing := 1
var attack_t := 0.0
var coyote := 0.0
var jump_buf := 0.0
var anim_t := 0.0
var _hit_done := {}
var crouching := false
var _shape: RectangleShape2D
var _cshape: CollisionShape2D
const H_STAND := 84.0
const H_CROUCH := 50.0

func _ready() -> void:
	var cs := CollisionShape2D.new()
	var rs := RectangleShape2D.new()
	rs.size = Vector2(34, H_STAND)
	cs.shape = rs
	cs.position = Vector2(0, -H_STAND / 2.0)
	add_child(cs)
	_shape = rs
	_cshape = cs
	add_to_group("player")

func hit_rect() -> Rect2:
	var w := 92.0
	var x := 14.0 if facing > 0 else -14.0 - w
	if crouching:
		return Rect2(global_position + Vector2(x, -48), Vector2(w, 44))
	return Rect2(global_position + Vector2(x, -78), Vector2(w, 66))

func _can_stand() -> bool:
	# há espaço livre acima para levantar?
	var q := PhysicsShapeQueryParameters2D.new()
	var r := RectangleShape2D.new()
	r.size = Vector2(32, H_STAND - 4.0)
	q.shape = r
	q.transform = Transform2D(0.0, global_position + Vector2(0, -H_STAND / 2.0 - 1.0))
	q.exclude = [get_rid()]
	return get_world_2d().direct_space_state.intersect_shape(q, 1).is_empty()

func _set_crouch(v: bool) -> void:
	if v == crouching:
		return
	crouching = v
	var h := H_CROUCH if v else H_STAND
	_shape.size = Vector2(34, h)
	_cshape.position = Vector2(0, -h / 2.0)

func _physics_process(dt: float) -> void:
	anim_t += dt
	var dir: float = ctl.move if ctl else 0.0
	var want_crouch: bool = ctl != null and ctl.crouch_down and is_on_floor()
	if want_crouch:
		_set_crouch(true)
	elif crouching and not (ctl != null and ctl.crouch_down) and _can_stand():
		_set_crouch(false)
	if crouching:
		dir *= 0.45   # andar agachado é mais lento
	if attack_t > 0.0:
		attack_t -= dt
		dir *= 0.35   # atacando: anda pouco
		if attack_t <= ATTACK_TIME - HIT_START and attack_t >= ATTACK_TIME - HIT_END:
			_try_hit()
	if dir != 0.0:
		facing = 1 if dir > 0.0 else -1
	velocity.x = move_toward(velocity.x, dir * SPEED, 2600.0 * dt)
	if is_on_floor():
		coyote = 0.1
	else:
		coyote -= dt
		velocity.y += GRAVITY * dt
	if ctl and ctl.jump_pressed:
		jump_buf = 0.12
	jump_buf -= dt
	if jump_buf > 0.0 and coyote > 0.0 and not crouching:
		velocity.y = JUMP_V
		jump_buf = 0.0
		coyote = 0.0
	# pulo variável: soltar o botão corta o pulo
	if ctl and not ctl.jump_down and velocity.y < -180.0:
		velocity.y = -180.0
	if ctl and ctl.attack_pressed and attack_t <= 0.0:
		attack_t = ATTACK_TIME
		_hit_done.clear()
	move_and_slide()
	queue_redraw()

func _try_hit() -> void:
	var r := hit_rect()
	for t in get_tree().get_nodes_in_group("hittable"):
		if _hit_done.has(t):
			continue
		if r.intersects(t.target_rect()):
			_hit_done[t] = true
			t.take_hit(facing)

func _draw() -> void:
	if crouching:
		draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0, 0.62))   # provisório: achata o corpo
	var f := float(facing)
	var moving := absf(velocity.x) > 20.0 and is_on_floor()
	var bob := sin(anim_t * 14.0) * 3.0 if moving else sin(anim_t * 3.0) * 1.2
	var air := not is_on_floor()
	var robe := Color("17171f")
	var robe_hi := Color("2b2b38")
	var skin := Color("c89870")
	var hair := Color("1c1a1a")
	var beard := Color("2a2626")
	var sash := Color("a3182a")
	# manto
	var lean := 6.0 * f if moving else 0.0
	draw_colored_polygon(PackedVector2Array([
		Vector2(-17 + lean, -40 + bob), Vector2(17 + lean, -40 + bob),
		Vector2(22, 0), Vector2(-22, 0)]), robe)
	draw_colored_polygon(PackedVector2Array([
		Vector2(-17 + lean, -40 + bob), Vector2(-4 + lean, -40 + bob),
		Vector2(-6, 0), Vector2(-22, 0)]), robe_hi)
	# faixa vermelha
	draw_rect(Rect2(-18 + lean * 0.6, -36 + bob, 36, 7), sash)
	# torso
	draw_colored_polygon(PackedVector2Array([
		Vector2(-18 + lean, -74 + bob), Vector2(18 + lean, -74 + bob),
		Vector2(17 + lean, -38 + bob), Vector2(-17 + lean, -38 + bob)]), robe)
	# cabeça (cabelo comprido, barba)
	var hc := Vector2(lean + 2.0 * f, -88 + bob)
	draw_circle(hc, 13.0, skin)
	draw_rect(Rect2(hc.x - 14, hc.y - 14, 28, 12), hair)
	# cabelo longo caindo atrás
	var back := -f
	draw_colored_polygon(PackedVector2Array([
		Vector2(hc.x + back * 8, hc.y - 10), Vector2(hc.x + back * 18, hc.y - 6),
		Vector2(hc.x + back * 22, hc.y + 22), Vector2(hc.x + back * 10, hc.y + 16)]), hair)
	draw_colored_polygon(PackedVector2Array([
		Vector2(hc.x - 9, hc.y + 4), Vector2(hc.x + 9, hc.y + 4),
		Vector2(hc.x + 7, hc.y + 18), Vector2(hc.x - 7, hc.y + 18)]), beard)
	draw_circle(hc + Vector2(5.0 * f, -1), 1.8, Color.WHITE)
	# katana
	var swing := 0.0
	if attack_t > 0.0:
		swing = 1.0 - (attack_t / ATTACK_TIME)
	var hand := Vector2(lean + 14.0 * f, -58 + bob)
	var ang := -1.2 + swing * 2.6
	if air and attack_t <= 0.0:
		ang = -0.5
	var tip := hand + Vector2(cos(ang) * f, sin(ang)) * 74.0
	draw_line(hand - (tip - hand) * 0.15, tip, Color("d9dde6"), 3.0)
	draw_line(hand - (tip - hand) * 0.15, hand, Color("5a1a1a"), 5.0)
	if attack_t > 0.0 and attack_t < ATTACK_TIME - 0.03:
		# arco do golpe
		var a0 := -1.2
		for i in range(8):
			var a1 := a0 + (ang - a0) * float(i + 1) / 8.0
			var p0 := hand + Vector2(cos(a0 + (ang - a0) * float(i) / 8.0) * f, sin(a0 + (ang - a0) * float(i) / 8.0)) * 70.0
			var p1 := hand + Vector2(cos(a1) * f, sin(a1)) * 70.0
			draw_line(p0, p1, Color(1, 1, 1, 0.12 + 0.05 * i), 4.0)
