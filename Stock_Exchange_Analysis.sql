-- Step 1: Create the database for stock exchange analysis
CREATE DATABASE StockExchangeAnalysis;
USE StockExchangeAnalysis;

-- Step 2: Create tables for stock data
-- Table for Stock Exchanges
CREATE TABLE Exchanges (
    ExchangeID INT AUTO_INCREMENT PRIMARY KEY,
    ExchangeName VARCHAR(50) NOT NULL
);

-- Table for Stocks (Companies listed on exchanges)
CREATE TABLE Stocks (
    StockID INT AUTO_INCREMENT PRIMARY KEY,
    Ticker VARCHAR(10) NOT NULL,
    CompanyName VARCHAR(100) NOT NULL,
    ExchangeID INT NOT NULL,
    Sector VARCHAR(50),
    FOREIGN KEY (ExchangeID) REFERENCES Exchanges(ExchangeID)
);

-- Table for Daily Stock Prices
CREATE TABLE StockPrices (
    PriceID INT AUTO_INCREMENT PRIMARY KEY,
    StockID INT NOT NULL,
    Date DATE NOT NULL,
    OpenPrice DECIMAL(10, 2),
    ClosePrice DECIMAL(10, 2),
    HighPrice DECIMAL(10, 2),
    LowPrice DECIMAL(10, 2),
    Volume INT,
    FOREIGN KEY (StockID) REFERENCES Stocks(StockID)
);

-- Step 3: Insert sample data for NYSE and LSE exchanges
INSERT INTO Exchanges (ExchangeName)
VALUES
    ('NYSE'),  -- New York Stock Exchange
    ('LSE');   -- London Stock Exchange

-- Step 4: Insert sample data for stocks (companies) listed on both exchanges
-- Sample stocks for NYSE
INSERT INTO Stocks (Ticker, CompanyName, ExchangeID, Sector)
VALUES
    ('AAPL', 'Apple Inc.', 1, 'Technology'),
    ('GOOG', 'Alphabet Inc.', 1, 'Technology'),
    ('TSLA', 'Tesla Inc.', 1, 'Automotive');

-- Sample stocks for LSE
INSERT INTO Stocks (Ticker, CompanyName, ExchangeID, Sector)
VALUES
    ('HSBC', 'HSBC Holdings', 2, 'Financial Services'),
    ('BP', 'BP Plc', 2, 'Energy'),
    ('GLEN', 'Glencore', 2, 'Mining');

-- Step 5: Insert sample stock prices for both exchanges
INSERT INTO StockPrices (StockID, Date, OpenPrice, ClosePrice, HighPrice, LowPrice, Volume)
VALUES
    -- NYSE stock prices (for Apple)
    (1, '2024-12-01', 170.00, 172.50, 174.00, 169.50, 1000000),
    (2, '2024-12-01', 2900.00, 2925.00, 2950.00, 2890.00, 500000),
    (3, '2024-12-01', 250.00, 255.00, 260.00, 245.00, 600000),
    -- LSE stock prices (for HSBC)
    (4, '2024-12-01', 650.00, 660.00, 670.00, 640.00, 200000),
    (5, '2024-12-01', 380.00, 375.00, 385.00, 370.00, 400000),
    (6, '2024-12-01', 450.00, 460.00, 470.00, 440.00, 350000);

-- Step 6: Analysis Queries

-- 1. Get the average closing price for stocks on each exchange (NYSE vs LSE)
SELECT e.ExchangeName, AVG(sp.ClosePrice) AS AverageClosingPrice
FROM StockPrices sp
JOIN Stocks s ON sp.StockID = s.StockID
JOIN Exchanges e ON s.ExchangeID = e.ExchangeID
GROUP BY e.ExchangeName;

-- 2. Get the total volume of stocks traded on each exchange
SELECT e.ExchangeName, SUM(sp.Volume) AS TotalVolume
FROM StockPrices sp
JOIN Stocks s ON sp.StockID = s.StockID
JOIN Exchanges e ON s.ExchangeID = e.ExchangeID
GROUP BY e.ExchangeName;

-- 3. Identify the stock with the highest daily trading volume for each exchange
SELECT e.ExchangeName, s.CompanyName, s.Ticker, MAX(sp.Volume) AS MaxVolume
FROM StockPrices sp
JOIN Stocks s ON sp.StockID = s.StockID
JOIN Exchanges e ON s.ExchangeID = e.ExchangeID
GROUP BY e.ExchangeName, s.CompanyName, s.Ticker
ORDER BY e.ExchangeName, MaxVolume DESC;

-- 4. Calculate the daily price change (Close - Open) for each stock on NYSE and LSE
SELECT e.ExchangeName, s.CompanyName, s.Ticker, sp.Date, 
       (sp.ClosePrice - sp.OpenPrice) AS DailyPriceChange
FROM StockPrices sp
JOIN Stocks s ON sp.StockID = s.StockID
JOIN Exchanges e ON s.ExchangeID = e.ExchangeID
WHERE e.ExchangeName IN ('NYSE', 'LSE')
ORDER BY e.ExchangeName, sp.Date;

-- 5. Get the top 3 stocks with the highest closing prices for each exchange
SELECT e.ExchangeName, s.CompanyName, s.Ticker, MAX(sp.ClosePrice) AS MaxClosePrice
FROM StockPrices sp
JOIN Stocks s ON sp.StockID = s.StockID
JOIN Exchanges e ON s.ExchangeID = e.ExchangeID
GROUP BY e.ExchangeName, s.CompanyName, s.Ticker
ORDER BY e.ExchangeName, MaxClosePrice DESC
LIMIT 3;

