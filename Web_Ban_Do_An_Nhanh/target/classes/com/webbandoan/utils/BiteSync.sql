-- 1. TẠO BẢNG DANH MỤC (Không phụ thuộc khóa ngoại)
CREATE TABLE `categories` (
                              `id` int NOT NULL AUTO_INCREMENT,
                              `name` varchar(100) NOT NULL,
                              `code_name` varchar(100) NOT NULL,
                              `icon_class` varchar(100) DEFAULT NULL,
                              `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                              PRIMARY KEY (`id`),
                              UNIQUE KEY `code_name` (`code_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `categories` VALUES
                             (1, 'Burgers', 'Burgers', 'fa-hamburger', '2026-06-26 00:40:23'),
                             (2, 'Pizzas', 'Pizzas', 'fa-pizza-slice', '2026-06-26 00:40:23'),
                             (3, 'Món Phụ', 'Sides', 'fa-cookie', '2026-06-26 00:40:23'),
                             (4, 'Đồ Uống', 'Drinks', 'fa-glass-water', '2026-06-26 00:40:23'),
                             (5, 'Tráng Miệng', 'Desserts', 'fa-ice-cream', '2026-06-26 00:40:23');


-- 2. TẠO BẢNG NGƯỜI DÙNG (Không phụ thuộc khóa ngoại)
CREATE TABLE `users` (
                         `id` int NOT NULL AUTO_INCREMENT,
                         `username` varchar(50) NOT NULL,
                         `email` varchar(100) NOT NULL,
                         `phone` varchar(20) DEFAULT NULL,
                         `password` varchar(255) NOT NULL,
                         `fullname` varchar(100) NOT NULL,
                         `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                         PRIMARY KEY (`id`),
                         UNIQUE KEY `username` (`username`),
                         UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. TẠO BẢNG MÓN ĂN (Phụ thuộc categories)
CREATE TABLE `foods` (
                         `id` int NOT NULL AUTO_INCREMENT,
                         `name` varchar(255) NOT NULL,
                         `description` text,
                         `price` decimal(10, 2) NOT NULL,
                         `image_url` varchar(500) DEFAULT NULL,
                         `category_id` int NOT NULL,
                         `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                         PRIMARY KEY (`id`),
                         KEY `fk_food_category` (`category_id`),
                         CONSTRAINT `fk_food_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `foods` VALUES
                        (1, 'Burger Bò Phô Mai Đặc Biệt', 'Bò nướng lửa hồng, phô mai Cheddar tan chảy, xà lách tươi bọc trong vỏ bánh mì mè nướng nóng hổi.', 5.99, 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=500&q=80', 1, '2026-06-26 00:41:37'),
                        (2, 'Burger Gà Giòn Cay Extra', 'Ức gà phi lê chiên xù giòn rụm kết hợp với sốt phô mai cay nồng vị Hàn Quốc siêu kích thích vị giác.', 4.99, 'https://images.unsplash.com/photo-1625813506062-0aeb1d7a094b?auto=format&fit=crop&w=500&q=80', 1, '2026-06-26 00:41:37'),
                        (3, 'Burger Bò BBQ Double Cheese', 'Gấp đôi miếng thịt bò Úc nướng hòa quyện cùng lớp sốt BBQ hun khói đậm đà và 2 lát phô mai.', 7.99, 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?auto=format&fit=crop&w=500&q=80', 1, '2026-06-26 00:41:37'),
                        (4, 'Burger Tôm Hoàng Gia', 'Nhân tôm băm tẩm bột chiên xù ngập tràn thịt tôm tươi ngọt, kết hợp với sốt Mayonnaise béo ngậy.', 6.49, 'https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=500&q=80', 1, '2026-06-26 00:41:37'),
                        (5, 'Burger Chay Thực Vật Healthy', 'Nhân làm từ đậu nành và nấm hương tự nhiên, giàu protein, thanh đạm, tốt cho sức khỏe và vóc dáng.', 4.50, 'https://images.unsplash.com/photo-1525059696034-4967a8e1dca2?auto=format&fit=crop&w=500&q=80', 1, '2026-06-26 00:41:37'),
                        (6, 'Pizza Hải Sản Sốt Pesto', 'Tôm, mực tươi, thanh cua rải đều trên lớp sốt húng tây Pesto xanh mát và phô mai Mozzarella kéo sợi.', 12.99, 'https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=500&q=80', 2, '2026-06-26 00:41:37'),
                        (7, 'Pizza Thập Cẩm Supreme', 'Sự kết hợp hoàn hảo giữa xúc xích pepperoni, thịt xông khói, hành tây, ớt chuông và nấm rơm.', 11.50, 'https://images.unsplash.com/photo-1534308983496-4fabb1a015ee?auto=format&fit=crop&w=500&q=80', 2, '2026-06-26 00:41:37'),
                        (8, 'Pizza Bò Nướng Tiêu Đen', 'Thịt bò băm nướng thơm lừng đẫm sốt tiêu đen cay nồng đậm vị, chuẩn gu người Việt.', 13.49, 'https://images.unsplash.com/photo-1590947132387-155cc02f3212?auto=format&fit=crop&w=500&q=80', 2, '2026-06-26 00:41:37'),
                        (9, 'Pizza Phô Mai Margherita', 'Đơn giản nhưng tinh tế với gấp đôi phô mai Mozzarella thượng hạng cùng sốt cà chua truyền thống.', 9.99, 'https://images.unsplash.com/photo-1604068549290-dea0e4a305ca?auto=format&fit=crop&w=500&q=80', 2, '2026-06-26 00:41:37'),
                        (10, 'Pizza Gà Nướng Sốt BBQ', 'Thịt gà xé nhỏ ướp gia vị đậm đà, nướng vàng ươm cùng hành tây thái mỏng trên nền sốt BBQ độc quyền.', 10.99, 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=500&q=80', 2, '2026-06-26 00:41:37'),
                        (11, 'Khoai Tây Chiên Lắc Phô Mai', 'Khoai tây bổ múi cau chiên giòn, bên ngoài phủ một lớp bột phô mai mặn ngọt béo ngậy cực cuốn.', 2.99, 'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?auto=format&fit=crop&w=500&q=80', 3, '2026-06-26 00:41:37'),
                        (12, 'Gà Rán Giòn Không Xương', 'Gà phi lê cắt miếng vừa ăn, tẩm ướp bột giòn cay độc vị, chiên ngập dầu vàng ruộm ráo mỡ.', 4.50, 'https://images.unsplash.com/photo-1562967914-608f82629710?auto=format&fit=crop&w=500&q=80', 3, '2026-06-26 00:41:37'),
                        (13, 'Phô Mai Que Kéo Sợi', 'Lớp vỏ bột chiên xù bọc bên trong khối phô mai Mozzarella dày dặn, kéo sợi dài siêu vui mắt.', 3.49, 'https://omiyage.com.vn/upload/products/thumb_800x0/pho-mai-2-1624423669.png', 3, '2026-06-26 00:41:37'),
                        (14, 'Vòng Hành Tây Chiên Xù', 'Hành tây ngọt dịu cắt khoanh tròn, nhúng bột chiên xù giòn tan, món ăn kèm chống ngấy hoàn hảo.', 2.50, 'https://afamilycdn.com/150157425591193600/2021/7/1/2-cach-lam-muc-chien-gion-muc-chien-xu-thom-ngon-gion-dai-xin-nhu-nha-hang-6-16251255472891974727180.jpg', 3, '2026-06-26 00:41:37'),
                        (15, 'Salad Rau Trộn Sốt Caesar', 'Xà lách romaine tươi xanh, bánh mì nướng bơ tỏi cắt nhỏ bùi bùi quyện sốt kem Caesar béo dịu.', 3.99, 'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?auto=format&fit=crop&w=500&q=80', 3, '2026-06-26 00:41:37'),
                        (16, 'Coca-Cola Lạnh Chai 390ml', 'Nước giải khát có ga đập tan cơn khát, mang lại cảm giác sảng khoái tức thì khi ăn kèm đồ ăn nhanh.', 1.50, 'https://images.unsplash.com/photo-1622483767028-3f66f32aef97?auto=format&fit=crop&w=500&q=80', 4, '2026-06-26 00:41:37'),
                        (17, 'Trà Sữa BiteSync Trân Châu', 'Trà sữa đậm vị trà thuần khiết kết hợp sữa thơm béo, kèm topping trân châu đen dai giòn sần sật.', 3.50, 'https://images.unsplash.com/photo-1541658016709-82535e94bc69?auto=format&fit=crop&w=500&q=80', 4, '2026-06-26 00:41:37'),
                        (18, 'Nước Ép Cam Tươi Nguyên Chất', 'Cam sành vắt nguyên chất giàu Vitamin C, làm mát cơ thể, giải nhiệt hiệu quả sau bữa ăn.', 2.99, 'https://images.unsplash.com/photo-1613478223719-2ab802602423?auto=format&fit=crop&w=500&q=80', 4, '2026-06-26 00:41:37'),
                        (19, 'Trà Đào Cam Sả Nhiệt Đới', 'Hương vị trà đào thơm lừng hòa quyện cùng vị chua dịu của cam tươi và hương sả nồng ấm.', 3.00, 'https://images.unsplash.com/photo-1556679343-c7306c1976bc?auto=format&fit=crop&w=500&q=80', 4, '2026-06-26 00:41:37'),
                        (20, 'Cà Phê Sữa Đá Truyền Thống', 'Cà phê hạt Robusta rang xay đậm đặc pha phin, kết hợp sữa đặc ngôi sao phương nam thơm béo.', 2.00, 'https://images.unsplash.com/photo-1541167760496-1628856ab772?auto=format&fit=crop&w=500&q=80', 4, '2026-06-26 00:41:37'),
                        (21, 'Bánh Tart Trứng Nóng Hổi', 'Lớp vỏ bánh ngàn lớp giòn tan bao bọc lớp kem trứng nướng vàng nâu béo ngậy, dậy mùi bơ.', 1.99, 'https://images.unsplash.com/photo-1590080875515-8a3a8dc5735e?auto=format&fit=crop&w=500&q=80', 5, '2026-06-26 00:41:37'),
                        (22, 'Kem Ly Vani Sốt Socola', 'Kem vị Vani sữa mát lạnh, mịn màng, rưới thêm một lớp kem sốt socola Bỉ đặc sánh ngọt ngào.', 2.50, 'https://images.unsplash.com/photo-1563805042-7684c019e1cb?auto=format&fit=crop&w=500&q=80', 5, '2026-06-26 00:41:37'),
                        (23, 'Bánh Tiramisu Ý Thượng Hạng', 'Bánh ngọt cốt mềm, thấm đẫm hương vị cà phê nồng nàn cùng lớp kem trứng phô mai Mascarpone.', 4.00, 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?auto=format&fit=crop&w=500&q=80', 5, '2026-06-26 00:41:37'),
                        (24, 'Bánh Gato Cuộn Matcha', 'Bánh bông lan cuộn kem tươi mềm xốp mịn, hương trà xanh Nhật Bản thơm mát thanh tao dịu nhẹ.', 3.50, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT5ltLOy7fSq8GORQUVusKMO4gyHQPeE-yfa17yhm2n9Q&s=10', 5, '2026-06-26 00:41:37'),
                        (25, 'Thạch Trái Cây Topping Bạc Hà', 'Món tráng miệng thanh mát kết hợp giữa các loại quả mọng vùng nhiệt đới và thạch gelatin dẻo.', 2.20, 'https://images.unsplash.com/photo-1551024601-bec78aea704b?auto=format&fit=crop&w=500&q=80', 5, '2026-06-26 00:41:37');


-- 4. TẠO BẢNG GIỎ HÀNG (Phụ thuộc users)
CREATE TABLE `carts` (
                         `id` int NOT NULL AUTO_INCREMENT,
                         `user_id` int NOT NULL,
                         `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                         `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
                         PRIMARY KEY (`id`),
                         KEY `fk_cart_user` (`user_id`),
                         CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. TẠO BẢNG CHI TIẾT GIỎ HÀNG (Phụ thuộc carts và foods)
CREATE TABLE `cart_items` (
                              `id` int NOT NULL AUTO_INCREMENT,
                              `cart_id` int NOT NULL,
                              `food_id` int NOT NULL,
                              `quantity` int NOT NULL DEFAULT 1,
                              `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
                              `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE CURRENT_TIMESTAMP,
                              PRIMARY KEY (`id`),
                              UNIQUE KEY `unique_cart_food` (`cart_id`,`food_id`),
                              KEY `fk_item_food` (`food_id`),
                              CONSTRAINT `fk_item_cart` FOREIGN KEY (`cart_id`) REFERENCES `carts` (`id`) ON DELETE CASCADE,
                              CONSTRAINT `fk_item_food` FOREIGN KEY (`food_id`) REFERENCES `foods` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;