using Microsoft.AspNetCore.Mvc;
using System.Reflection;
using Task_1.Models;

namespace Task_1.Controllers
{
    public class LoginController : Controller
    {
        private readonly List<UserModel> _registeredUsers = new List<UserModel>
        {
            new UserModel { Id = 1, IsAdmin = false, UserName = "User1", Password = "Password" },
            new UserModel { Id = 2, IsAdmin = true, UserName = "Admin", Password = "SuperAdmin" }
        };

        public IActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public IActionResult Verify(UserModel loginData)
        {
            if (ModelState.IsValid)
            {
                UserModel? foundUser = _registeredUsers.FirstOrDefault(user => user.UserName == loginData.UserName);

                if (foundUser != null && foundUser.Password == loginData.Password)
                {
                    return RedirectToAction("Index", "Home", new
                    {
                        userName = foundUser.UserName,
                        isAdmin = foundUser.IsAdmin
                    });
                }
                else
                {
                    ModelState.AddModelError("Error", "Incorrect username or password!");
                }
            }

            return View("Index", loginData);
        }
    }
}
