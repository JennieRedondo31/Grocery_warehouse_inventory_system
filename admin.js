document.addEventListener("DOMContentLoaded", () => {

    if (!checkAdmin()) {
        return;
    }

    const menuButton = document.getElementById("menu-button");
    const sidebar = document.getElementById("sidebar");

    if (menuButton && sidebar) {
        menuButton.addEventListener("click", () => {
            sidebar.classList.toggle("active");
        });
    }

    const logoutButton = document.getElementById("btn-logout");

    if (logoutButton) {
        logoutButton.addEventListener("click", logout);
    }

    const saveUserButton = document.getElementById("btn-save-user");

    if (saveUserButton) {
        saveUserButton.addEventListener("click", saveUser);
    }

    const cancelUserButton = document.getElementById("btn-cancel-user");

    if (cancelUserButton) {
        cancelUserButton.addEventListener("click", clearUser);
    }

    const saveRoleButton = document.getElementById("btn-save-role");

    if (saveRoleButton) {
        saveRoleButton.addEventListener("click", saveRole);
    }

    const cancelRoleButton = document.getElementById("btn-cancel-role");

    if (cancelRoleButton) {
        cancelRoleButton.addEventListener("click", clearRole);
    }

    const saveCategoryButton = document.getElementById("btn-save-category");

    if (saveCategoryButton) {
        saveCategoryButton.addEventListener("click", saveCategory);
    }

    const cancelCategoryButton = document.getElementById("btn-cancel-category");

    if (cancelCategoryButton) {
        cancelCategoryButton.addEventListener("click", clearCategory);
    }

    const saveAisleButton = document.getElementById("btn-save-aisle");

    if (saveAisleButton) {
        saveAisleButton.addEventListener("click", saveAisle);
    }

    const cancelAisleButton = document.getElementById("btn-cancel-aisle");

    if (cancelAisleButton) {
        cancelAisleButton.addEventListener("click", clearAisle);
    }

    const saveShelfButton = document.getElementById("btn-save-shelf");

    if (saveShelfButton) {
        saveShelfButton.addEventListener("click", saveShelf);
    }

    const cancelShelfButton = document.getElementById("btn-cancel-shelf");

    if (cancelShelfButton) {
        cancelShelfButton.addEventListener("click", clearShelf);
    }

    const saveBinButton = document.getElementById("btn-save-bin");

    if (saveBinButton) {
        saveBinButton.addEventListener("click", saveBin);
    }

    const cancelBinButton = document.getElementById("btn-cancel-bin");

    if (cancelBinButton) {
        cancelBinButton.addEventListener("click", clearBin);
    }

    const saveProductButton = document.getElementById("btn-save-product");

    if (saveProductButton) {
        saveProductButton.addEventListener("click", saveProduct);
    }

    const cancelProductButton = document.getElementById("btn-cancel-product");

    if (cancelProductButton) {
        cancelProductButton.addEventListener("click", clearProduct);
    }

    const roleSearch = document.getElementById("role-search");

    if (roleSearch) {
        roleSearch.addEventListener("input", displayRoles);
    }

    const userSearch = document.getElementById("user-search");

    if (userSearch) {
        userSearch.addEventListener("input", displayUsers);
    }

    const categorySearch = document.getElementById("category-search");

    if (categorySearch) {
        categorySearch.addEventListener("input", displayCategories);
    }

    const aisleSearch = document.getElementById("aisle-search");

    if (aisleSearch) {
        aisleSearch.addEventListener("input", displayAisles);
    }

    const shelfSearch = document.getElementById("shelf-search");

    if (shelfSearch) {
        shelfSearch.addEventListener("input", displayShelves);
    }

    const binSearch = document.getElementById("bin-search");

    if (binSearch) {
        binSearch.addEventListener("input", displayBins);
    }

    const productSearch = document.getElementById("product-search");

    if (productSearch) {
        productSearch.addEventListener("input", displayProducts);
    }

    const auditSearch = document.getElementById("audit-search");

    if (auditSearch) {
        auditSearch.addEventListener("input", displayAuditLogs);
    }

    showSection("dashboard-section");

    displayRoles();
    displayUsers();
    displayCategories();
    displayAisles();
    displayShelves();
    displayBins();
    displayProducts();
    displayAuditLogs();

    displayRoleOptions();
    displayAisleOptions();
    displayShelfOptions();
    displayCategoryOptions();
    displayBinOptions();

});


