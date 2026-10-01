<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="SalesManagementSystem1.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h3 class="page-title"><i class="bi bi-speedometer2"></i> Dashboard</h3>

    <div class="row g-3 mb-4">
        <div class="col-md-6 col-lg-3">
            <div class="card stat-card border-start border-4 border-primary">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <div class="text-muted small">Total Products</div>
                        <h3 class="mb-0"><asp:Label ID="lblProducts" runat="server" Text="0"></asp:Label></h3>
                    </div>
                    <i class="bi bi-box-seam fs-1 text-primary"></i>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="card stat-card border-start border-4 border-success">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <div class="text-muted small">Total Customers</div>
                        <h3 class="mb-0"><asp:Label ID="lblCustomers" runat="server" Text="0"></asp:Label></h3>
                    </div>
                    <i class="bi bi-people fs-1 text-success"></i>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="card stat-card border-start border-4 border-warning">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <div class="text-muted small">Total Sales</div>
                        <h3 class="mb-0"><asp:Label ID="lblSales" runat="server" Text="0"></asp:Label></h3>
                    </div>
                    <i class="bi bi-cart-check fs-1 text-warning"></i>
                </div>
            </div>
        </div>

        <div class="col-md-6 col-lg-3">
            <div class="card stat-card border-start border-4 border-danger">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <div>
                        <div class="text-muted small">Total Revenue</div>
                        <h4 class="mb-0"><asp:Label ID="lblRevenue" runat="server" Text="Rs. 0.00"></asp:Label></h4>
                    </div>
                    <i class="bi bi-currency-rupee fs-1 text-danger"></i>
                </div>
            </div>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header bg-white fw-semibold">
            <i class="bi bi-graph-up"></i> Sales Summary
        </div>
        <div class="card-body">
            <div class="row text-center">
                <div class="col-md-4 mb-2 mb-md-0">
                    <div class="text-muted small">Today's Sales</div>
                    <h4><asp:Label ID="lblTodaySales" runat="server" Text="0"></asp:Label></h4>
                </div>
                <div class="col-md-4 mb-2 mb-md-0">
                    <div class="text-muted small">Today's Revenue</div>
                    <h4><asp:Label ID="lblTodayRevenue" runat="server" Text="Rs. 0.00"></asp:Label></h4>
                </div>
                <div class="col-md-4">
                    <div class="text-muted small">This Month's Revenue</div>
                    <h4><asp:Label ID="lblMonthRevenue" runat="server" Text="Rs. 0.00"></asp:Label></h4>
                </div>
            </div>
        </div>
    </div>

    <div class="row g-3">
        <div class="col-lg-7">
            <div class="card">
                <div class="card-header bg-white fw-semibold">
                    <i class="bi bi-clock-history"></i> Recent Sales
                </div>
                <div class="card-body p-0">
                    <asp:GridView ID="gvRecentSales" runat="server" AutoGenerateColumns="False"
                        CssClass="table table-hover mb-0" GridLines="None" UseAccessibleHeader="true"
                        EmptyDataText="No sales yet.">
                        <HeaderStyle CssClass="table-light" />
                        <Columns>
                            <asp:BoundField DataField="SaleID" HeaderText="ID" />
                            <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                            <asp:BoundField DataField="ProductName" HeaderText="Product" />
                            <asp:BoundField DataField="Quantity" HeaderText="Qty" />
                            <asp:BoundField DataField="TotalAmount" HeaderText="Total" DataFormatString="Rs. {0:N2}" HtmlEncode="false" />
                            <asp:BoundField DataField="SaleDate" HeaderText="Date" DataFormatString="{0:dd-MM-yyyy}" HtmlEncode="false" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <div class="col-lg-5">
            <div class="card">
                <div class="card-header bg-white fw-semibold text-danger">
                    <i class="bi bi-exclamation-triangle"></i> Low Stock Products
                </div>
                <div class="card-body p-0">
                    <asp:GridView ID="gvLowStock" runat="server" AutoGenerateColumns="False"
                        CssClass="table table-hover mb-0" GridLines="None" UseAccessibleHeader="true"
                        EmptyDataText="All products have enough stock.">
                        <HeaderStyle CssClass="table-light" />
                        <Columns>
                            <asp:BoundField DataField="ProductName" HeaderText="Product" />
                            <asp:BoundField DataField="Category" HeaderText="Category" />
                            <asp:TemplateField HeaderText="Stock">
                                <ItemTemplate>
                                    <span class="badge bg-danger"><%# Eval("Stock") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>

</asp:Content>