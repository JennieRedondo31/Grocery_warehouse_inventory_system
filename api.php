<?php

header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

$host = "127.0.0.1";
$dbname = "grocery_warehouse_db";
$username = "root";
$password = "";

try {

    $conn = new PDO(
        "mysql:host=$host;dbname=$dbname;charset=utf8mb4",
        $username,
        $password
    );

    $conn->setAttribute(
        PDO::ATTR_ERRMODE,
        PDO::ERRMODE_EXCEPTION
    );

} catch (PDOException $e) {

    echo json_encode([
        "success" => false,
        "message" => "Database connection failed: " . $e->getMessage()
    ]);

    exit;
}

$operation = $_POST["operation"] ?? "";
$json = $_POST["json"] ?? "{}";
$data = json_decode($json, true);

if (!is_array($data)) {
    $data = [];
}

$currentUserID = isset($data["LoggedInUserID"])
    ? (int)$data["LoggedInUserID"]
    : null;

function response($success, $message, $data = []) {

    echo json_encode([
        "success" => $success,
        "message" => $message,
        "data" => $data
    ]);

    exit;
}

function addAudit($conn, $userID, $action, $table, $details) {

    global $currentUserID;

    if ($userID === null) {
        $userID = $currentUserID;
    }

    if ($userID === null || $userID <= 0) {
        throw new Exception(
            "Logged-in UserID is required for audit logging."
        );
    }

    $userID = (int)$userID;
    $action = $conn->quote($action);
    $table = $conn->quote($table);
    $details = $conn->quote($details);

    $sql = "
        INSERT INTO AuditLog
        (
            UserID,
            ActionType,
            TableAffected,
            Details
        )
        VALUES
        (
            $userID,
            $action,
            $table,
            $details
        )
    ";

    $conn->exec($sql);
}