const baseApiUrl = "http://localhost/grocery_warehouse/api.php";


const checkAdmin = () => {

    const user =
        JSON.parse(localStorage.getItem("user") || "null");

    if (!user || user.RoleName !== "Admin") {

        window.location.href = "login.html";

        return false;
    }

    const adminName =
        document.getElementById("admin-name");

    if (adminName) {

        adminName.textContent =
            (user.FirstName || "") +
            " " +
            (user.LastName || "");

    }

    return true;

};


const logout = () => {

    localStorage.removeItem("user");

    window.location.href = "login.html";

};


const showSection = sectionId => {

    const sections =
        document.querySelectorAll("section");

    sections.forEach(section => {

        section.classList.remove("active-section");

    });

    const selectedSection =
        document.getElementById(sectionId);

    if (selectedSection) {

        selectedSection.classList.add("active-section");

    }

    const sidebar =
        document.getElementById("sidebar");

    if (sidebar) {

        sidebar.classList.remove("active");

    }

};


const sendRequest = async (operation, data = {}) => {

    const loggedInUser =
        JSON.parse(
            localStorage.getItem("user") || "null"
        );

    const requestData = {
        ...data
    };

    if (loggedInUser && loggedInUser.UserID) {

        requestData.LoggedInUserID =
            loggedInUser.UserID;

    }

    const formData =
        new FormData();

    formData.append(
        "operation",
        operation
    );

    formData.append(
        "json",
        JSON.stringify(requestData)
    );

    try {

        const response =
            await axios({
                url: baseApiUrl,
                method: "POST",
                data: formData
            });

        return response.data;

    } catch (error) {

        console.error(error);

        return {
            success: false,
            message: "Unable to connect to the server."
        };

    }

};


const displayRoles = async () => {

    const search =
        document.getElementById("role-search")?.value || "";

    const response =
        await sendRequest(
            "getRoles",
            {
                search: search
            }
        );

    if (!response.success) {
        return;
    }

    let html = `
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Role Name</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
    `;

    response.data.forEach(role => {

        html += `
            <tr>
                <td>${role.RoleID}</td>
                <td>${role.RoleName}</td>
                <td>
                    ${role.IsActive == 1 ? "Active" : "Inactive"}
                </td>
                <td>

                    <button
                        class="btn btn-sm btn-warning"
                        onclick="editRole(${role.RoleID})"
                    >
                        Edit
                    </button>

                    <button
                        class="btn btn-sm btn-danger"
                        onclick="deleteRole(${role.RoleID})"
                    >
                        Delete
                    </button>

                </td>
            </tr>
        `;

    });

    html += `
            </tbody>
        </table>
    `;

    const table =
        document.getElementById("role-table");

    if (table) {
        table.innerHTML = html;
    }

};


const displayRoleOptions = async () => {

    const response =
        await sendRequest(
            "getRoles",
            {
                search: ""
            }
        );

    let html =
        `<option value="">Select Role</option>`;

    if (response.success) {

        response.data.forEach(role => {

            if (role.IsActive == 1) {

                html += `
                    <option value="${role.RoleID}">
                        ${role.RoleName}
                    </option>
                `;

            }

        });

    }

    const element =
        document.getElementById("user-role");

    if (element) {
        element.innerHTML = html;
    }

};


const saveRole = async () => {

    const id =
        document.getElementById("role-id").value;

    const roleName =
        document.getElementById("role-name").value.trim();

    const status =
        document.getElementById("role-status").value;

    if (roleName === "") {

        alert("Please enter role name.");

        return;
    }

    const operation =
        id === ""
            ? "insertRole"
            : "updateRole";

    const response =
        await sendRequest(
            operation,
            {
                RoleID: id,
                RoleName: roleName,
                IsActive: status
            }
        );

    if (!response.success) {

        alert(response.message);

        return;
    }

    clearRole();

    displayRoles();

    displayRoleOptions();

};


