import React from "react";
import Button from "react-bootstrap/Button";
function IngredientRow(props) {
  function handleDelete() {
    props.onDelete(props.id);
  }
  
  return (
    <tr>
      <td>{props.name}</td>
      <td>{props.quantity}</td>
      <td>{props.unit}</td>
      
      <td>
          <Button onClick={handleDelete} variant="danger">
            Delete
          </Button>
      </td>
    </tr>
  );
}
export default IngredientRow;