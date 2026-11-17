extends Node
# Cena inicial. Para testes: godot -- --go level torii  |  --go story abertura

func _ready() -> void:
	var a := OS.get_cmdline_user_args()
	var i := a.find("--go")
	if i != -1 and a.size() > i + 2:
		if a.has("--power"):
			Game.data["poderes"] = ["furia", "jade", "carmesim"]
			Game.data["equipado"] = a[a.find("--power") + 1]
		if a.has("--x"):
			Game.data["cp"] = {"fase": a[i + 2], "x": float(a[a.find("--x") + 1])}
		Game.goto.call_deferred(a[i + 1], a[i + 2])
		if a.has("--halfboss"):
			_half_boss_later()
		if a.has("--killboss"):
			_kill_boss_later(16.0 if a.has("--halfboss") else 4.0)
	else:
		Game.goto.call_deferred("title")

# teste: derruba o chefe alguns segundos depois de a arena começar
func _half_boss_later() -> void:
	await get_tree().create_timer(4.0).timeout
	for f in get_tree().get_nodes_in_group("foes"):
		if f.get("is_boss"):
			f.take_hit(int(f.hp - f.hp_max / 2), 1, "teste")

func _kill_boss_later(t := 4.0) -> void:
	await get_tree().create_timer(t).timeout
	for f in get_tree().get_nodes_in_group("foes"):
		if f.get("is_boss"):
			f.take_hit(999, 1, "teste")
