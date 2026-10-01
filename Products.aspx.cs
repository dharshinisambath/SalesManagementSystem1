using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace SalesManagementSystem1
{
    public partial class Products : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["SalesDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadProducts("");
            }
        }

        private void LoadProducts(string searchText)
        {
            string sql = "SELECT ProductID, ProductName, Category, Price, Stock, Supplier, Status " +
                         "FROM Products " +
                         "WHERE ProductName LIKE @Search OR Category LIKE @Search OR Supplier LIKE @Search " +
                         "ORDER BY ProductID DESC";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlDataAdapter da = new SqlDataAdapter(sql, con))
            {
                da.SelectCommand.Parameters.AddWithValue("@Search", "%" + searchText + "%");
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvProducts.DataSource = dt;
                gvProducts.DataBind();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            gvProducts.PageIndex = 0;
            LoadProducts(txtSearch.Text.Trim());
        }

        protected void btnShowAll_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            gvProducts.PageIndex = 0;
            LoadProducts("");
        }

        protected void gvProducts_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvProducts.PageIndex = e.NewPageIndex;
            LoadProducts(txtSearch.Text.Trim());
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            decimal price;
            int stock;
            if (!ReadPriceAndStock(out price, out stock)) return;

            string sql = "INSERT INTO Products (ProductName, Category, Price, Stock, Supplier, Status) " +
                         "VALUES (@Name, @Category, @Price, @Stock, @Supplier, @Status)";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
                cmd.Parameters.AddWithValue("@Category", ddlCategory.SelectedValue);
                cmd.Parameters.AddWithValue("@Price", price);
                cmd.Parameters.AddWithValue("@Stock", stock);
                cmd.Parameters.AddWithValue("@Supplier", txtSupplier.Text.Trim());
                cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);

                con.Open();
                cmd.ExecuteNonQuery();
            }

            ClearForm();
            LoadProducts(txtSearch.Text.Trim());
            ShowMessage("Product added successfully!", true);
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            decimal price;
            int stock;
            if (!ReadPriceAndStock(out price, out stock)) return;

            string sql = "UPDATE Products SET ProductName = @Name, Category = @Category, Price = @Price, " +
                         "Stock = @Stock, Supplier = @Supplier, Status = @Status WHERE ProductID = @ID";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@Name", txtName.Text.Trim());
                cmd.Parameters.AddWithValue("@Category", ddlCategory.SelectedValue);
                cmd.Parameters.AddWithValue("@Price", price);
                cmd.Parameters.AddWithValue("@Stock", stock);
                cmd.Parameters.AddWithValue("@Supplier", txtSupplier.Text.Trim());
                cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);
                cmd.Parameters.AddWithValue("@ID", Convert.ToInt32(hfProductID.Value));

                con.Open();
                cmd.ExecuteNonQuery();
            }

            ClearForm();
            LoadProducts(txtSearch.Text.Trim());
            ShowMessage("Product updated successfully!", true);
        }

        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "EditRow")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                LoadProductToForm(id);
            }
            else if (e.CommandName == "DeleteRow")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                DeleteProduct(id);
            }
        }

        private void LoadProductToForm(int id)
        {
            string sql = "SELECT * FROM Products WHERE ProductID = @ID";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@ID", id);
                con.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        hfProductID.Value = dr["ProductID"].ToString();
                        txtProductID.Text = dr["ProductID"].ToString();
                        txtName.Text = dr["ProductName"].ToString();
                        txtPrice.Text = Convert.ToDecimal(dr["Price"]).ToString("0.00");
                        txtStock.Text = dr["Stock"].ToString();
                        txtSupplier.Text = dr["Supplier"].ToString();

                        string category = dr["Category"].ToString();
                        if (ddlCategory.Items.FindByValue(category) == null)
                            ddlCategory.Items.Add(category);
                        ddlCategory.SelectedValue = category;

                        ddlStatus.SelectedValue = dr["Status"].ToString();
                    }
                }
            }

            btnAdd.Visible = false;
            btnUpdate.Visible = true;
            lblMessage.Visible = false;
        }

        private void DeleteProduct(int id)
        {
            try
            {
                string sql = "DELETE FROM Products WHERE ProductID = @ID";

                using (SqlConnection con = new SqlConnection(connStr))
                using (SqlCommand cmd = new SqlCommand(sql, con))
                {
                    cmd.Parameters.AddWithValue("@ID", id);
                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                ClearForm();
                LoadProducts(txtSearch.Text.Trim());
                ShowMessage("Product deleted successfully!", true);
            }
            catch (SqlException ex)
            {
                if (ex.Number == 547)
                    ShowMessage("Cannot delete this product because it has sales records. Set its Status to Inactive instead.", false);
                else
                    ShowMessage("Database error: " + ex.Message, false);
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
            lblMessage.Visible = false;
        }

        private void ClearForm()
        {
            hfProductID.Value = "";
            txtProductID.Text = "";
            txtName.Text = "";
            ddlCategory.SelectedIndex = 0;
            txtPrice.Text = "";
            txtStock.Text = "";
            txtSupplier.Text = "";
            ddlStatus.SelectedIndex = 0;

            btnAdd.Visible = true;
            btnUpdate.Visible = false;
        }

        private bool ReadPriceAndStock(out decimal price, out int stock)
        {
            stock = 0;

            if (!decimal.TryParse(txtPrice.Text.Trim(), out price) || price <= 0)
            {
                ShowMessage("Price must be a number greater than 0.", false);
                return false;
            }
            if (!int.TryParse(txtStock.Text.Trim(), out stock) || stock < 0)
            {
                ShowMessage("Stock must be a whole number (0 or more).", false);
                return false;
            }
            return true;
        }

        private void ShowMessage(string text, bool isSuccess)
        {
            lblMessage.Visible = true;
            lblMessage.Text = text;
            lblMessage.CssClass = isSuccess ? "alert alert-success d-block" : "alert alert-danger d-block";
        }
    }
}