using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Lab2.Models;
using Microsoft.AspNetCore.Http;
using System.Globalization;

namespace Lab2.Controllers
{
    public class IngredientsController : Controller
    {
        public IActionResult Index()
        {
            RecipesList recipesList = new();
            recipesList.LoadFromJSON();
            return View(recipesList);
        }

        public IActionResult Result(IFormCollection collection)
        {
            RecipesList recipesList = new();
            recipesList.LoadFromJSON();
            Ingredients ingregients = new();
            foreach (var recipe in recipesList.List)
            {
                if (!string.IsNullOrEmpty(collection[recipe.Name]))
                {
                    float times = float.Parse(collection[recipe.Name], CultureInfo.InvariantCulture.NumberFormat);
                    if (times < 0)
                        return RedirectToAction("Index");
                    for (int i = 0; i < recipe.IngredientName.Count; i++)
                        ingregients.AddIngredient(recipe.IngredientName[i], recipe.IngredientQuantity[i], recipe.IngredientUnit[i], times);
                }
            }
            return View(ingregients);
        }
    }
}
