<%-- 
    Document   : login
    Created on : Jun 11, 2025, 5:23:39 AM
    Author     : syousrei
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            background: url('jsp/images/wallpaper.jpeg') no-repeat center center fixed;
            background-size: cover;
            height: 100vh;
            display: flex;
            justify-content: flex-end;
            align-items: center;
            padding-right: 10%;
            background-color: #0b1033;
            overflow: hidden;
        }

        .login-container {
            background: rgba(255, 255, 255, 0.07);
            backdrop-filter: blur(10px);
            padding: 50px 60px;
            border-radius: 20px;
            width: 400px; /* ← زودت العرض */
            height: 400px;
            color: white;
            box-shadow: 0 0 20px rgba(255, 255, 255, 0.1);
        }

        .login-container h2 {
            margin-bottom: 25px;
            text-align: center;
            font-size: 28px;
        }

        label {
            display: block;
            margin-top: 15px;
            margin-bottom: 5px;
            font-size: 14px;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.2);
            color: white;
        }

        input::placeholder {
            color: #ccc;
        }

        .forgot {
            display: block;
            text-align: left;
            font-size: 12px;
            margin-top: 10px;
            margin-bottom: 10px;
            color: #aad;
            text-decoration: none;
        }

        .btn-login {
        width: 100%;
        background: linear-gradient(135deg, #007BFF, #8A2BE2); /* أزرق → بنفسجي */
        color: white;
        padding: 12px;
        border: none;
        border-radius: 8px;
        font-weight: bold;
        cursor: pointer;
        margin-top: 15px;
        transition: background 0.3s ease;
    }

    .btn-login:hover {
        background: linear-gradient(135deg, #0056b3, #6a1bbf); /* لون أغمق عند التحويم */
    }


 
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Sign In</h2>
        <form action="testLogin" method="post">
            <label for="username">Admin Username</label>
            <input type="text" name="username" id="username" placeholder="Enter your username" required>

            <label for="password">Admin Password</label>
            <input type="password" name="password" id="password" placeholder="Password" required>

            <a class="forgot" href="#">Forgot password?</a>
            <button class="btn-login" type="submit">SIGN IN</button>
        </form>
    </div>
</body>
</html>
