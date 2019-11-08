/* Change the schema default search path to 'group_project' (for current session only) */
--SET search_path = group_project;

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
            UPPER(gender) = 'M'
            OR UPPER(gender) = 'F'
          )   
);

CREATE TABLE Driver (
	uname varchar(15) PRIMARY KEY REFERENCES Users
		ON DELETE CASCADE,
	rating numeric (3,2) DEFAULT 5.00,				/* Default Driver rating */
	CHECK (											/* Ratings: Range of 0 to 5 inclusive */
		rating <= 5
	   	AND rating >= 0
		)
);

CREATE TABLE Passenger (
	uname varchar(15) PRIMARY KEY REFERENCES Users
		ON DELETE CASCADE,
	mstatus varchar(10) DEFAULT 'Member',			/* Membership status */
	tpoints integer DEFAULT 0,					/* Total accumalated reward points (upon joining: all members enjoy 100 points free) */
    cpoints integer DEFAULT 0,                    /* Current points user has after using points for Discount */
	rating numeric (3,2) DEFAULT 5.00,				/* Default Passenger rating */
	CHECK (											/* Ratings: Range of 0 to 5 inclusive */
		rating <= 5
	   	AND rating >= 0
		),
	CHECK (tpoints >= 0),							/* Check if tpoints is valid */
	CHECK (cpoints >= 0),							/* Check if cpoints is valid */ 
	CHECK (											/* Check if mstatus is valid */
			UPPER(mstatus) = 'MEMBER'
			OR UPPER(mstatus) = 'PREMIUM'
			OR UPPER(mstatus) = 'VIP'
		  )
);

/*---------------------------- 		DRIVER PART 		----------------------------------------*/

CREATE TABLE Car (
	uname varchar(15) REFERENCES Driver
		ON DELETE CASCADE,
	plate_num integer UNIQUE,				/* Plate number: Assuming all integers (eg. 1234, 1111, 0000) */
	num_seats integer,			 					/* Maximum capacity of the car, excluding driver */
	model varchar(7) NOT NULL,
	edate date NOT NULL,							/* End date of COE */
	PRIMARY KEY (uname, plate_num),
	CHECK (num_seats > 0),							/* Check if the mcap is valid */
	CHECK (											/* Check if the COE expiry: */
			date_part(								/* Minimum 1 year before expiry to register */
						'day',
					 	(now()::timestamp - edate::timestamp)
					 )
			>= 365
		  )
);

CREATE TABLE Ride (
	uname varchar(15),
	plate_num integer,
	pmax integer,									/* Maximum passengers driver accepts*/
	origin varchar(20),								/* Place to pick passenger up */
	dest varchar(20),								/* Destination: Place to drop passenger off */
	ptime time,										/* Pick-up time */
	pdate date,										/* Pick-up date */
	dtime time DEFAULT NULL,						/* Drop-off time */
	min_cost integer NOT NULL,						/* Minimum bid price */
	curr_bids integer DEFAULT 0,					/* Current number of bidders */
	FOREIGN KEY (uname, plate_num) REFERENCES Car
		ON DELETE CASCADE,
	PRIMARY KEY (uname, plate_num, origin, dest, ptime, pdate),
	CHECK (											/* Check if the ride is */
			pdate > current_date					/* at least 1hour from time of registration */
			OR
			(pdate = current_date AND ptime > (current_time + INTERVAL '1 hour'))
		  ),
	CHECK (min_cost > 0),
	CHECK (pmax > 0)								/* Check if pmax is valid */
													/* check (in trigger) if it is less than car's max cap */
);

CREATE TABLE Benefits (
	bcode char(7) PRIMARY KEY,
	bvalue integer NOT NULL,						/* Value of Benefit */	
	CHECK (value > 0)								/* Check if amt is valid */							

);
 
CREATE TABLE Earns (
	uname varchar(15) REFERENCES Driver,
	bcode char(7) REFERENCES Benefits,
	date_earned TIMESTAMP DEFAULT current_timestamp,
	PRIMARY KEY (uname, bcode, date_earned)
);

