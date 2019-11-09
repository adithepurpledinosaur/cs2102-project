-- the password is 'password'
INSERT INTO Reward VALUES ('D000001', DEFAULT);
INSERT INTO Reward VALUES ('D000002', DEFAULT);
INSERT INTO Reward VALUES ('D000003', DEFAULT);
INSERT INTO Reward VALUES ('D000004', DEFAULT);
INSERT INTO Reward VALUES ('D000005', DEFAULT);
INSERT INTO Reward VALUES ('D000006', DEFAULT);
INSERT INTO Reward VALUES ('R000001', DEFAULT);
INSERT INTO Reward VALUES ('R000002', DEFAULT);


INSERT INTO Discount VALUES ('D000001', 20, 1);
INSERT INTO Discount VALUES ('D000002', 40, 2);
INSERT INTO Discount VALUES ('D000003', 60, 3);
INSERT INTO Discount VALUES ('D000004', 80, 4);
INSERT INTO Discount VALUES ('D000005', 100, 5);
INSERT INTO Discount VALUES ('D000006', 120, 8);

INSERT INTO Points VALUES ('R000001', 50);
INSERT INTO Points VALUES ('R000002', 5);

INSERT INTO Benefits VALUES ('B000001', 1);

INSERT INTO Users VALUES ('Ali', '$2b$10$pmSW2VmR.fPKv7nUrA4Vq.uxpwgC.27Y4baSLHhnTZ8mVe5sayfEu', 'Ali Bin Cob', 'Ali', 'M', '1990-10-10', 'Sengkang', DEFAULT);
INSERT INTO Users VALUES ('Bob', '$2b$10$pmSW2VmR.fPKv7nUrA4Vq.uxpwgC.27Y4baSLHhnTZ8mVe5sayfEu', 'Bob Bin Cob', 'Bob', 'M', '1991-10-10', 'Sengkang', DEFAULT);
INSERT INTO Users VALUES ('Cob', '$2b$10$pmSW2VmR.fPKv7nUrA4Vq.uxpwgC.27Y4baSLHhnTZ8mVe5sayfEu', 'Cob Bin Cob', 'Cob', 'M', '1992-10-10', 'Sengkang', DEFAULT);
INSERT INTO Users VALUES ('Dad', '$2b$10$pmSW2VmR.fPKv7nUrA4Vq.uxpwgC.27Y4baSLHhnTZ8mVe5sayfEu', 'Dad Bin Cob', 'Dad', 'M', '1993-10-10', 'Sengkang', DEFAULT);
INSERT INTO Users VALUES ('Eli', '$2b$10$pmSW2VmR.fPKv7nUrA4Vq.uxpwgC.27Y4baSLHhnTZ8mVe5sayfEu', 'Eli Bin Cob', 'Eli', 'M', '1994-10-10', 'Sengkang', DEFAULT);
INSERT INTO Users VALUES ('Fox', '$2b$10$pmSW2VmR.fPKv7nUrA4Vq.uxpwgC.27Y4baSLHhnTZ8mVe5sayfEu', 'Fox Bin Cob', 'Fox', 'F', '1995-10-10', 'Sengkang', DEFAULT);
INSERT INTO Users VALUES ('God', '$2b$10$pmSW2VmR.fPKv7nUrA4Vq.uxpwgC.27Y4baSLHhnTZ8mVe5sayfEu', 'God Bin Cob', 'God', 'M', '1996-10-10', 'Sengkang', DEFAULT);
INSERT INTO Users VALUES ('Ham', '$2b$10$pmSW2VmR.fPKv7nUrA4Vq.uxpwgC.27Y4baSLHhnTZ8mVe5sayfEu', 'Ham Bin Cob', 'Ham', 'M', '1997-10-10', 'Sengkang', DEFAULT);
INSERT INTO Users VALUES ('Ivy', '$2b$10$pmSW2VmR.fPKv7nUrA4Vq.uxpwgC.27Y4baSLHhnTZ8mVe5sayfEu', 'Ivy Bin Cob', 'Ivy', 'F', '1998-10-10', 'Sengkang', DEFAULT);
INSERT INTO Users VALUES ('Jay', '$2b$10$pmSW2VmR.fPKv7nUrA4Vq.uxpwgC.27Y4baSLHhnTZ8mVe5sayfEu', 'Jay Bin Cob', 'Jay', 'M', '1999-10-10', 'Sengkang', DEFAULT);
INSERT INTO Users VALUES ('Kyl', '$2b$10$pmSW2VmR.fPKv7nUrA4Vq.uxpwgC.27Y4baSLHhnTZ8mVe5sayfEu', 'Kyl Bin Cob', 'Kyl', 'M', '2000-10-10', 'Sengkang', DEFAULT);
INSERT INTO Users VALUES ('Lam', '$2b$10$pmSW2VmR.fPKv7nUrA4Vq.uxpwgC.27Y4baSLHhnTZ8mVe5sayfEu', 'Lam Bin Cob', 'Lam', 'M', '2001-10-10', 'Sengkang', DEFAULT);
INSERT INTO Users VALUES ('Max', '$2b$10$pmSW2VmR.fPKv7nUrA4Vq.uxpwgC.27Y4baSLHhnTZ8mVe5sayfEu', 'Max Bin Cob', 'Max', 'F', '2010-10-10', 'Sengkang', DEFAULT);

