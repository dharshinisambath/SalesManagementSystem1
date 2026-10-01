using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace SalesManagementSystem1
{
    public partial class Customers : System.Web.UI.Page
    {
        // Web.config-la ulla database address
        string connStr = ConfigurationManager.ConnectionStrings["SalesDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCustomers("");
            }
        }

        // ---------- VIEW + SEARCH ----------
        private void LoadCustomers(string searchText)
        {
            string sql = "SELECT CustomerID, CustomerName, Phone, Email, Address " +
                         "FROM Customers " +
                         "WHERE CustomerName LIKE @Search OR Phone LIKE @Search OR Email LIKE @Search " +
                         "ORDER BY CustomerID DESC";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlDataAdapter da = new SqlDataAdapter(sql, con))
            {
                da.SelectCommand.Parameters.AddWithValue("@Search", "%" + searchText + "%");
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvCustomers.DataSource = dt;
                gvCustomers.DataBind();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            gvCustomers.PageIndex = 0;
            LoadCustomers(txtSearch.Text.Trim());
        }

        protected void btnShowAll_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            gvCustomers.PageIndex = 0;
            LoadCustomers("");
        }

        protected void gvCustomers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCustomers.PageIndex = e.NewPageIndex;
            LoadCustomers(txtSearch.Text.Trim());
        }

        // ---------- ADD ----------
        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string sql = "INSERT INTO Customers (CustomerName, Phone, Email, Address) " +
                         "VALUES (@Name, @Phone, @Email, @Address)";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
                cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());

                con.Open();
                cmd.ExecuteNonQuery();
            }

            ClearForm();
            LoadCustomers(txtSearch.Text.Trim());
            ShowMessage("Customer added successfully!", true);
        }

        // ---------- UPDATE ----------
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            string sql = "UPDATE Customers SET CustomerName = @Name, Phone = @Phone, " +
                         "Email = @Email, Address = @Address WHERE CustomerID = @ID";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
                cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
                cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());
                cmd.Parameters.AddWithValue("@ID", Convert.ToInt32(hfCustomerID.Value));

                con.Open();
                cmd.ExecuteNonQuery();
            }

            ClearForm();
            LoadCustomers(txtSearch.Text.Trim());
            ShowMessage("Customer updated successfully!", true);
        }

        // ---------- EDIT / DELETE (GridView buttons) ----------
        protected void gvCustomers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditRow")
            {
                LoadCustomerToForm(Convert.ToInt32(e.CommandArgument));
            }
            else if (e.CommandName == "DeleteRow")
            {
                DeleteCustomer(Convert.ToInt32(e.CommandArgument));
            }
        }

        // Edit click pannaa, data-va form-la kondu vandhu kaattum
        private void LoadCustomerToForm(int id)
        {
            string sql = "SELECT * FROM Customers WHERE CustomerID = @ID";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@ID", id);
                con.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        hfCustomerID.Value = dr["CustomerID"].ToString();
                        txtCustomerID.Text = dr["CustomerID"].ToString();
                        txtName.Text = dr["CustomerName"].ToString();
                        txtPhone.Text = dr["Phone"].ToString();
                        txtEmail.Text = dr["Email"].ToString();
                        txtAddress.Text = dr["Address"].ToString();
                    }
                }
            }

            // Add button-a maraichitu Update button-a kaattum
            btnAdd.Visible = false;
            btnUpdate.Visible = true;
            lblMessage.Visible = false;
        }

        private void DeleteCustomer(int id)
        {
            try
            {
                string sql = "DELETE FROM Customers WHERE CustomerID = @ID";

                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@ID", id);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                ClearForm();
                LoadCustomers(txtSearch.Text.Trim());
                ShowMessage("Customer deleted successfully!", true);
            }
            catch (SqlException ex)
            {
                // 547 = foreign key error (indha customer-ku sales irukku)
                if (ex.Number == 547)
                    ShowMessage("Cannot delete this customer because sales records exist for them.", false);
                else
                    ShowMessage("Database error: " + ex.Message, false);
            }
        }

        // ---------- CLEAR ----------
        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
            lblMessage.Visible = false;
        }

        private void ClearForm()
        {
            hfCustomerID.Value = "";
            txtCustomerID.Text = "";
            txtName.Text = "";
            txtPhone.Text = "";
            txtEmail.Text = "";
            txtAddress.Text = "";

            btnAdd.Visible = true;
            btnUpdate.Visible = false;
        }

        private void ShowMessage(string text, bool isSuccess)
        {
            lblMessage.Visible = true;
            lblMessage.Text = text;
            lblMessage.CssClass = isSuccess ? "alert alert-success d-block" : "alert alert-danger d-block";
        }
    }
}