const editRole = async id => {

    const response =
        await sendRequest(
            "getRole",
            {
                RoleID: id
            }
        );

    if (!response.success) {

        alert(response.message);

        return;
    }

    const role =
        response.data;

    document.getElementById("role-id").value =
        role.RoleID;

    document.getElementById("role-name").value =
        role.RoleName;

    document.getElementById("role-status").value =
        role.IsActive;

};


const deleteRole = async id => {

    if (!confirm("Delete this role?")) {
        return;
    }

    const response =
        await sendRequest(
            "deleteRole",
            {
                RoleID: id
            }
        );

    if (!response.success) {

        alert(response.message);

        return;
    }

    displayRoles();

    displayRoleOptions();

};


const clearRole = () => {

    document.getElementById("role-id").value = "";

    document.getElementById("role-name").value = "";

    document.getElementById("role-status").value = "1";

};


const displayUsers = async () => {

    const search =
        document.getElementById("user-search")?.value || "";

    const response =
        await sendRequest(
            "getUsers",
            {
                search: search
            }
        );

    if (!response.success) {
        return;
    }

    let html = `
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
    `;

    response.data.forEach(user => {

        html += `
            <tr>
                <td>${user.UserID}</td>
                <td>${user.UserName}</td>
                <td>
                    ${user.FirstName} ${user.LastName}
                </td>
                <td>${user.Email}</td>
                <td>${user.RoleName || ""}</td>
                <td>${user.UserStatus}</td>
                <td>

                    <button
                        class="btn btn-sm btn-warning"
                        onclick="editUser(${user.UserID})"
                    >
                        Edit
                    </button>

                    <button
                        class="btn btn-sm btn-danger"
                        onclick="deleteUser(${user.UserID})"
                    >
                        Delete
                    </button>

                    <button
                        class="btn btn-sm btn-secondary"
                        onclick="toggleUser(${user.UserID}, '${user.UserStatus}')"
                    >
                        ${
                            user.UserStatus === "Active"
                                ? "Deactivate"
                                : "Activate"
                        }
                    </button>

                </td>
            </tr>
        `;

    });

    html += `
            </tbody>
        </table>
    `;

    const table =
        document.getElementById("user-table");

    if (table) {
        table.innerHTML = html;
    }

};


const saveUser = async () => {

    const id =
        document.getElementById("user-id").value;

    const username =
        document.getElementById("username").value.trim();

    const password =
        document.getElementById("user-password").value;

    const firstName =
        document.getElementById("first-name").value.trim();

    const lastName =
        document.getElementById("last-name").value.trim();

    const email =
        document.getElementById("email").value.trim();

    const roleID =
        document.getElementById("user-role").value;

    const userStatus =
        document.getElementById("user-status").value;

    if (username === "") {

        alert("Please enter username.");

        return;
    }

    if (id === "" && password === "") {

        alert("Please enter password.");

        return;
    }

    if (firstName === "") {

        alert("Please enter first name.");

        return;
    }

    if (lastName === "") {

        alert("Please enter last name.");

        return;
    }

    if (email === "") {

        alert("Please enter email.");

        return;
    }

    if (roleID === "") {

        alert("Please select role.");

        return;
    }

    const operation =
        id === ""
            ? "insertUser"
            : "updateUser";

    const response =
        await sendRequest(
            operation,
            {
                UserID: id,
                UserName: username,
                Password: password,
                FirstName: firstName,
                LastName: lastName,
                Email: email,
                RoleID: roleID,
                UserStatus: userStatus
            }
        );

    if (!response.success) {

        alert(response.message);

        return;
    }

    clearUser();

    displayUsers();

    displayAuditLogs();

};


const editUser = async id => {

    const response =
        await sendRequest(
            "getUser",
            {
                UserID: id
            }
        );

    if (!response.success) {

        alert(response.message);

        return;
    }

    const user =
        response.data;

    document.getElementById("user-id").value =
        user.UserID;

    document.getElementById("username").value =
        user.UserName;

    document.getElementById("user-password").value =
        "";

    document.getElementById("first-name").value =
        user.FirstName;

    document.getElementById("last-name").value =
        user.LastName;

    document.getElementById("email").value =
        user.Email;

    document.getElementById("user-role").value =
        user.RoleID;

    document.getElementById("user-status").value =
        user.UserStatus;

};


