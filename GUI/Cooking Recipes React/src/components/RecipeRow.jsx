import React from "react";
import Button from "react-bootstrap/Button";
function RecipeRow(props) {
  function handleDelete() {
    props.onDelete(props.id);
  }
  function handleEdit() {
    props.onEdit(props.id);
  }
  return (
    <tr>
      <td>{props.name}</td>
      <td>
          <Button onClick={handleDelete} variant="danger">
            Delete
          </Button>

        <Button onClick={handleEdit} variant="primary">
          Edit
        </Button>
      </td>
    </tr>
  );
}
export default RecipeRow;
