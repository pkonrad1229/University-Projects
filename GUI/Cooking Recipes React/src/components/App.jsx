import React from "react";
import "bootstrap/dist/css/bootstrap.min.css";
import NavBar from "./Navbar";
import Home from "./Home";
import Upsert from "./Upsert";
import IngredientsPage from "./IngredientsPage";
import "bootstrap/dist/js/bootstrap.bundle.min";
import { BrowserRouter as Router, Route, Switch } from "react-router-dom";

function App() {
  return (
    <Router>
      <div>
        <NavBar />
        <Switch>
          <Route exact path="/">
            <Home />
          </Route>
          <Route exact path="/upsert/:id">
            <Upsert />
          </Route>
          <Route exact path="/ingredients">
            <IngredientsPage />
          </Route>
        </Switch>
      </div>
    </Router>
  );
}

export default App;
