
--------------------------- TRIGGER FUNCTIONS --------------------------------------

----Upgrade of Membership----
DROP FUNCTION upgrade_mship() CASCADE;
CREATE OR REPLACE FUNCTION upgrade_mship()
RETURNS TRIGGER AS 
$$ DECLARE newuname varchar(15);
BEGIN
	newuname := NEW.uname;
	RAISE NOTICE 'Mship Ugrade';
	IF NEW.tpoints >= 1000 THEN                                             
		UPDATE Passenger SET mstatus = 'VIP' WHERE uname = newuname;        /* Upgrade to VIP when total points > 1000 */
	ELSE
		UPDATE Passenger SET mstatus = 'Premium' WHERE uname = newuname;    /* Upgrade to Premium when total points > 500 */
	END IF;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_upgrade
AFTER INSERT OR UPDATE of tpoints ON Passenger
FOR EACH ROW WHEN (NEW.tpoints >= 500)
EXECUTE PROCEDURE upgrade_mship();


--query check: UPDATE Passenger Set tpoints = tpoints + 200 WHERE uname = 'God';--
----------------------------

----When Customer bids for car, update curr_pax----
DROP FUNCTION update_pax() CASCADE;
CREATE OR REPLACE FUNCTION update_pax()
RETURNS TRIGGER AS 
$$ DECLARE newuname1 varchar(15);
BEGIN 
	RAISE NOTICE 'Bid added';
	newuname1 := NEW.duname;                                         
	UPDATE Ride SET curr_pax = curr_pax + 1 WHERE uname = newuname1;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_bid
AFTER INSERT ON Bid
FOR EACH ROW
EXECUTE PROCEDURE update_pax();
------------------------------------------------


----When Customer ObtainsDiscounts, update curr_points----
----------------------------------------------------------
