<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Curso ExtJs
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        Ext.onReady(function(){
            var fieldsCliente = [ 
                { header: 'Id', name: 'Id', mapping: 'Id' },
                { header: 'Nome', name: 'Nome', mapping: 'Nome' }
            ];

            var RecordCliente = Ext.data.Record.create(fieldsCliente);

            var proxyCliente = new Ext.data.HttpProxy({
                api:{
                    create : '/Cliente/Criar',
                    read   : '/Cliente/Listar',
                    update : '/Cliente/Atualizar',
                    destroy: '/Cliente/Excluir'
                }
            });

//            OBSERVAÇÃO
//            ----------
//            Utilizando o JsonReader não foi possível consumir
//            os dados enviados pelo servidor. Bug?
//            As configurações de leitura foram movidas para o
//            próprio store.

//            var jsonReader = new Ext.data.JsonReader({
//                root         : 'Cliente',
//                idProperty   : 'Id',
//                totalProperty: 'Total',
//                fields       : fieldsCliente
//            });
            
            var jsonWriter = new Ext.data.JsonWriter({
                encode: false,
                writeAllFields: true
            });

            var tamanhoPagina = 10;

            var gridStore = new Ext.data.JsonStore({
                proxy: proxyCliente,
                writer: jsonWriter,
                autoSave: true,
                pruneModifiedRecords: true,
                
                // Configurações do reader
                //------------------------
                restful: true,
                root: 'Dados',
                idProperty: 'Id',
                totalProperty: 'Total',
                successProperty: 'Sucesso',
                remoteSort: true,
                fields: fieldsCliente,
                //------------------------

                // Eventos
                //--------
                listeners: {
                    load: function () {
                        
                    },

                    save: function () {
                        // Se a quantidade de itens exibidos ultrapassar o tamanho da página,
                        // carregar a página seguinte
                        if (gridStore.data.length > tamanhoPagina) {
                            gridStore.reload({
                                params: {
                                    start: gridStore.lastOptions.params.start + tamanhoPagina,
                                    limit: tamanhoPagina
                                }
                            })
                        }
                        // Se não houver dados na página e a página não for a primeira,
                        // carregar a página anterior
                        else if (gridStore.data.length == 0 && gridStore.lastOptions.params.start > 0) {
                            gridStore.reload({
                                params: {
                                    start: gridStore.lastOptions.params.start - tamanhoPagina,
                                    limit: tamanhoPagina
                                }
                            });
                        }
                    },
                    exception: function (proxy, type, action, exception) {
                        // Se houver modificações no store, devem ser rejeitadas,
                        // pois não foram persistidas no servidor.
                        if (action == "create") {
                            gridStore.each(function (record) {
                                if (record.phantom)
                                    gridStore.remove(record);
                            });
                        } else if (action == "update") {
                            gridStore.rejectChanges();
                        }

                        Ext.Msg.show({
                            title: 'Erro',
                            msg: 'Não foi possível realizar a operação solicitada [' + exception + ']',
                            buttons: Ext.Msg.OK,
                            icon: Ext.MessageBox.ERROR
                        });
                    }
                }
            });

            var pagingBar = new Ext.PagingToolbar({
                store: gridStore,
                pageSize: tamanhoPagina,
                displayInfo: true
            });

            var gridClientes = new Ext.grid.GridPanel({
                title: 'Clientes',
                store: gridStore,
                loadMask: true,
                columns: fieldsCliente,
                width: 500,
                height: 330,
                autoSave: true,
                buttons: [
                    {
                        text: 'Remover',
                        handler: function() {
                            var deletar = gridStore.getAt(1);

                            gridStore.remove(deletar);
                        }
                    }
                ],

                bbar: pagingBar
            });

            gridClientes.render('conteudo');

            gridStore.load({
                params:{
                    start: 0,
                    limit: tamanhoPagina
                }
            });
        });
    </script>

    <div id='conteudo'>
        
    </div>
</asp:Content>
