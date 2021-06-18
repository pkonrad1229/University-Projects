import React, { useState, useEffect } from "react";
import Container from "react-bootstrap/Container";
import Table from "react-bootstrap/Table";
import Button from "react-bootstrap/Button";
import axios from 'axios';
function IngredientsPage() {
  const [data, setData] = useState();

  useEffect(() => {
      const fetchData = async () => {
          const result = await axios(
              '/api',
          );
          setData(result.data);
      };
      fetchData();
  }, []);

  const [ingredientsList, setIngredientsList] = useState(false);
  function handleSubmit(event) {
    event.preventDefault();
    var newIngredientsList = [];
    for (var i = 0; i < data.recipes.length; i++) {
      if (parseFloat(event.target[i].value) !== 0 && !isNaN(parseFloat(event.target[i].value))) {
        for (var index = 0; index < data.recipes[i].ingredients.length; index++) {
          const array = data.recipes[i].ingredients[index].split(" ");
          var name = "";
          var quantity;
          var unit = "";
          var isName = true;
          var wasAdded = false;
          for (var x = 0; x < array.length; x++) {
            if (isNaN(array[x]) || !isName) {
              if (isName) {
                if (name === "") {
                  name = array[x];
                } else {
                  name += " " + array[x];
                }
              } else {
                if (unit === "") {
                  unit = array[x];
                } else {
                  name += " " + array[x];
                }
              }
            } else {
              quantity = parseFloat(array[x]) * parseFloat(event.target[i].value);
              isName = false;
            }
          }
          for (var ing = 0; ing < newIngredientsList.length; ing++) {
            if (
              newIngredientsList[ing].name === name &&
              newIngredientsList[ing].unit === unit
            ) {
              newIngredientsList[ing].quantity +=
                quantity;
              wasAdded = true;
            }
          }
          if (!wasAdded) {
            newIngredientsList.push({
              name: name,
              quantity: quantity,
              unit: unit,
            });
          }
        }
      }
      
    }
    setIngredientsList(
      newIngredientsList.sort((a, b) => {
        if (a.name < b.name) {
          return -1;
        }
        if (a.name > b.name) {
          return 1;
        }
        return 0;
      })
    );
  }

  function handleClear(event) {
    event.preventDefault();
    setIngredientsList(false);
  }
  return (
    <Container>
      <div className="ingredients">
        <form onSubmit={handleSubmit}>
          <Table striped bordered hover>
            <thead>
              <tr>
                <th className="name">Recipe Name</th>
                <th className="value">Ammount</th>
              </tr>
            </thead>
            <tbody>
              {data &&
                data.recipes.map((recipe) => {
                  return (
                    <tr>
                      <td className="name">{recipe.name}</td>
                      <td className="value">
                        <input name={recipe.name} type="number" min="0" />
                      </td>
                    </tr>
                  );
                })}
            </tbody>
          </Table>
          <Button type="submit">Calculate ingredients</Button>
        </form>
        {ingredientsList && (
          <form onSubmit={handleClear}>
            <Button type="submit" variant ="secondary">Clear</Button>
          </form>
        )}
      </div>

      {ingredientsList && (
        <Container>
          <Table striped bordered hover>
            <thead>
              <tr>
                <th>Ingredient</th>
                <th>Quantity</th>
                <th>Unit</th>
              </tr>
            </thead>
            <tbody>
              {ingredientsList.map((ingredient) => {
                return (
                  <tr>
                    <td>{ingredient.name}</td>
                    <td>{ingredient.quantity}</td>
                    <td>{ingredient.unit}</td>
                  </tr>
                );
              })}
            </tbody>
          </Table>
        </Container>
      )}
    </Container>
  );
}

export default IngredientsPage;
