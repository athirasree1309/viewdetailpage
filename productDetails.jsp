<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>

<%
    HttpSession httpSession = request.getSession();
    if (httpSession == null || httpSession.getAttribute("user") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String user = (String) httpSession.getAttribute("user");
%>
<%
    // JDBC driver name and database URL
    String JDBC_DRIVER = "com.mysql.jdbc.Driver";
    String DB_URL = "jdbc:mysql://localhost:3306/ultras";

    // Database credentials
    String USER = "root";
    String PASS = "";

    Connection con = null;
    Statement stmt = null;
    ResultSet rs = null;

    // Get the product ID from the request
    String productId = request.getParameter("id");

    // Initialize product details variables
    String productName = "";
    String imageUrl = "";
    String price = "";
    String specification = ""; // Add a specification field

    try {
        // Register JDBC driver
        Class.forName(JDBC_DRIVER);

        // Open a connection
        con = DriverManager.getConnection(DB_URL, USER, PASS);

        // Execute a query to get product details
        stmt = con.createStatement();
        String sql = "SELECT * FROM products WHERE id=" + productId;
        rs = stmt.executeQuery(sql);

        // Process the result set
        if (rs.next()) {
            // Retrieve by column name
            productName = rs.getString("name");
            imageUrl = rs.getString("image");
            price = rs.getString("price");
            specification = rs.getString("specification"); // Assuming there's a specification column
        }
    } catch (SQLException se) {
        // Handle errors for JDBC
        se.printStackTrace();
    } catch (Exception e) {
        // Handle errors for Class.forName
        e.printStackTrace();
    } finally {
        // Finally block to close resources
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (con != null) con.close();
        } catch (SQLException se) {
            se.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title><i>Weave Wardrobe</i></title>
<!-- Bootstrap CSS -->
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
<style>
    .product-details {
        margin-top: 20px;
        margin-bottom: 20px;
    }

    .product-image {
        display: flex;
        justify-content: center;
        align-items: center;
        max-width: 50%;
        height: 500px;
        overflow: hidden;
        margin: 0 auto; /* Center the image container */
    }

    .product-image img {
        object-fit: cover;
        width: 70%;
        height: 100%;
    }

    .product-name {
        font-size: 24px; /* Change the font size to your desired size */
        font-weight: bold; /* Make the font bold */
        text-align: center; /* Center the text */
    }

    .product-price {
        font-size: 18px; /* Change the font size to your desired size */
        font-weight: bold; /* Make the font bold */
    }

    .product-spec {
        font-size: 18px; /* Change the font size to your desired size */
        font-weight: 300; /* Make the font bold */
    }

    .size-button {
        border: 2px solid #ddd;
        border-radius: 5px;
        padding: 10px;
        margin: 5px;
        cursor: pointer;
        text-align: center;
        background-color: #f8f9fa;
        transition: background-color 0.3s, border-color 0.3s;
    }

    .size-button.selected {
        background-color: #007bff;
        color: #fff;
        border-color: #007bff;
    }

    .size-chart {
        display: flex;
        justify-content: center;
        flex-wrap: wrap;
    }
</style>
</head>
<body>
<div class="container">
    <div class="product-details">
        <h3 class="product-name"><%=productName%></h3>
        <div class="product-image">
            <img src="<%=imageUrl%>" alt="<%=productName%> Image">
        </div>
        <p class="product-price">Price: &#8360; <%=price%></p>
        <p class="product-spec">Specification: <%=specification%></p>
        <button class="btn btn-dark" data-toggle="modal" data-target="#sizeChartModal">Add to Cart</button>
    </div>
</div>

<!-- Size Chart Modal -->
<div class="modal fade" id="sizeChartModal" tabindex="-1" role="dialog" aria-labelledby="sizeChartModalLabel" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="sizeChartModalLabel">Select Size</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        <form id="cartForm" action="addtocart.jsp" method="post">
            <input type="hidden" name="productId" value="<%=productId%>">
            <div class="size-chart">
                <div class="size-button" data-size="S">S</div>
                <div class="size-button" data-size="M">M</div>
                <div class="size-button" data-size="L">L</div>
                <div class="size-button" data-size="XL">XL</div>
                <div class="size-button" data-size="XXL">XXL</div>
            </div>
            <input type="hidden" name="size" id="selectedSize" required>
            <button type="submit" class="btn btn-danger mt-3">Add to Cart</button>
        </form>
      </div>
    </div>
  </div>
</div>

<!-- Bootstrap JavaScript (optional) -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.3/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script>
    // JavaScript to handle size selection
    document.addEventListener('DOMContentLoaded', function() {
        const sizeButtons = document.querySelectorAll('.size-button');
        const selectedSizeInput = document.getElementById('selectedSize');

        sizeButtons.forEach(button => {
            button.addEventListener('click', function() {
                // Remove selected class from all buttons
                sizeButtons.forEach(btn => btn.classList.remove('selected'));
                // Add selected class to the clicked button
                this.classList.add('selected');
                // Set the selected size in the hidden input field
                selectedSizeInput.value = this.getAttribute('data-size');
            });
        });
    });
</script>
</body>
</html>
