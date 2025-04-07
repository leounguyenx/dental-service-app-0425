CREATE database dental_service_db;
USE dental_service_db;


DROP table Surgery;
DROP table Appointment;
DROP table Dentist;
DROP table Request;
DROP table Patient;
DROP table Address;

-- Table: Address
CREATE TABLE Address (
	addressID INT PRIMARY KEY,
    street VARCHAR(255),
    city VARCHAR(255),
    zip VARCHAR(10)
);
INSERT INTO Address (addressID,street, city, zip) VALUES
(1,'123 Main St', 'New York', '10001'),
(2,'456 Oak Ave', 'Los Angeles', '90001'),
(3,'789 Pine Rd', 'Chicago', '60601'),
(4,'321 Maple Ln', 'Houston', '77001'),
(5,'654 Cedar Blvd', 'Phoenix', '85001'),
(6,'987 Birch St', 'Philadelphia', '19019'),
(7,'1000 Tegre St', 'Iowa', '52557');

DELETE FROM Surgery;

-- Table: Surgery
CREATE TABLE Surgery (
    surgeryID INT PRIMARY KEY,
    name VARCHAR(255),
    phone VARCHAR(20),
    addressID INT,
    FOREIGN KEY (addressID) REFERENCES Address(addressID)
);
INSERT INTO Surgery (surgeryID, name, phone, addressID) VALUES
(10, 'Surgery 10', '8888888880', 1),
(13, 'Surgery 13', '8888888883', 2),
(15, 'Surgery 15', '8888888885', 3);

-- Table: Dentist
CREATE TABLE Dentist (
    dentistID INT PRIMARY KEY,
    firstName VARCHAR(255),
    lastName VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(100),
    specialization VARCHAR(255)
);
INSERT INTO Dentist (dentistID, firstName, lastName, phone, email, specialization)
VALUES
(1, 'Tony', 'Smith', '1111111111', 'tony.smith@example.com', 'General'),
(2, 'Helen', 'Pearson', '2222222222', 'helen.pearson@example.com', 'Orthodontist'),
(3, 'Robin', 'Plevin', '3333333333', 'robin.plevin@example.com', 'Pediatric');

-- Table: Patient
CREATE TABLE Patient (
    patientID INT PRIMARY KEY,
    firstName VARCHAR(255),
    lastName VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(100),
    dob DATE,
    addressID INT,
    FOREIGN KEY (addressID) REFERENCES Address(addressID)
);
INSERT INTO Patient (patientID, firstName, lastName, phone, email, dob, addressID) VALUES
(100, 'John', 'Doe', '555-1234', 'john.doe@example.com', '1980-05-15', 4),
(105, 'Jane', 'Smith', '555-5678', 'jane.smith@example.com', '1975-08-25', 5),
(108, 'Emily', 'Jones', '555-8765', 'emily.jones@example.com', '1990-02-10', 6),
(110, 'Michael', 'Brown', '555-4321', 'michael.brown@example.com', '1985-12-05', 7);

-- Table: Request
CREATE TABLE Request (
    requestID INT PRIMARY KEY,
    requestDate DATETIME,
    patientID INT,
    FOREIGN KEY (patientID) REFERENCES Patient(patientID)
);
INSERT INTO Request (requestID, requestDate, patientID) VALUES
(1, '2013-09-10 09:00:00', 100),
(2, '2013-09-11 10:15:00', 105),
(3, '2013-09-11 14:45:00', 108),
(4, '2013-09-12 08:30:00', 100),
(5, '2013-09-13 11:00:00', 110),
(6, '2013-09-14 16:00:00', 105);

-- Table: Appointment
CREATE TABLE Appointment (
    appointmentID INT PRIMARY KEY,
    appointmentDate DATETIME,
    surgeryID INT,
    dentistID INT,
    patientID INT,
    status VARCHAR(50),
    FOREIGN KEY (surgeryID) REFERENCES Surgery(surgeryID),
    FOREIGN KEY (dentistID) REFERENCES Dentist(dentistID),
    FOREIGN KEY (patientID) REFERENCES Patient(patientID)
);
INSERT INTO Appointment (appointmentID, appointmentDate, surgeryID, dentistID, patientID, status) VALUES
(1, '2013-09-10 09:30:00', 10, 1, 100, 'Scheduled'),
(2, '2013-09-11 10:30:00', 13, 2, 105, 'Completed'),
(3, '2013-09-11 15:00:00', 15, 3, 108, 'Cancelled'),
(4, '2013-09-12 09:00:00', 10, 1, 100, 'No-Show'),
(5, '2013-09-13 11:30:00', 13, 2, 110, 'Scheduled'),
(6, '2013-09-14 16:30:00', 15, 3, 105, 'Completed');


-- List of ALL Dentists sorted by last name
SELECT *
FROM Dentist
ORDER BY lastName;

-- List of ALL Appointments for a given Dentist (by dentistID), including Patient information
SELECT a.appointmentID, a.appointmentDate, p.firstName AS patientFirstName, p.lastName AS patientLastName, 
		p.phone AS patientPhone, p.email AS patientEmail, a.status
FROM Appointment a
JOIN Patient p ON a.patientID = p.patientID
WHERE a.dentistID = 1
ORDER BY a.appointmentDate;

-- List of ALL Appointments scheduled at a Surgery location
SELECT a.appointmentID, a.appointmentDate, p.firstName AS patientFirstName, p.lastName AS patientLastName, 
	p.phone AS patientPhone, p.email AS patientEmail, a.status
FROM Appointment a
JOIN Patient p ON a.patientID = p.patientID
WHERE a.surgeryID = 10
ORDER BY a.appointmentDate;

-- List of Appointments booked for a given Patient on a given Date
SELECT a.appointmentID, a.appointmentDate, s.name AS surgeryName, d.firstName AS dentistFirstName, 
d.lastName AS dentistLastName, a.status
FROM Appointment a
JOIN Surgery s ON a.surgeryID = s.surgeryID
JOIN Dentist d ON a.dentistID = d.dentistID
WHERE a.patientID = 100 AND DATE(a.appointmentDate) = '2013-09-10'
ORDER BY a.appointmentDate;