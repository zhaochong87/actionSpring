<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<html>
<head>
    <title>景区网站管理员登录</title>
    <link rel="stylesheet" href="../ext-4.2/resources/ext-theme-classic/ext-theme-classic-all.css">
    <script type="text/javascript" src="../ext-4.2/bootstrap.js"></script>
    <script type="text/javascript" src="../ext-4.2/locale/ext-lang-zh_CN.js"></script>
</head>
<body>
    <script type="text/javascript">
        Ext.onReady(function () {
            var loginForm = Ext.create('widget.login');
        });

        // 点击登录时触发的事件
        onButtonClickSubmit = function(button, e, options) {
            console.log('login submit');
            var formPanel = button.up('form'),
                    login = button.up('login'),
                    user = formPanel.down('textfield[name=user]').getValue(),
                    pass = formPanel.down('textfield[name=password]').getValue();

            if(formPanel.getForm().isValid()){

                // 提交请求服务器前先对用户用户密码进行加密处理
                // pass = Packet.util.MD5.encode(pass);

                // 添加遮罩，防止服务器响应前，用户进行二次点击登录
                Ext.get(login.getEl()).mask('Authenticating... Please wait...', 'loading');

                // 发起请求
                Ext.Ajax.request({
                    url: '<%=basePath%>admin/loginCheck.html',
                    params: {
                        userName: user,
                        password: pass
                    },
                    success: function(conn, response, options){

                        // 返回响应后，解除遮罩
                        Ext.get(login.getEl()).unmask();

                        //var result = Ext.JSON.decode(conn.responseText);
                        var result = Ext.JSON.decode(conn.responseText, true);
                        if(!result){
                            result = {};
                            result.success = false;
                            result.msg = conn.responseText;
                        }
                        if(result.success){
                            login.close();
//                            Ext.create('Packet.view.Viewport');
                        }else{
                            Ext.Msg.show({
                                title: 'Fail!',
                                msg: result.msg,
                                icon: Ext.Msg.Error,
                                buttons: Ext.Msg.ok
                            });
                        }

                    },
                    failure: function(conn, response, options, eOpts){

                        // 返回响应后，解除遮罩
                        Ext.get(login.getEl()).unmask();

                        Ext.Msg.show({
                            title: 'Error!',
                            msg: conn.responseText,
                            icon: Ext.Msg.Error,
                            buttons: Ext.Msg.ok
                        })
                    }
                });
            }
        }

        /**
         * 定义LoginView组件
         */
        Ext.define('Packet.view.Login', {
            extend: 'Ext.window.Window',
            alias: 'widget.login',

            autoShow: true,
            height: 170,
            width: 360,
            layout: {
                type: 'fit'
            },
            iconCls: 'key',
            title: 'Login',
            closeAction: 'hide',
            closable: false,
            draggable: false,
            resizable: false,

            items: [
                {
                    xtype: 'form',
                    frame: false,
                    bodyPadding: 15,
                    defaults: {
                        xtype: 'textfield',
                        anchor: '100%',
                        labelWidth: 60,
                        allowBlank: false,
                        vtype: 'alphanum',  // 字母(alpha)和数字(num)
                        minLength: 3,
                        msgTarget: 'under'
                    },
                    items: [
                        {
                            name: 'user',
                            fieldLabel: 'User',
                            maxLength: 25
                        },
                        {
                            inputType: 'password',
                            name: 'password',
                            fieldLabel: 'Password',
                            enableKeyEvents: true,
                            id: 'password',
                            maxLength: 15/*,
                         vtype: customPass*/
                        }
                    ],
                    dockedItems: [
                        {
                            xtype: 'toolbar',
                            dock: 'bottom',
                            items: [
                                /*{
                                 xtype: 'translation'
                                 },*/
                                {
                                    xtype: 'tbfill'
                                },
                                {
                                    xtype: 'button',
                                    itemId: 'cancel',
                                    iconCls: 'cancel',
                                    text: 'Cancel'
                                    //text: translations.cancel
                                },
                                {
                                    xtype: 'button',
                                    itemId: 'submit',
                                    formBind: true,     // 把Submit按钮绑定到表单，只有表单的客户端验证通过时，才能启用提交按钮。
                                    iconCls: 'key-go',
                                    text: 'Submit',
                                    handler: onButtonClickSubmit
                                }
                            ]
                        }
                    ]
                }
            ]
        });

    </script>
</body>
</html>
