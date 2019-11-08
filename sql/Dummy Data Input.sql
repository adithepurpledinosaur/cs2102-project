-- the password is 'password'
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


INSERT INTO Driver VALUES ('ALi', DEFAULT);
INSERT INTO Driver VALUES ('Bob', DEFAULT);
INSERT INTO Driver VALUES ('Cob', DEFAULT);
INSERT INTO Driver VALUES ('Dad', DEFAULT);

INSERT INTO Passenger VALUES ('Dad', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
INSERT INTO Passenger VALUES ('Eli', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
INSERT INTO Passenger VALUES ('Fox', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
INSERT INTO Passenger VALUES ('God', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
INSERT INTO Passenger VALUES ('Ham', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
INSERT INTO Passenger VALUES ('Ivy', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
INSERT INTO Passenger VALUES ('Jay', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
INSERT INTO Passenger VALUES ('Kyl', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
INSERT INTO Passenger VALUES ('Lam', DEFAULT, DEFAULT, DEFAULT, DEFAULT);
INSERT INTO Passenger VALUES ('Max', DEFAULT, DEFAULT, DEFAULT, DEFAULT);

INSERT INTO Car VALUES ('ALi', 2, 3, 'Toyota', '2019-10-08');
INSERT INTO Car VALUES ('Bob', 3, 5, 'Mazda', '2018-10-08');
INSERT INTO Car VALUES ('Cob', 4, 3, 'Honda', '2017-10-08');
INSERT INTO Car VALUES ('Dad', 5, 5, 'Lambo', '2016-10-08');

INSERT INTO Ride VALUES ('Bob', 3, 5, 'Sengkang', 'Hougang', '12:00:00', '2019-11-08', DEFAULT, 3, DEFAULT);
INSERT INTO Ride VALUES ('Bob', 3, 5, 'Sengkang', 'Hougang', '12:00:00', '2019-11-09', DEFAULT, 3, DEFAULT);
INSERT INTO Ride VALUES ('Bob', 3, 5, 'Sengkang', 'Hougang', '13:00:00', '2019-11-09', DEFAULT, 3, DEFAULT);
INSERT INTO Ride VALUES ('Bob', 3, 5, 'Sengkang', 'Hougang', '13:10:00', '2019-11-09', DEFAULT, 3, DEFAULT);
INSERT INTO Ride VALUES ('Cob', 4, 5, 'Sengkang', 'Hougang', '13:00:00', '2019-11-09', DEFAULT, 3, DEFAULT);
INSERT INTO Ride VALUES ('Cob', 4, 3, 'Sengkang', 'Hougang', '13:00:00', '2019-11-09', DEFAULT, 3, DEFAULT);
INSERT INTO Ride VALUES ('Dad', 5, 5, 'Sengkang', 'Hougang', '13:00:00', '2019-11-09', DEFAULT, 3, DEFAULT);

INSERT INTO Bid VALUES ('Dad', 'Bob', 3, 'Sengkang', 'Hougang', '12:00:00', '2019-11-09', DEFAULT, 3, DEFAULT);
INSERT INTO Bid VALUES ('Eli', 'Bob', 3, 'Sengkang', 'Hougang', '12:00:00', '2019-11-09', DEFAULT, 2, DEFAULT);
INSERT INTO Bid VALUES ('Fox', 'Bob', 3, 'Sengkang', 'Hougang', '12:00:00', '2019-11-09', DEFAULT, 3, DEFAULT);
INSERT INTO Bid VALUES ('God', 'Bob', 3, 'Sengkang', 'Hougang', '12:00:00', '2019-11-09', DEFAULT, 3, DEFAULT);
INSERT INTO Bid VALUES ('Dad', 'Dad', 5, 'Sengkang', 'Hougang', '13:00:00', '2019-11-09', DEFAULT, 3, DEFAULT);


UPDATE BID SET price = 4
    WHERE (puname = 'Dad' AND duname = 'Bob' AND plate_num = 3 AND origin = 'Sengkang' AND dest = 'Hougang' AND ptime = '12:00:00' AND pdate = '2019-11-09' AND price = 3);

UPDATE BID SET won = TRUE
WHERE (puname = 'Dad' AND duname = 'Bob' AND plate_num = 3 AND origin = 'Sengkang' AND dest = 'Hougang' AND ptime = '12:00:00' AND pdate = '2019-11-09' AND price = 4);

--When driver closes transaction--
UPDATE Transactions SET closed = true
WHERE (puname = 'Dad' AND duname = 'Bob' AND plate_num = 3 AND origin = 'Sengkang' AND dest = 'Hougang' AND ptime = '12:00:00' AND pdate = '2019-11-09');
--prompt user to input disc code and rating, and driver rating and ptype
UPDATE Transactions SET prating = 1.5, drating = 2.5, ptype = 'Cash'
WHERE (puname = 'Dad' AND duname = 'Bob' AND plate_num = 3 AND origin = 'Sengkang' AND dest = 'Hougang' AND ptime = '12:00:00' AND pdate = '2019-11-09');

update Passenger set tpoints = 100, cpoints = 100 where uname = 'Dad';
