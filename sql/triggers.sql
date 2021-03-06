
--------------------------- TRIGGER FUNCTIONS --------------------------------------


-------------------------------------Trigger on Users------------------------------------------
--All User will be added as a passenger--

DROP FUNCTION IF EXISTS update_passenger() CASCADE;
CREATE OR REPLACE FUNCTION update_passenger()
RETURNS TRIGGER AS 
$$ 
BEGIN
	INSERT INTO Passenger VALUES (NEW.uname,DEFAULT,DEFAULT, DEFAULT, DEFAULT);
	RAISE NOTICE 'New passenger added';
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER new_user
AFTER INSERT ON Users
FOR EACH ROW 
EXECUTE PROCEDURE update_passenger();





-------------------------------------Trigger on Passengers------------------------------------------

----Initial points upon sign-up----
DROP FUNCTION IF EXISTS award_points() CASCADE;
CREATE OR REPLACE FUNCTION award_points()
RETURNS TRIGGER AS 
$$ DECLARE newuname varchar(15);
BEGIN
	newuname := NEW.uname;
	INSERT INTO Obtains VALUES (NEW.uname, 'R000001', DEFAULT, DEFAULT);

	UPDATE Passenger P SET tpoints = tpoints + 50 WHERE P.uname = NEW.uname;
	UPDATE Passenger P SET cpoints = cpoints + 50 WHERE P.uname = NEW.uname;
	RAISE NOTICE 'Sign-Up points awarded';
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER new_passenger
AFTER INSERT ON Passenger
FOR EACH ROW 
EXECUTE PROCEDURE award_points();


----Upgrade of Membership----
DROP FUNCTION IF EXISTS upgrade_mship() CASCADE;
CREATE OR REPLACE FUNCTION upgrade_mship()
RETURNS TRIGGER AS 
$$ DECLARE newuname varchar(15);
BEGIN
	newuname := NEW.uname;
	RAISE NOTICE 'Mship Ugrade';
	IF NEW.tpoints >= 500 THEN                                             
		UPDATE Passenger SET mstatus = 'VIP' WHERE uname = newuname;        /* Upgrade to VIP when total points > 1000 */
	ELSE
		UPDATE Passenger SET mstatus = 'PREMIUM' WHERE uname = newuname;    /* Upgrade to Premium when total points > 500 */
	END IF;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_upgrade
AFTER INSERT OR UPDATE OF tpoints ON Passenger
FOR EACH ROW WHEN (NEW.tpoints >= 200)
EXECUTE PROCEDURE upgrade_mship();






-------------------------------------Trigger on Bid------------------------------------------

----When Customer bids for car, update curr_pax----
DROP FUNCTION IF EXISTS update_pax() CASCADE;
CREATE OR REPLACE FUNCTION update_pax()
RETURNS TRIGGER AS 
$$ DECLARE newuname1 varchar(15);
BEGIN 
	newuname1 := NEW.duname;                                         
	UPDATE Ride SET curr_bids = curr_bids + 1 WHERE uname = newuname1;
	RAISE NOTICE 'Bid curr pax updated';
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_bid
AFTER INSERT ON Bid
FOR EACH ROW
EXECUTE PROCEDURE update_pax();

----Trigger to check that bid price > ride's min_cost----

DROP FUNCTION IF EXISTS check_bid() CASCADE;
CREATE OR REPLACE FUNCTION check_bid()
RETURNS TRIGGER AS 
$$ DECLARE mincost integer;
BEGIN 
	SELECT min_cost INTO mincost
	FROM Ride R WHERE
	NEW.duname = R.uname 
	AND NEW.plate_num = R.plate_num
	AND NEW.origin = R.origin
	AND NEW.dest = R.dest
	AND NEW.pdatetime = R.pdatetime;
	
	IF NEW.price < mincost THEN
		RAISE NOTICE 'Bid too low!';
		RETURN NULL;
	ELSE 
		RAISE NOTICE 'Checked Bid Price';
		RETURN NEW;
	END IF;	
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER bid_placed
BEFORE INSERT ON Bid
FOR EACH ROW 
EXECUTE PROCEDURE check_bid();

----Trigger to update btime on update on Bid----

DROP FUNCTION IF EXISTS update_btime() CASCADE;
CREATE OR REPLACE FUNCTION update_btime()
RETURNS TRIGGER AS 
$$ 
BEGIN  

		UPDATE Bid SET btime = current_time WHERE
		puname = NEW.puname
		AND duname = NEW.duname
		AND plate_num = NEW.plate_num
		AND origin = NEW.origin
		AND dest = NEW.dest
		AND pdatetime = NEW.pdatetime;
		RAISE NOTICE 'btime updated';
		RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER price_update
AFTER UPDATE of price ON Bid
FOR EACH ROW 
EXECUTE PROCEDURE update_btime();


