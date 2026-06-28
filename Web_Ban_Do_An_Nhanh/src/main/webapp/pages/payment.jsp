<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>BiteSync | Thanh Toán Trực Tuyến</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .payment-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }
        .payment-card {
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
        .payment-card h2 {
            font-size: 1.8rem;
            font-weight: 700;
            margin-bottom: 8px;
            color: var(--text-primary);
        }
        .payment-card p {
            color: var(--text-secondary);
            font-size: 0.95rem;
            margin-bottom: 24px;
        }
        .qr-code-box {
            background: white;
            padding: 16px;
            border-radius: var(--radius-md);
            display: inline-block;
            margin-bottom: 24px;
            border: 1px solid var(--border-glass);
        }
        .qr-code-img {
            width: 200px;
            height: 200px;
            object-fit: contain;
        }
        .amount-highlight {
            font-size: 2rem;
            font-weight: 800;
            color: var(--color-orange);
            margin-bottom: 24px;
        }
        .bank-details {
            background: rgba(10, 10, 15, 0.4);
            border: 1px solid var(--border-glass);
            padding: 20px;
            border-radius: var(--radius-md);
            margin-bottom: 32px;
            text-align: left;
        }
        .detail-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 0.9rem;
        }
        .detail-row:last-child {
            margin-bottom: 0;
        }
        .detail-row span:first-child {
            color: var(--text-secondary);
        }
        .detail-row span:last-child {
            color: var(--text-primary);
            font-weight: 600;
        }
        .btn-payment-group {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        .btn-payment {
            width: 100%;
            padding: 14px;
            border-radius: 30px;
            font-weight: 700;
            font-size: 0.95rem;
            text-align: center;
            display: block;
            text-decoration: none;
        }
    </style>
</head>
<body>

    <div class="payment-wrapper">
        <div class="payment-card">
            <h2>Quét Mã Thanh Toán</h2>
            <p>Vui lòng quét mã QR dưới đây hoặc chuyển khoản theo thông tin chi tiết để hoàn tất đơn hàng.</p>

            <div class="qr-code-box">
                <!-- Fallback to a mock QR code image -->
                <img class="qr-code-img" src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=BiteSync_Order_${param.orderId}_Total_${param.total}" alt="Mã QR thanh toán">
            </div>

            <div class="amount-highlight">
                $${param.total}
            </div>

            <div class="bank-details">
                <div class="detail-row">
                    <span>Ngân Hàng:</span>
                    <span>PAYPAL / VIETCOMBANK</span>
                </div>
                <div class="detail-row">
                    <span>Số Tài Khoản:</span>
                    <span>1234567890</span>
                </div>
                <div class="detail-row">
                    <span>Tên Tài Khoản:</span>
                    <span>BITESYNC FAST FOOD</span>
                </div>
                <div class="detail-row">
                    <span>Nội Dung:</span>
                    <span style="color: var(--color-orange);">BITESYNC ${param.orderId}</span>
                </div>
            </div>

            <div class="btn-payment-group">
                <a href="${pageContext.request.contextPath}/checkout/confirm-payment?orderId=${param.orderId}" class="btn-primary btn-payment">Xác Nhận Đã Chuyển Khoản</a>
                <a href="${pageContext.request.contextPath}/home" class="btn-secondary btn-payment" style="background: none; border: 1px solid var(--border-glass); color: var(--text-secondary);">Hủy và Quay Lại</a>
            </div>
        </div>
    </div>

</body>
</html>
