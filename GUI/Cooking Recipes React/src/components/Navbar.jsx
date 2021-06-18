import React from "react";
import "bootstrap/dist/css/bootstrap.min.css";
import Navbar from "react-bootstrap/Navbar";
import Nav from "react-bootstrap/Nav";
import { Link } from "react-router-dom";

function NavBar() {
  return ( 
    <header>
      <Navbar border="bottom">
        <Navbar.Brand>Recipes</Navbar.Brand>
        <Navbar.Toggle />
        <Navbar.Collapse id="basic-navbar-nav">
          <Nav className="mr-auto">
          <Nav.Link as={Link} to="/">Home</Nav.Link>
          <Nav.Link as={Link} to="/upsert/new">New Recipe</Nav.Link>
          <Nav.Link as={Link} to="/ingredients">Ingredients</Nav.Link>            
          </Nav>
        </Navbar.Collapse>
      </Navbar>
        </header> 
  );
}
export default NavBar;