--open transaction--
DROP FUNCTION IF EXISTS open_transaction() CASCADE;
CREATE OR REPLACE FUNCTION open_transaction()
RETURNS TRIGGER AS 
$$ 
BEGIN  
	INSERT INTO Transactions VALUES (NEW.puname, NEW.duname, NEW.plate_num, NEW.origin, NEW.dest, NEW.pdatetime, DEFAULT, NEW.price, NEW.price, NULL, NULL, NULL, DEFAULT);
	RAISE NOTICE 'Transaction Opened';
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER bid_won
AFTER UPDATE of won ON Bid 
FOR EACH ROW WHEN (NEW.won = TRUE)
EXECUTE PROCEDURE open_transaction();






-------------------------------------Trigger on Ride------------------------------------------

----Check pmax <= num_seats when Drivers advertise Ride----
DROP FUNCTION IF EXISTS reject_ride() CASCADE;
CREATE OR REPLACE FUNCTION reject_ride()
RETURNS TRIGGER AS 
$$ DECLARE numseats integer;
BEGIN 

	SELECT (C.num_seats) INTO numseats
	FROM Car C
	WHERE NEW.uname = C.uname
	AND NEW.plate_num = C.plate_num;

	IF numseats < NEW.pmax THEN
		RAISE NOTICE 'Insufficient Seats';
		RETURN NULL;
	ELSE 
		RAISE NOTICE 'Checked Num_Seats';
		RETURN NEW;
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_pmax
BEFORE INSERT ON Ride
FOR EACH ROW 
EXECUTE PROCEDURE reject_ride();
-----------------------------------------------------------


----Trigger to check driver dont add ride 1hr within another ride----
DROP FUNCTION IF EXISTS remove_ride() CASCADE;
CREATE OR REPLACE FUNCTION remove_ride()
RETURNS TRIGGER AS 
$$ DECLARE 
BEGIN 
	
        IF EXISTS (
            SELECT 1 FROM Ride R
            WHERE NEW.uname = R.uname
            AND ((NEW.pdatetime > R.pdatetime AND NEW.pdatetime - INTERVAL '1 hour' <= R.pdatetime)
              OR (NEW.pdatetime < R.pdatetime AND NEW.pdatetime + INTERVAL '1 hour' >= R.pdatetime))
            LIMIT 1
        ) THEN
		RAISE NOTICE 'Ride Timing Violation';
		RETURN NULL;
	ELSE 
		RAISE NOTICE 'Checked Pick-up Time';
		RETURN NEW;
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_ride
BEFORE INSERT ON Ride
FOR EACH ROW 
EXECUTE PROCEDURE remove_ride();











-------------------------------------Trigger on Obtains------------------------------------------

----Trigger to deduct cpoints when Passenger obtains discount----

DROP FUNCTION IF EXISTS deduct_cpoints() CASCADE;
CREATE OR REPLACE FUNCTION deduct_cpoints()
RETURNS TRIGGER AS 
$$ DECLARE dcost integer;
BEGIN  

	SELECT cost INTO dcost 
	FROM Discount D  
	WHERE NEW.rcode = D.rcode;
	
	UPDATE Passenger
	SET cpoints = cpoints - dcost
	WHERE uname = NEW.uname;
	RAISE NOTICE 'Discount code bought';
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER deduct_cpoints
AFTER INSERT ON Obtains 
FOR EACH ROW WHEN (NEW.rcode LIKE 'D%')	
EXECUTE PROCEDURE deduct_cpoints();











-------------------------------------Trigger on Transactions------------------------------------------

----Trigger to update dtime on update on closure of Transaction---
DROP FUNCTION IF EXISTS update_dtime() CASCADE;
CREATE OR REPLACE FUNCTION update_dtime()
RETURNS TRIGGER AS 
$$ 
BEGIN  
	UPDATE Ride SET dtime = current_time 
	WHERE uname = NEW.duname  
	AND plate_num = NEW.plate_num
	AND origin = NEW.origin
	AND dest = NEW.dest
	AND pdatetime = NEW.pdatetime;
	RAISE NOTICE 'Drop time updated';
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trip_closed
AFTER UPDATE of closed ON Transactions 
FOR EACH ROW WHEN (NEW.closed = TRUE)
EXECUTE PROCEDURE update_dtime();

-- -- these are not just mock data because the triggers require these relations added to function
-- INSERT INTO Reward VALUES ('R000001', DEFAULT);
-- INSERT INTO Reward VALUES ('R000002', DEFAULT);
-- INSERT INTO Points VALUES ('R000001', 50);
-- INSERT INTO Points VALUES ('R000002', 5);
-- INSERT INTO Benefits VALUES ('B000001', 1);

--Trigger to add to tpoints, every 5 dollars = 10 points--
DROP FUNCTION IF EXISTS issue_points() CASCADE;
CREATE OR REPLACE FUNCTION issue_points()
RETURNS TRIGGER AS
$$ DECLARE price integer;
currtime TIMESTAMP;
BEGIN
	SELECT CURRENT_TIMESTAMP INTO currtime;

	SELECT tprice INTO price
	FROM Transactions T
	WHERE puname = NEW.puname
	AND duname = NEW.duname  
	AND plate_num = NEW.plate_num
	AND origin = NEW.origin
	AND dest = NEW.dest
	AND pdatetime = NEW.pdatetime;

	WHILE price >= 5 LOOP
		INSERT INTO Obtains VALUES (NEW.puname, 'R000002', currtime, DEFAULT);
		price := price - 5;
		currtime := currtime + INTERVAL '1 second';
		UPDATE Passenger SET tpoints = tpoints + 5 
		WHERE uname = NEW.puname;
		
		UPDATE Passenger SET cpoints = cpoints + 5 
		WHERE uname = NEW.puname;
	END LOOP; 
	RAISE NOTICE 'Points for ride issued';
	RETURN NULL;

	-- UPDATE Passenger P 
	-- SET P.tpoints = P.tpoints + ((NEW.tprice - (mod(NEW.tprice,5)))/5) * 10  
	-- WHERE NEW.puname = P.uname;
	-- RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER p_ride
