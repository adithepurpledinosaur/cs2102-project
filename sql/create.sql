/* Change the schema default search path to 'group_project' (for current session only) */
SET search_path = group_project;

/* Create the relational schemas */
CREATE TABLE Users (
	uname varchar(15) PRIMARY KEY, 					/* Username */
	pwd varchar(100) NOT NULL, 						/* Password */
	fname varchar(50) NOT NULL, 					/* Full name */
	name varchar(15), 								/* Nickname that is preferred */
	gender char(1), 								/* F = Female, M = Male */
	dob date, 										/* Date of birth */
	addr varchar(100), 								/* Address */
	cdate date DEFAULT current_date,				/* Date of account creation */
	CHECK (cdate >= current_date),					/* Check if date is valid */
	CHECK (date_part('year', age(dob)) >= 16),		/* Check if user is 16 y/o and above */
    CHECK (                                         /* Check gender */
            gender = 'M'
            OR gender = 'F'
          )   
);

CREATE TABLE Driver (
	uname varchar(15) PRIMARY KEY REFERENCES Users
		ON DELETE CASCADE,
	expr integer NOT NULL 							/* Experience */
	CHECK (expr >= 0)								/* Check if experience is valid */
);

CREATE TABLE Passenger (
	uname varchar(15) PRIMARY KEY REFERENCES Users
		ON DELETE CASCADE,
	mid SERIAL NOT NULL,							/* Candidate key: Membership ID */
	mstatus varchar(10) DEFAULT 'Member',			/* Membership status */
	tpoints integer DEFAULT 100,					/* Total accumalated reward points (upon joining: all members enjoy 100 points free) */
    cpoints integer DEFAULT 100,                    /* Current points user has after using points for Discount */
	CHECK (tpoints >= 0),							/* Check if tpoints is valid */
	CHECK (cpoints >= 0),							/* Check if cpoints is valid */ 
	CHECK (											/* Check if mstatus is valid */
			mstatus = 'Member'
			OR mstatus = 'Premium'
			OR mstatus = 'VIP'
		  )
);

/*---------------------------- 		DRIVER PART 		----------------------------------------*/

CREATE TABLE Car (
	uname varchar(15) REFERENCES Driver
		ON DELETE CASCADE,
	plate_no integer NOT NULL,						/* Plate number: Assuming all integers (eg. 1234, 1111, 0000) */
	model varchar(7) NOT NULL,
	sdate date NOT NULL,							/* Start date of COE: Expires in 10 years */
	num_seats integer NOT NULL,
	PRIMARY KEY (uname, plate_no,num_seats),
	CHECK (date_part('year',age(sdate)) >= 1)		/* Check if the COE expiry: Minimum 1 year before expiry to register */
);

CREATE TABLE Ride (
	uname varchar(15),
	plate_no integer,
	num_seats integer,
	origin varchar(20),								/* Place to pick passenger up */
	dest varchar(20),								/* Destination: Place to drop passenger off */
	ptime time,										/* Pick-up time */
	pdate date,										/* Pick-up date */
	dtime time,										/* Drop-off time */
	curr_pax integer DEFAULT 0,
	FOREIGN KEY (uname, plate_no, num_seats) REFERENCES Car
		ON DELETE CASCADE,
	PRIMARY KEY (uname, plate_no, origin, dest, ptime, pdate),
	CHECK (											/* Check if the ride is at least 1hour from time of registration */
			pdate > current_date
			OR
			(pdate = current_date AND ptime > (current_time + INTERVAL '1 hour'))
		  )
);

CREATE TABLE DObtains (									/* Driver obtain driver rewards */
	uname varchar(15) REFERENCES Driver,
	rcode char(7) REFERENCES DReward,
	expdate timestamp DEFAULT (current_timestamp + interval '3 months'),	/* Date and time of issue */
	PRIMARY KEY (uname, rcode)
)

-- /*---------------------------- 		PASSENGER PART		 ----------------------------------------*/

-- CREATE TABLE Reward (
-- 	rcode char(7) PRIMARY KEY,						/* Reward code (Eg. ABC0000) */
-- 	rid SERIAL NOT NULL,							/* Candidate key: Reward ID */
-- 	CHECK (											/* D = Discount, P = Point */
-- 			rcode LIKE 'D%'
-- 		   	OR rcode LIKE 'P%'
-- 		  )
-- );

