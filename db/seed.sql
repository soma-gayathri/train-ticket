-- Illustrative sample schedules. Not verified travel information.
INSERT OR IGNORE INTO fare_rules (travel_class, label, base_paise, per_leg_paise) VALUES
('SL', 'Sleeper', 5000, 2000),
('3A', 'AC 3 Tier', 10000, 4500),
('2A', 'AC 2 Tier', 15000, 7000),
('CC', 'AC Chair Car', 8000, 3500);
INSERT OR IGNORE INTO stations (code, name) VALUES
('NDLS', 'New Delhi'),
('DEC', 'Delhi Cantt'),
('GGN', 'Gurugram'),
('RE', 'Rewari Junction'),
('AWR', 'Alwar Junction'),
('BKI', 'Bandikui Junction'),
('GADJ', 'Gandhinagar Jaipur'),
('JP', 'Jaipur Junction'),
('AII', 'Ajmer Junction'),
('BCT', 'Mumbai Central'),
('BVI', 'Borivali'),
('VAPI', 'Vapi'),
('ST', 'Surat'),
('BRC', 'Vadodara Junction'),
('ADI', 'Ahmedabad Junction'),
('SBC', 'KSR Bengaluru'),
('BNC', 'Bengaluru Cantt'),
('KPD', 'Katpadi Junction'),
('AJJ', 'Arakkonam Junction'),
('MAS', 'Chennai Central'),
('AGC', 'Agra Cantt'),
('GWL', 'Gwalior Junction'),
('VGLJ', 'Virangana Lakshmibai Jhansi'),
('BPL', 'Bhopal Junction');
INSERT OR IGNORE INTO trains (number, name, type) VALUES
('12015', 'Ajmer Shatabdi Express', 'Shatabdi'),
('12958', 'Swarna Jayanti Rajdhani', 'Rajdhani'),
('12916', 'Ashram Express', 'Superfast'),
('12016', 'New Delhi Shatabdi Express', 'Shatabdi'),
('12951', 'Mumbai Rajdhani Express', 'Rajdhani'),
('12931', 'Ahmedabad Double Decker', 'Superfast'),
('12932', 'Mumbai Double Decker', 'Superfast'),
('12028', 'Chennai Shatabdi Express', 'Shatabdi'),
('12658', 'Chennai Mail', 'Superfast'),
('12027', 'Bengaluru Shatabdi Express', 'Shatabdi'),
('12002', 'Bhopal Shatabdi Express', 'Shatabdi');
INSERT OR IGNORE INTO train_stops (train_number, stop_order, station_code, arrival, departure, arrival_day, departure_day) VALUES
('12015', 0, 'NDLS', NULL, '06:10', 0, 0),
('12015', 1, 'DEC', '06:38', '06:40', 0, 0),
('12015', 2, 'GGN', '06:56', '06:58', 0, 0),
('12015', 3, 'RE', '07:40', '07:42', 0, 0),
('12015', 4, 'AWR', '08:30', '08:32', 0, 0),
('12015', 5, 'BKI', '09:15', '09:17', 0, 0),
('12015', 6, 'GADJ', '10:03', '10:05', 0, 0),
('12015', 7, 'JP', '10:15', '10:20', 0, 0),
('12015', 8, 'AII', '12:50', NULL, 0, 0),
('12958', 0, 'NDLS', NULL, '19:55', 0, 0),
('12958', 1, 'GGN', '20:30', '20:32', 0, 0),
('12958', 2, 'JP', '00:20', '00:30', 1, 1),
('12958', 3, 'AII', '02:25', '02:30', 1, 1),
('12958', 4, 'ADI', '08:45', NULL, 1, 1),
('12916', 0, 'NDLS', NULL, '15:20', 0, 0),
('12916', 1, 'DEC', '15:48', '15:50', 0, 0),
('12916', 2, 'GGN', '16:06', '16:08', 0, 0),
('12916', 3, 'RE', '16:55', '17:00', 0, 0),
('12916', 4, 'AWR', '18:02', '18:05', 0, 0),
('12916', 5, 'BKI', '19:00', '19:02', 0, 0),
('12916', 6, 'JP', '20:20', '20:30', 0, 0),
('12916', 7, 'AII', '22:40', '22:45', 0, 0),
('12916', 8, 'ADI', '06:20', NULL, 1, 1),
('12016', 0, 'AII', NULL, '15:45', 0, 0),
('12016', 1, 'JP', '17:35', '17:40', 0, 0),
('12016', 2, 'GADJ', '17:49', '17:51', 0, 0),
('12016', 3, 'BKI', '18:40', '18:42', 0, 0),
('12016', 4, 'AWR', '19:20', '19:22', 0, 0),
('12016', 5, 'RE', '20:15', '20:17', 0, 0),
('12016', 6, 'GGN', '21:00', '21:02', 0, 0),
('12016', 7, 'DEC', '21:18', '21:20', 0, 0),
('12016', 8, 'NDLS', '21:50', NULL, 0, 0),
('12951', 0, 'BCT', NULL, '17:00', 0, 0),
('12951', 1, 'BVI', '17:28', '17:30', 0, 0),
('12951', 2, 'ST', '19:43', '19:48', 0, 0),
('12951', 3, 'BRC', '21:18', '21:28', 0, 0),
('12951', 4, 'NDLS', '08:35', NULL, 1, 1),
('12931', 0, 'BCT', NULL, '14:30', 0, 0),
('12931', 1, 'BVI', '15:02', '15:04', 0, 0),
('12931', 2, 'VAPI', '16:48', '16:50', 0, 0),
('12931', 3, 'ST', '18:00', '18:05', 0, 0),
('12931', 4, 'BRC', '19:40', '19:45', 0, 0),
('12931', 5, 'ADI', '21:35', NULL, 0, 0),
('12932', 0, 'ADI', NULL, '06:00', 0, 0),
('12932', 1, 'BRC', '07:35', '07:40', 0, 0),
('12932', 2, 'ST', '09:10', '09:15', 0, 0),
('12932', 3, 'VAPI', '10:30', '10:32', 0, 0),
('12932', 4, 'BVI', '12:20', '12:22', 0, 0),
('12932', 5, 'BCT', '13:00', NULL, 0, 0),
('12028', 0, 'SBC', NULL, '06:00', 0, 0),
('12028', 1, 'BNC', '06:10', '06:12', 0, 0),
('12028', 2, 'KPD', '09:08', '09:10', 0, 0),
('12028', 3, 'AJJ', '10:00', '10:02', 0, 0),
('12028', 4, 'MAS', '11:00', NULL, 0, 0),
('12658', 0, 'SBC', NULL, '22:40', 0, 0),
('12658', 1, 'BNC', '22:50', '22:52', 0, 0),
('12658', 2, 'KPD', '02:35', '02:40', 1, 1),
('12658', 3, 'AJJ', '03:30', '03:32', 1, 1),
('12658', 4, 'MAS', '04:40', NULL, 1, 1),
('12027', 0, 'MAS', NULL, '17:30', 0, 0),
('12027', 1, 'AJJ', '18:25', '18:27', 0, 0),
('12027', 2, 'KPD', '19:15', '19:17', 0, 0),
('12027', 3, 'BNC', '22:10', '22:12', 0, 0),
('12027', 4, 'SBC', '22:25', NULL, 0, 0),
('12002', 0, 'NDLS', NULL, '06:00', 0, 0),
('12002', 1, 'AGC', '07:50', '07:55', 0, 0),
('12002', 2, 'GWL', '09:10', '09:15', 0, 0),
('12002', 3, 'VGLJ', '10:25', '10:30', 0, 0),
('12002', 4, 'BPL', '14:00', NULL, 0, 0);

