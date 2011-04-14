using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Curso.ExtJs.Models;

namespace Curso.ExtJs.Controllers
{
	public class ClienteController : Controller
	{
		private static List<Cliente> clientes = NovaListaClientes( 1000 );

		private static List<Cliente> NovaListaClientes( int tamanho )
		{
			var lista = new List<Cliente>();
			var idCorrente = 0;

			while ( lista.Count < tamanho )
			{
				idCorrente++;

				lista.Add( new Cliente
				{
					Id = idCorrente,
					Nome = "Cliente " + idCorrente
				} );
			}

			return lista;
		}

		public ViewResult Index()
		{
			return View();
		}

		public JsonResult Listar( int start, int limit )
		{
			var lista = clientes.Skip( start ).Take( limit );

			var resultado = new
			{
				Dados = lista,
				Total = clientes.Count,
				Sucesso = true
			};

			return Json( resultado, JsonRequestBehavior.AllowGet );
		}

		public JsonResult Criar( Cliente cliente )
		{
			cliente.Id = clientes.Last().Id + 1;

			clientes.Add( cliente );

			var resultado = new
			{
				Dados = new List<Cliente> { cliente },
				Total = 1,
				Sucesso = true
			};

			return Json( resultado, JsonRequestBehavior.AllowGet );
		}

		public JsonResult Atualizar( Cliente cliente )
		{
			var clienteAtualizado = clientes.Where( c => c.Id == cliente.Id ).SingleOrDefault();

			clienteAtualizado.Nome = cliente.Nome;

			var resultado = new
			{
				Dados = clienteAtualizado,
				Total = 1,
				Successo = true
			};

			return Json( resultado, JsonRequestBehavior.AllowGet );
		}

		public JsonResult Excluir( int id )
		{
			var clienteExcluido = clientes.Where( c => c.Id == id ).SingleOrDefault();

			clientes.Remove( clienteExcluido );

			var resultado = new
			{
				Dados = new List<Cliente>(),
				Total = 1,
				Successo = true
			};

			return Json( resultado, JsonRequestBehavior.AllowGet );
		}
	}
}
