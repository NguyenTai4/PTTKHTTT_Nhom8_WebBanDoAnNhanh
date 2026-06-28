<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BiteSync | Đặt Hàng Thành Công</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .success-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }
        .success-card {
            background: var(--bg-glass);
            border: 1px solid var(--border-glass);
            border-radius: var(--radius-lg);
            width: 100%;
            max-width: 500px;
            padding: 40px;
            text-align: center;
            backdrop-filter: blur(20px);
            box-shadow: var(--shadow-lg);
        }
        .success-icon {
            font-size: 4.5rem;
            color: #2ecc71;
            margin-bottom: 24px;
            animation: scaleIn 0.5s ease-out;
        }
        .success-card h2 {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 12px;
            color: var(--text-primary);
        }
        .success-card p {
            color: var(--text-secondary);
            font-size: 0.95rem;
            line-height: 1.6;
            margin-bottom: 24px;
        }
        .order-info-box {
            background: rgba(10, 10, 15, 0.4);
            border: 1px solid var(--border-glass);
            padding: 20px;
            border-radius: var(--radius-md);
            margin-bottom: 32px;
            text-align: left;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 0.9rem;
        }
        .info-row:last-child {
            margin-bottom: 0;
            border-top: 1px solid var(--border-glass);
            padding-top: 12px;
            font-weight: 700;
            font-size: 1rem;
        }
        .info-row span:first-child {
            color: var(--text-secondary);
        }
        .info-row span:last-child {
            color: var(--text-primary);
        }
        .btn-success-group {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .btn-success {
            width: 100%;
            padding: 14px;
            border-radius: 30px;
            font-weight: 700;
            font-size: 0.95rem;
            text-align: center;
            display: block;
            text-decoration: none;
            transition: var(--transition-fast);
        }
        @keyframes scaleIn {
            0% { transform: scale(0); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }
    </style>
</head>
<body>

    <div class="success-wrapper">
        <div class="success-card">
            <i class="fa-solid fa-circle-check success-icon"></i>
            <h2>Đặt Hàng Thành Công!</h2>
            <p>Cảm ơn bạn đã lựa chọn BiteSync. Đơn hàng của bạn đã được xác nhận và đang trong quá trình chuẩn bị.</p>

            <div class="order-info-box">
                <div class="info-row">
                    <span>Mã Đơn Hàng:</span>
                    <span>#${param.orderId}</span>
                </div>
                <div class="info-row">
                    <span>Phương Thức:</span>
                    <span>Thanh toán khi nhận hàng (COD)</span>
                </div>
                <div class="info-row">
                    <span>Trạng Thái:</span>
                    <span style="color: #f1c40f;">Chờ giao hàng</span>
                </div>
            </div>

            <div class="btn-success-group">
                <a href="${pageContext.request.contextPath}/home" class="btn-primary btn-success">Quay lại Trang Chủ</a>
            </div>
        </div>
    </div>

</body>
</html>
