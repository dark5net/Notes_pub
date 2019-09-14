<%@ Page Language="C#" AutoEventWireup="true" CodeFile="post.aspx.cs" Inherits="test" %>
 
<!DOCTYPE html>
 
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <table runat="server" id="table1">
        <tr>
            <td>name:</td>
            <td>
                <asp:TextBox ID="tbName" runat="server"></asp:TextBox>
            </td>

            <td>result:</td>
            <td>
                <asp:TextBox ID="tbAge" runat="server"></asp:TextBox>
            </td>
        </tr>

        <tr>

            <td><asp:Button runat="server" ID="BtnSelect" text="select" OnClick="BtnSelect_Click"/></td>
        </tr>
    </table>
    </div>
    </form>
</body>
</html>
