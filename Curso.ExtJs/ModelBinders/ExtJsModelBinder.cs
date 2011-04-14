using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.IO;
using System.Web.Script.Serialization;

namespace Curso.ExtJs.ModelBinders
{
	public class ExtJsModelBinder : DefaultModelBinder
	{
		private string root;

		public ExtJsModelBinder( string root )
		{
			this.root = "{\"" + root + "\":";
		}

		public string Root
		{
			get { return root; }
		}

		public override object BindModel( ControllerContext controllerContext, ModelBindingContext bindingContext )
		{
			if ( EhRequisicaoJson( controllerContext ) )
			{
				string jsonData = new StreamReader( controllerContext.RequestContext.HttpContext.Request.InputStream ).ReadToEnd();

				if ( jsonData.StartsWith( Root ) )
				{
					jsonData = jsonData.Replace( Root, "" );
					jsonData = jsonData.Substring( 0, jsonData.Length - 1 );
				}

				JavaScriptSerializer serializer = new JavaScriptSerializer();

				return serializer.Deserialize( jsonData, bindingContext.ModelMetadata.ModelType );
			}

			return base.BindModel( controllerContext, bindingContext );
		}

		private static bool EhRequisicaoJson( ControllerContext context )
		{
			return context.RequestContext.HttpContext.Request.ContentType.Contains( "application/json" );
		}
	}
}