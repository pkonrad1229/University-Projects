import React, { useState } from "react";
import Button from "react-bootstrap/Button";

function AddIngredient(props){
    const [ingredient, setIngredient] = useState({
        ingredientName: "",
        ingredientQuantity: 0,
        ingredientUnit: ""
      });
      const isDisabled = ingredient.ingredientName === "" || 
                          ingredient.ingredientUnit === "" ||
                          ingredient.ingredientQuantity <= 0 || !isNaN(ingredient.ingredientName);
      function submitIngredient(event) {
          props.onAdd(ingredient);
          event.preventDefault();
      }
      function handleIngredientChange(event) {
        const { name, value } = event.target;
    
        setIngredient((prevIngredient) => {
          return {
            ...prevIngredient,
            [name]: value,
          };
        });
      }
    return (
        <tr>
                    <td>
                      <input
                        name="ingredientName"
                        type="text"
                        value={ingredient.name}
                        onChange={handleIngredientChange}
                      />
                    </td>
                    <td>
                      <input
                        name="ingredientQuantity"
                        type="number"
                        min="0"
                        step="0.001"
                        value={ingredient.quantity}
                        onChange={handleIngredientChange}
                      />
                    </td>
                    <td>
                      <input
                        name="ingredientUnit"
                        type="text"
                        value={ingredient.unit}
                        onChange={handleIngredientChange}
                      />
                    </td>
                    <td>
                      <Button
                        type="button"
                        onClick={submitIngredient}
                        variant="primary"
                        disabled={isDisabled}
                      >
                        Add Ingredient
                      </Button>
                    </td>
                  </tr>
    )
}
export default AddIngredient;