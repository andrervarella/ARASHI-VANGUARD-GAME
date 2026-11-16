extends Node2D
# Boneco de treino (alvo) — só para testar o golpe.
var hp := 5
var flash := 0.0
var wobble := 0.0
var respawn := 0.0

func _ready() -> void:
	add_to_group("hittable")

func target_rect() -> Rect2:
	if hp <= 0:
		return Rect2(0, 0, 0, 0)
	return Rect2(global_position + Vector2(-22, -110), Vector2(44, 110))

func take_hit(dir: int) -> void:
	hp -= 1
	flash = 0.15
	wobble = 0.3 * dir
	if hp <= 0:
		respawn = 2.5

func _process(dt: float) -> void:
	flash = maxf(0.0, flash - dt)
	wobble = move_toward(wobble, 0.0, dt * 1.2)
	if hp <= 0:
		respawn -= dt
		if respawn <= 0.0:
			hp = 5
	queue_redraw()

func _draw() -> void:
	if hp <= 0:
		return
	var c := Color("8a5a35") if flash <= 0.0 else Color.WHITE
	draw_set_transform(Vector2.ZERO, wobble, Vector2.ONE)
	draw_rect(Rect2(-6, -110, 12, 110), c)
	draw_rect(Rect2(-22, -96, 44, 14), c)
	draw_rect(Rect2(-22, -64, 44, 10), c)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	draw_rect(Rect2(-24, -128, 48, 6), Color(0, 0, 0, 0.6))
	draw_rect(Rect2(-24, -128, 48.0 * hp / 5.0, 6), Color("d4263b"))