AFTER UPDATE of closed ON Transactions
FOR EACH ROW WHEN (NEW.closed = TRUE)
EXECUTE PROCEDURE issue_points();



--Trigger to check redeem status
DROP FUNCTION IF EXISTS check_redeem() CASCADE;
CREATE OR REPLACE FUNCTION check_redeem()
RETURNS TRIGGER AS 
$$ DECLARE 
	redeem_status BOOLEAN;
	exp_date timestamp;
	disc_cost integer;
BEGIN  

	SELECT D.cost INTO disc_cost
	FROM Discount D
	WHERE D.rcode = NEW.r_redeem;

	SELECT O.expdate INTO exp_date
	FROM Obtains O 
	WHERE NEW.puname = O.uname
	AND NEW.r_redeem = O.rcode;

	SELECT O.redeemed INTO redeem_status
	FROM Obtains O 
	WHERE NEW.puname = O.uname
	AND NEW.r_redeem = O.rcode
	ORDER BY redeemed ASC;
	
	IF redeem_status = TRUE
	OR exp_date <= CURRENT_TIMESTAMP THEN
		RAISE NOTICE 'Expired discount';
		RETURN NULL;
	ELSE	
		RAISE NOTICE 'Discount Valid';
		RETURN NEW;
	END IF;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER user_redeem
BEFORE UPDATE OF r_redeem ON Transactions 
FOR EACH ROW 
EXECUTE PROCEDURE check_redeem();
----------------------------------------

--Trigger to change tprice with discount
DROP FUNCTION IF EXISTS update_price() CASCADE;
CREATE OR REPLACE FUNCTION update_price()
RETURNS TRIGGER AS 
$$ DECLARE 
	disc integer;
BEGIN  
	SELECT amt INTO disc 
	FROM Discount D  
	WHERE NEW.r_redeem = D.rcode;

	
	UPDATE Obtains
	SET redeemed = TRUE 
	WHERE uname = NEW.puname 
	AND rcode = NEW.r_redeem;


	UPDATE Transactions 
	SET tprice = tprice - disc
	WHERE puname = NEW.puname
	AND duname = NEW.duname  
	AND plate_num = NEW.plate_num
	AND origin = NEW.origin
	AND dest = NEW.dest
	AND pdatetime = NEW.pdatetime;

	RAISE NOTICE 'Discount applied';

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER dicount_used
AFTER UPDATE OF r_redeem ON Transactions 
FOR EACH ROW
EXECUTE PROCEDURE update_price();

--Average prating upon transaction--

DROP FUNCTION IF EXISTS update_prating() CASCADE;
CREATE OR REPLACE FUNCTION update_prating()
RETURNS TRIGGER AS 
$$ DECLARE 
	newrating numeric(3,2);
BEGIN  
	SELECT avg(prating) INTO newrating 
	FROM Transactions T  
	WHERE T.puname = NEW.puname;

	UPDATE Passenger 
	SET rating = newrating 
	WHERE uname = NEW.puname;
	RAISE NOTICE 'New average prating';
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER prating_added
AFTER UPDATE OF prating ON Transactions 
FOR EACH ROW
EXECUTE PROCEDURE update_prating();


--Average drating upon transaction--

DROP FUNCTION IF EXISTS update_drating() CASCADE;
CREATE OR REPLACE FUNCTION update_drating()
RETURNS TRIGGER AS 
$$ DECLARE 
	newrating numeric(3,2);
BEGIN  
	SELECT avg(drating) INTO newrating 
	FROM Transactions T  
	WHERE T.duname = NEW.duname;

	UPDATE Driver 
	SET rating = newrating 
	WHERE uname = NEW.duname;
	RAISE NOTICE 'New average drating';
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER drating_added
AFTER UPDATE OF drating ON Transactions 
FOR EACH ROW
EXECUTE PROCEDURE update_drating();

--Driver obtains benefit every rides--

DROP FUNCTION IF EXISTS issue_benefit() CASCADE;
CREATE OR REPLACE FUNCTION issue_benefit()
RETURNS TRIGGER AS 
$$
BEGIN  
	INSERT INTO Earns VALUES (NEW.duname, 'B000001', DEFAULT);
	RAISE NOTICE 'Driver earn benefit';
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER d_ride
AFTER UPDATE of closed ON Transactions 
FOR EACH ROW WHEN (NEW.closed = TRUE)
EXECUTE PROCEDURE issue_benefit();