const deleteUser = async id => {

    const loggedInUser =
        JSON.parse(
            localStorage.getItem("user") || "null"
        );

    if (
        loggedInUser &&
        Number(loggedInUser.UserID) === Number(id)
    ) {

        alert(
            "You cannot delete the currently logged-in user."
        );

        return;
    }

    if (!confirm("Delete this user?")) {
        return;
    }

    const response =
        await sendRequest(
            "deleteUser",
            {
                UserID: id
            }
        );

    if (!response.success) {

        alert(response.message);

        return;
    }

    displayUsers();

    displayAuditLogs();

};


const toggleUser = async (id, currentStatus) => {

    const newStatus =
        currentStatus === "Active"
            ? "Inactive"
            : "Active";

    const response =
        await sendRequest(
            "toggleUserStatus",
            {
                UserID: id,
                UserStatus: newStatus
            }
        );

    if (!response.success) {

        alert(response.message);

        return;
    }

    displayUsers();

    displayAuditLogs();

};


const clearUser = () => {

    document.getElementById("user-id").value = "";

    document.getElementById("username").value = "";

    document.getElementById("user-password").value = "";

    document.getElementById("first-name").value = "";

    document.getElementById("last-name").value = "";

    document.getElementById("email").value = "";

    document.getElementById("user-role").value = "";

    document.getElementById("user-status").value = "Active";

};


const displayCategories = async () => {

    const search =
        document.getElementById("category-search")?.value || "";

    const response =
        await sendRequest(
            "getCategories",
            {
                search: search
            }
        );

    if (!response.success) {
        return;
    }

    let html = `
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Category Name</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
    `;

    response.data.forEach(category => {

        html += `
            <tr>
                <td>${category.CategoryID}</td>
                <td>${category.CategoryName}</td>
                <td>
                    ${
                        category.IsActive == 1
                            ? "Active"
                            : "Inactive"
                    }
                </td>
                <td>

                    <button
                        class="btn btn-sm btn-warning"
                        onclick="editCategory(${category.CategoryID})"
                    >
                        Edit
                    </button>

                    <button
                        class="btn btn-sm btn-danger"
                        onclick="deleteCategory(${category.CategoryID})"
                    >
                        Delete
                    </button>

                </td>
            </tr>
        `;

    });

    html += `
            </tbody>
        </table>
    `;

    document.getElementById("category-table").innerHTML =
        html;

};


const saveCategory = async () => {

    const id =
        document.getElementById("category-id").value;

    const name =
        document.getElementById("category-name").value.trim();

    const status =
        document.getElementById("category-status").value;

    if (name === "") {

        alert("Please enter category name.");

        return;
    }

    const operation =
        id === ""
            ? "insertCategory"
            : "updateCategory";

    const response =
        await sendRequest(
            operation,
            {
                CategoryID: id,
                CategoryName: name,
                IsActive: status
            }
        );

    if (!response.success) {

        alert(response.message);

        return;
    }

    clearCategory();

    displayCategories();

    displayCategoryOptions();

};


const editCategory = async id => {

    const response =
        await sendRequest(
            "getCategory",
            {
                CategoryID: id
            }
        );

    if (!response.success) {

        alert(response.message);

        return;
    }

    document.getElementById("category-id").value =
        response.data.CategoryID;

    document.getElementById("category-name").value =
        response.data.CategoryName;

    document.getElementById("category-status").value =
        response.data.IsActive;

};


const deleteCategory = async id => {

    if (!confirm("Delete this category?")) {
        return;
    }

    const response =
        await sendRequest(
            "deleteCategory",
            {
                CategoryID: id
            }
        );

    if (!response.success) {

        alert(response.message);

        return;
    }

    displayCategories();

    displayCategoryOptions();

};


const clearCategory = () => {

    document.getElementById("category-id").value = "";

    document.getElementById("category-name").value = "";

    document.getElementById("category-status").value = "1";

};


