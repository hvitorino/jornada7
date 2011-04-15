<%@ Page Title="" Language="C#" MasterPageFile="~/Views/Shared/Site.Master" Inherits="System.Web.Mvc.ViewPage<dynamic>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
	Curso ExtJs
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript">
        Ext.onReady(function(){
            var txtNome = new Ext.form.TextField({
                xtype     : 'textfield',
                id        : 'Nome',
                fieldLabel: 'Nome',
                allowBlank: false
            });

            var txtIdade = new Ext.form.TextField({
                xtype     : 'textfield',
                id        : 'Idade',
                fieldLabel: 'Idade',
                allowBlank: false
            });
                    
            var txtEmail = new Ext.form.TextField({
                xtype     : 'textfield',
                id        : 'Email',
                fieldLabel: 'Email',
                allowBlank: false
            });

            var botaoSalvar = new Ext.Button({
                id      : 'botao-salvar',
                text    : 'Salvar',
                formBind: true
            });

            botaoSalvar.on('click', function() {
                var clienteNovo = {
                    Nome : Ext.getCmp('Nome').getValue(),
                    Idade: Ext.getCmp('Idade').getValue(),
                    Email: Ext.getCmp('Email').getValue()
                }

                Ext.Ajax.request({
                    url    : '/Cliente/Criar',
                    success: function(httpResponse) {
                        var resposta = Ext.decode(httpResponse.responseText);

                        if(resposta.Sucesso)
                            Ext.Msg.alert('Mensagem', 'Cliente salvo com sucesso');
                        else
                            Ext.Msg.alert('Erro', 'Falha no processamento da solicitação');
                    },
                    failure: function() {
                        Ext.Msg.alert('Erro', 'Falha ao salvar cliente');
                    },
                    jsonData: clienteNovo
                });
            });

            var formularioCliente = new Ext.FormPanel({
                id          : 'form-cliente',
                title       : 'Cliente',
                monitorValid: true,
                autoWidth   : 800,
                autoHeight  : 600,
                padding     : 10,
                items       : [txtNome, txtIdade, txtEmail],
                buttons     : [botaoSalvar]
            });

            formularioCliente.render('conteudo');
        });
        
    </script>

    <div id='conteudo'>
        
    </div>
</asp:Content>
