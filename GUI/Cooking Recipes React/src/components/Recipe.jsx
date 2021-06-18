import React from "react";
import Button from "react-bootstrap/Button";
function Recipe(props) {
    function handleDelete() {
      props.onDelete(props.id);
    }
    function handleEdit() {
        props.onEdit(props.id);
      }
  
    return (
      <div className="recipe">
        <h1>{props.name}</h1>
        <Button onClick={handleDelete} variant="danger">
            Delete
          </Button>
          <Button onClick={handleEdit} variant="primary">
          Edit
        </Button>
      </div>
    );
  }
  
  export default Recipe;
  