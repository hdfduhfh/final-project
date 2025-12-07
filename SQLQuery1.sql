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
    TotalSeats      INT          NOT NULL,
    AvailableSeats  INT          NOT NULL,
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

--Bảng order
CREATE TABLE dbo.[Order] (
    OrderID        INT IDENTITY(1,1) PRIMARY KEY,
    UserID         INT           NOT NULL,
    PromotionID    INT           NULL,   -- nullable nếu không dùng mã KM
    TotalAmount    DECIMAL(12,2) NOT NULL,
    DiscountAmount DECIMAL(12,2) NOT NULL DEFAULT(0),
    PromotionCode  VARCHAR(50)   NULL,
    Status         VARCHAR(20)   NOT NULL,
    CreatedAt      DATETIME      NOT NULL DEFAULT(GETDATE()),

    CONSTRAINT FK_Order_User
        FOREIGN KEY (UserID) REFERENCES dbo.[User](UserID),
    CONSTRAINT FK_Order_Promotion
        FOREIGN KEY (PromotionID) REFERENCES dbo.Promotion(PromotionID)
);

--Bảng thanh toán
CREATE TABLE dbo.Payment (
    PaymentID       INT IDENTITY(1,1) PRIMARY KEY,
    UserID          INT           NOT NULL,
    OrderID         INT           NOT NULL,
    Amount          DECIMAL(12,2) NOT NULL,
    Method          VARCHAR(30)   NOT NULL,
    Status          VARCHAR(20)   NOT NULL,
    TransactionCode VARCHAR(100)  NULL,
    PaidAt          DATETIME      NULL,
    CreatedAt       DATETIME      NOT NULL DEFAULT(GETDATE()),
    UpdatedAt       DATETIME      NULL,

    CONSTRAINT FK_Payment_User
        FOREIGN KEY (UserID) REFERENCES dbo.[User](UserID),
    CONSTRAINT FK_Payment_Order
        FOREIGN KEY (OrderID) REFERENCES dbo.[Order](OrderID)
);

--Bảng vé 
CREATE TABLE dbo.Ticket (
    TicketID    INT IDENTITY(1,1) PRIMARY KEY,
    OrderID     INT           NOT NULL,
    ScheduleID  INT           NOT NULL,
    SeatID      INT           NOT NULL,
    Price       DECIMAL(12,2) NOT NULL,
    PaymentID   INT           NULL,           -- optional, nullable if unpaid
    Status      VARCHAR(20)   NOT NULL,
    CreatedAt   DATETIME      NOT NULL DEFAULT(GETDATE()),
    UpdatedAt   DATETIME      NULL,

    CONSTRAINT FK_Ticket_Order
        FOREIGN KEY (OrderID) REFERENCES dbo.[Order](OrderID),
    CONSTRAINT FK_Ticket_Schedule
        FOREIGN KEY (ScheduleID) REFERENCES dbo.ShowSchedule(ScheduleID),
    CONSTRAINT FK_Ticket_Seat
        FOREIGN KEY (SeatID) REFERENCES dbo.Seat(SeatID),
    CONSTRAINT FK_Ticket_Payment
        FOREIGN KEY (PaymentID) REFERENCES dbo.Payment(PaymentID)
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

