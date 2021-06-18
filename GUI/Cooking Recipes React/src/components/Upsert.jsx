import React, { useState, useEffect } from "react";
import { useParams } from "react-router-dom";
import { useHistory } from "react-router-dom";
import Container from "react-bootstrap/Container";
import Table from "react-bootstrap/Table";
import IngredientRow from "./IngredientRow";
import AddIngredient from "./AddIngredient";
import Button from "react-bootstrap/Button";

function Upsert() {
  let { id } = useParams();
  const [isPending, setIsPending] = useState(true);
  const [recipe, setRecipe] = useState({
    name: "",
    recipe: "",
    ingredients: [],
  });
  const [ingredientsList, setIngredientsList] = useState({
    name: [],
    quantity: [],
    unit: [],
  });

  useEffect(() => {
    const abortCont = new AbortController();
    fetch("http://localhost:5000/api/" + id, { signal: abortCont.signal })
      .then((res) => {
        return res.json();
      })
      .then((data) => {
        if (Object.keys(data).length !== 0) {
          setRecipe(data);

          data.ingredients.map((oldIngredient) => {
            const array = oldIngredient.split(" ");
            var name = "";
            var quantity = "";
            var unit = "";
            var isName = true;
            for (var i = 0; i < array.length; i++) {
              if (isNaN(array[i]) || !isName) {
                if (isName) {
                  if (name === "") {
                    name = array[i];
                  } else {
                    name += " " + array[i];
                  }
                } else {
                  if (unit === "") {
                    unit = array[i];
                  } else {
                    name += " " + array[i];
                  }
                }
              } else {
                quantity = array[i];
                isName = false;
              }
            }
            setIngredientsList((prevList) => {
              return {
                name: [...prevList.name, name],
                quantity: [...prevList.quantity, quantity],
                unit: [...prevList.unit, unit],
              };
            });
          });
        } else {
          if (id !== "new") {
            history.push("/");
          }
        }
        setIsPending(false);
      });
    return () => abortCont.abort();
  }, []);

  const history = useHistory();

  function handleSubmit(event) {
    event.preventDefault();
    if (
      recipe.name === "" ||
      recipe.recipe === "" ||
      recipe.ingredients.length === 0
    ) {
      //toast or something
    } else {
      setRecipe( prevRecipe =>{
        return (
          {
            ...prevRecipe,
            recipe: prevRecipe.recipe.split("\n")
          }
        )
      })
      if (id === "new") {
        fetch("http://localhost:5000/api", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(recipe),
        }).then(() => {
          history.push("/");
        });
      } else {
        fetch("http://localhost:5000/api/" + id, {
          method: "PUT",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(recipe),
        }).then(() => {
          history.push("/");
        });
      }
    }
  }
  function deleteIngredient(id) {
    setRecipe((prevRecipe) => {
      const newIngredients = prevRecipe.ingredients.filter(
        (ingredient, index) => {
          return index !== id;
        }
      );
      return {
        ...prevRecipe,
        ingredients: newIngredients,
      };
    });
    setIngredientsList((prevList) => {
      return {
        name: prevList.name.filter((x, index) => {
          return index !== id;
        }),
        quantity: prevList.quantity.filter((x, index) => {
          return index !== id;
        }),
        unit: prevList.unit.filter((x, index) => {
          return index !== id;
        }),
      };
    });
  }

  function addIngredient(ingredient) {
    var newIngredients = recipe.ingredients
    var newIngredientsList = ingredientsList
    if (ingredientsList.name.includes(ingredient.ingredientName)){
      const index = ingredientsList.name.indexOf(ingredient.ingredientName)
      newIngredients[index] = ingredient.ingredientName +
      " " + ingredient.ingredientQuantity +
      " " + ingredient.ingredientUnit;
      newIngredientsList.quantity[index] = ingredient.ingredientQuantity;
      newIngredientsList.unit[index] = ingredient.ingredientUnit;
    } else { 
      newIngredients.push(ingredient.ingredientName +
        " " + ingredient.ingredientQuantity +
        " " + ingredient.ingredientUnit);
      newIngredientsList.name.push(ingredient.ingredientName);
      newIngredientsList.quantity.push(ingredient.ingredientQuantity);
      newIngredientsList.unit.push(ingredient.ingredientUnit);
    }
    setRecipe( prevRecipe => {
      return {
        ...prevRecipe,
        ingredients: newIngredients
      };
    });
    setIngredientsList(newIngredientsList);
  }

  function handleChange(event) {
    const { name, value } = event.target;

    setRecipe((prevRecipe) => {
      return {
        ...prevRecipe,
        [name]: value,
      };
    });
  }

  return (
    <div>
      {!isPending && (
        <Container>
          <div className="upsert">
            <h1>{id==="new" ? "Add new" : "Update existing"} recipe</h1>
            <form onSubmit={handleSubmit}>
              <label>Name:</label>
              <input
                name="name"
                type="text"
                required
                value={recipe.name}
                onChange={handleChange}
              />
              <label>Recipe:</label>
              <textarea
                name="recipe"
                type="text"
                required
                value={recipe.recipe}
                onChange={handleChange}
              ></textarea>
              <Container>
                <Table striped bordered hover>
                  <thead>
                    <tr>
                      <th>Ingredient</th>
                      <th>Quantity</th>
                      <th>Unit</th>

                      <th></th>
                    </tr>
                  </thead>
                  <tbody>
                    {recipe &&
                      recipe.ingredients.map((ingredient, index) => {
                        return (
                          <IngredientRow
                            name={ingredientsList.name[index]}
                            quantity={ingredientsList.quantity[index]}
                            unit={ingredientsList.unit[index]}
                            id={index}
                            onDelete={deleteIngredient}
                          />
                        );
                      })}
                    <AddIngredient onAdd={addIngredient} />
                  </tbody>
                </Table>
              </Container>
              <Button type="submit" >{id==="new" ? "Add new" : "Update"} recipe</Button>
            </form>
          </div>
        </Container>
      )}
    </div>
  );
}

export default Upsert;