INSERT INTO Driver VALUES ('Ali', DEFAULT);
INSERT INTO Driver VALUES ('Bob', DEFAULT);
INSERT INTO Driver VALUES ('Cob', DEFAULT);
INSERT INTO Driver VALUES ('Dad', DEFAULT);

INSERT INTO Car VALUES ('Ali', 'SGX9123A', 3, 'Toyota', '2029-10-08');
INSERT INTO Car VALUES ('Bob', 'SGX9123B', 5, 'Mazda', '2028-10-08');
INSERT INTO Car VALUES ('Cob', 'SGX9123C', 3, 'Honda', '2027-10-08');
INSERT INTO Car VALUES ('Dad', 'SGX9123D', 5, 'Lambo', '2026-10-08');

INSERT INTO Ride VALUES ('Bob', 'SGX9123B', 5, 'Sengkang', 'Hougang', '2019-11-08 12:00:00', DEFAULT, 3, DEFAULT);
INSERT INTO Ride VALUES ('Bob', 'SGX9123B', 5, 'Sengkang', 'Hougang', '2019-11-10 12:00:00', DEFAULT, 3, DEFAULT);
INSERT INTO Ride VALUES ('Bob', 'SGX9123B', 5, 'Sengkang', 'Hougang', '2019-11-10 13:00:00', DEFAULT, 3, DEFAULT);
INSERT INTO Ride VALUES ('Bob', 'SGX9123B', 5, 'Sengkang', 'Hougang', '2019-11-10 13:10:00', DEFAULT, 3, DEFAULT);
INSERT INTO Ride VALUES ('Cob', 'SGX9123C', 5, 'Sengkang', 'Hougang', '2019-11-10 13:00:00', DEFAULT, 3, DEFAULT);
INSERT INTO Ride VALUES ('Cob', 'SGX9123C', 3, 'Sengkang', 'Hougang', '2019-11-10 13:00:00', DEFAULT, 3, DEFAULT);
INSERT INTO Ride VALUES ('Dad', 'SGX9123D', 5, 'Sengkang', 'Hougang', '2019-11-10 13:00:00', DEFAULT, 3, DEFAULT);