-- CREATE TABLE Discount (								/* Able to use the amount to deduct the ride fee */
-- 	rcode char(7) PRIMARY KEY REFERENCES Reward
-- 		ON DELETE CASCADE,
-- 	duration integer,								/* Life span of the discount - Null = Forever */
-- 	redeemed boolean DEFAULT FALSE,					/* States if the discount has been redeemed */
-- 	CHECK (duration > 0)							/* Check if duration is valid */
-- );

-- CREATE TABLE Points (								/* Able to use points to redeem discount codes */
-- 	rcode char(7) PRIMARY KEY REFERENCES Reward
-- 		ON DELETE CASCADE
-- );

-- CREATE TABLE Obtains (								/* Passenger has... */
-- 	uname varchar(15) REFERENCES Passenger,
-- 	rcode char(7) REFERENCES Reward,
-- 	amt integer NOT NULL,							/* Amount given: $$ dicounted, # of points */
-- 	sdatetime timestamp DEFAULT current_timestamp,	/* Date and time of issue */
-- 	PRIMARY KEY (uname, rcode, sdatetime),
-- 	CHECK (amt > 0),								/* Check if amt is valid */
-- 	CHECK (sdatetime >= current_timestamp)			/* Check if the timestamp is valid */
-- );


-- CREATE TABLE Bids (
-- 	puname varchar(15),
-- 	duname varchar(15),
-- 	plate_no integer,
-- 	origin varchar(20),
-- 	dest varchar(20),
-- 	ptime time,
-- 	pdate date,	
-- 	won boolean DEFAULT FALSE,						/* States if the passenger has won the bid */
-- 	price integer NOT NULL,							/* Price of the bid */
-- 	FOREIGN KEY (puname)
-- 		REFERENCES Passenger (uname)
-- 		ON DELETE CASCADE,
-- 	FOREIGN KEY (duname, plate_no, origin, dest, ptime, pdate)
-- 		REFERENCES Ride (uname, plate_no, origin, dest, ptime, pdate)
-- 		ON DELETE CASCADE,
-- 	PRIMARY KEY (puname, duname, plate_no, origin, dest, ptime, pdate),
-- 	CHECK (ptime > current_time + INTERVAL '1 hour'), /* Check that time passenger bids is 1hr before ride */
-- 	CHECK (puname <> duname),						/* Make sures that the passenger and driver are not the same person */
-- 	CHECK (price > 0)								/* Checks if the price is valid */
-- );

------------------------------------ALTERNATE SUGGESTION-----------------------------------
--is there a need for a points table? We can update points as a trigger?
--Cases where points increase: 1) after every trip  2)After 10 rides?(idk if we want to do)
--in any case we can do without a point table
CREATE TABLE Reward (
	rcode char(7) PRIMARY KEY,						/* Reward code (Eg. ABC0000) */
	rid SERIAL NOT NULL,							/* Candidate key: Reward ID */
	cost integer NOT NULL,
	CHECK (											/* D = Discount, P = Point */
			rcode LIKE 'D%'
		   	OR rcode LIKE 'P%'
		  )
);

CREATE TABLE AltDiscount (							/* Able to use the amount to deduct the ride fee */
	rcode char(7) PRIMARY KEY REFERENCES Reward
		ON DELETE CASCADE,
 	amt integer NOT NULL,									/* Value of disc*/
	CHECK (amt > 0)
);

-- CREATE TABLE Points (								/* Able to use points to redeem discount codes */
-- 	rcode char(7) PRIMARY KEY REFERENCES Reward
-- 		ON DELETE CASCADE
-- );

CREATE TABLE AltObtains (								/* Passenger has... */
	uname varchar(15) REFERENCES Passenger,
	rcode char(7) REFERENCES Reward,
	expdate timestamp DEFAULT (current_timestamp + interval '3 months'),	/* Date and time of issue */
	PRIMARY KEY (uname, rcode)
);

