using System;
using System.IO;

namespace SalesManagementSystem1
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        
        protected void Page_Init(object sender, EventArgs e)
        {
            if (Session["User"] == null)
            {
                Response.Redirect("Login.aspx");
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && Session["User"] != null)
            {
                lblUser.Text = Session["User"].ToString();
            }
        }

        
        protected string GetActive(string pageName)
        {
            string currentPage = Path.GetFileName(Request.Path);
            return currentPage.Equals(pageName, StringComparison.OrdinalIgnoreCase) ? "active" : "";
        }

        
        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}