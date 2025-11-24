interface Char {
names:{
name:Array<string>|string
pron:Array<Array<string>>|string
}
species:string;
sex:"Male"|"Female"|"Neuter"
extra:Array<string>
}
(State.variables as any).characters={}
fetch("src/data.json")
.then((response)=>response.json())
.then((data:{
init:{
ifid:string
start:string
}characters:Record<string,Char>
})=>{
Object.entries(data.characters)
.forEach(([k,v]:[string,Char])=>{
v.names.name=(v.names.name as Array<string>)
.join(" ");
v.names.pron=(v.names.pron as Array<Array<string>>)
.map((i)=>i.join(""))
.join("\u{B7}");
(State.variables as any).characters[k]=v});
Engine.play("Main")
})
.catch((error)=>console.error("Error loading JSON:",error));