const displayCategoryOptions = async () => {

    const response =
        await sendRequest(
            "getCategories",
            {
                search: ""
            }
        );

    let html =
        `<option value="">Select Category</option>`;

    if (response.success) {

        response.data.forEach(category => {

            if (category.IsActive == 1) {

                html += `
                    <option value="${category.CategoryID}">
                        ${category.CategoryName}
                    </option>
                `;

            }

        });

    }

    const element =
        document.getElementById("product-category");

    if (element) {
        element.innerHTML = html;
    }

};


const displayAisles = async () => {

    const search =
        document.getElementById("aisle-search")?.value || "";

    const response =
        await sendRequest(
            "getAisles",
            {
                search: search
            }
        );

    if (!response.success) {
        return;
    }

    let html = `
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Aisle Code</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
    `;

    response.data.forEach(aisle => {

        html += `
            <tr>
                <td>${aisle.AisleID}</td>
                <td>${aisle.AisleCode}</td>
                <td>
                    ${
                        aisle.IsActive == 1
                            ? "Active"
                            : "Inactive"
                    }
                </td>
                <td>

                    <button
                        class="btn btn-sm btn-warning"
                        onclick="editAisle(${aisle.AisleID})"
                    >
                        Edit
                    </button>

                    <button
                        class="btn btn-sm btn-danger"
                        onclick="deleteAisle(${aisle.AisleID})"
                    >
                        Delete
                    </button>

                </td>
            </tr>
        `;

    });

    html += `
            </tbody>
        </table>
    `;

    document.getElementById("aisle-table").innerHTML =
        html;

};


const saveAisle = async () => {

    const id =
        document.getElementById("aisle-id").value;

    const code =
        document.getElementById("aisle-code").value.trim();

    const status =
        document.getElementById("aisle-status").value;

    if (code === "") {

        alert("Please enter aisle code.");

        return;
    }

    const operation =
        id === ""
            ? "insertAisle"
            : "updateAisle";

    const response =
        await sendRequest(
            operation,
            {
                AisleID: id,
                AisleCode: code,
                IsActive: status
            }
        );

    if (!response.success) {

        alert(response.message);

        return;
    }

    clearAisle();

    displayAisles();

    displayAisleOptions();

};


const editAisle = async id => {

    const response =
        await sendRequest(
            "getAisle",
            {
                AisleID: id
            }
        );

    if (!response.success) {

        alert(response.message);

        return;
    }

    document.getElementById("aisle-id").value =
        response.data.AisleID;

    document.getElementById("aisle-code").value =
        response.data.AisleCode;

    document.getElementById("aisle-status").value =
        response.data.IsActive;

};


const deleteAisle = async id => {

    if (!confirm("Delete this aisle?")) {
        return;
    }

    const response =
        await sendRequest(
            "deleteAisle",
            {
                AisleID: id
            }
        );

    if (!response.success) {

        alert(response.message);

        return;
    }

    displayAisles();

    displayAisleOptions();

};


const clearAisle = () => {

    document.getElementById("aisle-id").value = "";

    document.getElementById("aisle-code").value = "";

    document.getElementById("aisle-status").value = "1";

};


const displayAisleOptions = async () => {

    const response =
        await sendRequest(
            "getAisles",
            {
                search: ""
            }
        );

    let html =
        `<option value="">Select Aisle</option>`;

    if (response.success) {

        response.data.forEach(aisle => {

            if (aisle.IsActive == 1) {

                html += `
                    <option value="${aisle.AisleID}">
                        ${aisle.AisleCode}
                    </option>
                `;

            }

        });

    }

    const element =
        document.getElementById("shelf-aisle");

    if (element) {
        element.innerHTML = html;
    }

};