INSERT INTO Bid VALUES ('Dad', 'Bob', 'SGX9123B', 'Sengkang', 'Hougang', '2019-11-10 12:00:00', DEFAULT, 3, DEFAULT);
INSERT INTO Bid VALUES ('Eli', 'Bob', 'SGX9123B', 'Sengkang', 'Hougang', '2019-11-10 12:00:00', DEFAULT, 2, DEFAULT);
INSERT INTO Bid VALUES ('Fox', 'Bob', 'SGX9123B', 'Sengkang', 'Hougang', '2019-11-10 12:00:00', DEFAULT, 3, DEFAULT);
INSERT INTO Bid VALUES ('God', 'Bob', 'SGX9123B', 'Sengkang', 'Hougang', '2019-11-10 12:00:00', DEFAULT, 3, DEFAULT);
INSERT INTO Bid VALUES ('Dad', 'Dad', 'SGX9123C', 'Sengkang', 'Hougang', '2019-11-10 13:00:00', DEFAULT, 3, DEFAULT);
INSERT INTO Bid VALUES ('Lam', 'Dad', 'SGX9123D', 'Sengkang', 'Hougang', '2019-11-10 13:00:00', DEFAULT, 12, DEFAULT);
INSERT INTO Bid VALUES ('Ham', 'Dad', 'SGX9123D', 'Sengkang', 'Hougang', '2019-11-10 13:00:00', DEFAULT, 16, DEFAULT);

UPDATE BID SET price = 4
    WHERE (puname = 'Dad' AND duname = 'Bob' AND plate_num = 'SGX9123B' AND origin = 'Sengkang' AND dest = 'Hougang' AND pdatetime = '2019-11-10 12:00:00' AND price = 3);

UPDATE BID SET won = TRUE
WHERE (puname = 'Lam' AND duname = 'Dad' AND plate_num = 'SGX9123D' AND origin = 'Sengkang' AND dest = 'Hougang' AND pdatetime = '2019-11-10 13:00:00' AND price = 12);
UPDATE BID SET won = TRUE
WHERE (puname = 'Ham' AND duname = 'Dad' AND plate_num = 'SGX9123D' AND origin = 'Sengkang' AND dest = 'Hougang' AND pdatetime = '2019-11-10 13:00:00' AND price = 16);

UPDATE BID SET won = TRUE
WHERE (puname = 'Dad' AND duname = 'Bob' AND plate_num = 'SGX9123B' AND origin = 'Sengkang' AND dest = 'Hougang' AND pdatetime = '2019-11-10 12:00:00' AND price = 4);

--When driver closes transaction--
UPDATE Transactions SET closed = true
WHERE (puname = 'Dad' AND duname = 'Bob' AND plate_num = 'SGX9123B' AND origin = 'Sengkang' AND dest = 'Hougang' AND pdatetime = '2019-11-10 12:00:00');
UPDATE Transactions SET closed = true
WHERE (puname = 'Lam' AND duname = 'Dad' AND plate_num = 'SGX9123D' AND origin = 'Sengkang' AND dest = 'Hougang' AND pdatetime = '2019-11-10 13:00:00');
UPDATE Transactions SET closed = true
WHERE (puname = 'Ham' AND duname = 'Dad' AND plate_num = 'SGX9123D' AND origin = 'Sengkang' AND dest = 'Hougang' AND pdatetime = '2019-11-10 13:00:00');

--Give Ham 100 points for testing of discount
UPDATE Passenger SET  cpoints = 1000 WHERE uname = 'Ham';
--Ham buys a discount code
INSERT INTO Obtains VALUES ('Ham', 'D000006', DEFAULT, DEFAULT);

--prompt user to input disc code and rating, and driver rating and ptype
UPDATE Transactions SET prating = 1.5, drating = 2.5, ptype = 'Cash'
WHERE (puname = 'Dad' AND duname = 'Bob' AND plate_num = 'SGX9123B' AND origin = 'Sengkang' AND dest = 'Hougang' AND pdatetime = '2019-11-10 12:00:00');



UPDATE Transactions SET r_redeem = 'D000006', prating = 1.5, drating = 2.5, ptype = 'Cash'
WHERE (puname = 'Ham' AND duname = 'Dad' AND plate_num = 'SGX9123D' AND origin = 'Sengkang' AND dest = 'Hougang' AND pdatetime = '2019-11-10 13:00:00');

UPDATE Transactions SET prating = 1.5, drating = 5, ptype = 'Cash'
WHERE (puname = 'Lam' AND duname = 'Dad' AND plate_num = 'SGX9123D' AND origin = 'Sengkang' AND dest = 'Hougang' AND pdatetime = '2019-11-10 13:00:00');

