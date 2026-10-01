<%@ Page Title="Customers" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Customers.aspx.cs" Inherits="SalesManagementSystem1.Customers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <h3 class="page-title"><i class="bi bi-people"></i> Customer Management</h3>

    <asp:Label ID="lblMessage" runat="server" Visible="false"></asp:Label>

    <div class="card mb-4">
        <div class="card-header bg-white fw-semibold">
            <i class="bi bi-person-plus"></i> Customer Details
        </div>
        <div class="card-body">
            <asp:HiddenField ID="hfCustomerID" runat="server" />

            <div class="row g-3">
                <div class="col-md-4">
                    <label class="form-label">Customer ID</label>
                    <asp:TextBox ID="txtCustomerID" runat="server" CssClass="form-control" ReadOnly="true" placeholder="Auto generated"></asp:TextBox>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Customer Name</label>
                    <asp:TextBox ID="txtName" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName"
                        ErrorMessage="Customer name is required." CssClass="text-danger small" Display="Dynamic" ValidationGroup="CustomerGroup"></asp:RequiredFieldValidator>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Phone</label>
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control" MaxLength="10" placeholder="10 digit mobile number"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhone"
                        ErrorMessage="Phone is required." CssClass="text-danger small" Display="Dynamic" ValidationGroup="CustomerGroup"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revPhone" runat="server" ControlToValidate="txtPhone"
                        ValidationExpression="^[6-9]\d{9}$"
                        ErrorMessage="Enter a valid 10-digit mobile number." CssClass="text-danger small" Display="Dynamic" ValidationGroup="CustomerGroup"></asp:RegularExpressionValidator>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" MaxLength="100"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail"
                        ErrorMessage="Email is required." CssClass="text-danger small" Display="Dynamic" ValidationGroup="CustomerGroup"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail"
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                        ErrorMessage="Enter a valid email address." CssClass="text-danger small" Display="Dynamic" ValidationGroup="CustomerGroup"></asp:RegularExpressionValidator>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Address</label>
                    <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2" MaxLength="250"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvAddress" runat="server" ControlToValidate="txtAddress"
                        ErrorMessage="Address is required." CssClass="text-danger small" Display="Dynamic" ValidationGroup="CustomerGroup"></asp:RequiredFieldValidator>
                </div>
            </div>

            <div class="mt-4 d-flex gap-2">
                <asp:Button ID="btnAdd" runat="server" Text="Add Customer" CssClass="btn btn-primary"
                    OnClick="btnAdd_Click" ValidationGroup="CustomerGroup" />
                <asp:Button ID="btnUpdate" runat="server" Text="Update Customer" CssClass="btn btn-success"
                    OnClick="btnUpdate_Click" ValidationGroup="CustomerGroup" Visible="false" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn btn-outline-secondary"
                    OnClick="btnClear_Click" CausesValidation="false" />
            </div>
        </div>
    </div>

    <div class="card">
        <div class="card-header bg-white">
            <div class="row g-2 align-items-center">
                <div class="col-md-5 fw-semibold"><i class="bi bi-list-ul"></i> Customer List</div>
                <div class="col-md-7">
                    <div class="input-group">
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="Search by name, phone or email"></asp:TextBox>
                        <asp:Button ID="btnSearch" runat="server" Text="Search" CssClass="btn btn-primary"
                            OnClick="btnSearch_Click" CausesValidation="false" />
                        <asp:Button ID="btnShowAll" runat="server" Text="Show All" CssClass="btn btn-outline-secondary"
                            OnClick="btnShowAll_Click" CausesValidation="false" />
                    </div>
                </div>
            </div>
        </div>
        <div class="card-body p-0 table-responsive">
            <asp:GridView ID="gvCustomers" runat="server" AutoGenerateColumns="False" DataKeyNames="CustomerID"
                CssClass="table table-hover align-middle mb-0" GridLines="None" UseAccessibleHeader="true"
                AllowPaging="True" PageSize="8" OnPageIndexChanging="gvCustomers_PageIndexChanging"
                OnRowCommand="gvCustomers_RowCommand" EmptyDataText="No customers found.">
                <HeaderStyle CssClass="table-light" />
                <PagerStyle CssClass="p-2" HorizontalAlign="Center" />
                <Columns>
                    <asp:BoundField DataField="CustomerID" HeaderText="ID" />
                    <asp:BoundField DataField="CustomerName" HeaderText="Name" />
                    <asp:BoundField DataField="Phone" HeaderText="Phone" />
                    <asp:BoundField DataField="Email" HeaderText="Email" />
                    <asp:BoundField DataField="Address" HeaderText="Address" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:LinkButton ID="lnkEdit" runat="server" CommandName="EditRow" CommandArgument='<%# Eval("CustomerID") %>'
                                CssClass="btn btn-sm btn-outline-primary" CausesValidation="false">
                                <i class="bi bi-pencil-square"></i> Edit
                            </asp:LinkButton>
                            <asp:LinkButton ID="lnkDelete" runat="server" CommandName="DeleteRow" CommandArgument='<%# Eval("CustomerID") %>'
                                CssClass="btn btn-sm btn-outline-danger" CausesValidation="false"
                                OnClientClick="return confirm('Are you sure you want to delete this customer?');">
                                <i class="bi bi-trash"></i> Delete
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>

</asp:Content>