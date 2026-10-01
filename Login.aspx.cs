using System;

namespace SalesManagementSystem1
{
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["User"] != null)
            {
                Response.Redirect("Dashboard.aspx");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (username == "admin" && password == "admin123")
            {
                Session["User"] = username;          
                Response.Redirect("Dashboard.aspx");
            }
            else
            {
                lblMessage.Visible = true;
                lblMessage.CssClass = "alert alert-danger d-block";
                lblMessage.Text = "Invalid username or password. Please try again.";
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            txtUsername.Text = "";
            txtPassword.Text = "";
            lblMessage.Visible = false;
        }
    }
}