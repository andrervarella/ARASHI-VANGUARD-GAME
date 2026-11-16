extends Node
# Cena inicial. Para testes: godot -- --go level torii  |  --go story abertura

func _ready() -> void:
	var a := OS.get_cmdline_user_args()
	var i := a.find("--go")
	if i != -1 and a.size() > i + 2:
		if a.has("--power"):
			Game.data["poderes"] = ["furia", "jade"]
			Game.data["equipado"] = a[a.find("--power") + 1]
		if a.has("--x"):
			Game.data["cp"] = {"fase": a[i + 2], "x": float(a[a.find("--x") + 1])}
		Game.goto.call_deferred(a[i + 1], a[i + 2])
	else:
		Game.goto.call_deferred("title")