try {

    switch ($operation) {

        case "login":

            $usernameValue = trim($data["username"] ?? "");
            $plainPassword = $data["password"] ?? "";

            if ($usernameValue === "" || $plainPassword === "") {

                response(
                    false,
                    "Username and password are required."
                );

            }

            $username = $conn->quote($usernameValue);

            $sql = "
                SELECT
                    u.UserID,
                    u.UserName,
                    u.Password,
                    u.FirstName,
                    u.LastName,
                    u.Email,
                    u.RoleID,
                    u.UserStatus,
                    r.RoleName
                FROM `User` u
                INNER JOIN Role r
                    ON u.RoleID = r.RoleID
                WHERE
                    u.UserName = $username
                    AND u.UserStatus = 'Active'
                    AND r.IsActive = 1
                LIMIT 1
            ";

            $stmt = $conn->query($sql);

            $user = $stmt->fetch(PDO::FETCH_ASSOC);

            if (!$user) {

                response(
                    false,
                    "Invalid username or password."
                );

            }

            $storedPassword = $user["Password"];

            $passwordIsValid = false;

            if (
                password_get_info($storedPassword)["algo"] !== 0
            ) {

                $passwordIsValid =
                    password_verify(
                        $plainPassword,
                        $storedPassword
                    );

            } else {

                if ($plainPassword === $storedPassword) {

                    $passwordIsValid = true;

                    $newHash =
                        password_hash(
                            $plainPassword,
                            PASSWORD_DEFAULT
                        );

                    $newHash = $conn->quote($newHash);

                    $userID =
                        (int)$user["UserID"];

                    $updatePassword = "
                        UPDATE `User`
                        SET Password = $newHash
                        WHERE UserID = $userID
                    ";

                    $conn->exec($updatePassword);
                }
            }

            if (!$passwordIsValid) {

                response(
                    false,
                    "Invalid username or password."
                );

            }

            unset($user["Password"]);

            response(
                true,
                "Login successful.",
                $user
            );

            break;


        case "getRoles":

            $search = $data["search"] ?? "";
            $search = $conn->quote("%" . $search . "%");

            $sql = "
                SELECT *
                FROM Role
                WHERE RoleName LIKE $search
                ORDER BY RoleID DESC
            ";

            $stmt = $conn->query($sql);

            response(
                true,
                "Roles retrieved successfully.",
                $stmt->fetchAll(PDO::FETCH_ASSOC)
            );

            break;


        case "getRole":

            $id = (int)($data["RoleID"] ?? 0);

            $sql = "
                SELECT *
                FROM Role
                WHERE RoleID = $id
            ";

            $stmt = $conn->query($sql);

            $role = $stmt->fetch(PDO::FETCH_ASSOC);

            response(
                true,
                "Role retrieved successfully.",
                $role
            );

            break;


        case "insertRole":

            $name = $conn->quote($data["RoleName"] ?? "");
            $active = (int)($data["IsActive"] ?? 1);

            $sql = "
                INSERT INTO Role
                (
                    RoleName,
                    IsActive
                )
                VALUES
                (
                    $name,
                    $active
                )
            ";

            $conn->exec($sql);

            addAudit(
                $conn,
                null,
                "CREATE",
                "Role",
                "Created role: " . ($data["RoleName"] ?? "")
            );

            response(
                true,
                "Role created successfully."
            );

            break;


        case "updateRole":

            $id = (int)($data["RoleID"] ?? 0);
            $name = $conn->quote($data["RoleName"] ?? "");
            $active = (int)($data["IsActive"] ?? 1);

            $sql = "
                UPDATE Role
                SET
                    RoleName = $name,
                    IsActive = $active
                WHERE RoleID = $id
            ";

            $conn->exec($sql);

            addAudit(
                $conn,
                null,
                "UPDATE",
                "Role",
                "Updated role ID: " . $id
            );

            response(
                true,
                "Role updated successfully."
            );

            break;


        case "deleteRole":

            $id = (int)($data["RoleID"] ?? 0);

            $sql = "
                DELETE FROM Role
                WHERE RoleID = $id
            ";

            $conn->exec($sql);

            addAudit(
                $conn,
                null,
                "DELETE",
                "Role",
                "Deleted role ID: " . $id
            );

            response(
                true,
                "Role deleted successfully."
            );

            break;


        case "getCategories":

            $search = $data["search"] ?? "";
            $search = $conn->quote("%" . $search . "%");

            $sql = "
                SELECT *
                FROM Category
                WHERE CategoryName LIKE $search
                ORDER BY CategoryID DESC
            ";

            $stmt = $conn->query($sql);

            response(
                true,
                "Categories retrieved successfully.",
                $stmt->fetchAll(PDO::FETCH_ASSOC)
            );

            break;


        case "getCategory":

            $id = (int)($data["CategoryID"] ?? 0);

            $sql = "
                SELECT *
                FROM Category
                WHERE CategoryID = $id
            ";

            $stmt = $conn->query($sql);

            $category = $stmt->fetch(PDO::FETCH_ASSOC);

            response(
                true,
                "Category retrieved successfully.",
                $category
            );

            break;


        case "insertCategory":

            $name = $conn->quote($data["CategoryName"] ?? "");
            $active = (int)($data["IsActive"] ?? 1);

            $sql = "
                INSERT INTO Category
                (
                    CategoryName,
                    IsActive
                )
                VALUES
                (
                    $name,
                    $active
                )
            ";

            $conn->exec($sql);

            addAudit(
                $conn,
                null,
                "CREATE",
                "Category",
                "Created category: " . ($data["CategoryName"] ?? "")
            );

            response(
                true,
                "Category created successfully."
            );

            break;


        case "updateCategory":

            $id = (int)($data["CategoryID"] ?? 0);
            $name = $conn->quote($data["CategoryName"] ?? "");
            $active = (int)($data["IsActive"] ?? 1);

            $sql = "
                UPDATE Category
                SET
                    CategoryName = $name,
                    IsActive = $active
                WHERE CategoryID = $id
            ";

            $conn->exec($sql);

            addAudit(
                $conn,
                null,
                "UPDATE",
                "Category",
                "Updated category ID: " . $id
            );

            response(
                true,
                "Category updated successfully."
            );

            break;


        case "deleteCategory":

            $id = (int)($data["CategoryID"] ?? 0);

            $sql = "
                DELETE FROM Category
                WHERE CategoryID = $id
            ";

            $conn->exec($sql);

            addAudit(
                $conn,
                null,
                "DELETE",
                "Category",
                "Deleted category ID: " . $id
            );

            response(
                true,
                "Category deleted successfully."
            );

            break;


        case "getAisles":

            $search = $data["search"] ?? "";
            $search = $conn->quote("%" . $search . "%");

            $sql = "
                SELECT *
                FROM Aisle
                WHERE AisleCode LIKE $search
                ORDER BY AisleID DESC
            ";

            $stmt = $conn->query($sql);

            response(
                true,
                "Aisles retrieved successfully.",
                $stmt->fetchAll(PDO::FETCH_ASSOC)
            );

            break;


        case "getAisle":

            $id = (int)($data["AisleID"] ?? 0);

            $sql = "
                SELECT *
                FROM Aisle
                WHERE AisleID = $id
            ";

            $stmt = $conn->query($sql);

            $aisle = $stmt->fetch(PDO::FETCH_ASSOC);

            response(
                true,
                "Aisle retrieved successfully.",
                $aisle
            );

            break;


        case "insertAisle":

            $code = $conn->quote($data["AisleCode"] ?? "");
            $active = (int)($data["IsActive"] ?? 1);

            $sql = "
                INSERT INTO Aisle
                (
                    AisleCode,
                    IsActive
                )
                VALUES
                (
                    $code,
                    $active
                )
            ";

            $conn->exec($sql);

            addAudit(
                $conn,
                null,
                "CREATE",
                "Aisle",
                "Created aisle: " . ($data["AisleCode"] ?? "")
            );

            response(
                true,
                "Aisle created successfully."
            );

            break;


        case "updateAisle":

            $id = (int)($data["AisleID"] ?? 0);
            $code = $conn->quote($data["AisleCode"] ?? "");
            $active = (int)($data["IsActive"] ?? 1);

            $sql = "
                UPDATE Aisle
                SET
                    AisleCode = $code,
                    IsActive = $active
                WHERE AisleID = $id
            ";

            $conn->exec($sql);

            addAudit(
                $conn,
                null,
                "UPDATE",
                "Aisle",
                "Updated aisle ID: " . $id
            );

            response(
                true,
                "Aisle updated successfully."
            );

            break;


        case "deleteAisle":

            $id = (int)($data["AisleID"] ?? 0);

            $sql = "
                DELETE FROM Aisle
                WHERE AisleID = $id
            ";

            $conn->exec($sql);

            addAudit(
                $conn,
                null,
                "DELETE",
                "Aisle",
                "Deleted aisle ID: " . $id
            );

            response(
                true,
                "Aisle deleted successfully."
            );

            break;


        case "getShelves":

            $search = $data["search"] ?? "";
            $search = $conn->quote("%" . $search . "%");

            $sql = "
                SELECT
                    s.ShelfID,
                    s.AisleID,
                    a.AisleCode,
                    s.ShelfCode,
                    s.IsActive
                FROM Shelf s
                INNER JOIN Aisle a
                    ON s.AisleID = a.AisleID
                WHERE
                    s.ShelfCode LIKE $search
                    OR a.AisleCode LIKE $search
                ORDER BY s.ShelfID DESC
            ";

            $stmt = $conn->query($sql);

            response(
                true,
                "Shelves retrieved successfully.",
                $stmt->fetchAll(PDO::FETCH_ASSOC)
            );

            break;


        case "getShelf":

            $id = (int)($data["ShelfID"] ?? 0);

            $sql = "
                SELECT *
                FROM Shelf
                WHERE ShelfID = $id
            ";

            $stmt = $conn->query($sql);

            $shelf = $stmt->fetch(PDO::FETCH_ASSOC);

            response(
                true,
                "Shelf retrieved successfully.",
                $shelf
            );

            break;


        case "insertShelf":

            $aisle = (int)($data["AisleID"] ?? 0);
            $code = $conn->quote($data["ShelfCode"] ?? "");
            $active = (int)($data["IsActive"] ?? 1);

            $sql = "
                INSERT INTO Shelf
                (
                    AisleID,
                    ShelfCode,
                    IsActive
                )
                VALUES
                (
                    $aisle,
                    $code,
                    $active
                )
            ";

            $conn->exec($sql);

            addAudit(
                $conn,
                null,
                "CREATE",
                "Shelf",
                "Created shelf: " . ($data["ShelfCode"] ?? "")
            );

            response(
                true,
                "Shelf created successfully."
            );

            break;


        case "updateShelf":

            $id = (int)($data["ShelfID"] ?? 0);
            $aisle = (int)($data["AisleID"] ?? 0);
            $code = $conn->quote($data["ShelfCode"] ?? "");
            $active = (int)($data["IsActive"] ?? 1);

            $sql = "
                UPDATE Shelf
                SET
                    AisleID = $aisle,
                    ShelfCode = $code,
                    IsActive = $active
                WHERE ShelfID = $id
            ";

            $conn->exec($sql);

            addAudit(
                $conn,
                null,
                "UPDATE",
                "Shelf",
                "Updated shelf ID: " . $id
            );

            response(
                true,
                "Shelf updated successfully."
            );

            break;


        case "deleteShelf":

            $id = (int)($data["ShelfID"] ?? 0);

            $sql = "
                DELETE FROM Shelf
                WHERE ShelfID = $id
            ";

            $conn->exec($sql);

            addAudit(
                $conn,
                null,
                "DELETE",
                "Shelf",
                "Deleted shelf ID: " . $id
            );

            response(
                true,
                "Shelf deleted successfully."
            );

            break;


        case "getBins":

            $search = $data["search"] ?? "";
            $search = $conn->quote("%" . $search . "%");

            $sql = "
                SELECT
                    b.BinID,
                    b.ShelfID,
                    s.ShelfCode,
                    b.BinCode,
                    b.IsActive
                FROM Bin b
                INNER JOIN Shelf s
                    ON b.ShelfID = s.ShelfID
                WHERE
                    b.BinCode LIKE $search
                    OR s.ShelfCode LIKE $search
                ORDER BY b.BinID DESC
            ";

            $stmt = $conn->query($sql);

            response(
                true,
                "Bins retrieved successfully.",
                $stmt->fetchAll(PDO::FETCH_ASSOC)
            );

            break;


        case "getBin":

            $id = (int)($data["BinID"] ?? 0);

            $sql = "
                SELECT *
                FROM Bin
                WHERE BinID = $id
            ";

            $stmt = $conn->query($sql);

            $bin = $stmt->fetch(PDO::FETCH_ASSOC);

            response(
                true,
                "Bin retrieved successfully.",
                $bin
            );

            break;


        case "insertBin":

            $shelf = (int)($data["ShelfID"] ?? 0);
            $code = $conn->quote($data["BinCode"] ?? "");
            $active = (int)($data["IsActive"] ?? 1);

            $sql = "
                INSERT INTO Bin
                (
                    ShelfID,
                    BinCode,
                    IsActive
                )
                VALUES
                (
                    $shelf,
                    $code,
                    $active
                )
            ";

            $conn->exec($sql);

            addAudit(
                $conn,
                null,
                "CREATE",
                "Bin",
                "Created bin: " . ($data["BinCode"] ?? "")
            );

            response(
                true,
                "Bin created successfully."
            );

            break;


        case "updateBin":

            $id = (int)($data["BinID"] ?? 0);
            $shelf = (int)($data["ShelfID"] ?? 0);
            $code = $conn->quote($data["BinCode"] ?? "");
            $active = (int)($data["IsActive"] ?? 1);

            $sql = "
                UPDATE Bin
                SET
                    ShelfID = $shelf,
                    BinCode = $code,
                    IsActive = $active
                WHERE BinID = $id
            ";

            $conn->exec($sql);

            addAudit(
                $conn,
                null,
                "UPDATE",
                "Bin",
                "Updated bin ID: " . $id
            );

            response(
                true,
                "Bin updated successfully."
            );

            break;


        case "deleteBin":

            $id = (int)($data["BinID"] ?? 0);

            $sql = "
                DELETE FROM Bin
                WHERE BinID = $id
            ";

            $conn->exec($sql);

            addAudit(
                $conn,
                null,
                "DELETE",
                "Bin",
                "Deleted bin ID: " . $id
            );

            response(
                true,
                "Bin deleted successfully."
            );

            break;


        case "getProducts":

            $search = $data["search"] ?? "";
            $search = $conn->quote("%" . $search . "%");

            $sql = "
                SELECT
                    p.*,
                    c.CategoryName,
                    b.BinCode
                FROM Product p
                LEFT JOIN Category c
                    ON p.CategoryID = c.CategoryID
                LEFT JOIN Bin b
                    ON p.BinID = b.BinID
                WHERE
                    p.SKU LIKE $search
                    OR p.Barcode LIKE $search
                    OR p.ProductName LIKE $search
                    OR p.Description LIKE $search
                    OR c.CategoryName LIKE $search
                    OR b.BinCode LIKE $search
                ORDER BY p.ProductID DESC
            ";

            $stmt = $conn->query($sql);

            response(
                true,
                "Products retrieved successfully.",
                $stmt->fetchAll(PDO::FETCH_ASSOC)
            );

            break;


        case "getProduct":

            $id = (int)($data["ProductID"] ?? 0);

            $sql = "
                SELECT
                    p.*,
                    c.CategoryName,
                    b.BinCode
                FROM Product p
                LEFT JOIN Category c
                    ON p.CategoryID = c.CategoryID
                LEFT JOIN Bin b
                    ON p.BinID = b.BinID
                WHERE p.ProductID = $id
            ";

            $stmt = $conn->query($sql);

            $product = $stmt->fetch(PDO::FETCH_ASSOC);

            response(
                true,
                "Product retrieved successfully.",
                $product
            );

            break;


        case "insertProduct":

            $sku = $conn->quote($data["SKU"] ?? "");
            $barcode = $conn->quote($data["Barcode"] ?? "");
            $name = $conn->quote($data["ProductName"] ?? "");
            $description = $conn->quote($data["Description"] ?? "");
            $unit = $conn->quote($data["UnitOfMeasure"] ?? "");
            $minStock = (int)($data["MinStockLevel"] ?? 0);
            $bin = (int)($data["BinID"] ?? 0);
            $category = (int)($data["CategoryID"] ?? 0);
            $active = (int)($data["IsActive"] ?? 1);

            $sql = "
                INSERT INTO Product
                (
                    SKU,
                    Barcode,
                    ProductName,
                    Description,
                    UnitOfMeasure,
                    MinStockLevel,
                    BinID,
                    CategoryID,
                    IsActive
                )
                VALUES
                (
                    $sku,
                    $barcode,
                    $name,
                    $description,
                    $unit,
                    $minStock,
                    $bin,
                    $category,
                    $active
                )
            ";

            $conn->exec($sql);

            addAudit(
                $conn,
                null,
                "CREATE",
                "Product",
                "Created product: " . ($data["ProductName"] ?? "")
            );

            response(
                true,
                "Product created successfully."
            );

            break;


        case "updateProduct":

            $id = (int)($data["ProductID"] ?? 0);
            $sku = $conn->quote($data["SKU"] ?? "");
            $barcode = $conn->quote($data["Barcode"] ?? "");
            $name = $conn->quote($data["ProductName"] ?? "");
            $description = $conn->quote($data["Description"] ?? "");
            $unit = $conn->quote($data["UnitOfMeasure"] ?? "");
            $minStock = (int)($data["MinStockLevel"] ?? 0);
            $bin = (int)($data["BinID"] ?? 0);
            $category = (int)($data["CategoryID"] ?? 0);
            $active = (int)($data["IsActive"] ?? 1);

            $sql = "
                UPDATE Product
                SET
                    SKU = $sku,
                    Barcode = $barcode,
                    ProductName = $name,
                    Description = $description,
                    UnitOfMeasure = $unit,
                    MinStockLevel = $minStock,
                    BinID = $bin,
                    CategoryID = $category,
                    IsActive = $active
                WHERE ProductID = $id
            ";

            $conn->exec($sql);

            addAudit(
                $conn,
                null,
                "UPDATE",
                "Product",
                "Updated product ID: " . $id
            );

            response(
                true,
                "Product updated successfully."
            );

            break;


        case "deleteProduct":

            $id = (int)($data["ProductID"] ?? 0);

            $sql = "
                DELETE FROM Product
                WHERE ProductID = $id
            ";

            $conn->exec($sql);

            addAudit(
                $conn,
                null,
                "DELETE",
                "Product",
                "Deleted product ID: " . $id
            );

            response(
                true,
                "Product deleted successfully."
            );

            break;


        case "getUsers":

            $search = $data["search"] ?? "";
            $search = $conn->quote("%" . $search . "%");

            $sql = "
                SELECT
                    u.UserID,
                    u.UserName,
                    u.FirstName,
                    u.LastName,
                    u.Email,
                    u.RoleID,
                    r.RoleName,
                    u.UserStatus
                FROM `User` u
                LEFT JOIN Role r
                    ON u.RoleID = r.RoleID
                WHERE
                    u.UserName LIKE $search
                    OR u.FirstName LIKE $search
                    OR u.LastName LIKE $search
                    OR u.Email LIKE $search
                    OR r.RoleName LIKE $search
                    OR u.UserStatus LIKE $search
                ORDER BY u.UserID DESC
            ";

            $stmt = $conn->query($sql);

            response(
                true,
                "Users retrieved successfully.",
                $stmt->fetchAll(PDO::FETCH_ASSOC)
            );

            break;


        case "getUser":

            $id = (int)($data["UserID"] ?? 0);

            $sql = "
                SELECT
                    u.UserID,
                    u.UserName,
                    u.FirstName,
                    u.LastName,
                    u.Email,
                    u.RoleID,
                    r.RoleName,
                    u.UserStatus
                FROM `User` u
                LEFT JOIN Role r
                    ON u.RoleID = r.RoleID
                WHERE u.UserID = $id
            ";

            $stmt = $conn->query($sql);

            $user = $stmt->fetch(PDO::FETCH_ASSOC);

            response(
                true,
                "User retrieved successfully.",
                $user
            );

            break;


        case "insertUser":

            $username = $conn->quote(
                $data["UserName"] ?? ""
            );

            $plainPassword = $data["Password"] ?? "";

            if ($plainPassword == "") {

                response(
                    false,
                    "Password is required."
                );

            }

            $hashedPassword = password_hash(
                $plainPassword,
                PASSWORD_DEFAULT
            );

            $password = $conn->quote(
                $hashedPassword
            );

            $firstName = $conn->quote(
                $data["FirstName"] ?? ""
            );

            $lastName = $conn->quote(
                $data["LastName"] ?? ""
            );

            $email = $conn->quote(
                $data["Email"] ?? ""
            );

            $role = (int)($data["RoleID"] ?? 0);

            $status = $conn->quote(
                $data["UserStatus"] ?? "Active"
            );

            $sql = "
                INSERT INTO `User`
                (
                    UserName,
                    Password,
                    FirstName,
                    LastName,
                    Email,
                    RoleID,
                    UserStatus
                )
                VALUES
                (
                    $username,
                    $password,
                    $firstName,
                    $lastName,
                    $email,
                    $role,
                    $status
                )
            ";

            $conn->exec($sql);

            addAudit(
                $conn,
                null,
                "CREATE",
                "User",
                "Created user: " . ($data["UserName"] ?? "")
            );

            response(
                true,
                "User created successfully."
            );

            break;


        case "updateUser":

            $id = (int)($data["UserID"] ?? 0);

            $username = $conn->quote(
                $data["UserName"] ?? ""
            );

            $firstName = $conn->quote(
                $data["FirstName"] ?? ""
            );

            $lastName = $conn->quote(
                $data["LastName"] ?? ""
            );

            $email = $conn->quote(
                $data["Email"] ?? ""
            );

            $role = (int)($data["RoleID"] ?? 0);

            $status = $conn->quote(
                $data["UserStatus"] ?? "Active"
            );

            $plainPassword = $data["Password"] ?? "";

            if ($plainPassword != "") {

                $hashedPassword = password_hash(
                    $plainPassword,
                    PASSWORD_DEFAULT
                );

                $password = $conn->quote(
                    $hashedPassword
                );

                $sql = "
                    UPDATE `User`
                    SET
                        UserName = $username,
                        Password = $password,
                        FirstName = $firstName,
                        LastName = $lastName,
                        Email = $email,
                        RoleID = $role,
                        UserStatus = $status
                    WHERE UserID = $id
                ";

            } else {

                $sql = "
                    UPDATE `User`
                    SET
                        UserName = $username,
                        FirstName = $firstName,
                        LastName = $lastName,
                        Email = $email,
                        RoleID = $role,
                        UserStatus = $status
                    WHERE UserID = $id
                ";

            }

            $conn->exec($sql);

            addAudit(
                $conn,
                null,
                "UPDATE",
                "User",
                "Updated user ID: " . $id
            );

            response(
                true,
                "User updated successfully."
            );

            break;


        case "deleteUser":

            $id = (int)($data["UserID"] ?? 0);

            $sql = "
                DELETE FROM `User`
                WHERE UserID = $id
            ";

            $conn->exec($sql);

            addAudit(
                $conn,
                null,
                "DELETE",
                "User",
                "Deleted user ID: " . $id
            );

            response(
                true,
                "User deleted successfully."
            );

            break;


        case "toggleUserStatus":

            $id = (int)($data["UserID"] ?? 0);

            $status = $conn->quote(
                $data["UserStatus"] ?? "Active"
            );

            $sql = "
                UPDATE `User`
                SET UserStatus = $status
                WHERE UserID = $id
            ";

            $conn->exec($sql);

            addAudit(
                $conn,
                null,
                "STATUS CHANGE",
                "User",
                "Changed user ID "
                . $id
                . " status to "
                . ($data["UserStatus"] ?? "")
            );

            response(
                true,
                "User status updated successfully."
            );

            break;


        case "getAuditLogs":

            $search = $data["search"] ?? "";
            $search = $conn->quote(
                "%" . $search . "%"
            );

            $sql = "
                SELECT
                    a.AuditLogID,
                    a.UserID,
                    u.UserName,
                    a.ActionType,
                    a.TableAffected,
                    a.ActionTimestamp,
                    a.Details
                FROM AuditLog a
                LEFT JOIN `User` u
                    ON a.UserID = u.UserID
                WHERE
                    a.ActionType LIKE $search
                    OR a.TableAffected LIKE $search
                    OR a.Details LIKE $search
                    OR u.UserName LIKE $search
                ORDER BY a.AuditLogID DESC
            ";

            $stmt = $conn->query($sql);

            response(
                true,
                "Audit logs retrieved successfully.",
                $stmt->fetchAll(PDO::FETCH_ASSOC)
            );

            break;


        default:

            response(
                false,
                "Invalid operation."
            );

            break;
    }

} catch (PDOException $e) {

    response(
        false,
        "Database error: " . $e->getMessage()
    );

} catch (Exception $e) {

    response(
        false,
        "Server error: " . $e->getMessage()
    );

}

?>