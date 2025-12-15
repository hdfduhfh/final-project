CREATE DATABASE BookingStageDB;

USE BookingStageDB;

-- Bảng vai trò người dùng
CREATE TABLE dbo.Role (
    RoleID     INT IDENTITY(1,1) PRIMARY KEY,   -- khoá chính tự tăng 1,1 :contentReference[oaicite:1]{index=1}
    RoleName   VARCHAR(50)   NOT NULL,
    CreatedAt  DATETIME      NOT NULL DEFAULT(GETDATE())
);

-- Bảng khuyến mãi
CREATE TABLE dbo.Promotion (
    PromotionID        INT IDENTITY(1,1) PRIMARY KEY,
    Name               NVARCHAR(100)  NOT NULL,
    Code               VARCHAR(50)    NOT NULL,
    DiscountType       VARCHAR(20)    NOT NULL,
    DiscountValue      DECIMAL(12,2)  NOT NULL,
    MinOrderAmount     DECIMAL(12,2)  NULL,
    MaxDiscount        DECIMAL(12,2)  NULL,
    StartDate          DATETIME       NOT NULL,
    EndDate            DATETIME       NOT NULL,
    Status             VARCHAR(20)    NOT NULL,
    MaxUsage           INT            NULL,
    MaxUsagePerUser    INT            NULL
);

-- Bảng người dùng
CREATE TABLE dbo.[User] (
    UserID        INT IDENTITY(1,1) PRIMARY KEY,
    FullName      NVARCHAR(100)  NOT NULL,
    Email         VARCHAR(100)   NOT NULL,
    Phone         VARCHAR(20)    NULL,
    PasswordHash  NVARCHAR(255)  NOT NULL,
    RoleID        INT            NOT NULL,
    CreatedAt     DATETIME       NOT NULL DEFAULT(GETDATE()),
    UpdatedAt     DATETIME       NULL,
    LastLogin     DATETIME       NULL,

    CONSTRAINT FK_User_Role
        FOREIGN KEY (RoleID) REFERENCES dbo.Role(RoleID)
);

--Bảng show diễn 
CREATE TABLE dbo.[Show] (
    ShowID         INT IDENTITY(1,1) PRIMARY KEY,
    ShowName       VARCHAR(150)  NOT NULL,
    Description    VARCHAR(255)  NULL,
    DurationMinutes INT          NOT NULL,
    Status         VARCHAR(20)   NOT NULL,
    ShowImage      VARCHAR(500)  NULL,
    CreatedAt      DATETIME      NOT NULL DEFAULT(GETDATE())
);

--Bảng lịch diễn 
CREATE TABLE dbo.ShowSchedule (
    ScheduleID      INT IDENTITY(1,1) PRIMARY KEY,
    ShowID          INT          NOT NULL,
    ShowTime        DATETIME     NOT NULL,
    Status          VARCHAR(20)  NOT NULL,
    CreatedAt       DATETIME     NOT NULL DEFAULT(GETDATE()),

    CONSTRAINT FK_ShowSchedule_Show
        FOREIGN KEY (ShowID) REFERENCES dbo.[Show](ShowID)
);

--Bảng ghế 
CREATE TABLE dbo.Seat (
    SeatID        INT IDENTITY(1,1) PRIMARY KEY,
    SeatNumber    NVARCHAR(10)  NOT NULL,
    SeatType      NVARCHAR(20)  NOT NULL,
    RowLabel      VARCHAR(5)    NOT NULL,
    ColumnNumber  INT           NOT NULL,
    IsActive      BIT           NOT NULL DEFAULT(1),
    CreatedAt     DATETIME      NOT NULL DEFAULT(GETDATE())
);

--Bảng nghệ sĩ 
CREATE TABLE dbo.Artist (
    ArtistID     INT IDENTITY(1,1) PRIMARY KEY,
    Name         VARCHAR(100)  NOT NULL,
    Role         VARCHAR(50)   NULL,
    Bio          VARCHAR(255)  NULL,
    ArtistImage  VARCHAR(500)  NULL
);

--Bảng nghệ sĩ cho buổi biểu diễn
CREATE TABLE dbo.ShowArtist (
    ShowArtistID INT IDENTITY(1,1) PRIMARY KEY,
    ShowID       INT NOT NULL,
    ArtistID     INT NOT NULL,

    CONSTRAINT FK_ShowArtist_Show
        FOREIGN KEY (ShowID) REFERENCES dbo.[Show](ShowID),
    CONSTRAINT FK_ShowArtist_Artist
        FOREIGN KEY (ArtistID) REFERENCES dbo.Artist(ArtistID)
);
sql-- ============================================
-- BƯỚC 1: XÓA CÁC BẢNG CŨ
-- ============================================

