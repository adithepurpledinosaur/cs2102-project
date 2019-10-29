
--------------------------- TRIGGER FUNCTIONS --------------------------------------
DROP FUNCTION upgrade_mship() CASCADE;
CREATE OR REPLACE FUNCTION upgrade_mship()
RETURNS TRIGGER AS 
$$ DECLARE newuname varchar(15);
BEGIN
	newuname := NEW.uname;
	IF NEW.tpoints >= 1000 THEN
		UPDATE Passenger SET mstatus = 'VIP' WHERE uname = newuname;
	ELSE
		UPDATE Passenger SET mstatus = 'Premium' WHERE uname = newuname;
	END IF;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_upgrade
AFTER INSERT OR UPDATE of tpoints ON Passenger
FOR EACH ROW WHEN (NEW.tpoints >= 500)
EXECUTE PROCEDURE upgrade_mship();

UPDATE Passenger SET tpoints = 600 WHERE uname ='God';