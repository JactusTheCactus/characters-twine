interface Char {
	names: {
		name: string;
		pronunciation: Array<string> | string;
	};
	species: string;
	sex: "Male" | "Female" | "Neuter";
	extra: string[];
}
(State.variables as any).characters = {}
fetch("src/data.json")
	.then(response => response.json())
	.then((data: {
		init: Record<string, any>,
		characters: Record<string, Char>
	}) => {
		Object.entries(data.characters)
			.forEach(([k, v]: [string, Char]) => {
				let pron: Array<string> | string = v.names.pronunciation
				if (Array.isArray(pron)) {
					pron = pron
						.join("")
				}
				v.names.pronunciation = pron;
				(State.variables as any).characters[k] = v;
			})
		Engine.play("Main")
	})
	.catch(error => console.error("Error loading JSON:", error));
