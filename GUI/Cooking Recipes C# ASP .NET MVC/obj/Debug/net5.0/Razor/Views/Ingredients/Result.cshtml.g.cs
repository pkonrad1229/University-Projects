#pragma checksum "C:\Users\pkonr\OneDrive\Pulpit\EGUI\Lab2\Lab2\Views\Ingredients\Result.cshtml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "e2a6a722905ef350c972a467ab0b3b26fef5dff1"
// <auto-generated/>
#pragma warning disable 1591
[assembly: global::Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute(typeof(AspNetCore.Views_Ingredients_Result), @"mvc.1.0.view", @"/Views/Ingredients/Result.cshtml")]
namespace AspNetCore
{
    #line hidden
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Threading.Tasks;
    using Microsoft.AspNetCore.Mvc;
    using Microsoft.AspNetCore.Mvc.Rendering;
    using Microsoft.AspNetCore.Mvc.ViewFeatures;
#nullable restore
#line 1 "C:\Users\pkonr\OneDrive\Pulpit\EGUI\Lab2\Lab2\Views\_ViewImports.cshtml"
using Lab2;

#line default
#line hidden
#nullable disable
#nullable restore
#line 2 "C:\Users\pkonr\OneDrive\Pulpit\EGUI\Lab2\Lab2\Views\_ViewImports.cshtml"
using Lab2.Models;

#line default
#line hidden
#nullable disable
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"e2a6a722905ef350c972a467ab0b3b26fef5dff1", @"/Views/Ingredients/Result.cshtml")]
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"fd9d6898af3ee645766c02769f00bd7edd74cd52", @"/Views/_ViewImports.cshtml")]
    public class Views_Ingredients_Result : global::Microsoft.AspNetCore.Mvc.Razor.RazorPage<Lab2.Models.Ingredients>
    {
        #pragma warning disable 1998
        public async override global::System.Threading.Tasks.Task ExecuteAsync()
        {
            WriteLiteral("<div class=\"col-12 border p-3 mt-3\">\r\n");
#nullable restore
#line 3 "C:\Users\pkonr\OneDrive\Pulpit\EGUI\Lab2\Lab2\Views\Ingredients\Result.cshtml"
     if (Model.IngredientName.Count == 0)
    {

#line default
#line hidden
#nullable disable
            WriteLiteral("        <p>The list is empty</p>\r\n");
#nullable restore
#line 6 "C:\Users\pkonr\OneDrive\Pulpit\EGUI\Lab2\Lab2\Views\Ingredients\Result.cshtml"
    }
    else
    {

#line default
#line hidden
#nullable disable
            WriteLiteral(@"        <table class=""table table-striped border"">
            <tr>
                <th scope=""col"">
                    <label>Ingredient</label>
                </th>
                <th scope=""col"">
                    <label>Quantity</label>
                </th>
                <th scope=""col"">
                    <label>Unit</label>
                </th>
            </tr>

");
#nullable restore
#line 22 "C:\Users\pkonr\OneDrive\Pulpit\EGUI\Lab2\Lab2\Views\Ingredients\Result.cshtml"
             for (int i = 0; i < Model.IngredientName.Count; i++)
            {

#line default
#line hidden
#nullable disable
            WriteLiteral("                <tr>\r\n                    <td>\r\n                        ");
#nullable restore
#line 26 "C:\Users\pkonr\OneDrive\Pulpit\EGUI\Lab2\Lab2\Views\Ingredients\Result.cshtml"
                   Write(Model.IngredientName[i]);

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n                    </td>\r\n                    <td>\r\n                        ");
#nullable restore
#line 29 "C:\Users\pkonr\OneDrive\Pulpit\EGUI\Lab2\Lab2\Views\Ingredients\Result.cshtml"
                   Write(Model.IngredientQuantity[i]);

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n                    </td>\r\n                    <td>\r\n                        ");
#nullable restore
#line 32 "C:\Users\pkonr\OneDrive\Pulpit\EGUI\Lab2\Lab2\Views\Ingredients\Result.cshtml"
                   Write(Model.IngredientUnit[i]);

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n                    </td>\r\n\r\n                </tr>\r\n");
#nullable restore
#line 36 "C:\Users\pkonr\OneDrive\Pulpit\EGUI\Lab2\Lab2\Views\Ingredients\Result.cshtml"
            }

#line default
#line hidden
#nullable disable
            WriteLiteral("\r\n        </table>\r\n");
#nullable restore
#line 39 "C:\Users\pkonr\OneDrive\Pulpit\EGUI\Lab2\Lab2\Views\Ingredients\Result.cshtml"
    }

#line default
#line hidden
#nullable disable
            WriteLiteral("</div>");
        }
        #pragma warning restore 1998
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.ViewFeatures.IModelExpressionProvider ModelExpressionProvider { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IUrlHelper Url { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.IViewComponentHelper Component { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IJsonHelper Json { get; private set; }
        [global::Microsoft.AspNetCore.Mvc.Razor.Internal.RazorInjectAttribute]
        public global::Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<Lab2.Models.Ingredients> Html { get; private set; }
    }
}
#pragma warning restore 1591
