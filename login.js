document.addEventListener("DOMContentLoaded", () => {

    document
        .getElementById("btn-login")
        .addEventListener("click", () => {
            login();
        });

});

const baseApiUrl = "http://localhost/grocery_warehouse/api.php";

const login = async () => {

    const username =
        document.getElementById("username").value;

    const password =
        document.getElementById("password").value;

    if (username == "" || password == "") {

        alert("Please enter username and password.");
        return;

    }

    const formData = new FormData();

    formData.append("operation", "login");

    formData.append(
        "json",
        JSON.stringify({
            username: username,
            password: password
        })
    );

    try {

        const response = await axios({
            url: baseApiUrl,
            method: "POST",
            data: formData
        });

        if (response.data.success == true) {

            if (response.data.data.RoleName == "Admin") {

                localStorage.setItem(
                    "user",
                    JSON.stringify(response.data.data)
                );

                window.location.href = "admin.html";

            } else {

                alert("Only Admin users can access this page.");

            }

        } else {

            alert(response.data.message);

        }

    } catch (error) {

        console.error(error);

        alert("Unable to connect to the server.");

    }

};