-- Xóa ràng buộc trước
IF OBJECT_ID('dbo.FK_Ticket_Payment', 'F') IS NOT NULL
    ALTER TABLE dbo.Ticket DROP CONSTRAINT FK_Ticket_Payment;
IF OBJECT_ID('dbo.FK_Ticket_Seat', 'F') IS NOT NULL
    ALTER TABLE dbo.Ticket DROP CONSTRAINT FK_Ticket_Seat;
IF OBJECT_ID('dbo.FK_Ticket_Schedule', 'F') IS NOT NULL
    ALTER TABLE dbo.Ticket DROP CONSTRAINT FK_Ticket_Schedule;
IF OBJECT_ID('dbo.FK_Ticket_Order', 'F') IS NOT NULL
    ALTER TABLE dbo.Ticket DROP CONSTRAINT FK_Ticket_Order;
IF OBJECT_ID('dbo.FK_Payment_Order', 'F') IS NOT NULL
    ALTER TABLE dbo.Payment DROP CONSTRAINT FK_Payment_Order;
IF OBJECT_ID('dbo.FK_Payment_User', 'F') IS NOT NULL
    ALTER TABLE dbo.Payment DROP CONSTRAINT FK_Payment_User;
IF OBJECT_ID('dbo.FK_Order_Promotion', 'F') IS NOT NULL
    ALTER TABLE dbo.[Order] DROP CONSTRAINT FK_Order_Promotion;
IF OBJECT_ID('dbo.FK_Order_User', 'F') IS NOT NULL
    ALTER TABLE dbo.[Order] DROP CONSTRAINT FK_Order_User;

-- Xóa các bảng
DROP TABLE IF EXISTS dbo.Ticket;
DROP TABLE IF EXISTS dbo.Payment;
DROP TABLE IF EXISTS dbo.[Order];

-- ============================================
-- BƯỚC 2: TẠO LẠI CÁC BẢNG MỚI
-- ============================================

-- Bảng Order (Đơn hàng + Thanh toán)
CREATE TABLE dbo.[Order] (
    OrderID         INT IDENTITY(1,1) PRIMARY KEY,
    UserID          INT           NOT NULL,
    PromotionID     INT           NULL,
    
    -- Thông tin giá tiền
    TotalAmount     DECIMAL(12,2) NOT NULL,
    DiscountAmount  DECIMAL(12,2) NOT NULL DEFAULT(0),
    FinalAmount     DECIMAL(12,2) NOT NULL, -- TotalAmount - DiscountAmount
    PromotionCode   VARCHAR(50)   NULL,
    
    -- Thông tin thanh toán (gộp luôn vào Order)
    PaymentMethod      VARCHAR(30)   NULL,     -- 'Cash', 'Card', 'MoMo', 'ZaloPay', 'VNPay'
    PaymentStatus      VARCHAR(20)   NOT NULL, -- 'Pending', 'Success', 'Failed', 'Refunded'
    TransactionCode    VARCHAR(100)  NULL,     -- Mã giao dịch từ cổng thanh toán
    PaidAt             DATETIME      NULL,     -- Thời điểm thanh toán thành công
    
    -- Trạng thái đơn hàng
    Status          VARCHAR(20)   NOT NULL,    -- 'Pending', 'Confirmed', 'Cancelled', 'Completed'
    
    CreatedAt       DATETIME      NOT NULL DEFAULT(GETDATE()),
    UpdatedAt       DATETIME      NULL,

    CONSTRAINT FK_Order_User
        FOREIGN KEY (UserID) REFERENCES dbo.[User](UserID),
    CONSTRAINT FK_Order_Promotion
        FOREIGN KEY (PromotionID) REFERENCES dbo.Promotion(PromotionID)
);

-- Bảng OrderDetail (Chi tiết đơn hàng - từng vé)
CREATE TABLE dbo.OrderDetail (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID       INT           NOT NULL,
    ScheduleID    INT           NOT NULL,
    SeatID        INT           NOT NULL,
    Price         DECIMAL(12,2) NOT NULL, -- Giá tại thời điểm đặt
    Quantity      INT           NOT NULL DEFAULT(1),
    CreatedAt     DATETIME      NOT NULL DEFAULT(GETDATE()),

    CONSTRAINT FK_OrderDetail_Order
        FOREIGN KEY (OrderID) REFERENCES dbo.[Order](OrderID),
    CONSTRAINT FK_OrderDetail_Schedule
        FOREIGN KEY (ScheduleID) REFERENCES dbo.ShowSchedule(ScheduleID),
    CONSTRAINT FK_OrderDetail_Seat
        FOREIGN KEY (SeatID) REFERENCES dbo.Seat(SeatID)
);

