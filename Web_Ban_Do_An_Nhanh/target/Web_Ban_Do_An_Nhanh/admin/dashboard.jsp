<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BiteSync | Admin Dashboard</title>
    
    <!-- Custom Style Sheet -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* Specific admin adjustments on top of base styles */
        .admin-layout {
            display: grid;
            grid-template-columns: 240px 1fr;
            min-height: 100vh;
            padding-top: 80px;
        }
        
        .sidebar {
            background: var(--bg-secondary);
            border-right: 1px solid var(--border-glass);
            padding: 24px;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        
        .sidebar-link {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            color: var(--text-secondary);
            text-decoration: none;
            border-radius: var(--radius-sm);
            font-weight: 500;
            transition: var(--transition-fast);
        }
        
        .sidebar-link:hover, .sidebar-link.active {
            background: var(--bg-glass-hover);
            color: var(--text-primary);
        }
        
        .sidebar-link.active {
            border-left: 3px solid var(--color-orange);
            background: rgba(255, 94, 54, 0.1);
        }
        
        .admin-content {
            padding: 40px;
            overflow-y: auto;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 24px;
            margin-bottom: 40px;
        }
        
        .stat-card {
            background: var(--bg-glass);
            border: 1px solid var(--border-glass);
            border-radius: var(--radius-md);
            padding: 24px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .stat-info h3 {
            font-size: 1.8rem;
            font-weight: 700;
            margin-top: 4px;
        }
        
        .stat-info p {
            color: var(--text-secondary);
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .stat-icon {
            font-size: 2rem;
            color: var(--color-orange);
            opacity: 0.8;
        }
        
        .data-table-container {
            background: var(--bg-glass);
            border: 1px solid var(--border-glass);
            border-radius: var(--radius-lg);
            padding: 24px;
            backdrop-filter: blur(12px);
        }
        
        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .admin-table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }
        
        .admin-table th, .admin-table td {
            padding: 16px;
            border-bottom: 1px solid var(--border-glass);
        }
        
        .admin-table th {
            color: var(--text-muted);
            font-size: 0.85rem;
            text-transform: uppercase;
            font-weight: 600;
        }
        
        .admin-table td {
            font-size: 0.9rem;
            color: var(--text-secondary);
        }
        
        .admin-table tr:hover td {
            color: var(--text-primary);
            background: rgba(255, 255, 255, 0.01);
        }
        
        .status-badge {
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        
        .status-badge.pending {
            background: rgba(255, 138, 0, 0.15);
            color: var(--color-orange);
            border: 1px solid rgba(255, 138, 0, 0.3);
        }
        
        .status-badge.completed {
            background: rgba(46, 213, 115, 0.15);
            color: #2ed573;
            border: 1px solid rgba(46, 213, 115, 0.3);
        }
    </style>
</head>
<body>

    <!-- Header / Navigation Bar -->
    <header>
        <div class="container nav-container" style="max-width: 100%; padding: 0 40px;">
            <a href="${pageContext.request.contextPath}/home" class="logo">
                <i class="fa-solid fa-fire-flame-curved"></i> BiteSync <span style="font-size: 0.9rem; font-weight: 400; color: var(--text-secondary); margin-left: 8px;">| Bảng Điều Khiển Admin</span>
            </a>
            
            <div class="nav-actions">
                <a href="${pageContext.request.contextPath}/home" class="btn-secondary">
                    <i class="fa-solid fa-arrow-left"></i> Quay lại Web chính
                </a>
            </div>
        </div>
    </header>

    <!-- Admin Grid Layout -->
    <div class="admin-layout">
        <!-- Sidebar Navigation -->
        <aside class="sidebar">
            <a href="#" class="sidebar-link active">
                <i class="fa-solid fa-chart-pie"></i> Tổng quan
            </a>
            <a href="#" class="sidebar-link">
                <i class="fa-solid fa-burger"></i> Quản lý món ăn
            </a>
            <a href="#" class="sidebar-link">
                <i class="fa-solid fa-receipt"></i> Quản lý đơn hàng
            </a>
            <a href="#" class="sidebar-link">
                <i class="fa-solid fa-users"></i> Người dùng
            </a>
            <a href="#" class="sidebar-link">
                <i class="fa-solid fa-gear"></i> Cấu hình
            </a>
        </aside>

        <!-- Admin Content -->
        <main class="admin-content">
            <div style="margin-bottom: 32px;">
                <h2 style="font-size: 1.8rem; font-weight: 700;">Hôm nay thế nào rồi?</h2>
                <p style="color: var(--text-secondary);">Thống kê hoạt động của cửa hàng BiteSync hôm nay.</p>
            </div>
            
            <!-- Quick Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-info">
                        <p>Doanh Thu</p>
                        <h3>$1,248.50</h3>
                    </div>
                    <div class="stat-icon"><i class="fa-solid fa-wallet"></i></div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-info">
                        <p>Đơn Hàng Mới</p>
                        <h3>48</h3>
                    </div>
                    <div class="stat-icon"><i class="fa-solid fa-cart-shopping"></i></div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-info">
                        <p>Khách Hàng</p>
                        <h3>320</h3>
                    </div>
                    <div class="stat-icon"><i class="fa-solid fa-user-group"></i></div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-info">
                        <p>Chưa Xử Lý</p>
                        <h3>7</h3>
                    </div>
                    <div class="stat-icon"><i class="fa-solid fa-clock"></i></div>
                </div>
            </div>
            
            <!-- Recent Orders Table -->
            <div class="data-table-container">
                <div class="table-header">
                    <h3 style="font-weight: 700;">Đơn Hàng Gần Đây</h3>
                    <button class="btn-primary" style="padding: 8px 16px; font-size: 0.8rem;">Xem tất cả</button>
                </div>
                
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>Mã Đơn</th>
                            <th>Khách Hàng</th>
                            <th>Chi Tiết Món Ăn</th>
                            <th>Tổng Tiền</th>
                            <th>Trạng Thái</th>
                            <th>Hành Động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>#1024</td>
                            <td>Nguyễn Văn A</td>
                            <td>1x Double Cheese Burger, 1x Fries</td>
                            <td>$9.48</td>
                            <td><span class="status-badge pending">Đang chờ</span></td>
                            <td>
                                <button class="btn-icon" style="width: 32px; height: 32px;" title="Xử lý"><i class="fa-solid fa-check"></i></button>
                            </td>
                        </tr>
                        <tr>
                            <td>#1023</td>
                            <td>Trần Thị B</td>
                            <td>1x Pepperoni Pizza, 2x Milkshake</td>
                            <td>$14.97</td>
                            <td><span class="status-badge completed">Đã hoàn thành</span></td>
                            <td>
                                <button class="btn-icon" style="width: 32px; height: 32px; opacity: 0.5; cursor: not-allowed;" disabled><i class="fa-solid fa-check"></i></button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

</body>
</html>
