<%@ Page Title="Sales" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Sales.aspx.cs" Inherits="SalesManagementSystem1.Sales" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h3 class="page-title"><i class="bi bi-cart-check"></i> New Sale</h3>

    <asp:Label ID="lblMessage" runat="server" Visible="false"></asp:Label>

    <div class="card">
        <div class="card-header bg-white fw-semibold">
            <i class="bi bi-receipt"></i> Sale Details
        </div>
        <div class="card-body">
            <div class="row g-3">

                <div class="col-md-6">
                    <label class="form-label">Sale ID</label>
                    <asp:TextBox ID="txtSaleID" runat="server" CssClass="form-control" ReadOnly="true" placeholder="Auto generated"></asp:TextBox>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Sale Date</label>
                    <asp:TextBox ID="txtSaleDate" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Customer</label>
                    <asp:DropDownList ID="ddlCustomer" runat="server" CssClass="form-select"></asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvCustomer" runat="server" ControlToValidate="ddlCustomer" InitialValue=""
                        ErrorMessage="Please select a customer." CssClass="text-danger small" Display="Dynamic" ValidationGroup="SaleGroup"></asp:RequiredFieldValidator>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Product</label>
                    <asp:DropDownList ID="ddlProduct" runat="server" CssClass="form-select"
                        AutoPostBack="true" OnSelectedIndexChanged="ddlProduct_SelectedIndexChanged" CausesValidation="false"></asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvProduct" runat="server" ControlToValidate="ddlProduct" InitialValue=""
                        ErrorMessage="Please select a product." CssClass="text-danger small" Display="Dynamic" ValidationGroup="SaleGroup"></asp:RequiredFieldValidator>
                    <asp:Label ID="lblStock" runat="server" CssClass="text-muted small d-block"></asp:Label>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Quantity</label>
                    <asp:TextBox ID="txtQuantity" runat="server" CssClass="form-control"
                        AutoPostBack="true" OnTextChanged="txtQuantity_TextChanged" CausesValidation="false"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvQuantity" runat="server" ControlToValidate="txtQuantity"
                        ErrorMessage="Quantity is required." CssClass="text-danger small" Display="Dynamic" ValidationGroup="SaleGroup"></asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="cvQuantity" runat="server" ControlToValidate="txtQuantity" Operator="GreaterThan" ValueToCompare="0" Type="Integer"
                        ErrorMessage="Quantity must be a whole number greater than 0." CssClass="text-danger small" Display="Dynamic" ValidationGroup="SaleGroup"></asp:CompareValidator>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Unit Price (Rs.)</label>
                    <asp:TextBox ID="txtUnitPrice" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Total Amount (Rs.)</label>
                    <asp:TextBox ID="txtTotal" runat="server" CssClass="form-control fw-bold" ReadOnly="true"></asp:TextBox>
                </div>
            </div>

            <div class="mt-4 d-flex gap-2">
                <asp:Button ID="btnSave" runat="server" Text="Save Sale" CssClass="btn btn-primary"
                    OnClick="btnSave_Click" ValidationGroup="SaleGroup" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-outline-secondary"
                    OnClick="btnClear_Click" CausesValidation="false" />
            </div>
        </div>
    </div>

</asp:Content>
