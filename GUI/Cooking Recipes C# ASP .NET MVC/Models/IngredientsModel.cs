using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace Lab2.Models
{
    public class Ingredients
    {
        public List<string> IngredientName { get; set; }
        public List<float> IngredientQuantity { get; set; }
        public List<string> IngredientUnit { get; set; }

        public Ingredients()
        {
            this.IngredientName = new();
            this.IngredientQuantity = new();
            this.IngredientUnit = new();
        }
        public void AddIngredient(string name, float quantity, string unit, float times)
        {
            bool wasAdded = false;
            for(int i=0; i<this.IngredientName.Count; i++)
            {
                if(this.IngredientName[i] == name && this.IngredientUnit[i] == unit)
                {
                    this.IngredientQuantity[i] += quantity * times;
                    wasAdded = true;
                    break;
                }
            }
            if (!wasAdded)
            {
                this.IngredientName.Add(name);
                this.IngredientQuantity.Add(quantity * times);
                this.IngredientUnit.Add(unit);
            }
        }
    }
}
