const Macro = {
	add(name: string, obj: any) {
		obj.handler.call({
			args: [],
			output: { append: () => { } }
		});
	}
};
// BODY
const omega = "\u{3C9}";
const acute = "\u{301}";
const grave = "\u{300}";
const hacek = "\u{30C}";
const schwa = "\u{259}";
function em(c: string, n: number) {
	return c + ["", acute, grave, hacek][n]
}
function group(a: string, b: string, n: number) {
	return `[${a}${em("-", n)}${b}]`
}
type Character = {
	[x: string]: {
		names: {
			name: string,
			pronunciation: string
		},
		species: string,
		sex: "Male" | "Female",
		extra: string[]
	}
}
const characters: Character = {
	morrigan: {
		names: {
			name: "Morrigan",
			pronunciation: `M${em(omega, 1)}r${schwa}g${em("y", 2)}n`
		},
		species: "Reaper",
		sex: "Female",
		extra: ["Wields a scythe"]
	},
	hound: {
		names: {
			name: "Hound",
			pronunciation: `H${group("a", "u", 1)}nd`
		},
		species: "Changeling",
		sex: "Female",
		extra: ["Shapeshifts into a large, black Wolf"]
	}
};
const el = document.createElement.bind(document);
Macro.add("char", {
	handler() {
		const c = characters[this.args[0]];
		const out = el("dl");
		const names = el("dt");
		names.innerText = "Name";
		out.appendChild(names);
		const name = el("dd");
		name.className = "name"
		name.innerText = c.names.name;
		out.appendChild(name);
		const pronunciation = el("dd");
		pronunciation.className = "pronunciation";
		pronunciation.innerText = c.names.pronunciation;
		out.appendChild(pronunciation);
		const species_ = el("dt");
		species_.innerText = "Species";
		out.appendChild(species_);
		const species = el("dd");
		species.innerText = c.species;
		out.appendChild(species);
		species.innerText = c.species;
		out.appendChild(species);
		const extra = el("dt");
		extra.innerText = "Extra";
		out.appendChild(extra);
		for (const e of c.extra) {
			const ex = el("dd");
			ex.innerText = e;
			out.appendChild(ex);
		}
		out.setAttribute("data-sex", c.sex);
		this.output.append(out)
	}
});