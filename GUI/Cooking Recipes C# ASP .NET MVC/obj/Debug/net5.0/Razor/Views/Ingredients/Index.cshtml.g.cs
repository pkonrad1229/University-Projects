#pragma checksum "C:\Users\pkonr\OneDrive\Pulpit\EGUI\Lab2\Lab2\Views\Ingredients\Index.cshtml" "{ff1816ec-aa5e-4d10-87f7-6f4963833460}" "8de3c52436ad9ef66d9ce006226dd99af7158f66"
// <auto-generated/>
#pragma warning disable 1591
[assembly: global::Microsoft.AspNetCore.Razor.Hosting.RazorCompiledItemAttribute(typeof(AspNetCore.Views_Ingredients_Index), @"mvc.1.0.view", @"/Views/Ingredients/Index.cshtml")]
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
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"8de3c52436ad9ef66d9ce006226dd99af7158f66", @"/Views/Ingredients/Index.cshtml")]
    [global::Microsoft.AspNetCore.Razor.Hosting.RazorSourceChecksumAttribute(@"SHA1", @"fd9d6898af3ee645766c02769f00bd7edd74cd52", @"/Views/_ViewImports.cshtml")]
    public class Views_Ingredients_Index : global::Microsoft.AspNetCore.Mvc.Razor.RazorPage<Lab2.Models.RecipesList>
    {
        private static readonly global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute __tagHelperAttribute_0 = new global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute("asp-action", "Result", global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.DoubleQuotes);
        private static readonly global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute __tagHelperAttribute_1 = new global::Microsoft.AspNetCore.Razor.TagHelpers.TagHelperAttribute("method", "post", global::Microsoft.AspNetCore.Razor.TagHelpers.HtmlAttributeValueStyle.DoubleQuotes);
        #line hidden
        #pragma warning disable 0649
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperExecutionContext __tagHelperExecutionContext;
        #pragma warning restore 0649
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperRunner __tagHelperRunner = new global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperRunner();
        #pragma warning disable 0169
        private string __tagHelperStringValueBuffer;
        #pragma warning restore 0169
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperScopeManager __backed__tagHelperScopeManager = null;
        private global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperScopeManager __tagHelperScopeManager
        {
            get
            {
                if (__backed__tagHelperScopeManager == null)
                {
                    __backed__tagHelperScopeManager = new global::Microsoft.AspNetCore.Razor.Runtime.TagHelpers.TagHelperScopeManager(StartTagHelperWritingScope, EndTagHelperWritingScope);
                }
                return __backed__tagHelperScopeManager;
            }
        }
        private global::Microsoft.AspNetCore.Mvc.TagHelpers.FormTagHelper __Microsoft_AspNetCore_Mvc_TagHelpers_FormTagHelper;
        private global::Microsoft.AspNetCore.Mvc.TagHelpers.RenderAtEndOfFormTagHelper __Microsoft_AspNetCore_Mvc_TagHelpers_RenderAtEndOfFormTagHelper;
        #pragma warning disable 1998
        public async override global::System.Threading.Tasks.Task ExecuteAsync()
        {
            WriteLiteral("\r\n<div class=\"container row p-0 m-0\">\r\n    <div class=\"col-9\">\r\n        <h2 class=\"text-secondary\">Count ingredients</h2>\r\n    </div>\r\n\r\n    <div class=\"col-12 border p-3 mt-3\">\r\n        ");
            __tagHelperExecutionContext = __tagHelperScopeManager.Begin("form", global::Microsoft.AspNetCore.Razor.TagHelpers.TagMode.StartTagAndEndTag, "8de3c52436ad9ef66d9ce006226dd99af7158f664027", async() => {
                WriteLiteral("\r\n");
#nullable restore
#line 10 "C:\Users\pkonr\OneDrive\Pulpit\EGUI\Lab2\Lab2\Views\Ingredients\Index.cshtml"
             if (Model.List.Count() > 0)
            {

#line default
#line hidden
#nullable disable
                WriteLiteral(@"                <table class=""table table-striped border"">
                    <tr class=""table-secondary"">
                        <th style=""width:  85%"">
                            <label>Recipe</label>
                        </th>

                        <th style=""width:  15%""></th>
                    </tr>
");
#nullable restore
#line 20 "C:\Users\pkonr\OneDrive\Pulpit\EGUI\Lab2\Lab2\Views\Ingredients\Index.cshtml"
                     foreach (var item in Model.List)
                    {

#line default
#line hidden
#nullable disable
                WriteLiteral("                <tr>\r\n                    <td>\r\n                        ");
#nullable restore
#line 24 "C:\Users\pkonr\OneDrive\Pulpit\EGUI\Lab2\Lab2\Views\Ingredients\Index.cshtml"
                   Write(item.Name);

#line default
#line hidden
#nullable disable
                WriteLiteral("\r\n                    </td>\r\n                    <td>\r\n                        <input");
                BeginWriteAttribute("name", " name=\"", 889, "\"", 906, 1);
#nullable restore
#line 27 "C:\Users\pkonr\OneDrive\Pulpit\EGUI\Lab2\Lab2\Views\Ingredients\Index.cshtml"
WriteAttributeValue("", 896, item.Name, 896, 10, false);

#line default
#line hidden
#nullable disable
                EndWriteAttribute();
                WriteLiteral(" class=\"form-control\" type=\"number\" />\r\n                    </td>\r\n                </tr>\r\n");
#nullable restore
#line 30 "C:\Users\pkonr\OneDrive\Pulpit\EGUI\Lab2\Lab2\Views\Ingredients\Index.cshtml"
                    }

#line default
#line hidden
#nullable disable
                WriteLiteral("                </table>\r\n                <input type=\"submit\" name=\"submitButton\" value=\"Count Ingredients\" class=\"btn btn-primary\" />\r\n");
#nullable restore
#line 33 "C:\Users\pkonr\OneDrive\Pulpit\EGUI\Lab2\Lab2\Views\Ingredients\Index.cshtml"
            }
            else
            {

#line default
#line hidden
#nullable disable
                WriteLiteral("                <p>No recipes available.</p>\r\n");
#nullable restore
#line 37 "C:\Users\pkonr\OneDrive\Pulpit\EGUI\Lab2\Lab2\Views\Ingredients\Index.cshtml"
            }

#line default
#line hidden
#nullable disable
                WriteLiteral("        ");
            }
            );
            __Microsoft_AspNetCore_Mvc_TagHelpers_FormTagHelper = CreateTagHelper<global::Microsoft.AspNetCore.Mvc.TagHelpers.FormTagHelper>();
            __tagHelperExecutionContext.Add(__Microsoft_AspNetCore_Mvc_TagHelpers_FormTagHelper);
            __Microsoft_AspNetCore_Mvc_TagHelpers_RenderAtEndOfFormTagHelper = CreateTagHelper<global::Microsoft.AspNetCore.Mvc.TagHelpers.RenderAtEndOfFormTagHelper>();
            __tagHelperExecutionContext.Add(__Microsoft_AspNetCore_Mvc_TagHelpers_RenderAtEndOfFormTagHelper);
            __Microsoft_AspNetCore_Mvc_TagHelpers_FormTagHelper.Action = (string)__tagHelperAttribute_0.Value;
            __tagHelperExecutionContext.AddTagHelperAttribute(__tagHelperAttribute_0);
            __Microsoft_AspNetCore_Mvc_TagHelpers_FormTagHelper.Method = (string)__tagHelperAttribute_1.Value;
            __tagHelperExecutionContext.AddTagHelperAttribute(__tagHelperAttribute_1);
            await __tagHelperRunner.RunAsync(__tagHelperExecutionContext);
            if (!__tagHelperExecutionContext.Output.IsContentModified)
            {
                await __tagHelperExecutionContext.SetOutputContentAsync();
            }
            Write(__tagHelperExecutionContext.Output);
            __tagHelperExecutionContext = __tagHelperScopeManager.End();
            WriteLiteral("\r\n    </div>\r\n\r\n\r\n</div>");
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
        public global::Microsoft.AspNetCore.Mvc.Rendering.IHtmlHelper<Lab2.Models.RecipesList> Html { get; private set; }
    }
}
#pragma warning restore 1591