-- Bảng Ticket (Vé thực tế - sinh sau khi thanh toán thành công)
CREATE TABLE dbo.Ticket (
    TicketID      INT IDENTITY(1,1) PRIMARY KEY,
    OrderDetailID INT           NOT NULL,
    QRCode        VARCHAR(100)  NULL,      -- Mã QR để check-in
    Status        VARCHAR(20)   NOT NULL,  -- 'Valid', 'Used', 'Cancelled', 'Expired'
    IssuedAt      DATETIME      NOT NULL DEFAULT(GETDATE()), -- Thời điểm phát hành vé
    CheckInAt     DATETIME      NULL,      -- Thời điểm quét vé
    CreatedAt     DATETIME      NOT NULL DEFAULT(GETDATE()),
    UpdatedAt     DATETIME      NULL,

    CONSTRAINT FK_Ticket_OrderDetail
        FOREIGN KEY (OrderDetailID) REFERENCES dbo.OrderDetail(OrderDetailID)
);

--Bảng feedback 
CREATE TABLE dbo.Feedback (
    FeedbackID  INT IDENTITY(1,1) PRIMARY KEY,
    UserID      INT            NOT NULL,
    ScheduleID  INT            NOT NULL,
    Rating      INT            NOT NULL,
    Comment     NVARCHAR(MAX)  NULL,
    Status      VARCHAR(20)    NOT NULL,
    CreatedAt   DATETIME       NOT NULL DEFAULT(GETDATE()),
    UpdatedAt   DATETIME       NULL,

    CONSTRAINT FK_Feedback_User
        FOREIGN KEY (UserID) REFERENCES dbo.[User](UserID),
    CONSTRAINT FK_Feedback_Schedule
        FOREIGN KEY (ScheduleID) REFERENCES dbo.ShowSchedule(ScheduleID)
);

--Bảng tin tức
CREATE TABLE dbo.News (
    NewsID     INT IDENTITY(1,1) PRIMARY KEY,
    Title      NVARCHAR(200)  NOT NULL,
    Content    NVARCHAR(MAX)  NOT NULL,
    CreatedAt  DATETIME       NOT NULL DEFAULT(GETDATE()),
    UpdatedAt  DATETIME       NULL,
    UserID     INT            NOT NULL,

    CONSTRAINT FK_News_User
        FOREIGN KEY (UserID) REFERENCES dbo.[User](UserID)
);

--Bảng tuyển dụng
CREATE TABLE dbo.Recruitment (
    JobID        INT IDENTITY(1,1) PRIMARY KEY,
    UserID       INT            NOT NULL,
    Description  NVARCHAR(MAX) NOT NULL,
    PostedAt     DATETIME      NOT NULL DEFAULT(GETDATE()),

    CONSTRAINT FK_Recruitment_User
        FOREIGN KEY (UserID) REFERENCES dbo.[User](UserID)
);

-- 1. Tạo Role ADMIN trước
INSERT INTO Role (RoleName, CreatedAt)
VALUES ('ADMIN', GETDATE());

-- 2. Tạo admin user với mật khẩu 'admin123' hash SHA2_256
INSERT INTO [User] (FullName, Email, PasswordHash, RoleID, CreatedAt)
VALUES (
    'Admin',
    'admin',
    CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', '123'), 2),
    (SELECT RoleID FROM Role WHERE RoleName='ADMIN'),
    GETDATE()
);
UPDATE [User]
SET Email = 'admin@example.com'
WHERE Email = 'admin';
UPDATE [User]
SET PasswordHash = CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', 'admin123'), 2)
WHERE Email = 'admin@example.com';

INSERT INTO Role (RoleName, CreatedAt) VALUES ('USER', GETDATE());

UPDATE [User]
SET PasswordHash = LOWER(PasswordHash)
WHERE Email = 'admin@example.com';

ALTER TABLE dbo.Artist
    ALTER COLUMN Name NVARCHAR(100) NOT NULL;

ALTER TABLE dbo.Artist
    ALTER COLUMN Role NVARCHAR(50) NULL;

ALTER TABLE dbo.Artist
    ALTER COLUMN Bio NVARCHAR(255) NULL;

ALTER TABLE dbo.Artist
    ALTER COLUMN ArtistImage NVARCHAR(500) NULL;

ALTER TABLE dbo.[Show]
    ALTER COLUMN ShowName NVARCHAR(150)  NOT NULL;

