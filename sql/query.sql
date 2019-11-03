--test query for Passenger to check records of transactions--
SELECT duname, dest, pdate, ptime, price 
FROM Transactions 
WHERE puname = 'God';

--test query for Driver to check records of transactions--
SELECT puname, dest, pdate, ptime, price 
FROM Transactions 
WHERE duname = 'Cob';

--test query for Passenger to check what discounts he can buy--
SELECT R.rcode, D.amt 
FROM Reward R, AltDiscount D, Passenger P 
WHERE r.cost <= P.cpoints 
    AND P.uname = 'God'
    AND R.rcode = D.rcode;