const displayShelves = async () => {

    const search =
        document.getElementById("shelf-search")?.value || "";

    const response =
        await sendRequest(
            "getShelves",
            {
                search: search
            }
        );

    if (!response.success) {
        return;
    }

    let html = `
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Aisle</th>
                    <th>Shelf Code</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
    `;

    response.data.forEach(shelf => {

        html += `
            <tr>
                <td>${shelf.ShelfID}</td>
                <td>${shelf.AisleCode || ""}</td>
                <td>${shelf.ShelfCode}</td>
                <td>
                    ${
                        shelf.IsActive == 1
                            ? "Active"
                            : "Inactive"
                    }
                </td>
                <td>

                    <button
                        class="btn btn-sm btn-warning"
                        onclick="editShelf(${shelf.ShelfID})"
                    >
                        Edit
                    </button>

                    <button
                        class="btn btn-sm btn-danger"
                        onclick="deleteShelf(${shelf.ShelfID})"
                    >
                        Delete
                    </button>

                </td>
            </tr>
        `;

    });

    html += `
            </tbody>
        </table>
    `;

    document.getElementById("shelf-table").innerHTML =
        html;

};


const saveShelf = async () => {

    const id =
        document.getElementById("shelf-id").value;

    const aisleID =
        document.getElementById("shelf-aisle").value;

    const code =
        document.getElementById("shelf-code").value.trim();

    const status =
        document.getElementById("shelf-status").value;

    if (aisleID === "") {

        alert("Please select aisle.");

        return;
    }

    if (code === "") {

        alert("Please enter shelf code.");

        return;
    }

    const operation =
        id === ""
            ? "insertShelf"
            : "updateShelf";

    const response =
        await sendRequest(
            operation,
            {
                ShelfID: id,
                AisleID: aisleID,
                ShelfCode: code,
                IsActive: status
            }
        );

    if (!response.success) {

        alert(response.message);

        return;
    }

    clearShelf();

    displayShelves();

    displayShelfOptions();

};


const editShelf = async id => {

    const response =
        await sendRequest(
            "getShelf",
            {
                ShelfID: id
            }
        );

    if (!response.success) {

        alert(response.message);

        return;
    }

    document.getElementById("shelf-id").value =
        response.data.ShelfID;

    document.getElementById("shelf-aisle").value =
        response.data.AisleID;

    document.getElementById("shelf-code").value =
        response.data.ShelfCode;

    document.getElementById("shelf-status").value =
        response.data.IsActive;

};


const deleteShelf = async id => {

    if (!confirm("Delete this shelf?")) {
        return;
    }

    const response =
        await sendRequest(
            "deleteShelf",
            {
                ShelfID: id
            }
        );

    if (!response.success) {

        alert(response.message);

        return;
    }

    displayShelves();

    displayShelfOptions();

};


const clearShelf = () => {

    document.getElementById("shelf-id").value = "";

    document.getElementById("shelf-aisle").value = "";

    document.getElementById("shelf-code").value = "";

    document.getElementById("shelf-status").value = "1";

};


const displayShelfOptions = async () => {

    const response =
        await sendRequest(
            "getShelves",
            {
                search: ""
            }
        );

    let html =
        `<option value="">Select Shelf</option>`;

    if (response.success) {

        response.data.forEach(shelf => {

            if (shelf.IsActive == 1) {

                html += `
                    <option value="${shelf.ShelfID}">
                        ${shelf.ShelfCode}
                    </option>
                `;

            }

        });

    }

    const element =
        document.getElementById("bin-shelf");

    if (element) {
        element.innerHTML = html;
    }

};


const displayBins = async () => {

    const search =
        document.getElementById("bin-search")?.value || "";

    const response =
        await sendRequest(
            "getBins",
            {
                search: search
            }
        );

    if (!response.success) {
        return;
    }

    let html = `
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Shelf</th>
                    <th>Bin Code</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
    `;

    response.data.forEach(bin => {

        html += `
            <tr>
                <td>${bin.BinID}</td>
                <td>${bin.ShelfCode || ""}</td>
                <td>${bin.BinCode}</td>
                <td>
                    ${
                        bin.IsActive == 1
                            ? "Active"
                            : "Inactive"
                    }
                </td>
                <td>

                    <button
                        class="btn btn-sm btn-warning"
                        onclick="editBin(${bin.BinID})"
                    >
                        Edit
                    </button>

                    <button
                        class="btn btn-sm btn-danger"
                        onclick="deleteBin(${bin.BinID})"
                    >
                        Delete
                    </button>

                </td>
            </tr>
        `;

    });

    html += `
            </tbody>
        </table>
    `;

    document.getElementById("bin-table").innerHTML =
        html;

};


