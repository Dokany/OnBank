/******************************************
CSCE 253/2501
Summer 2018
Project 1

Mohamed T Abdelrahman (ID no. 900142457)
Yasmin ElDokany (ID no. 900131538)
******************************************/

-- Insert Teller Data
INSERT INTO `teller` (TUsername, TPassword, TLastLogin)
VALUES ('hudson.jalyn','$2y$10$TLV6G8.SK5skdGlTF0LIWuN8p3VeJeIQLSoZHhiKja7idmY77ZKea','0000-00-00 00:00:00'),
('halie07','$2y$10$Ur1OXcDZbp7siWv19A0D1.98v6QRlCbFrs1akvGa/cV6Mxmw.D9sC','0000-00-00 00:00:00'),
('garrett68','$2y$10$XjEsLw/T5ugnXS7z9hYwn./4k5EmdRPqPgUE72lR6DslYKoyRCInK','2018-06-17 05:21:28'),
('ole84','$2y$10$Nmcp22SClJUbC/Df6Qc6xeKevYF2RQP.st39JN/H72b9lhTlNLb.2','0000-00-00 00:00:00'),
('hoppe.dakota','$2y$10$LCEc326gWqTm1DqvasxXyO1K1VpWjd5Ut4h1sS6lujXSF0UjJOAuO','0000-00-00 00:00:00');

-- Insert Administrator Data
INSERT INTO `administrator` (AUsername, APassword, ALastLogin)
VALUES ('lreilly','$2y$10$bKuXoZoJOu6e5pbpmVv.vOU9barvdximBm1/voKgLTUE/Pw3ayTzm','0000-00-00 00:00:00'),
('idurgan','$2y$10$bnvKDNv/y4jDxJ9fdspCAu3aWd/Ct8W98G2WyRvqsNI01hOrWFBqa','0000-00-00 00:00:00'),
('skub','$2y$10$UaUU7UJ.siFaujJ2Yvxk1uHhuhxSPBwV7E/Ps.G5Ab4F5GpfCKwJO','0000-00-00 00:00:00'),
('helmet86','$2y$10$kwvyA8drqCEk5zHl.N6Hfew556x35wPmCe6rjRNess8DfFavUS4na','0000-00-00 00:00:00'),
('bernie99','$2y$10$2v3riKEO9ML44ArEwmqDjOeHTcLv0XgtHea8WJ8Tb/Dd4uvyoqzEK','0000-00-00 00:00:00'); 

-- Insert Client Data
INSERT INTO `client` (NIN, Fname, Lname, CUsername, CPassword, BDate, Address, PhoneNo, Email, CLastLogin)
VALUES ('4024007162850','Kaycee','Shields','kaycee73','$2y$10$brZPeyYZ8atuRtdM9A.7rOuabLiqvs5Cc3jkG/SnFPW67ZhjX1yoK','1973-11-13','80546 Cormier Locks','003119966','dokany@aucegypt.edu','0000-00-00 00:00:00'),
('4024007169161','Blanca','Jacobson','bjacob','$2y$10$fr6rpC6efV1nhMQJ1W8d3e8FahBHLfOgrRWY63qHJZI0X3HuZ4Joi','1978-09-11','658 Bruce Turnpike','003119966','dokany@aucegypt.edu','0000-00-00 00:00:00'),
('52921656733759','Noemi','D\'Amore','namore','$2y$10$pNCQ73S3G7wT2PY6fgvEJuv3VYhavo4zIHV3fUq53C2VoVsBO3aK6','1972-01-31','32862 Celestine Caus','003119966','dokany@aucegypt.edu','0000-00-00 00:00:00'),
('47162735623084','Hailie','Vada','hailie.vada','$2y$10$p.0nmPnQvUxITvSnr0sSkeel822vABb98AZ3d29hpFIsepsWDnbv.','2005-08-29','646 Upton Branch','003119966','dokany@aucegypt.edu','0000-00-00 00:00:00'),
('4539248772654','Yasmin','ElDokany','dokany','$2y$10$Jp6vXHk.V6eVq8KwrV0CAewc2dYPgiVIvLbqhmvE.HeMhYZGaxCwO','1996-03-16','812 Wiza Inlet Hat','003119966','dokany@aucegypt.edu','0000-00-00 00:00:00'); 

-- Insert Owner_Info Data
INSERT INTO `owner_info`
VALUES ('4024007162850','Kaycee','Shields'),
('4024007169161','Blanca','Jacobson'),
('52921656733759','Noemi','D\'Amore'),
('47162735623084','Hailie','Vada'),
('4539248772654','Yasmin','ElDokany'),
('52721912130386','Kariane','Torp'),
('53417184710584','Maye','Goyette'),
('55902410023542','Naomie','Crona'); 

-- Insert Account_Type Data
INSERT INTO `account_type` (`AcctType`, `InterestRate`)
VALUES ('c', '0.0000'),
('s', '0.0075');

-- Insert Currency Data
INSERT INTO `currency`
VALUES ('USD'),
('EGP'),
('EUR');

-- Insert Currency Exchange Data
-- REFERENCE: https://www.xe.com/currencytables/?from=EGP&date=2018-07-01
INSERT INTO `currency_exchange`
VALUES ('USD', 'EGP', 17.8725),
('USD', 'EUR', 0.8555),
('EGP', 'USD', 0.0560),
('EGP', 'EUR', 0.0479),
('EUR', 'USD', 1.1689),
('EUR', 'EGP', 20.8912);

-- Insert Account Data
INSERT INTO `account` (Balance, AcctType, Abbreviation, NIN)
VALUES (10683.5000,'s','EUR','4024007162850'),
(603.5400,'s','EGP','4024007169161'),
(-10.7580,'c','EGP','52921656733759'),
(2683.0680,'c','EGP','47162735623084'),
(5100.7900,'c','USD','4539248772654'),
(256.5477,'s','EUR','52721912130386'),
(83.7780,'s','USD','53417184710584'),
(200683.7000,'c','EGP','55902410023542');