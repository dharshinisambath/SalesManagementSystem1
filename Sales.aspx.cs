using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace SalesManagementSystem1
{
    public partial class Sales : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["SalesDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCustomers();
                LoadProducts();
                txtSaleDate.Text = DateTime.Now.ToString("dd-MM-yyyy");
            }
        }

        private void LoadCustomers()
        {
            string sql = "SELECT CustomerID, CustomerName FROM Customers ORDER BY CustomerName";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlDataAdapter da = new SqlDataAdapter(sql, con))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlCustomer.DataSource = dt;
                ddlCustomer.DataTextField = "CustomerName";
                ddlCustomer.DataValueField = "CustomerID";
                ddlCustomer.DataBind();
            }
            ddlCustomer.Items.Insert(0, new ListItem("-- Select Customer --", ""));
        }

        private void LoadProducts()
        {
            string sql = "SELECT ProductID, ProductName + ' (Stock: ' + CAST(Stock AS NVARCHAR(10)) + ')' AS DisplayName " +
                         "FROM Products WHERE Status = 'Active' AND Stock > 0 ORDER BY ProductName";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlDataAdapter da = new SqlDataAdapter(sql, con))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlProduct.DataSource = dt;
                ddlProduct.DataTextField = "DisplayName";
                ddlProduct.DataValueField = "ProductID";
                ddlProduct.DataBind();
            }
            ddlProduct.Items.Insert(0, new ListItem("-- Select Product --", ""));
        }

        private void GetProductInfo(int productId, out decimal price, out int stock)
        {
            price = 0;
            stock = 0;

            string sql = "SELECT Price, Stock FROM Products WHERE ProductID = @ID";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                cmd.Parameters.AddWithValue("@ID", productId);
                con.Open();

                using (SqlDataReader dr = cmd.ExecuteReader())
                {
                    if (dr.Read())
                    {
                        price = Convert.ToDecimal(dr["Price"]);
                        stock = Convert.ToInt32(dr["Stock"]);
                    }
                }
            }
        }

        protected void ddlProduct_SelectedIndexChanged(object sender, EventArgs e)
        {
            UpdatePriceAndTotal();
        }

        protected void txtQuantity_TextChanged(object sender, EventArgs e)
        {
            UpdatePriceAndTotal();
        }

        private void UpdatePriceAndTotal()
        {
            lblStock.Text = "";
            txtUnitPrice.Text = "";
            txtTotal.Text = "";

            if (ddlProduct.SelectedValue == "") return;

            decimal price;
            int stock;
            GetProductInfo(Convert.ToInt32(ddlProduct.SelectedValue), out price, out stock);

            txtUnitPrice.Text = price.ToString("0.00");
            lblStock.Text = "Available stock: " + stock;

            int qty;
            if (int.TryParse(txtQuantity.Text.Trim(), out qty) && qty > 0)
            {
                txtTotal.Text = (price * qty).ToString("0.00");
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;

            int customerId = Convert.ToInt32(ddlCustomer.SelectedValue);
            int productId = Convert.ToInt32(ddlProduct.SelectedValue);

            int qty;
            if (!int.TryParse(txtQuantity.Text.Trim(), out qty) || qty <= 0)
            {
                ShowMessage("Quantity must be a whole number greater than 0.", false);
                return;
            }

            decimal price;
            int stock;
            GetProductInfo(productId, out price, out stock);

            if (qty > stock)
            {
                ShowMessage("Not enough stock! Only " + stock + " item(s) available.", false);
                UpdatePriceAndTotal();
                return;
            }

            decimal total = price * qty;
            int saleId = 0;

            using (SqlConnection con = new SqlConnection(connStr))
            {
                con.Open();

                SqlTransaction tran = con.BeginTransaction();

                try
                {
                    string updateSql = "UPDATE Products SET Stock = Stock - @Qty " +
                                       "WHERE ProductID = @PID AND Stock >= @Qty";

                    SqlCommand updateCmd = new SqlCommand(updateSql, con, tran);
                    updateCmd.Parameters.AddWithValue("@Qty", qty);
                    updateCmd.Parameters.AddWithValue("@PID", productId);
                    int rowsUpdated = updateCmd.ExecuteNonQuery();

                    if (rowsUpdated == 0)
                    {
                        tran.Rollback();
                        ShowMessage("Not enough stock available. Please check the quantity.", false);
                        LoadProducts();
                        return;
                    }

                    string insertSql = "INSERT INTO Sales (CustomerID, ProductID, Quantity, UnitPrice, TotalAmount, SaleDate) " +
                                       "VALUES (@CID, @PID, @Qty, @Price, @Total, @Date); " +
                                       "SELECT SCOPE_IDENTITY();";

                    SqlCommand insertCmd = new SqlCommand(insertSql, con, tran);
                    insertCmd.Parameters.AddWithValue("@CID", customerId);
                    insertCmd.Parameters.AddWithValue("@PID", productId);
                    insertCmd.Parameters.AddWithValue("@Qty", qty);
                    insertCmd.Parameters.AddWithValue("@Price", price);
                    insertCmd.Parameters.AddWithValue("@Total", total);
                    insertCmd.Parameters.AddWithValue("@Date", DateTime.Now);

                    saleId = Convert.ToInt32(insertCmd.ExecuteScalar());

                    tran.Commit();
                }
                catch (Exception ex)
                {
                    tran.Rollback();
                    ShowMessage("Error while saving sale: " + ex.Message, false);
                    return;
                }
            }

            ClearForm();
            txtSaleID.Text = saleId.ToString();
            ShowMessage("Sale saved successfully! Sale ID: " + saleId + " | Total: Rs. " + total.ToString("N2") + " | Stock updated.", true);
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
            lblMessage.Visible = false;
        }

        private void ClearForm()
        {
            txtSaleID.Text = "";
            ddlCustomer.SelectedIndex = 0;
            LoadProducts();                 
            txtQuantity.Text = "";
            txtUnitPrice.Text = "";
            txtTotal.Text = "";
            lblStock.Text = "";
            txtSaleDate.Text = DateTime.Now.ToString("dd-MM-yyyy");
        }

        private void ShowMessage(string text, bool isSuccess)
        {
            lblMessage.Visible = true;
            lblMessage.Text = text;
            lblMessage.CssClass = isSuccess ? "alert alert-success d-block" : "alert alert-danger d-block";
        }
    }
}