-- Additional popular destinations; station codes verified against Indian Railways.
INSERT OR IGNORE INTO stations (code, name) VALUES
('ASR', 'Amritsar Junction'),
('AWB', 'Aurangabad'),
('AY', 'Ayodhya'),
('ANV', 'Annavaram'),
('AK', 'Akola Junction'),
('ABKP', 'Ambikapur'),
('AD', 'Adoni'),
('ANND', 'Anand Junction'),
('ASN', 'Asansol Junction'),
('ARA', 'Ara Junction'),
('AGTL', 'Agartala'),
('BSB', 'Varanasi Junction'),
('BBS', 'Bhubaneswar'),
('BSP', 'Bilaspur Junction'),
('BKN', 'Bikaner Junction'),
('BJU', 'Barauni Junction'),
('BGP', 'Bhagalpur'),
('BE', 'Bareilly Junction'),
('BWN', 'Bardhaman Junction'),
('BTE', 'Bharatpur'),
('BJP', 'Vijayapura'),
('BGK', 'Bagalkot'),
('BGM', 'Belagavi'),
('BTI', 'Bathinda Junction'),
('BDTS', 'Bandra Terminus'),
('CDG', 'Chandigarh'),
('CGL', 'Chengalpattu Junction'),
('CLT', 'Kozhikode'),
('CAN', 'Kannur'),
('CSMT', 'Mumbai Chhatrapati Shivaji Maharaj Terminus'),
('CTC', 'Cuttack'),
('CPR', 'Chhapra Junction'),
('CHZ', 'Charlapalli'),
('CCT', 'Kakinada Town'),
('CNB', 'Kanpur Central Junction'),
('DBG', 'Darbhanga Junction'),
('DDN', 'Dehradun'),
('DHN', 'Dhanbad Junction'),
('DLI', 'Delhi Junction'),
('DHNE', 'Dhone Junction'),
('DWR', 'Dharwad'),
('DG', 'Dindigul Junction'),
('DJ', 'Darjeeling'),
('DHD', 'Dahod'),
('DNR', 'Danapur'),
('ETW', 'Etawah Junction'),
('ET', 'Itarsi Junction'),
('EE', 'Eluru'),
('FBD', 'Farrukhabad Junction'),
('FD', 'Faizabad Junction'),
('FZR', 'Firozpur Cantt. Junction'),
('FKA', 'Fazilka Junction'),
('FTP', 'Fatehpur'),
('GAYA', 'Gaya Junction'),
('GKP', 'Gorakhpur Junction'),
('GNT', 'Guntur Junction'),
('GHY', 'Guwahati'),
('GIMB', 'Gandhidham Junction'),
('GD', 'Gonda Junction'),
('GDR', 'Gudur Junction'),
('GUNA', 'Guna'),
('GZB', 'Ghaziabad Junction'),
('HWH', 'Howrah'),
('HYB', 'Hyderabad Deccan'),
('HDW', 'Haldwani'),
('HRR', 'Harihar'),
('HJP', 'Hajipur Junction'),
('HTE', 'Hatia'),
('HSR', 'Hisar Junction'),
('HPT', 'Hosapete Junction'),
('HX', 'Kadapa'),
('INDB', 'Indore Junction'),
('IPR', 'Islampur'),
('IZN', 'Izzatnagar Junction'),
('JU', 'Jodhpur Junction'),
('JAT', 'Jammu Tawi'),
('JUC', 'Jalandhar City Junction'),
('JBP', 'Jabalpur'),
('JSM', 'Jaisalmer'),
('JSG', 'Jharsuguda Junction'),
('J', 'Jalna'),
('KRMR', 'Karimnagar'),
('KCG', 'Kacheguda'),
('KYN', 'Kalyan Junction'),
('KZJ', 'Kazipet Junction'),
('KJM', 'Krishnarajpuram'),
('KOTA', 'Kota Junction'),
('KUR', 'Khurda Road Junction'),
('KRNT', 'Kurnool Town'),
('KMT', 'Khammam'),
('KGP', 'Kharagpur'),
('KGI', 'Kengeri'),
('KTE', 'Katni Junction'),
('KPV', 'Kashipur Junction'),
('KOAA', 'Kolkata'),
('KQL', 'Kandhla'),
('LKO', 'Lucknow Charbagh'),
('LJN', 'Lucknow Junction'),
('LDH', 'Ludhiana Junction'),
('LTT', 'Lokmanya Tilak Terminus'),
('LKU', 'Lalkua Junction'),
('LUR', 'Latur'),
('MAJN', 'Mangalore Junction'),
('MDU', 'Madurai Junction'),
('MYS', 'Mysuru Junction'),
('MTJ', 'Mathura Junction'),
('MB', 'Moradabad Junction'),
('MFP', 'Muzaffarpur Junction'),
('MBNR', 'Mahabubnagar'),
('MCI', 'Mancherial'),
('NGP', 'Nagpur'),
('NK', 'Nashik Road'),
('NZB', 'Nizamabad'),
('NLR', 'Nellore'),
('ND', 'Nadiad Junction'),
('NED', 'Hazur Sahib Nanded'),
('NJP', 'New Jalpaiguri Junction'),
('NDB', 'Nandurbar'),
('NS', 'Narasapur'),
('NDL', 'Nandyal'),
('ON', 'Unnao Junction'),
('OGL', 'Ongole'),
('PUNE', 'Pune Junction'),
('PNBE', 'Patna Junction'),
('PURI', 'Puri'),
('PGT', 'Palakkad Junction'),
('PNVL', 'Panvel'),
('PBR', 'Porbandar'),
('PBE', 'Pilibhit Junction'),
('PTK', 'Pathankot Junction'),
('QLD', 'Quilandi'),
('RNC', 'Ranchi'),
('R', 'Raipur Junction'),
('RMM', 'Rameswaram'),
('RJY', 'Rajahmundry'),
('RU', 'Renigunta Junction'),
('RBL', 'Rae Bareli Junction'),
('RTM', 'Ratlam Junction'),
('RDM', 'Ramagundam'),
('SC', 'Secunderabad Junction'),
('SRE', 'Saharanpur Junction'),
('SLN', 'Sultanpur Junction'),
('SMQL', 'Shamli'),
('SVKS', 'Sivakasi'),
('TPTY', 'Tirupati'),
('TEN', 'Tirunelveli Junction'),
('TPJ', 'Tiruchirappalli Junction'),
('TATA', 'Tatanagar Junction'),
('TUNI', 'Tuni'),
('TDL', 'Tundla Junction'),
('UJN', 'Ujjain Junction'),
('UR', 'Umdanagar'),
('UBL', 'Hubballi Junction'),
('UHP', 'Udhampur'),
('VSKP', 'Visakhapatnam'),
('BZA', 'Vijayawada Junction'),
('VLR', 'Vellore Cantonment'),
('VRL', 'Veraval'),
('WL', 'Warangal'),
('WADI', 'Wadi'),
('WR', 'Wardha Junction'),
('WKR', 'Wankaner Junction'),
('YPR', 'Yesvantpur'),
('YNK', 'Yelahanka'),
('YG', 'Yadgir'),
('ZBD', 'Zafarabad Junction'),
('ZN', 'Jangaon'),
('ZB', 'Zaheerabad');

