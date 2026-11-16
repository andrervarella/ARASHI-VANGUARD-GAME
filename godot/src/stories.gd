extends RefCounted
# Histórias em quadros (storyboard). Cada quadro: imagem, texto (legenda) e duração.
# "video": se existir res://assets/video/<id>.ogv, ele toca no lugar dos quadros
# (vaga reservada para as cutscenes do Higgsfield; a legenda continua por código).
# Linguagem épica (DEC-019): nada de gíria.

const S := {
	"abertura": {
		"musica": "titulo",
		"quadros": [
			{"img": "mapa", "txt": "Nas Sete Terras, sete selos aprisionam sete demônios.", "dur": 4.5, "texto_tela": true},
			{"img": "ritual", "txt": "Sete Casas guardam esses selos... e deles bebem o seu poder.", "dur": 4.5, "texto_tela": true},
			{"img": "pobres", "txt": "O preço dessa paz é pago com a vida dos humildes.", "dur": 4.5, "texto_tela": true},
			{"img": "mapa", "txt": "Todos os selos respondem a uma única tranca: o Grande Portão, erguido sobre a aldeia de Arashi.", "dur": 5.5},
			{"img": "aldeia", "txt": "Ali vive Ren Arashi, ferreiro como seu pai e o pai de seu pai. Foram as mãos de sua gente que forjaram as engrenagens do Portão.", "dur": 6.0},
			{"img": "ritual", "txt": "A cada lua cheia, as Sete Casas renovam o selo com a força vital dos aldeões.", "dur": 5.0},
			{"img": "lua_vermelha", "txt": "Mas na noite da Lua Vermelha, o ritual falha. A ira dos demônios rompe a terra.", "dur": 5.0, "video": "abertura"},
			{"img": "portao_trancado", "txt": "Para salvar a si mesmas, as Sete Casas trancam o Portão... com o povo de Arashi do lado de dentro.", "dur": 6.0},
			{"img": "ren_luke", "txt": "Ren conhece cada dente daquelas engrenagens. E sabe onde golpear.", "dur": 4.5},
		],
	},
	"cicatriz": {
		"musica": "titulo",
		"quadros": [
			{"img": "fuga", "txt": "O Grande Portão se rompe. O povo foge para as montanhas... e os sete selos se partem com ele.", "dur": 6.0},
			{"img": "baku2", "txt": "Baku, a Ira, foi o primeiro a se erguer. E deixou no rosto de Ren uma marca que não se apaga.", "dur": 5.5},
			{"img": "demonios", "txt": "Os sete demônios tomam as Sete Terras. E as Sete Casas apontam um único culpado: Ren Arashi.", "dur": 6.0},
			{"img": "ren_luke", "txt": "Para salvar seu povo, ele libertou sete demônios. Agora, há de caçar cada um.", "dur": 5.5},
			{"img": "torii", "txt": "Fase 1 — Vale das Torii\nBaku o aguarda.", "dur": 4.0, "titulo": true},
		],
	},
	"vila_chegada": {
		"musica": "vila",
		"quadros": [
			{"img": "refugio", "txt": "Nas montanhas, os sobreviventes de Arashi erguem um refúgio.", "dur": 5.0},
			{"img": "refugio", "txt": "O velho mestre Tetsu os guia. E sabe mais sobre os selos do que ousa dizer.", "dur": 5.0},
		],
	},
	"dois_chefes": {
		"musica": "vila",
		"quadros": [
			{"img": "lua", "txt": "Dois demônios tombaram. Mas as cicatrizes de Ren começam a se espalhar.", "dur": 5.0},
			{"img": "baku2", "txt": "Algo dentro dele anseia por sair. A Forma Carmesim.", "dur": 4.5},
			{"img": "ren_luke", "txt": "Só Luke consegue trazê-lo de volta.", "dur": 4.5},
			{"img": "mapa", "txt": "FIM DA DEMONSTRAÇÃO\nFases 1 e 2 concluídas. Obrigado por jogar!", "dur": 6.0, "titulo": true},
		],
	},
}
