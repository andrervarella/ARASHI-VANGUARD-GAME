extends RefCounted
# Histórias em quadros (storyboard). Cada quadro: imagem, texto (legenda) e duração.
# "video": se existir res://assets/video/<id>.ogv, ele toca no lugar dos quadros
# (vaga reservada para as cutscenes do Higgsfield; a legenda continua por código).

const S := {
	"abertura": {
		"musica": "titulo",
		"quadros": [
			{"img": "familias", "txt": "Sete famílias governam a cidade.", "dur": 4.0, "texto_tela": true},
			{"img": "demonios", "txt": "Debaixo dela, prenderam sete demônios.", "dur": 4.0, "texto_tela": true},
			{"img": "pobres", "txt": "E pagam essa paz com a vida dos pobres.", "dur": 4.0, "texto_tela": true},
			{"img": "lua", "txt": "Na noite da lua vermelha, o ritual das famílias falha.", "dur": 4.5, "video": "abertura"},
			{"img": "portao", "txt": "A energia dos demônios vaza no distrito. As famílias trancam o portão com o povo dentro.", "dur": 5.0},
			{"img": "forja", "txt": "Ren Arashi é ferreiro. Conhece cada engrenagem daquele portão.", "dur": 4.5},
			{"img": "demonios", "txt": "Ele arromba o portão para salvar seu povo... e abre também o selo.", "dur": 5.0},
			{"img": "baku", "txt": "No meio do fogo, uma sombra se ergue.", "dur": 4.0},
		],
	},
	"cicatriz": {
		"musica": "titulo",
		"quadros": [
			{"img": "baku2", "txt": "Baku, a Ira, foi o primeiro a sair. E deixou em Ren uma marca que arde.", "dur": 5.0},
			{"img": "pobres", "txt": "O povo escapou. Mas, para a cidade, o culpado tem nome: Ren Arashi.", "dur": 5.0},
			{"img": "ren_luke", "txt": "Para salvar seu povo, ele libertou sete demônios. Agora vai caçar cada um.", "dur": 5.5},
			{"img": "torii", "txt": "Fase 1 — Vale das Torii. Baku espera.", "dur": 4.0, "titulo": true},
		],
	},
	"vila_chegada": {
		"musica": "vila",
		"quadros": [
			{"img": "pobres", "txt": "Vila de Arashi. Quem fugiu do distrito encontrou abrigo aqui.", "dur": 4.5},
			{"img": "forja", "txt": "O velho mestre Tetsu cuida da vila. E sabe mais sobre os selos do que diz.", "dur": 5.0},
		],
	},
	"dois_chefes": {
		"musica": "vila",
		"quadros": [
			{"img": "lua", "txt": "Dois demônios caídos. As cicatrizes de Ren começam a se espalhar.", "dur": 5.0},
			{"img": "baku2", "txt": "Algo dentro dele quer sair. A Forma Carmesim.", "dur": 4.5},
			{"img": "ren_luke", "txt": "Só Luke consegue acalmá-lo.", "dur": 4.5},
			{"img": "portao", "txt": "FIM DA DEMONSTRAÇÃO\nFases 1 e 2 concluídas. Obrigado por jogar!", "dur": 6.0, "titulo": true},
		],
	},
}
