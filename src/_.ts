interface Char {
	names: {
		name: string
		pron: Array<Array<string>> | string
	}
	species: string
	sex: "Male" | "Female" | "Neuter"
	extra: Array<string>
}
(State.variables as any).characters = {}
fetch("src/data.json")
	.then(response => response.json())
	.then((data: {
		init: {
			ifid: string
			start: string
		}
		characters: Record<string, Char>
	}) => {
		Object.entries(data.characters)
			.forEach(([k, v]: [string, Char]) => {
				if (Array.isArray(v.names.pron)) {
					v.names.pron = v.names.pron
						.map(i => i.join(""))
						.join("\u00B7")
				}
				(State.variables as any).characters[k] = v
			})
		Engine.play("Main")
	})
	.catch(error => console.error("Error loading JSON:", error))
