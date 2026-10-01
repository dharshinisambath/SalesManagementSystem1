<%@ Page Title="Sales History" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SalesHistory.aspx.cs" Inherits="SalesManagementSystem1.SalesHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h3 class="page-title"><i class="bi bi-clock-history"></i> Sales History</h3>

    <asp:Label ID="lblMessage" runat="server" Visible="false"></asp:Label>

    <div class="card mb-4">
        <div class="card-header bg-white fw-semibold">
            <i class="bi bi-search"></i> Search Sales
        </div>
        <div class="card-body">
            <div class="row g-3 align-items-end">
                <div class="col-md-4">
                    <label class="form-label">Customer Name</label>
                    <asp:TextBox ID="txtCustomer" runat="server" CssClass="form-control" placeholder="Search by customer name"></asp:TextBox>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Sale Date</label>
                    <asp:TextBox ID="txtDate" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                </div>
                <div class="col-md-5 d-flex gap-2">
                    <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary"
                        OnClick="btnSearch_Click" CausesValidation="false" />
                    <asp:Button ID="btnShowAll" runat="server" Text="View All Sales" CssClass="btn btn-outline-secondary"
                        OnClick="btnShowAll_Click" CausesValidation="false" />
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-header bg-white d-flex justify-content-between align-items-center">
            <span class="fw-semibold"><i class="bi bi-list-ul"></i> Sales List</span>
            <asp:Label ID="lblSummary" runat="server" CssClass="badge bg-primary fs-6"></asp:Label>
        </div>
        <div class="card-body p-0 table-responsive">
            <asp:GridView ID="gvSales" runat="server" AutoGenerateColumns="False"
                CssClass="table table-hover align-middle mb-0" GridLines="None" UseAccessibleHeader="true"
                AllowPaging="True" PageSize="10" OnPageIndexChanging="gvSales_PageIndexChanging"
                EmptyDataText="No sales found.">
                <HeaderStyle CssClass="table-light" />
                <PagerStyle CssClass="p-2" HorizontalAlign="Center" />
                <Columns>
                    <asp:BoundField DataField="SaleID" HeaderText="Sale ID" />
                    <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                    <asp:BoundField DataField="ProductName" HeaderText="Product" />
                    <asp:BoundField DataField="Quantity" HeaderText="Qty" />
                    <asp:BoundField DataField="UnitPrice" HeaderText="Unit Price" DataFormatString="Rs. {0:N2}" HtmlEncode="false" />
                    <asp:BoundField DataField="TotalAmount" HeaderText="Total Amount" DataFormatString="Rs. {0:N2}" HtmlEncode="false" />
                    <asp:BoundField DataField="SaleDate" HeaderText="Sale Date" DataFormatString="{0:dd-MM-yyyy hh:mm tt}" HtmlEncode="false" />
                </Columns>
            </asp:GridView>
        </div>
    </div>

</asp:Content>