const saveBin = async () => {

    const id =
        document.getElementById("bin-id").value;

    const shelfID =
        document.getElementById("bin-shelf").value;

    const code =
        document.getElementById("bin-code").value.trim();

    const status =
        document.getElementById("bin-status").value;

    if (shelfID === "") {

        alert("Please select shelf.");

        return;
    }

    if (code === "") {

        alert("Please enter bin code.");

        return;
    }

    const operation =
        id === ""
            ? "insertBin"
            : "updateBin";

    const response =
        await sendRequest(
            operation,
            {
                BinID: id,
                ShelfID: shelfID,
                BinCode: code,
                IsActive: status
            }
        );

    if (!response.success) {

        alert(response.message);

        return;
    }

    clearBin();

    displayBins();

    displayBinOptions();

};


const editBin = async id => {

    const response =
        await sendRequest(
            "getBin",
            {
                BinID: id
            }
        );

    if (!response.success) {

        alert(response.message);

        return;
    }

    document.getElementById("bin-id").value =
        response.data.BinID;

    document.getElementById("bin-shelf").value =
        response.data.ShelfID;

    document.getElementById("bin-code").value =
        response.data.BinCode;

    document.getElementById("bin-status").value =
        response.data.IsActive;

};


const deleteBin = async id => {

    if (!confirm("Delete this bin?")) {
        return;
    }

    const response =
        await sendRequest(
            "deleteBin",
            {
                BinID: id
            }
        );

    if (!response.success) {

        alert(response.message);

        return;
    }

    displayBins();

    displayBinOptions();

};


const clearBin = () => {

    document.getElementById("bin-id").value = "";

    document.getElementById("bin-shelf").value = "";

    document.getElementById("bin-code").value = "";

    document.getElementById("bin-status").value = "1";

};


const displayBinOptions = async () => {

    const response =
        await sendRequest(
            "getBins",
            {
                search: ""
            }
        );

    let html =
        `<option value="">Select Bin</option>`;

    if (response.success) {

        response.data.forEach(bin => {

            if (bin.IsActive == 1) {

                html += `
                    <option value="${bin.BinID}">
                        ${bin.BinCode}
                    </option>
                `;

            }

        });

    }

    const element =
        document.getElementById("product-bin");

    if (element) {
        element.innerHTML = html;
    }

};


const displayProducts = async () => {

    const search =
        document.getElementById("product-search")?.value || "";

    const response =
        await sendRequest(
            "getProducts",
            {
                search: search
            }
        );

    if (!response.success) {
        return;
    }

    let html = `
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>SKU</th>
                    <th>Barcode</th>
                    <th>Product Name</th>
                    <th>Unit</th>
                    <th>Min Stock</th>
                    <th>Bin</th>
                    <th>Category</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
    `;

    response.data.forEach(product => {

        html += `
            <tr>
                <td>${product.ProductID}</td>
                <td>${product.SKU}</td>
                <td>${product.Barcode}</td>
                <td>${product.ProductName}</td>
                <td>${product.UnitOfMeasure}</td>
                <td>${product.MinStockLevel}</td>
                <td>${product.BinCode || ""}</td>
                <td>${product.CategoryName || ""}</td>
                <td>
                    ${
                        product.IsActive == 1
                            ? "Active"
                            : "Inactive"
                    }
                </td>
                <td>

                    <button
                        class="btn btn-sm btn-warning"
                        onclick="editProduct(${product.ProductID})"
                    >
                        Edit
                    </button>

                    <button
                        class="btn btn-sm btn-danger"
                        onclick="deleteProduct(${product.ProductID})"
                    >
                        Delete
                    </button>

                </td>
            </tr>
        `;

    });

    html += `
            </tbody>
        </table>
    `;

    document.getElementById("product-table").innerHTML =
        html;

};


