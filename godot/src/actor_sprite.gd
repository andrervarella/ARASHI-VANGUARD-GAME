extends AnimatedSprite2D
# Sprite com ponto de apoio nos pés (lido do JSON gerado por tools/montar_anim.py).

var meta := {}
var facing := 1

func setup(set_name: String) -> void:
	var s := Game.sprite_set(set_name)
	sprite_frames = s["frames"]
	meta = s["meta"]
	centered = false

func has_anim(an: String) -> bool:
	return meta.has(an)

func play_anim(an: String, restart := false, speed := 1.0) -> void:
	if not meta.has(an):
		return
	if animation != an or restart or not is_playing():
		play(an, speed)
		if restart:
			frame = 0
		_apply()
	speed_scale = speed

func set_facing(f: int) -> void:
	facing = 1 if f >= 0 else -1
	flip_h = facing < 0
	_apply()

func _apply() -> void:
	if not meta.has(animation):
		return
	var m: Dictionary = meta[animation]
	var a: Array = m["anchor"]
	var sz: Array = m["size"]
	offset = Vector2(-(float(sz[0]) - float(a[0])) if flip_h else -float(a[0]), -float(a[1]))
