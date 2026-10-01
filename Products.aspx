<%@ Page Title="Products" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Products.aspx.cs" Inherits="SalesManagementSystem1.Products" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h3 class="page-title"><i class="bi bi-box-seam"></i> Product Management</h3>

    <asp:Label ID="lblMessage" runat="server" Visible="false"></asp:Label>

    <div class="card mb-4">
        <div class="card-header bg-white fw-semibold">
            <i class="bi bi-pencil-square"></i> Product Details
        </div>
        <div class="card-body">
            <asp:HiddenField ID="hfProductID" runat="server" />

            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">Product ID</label>
                    <asp:TextBox ID="txtProductID" runat="server" CssClass="form-control" ReadOnly="true" placeholder="Auto generated"></asp:TextBox>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Product Name</label>
                    <asp:TextBox ID="txtName" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
                        ErrorMessage="Product name is required." CssClass="text-danger small" Display="Dynamic" ValidationGroup="ProductGroup"></asp:RequiredFieldValidator>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Category</label>
                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select">
                        <asp:ListItem Text="-- Select Category --" Value=""></asp:ListItem>
                        <asp:ListItem Text="Electronics" Value="Electronics"></asp:ListItem>
                        <asp:ListItem Text="Accessories" Value="Accessories"></asp:ListItem>
                        <asp:ListItem Text="Stationery" Value="Stationery"></asp:ListItem>
                        <asp:ListItem Text="Grocery" Value="Grocery"></asp:ListItem>
                        <asp:ListItem Text="Other" Value="Other"></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvCategory" runat="server" ControlToValidate="ddlCategory" InitialValue=""
                        ErrorMessage="Please select a category." CssClass="text-danger small" Display="Dynamic" ValidationGroup="ProductGroup"></asp:RequiredFieldValidator>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Price (Rs.)</label>
                    <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPrice" runat="server" ControlToValidate="txtPrice"
                        ErrorMessage="Price is required." CssClass="text-danger small" Display="Dynamic" ValidationGroup="ProductGroup"></asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="cvPrice" runat="server" ControlToValidate="txtPrice" Operator="GreaterThan" ValueToCompare="0" Type="Double"
                        ErrorMessage="Enter a valid price greater than 0." CssClass="text-danger small" Display="Dynamic" ValidationGroup="ProductGroup"></asp:CompareValidator>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Stock (Quantity)</label>
                    <asp:TextBox ID="txtStock" runat="server" CssClass="form-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvStock" runat="server" ControlToValidate="txtStock"
                        ErrorMessage="Stock is required." CssClass="text-danger small" Display="Dynamic" ValidationGroup="ProductGroup"></asp:RequiredFieldValidator>
                    <asp:CompareValidator ID="cvStock" runat="server" ControlToValidate="txtStock" Operator="GreaterThanEqual" ValueToCompare="0" Type="Integer"
                        ErrorMessage="Stock must be a whole number (0 or more)." CssClass="text-danger small" Display="Dynamic" ValidationGroup="ProductGroup"></asp:CompareValidator>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Supplier</label>
                    <asp:TextBox ID="txtSupplier" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvSupplier" runat="server" ControlToValidate="txtSupplier"
                        ErrorMessage="Supplier is required." CssClass="text-danger small" Display="Dynamic" ValidationGroup="ProductGroup"></asp:RequiredFieldValidator>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Status</label>
                    <asp:DropDownList ID="ddlStatus" runat="server" CssClass="form-select">
                        <asp:ListItem Text="Active" Value="Active"></asp:ListItem>
                        <asp:ListItem Text="Inactive" Value="Inactive"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

            <div class="mt-4 d-flex gap-2">
                <asp:Button ID="btnAdd" runat="server" Text="Add Product" CssClass="btn btn-primary"
                    OnClick="btnAdd_Click" ValidationGroup="ProductGroup" />
                <asp:Button ID="btnUpdate" runat="server" Text="Update Product" CssClass="btn btn-success"
                    OnClick="btnUpdate_Click" ValidationGroup="ProductGroup" Visible="false" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-outline-secondary"
                    OnClick="btnClear_Click" CausesValidation="false" />
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-header bg-white">
            <div class="row g-2 align-items-center">
                <div class="col-md-5 fw-semibold"><i class="bi bi-list-ul"></i> Product List</div>
                <div class="col-md-7">
                    <div class="input-group">
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by name, category or supplier"></asp:TextBox>
                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary"
                            OnClick="btnSearch_Click" CausesValidation="false" />
                        <asp:Button ID="btnShowAll" runat="server" Text="Show All" CssClass="btn btn-outline-secondary"
                            OnClick="btnShowAll_Click" CausesValidation="false" />
                    </div>
                </div>
            </div>
        </div>
        <div class="card-body p-0 table-responsive">
            <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" DataKeyNames="ProductID"
                CssClass="table table-hover align-middle mb-0" GridLines="None" UseAccessibleHeader="true"
                AllowPaging="True" PageSize="8" OnPageIndexChanging="gvProducts_PageIndexChanging"
                OnRowCommand="gvProducts_RowCommand" EmptyDataText="No products found.">
                <HeaderStyle CssClass="table-light" />
                <PagerStyle CssClass="p-2" HorizontalAlign="Center" />
                <Columns>
                    <asp:BoundField DataField="ProductID" HeaderText="ID" />
                    <asp:BoundField DataField="ProductName" HeaderText="Product Name" />
                    <asp:BoundField DataField="Category" HeaderText="Category" />
                    <asp:BoundField DataField="Price" HeaderText="Price" DataFormatString="Rs. {0:N2}" HtmlEncode="false" />
                    <asp:BoundField DataField="Stock" HeaderText="Stock" />
                    <asp:BoundField DataField="Supplier" HeaderText="Supplier" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='badge <%# Eval("Status").ToString() == "Active" ? "bg-success" : "bg-secondary" %>'><%# Eval("Status") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkEdit" runat="server" CommandName="EditRow" CommandArgument='<%# Eval("ProductID") %>'
                                CssClass="btn btn-sm btn-outline-primary" CausesValidation="false">
                                <i class="bi bi-pencil-square"></i> Edit
                            </asp:LinkButton>
                            <asp:LinkButton ID="lnkDelete" runat="server" CommandName="DeleteRow" CommandArgument='<%# Eval("ProductID") %>'
                                CssClass="btn btn-sm btn-outline-danger" CausesValidation="false"
                                OnClientClick="return confirm('Are you sure you want to delete this product?');">
                                <i class="bi bi-trash"></i> Delete
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

</asp:Content>