const saveProduct = async () => {

    const id =
        document.getElementById("product-id").value;

    const sku =
        document.getElementById("sku").value.trim();

    const barcode =
        document.getElementById("barcode").value.trim();

    const productName =
        document.getElementById("product-name").value.trim();

    const description =
        document.getElementById("description").value.trim();

    const unit =
        document.getElementById("unit-of-measure").value.trim();

    const minStock =
        document.getElementById("min-stock-level").value;

    const binID =
        document.getElementById("product-bin").value;

    const categoryID =
        document.getElementById("product-category").value;

    const status =
        document.getElementById("product-status").value;

    if (sku === "") {

        alert("Please enter SKU.");

        return;
    }

    if (productName === "") {

        alert("Please enter product name.");

        return;
    }

    if (unit === "") {

        alert("Please enter unit of measure.");

        return;
    }

    if (binID === "") {

        alert("Please select bin.");

        return;
    }

    if (categoryID === "") {

        alert("Please select category.");

        return;
    }

    const operation =
        id === ""
            ? "insertProduct"
            : "updateProduct";

    const response =
        await sendRequest(
            operation,
            {
                ProductID: id,
                SKU: sku,
                Barcode: barcode,
                ProductName: productName,
                Description: description,
                UnitOfMeasure: unit,
                MinStockLevel: minStock,
                BinID: binID,
                CategoryID: categoryID,
                IsActive: status
            }
        );

    if (!response.success) {

        alert(response.message);

        return;
    }

    clearProduct();

    displayProducts();

    displayAuditLogs();

};


const editProduct = async id => {

    const response =
        await sendRequest(
            "getProduct",
            {
                ProductID: id
            }
        );

    if (!response.success) {

        alert(response.message);

        return;
    }

    const product =
        response.data;

    document.getElementById("product-id").value =
        product.ProductID;

    document.getElementById("sku").value =
        product.SKU;

    document.getElementById("barcode").value =
        product.Barcode;

    document.getElementById("product-name").value =
        product.ProductName;

    document.getElementById("description").value =
        product.Description;

    document.getElementById("unit-of-measure").value =
        product.UnitOfMeasure;

    document.getElementById("min-stock-level").value =
        product.MinStockLevel;

    document.getElementById("product-bin").value =
        product.BinID;

    document.getElementById("product-category").value =
        product.CategoryID;

    document.getElementById("product-status").value =
        product.IsActive;

};


const deleteProduct = async id => {

    if (!confirm("Delete this product?")) {
        return;
    }

    const response =
        await sendRequest(
            "deleteProduct",
            {
                ProductID: id
            }
        );

    if (!response.success) {

        alert(response.message);

        return;
    }

    displayProducts();

    displayAuditLogs();

};


const clearProduct = () => {

    document.getElementById("product-id").value = "";

    document.getElementById("sku").value = "";

    document.getElementById("barcode").value = "";

    document.getElementById("product-name").value = "";

    document.getElementById("description").value = "";

    document.getElementById("unit-of-measure").value = "";

    document.getElementById("min-stock-level").value = "0";

    document.getElementById("product-bin").value = "";

    document.getElementById("product-category").value = "";

    document.getElementById("product-status").value = "1";

};


const displayAuditLogs = async () => {

    const search =
        document.getElementById("audit-search")?.value || "";

    const response =
        await sendRequest(
            "getAuditLogs",
            {
                search: search
            }
        );

    if (!response.success) {
        return;
    }

    let html = `
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>User ID</th>
                    <th>Username</th>
                    <th>Action</th>
                    <th>Table</th>
                    <th>Date/Time</th>
                    <th>Details</th>
                </tr>
            </thead>
            <tbody>
    `;

    response.data.forEach(log => {

        html += `
            <tr>
                <td>${log.AuditLogID}</td>
                <td>${log.UserID}</td>
                <td>${log.UserName || ""}</td>
                <td>${log.ActionType}</td>
                <td>${log.TableAffected}</td>
                <td>${log.ActionTimestamp}</td>
                <td>${log.Details}</td>
            </tr>
        `;

    });

    html += `
            </tbody>
        </table>
    `;

    const table =
        document.getElementById("audit-table");

    if (table) {
        table.innerHTML = html;
    }

};