using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace SalesManagementSystem1
{
    public partial class SalesHistory : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["SalesDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSales();
            }
        }

        // ---------- VIEW + SEARCH ----------
        // Customer name / date filter-a use panni sales list-a load pannum.
        // Filter khaali-a irundha ella sales-um varum.
        private void LoadSales()
        {
            lblMessage.Visible = false;

            string customer = txtCustomer.Text.Trim();

            object dateValue = DBNull.Value;
            if (txtDate.Text.Trim() != "")
            {
                DateTime parsedDate;
                if (DateTime.TryParse(txtDate.Text.Trim(), out parsedDate))
                {
                    dateValue = parsedDate.Date;
                }
                else
                {
                    ShowMessage("Please enter a valid date.", false);
                    return;
                }
            }

            string sql = "SELECT s.SaleID, c.CustomerName, p.ProductName, s.Quantity, s.UnitPrice, s.TotalAmount, s.SaleDate " +
                         "FROM Sales s " +
                         "INNER JOIN Customers c ON s.CustomerID = c.CustomerID " +
                         "INNER JOIN Products p ON s.ProductID = p.ProductID " +
                         "WHERE (@Customer = '' OR c.CustomerName LIKE '%' + @Customer + '%') " +
                         "AND (@Date IS NULL OR CAST(s.SaleDate AS DATE) = @Date) " +
                         "ORDER BY s.SaleDate DESC";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlDataAdapter da = new SqlDataAdapter(sql, con))
            {
                da.SelectCommand.Parameters.AddWithValue("@Customer", customer);
                da.SelectCommand.Parameters.Add("@Date", SqlDbType.Date).Value = dateValue;

                DataTable dt = new DataTable();
                da.Fill(dt);

                gvSales.DataSource = dt;
                gvSales.DataBind();

                decimal totalAmount = 0;
                if (dt.Rows.Count > 0)
                {
                    totalAmount = Convert.ToDecimal(dt.Compute("SUM(TotalAmount)", ""));
                }
                lblSummary.Text = dt.Rows.Count + " sale(s) | Total: Rs. " + totalAmount.ToString("N2");
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            gvSales.PageIndex = 0;
            LoadSales();
        }

        protected void btnShowAll_Click(object sender, EventArgs e)
        {
            txtCustomer.Text = "";
            txtDate.Text = "";
            gvSales.PageIndex = 0;
            LoadSales();
        }

        protected void gvSales_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvSales.PageIndex = e.NewPageIndex;
            LoadSales();
        }

        private void ShowMessage(string text, bool isSuccess)
        {
            lblMessage.Visible = true;
            lblMessage.Text = text;
            lblMessage.CssClass = isSuccess ? "alert alert-success d-block" : "alert alert-danger d-block";
        }
    }
}