INSERT OR IGNORE INTO stations (code, name) VALUES
('CBE', 'Coimbatore Junction'),
('ERS', 'Ernakulam Junction'),
('TVC', 'Thiruvananthapuram Central'),
('TCR', 'Thrissur'),
('KTYM', 'Kottayam'),
('CAPE', 'Kanyakumari'),
('QLN', 'Kollam Junction'),
('MAO', 'Madgaon Junction'),
('UDZ', 'Udaipur City'),
('ED', 'Erode Junction'),
('MAQ', 'Mangaluru Central'),
('MMR', 'Manmad Junction'),
('HW', 'Haridwar Junction'),
('BSL', 'Bhusaval Junction'),
('MLDT', 'Malda Town'),
('SA', 'Salem Junction'),
('PDY', 'Puducherry'),
('SML', 'Shimla'),
('UAM', 'Udhagamandalam (Ooty)'),
('KOP', 'Kolhapur');

-- Additional fictional regional demo services.
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90001','Demo Adoni Bengaluru Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90001',0,'AD',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90001',1,'YNK','11:30','11:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90001',2,'YPR','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90001',3,'SBC','12:30','12:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90001',4,'BNC','12:45',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90002','Demo Adoni Bengaluru Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90002',0,'BNC',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90002',1,'SBC','18:10','18:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90002',2,'YPR','18:30','18:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90002',3,'YNK','19:10','19:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90002',4,'AD','00:45',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90003','Demo Bengaluru Chennai Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90003',0,'SBC',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90003',1,'BNC','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90003',2,'KJM','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90003',3,'KPD','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90003',4,'AJJ','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90003',5,'MAS','15:50',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90004','Demo Bengaluru Chennai Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90004',0,'MAS',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90004',1,'AJJ','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90004',2,'KPD','21:35','21:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90004',3,'KJM','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90004',4,'BNC','02:15','02:20',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90004',5,'SBC','03:50',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90005','Demo Bengaluru Mysuru Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90005',0,'BNC',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90005',1,'SBC','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90005',2,'KGI','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90005',3,'MYS','12:10',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90006','Demo Bengaluru Mysuru Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90006',0,'MYS',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90006',1,'KGI','20:30','20:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90006',2,'SBC','22:35','22:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90006',3,'BNC','00:10',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90007','Demo Karnataka Heritage Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90007',0,'BNC',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90007',1,'YNK','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90007',2,'HRR','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90007',3,'DWR','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90007',4,'UBL','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90007',5,'HPT','15:50','15:55',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90007',6,'BGK','18:25','18:30',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90007',7,'BJP','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90007',8,'BGM','22:05','22:10',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90007',9,'MAO','00:40',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90008','Demo Karnataka Heritage Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90008',0,'MAO',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90008',1,'BGM','20:30','20:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90008',2,'BJP','22:35','22:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90008',3,'BGK','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90008',4,'HPT','02:45','02:50',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90008',5,'UBL','04:50','04:55',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90008',6,'DWR','06:25','06:30',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90008',7,'HRR','09:00','09:05',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90008',8,'YNK','11:05','11:10',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90008',9,'BNC','12:40',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90009','Demo Deccan Connection Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90009',0,'BNC',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90009',1,'YNK','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90009',2,'AD','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90009',3,'WADI','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90009',4,'YG','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90009',5,'ZB','15:50','15:55',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90009',6,'HYB','18:25','18:30',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90009',7,'SC','20:00',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90010','Demo Deccan Connection Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90010',0,'SC',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90010',1,'HYB','19:30','19:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90010',2,'ZB','22:05','22:10',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90010',3,'YG','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90010',4,'WADI','01:45','01:50',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90010',5,'AD','04:20','04:25',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90010',6,'YNK','06:25','06:30',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90010',7,'BNC','08:00',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90011','Demo Hyderabad Kurnool Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90011',0,'HYB',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90011',1,'KCG','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90011',2,'UR','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90011',3,'MBNR','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90011',4,'KRNT','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90011',5,'DHNE','15:50','15:55',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90011',6,'NDL','18:25','18:30',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90011',7,'HX','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90011',8,'RU','22:05','22:10',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90011',9,'TPTY','00:40',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90012','Demo Hyderabad Kurnool Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90012',0,'TPTY',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90012',1,'RU','20:30','20:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90012',2,'HX','22:35','22:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90012',3,'NDL','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90012',4,'DHNE','02:45','02:50',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90012',5,'KRNT','04:50','04:55',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90012',6,'MBNR','06:25','06:30',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90012',7,'UR','09:00','09:05',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90012',8,'KCG','11:05','11:10',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90012',9,'HYB','12:40',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90013','Demo Telangana Connection Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90013',0,'HYB',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90013',1,'SC','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90013',2,'CHZ','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90013',3,'ZN','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90013',4,'KZJ','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90013',5,'WL','15:50','15:55',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90013',6,'RDM','18:25','18:30',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90013',7,'MCI','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90013',8,'KRMR','22:05','22:10',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90013',9,'NZB','00:40','00:45',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90013',10,'NED','02:15',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90014','Demo Telangana Connection Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90014',0,'NED',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90014',1,'NZB','19:30','19:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90014',2,'KRMR','22:05','22:10',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90014',3,'MCI','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90014',4,'RDM','01:45','01:50',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90014',5,'WL','04:20','04:25',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90014',6,'KZJ','06:25','06:30',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90014',7,'ZN','08:00','08:05',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90014',8,'CHZ','10:35','10:40',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90014',9,'SC','12:40','12:45',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90014',10,'HYB','14:15',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90015','Demo Andhra Coast Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90015',0,'MAS',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90015',1,'GDR','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90015',2,'NLR','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90015',3,'OGL','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90015',4,'GNT','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90015',5,'BZA','15:50','15:55',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90015',6,'EE','18:25','18:30',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90015',7,'RJY','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90015',8,'NS','22:05','22:10',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90015',9,'CCT','00:40','00:45',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90015',10,'ANV','02:15','02:20',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90015',11,'TUNI','04:20','04:25',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90015',12,'VSKP','06:55',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90016','Demo Andhra Coast Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90016',0,'VSKP',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90016',1,'TUNI','20:30','20:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90016',2,'ANV','22:35','22:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90016',3,'CCT','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90016',4,'NS','02:45','02:50',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90016',5,'RJY','04:50','04:55',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90016',6,'EE','06:25','06:30',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90016',7,'BZA','09:00','09:05',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90016',8,'GNT','11:05','11:10',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90016',9,'OGL','12:40','12:45',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90016',10,'NLR','15:15','15:20',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90016',11,'GDR','17:20','17:25',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90016',12,'MAS','18:55',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90017','Demo Warangal Vijayawada Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90017',0,'SC',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90017',1,'ZN','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90017',2,'KZJ','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90017',3,'WL','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90017',4,'KMT','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90017',5,'BZA','15:50',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90018','Demo Warangal Vijayawada Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90018',0,'BZA',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90018',1,'KMT','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90018',2,'WL','21:35','21:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90018',3,'KZJ','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90018',4,'ZN','02:15','02:20',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90018',5,'SC','03:50',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90019','Demo Tamil Nadu Heritage Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90019',0,'MAS',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90019',1,'CGL','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90019',2,'PDY','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90019',3,'TPJ','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90019',4,'DG','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90019',5,'MDU','15:50','15:55',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90019',6,'SVKS','18:25','18:30',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90019',7,'TEN','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90019',8,'CAPE','22:05',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90020','Demo Tamil Nadu Heritage Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90020',0,'CAPE',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90020',1,'TEN','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90020',2,'SVKS','21:35','21:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90020',3,'MDU','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90020',4,'DG','02:15','02:20',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90020',5,'TPJ','03:50','03:55',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90020',6,'PDY','06:25','06:30',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90020',7,'CGL','08:30','08:35',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90020',8,'MAS','10:05',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90021','Demo Tamil Nadu Hills Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90021',0,'MAS',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90021',1,'AJJ','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90021',2,'KPD','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90021',3,'VLR','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90021',4,'SA','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90021',5,'ED','15:50','15:55',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90021',6,'CBE','18:25','18:30',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90021',7,'UAM','20:00',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90022','Demo Tamil Nadu Hills Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90022',0,'UAM',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90022',1,'CBE','19:30','19:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90022',2,'ED','22:05','22:10',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90022',3,'SA','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90022',4,'VLR','01:45','01:50',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90022',5,'KPD','04:20','04:25',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90022',6,'AJJ','06:25','06:30',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90022',7,'MAS','08:00',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90023','Demo Rameswaram Connection Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90023',0,'TPJ',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90023',1,'DG','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90023',2,'MDU','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90023',3,'RMM','12:10',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90024','Demo Rameswaram Connection Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90024',0,'RMM',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90024',1,'MDU','20:30','20:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90024',2,'DG','22:35','22:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90024',3,'TPJ','00:10',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90025','Demo Southern Coast Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90025',0,'CBE',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90025',1,'PGT','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90025',2,'TCR','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90025',3,'ERS','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90025',4,'KTYM','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90025',5,'QLN','15:50','15:55',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90025',6,'TVC','18:25','18:30',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90025',7,'CAPE','20:00',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90026','Demo Southern Coast Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90026',0,'CAPE',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90026',1,'TVC','19:30','19:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90026',2,'QLN','22:05','22:10',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90026',3,'KTYM','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90026',4,'ERS','01:45','01:50',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90026',5,'TCR','04:20','04:25',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90026',6,'PGT','06:25','06:30',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90026',7,'CBE','08:00',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90027','Demo Malabar Coast Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90027',0,'MAO',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90027',1,'MAJN','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90027',2,'MAQ','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90027',3,'CAN','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90027',4,'QLD','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90027',5,'CLT','15:50','15:55',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90027',6,'TCR','18:25','18:30',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90027',7,'ERS','20:00',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90028','Demo Malabar Coast Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90028',0,'ERS',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90028',1,'TCR','19:30','19:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90028',2,'CLT','22:05','22:10',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90028',3,'QLD','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90028',4,'CAN','01:45','01:50',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90028',5,'MAQ','04:20','04:25',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90028',6,'MAJN','06:25','06:30',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90028',7,'MAO','08:00',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90029','Demo Maharashtra Connection Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90029',0,'CSMT',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90029',1,'KYN','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90029',2,'NK','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90029',3,'MMR','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90029',4,'BSL','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90029',5,'AK','15:50','15:55',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90029',6,'NGP','18:25','18:30',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90029',7,'WR','20:00',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90030','Demo Maharashtra Connection Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90030',0,'WR',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90030',1,'NGP','19:30','19:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90030',2,'AK','22:05','22:10',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90030',3,'BSL','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90030',4,'MMR','01:45','01:50',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90030',5,'NK','04:20','04:25',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90030',6,'KYN','06:25','06:30',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90030',7,'CSMT','08:00',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90031','Demo Marathwada Connection Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90031',0,'LTT',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90031',1,'KYN','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90031',2,'NK','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90031',3,'MMR','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90031',4,'AWB','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90031',5,'J','15:50','15:55',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90031',6,'NED','18:25','18:30',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90031',7,'LUR','20:00',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90032','Demo Marathwada Connection Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90032',0,'LUR',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90032',1,'NED','19:30','19:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90032',2,'J','22:05','22:10',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90032',3,'AWB','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90032',4,'MMR','01:45','01:50',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90032',5,'NK','04:20','04:25',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90032',6,'KYN','06:25','06:30',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90032',7,'LTT','08:00',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90033','Demo Konkan Deccan Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90033',0,'BDTS',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90033',1,'PNVL','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90033',2,'PUNE','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90033',3,'KOP','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90033',4,'BGM','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90033',5,'MAO','15:50',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90034','Demo Konkan Deccan Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90034',0,'MAO',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90034',1,'BGM','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90034',2,'KOP','21:35','21:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90034',3,'PUNE','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90034',4,'PNVL','02:15','02:20',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90034',5,'BDTS','03:50',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90035','Demo Western Cities Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90035',0,'BCT',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90035',1,'BVI','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90035',2,'VAPI','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90035',3,'ST','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90035',4,'BRC','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90035',5,'ANND','15:50','15:55',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90035',6,'ND','18:25','18:30',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90035',7,'ADI','20:00',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90036','Demo Western Cities Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90036',0,'ADI',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90036',1,'ND','19:30','19:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90036',2,'ANND','22:05','22:10',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90036',3,'BRC','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90036',4,'ST','01:45','01:50',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90036',5,'VAPI','04:20','04:25',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90036',6,'BVI','06:25','06:30',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90036',7,'BCT','08:00',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90037','Demo Gujarat Coast Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90037',0,'ADI',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90037',1,'GIMB','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90037',2,'WKR','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90037',3,'PBR','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90037',4,'VRL','13:45',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90038','Demo Gujarat Coast Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90038',0,'VRL',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90038',1,'PBR','19:30','19:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90038',2,'WKR','22:05','22:10',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90038',3,'GIMB','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90038',4,'ADI','01:45',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90039','Demo Western Junctions Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90039',0,'ST',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90039',1,'NDB','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90039',2,'BSL','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90039',3,'AK','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90039',4,'NGP','13:45',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90040','Demo Western Junctions Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90040',0,'NGP',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90040',1,'AK','19:30','19:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90040',2,'BSL','22:05','22:10',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90040',3,'NDB','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90040',4,'ST','01:45',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90041','Demo Gujarat Malwa Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90041',0,'ADI',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90041',1,'ANND','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90041',2,'BRC','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90041',3,'DHD','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90041',4,'RTM','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90041',5,'UJN','15:50','15:55',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90041',6,'INDB','18:25',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90042','Demo Gujarat Malwa Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90042',0,'INDB',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90042',1,'UJN','20:30','20:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90042',2,'RTM','22:35','22:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90042',3,'DHD','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90042',4,'BRC','02:45','02:50',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90042',5,'ANND','04:50','04:55',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90042',6,'ADI','06:25',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90043','Demo Rajasthan Heritage Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90043',0,'UDZ',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90043',1,'AII','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90043',2,'JU','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90043',3,'JSM','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90043',4,'BKN','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90043',5,'HSR','15:50','15:55',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90043',6,'BTI','18:25',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90044','Demo Rajasthan Heritage Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90044',0,'BTI',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90044',1,'HSR','20:30','20:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90044',2,'BKN','22:35','22:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90044',3,'JSM','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90044',4,'JU','02:45','02:50',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90044',5,'AII','04:50','04:55',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90044',6,'UDZ','06:25',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90045','Demo Desert Connection Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90045',0,'JP',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90045',1,'AII','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90045',2,'JU','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90045',3,'BKN','12:10',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90046','Demo Desert Connection Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90046',0,'BKN',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90046',1,'JU','20:30','20:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90046',2,'AII','22:35','22:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90046',3,'JP','00:10',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90047','Demo Jaipur Agra Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90047',0,'JP',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90047',1,'GADJ','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90047',2,'BKI','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90047',3,'BTE','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90047',4,'MTJ','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90047',5,'AGC','15:50',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90048','Demo Jaipur Agra Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90048',0,'AGC',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90048',1,'MTJ','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90048',2,'BTE','21:35','21:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90048',3,'BKI','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90048',4,'GADJ','02:15','02:20',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90048',5,'JP','03:50',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90049','Demo Alwar Delhi Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90049',0,'AWR',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90049',1,'RE','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90049',2,'GGN','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90049',3,'DEC','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90049',4,'DLI','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90049',5,'NDLS','15:50',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90050','Demo Alwar Delhi Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90050',0,'NDLS',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90050',1,'DLI','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90050',2,'DEC','21:35','21:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90050',3,'GGN','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90050',4,'RE','02:15','02:20',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90050',5,'AWR','03:50',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90051','Demo North India Connection Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90051',0,'NDLS',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90051',1,'DLI','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90051',2,'GZB','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90051',3,'SRE','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90051',4,'CDG','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90051',5,'LDH','15:50','15:55',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90051',6,'JUC','18:25','18:30',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90051',7,'ASR','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90051',8,'PTK','22:05','22:10',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90051',9,'JAT','00:40','00:45',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90051',10,'UHP','02:15',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90052','Demo North India Connection Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90052',0,'UHP',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90052',1,'JAT','19:30','19:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90052',2,'PTK','22:05','22:10',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90052',3,'ASR','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90052',4,'JUC','01:45','01:50',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90052',5,'LDH','04:20','04:25',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90052',6,'CDG','06:25','06:30',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90052',7,'SRE','08:00','08:05',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90052',8,'GZB','10:35','10:40',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90052',9,'DLI','12:40','12:45',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90052',10,'NDLS','14:15',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90053','Demo Punjab Connection Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90053',0,'ASR',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90053',1,'JUC','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90053',2,'LDH','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90053',3,'BTI','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90053',4,'FZR','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90053',5,'FKA','15:50',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90054','Demo Punjab Connection Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90054',0,'FKA',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90054',1,'FZR','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90054',2,'BTI','21:35','21:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90054',3,'LDH','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90054',4,'JUC','02:15','02:20',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90054',5,'ASR','03:50',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90055','Demo Himalayan Foothills Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90055',0,'NDLS',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90055',1,'GZB','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90055',2,'SRE','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90055',3,'HW','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90055',4,'DDN','13:45',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90056','Demo Himalayan Foothills Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90056',0,'DDN',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90056',1,'HW','19:30','19:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90056',2,'SRE','22:05','22:10',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90056',3,'GZB','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90056',4,'NDLS','01:45',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90057','Demo Shimla Hills Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90057',0,'NDLS',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90057',1,'CDG','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90057',2,'SML','09:35',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90058','Demo Shimla Hills Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90058',0,'SML',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90058',1,'CDG','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90058',2,'NDLS','21:35',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90059','Demo Kumaon Connection Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90059',0,'DLI',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90059',1,'GZB','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90059',2,'MB','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90059',3,'KPV','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90059',4,'LKU','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90059',5,'HDW','15:50','15:55',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90059',6,'IZN','18:25','18:30',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90059',7,'BE','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90059',8,'PBE','22:05',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90060','Demo Kumaon Connection Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90060',0,'PBE',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90060',1,'BE','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90060',2,'IZN','21:35','21:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90060',3,'HDW','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90060',4,'LKU','02:15','02:20',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90060',5,'KPV','03:50','03:55',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90060',6,'MB','06:25','06:30',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90060',7,'GZB','08:30','08:35',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90060',8,'DLI','10:05',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90061','Demo Shamli Connection Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90061',0,'DLI',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90061',1,'KQL','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90061',2,'SMQL','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90061',3,'SRE','12:10',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90062','Demo Shamli Connection Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90062',0,'SRE',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90062',1,'SMQL','20:30','20:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90062',2,'KQL','22:35','22:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90062',3,'DLI','00:10',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90063','Demo Central India Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90063',0,'AGC',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90063',1,'GWL','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90063',2,'VGLJ','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90063',3,'BPL','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90063',4,'ET','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90063',5,'NGP','15:50',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90064','Demo Central India Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90064',0,'NGP',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90064',1,'ET','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90064',2,'BPL','21:35','21:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90064',3,'VGLJ','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90064',4,'GWL','02:15','02:20',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90064',5,'AGC','03:50',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90065','Demo Malwa Bundelkhand Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90065',0,'KOTA',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90065',1,'GUNA','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90065',2,'BPL','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90065',3,'ET','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90065',4,'JBP','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90065',5,'KTE','15:50',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90066','Demo Malwa Bundelkhand Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90066',0,'KTE',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90066',1,'JBP','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90066',2,'ET','21:35','21:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90066',3,'BPL','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90066',4,'GUNA','02:15','02:20',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90066',5,'KOTA','03:50',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90067','Demo Gangetic Cities Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90067',0,'AGC',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90067',1,'TDL','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90067',2,'ETW','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90067',3,'CNB','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90067',4,'ON','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90067',5,'LJN','15:50','15:55',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90067',6,'LKO','18:25','18:30',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90067',7,'RBL','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90067',8,'BSB','22:05',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90068','Demo Gangetic Cities Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90068',0,'BSB',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90068',1,'RBL','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90068',2,'LKO','21:35','21:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90068',3,'LJN','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90068',4,'ON','02:15','02:20',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90068',5,'CNB','03:50','03:55',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90068',6,'ETW','06:25','06:30',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90068',7,'TDL','08:30','08:35',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90068',8,'AGC','10:05',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90069','Demo Awadh Connection Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90069',0,'CNB',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90069',1,'FBD','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90069',2,'LKO','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90069',3,'SLN','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90069',4,'FD','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90069',5,'AY','15:50','15:55',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90069',6,'GD','18:25','18:30',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90069',7,'GKP','20:00',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90070','Demo Awadh Connection Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90070',0,'GKP',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90070',1,'GD','19:30','19:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90070',2,'AY','22:05','22:10',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90070',3,'FD','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90070',4,'SLN','01:45','01:50',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90070',5,'LKO','04:20','04:25',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90070',6,'FBD','06:25','06:30',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90070',7,'CNB','08:00',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90071','Demo Eastern Ganga Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90071',0,'CNB',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90071',1,'FTP','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90071',2,'BSB','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90071',3,'ZBD','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90071',4,'GAYA','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90071',5,'PNBE','15:50','15:55',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90071',6,'DNR','18:25','18:30',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90071',7,'ARA','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90071',8,'IPR','22:05',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90072','Demo Eastern Ganga Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90072',0,'IPR',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90072',1,'ARA','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90072',2,'DNR','21:35','21:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90072',3,'PNBE','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90072',4,'GAYA','02:15','02:20',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90072',5,'ZBD','03:50','03:55',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90072',6,'BSB','06:25','06:30',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90072',7,'FTP','08:30','08:35',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90072',8,'CNB','10:05',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90073','Demo Bihar Connection Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90073',0,'GKP',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90073',1,'CPR','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90073',2,'HJP','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90073',3,'MFP','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90073',4,'DBG','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90073',5,'BJU','15:50','15:55',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90073',6,'BGP','18:25','18:30',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90073',7,'PNBE','20:00',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90074','Demo Bihar Connection Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90074',0,'PNBE',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90074',1,'BGP','19:30','19:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90074',2,'BJU','22:05','22:10',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90074',3,'DBG','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90074',4,'MFP','01:45','01:50',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90074',5,'HJP','04:20','04:25',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90074',6,'CPR','06:25','06:30',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90074',7,'GKP','08:00',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90075','Demo Bengal Connection Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90075',0,'PNBE',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90075',1,'GAYA','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90075',2,'DHN','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90075',3,'ASN','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90075',4,'BWN','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90075',5,'HWH','15:50','15:55',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90075',6,'KOAA','18:25',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90076','Demo Bengal Connection Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90076',0,'KOAA',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90076',1,'HWH','20:30','20:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90076',2,'BWN','22:35','22:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90076',3,'ASN','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90076',4,'DHN','02:45','02:50',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90076',5,'GAYA','04:50','04:55',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90076',6,'PNBE','06:25',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90077','Demo Eastern Hills Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90077',0,'KOAA',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90077',1,'BWN','07:50','07:55',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90077',2,'MLDT','11:55','12:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90077',3,'NJP','15:00','15:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90077',4,'DJ','18:05','18:10',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90077',5,'GHY','01:10','01:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90077',6,'AGTL','13:15',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90078','Demo Eastern Hills Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90078',0,'AGTL',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90078',1,'GHY','06:00','06:05',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90078',2,'DJ','13:05','13:10',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90078',3,'NJP','16:10','16:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90078',4,'MLDT','19:15','19:20',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90078',5,'BWN','23:20','23:25',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90078',6,'KOAA','01:15',NULL,2,2);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90079','Demo Jharkhand Connection Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90079',0,'HWH',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90079',1,'KGP','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90079',2,'TATA','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90079',3,'RNC','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90079',4,'HTE','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90079',5,'DHN','15:50',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90080','Demo Jharkhand Connection Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90080',0,'DHN',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90080',1,'HTE','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90080',2,'RNC','21:35','21:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90080',3,'TATA','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90080',4,'KGP','02:15','02:20',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90080',5,'HWH','03:50',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90081','Demo East Coast Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90081',0,'HWH',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90081',1,'KGP','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90081',2,'CTC','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90081',3,'BBS','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90081',4,'KUR','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90081',5,'PURI','15:50',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90082','Demo East Coast Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90082',0,'PURI',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90082',1,'KUR','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90082',2,'BBS','21:35','21:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90082',3,'CTC','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90082',4,'KGP','02:15','02:20',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90082',5,'HWH','03:50',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90083','Demo Odisha Andhra Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90083',0,'BBS',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90083',1,'KUR','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90083',2,'VSKP','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90083',3,'ANV','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90083',4,'RJY','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90083',5,'BZA','15:50',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90084','Demo Odisha Andhra Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90084',0,'BZA',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90084',1,'RJY','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90084',2,'ANV','21:35','21:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90084',3,'VSKP','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90084',4,'KUR','02:15','02:20',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90084',5,'BBS','03:50',NULL,1,1);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90085','Demo Central Eastern Express','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90085',0,'NGP',NULL,'06:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90085',1,'R','07:30','07:35',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90085',2,'BSP','09:35','09:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90085',3,'ABKP','12:10','12:15',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90085',4,'JSG','13:45','13:50',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90085',5,'RNC','15:50',NULL,0,0);
INSERT OR IGNORE INTO trains (number,name,type) VALUES ('90086','Demo Central Eastern Return','Demo Express');
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90086',0,'RNC',NULL,'18:00',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90086',1,'JSG','20:00','20:05',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90086',2,'ABKP','21:35','21:40',0,0);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90086',3,'BSP','00:10','00:15',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90086',4,'R','02:15','02:20',1,1);
INSERT OR IGNORE INTO train_stops (train_number,stop_order,station_code,arrival,departure,arrival_day,departure_day) VALUES ('90086',5,'NGP','03:50',NULL,1,1);
