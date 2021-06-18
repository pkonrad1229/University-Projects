using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Text.Json;
using Lab2.Models;
using System.IO;
using Newtonsoft.Json;
using System.Linq;

namespace Lab2.Models
{
    public class Recipe
    {
        
        public string Name { get; set; }
        public List<string> Instructions { get; set; }
        public List<string> IngredientName { get; set; }
        public List<float> IngredientQuantity { get; set; }
        public List<string> IngredientUnit { get; set; }
        public int IdNumber { get; set; }

        public Recipe()
        {
            this.IdNumber = -1;
            this.Instructions = new List<string>();
            this.IngredientName = new List<string>();
            this.IngredientQuantity = new List<float>();
            this.IngredientUnit = new List<string>();
        }
        public void AddIngredient(string name, float quantity, string unit)
        {
            this.IngredientName.Add(name);
            this.IngredientQuantity.Add(quantity);
            this.IngredientUnit.Add(unit);
        }
    }
    public class RecipeJSON
    {
        public string name { get; set; }
        public List<string> recipe { get; set; }
        public List<string> ingredients { get; set; }
    }
    public class RecipesList
    {
        public List<Recipe> List { get; set; }
        
        public RecipesList()
        {
            this.List = new List<Recipe>();
        }
        public void AddRecipe(string name, List<string> instructions, List<string> ingredientName, List<float> ingredientQuantity, List<string> ingredientUnit)
        {
            var recipe = new Recipe {
                Name = name,
                Instructions = instructions,
                IngredientName = ingredientName,
                IngredientQuantity = ingredientQuantity,
                IngredientUnit = ingredientUnit,
                IdNumber = this.List.Count
            };
            this.List.Add(recipe);
        }
        public void AddRecipe(Recipe recipe)
        {
            recipe.IdNumber = this.List.Count;
            this.List.Add(recipe);
        }

        public void RemoveRecipe(int index)
        {
            this.List.RemoveAt(index);
            for (int i=index; i<this.List.Count; i++)
            {
                this.List[i].IdNumber -= 1;
            }
        }

        public void SaveAsJSON()
        {
            List<RecipeJSON> recipesJSON = new();
            foreach (Recipe recipe in this.List)
            {
                List<string> ingredients = new();
                for(int i=0; i<recipe.IngredientName.Count; i++)
                {
                    ingredients.Add(recipe.IngredientName[i] + " " + recipe.IngredientQuantity[i].ToString() + " " + recipe.IngredientUnit[i]);
                }
                var recipeJSON = new RecipeJSON
                {
                    name = recipe.Name,
                    recipe = recipe.Instructions,
                    ingredients = ingredients
                };
                recipesJSON.Add(recipeJSON);
            }
            string data = JsonConvert.SerializeObject(recipesJSON);

            var path = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "data", "recipes.json");
            using var streamWriter = File.CreateText(path);
            streamWriter.Write(data);
        }

        public void LoadFromJSON()
        {
            var path = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "data", "recipes.json");
            string jsonResult;
            using (StreamReader streamReader = new StreamReader(path))
                jsonResult = streamReader.ReadToEnd();
            List<RecipeJSON> recipesJSON = JsonConvert.DeserializeObject<List<RecipeJSON>>(jsonResult);
            this.List.Clear();
            foreach (var recipeJSON in recipesJSON)
            {
                List<string> ingredientName = new();
                List<float> ingredientQuantity = new();
                List<string> ingredientUnit = new();
                bool foundQuantity = false;
                float result = 0;
                for (int i=0; i < recipeJSON.ingredients.Count; i++)
                {
                    foundQuantity = false;
                    List<string> ingredient = recipeJSON.ingredients[i].ToString().Split(" ").ToList();
                    foreach(var element in ingredient)
                    {
                        if (float.TryParse(element, out result))
                        {
                            ingredientQuantity.Add(result);
                            foundQuantity = true;
                        } else if (foundQuantity)
                        {
                            if (ingredientUnit.Count == i)
                            {
                                ingredientUnit.Add(element);
                            } else
                            {
                                ingredientUnit[i] += " " + element;
                            }
                        } else
                        {
                            if (ingredientName.Count == i)
                            {
                                ingredientName.Add(element);
                            }
                            else
                            {
                                ingredientName[i] += " " + element;
                            }
                        }
                    }
                }

                this.AddRecipe(recipeJSON.name, recipeJSON.recipe, ingredientName, ingredientQuantity, ingredientUnit);
            }
        }

    }


}