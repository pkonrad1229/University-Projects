using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Lab2.Models;
using System.Text.Json;
using Newtonsoft.Json;
using System.Web;
using Microsoft.AspNetCore.Http;
using System.Globalization;
using JsonSerializer = System.Text.Json.JsonSerializer;

namespace Lab2.Controllers
{

    public class RecipesController : Controller
    {
        public RecipesList recipesList1 = new RecipesList();
        public RecipesController()
        {
        }
        public IActionResult Index()
        {
            HttpContext.Session.Remove("currentRecipe");
            RecipesList recipesList = new();
            recipesList.LoadFromJSON();
            HttpContext.Session.SetString("recipes", JsonSerializer.Serialize<RecipesList>(recipesList));
            return View(recipesList);
        }

        public IActionResult Upsert(int? itemid)
        {
            Recipe recipe;
            if (null != HttpContext.Session.GetString("currentRecipe"))
            {               
                recipe = JsonSerializer.Deserialize<Recipe>(HttpContext.Session.GetString("currentRecipe"));
                if ((itemid != recipe.IdNumber && itemid != null) || (itemid != null && recipe.IdNumber == -1))
                {
                    return RedirectToAction("Index");
                }
            }
            else if (itemid == null)
            {
                recipe = new Recipe();
                HttpContext.Session.SetString("currentRecipe", JsonSerializer.Serialize<Recipe>(recipe));
            }
            else
            {
                RecipesList recipesList = new();
                recipesList.LoadFromJSON();
                recipe = recipesList.List[(int)itemid];
                HttpContext.Session.SetString("currentRecipe", JsonSerializer.Serialize<Recipe>(recipe));
            }
            return View(recipe);
        }

        public IActionResult Remove(int itemid)
        {
            RecipesList recipesList = new();
            recipesList.LoadFromJSON();
            if (itemid >= 0 && itemid < recipesList.List.Count)
            {
                recipesList.RemoveRecipe(itemid);
                
                recipesList.SaveAsJSON();
            }
            return RedirectToAction("Index");

        }

        public IActionResult DeleteIngredient(int itemid)
        {
            if (null == HttpContext.Session.GetString("currentRecipe"))
            {
                return RedirectToAction("Index");
            }
            Recipe recipe = JsonSerializer.Deserialize<Recipe>(HttpContext.Session.GetString("currentRecipe"));
            if (recipe.IngredientName.Count <= itemid || itemid < 0)
            {
                if (recipe.IdNumber == -1)
                    return RedirectToAction("Upsert");
                return RedirectToAction("Upsert", new { itemid = recipe.IdNumber });
            }
            recipe.IngredientName.RemoveAt(itemid);
            recipe.IngredientQuantity.RemoveAt(itemid);
            recipe.IngredientUnit.RemoveAt(itemid);
            HttpContext.Session.SetString("currentRecipe", JsonSerializer.Serialize<Recipe>(recipe));
            if (recipe.IdNumber == -1)
                return RedirectToAction("Upsert");
            return RedirectToAction("Upsert", new { itemid = recipe.IdNumber });
        }


        public IActionResult Update(IFormCollection collection)
        {
            if (null == HttpContext.Session.GetString("currentRecipe"))
            {
                return RedirectToAction("Index");
            }
            Recipe recipe;
            switch (collection["submitButton"])
            {            
                case "Update Changes":
                    recipe = JsonSerializer.Deserialize<Recipe>(HttpContext.Session.GetString("currentRecipe"));
                    RecipesList recipesList = new();
                    recipesList.LoadFromJSON();

                    if (string.IsNullOrEmpty(recipe.Name) || recipe.Instructions.Count == 0 ||recipe.IngredientName.Count == 0 )
                    {
                        if (recipe.IdNumber == -1)
                            return RedirectToAction("Upsert");
                        return RedirectToAction("Upsert", new { itemid = recipe.IdNumber });
                    }
                    if (recipe.IdNumber == -1)
                        recipesList.AddRecipe(recipe);
                    else
                        recipesList.List[recipe.IdNumber] = recipe;
                    HttpContext.Session.Remove("currentRecipe");
                    recipesList.SaveAsJSON();
                    return RedirectToAction("Index");
                case "Add/Edit Ingredient":
                    recipe = JsonSerializer.Deserialize<Recipe>(HttpContext.Session.GetString("currentRecipe"));
                    if (string.IsNullOrEmpty(collection["NewIngredient"]) || string.IsNullOrEmpty(collection["NewQuantity"]) ||  string.IsNullOrEmpty(collection["NewUnit"]))
                    {
                        if (recipe.IdNumber == -1)
                            return RedirectToAction("Upsert");
                        return RedirectToAction("Upsert", new { itemid = recipe.IdNumber });
                    }
                    if (float.Parse(collection["NewQuantity"], CultureInfo.InvariantCulture.NumberFormat) <= 0)
                    {
                        if (recipe.IdNumber == -1)
                            return RedirectToAction("Upsert");
                        return RedirectToAction("Upsert", new { itemid = recipe.IdNumber });
                    }

                    recipe = JsonSerializer.Deserialize<Recipe>(HttpContext.Session.GetString("currentRecipe"));
                    if (recipe.IngredientName.Contains(collection["NewIngredient"]))
                    {
                        int index = recipe.IngredientName.IndexOf(collection["NewIngredient"]);
                        recipe.IngredientQuantity[index] = float.Parse(collection["NewQuantity"], CultureInfo.InvariantCulture.NumberFormat);
                        recipe.IngredientUnit[index] = collection["NewUnit"];
                    }
                    else
                        recipe.AddIngredient(collection["NewIngredient"], float.Parse(collection["NewQuantity"], CultureInfo.InvariantCulture.NumberFormat), collection["NewUnit"]);
                    HttpContext.Session.SetString("currentRecipe", JsonSerializer.Serialize<Recipe>(recipe));
                    if (recipe.IdNumber == -1)
                        return RedirectToAction("Upsert");
                    return RedirectToAction("Upsert", new { itemid = recipe.IdNumber });

                case "Save Name":
                    recipe = JsonSerializer.Deserialize<Recipe>(HttpContext.Session.GetString("currentRecipe"));
                    recipe.Name = collection["Name"];
                    HttpContext.Session.SetString("currentRecipe", JsonSerializer.Serialize<Recipe>(recipe));
                    if (recipe.IdNumber == -1)
                        return RedirectToAction("Upsert");
                    return RedirectToAction("Upsert", new { itemid = recipe.IdNumber });
                case "Save Instructions":
                    recipe = JsonSerializer.Deserialize<Recipe>(HttpContext.Session.GetString("currentRecipe"));
                    recipe.Instructions = collection["InstructionsString"].ToString().Split('\n').ToList();
                    HttpContext.Session.SetString("currentRecipe", JsonSerializer.Serialize<Recipe>(recipe));
                    if (recipe.IdNumber == -1)
                        return RedirectToAction("Upsert");
                    return RedirectToAction("Upsert", new { itemid = recipe.IdNumber });
                    
                default:
                    return RedirectToAction("Index");
            }
        }
    }
}