CREATE TABLE Bid (
	puname varchar(15),
	duname varchar(15),
	plate_no integer,
	origin varchar(20),
	dest varchar(20),
	ptime time,
	pdate date,	
	won boolean DEFAULT FALSE,						/* States if the passenger has won the bid */
	price integer NOT NULL,							/* Price of the bid */
	FOREIGN KEY (puname)
		REFERENCES Passenger (uname)
		ON DELETE CASCADE,
	FOREIGN KEY (duname, plate_no, origin, dest, ptime, pdate)
		REFERENCES Ride (uname, plate_no, origin, dest, ptime, pdate)
		ON DELETE CASCADE,
	PRIMARY KEY (puname, duname, plate_no, origin, dest, ptime, pdate),
	CHECK (ptime > current_time + INTERVAL '1 hour'), /* Check that time passenger bids is 1hr before ride */
	CHECK (puname <> duname),						/* Make sures that the passenger and driver are not the same person */
	CHECK (price > 0)								/* Checks if the price is valid */
);
/*---------------------------- 		TRANSACTION PART		 ----------------------------------------*/

CREATE TABLE Payment (
	pcode char(7) PRIMARY KEY,						/* Payment code (Eg. ABC0000) */
	pid SERIAL NOT NULL,							/* Candidate key: Payment ID */
	CHECK (											/* CH = Cash, CD = Card */
			pcode LIKE 'CH%'
		   	OR pcode LIKE 'CD%'
		  )
);

CREATE TABLE Cash (									/* Cash payment for the ride */
	pcode char(7) PRIMARY KEY REFERENCES Payment
		ON DELETE CASCADE
);

CREATE TABLE Card (									/* Card payment for the ride */
	pcode char(7) PRIMARY KEY REFERENCES Payment
		ON DELETE CASCADE,
	surcharge numeric(2, 2) NOT NULL,						/* Extra xx.xx% of the total bill for administrative fees of using a card payment */
	ctype varchar(15) NOT NULL,						/* Type of card payment */
	company varchar(10) NOT NULL,					/* Card company */
	CHECK (											/* Check if surcharge is valid: Maximum of 50% surcharge */
			surcharge >= 0.00
		   	OR surcharge <= 50.00
		  ),
	CHECK (											/* Check if ctype is valid: System only applicable for nets/credit/paywave transactions*/
			ctype = 'NETS'
		   	OR ctype = 'CREDIT'
			OR ctype = 'PAYWAVE'
		  ),
	CHECK (											/* Check if company is valid: System only applicable for Master/Visa transactions */
			company = 'MASTER'
		   	OR company = 'VISA'
		  )
);

CREATE TABLE Transacts (
	puname varchar(15),
	duname varchar(15),
	plate_no integer,
	origin varchar(20),
	dest varchar(20),
	ptime time,
	pdate date,
	paycode char(7),
	prating integer,								/* Rating given to passenger by driver */
	drating integer,								/* Rating given to driver by passenger */
	closed boolean DEFAULT FALSE,

	FOREIGN KEY (puname)
		REFERENCES Passenger (uname)
		ON DELETE CASCADE,
	FOREIGN KEY (duname, plate_no, origin, dest, ptime, pdate)
		REFERENCES Ride (uname, plate_no, origin, dest, ptime, pdate)
		ON DELETE CASCADE,
	FOREIGN KEY (paycode)							/* If payment method is removed, FK set to NULL */
		REFERENCES Payment (pcode)
		ON DELETE SET NULL,
	PRIMARY KEY (puname, duname, plate_no, origin, dest, ptime, pdate, paycode),
	CHECK (puname <> duname),						/* Make sures that the passenger and driver are not the same person */
	CHECK (											/* Passenger ratings are in range of 0 to 5 inclusive */
			prating <= 5
		   	OR prating >= 0
		  ),
	CHECK (											/* Driver ratings are in range of 0 to 5 inclusive */
			drating <= 5
		   	OR drating >= 0
		  )
);

--review rewards system. For every trip, they obtain points? (according to price paid)
--this can also be a trigger: upon insert on transaction, update points on Passenger uname
--another trigger: upon points accumalated > threshold -> upgrade mship status
--upon creation of acc, and upgrade of mship status, user gets a Discount code
--find a way to track what Discounts user has -> create table Has_discount (uname, D)
--make our life easier, make default discount codes last for 3 months

--should pcode be the primary key in Transact instead? 
--So pcode in payment,card,cash will be foreign keys referecing Transacts.
--potential area to put trigger? Upon adding transaction, update payment 	
