using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace SalesManagementSystem1
{
    public partial class Reports : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["SalesDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadSummary();
                LoadTopProducts();
                LoadDailyReport();
                LoadRecentSales();
                LoadChart();
            }
        }

        private DataTable GetTable(string sql)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            using (SqlDataAdapter da = new SqlDataAdapter(sql, con))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
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

        private void LoadSummary()
        {
            lblTotalSales.Text = GetNumber("SELECT COUNT(*) FROM Sales").ToString("0");

            decimal revenue = GetNumber("SELECT ISNULL(SUM(TotalAmount), 0) FROM Sales");
            lblRevenue.Text = "Rs. " + revenue.ToString("N2");

            lblProductsSold.Text = GetNumber("SELECT ISNULL(SUM(Quantity), 0) FROM Sales").ToString("0");
        }

        private void LoadTopProducts()
        {
            string sql = "SELECT TOP 5 p.ProductName, p.Category, SUM(s.Quantity) AS QtySold, SUM(s.TotalAmount) AS Revenue " +
                         "FROM Sales s " +
                         "INNER JOIN Products p ON s.ProductID = p.ProductID " +
                         "GROUP BY p.ProductName, p.Category " +
                         "ORDER BY QtySold DESC";

            gvTopProducts.DataSource = GetTable(sql);
            gvTopProducts.DataBind();
        }

        private void LoadDailyReport()
        {
            string sql = "SELECT TOP 10 CAST(SaleDate AS DATE) AS SaleDay, COUNT(*) AS TotalSales, " +
                         "SUM(Quantity) AS ItemsSold, SUM(TotalAmount) AS Revenue " +
                         "FROM Sales " +
                         "GROUP BY CAST(SaleDate AS DATE) " +
                         "ORDER BY SaleDay DESC";

            gvDaily.DataSource = GetTable(sql);
            gvDaily.DataBind();
        }

        private void LoadRecentSales()
        {
            string sql = "SELECT TOP 10 s.SaleID, c.CustomerName, p.ProductName, s.Quantity, s.TotalAmount, s.SaleDate " +
                         "FROM Sales s " +
                         "INNER JOIN Customers c ON s.CustomerID = c.CustomerID " +
                         "INNER JOIN Products p ON s.ProductID = p.ProductID " +
                         "ORDER BY s.SaleDate DESC";

            gvRecent.DataSource = GetTable(sql);
            gvRecent.DataBind();
        }

        private void LoadChart()
        {
            string sql = "SELECT p.ProductName, SUM(s.TotalAmount) AS Revenue " +
                         "FROM Sales s " +
                         "INNER JOIN Products p ON s.ProductID = p.ProductID " +
                         "GROUP BY p.ProductName " +
                         "ORDER BY Revenue DESC";

            DataTable dt = GetTable(sql);

            chartRevenue.Series["Revenue"].Points.Clear();

            foreach (DataRow row in dt.Rows)
            {
                chartRevenue.Series["Revenue"].Points.AddXY(
                    row["ProductName"].ToString(),
                    Convert.ToDouble(row["Revenue"]));
            }
        }
    }
}