/*---------------------------- 		PASSENGER PART		 ----------------------------------------*/
CREATE TABLE Reward (
	rcode char(7) PRIMARY KEY,						/* Reward code (Eg. ABC0000) */
	expired boolean DEFAULT false,					/* States if reward has expired */
	CHECK (											/* D = Discount, P = Point */
			UPPER(rcode) LIKE 'D%'
		   	OR
			UPPER(rcode) LIKE 'P%'
		  )
);

CREATE TABLE Discount (							/* Able to use the amount to deduct the ride fee */
	rcode char(7) PRIMARY KEY REFERENCES Reward
		ON DELETE CASCADE,
	cost integer NOT NULL,						/* Cost of points to redeem */
	amt integer NOT NULL,						/* Value of Discount Code */	
	CHECK (amt > 0)								/* Check if amt is valid */							

);

CREATE TABLE Points (								/* Able to use points to redeem discount codes */
	rcode char(7) PRIMARY KEY REFERENCES Reward
		ON DELETE CASCADE,
	amt integer NOT NULL,							/* Amt of points */
	CHECK (amt > 0)								/* Check if amt is valid */ 
);

CREATE TABLE Obtains (								/* Passenger has... */
	uname varchar(15) REFERENCES Passenger,
	rcode char(7) REFERENCES Reward,
	expdate timestamp DEFAULT 						/* Expiry date */
		(
			current_timestamp + interval '3 months'
		),
	redeemed boolean DEFAULT FALSE,				/* States if the discount has been redeemed */
	PRIMARY KEY (uname, rcode, expdate),
	CHECK (expdate - interval '3 months' >= current_timestamp)			/* Check if the timestamp is valid */
);

CREATE TABLE Bid (
	puname varchar(15),
	duname varchar(15),
	plate_num integer,
	origin varchar(20),
	dest varchar(20),
	ptime time,
	pdate date,	
	won boolean DEFAULT FALSE,						/* States if the passenger has won the bid */
	price integer NOT NULL,							/* Price of the bid */
	btime time DEFAULT current_time,				/* Time of bid, updates when User updates Bid to change the bid price */
	FOREIGN KEY (puname)
		REFERENCES Passenger (uname)
		ON DELETE CASCADE,
	FOREIGN KEY (duname, plate_num, origin, dest, ptime, pdate)
		REFERENCES Ride (uname, plate_num, origin, dest, ptime, pdate)
		ON DELETE CASCADE,
	PRIMARY KEY (puname, duname, plate_num, origin, dest, ptime, pdate),
	CHECK (ptime > current_time + INTERVAL '1 hour'), /* Check that time passenger bids is 1hr before ride */
	CHECK (puname <> duname),						/* Make sures that the passenger and driver are not the same person */
	CHECK (price > 0)								/* Checks if the price is valid */
);
/*---------------------------- 		TRANSACTION PART		 ----------------------------------------*/



CREATE TABLE Transactions (
	tcode varchar(15) PRIMARY KEY,
	puname varchar(15),
	duname varchar(15),
	plate_num integer,
	origin varchar(20),
	dest varchar(20),
	ptime time,
	pdate date,
	r_issue char(7),
	r_redeem char (7) DEFAULT NULL,
	tprice integer,									/* Total price Passenger paid */
	prating integer,								/* Rating given to passenger by driver */
	drating integer,								/* Rating given to driver by passenger */
	ptype varchar(7) NOT NULL,
	closed boolean DEFAULT FALSE,
	FOREIGN KEY (puname)
		REFERENCES Passenger (uname),
	FOREIGN KEY (r_issue)
		REFERENCES Reward (rcode),
	FOREIGN KEY (r_redeem)
		REFERENCES Reward (rcode),
	FOREIGN KEY (duname, plate_num, origin, dest, ptime, pdate)
		REFERENCES Ride (uname, plate_num, origin, dest, ptime, pdate),
	CHECK (puname <> duname),						/* Make sures that the passenger */
													/* and driver are not the same person */
	CHECK (											/* Passenger ratings: Range of 0 to 5 inclusive */
			prating <= 5
		   	AND prating >= 0
		  ),
	CHECK (											/* Driver ratings: Range of 0 to 5 inclusive */
			drating <= 5
		   	AND drating >= 0
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
