<%-- 
    Document   : Editor
    Created on : Jun 5, 2025, 7:32:46 AM
    Author     : mibrahim
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>VoxRoute - User Management</title>
<style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }
        .container {
            display: flex;
            min-height: 100vh;
        }
        .sidebar {
            width: 200px;
            background-color: #2c3e50;
            color: white;
            padding: 20px 0;
        }
        .sidebar-header {
            padding: 0 20px 20px 20px;
            font-size: 20px;
            font-weight: bold;
            border-bottom: 1px solid #34495e;
            margin-bottom: 20px;
        }
        .sidebar-menu {
            list-style-type: none;
            padding: 0;
            margin: 0;
        }
        .sidebar-menu li {
            padding: 10px 20px;
            cursor: pointer;
        }
        .sidebar-menu li:hover {
            background-color: #34495e;
        }
        .main-content {
            flex: 1;
            padding: 20px;
        }
        h1 {
            color: #2c3e50;
            margin-top: 0;
        }
        h2 {
            color: #3498db;
            margin-top: 30px;
        }
        h3 {
            color: #7f8c8d;
        }
        .card {
            background-color: white;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            padding: 15px;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 12px 15px;
            text-align: left;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
            font-weight: bold;
        }
        tr:hover {
            background-color: #f5f5f5;
        }
        .status-active {
            color: #27ae60;
        }
        .status-inactive {
            color: #e74c3c;
        }
        .action-btn {
            cursor: pointer;
            font-size: 18px;
            margin-right: 10px;
        }
        hr {
            border: 0;
            height: 1px;
            background-color: #ddd;
            margin: 30px 0;
        }
</style>
</head>
<body>
<div class="container">
<div class="sidebar">
<div class="sidebar-header">VoxRoute</div>
<ul class="sidebar-menu">
<li>Home</li>
<li>Dashboard</li>
<li>Users</li>
<li>VXML Files</li>
<li>VXML Editor</li>
<li>Add Services</li>
</ul>
</div>
<div class="main-content">
<h1>VoxRoute</h1>
<h2>Home</h2>
<h3>Dashboard</h3>
<ul>
<li>Users</li>
<li>VXML Files</li>
<li>VXML Editor</li>
<li>Add Services</li>
</ul>
<hr>
<h2>User Management</h2>
<div class="card">
<h3>All Users</h3>
<p>Manage your user accounts</p>
</div>
<table>
<thead>
<tr>
<th>User Name</th>
<th>MSISDN</th>
<th>Balance</th>
<th>Service Name</th>
<th>Status</th>
<th>Actions</th>
</tr>
</thead>
<tbody>
<tr>
<td>John Smith</td>
<td>+1234567890</td>
<td>$125.50</td>
<td>Premium Plan</td>
<td class="status-active">active</td>
<td>
<span class="action-btn">☑</span>
<span class="action-btn">☐</span>
</td>
</tr>
<tr>
<td>Sarah Johnson</td>
<td>+1234567891</td>
<td>$89.25</td>
<td>Basic Plan</td>
<td class="status-inactive">inactive</td>
<td>
<span class="action-btn">☑</span>
<span class="action-btn">☐</span>
</td>
</tr>
<tr>
<td>Mike Wilson</td>
<td>+1234567892</td>
<td>$200.00</td>
<td>Enterprise Plan</td>
<td class="status-active">active</td>
<td>
<span class="action-btn">☑</span>
<span class="action-btn">☐</span>
</td>
</tr>
<tr>
<td>Emily Davis</td>
<td>+1234567893</td>
<td>$45.75</td>
<td>Standard Plan</td>
<td class="status-active">active</td>
<td>
<span class="action-btn">☑</span>
<span class="action-btn">☐</span>
</td>
</tr>
<tr>
<td>David Brown</td>
<td>+1234567894</td>
<td>$0.00</td>
<td>Basic Plan</td>
<td class="status-inactive">inactive</td>
<td>
<span class="action-btn">☑</span>
<span class="action-btn">☐</span>
</td>
</tr>
</tbody>
</table>
</div>
</div>
</body>
</html>
