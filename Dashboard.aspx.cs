using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace SalesManagementSystem1
{
    public partial class Dashboard : System.Web.UI.Page
    {
        
        string connStr = ConfigurationManager.ConnectionStrings["SalesDB"].ConnectionString;

        
        const int LowStockLimit = 10;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCards();
                LoadSummary();
                LoadRecentSales();
                LoadLowStock();
            }
        }

        
        private decimal GetNumber(string sql)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(sql, con))
            {
                con.Open();
                object result = cmd.ExecuteScalar();
                if (result == null || result == DBNull.Value)
                    return 0;
                return Convert.ToDecimal(result);
            }
        }

        private void LoadCards()
        {
            lblProducts.Text = GetNumber("SELECT COUNT(*) FROM Products").ToString("0");
            lblCustomers.Text = GetNumber("SELECT COUNT(*) FROM Customers").ToString("0");
            lblSales.Text = GetNumber("SELECT COUNT(*) FROM Sales").ToString("0");

            decimal revenue = GetNumber("SELECT ISNULL(SUM(TotalAmount), 0) FROM Sales");
            lblRevenue.Text = "Rs. " + revenue.ToString("N2");
        }

        
        private void LoadSummary()
        {
            lblTodaySales.Text = GetNumber(
                "SELECT COUNT(*) FROM Sales WHERE CAST(SaleDate AS DATE) = CAST(GETDATE() AS DATE)").ToString("0");

            decimal todayRevenue = GetNumber(
                "SELECT ISNULL(SUM(TotalAmount), 0) FROM Sales WHERE CAST(SaleDate AS DATE) = CAST(GETDATE() AS DATE)");
            lblTodayRevenue.Text = "Rs. " + todayRevenue.ToString("N2");

            decimal monthRevenue = GetNumber(
                "SELECT ISNULL(SUM(TotalAmount), 0) FROM Sales " +
                "WHERE MONTH(SaleDate) = MONTH(GETDATE()) AND YEAR(SaleDate) = YEAR(GETDATE())");
            lblMonthRevenue.Text = "Rs. " + monthRevenue.ToString("N2");
        }

        private void LoadRecentSales()
        {
            string sql = "SELECT TOP 5 s.SaleID, c.CustomerName, p.ProductName, s.Quantity, s.TotalAmount, s.SaleDate " +
                         "FROM Sales s " +
                         "INNER JOIN Customers c ON s.CustomerID = c.CustomerID " +
                         "INNER JOIN Products p ON s.ProductID = p.ProductID " +
                         "ORDER BY s.SaleDate DESC";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlDataAdapter da = new SqlDataAdapter(sql, con))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvRecentSales.DataSource = dt;
                gvRecentSales.DataBind();
            }
        }

        
        private void LoadLowStock()
        {
            string sql = "SELECT ProductName, Category, Stock FROM Products " +
                         "WHERE Stock <= @Limit ORDER BY Stock";

            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlDataAdapter da = new SqlDataAdapter(sql, con))
            {
                da.SelectCommand.Parameters.AddWithValue("@Limit", LowStockLimit);

                DataTable dt = new DataTable();
                da.Fill(dt);
                gvLowStock.DataSource = dt;
                gvLowStock.DataBind();
            }
        }
    }
}