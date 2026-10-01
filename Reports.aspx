<%@ Page Title="Reports" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Reports.aspx.cs" Inherits="SalesManagementSystem1.Reports" %>
<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h3 class="page-title"><i class="bi bi-bar-chart-line"></i> Reports</h3>

    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card stat-card border-start border-4 border-warning">
                <div class="card-body">
                    <div class="text-muted small">Total Sales</div>
                    <h3 class="mb-0"><asp:Label ID="lblTotalSales" runat="server" Text="0"></asp:Label></h3>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card border-start border-4 border-danger">
                <div class="card-body">
                    <div class="text-muted small">Total Revenue</div>
                    <h3 class="mb-0"><asp:Label ID="lblRevenue" runat="server" Text="Rs. 0.00"></asp:Label></h3>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card border-start border-4 border-success">
                <div class="card-body">
                    <div class="text-muted small">Number of Products Sold</div>
                    <h3 class="mb-0"><asp:Label ID="lblProductsSold" runat="server" Text="0"></asp:Label></h3>
                </div>
            </div>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header bg-white fw-semibold">
            <i class="bi bi-graph-up"></i> Revenue by Product
        </div>
        <div class="card-body text-center" style="overflow-x: auto;">
            <asp:Chart ID="chartRevenue" runat="server" Width="800px" Height="320px" BorderlineColor="LightGray">
                <Series>
                    <asp:Series Name="Revenue" ChartType="Column" Color="#2A5298" IsValueShownAsLabel="true"></asp:Series>
                </Series>
                <ChartAreas>
                    <asp:ChartArea Name="MainArea">
                        <AxisX Title="Product" Interval="1"></AxisX>
                        <AxisY Title="Revenue (Rs.)"></AxisY>
                    </asp:ChartArea>
                </ChartAreas>
            </asp:Chart>
        </div>
    </div>

    <div class="row g-3 mb-4">
        <div class="col-lg-6">
            <div class="card h-100">
                <div class="card-header bg-white fw-semibold">
                    <i class="bi bi-trophy"></i> Top-Selling Products
                </div>
                <div class="card-body p-0 table-responsive">
                    <asp:GridView ID="gvTopProducts" runat="server" AutoGenerateColumns="False"
                        CssClass="table table-hover mb-0" GridLines="None" UseAccessibleHeader="true"
                        EmptyDataText="No sales yet.">
                        <HeaderStyle CssClass="table-light" />
                        <Columns>
                            <asp:BoundField DataField="ProductName" HeaderText="Product" />
                            <asp:BoundField DataField="Category" HeaderText="Category" />
                            <asp:BoundField DataField="QtySold" HeaderText="Qty Sold" />
                            <asp:BoundField DataField="Revenue" HeaderText="Revenue" DataFormatString="Rs. {0:N2}" HtmlEncode="false" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="card h-100">
                <div class="card-header bg-white fw-semibold">
                    <i class="bi bi-calendar-week"></i> Daily Sales Report
                </div>
                <div class="card-body p-0 table-responsive">
                    <asp:GridView ID="gvDaily" runat="server" AutoGenerateColumns="False"
                        CssClass="table table-hover mb-0" GridLines="None" UseAccessibleHeader="true"
                        EmptyDataText="No sales yet.">
                        <HeaderStyle CssClass="table-light" />
                        <Columns>
                            <asp:BoundField DataField="SaleDay" HeaderText="Date" DataFormatString="{0:dd-MM-yyyy}" HtmlEncode="false" />
                            <asp:BoundField DataField="TotalSales" HeaderText="Sales" />
                            <asp:BoundField DataField="ItemsSold" HeaderText="Items Sold" />
                            <asp:BoundField DataField="Revenue" HeaderText="Revenue" DataFormatString="Rs. {0:N2}" HtmlEncode="false" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-header bg-white fw-semibold">
            <i class="bi bi-clock-history"></i> Recent Sales
        </div>
        <div class="card-body p-0 table-responsive">
            <asp:GridView ID="gvRecent" runat="server" AutoGenerateColumns="False"
                CssClass="table table-hover mb-0" GridLines="None" UseAccessibleHeader="true"
                EmptyDataText="No sales yet.">
                <HeaderStyle CssClass="table-light" />
                <Columns>
                    <asp:BoundField DataField="SaleID" HeaderText="Sale ID" />
                    <asp:BoundField DataField="CustomerName" HeaderText="Customer" />
                    <asp:BoundField DataField="ProductName" HeaderText="Product" />
                    <asp:BoundField DataField="Quantity" HeaderText="Qty" />
                    <asp:BoundField DataField="TotalAmount" HeaderText="Total" DataFormatString="Rs. {0:N2}" HtmlEncode="false" />
                    <asp:BoundField DataField="SaleDate" HeaderText="Date" DataFormatString="{0:dd-MM-yyyy hh:mm tt}" HtmlEncode="false" />
                </Columns>
            </asp:GridView>
        </div>
    </div>

</asp:Content>