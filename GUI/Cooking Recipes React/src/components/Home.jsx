import React, {useState, useEffect} from "react";
import Container from "react-bootstrap/Container";
import { useHistory } from "react-router-dom";
import Recipe from "./Recipe";
import axios from 'axios';

function Home() {
  const [data, setData] = useState();
  const history = useHistory();
  useEffect(() => {
      const fetchData = async () => {
          const result = await axios(
              '/api',
          );
          setData(result.data);
      };
      fetchData();
  }, []);

  function deleteRecipe(id) {
    fetch("http://localhost:5000/api/" + id, {
      method: "DELETE",
    }).then(() => {
      window.location.reload();
    });
  }
  function editRecipe(id) {
    history.push("/upsert/" + id);
  }
  return (
    <Container>
      {data &&
       data.recipes.map((recipe) => {
          return (
            <Recipe
              name={recipe.name}
              id={recipe.id}
              onDelete={deleteRecipe}
              onEdit={editRecipe}
            />
          );
        })}
      
    </Container>
  );
}
export default Home;
