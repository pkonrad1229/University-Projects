const express = require("express");
const app = express();
const bodyParser = require("body-parser");
const path = require("path");
const { v1: uuidv1 } = require("uuid");
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, "build")));


const fs = require('fs');

let rawdata = fs.readFileSync(path.join(__dirname, "recipes.json"));
let data = JSON.parse(rawdata);

app.get("/", (req, res) => {
  res.sendFile(path.join(__dirname, "build", "index.html"));
});
app.get("/api", (req, res) => res.json(data));
app.get("/api/:id", (req, res) => {
  let recipe = data.recipes.find(
    (recipe) => recipe.id.toString() === req.params.id
  );
  res.set({
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*",
  });
  if (recipe === undefined) {
    res.json("");
  } else res.json(recipe);
});
app.post("/api", (req, res) => {
  let recipe = req.body;
  recipe = {
    ...recipe,
    id: uuidv1(),
  };
  data.recipes.push(recipe);
  fs.writeFile(path.join(__dirname, "recipes.json"), JSON.stringify(data, null, 2), (err) => {
    if (err) throw err;

});
  res.end("It worked!");
});

app.delete("/api/:id", (req, res) => {
  const id = req.params.id;

  data.recipes = data.recipes.filter((recipe) => {
    if (recipe.id.toString() !== id) {
      return true;
    }
    return false;
  });
  fs.writeFile(path.join(__dirname, "recipes.json"), JSON.stringify(data, null, 2), (err) => {
    if (err) throw err;
});
  res.end("It worked!");
});

app.put("/api/:id", (req, res) => {
  const id = req.params.id;
  const newRecipe = req.body;

  for (let i = 0; i < data.recipes.length; i++) {
    let recipe = data.recipes[i];
    if (recipe.id.toString() === id) {
      data.recipes[i] = {
        ...newRecipe,
        id: data.recipes[i].id,
      };
    }
  }
  fs.writeFile(path.join(__dirname, "recipes.json"), JSON.stringify(data, null, 2), (err) => {
    if (err) throw err;
});
  res.end("It worked!");
});

app.listen(5000);
