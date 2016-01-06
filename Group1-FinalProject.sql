-- SQL Group 1 --
-- Q2: Script to create tables with constraints and insert data -- 

-- CREATING TABLES - primary keys have been created during table creation if they are not composite
-- Foreign keys and composite keys added afterward
 
CREATE table Student (
StudentNum	Number (9) CONSTRAINT student_StudentNum_pk PRIMARY KEY, 
LastName      VARCHAR2 (15),
FirstName     VARCHAR2 (15),
LocalStreet   VARCHAR2 (40),
LocalCity     VARCHAR2 (20),
LocalState    VARCHAR2 (20),
LocalZip      VARCHAR2 (6),
PermStreet   VARCHAR2 (40),
PermCity     VARCHAR2 (20),
PermState    VARCHAR2 (20),
PermZip      VARCHAR2 (6),
CreditsTaken  NUMBER (3),
CreditsEarned NUMBER (3),
GPA           NUMBER (3,2),
TotalPoints   NUMBER (5,2),
ClassStanding VARCHAR2 (15));  
 
CREATE table Faculty (
FacultyNum    Number (4) CONSTRAINT faculty_facultyNum_pk PRIMARY KEY,
LastName      VARCHAR2 (15),
FirstName     VARCHAR2 (15),
Street        VARCHAR2 (20),
City          VARCHAR2 (20),
State         VARCHAR2 (10),
Zip           VARCHAR2 (6),
CurrentRank   VARCHAR2 (20),
StartDate 	DATE,
OfficeNum     NUMBER (4),
DepartmentCode  VARCHAR2 (3));
 
CREATE table Office (
OfficeNum   NUMBER (4) CONSTRAINT office_officeNum_pk PRIMARY KEY,
Phone   	CHAR (10));
 
CREATE table Department (
DepartmentCode VARCHAR2 (3) CONSTRAINT Department_DepartmentCode_pk PRIMARY KEY,
DepartmentName VARCHAR2 (15),
Location       VARCHAR2 (20));
 
CREATE table Major (
MajorNum NUMBER (3) CONSTRAINT Major_MajorNum_pk PRIMARY KEY,
Description VARCHAR2 (40),
DepartmentCode VARCHAR2 (3));
 
CREATE table Advises (
MajorNum	NUMBER (3),
StudentNum  NUMBER (9),
FacultyNum  NUMBER (4));
 
CREATE table Semester (
SemesterCode    VARCHAR2 (4) CONSTRAINT Semester_SemesterCode_pk PRIMARY KEY,
StartDate       DATE,
EndDate         DATE,
ExamStartDate   DATE,
ExamEndDate     DATE,
WithdrawalDate  DATE );
 
CREATE table Section (
ScheduleCode    NUMBER (4),
SemesterCode    VARCHAR2 (4),
SectionLetter   CHAR (1),
Time            VARCHAR2 (40),
Room            VARCHAR2 (8),
CurrentEnrollment   NUMBER (2),
MaximumEnrollment   NUMBER (2),
FacultyNum          NUMBER (4),
CourseNum           VARCHAR2 (6),
DepartmentCode      VARCHAR2 (3)
);
 
CREATE table StudentClass (
StudentNum      NUMBER (9), 
ScheduleCode    NUMBER (4),
SemesterCode    VARCHAR2 (4),
Grade           VARCHAR (2)
);
 
CREATE table StudentGrade (
CourseNum       VARCHAR2 (6),
DepartmentCode  VARCHAR2 (3),
StudentNum      NUMBER (9), 
SemesterCode    VARCHAR2 (4),
Grade           VARCHAR (2),
CreditsEarned   NUMBER (3),
GradePoints     NUMBER (4,2));
 
CREATE table Course (
CourseNum       VARCHAR2 (6),
DepartmentCode  VARCHAR2 (3),
CourseTitle VARCHAR2(25),
NumCredits NUMBER(1)
);


CREATE TABLE PreReq (
CourseNum VARCHAR2 (6),
DepartmentCode VARCHAR2 (3), 
Prereq_CourseNum VARCHAR2(6),
Prereq_DepartmentCode VARCHAR2(3)
);

CREATE TABLE RegistrationRequest (
StudentNum NUMBER (9),
ScheduleCode NUMBER (4),
SemesterCode VARCHAR2(4),
Alternate_ScheduleCode NUMBER (4),
Alternate_SemesterCode VARCHAR2(4)
);
 
-- ADDING ALL THE COMPOSITE PRIMARY AND FOREIGN KEYS
 
ALTER TABLE Major
ADD CONSTRAINT Major_DepartmentCode_FK FOREIGN KEY (DepartmentCode)
REFERENCES Department (DepartmentCode);
 
ALTER TABLE Advises
ADD CONSTRAINT Advises_FacultyNum_FK FOREIGN KEY (FacultyNum)
REFERENCES Faculty (FacultyNum);
 
ALTER TABLE Advises
ADD CONSTRAINT Advises_StudentNum_FK FOREIGN KEY (StudentNum)
REFERENCES Student (StudentNum);
 
ALTER TABLE Advises
ADD CONSTRAINT Advises_MajorNum_FK FOREIGN KEY (MajorNum)
REFERENCES Major (MajorNum);
 
ALTER TABLE Advises
ADD CONSTRAINT Advises_MajorNumStudentNum_PK PRIMARY KEY (MajorNum, StudentNum);
 
ALTER TABLE Faculty
ADD CONSTRAINT Faculty_OfficeNum_FK FOREIGN KEY (OfficeNum)
REFERENCES Office (OfficeNum);
 
ALTER TABLE Faculty
ADD CONSTRAINT Faculty_DepartmentCode_FK FOREIGN KEY (DepartmentCode)
REFERENCES Department(DepartmentCode);

ALTER TABLE Course
ADD CONSTRAINT Course_DepartmentCode_FK FOREIGN KEY (DepartmentCode)
REFERENCES Department(DepartmentCode);

ALTER TABLE Course
ADD CONSTRAINT Course_DptCourseNum_PK PRIMARY KEY (CourseNum, DepartmentCode);
 
ALTER TABLE Section
ADD CONSTRAINT Section_SemesterCode_FK FOREIGN KEY (SemesterCode)
REFERENCES Semester(SemesterCode);
 
ALTER TABLE Section
ADD CONSTRAINT Section_FacultyNum_FK FOREIGN KEY (FacultyNum)
REFERENCES Faculty(FacultyNum);
 
ALTER TABLE Section
ADD CONSTRAINT Section_DptCourse_FK FOREIGN KEY (DepartmentCode,CourseNum)
REFERENCES Course(DepartmentCode, CourseNum);
 
ALTER TABLE Section
ADD CONSTRAINT Section_ScheduleSemester_PK PRIMARY KEY (ScheduleCode, SemesterCode);
 
ALTER TABLE StudentClass
ADD CONSTRAINT StudentClass_StudentNum_FK FOREIGN KEY (StudentNum)
REFERENCES Student(StudentNum);
 
ALTER TABLE StudentClass
ADD CONSTRAINT StudentClass_SchedSem_FK FOREIGN KEY (ScheduleCode, SemesterCode)
REFERENCES Section(ScheduleCode, SemesterCode);
 
ALTER TABLE StudentClass
ADD CONSTRAINT StudentClass_StuNumSemSched_PK PRIMARY KEY (StudentNum,SemesterCode,ScheduleCode);

ALTER TABLE StudentGrade
ADD CONSTRAINT StudentGrade_CrsDpt_FK FOREIGN KEY (CourseNum, DepartmentCode)
REFERENCES Course(CourseNum,DepartmentCode);

ALTER TABLE StudentGrade
ADD CONSTRAINT StudentGrade_StudentNum_FK FOREIGN KEY (StudentNum)
REFERENCES Student(StudentNum);
 
ALTER TABLE StudentGrade
ADD CONSTRAINT StudentGrade_SemesterCode_FK FOREIGN KEY (SemesterCode)
REFERENCES Semester(SemesterCode);
 
ALTER TABLE StudentGrade
ADD CONSTRAINT StudentGrade_CrsDptStuSem_PK PRIMARY KEY (CourseNum, DepartmentCode, StudentNum, SemesterCode);
 
ALTER TABLE Prereq
ADD CONSTRAINT Prereq_CrsNumDptCode_FK FOREIGN KEY (CourseNum, DepartmentCode)
REFERENCES Course(CourseNum, DepartmentCode);

ALTER TABLE Prereq
ADD CONSTRAINT Prereq_PreCrsDptCode_FK FOREIGN KEY (Prereq_CourseNum, Prereq_DepartmentCode)
REFERENCES Course(CourseNum, DepartmentCode);

ALTER TABLE Prereq
ADD CONSTRAINT Prereq_CrsDptPre_PK PRIMARY KEY (CourseNum,DepartmentCode, Prereq_CourseNum, Prereq_DepartmentCode);

ALTER TABLE RegistrationRequest ADD CONSTRAINT RegReq_SchedSem_FK FOREIGN KEY (ScheduleCode, SemesterCode)
REFERENCES Section(ScheduleCode, SemesterCode);

ALTER TABLE RegistrationRequest ADD CONSTRAINT RegReq_AltScheSem_FK FOREIGN KEY (Alternate_ScheduleCode, Alternate_SemesterCode)
REFERENCES Section(ScheduleCode, SemesterCode);

ALTER TABLE RegistrationRequest ADD CONSTRAINT RegReq_StudentNum_FK FOREIGN KEY (StudentNum)
REFERENCES Student(StudentNum);

ALTER TABLE RegistrationRequest
ADD CONSTRAINT Prereq_StuScheSem_PK PRIMARY KEY (StudentNum, ScheduleCode, SemesterCode); 

--
-- INSERTING VALUES

INSERT INTO Student VALUES (810610110, 'Siegel', 'Cole', '19 Warland Ave', 'Toronto', 'Ontario', 'M4J3G1', '34 Queens St', 'New York', 'Buffalo', '90210', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610111, 'Hossain', 'Mazhar', '71 Jeremiah Lane', 'Scarborough', 'Ontario', 'M1J0A3', '71 Jeremiah Lane', 'Scarborough', 'Ontario', 'M1J0A3', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610112, 'Brown', 'Robert', '560 Bay Street', 'Toronto', 'Ontario', 'M2M4K2', '3506 W 22 Ave', 'London', 'Ontario', 'L6S1K3', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610113, 'Kamal', 'Nisa', '5 Bay Street', 'Toronto', 'Ontario', 'M2M4L2', '3512 W 32 Ave', 'North York', 'Ontario', 'N6S1L3', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610114, 'Raman', 'Bob', '705 Yonge Street', 'Toronto', 'Ontario', 'M6M4J2', '320 Dale Ave', 'Kingston', 'Ontario', 'K6L1M3', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610115, 'Singh', 'Aman', '560 Kipling Ave', 'Toronto', 'Ontario', 'M8M2L7', '420 Yonge Street', 'Toronto', 'Ontario', 'M6M5K7', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610116, 'Becket', 'Katherine', '1180 Eglinton Ave E', 'Toronto', 'Ontario', 'M7K8L2', '1180 Eglinton Ave E', 'Toronto', 'Ontario', 'M7K8L2', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610117, 'Connors', 'Brian', '120 Gerrard Street', 'Toronto', 'Ontario', 'M1K9H2', '1890 Eglinton Ave E', 'Toronto', 'Ontario', 'M2K3L2', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610118, 'Hossain', 'Tabassum', '3380 Eglinton Ave E', 'Scarborough', 'Ontario', 'M1J3L6', '3380 Eglinton Ave E', 'Toronto', 'Ontario', 'M1J3L6', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610119, 'Khan', 'Adeeba', '120 Yonge Street', 'Toronto', 'Ontario', 'M2K9J2', '428 Bathurst Ave', 'Toronto', 'Ontario', 'M2J4L2', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610120, 'Rahman', 'Shahriah', '3350 Keele Street', 'North York', 'Ontario', 'K2L3J5', '390 Eglinton Ave E', 'Scarborough', 'Ontario', 'M1J3M2', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610121, 'Singh', 'Karanjit', '67 Lambdon Street', 'Etobicoke', 'Ontario', 'M2P5N8', '3385 Wesbrook Mall', 'Vancouver', 'British Columbia', 'V6S1J3', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610122, 'Das', 'Triporna', '30 Burnhill Road', 'Scarborough', 'Ontario', 'M3M5L2', '30 Main Street', 'Vancouver', 'British Columbia', 'V6T1K3', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610123, 'Sarkar', 'Kowshik', '73 Jeremiah Lane', 'Scarborough', 'Ontario', 'M1J0A3', '380 West Mall Drive', 'Vancouver', 'British Columbia', 'V6J1H9', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610124, 'Islam', 'Rizwana', '900 Willowdale Avenue', 'North York', 'Ontario', 'M2M5K8', '3385 Fraser Street', 'Calgary', 'Alberta', 'T2P1L2', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610125, 'Hossain', 'Manhar', '45 Yonge Street', 'North York', 'Ontario', 'M2K2L8', '78 Miller Street', 'Calgary', 'Alberta', 'T2P1M9', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610126, 'Kapoor', 'Mahek', '98 Kipling Ave', 'Etobicoke', 'Ontario', 'M7J1S2', '78 Burrard Street', 'Vancouver', 'British Columbia', 'V5J1S9', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610127, 'Singh', 'Kerry', '990 Islington Avenue', 'Etobicoke', 'Ontario', 'M7J8K9', '89 Keele Street', 'Kingston', 'Ontario', 'M9L9S2', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610128, 'Singh', 'Dalveer', '1050 Finch Avenue', 'North York', 'Ontario', 'M2P2L3', '1050 Finch Avenue', 'North York', 'Ontario', 'M2P2L3', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610129, 'Kaur', 'Bhawanjeet', '1060 Yorkmills Road', 'North York', 'Ontario', 'M2M2B3', '1060 Yorkmills Road', 'North York', 'Ontario', 'M2M2B3', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610130, 'Bhawsar', 'Kinjal', '82 Via Romano Way', 'Brampton', 'Ontario', 'K2L3B5', '82 Via Romano Way', 'Brampton', 'Ontario', 'K2L3B5', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610131, 'Acharya', 'Unnati', '560 Finch Avenue West', 'North York', 'Ontario', 'M3J1L1', '560 Finch Avenue West', 'North York', 'Ontario', 'M3J1L1', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610132, 'Sofia', 'Polina', '450 Yonge Street', 'Yonge Street', 'Ontario', 'M2M6K4', '80 Main Street', 'Toronto', 'Ontario', 'M1M4K2', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610133, 'Andrew', 'Scott', '5800 Finch Ave East', 'North York', 'Ontario', 'M2J3V3', '5800 Finch Ave East', 'North York', 'Ontario', 'M2J3V3', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610134, 'Parish', 'Alex', '811 Kipling Avenue', 'Etobicoke', 'Ontario', 'M7J1M9', '105 Lemon Street', 'Tempe', 'Arizona, USA', '85281',12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610135, 'Logan', 'Daniel', '78 Bathurst Street', 'Toronto', 'Ontario', 'M1M5K7', '78 Bathurst Street', 'Toronto', 'Ontario', 'M1M5K7', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610136, 'Lucas', 'Ben', '78 Mavis Road', 'Mississauga', 'Ontario', 'L4T1C2', '78 Mavis Road', 'Mississauga', 'Ontario', 'L4T1C2', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610137, 'Riley', 'Jake', '90 Mississauga Road', 'Mississauga', 'Ontario', 'L4T3E4', '90 Mississauga Road', 'Mississauga', 'Ontario', 'L4T3E4', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610138, 'Tyler', 'David', '84 Thorncliffe Park Drive', 'East York', 'Ontario', 'M4H1L3', '84 Thorncliffe Park Drive', 'East York', 'Ontario', 'M4H1L3', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610139, 'Kian', 'Michael', '980 Niagara Street', 'Toronto', 'Ontario', 'M3M4D2', '129 Mississauga Road', 'Mississauga', 'Ontario', 'L4T3E4', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610140, 'Mazat', 'Michael', '980 Jin Street', 'Toronto', 'Ontario', 'M3M4D1', '190 Mississauga Road', 'Mississauga', 'Ontario', 'L4T3E4', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610141, 'Slandin', 'Rick', '80 Niagara Street', 'Toronto', 'Ontario', 'M5M4D2', '129 Looke Road', 'Mississauga', 'Ontario', 'L4T3E4', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610142, 'Micksi', 'Minnie', '98 Nia Street', 'Toronto', 'Ontario', 'M3L4D2', '1 Missi Road', 'Mississauga', 'Ontario', 'L4T3E4', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610143, 'Ronam', 'Lynn', '8 Sima Street', 'Toronto', 'Ontario', 'M3M4D2', '144 Mississauga Road', 'Mississauga', 'Ontario', 'L4T3E4', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610144, 'Bobby', 'Ronald', '5 James Street', 'Toronto', 'Ontario', 'M3M4D2', '180 Mississauga Road', 'Mississauga', 'Ontario', 'L4T3E4', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610145, 'Laney', 'Michael', '383 Niagara Street', 'Toronto', 'Ontario', 'M3M4D7', '190 Mississauga Road', 'Mississauga', 'Ontario', 'L4T3E4', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610146, 'Pano', 'Mich', '980 John Street', 'Toronto', 'Ontario', 'M3M4D1', '129 James Road', 'Mississauga', 'Ontario', 'L4T3E4', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610147, 'Kreken', 'Michael', '980 Noona Street', 'Toronto', 'Ontario', 'M3M4D2', '129 Jin Road', 'Mississauga', 'Ontario', 'L4T3E4', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610148, 'Kian', 'Michael', '980 Niagara Street', 'Toronto', 'Ontario', 'M3M4D2', '129 John Road', 'Mississauga', 'Ontario', 'L4T3E4', 12, 12, 4.0, 48.0, 'Good standing');
INSERT INTO Student VALUES (810610149, 'Lindo', 'Randy', '980 Bimo Street', 'Toronto', 'Ontario', 'M3M4D1', '129 Lane Road', 'Mississauga', 'Ontario', 'L4Z3E4', 12, 12, 4.0, 48.0, 'Good standing');
COMMIT;

INSERT INTO Department VALUES ('ITS', 'MEDIA STUDIES', 'NORTH CAMPUS LRC');
INSERT INTO Department VALUES ('HRM', 'HUMAN RESOURCES', 'NORTH CAMPUS LRC');
INSERT INTO Department VALUES ('PHY', 'PHYSICS', 'SOUTH CAMPUS');
INSERT INTO Department VALUES ('CHM', 'CHEMISTRY', 'NORTH CAMPUS LRC');
INSERT INTO Department VALUES ('ENG', 'ENGINEERING', 'SOUTH CAMPUS');
COMMIT;

INSERT INTO Office VALUES ('4001', '6473783780');
INSERT INTO Office VALUES ('4002', '6477806910');
INSERT INTO Office VALUES ('4003', '4164006700');
INSERT INTO Office VALUES ('4004', '4167148600');
INSERT INTO Office VALUES ('4005', '4167449800');
INSERT INTO Office VALUES ('4006', '6478907200');
INSERT INTO Office VALUES ('4007', '4168449801');
INSERT INTO Office VALUES ('4008', '6479907203');
COMMIT;

INSERT INTO Faculty VALUES (9001, 'Johnson', 'James', '38 Nonna Street', 'Toronto', 'Ontario', 'M3K3L1', 'Professor', '22-JAN-08', 4001, 'ITS');
INSERT INTO Faculty VALUES (9002, 'Patel', 'Harry', '780 Yonge Street', 'Toronto', 'Ontario', 'M2M4J9', 'Lecturer', '29-JAN-10', 4002, 'ITS');
INSERT INTO Faculty VALUES (9003, 'Singh', 'Jimmy', '3506 Markham Road', 'Scarborough', 'Ontario', 'M1J1A8', 'Professor', '26-FEB-09', 4003, 'HRM');
INSERT INTO Faculty VALUES (9004, 'Love', 'Linda', '18 Keele Street', 'Toronto', 'Ontario', 'M1K1J3', 'Associate-Professor', '10-JUL-09', 4005, 'HRM');
INSERT INTO Faculty VALUES (9005, 'Chema', 'Ron', '99 Juni Street', 'Toronto', 'Ontario', 'M1P1N3', 'Professor', '10-JUN-04', 4006, 'CHM');
INSERT INTO Faculty VALUES (9006, 'Linberg', 'Jessie', '89 Clarkson Street', 'Toronto', 'Ontario', 'M1P1N1', 'Professor', '10-MAY-09', 4007, 'PHY');
INSERT INTO Faculty VALUES (9007, 'White', 'Jane', '44 Ricky Street', 'Toronto', 'Ontario', 'M1P1N8', 'Lecturer', '02-JUN-02', 4008, 'PHY');
COMMIT;

INSERT INTO Major VALUES ('101', 'SOFTWARE DEV', 'ITS');
INSERT INTO Major VALUES ('102', 'ORGANIC CHEM', 'CHM');
INSERT INTO Major VALUES ('103', 'HR MANAGEMENT', 'HRM');
INSERT INTO Major VALUES ('104', 'APPLIED PHYSICS', 'PHY');
INSERT INTO Major VALUES ('105', 'MECHANICAL ENGINEERING', 'ENG');
COMMIT;

INSERT INTO Advises VALUES ('101', 810610111 , '9001');
INSERT INTO Advises VALUES ('101', 810610112 , '9001');
INSERT INTO Advises VALUES ('101', 810610113 , '9002');
INSERT INTO Advises VALUES ('104', 810610125 , '9007');
INSERT INTO Advises VALUES ('104', 810610126 , '9007');
INSERT INTO Advises VALUES ('104', 810610127 , '9007');
COMMIT;

INSERT INTO Semester VALUES ('FA15', '07-SEP-2015', '10-DEC-2015', '11-DEC-2015', '20-DEC-2015', '07-OCT-2015');
INSERT INTO Semester VALUES ('WI16', '07-JAN-2016', '11-APR-2016', '15-APR-2016', '22-APR-2016', '12-MAR-2016');
INSERT INTO Semester VALUES ('SU15', '09-MAY-2015', '05-AUG-2015', '09-AUG-2015', '15-AUG-2015', '15-JUN-2015');
INSERT INTO Semester VALUES ('FA14', '08-SEP-2015', '11-DEC-2015', '12-DEC-2015', '19-DEC-2015', '08-OCT-2015');
INSERT INTO Semester VALUES ('SU14', '07-MAY-2015', '07-AUG-2015', '14-AUG-2015', '20-AUG-2015', '12-JUN-2015');
INSERT INTO Semester VALUES ('WI15', '05-JAN-2016', '14-APR-2016', '21-APR-2016', '27-APR-2016', '13-MAR-2016');

COMMIT;

INSERT INTO Course VALUES ('ITS501', 'ITS', 'INTRO TO JAVA', 3);
INSERT INTO Course VALUES ('ITS503', 'ITS', 'INTRO TO SQL', 3);
INSERT INTO Course VALUES ('ITS504', 'ITS', 'WEB DEVELOPMENT', 3);
INSERT INTO Course VALUES ('ITS506', 'ITS', 'OPERATING SYSTEM', 3);
INSERT INTO Course VALUES ('ITS510', 'ITS', 'XML AND JAVASCRIPT', 3);
INSERT INTO Course VALUES ('ITS514', 'ITS', 'ADVANCED DBMS', 3);
INSERT INTO Course VALUES ('ITS556', 'ITS', 'ADVANCED OS', 3);
INSERT INTO Course VALUES ('ITS525', 'ITS', 'DOT NET DEV', 3);
INSERT INTO Course VALUES ('CHM101', 'CHM', 'INTRO TO CHEM', 3);
INSERT INTO Course VALUES ('CHM102', 'CHM', 'ADVANCED CHEM', 3);
INSERT INTO Course VALUES ('CHM105', 'CHM', 'ORGANIC CHEM', 3);
INSERT INTO Course VALUES ('CHM107', 'CHM', 'LABORATORY SKILLS', 3);
INSERT INTO Course VALUES ('CHM109', 'CHM', 'BIOCHEMISTRY', 3);
INSERT INTO Course VALUES ('CHM106', 'CHM', 'ADVANCED ORGANIC CHEM', 3);
INSERT INTO Course VALUES ('CHM110', 'CHM', 'ADVANCED BIOCHEMISTRY', 3);
INSERT INTO Course VALUES ('CHM108', 'CHM', 'ADVANCED LABORATORY', 3);
INSERT INTO Course VALUES ('HRM101', 'HRM', 'INTRO TO HRM', 3);
INSERT INTO Course VALUES ('HRM201', 'HRM', 'RECRUITMENT', 3);
INSERT INTO Course VALUES ('HRM240', 'HRM', 'INDUSTRIAL RLTN', 3);
INSERT INTO Course VALUES ('HRM301', 'HRM', 'HR PLANNING', 3);
INSERT INTO Course VALUES ('HRM102', 'HRM', 'ADVANCED HRM', 3);
INSERT INTO Course VALUES ('HRM202', 'HRM', 'ADVANCED RECRUITMENT', 3);
INSERT INTO Course VALUES ('HRM241', 'HRM', 'ADVANCED INDUSTRIAL RLTN', 3);
INSERT INTO Course VALUES ('HRM302', 'HRM', 'ADVANCED HR PLANNING', 3);
INSERT INTO Course VALUES ('PHY001', 'PHY', 'INTRO TO PHYSICS', 3);
INSERT INTO Course VALUES ('PHY002', 'PHY', 'CALCULUS', 3);
INSERT INTO Course VALUES ('PHY003', 'PHY', 'APPLIED PHYSICS', 3);
INSERT INTO Course VALUES ('PHY004', 'PHY', 'PHYSICS LAB', 3);
INSERT INTO Course VALUES ('PHY005', 'PHY', 'ADVANCED PHYSICS', 3);
INSERT INTO Course VALUES ('PHY006', 'PHY', 'ADVANCED CALCULUS', 3);
INSERT INTO Course VALUES ('PHY007', 'PHY', 'ADVANCED PHYSICS LAB', 3);
INSERT INTO Course VALUES ('PHY008', 'PHY', 'ADVANCED APPLIED PHYSICS', 3);
COMMIT;

INSERT INTO Section VALUES ('1001', 'FA15', 'A', '9:00-11:00 M', '101', 5, 20, '9001', 'ITS501', 'ITS');
INSERT INTO Section VALUES ('1002', 'FA15', 'A', '9:00-11:00 T', '102', 5, 20, '9001', 'ITS503', 'ITS');
INSERT INTO Section VALUES ('1003', 'FA15', 'A', '9:00-11:00 W', '103', 5, 20, '9002', 'ITS504', 'ITS');
INSERT INTO Section VALUES ('1004', 'FA15', 'A', '9:00-11:00 R', '104', 5, 20, '9002', 'ITS506', 'ITS');
INSERT INTO Section VALUES ('1005', 'FA15', 'B', '13:00-15:00 M', '101', 5, 20, '9001', 'ITS501', 'ITS');
INSERT INTO Section VALUES ('1006', 'FA15', 'B', '13:00-15:00 T', '102', 5, 20, '9001', 'ITS503', 'ITS');
INSERT INTO Section VALUES ('1007', 'FA15', 'B', '13:00-15:00 W', '103', 5, 20, '9002', 'ITS504', 'ITS');
INSERT INTO Section VALUES ('1008', 'FA15', 'B', '13:00-15:00 R', '104', 5, 20, '9002', 'ITS506', 'ITS');
INSERT INTO Section VALUES ('1009', 'WI16', 'A', '9:00-11:00 M', '101', 5, 20, '9001', 'ITS525', 'ITS');
INSERT INTO Section VALUES ('1010', 'WI16', 'A', '9:00-11:00 T', '102', 5, 20, '9001', 'ITS514', 'ITS');
INSERT INTO Section VALUES ('1011', 'WI16', 'A', '9:00-11:00 W', '103', 5, 20, '9002', 'ITS510', 'ITS');
INSERT INTO Section VALUES ('1012', 'WI16', 'A', '9:00-11:00 R', '104', 5, 20, '9002', 'ITS556', 'ITS');
INSERT INTO Section VALUES ('1013', 'WI16', 'B', '13:00-15:00 M', '101', 5, 20, '9001', 'ITS525', 'ITS');
INSERT INTO Section VALUES ('1014', 'WI16', 'B', '13:00-15:00 T', '102', 5, 20, '9001', 'ITS514', 'ITS');
INSERT INTO Section VALUES ('1015', 'WI16', 'B', '13:00-15:00 W', '103', 5, 20, '9002', 'ITS510', 'ITS');
INSERT INTO Section VALUES ('1016', 'WI16', 'B', '13:00-15:00 R', '104', 5, 20, '9002', 'ITS556', 'ITS');
INSERT INTO Section VALUES ('4001', 'FA15', 'A', '9:00-11:00 M', '101', 5, 20, '9006', 'PHY001', 'PHY');
INSERT INTO Section VALUES ('4002', 'FA15', 'A', '9:00-11:00 T', '102', 5, 20, '9006', 'PHY002', 'PHY');
INSERT INTO Section VALUES ('4003', 'FA15', 'A', '9:00-11:00 W', '103', 5, 20, '9007', 'PHY003', 'PHY');
INSERT INTO Section VALUES ('4004', 'FA15', 'A', '9:00-11:00 R', '104', 5, 20, '9007', 'PHY004', 'PHY');
INSERT INTO Section VALUES ('4005', 'FA15', 'B', '13:00-15:00 M', '101', 5, 20, '9006', 'PHY001', 'PHY');
INSERT INTO Section VALUES ('4006', 'FA15', 'B', '13:00-15:00 T', '102', 5, 20, '9006', 'PHY002', 'PHY');
INSERT INTO Section VALUES ('4007', 'FA15', 'B', '13:00-15:00 W', '103', 5, 20, '9007', 'PHY003', 'PHY');
INSERT INTO Section VALUES ('4008', 'FA15', 'B', '13:00-15:00 R', '104', 5, 20, '9007', 'PHY004', 'PHY');
INSERT INTO Section VALUES ('4009', 'WI16', 'A', '9:00-11:00 M', '101', 5, 20, '9006', 'PHY005', 'PHY');
INSERT INTO Section VALUES ('4010', 'WI16', 'A', '9:00-11:00 T', '102', 5, 20, '9006', 'PHY006', 'PHY');
INSERT INTO Section VALUES ('4011', 'WI16', 'A', '9:00-11:00 W', '103', 5, 20, '9007', 'PHY007', 'PHY');
INSERT INTO Section VALUES ('4012', 'WI16', 'A', '9:00-11:00 R', '104', 5, 20, '9007', 'PHY008', 'PHY');
INSERT INTO Section VALUES ('4013', 'WI16', 'B', '13:00-15:00 M', '101', 5, 20, '9006', 'PHY005', 'PHY');
INSERT INTO Section VALUES ('4014', 'WI16', 'B', '13:00-15:00 T', '102', 5, 20, '9006', 'PHY006', 'PHY');
INSERT INTO Section VALUES ('4015', 'WI16', 'B', '13:00-15:00 W', '103', 5, 20, '9007', 'PHY007', 'PHY');
INSERT INTO Section VALUES ('4016', 'WI16', 'B', '13:00-15:00 R', '104', 5, 20, '9007', 'PHY008', 'PHY');
COMMIT;

--  5 students per class section for ITS and PHY
INSERT INTO StudentClass VALUES (810610110, 1001, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610110, 1002, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610110, 1003, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610110, 1004, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610111, 1001, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610111, 1002, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610111, 1003, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610111, 1004, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610112, 1001, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610112, 1002, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610112, 1003, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610112, 1004, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610113, 1001, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610113, 1002, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610113, 1003, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610113, 1004, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610114, 1001, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610114, 1002, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610114, 1003, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610114, 1004, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610115, 1005, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610115, 1006, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610115, 1007, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610115, 1008, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610116, 1005, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610116, 1006, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610116, 1007, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610116, 1008, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610117, 1005, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610117, 1006, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610117, 1007, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610117, 1008, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610118, 1005, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610118, 1006, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610118, 1007, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610118, 1008, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610119, 1005, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610119, 1006, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610119, 1007, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610119, 1008, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610120, 1009, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610120, 1010, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610120, 1011, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610120, 1012, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610121, 1009, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610121, 1010, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610121, 1011, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610121, 1012, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610122, 1009, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610122, 1010, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610122, 1011, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610122, 1012, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610123, 1009, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610123, 1010, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610123, 1011, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610123, 1012, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610124, 1009, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610124, 1010, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610124, 1011, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610124, 1012, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610125, 1013, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610125, 1014, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610125, 1015, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610125, 1016, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610126, 1013, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610126, 1014, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610126, 1015, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610126, 1016, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610127, 1013, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610127, 1014, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610127, 1015, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610127, 1016, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610128, 1013, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610128, 1014, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610128, 1015, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610128, 1016, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610129, 1013, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610129, 1014, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610129, 1015, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610129, 1016, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610130, 4001, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610130, 4002, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610130, 4003, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610130, 4004, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610131, 4001, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610131, 4002, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610131, 4003, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610131, 4004, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610149, 4001, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610149, 4002, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610149, 4003, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610149, 4004, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610132, 4001, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610132, 4002, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610132, 4003, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610132, 4004, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610133, 4001, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610133, 4002, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610133, 4003, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610133, 4004, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610134, 4005, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610134, 4006, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610134, 4007, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610134, 4008, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610135, 4005, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610135, 4006, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610135, 4007, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610135, 4008, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610136, 4005, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610136, 4006, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610136, 4007, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610136, 4008, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610137, 4005, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610137, 4006, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610137, 4007, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610137, 4008, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610138, 4005, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610138, 4006, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610138, 4007, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610138, 4008, 'FA15', 'A');
INSERT INTO StudentClass VALUES (810610139, 4009, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610139, 4010, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610139, 4011, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610139, 4012, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610140, 4009, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610140, 4010, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610140, 4011, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610140, 4012, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610141, 4009, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610141, 4010, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610141, 4011, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610141, 4012, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610142, 4009, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610142, 4010, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610142, 4011, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610142, 4012, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610143, 4009, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610143, 4010, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610143, 4011, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610143, 4012, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610144, 4013, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610144, 4014, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610144, 4015, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610144, 4016, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610145, 4013, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610145, 4014, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610145, 4015, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610145, 4016, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610146, 4013, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610146, 4014, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610146, 4015, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610146, 4016, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610147, 4013, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610147, 4014, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610147, 4015, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610147, 4016, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610148, 4013, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610148, 4014, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610148, 4015, 'WI16', 'A');
INSERT INTO StudentClass VALUES (810610148, 4016, 'WI16', 'A');
COMMIT;
                  
INSERT INTO StudentGrade VALUES ('ITS501','ITS',810610110,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS503','ITS',810610110,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS504','ITS',810610110,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS506','ITS',810610110,'FA15', 'A', 3, 12.0);              
INSERT INTO StudentGrade VALUES ('ITS501','ITS',810610111,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS503','ITS',810610111,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS504','ITS',810610111,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS506','ITS',810610111,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS501','ITS',810610112,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS503','ITS',810610112,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS504','ITS',810610112,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS506','ITS',810610112,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS501','ITS',810610113,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS503','ITS',810610113,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS504','ITS',810610113,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS506','ITS',810610113,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS501','ITS',810610114,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS503','ITS',810610114,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS504','ITS',810610114,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS506','ITS',810610114,'FA15', 'A', 3, 12.0);                  
INSERT INTO StudentGrade VALUES ('ITS501','ITS',810610115,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS503','ITS',810610115,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS504','ITS',810610115,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS506','ITS',810610115,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS501','ITS',810610116,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS503','ITS',810610116,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS504','ITS',810610116,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS506','ITS',810610116,'FA15', 'A', 3, 12.0);                  
INSERT INTO StudentGrade VALUES ('ITS501','ITS',810610117,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS503','ITS',810610117,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS504','ITS',810610117,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS506','ITS',810610117,'FA15', 'A', 3, 12.0);           
INSERT INTO StudentGrade VALUES ('ITS501','ITS',810610118,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS503','ITS',810610118,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS504','ITS',810610118,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS506','ITS',810610118,'FA15', 'A', 3, 12.0);                       
INSERT INTO StudentGrade VALUES ('ITS501','ITS',810610119,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS503','ITS',810610119,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS504','ITS',810610119,'FA15', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS506','ITS',810610119,'FA15', 'A', 3, 12.0);            
INSERT INTO StudentGrade VALUES ('ITS510','ITS',810610120,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS556','ITS',810610120,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS525','ITS',810610120,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS514','ITS',810610120,'WI16', 'A', 3, 12.0);                                                            
INSERT INTO StudentGrade VALUES ('ITS510','ITS',810610121,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS556','ITS',810610121,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS525','ITS',810610121,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS514','ITS',810610121,'WI16', 'A', 3, 12.0);                                           
INSERT INTO StudentGrade VALUES ('ITS510','ITS',810610122,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS556','ITS',810610122,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS525','ITS',810610122,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS514','ITS',810610122,'WI16', 'A', 3, 12.0);                               
INSERT INTO StudentGrade VALUES ('ITS510','ITS',810610123,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS556','ITS',810610123,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS525','ITS',810610123,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS514','ITS',810610123,'WI16', 'A', 3, 12.0);              
INSERT INTO StudentGrade VALUES ('ITS510','ITS',810610124,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS556','ITS',810610124,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS525','ITS',810610124,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS514','ITS',810610124,'WI16', 'A', 3, 12.0);                                                                                                                                                     
INSERT INTO StudentGrade VALUES ('ITS510','ITS',810610125,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS556','ITS',810610125,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS525','ITS',810610125,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS514','ITS',810610125,'WI16', 'A', 3, 12.0);                                                 
INSERT INTO StudentGrade VALUES ('ITS510','ITS',810610126,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS556','ITS',810610126,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS525','ITS',810610126,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS514','ITS',810610126,'WI16', 'A', 3, 12.0);                                                       
INSERT INTO StudentGrade VALUES ('ITS510','ITS',810610127,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS556','ITS',810610127,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS525','ITS',810610127,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS514','ITS',810610127,'WI16', 'A', 3, 12.0);                                                           
INSERT INTO StudentGrade VALUES ('ITS510','ITS',810610128,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS556','ITS',810610128,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS525','ITS',810610128,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS514','ITS',810610128,'WI16', 'A', 3, 12.0);                                                       
INSERT INTO StudentGrade VALUES ('ITS510','ITS',810610129,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS556','ITS',810610129,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS525','ITS',810610129,'WI16', 'A', 3, 12.0);        
INSERT INTO StudentGrade VALUES ('ITS514','ITS',810610129,'WI16', 'A', 3, 12.0);        
COMMIT;

INSERT INTO StudentGrade VALUES ( 'PHY001','PHY',810610130, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY002','PHY',810610130, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY003','PHY',810610130, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY004','PHY',810610130, 'FA15', 'A', 3, 12.0);      
INSERT INTO StudentGrade VALUES ( 'PHY001','PHY',810610131, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY002','PHY',810610131, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY003','PHY',810610131, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY004','PHY',810610131, 'FA15', 'A', 3, 12.0);       
INSERT INTO StudentGrade VALUES ( 'PHY001','PHY',810610149, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY002','PHY',810610149, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY003','PHY',810610149, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY004','PHY',810610149, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY001','PHY',810610132, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY002','PHY',810610132, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY003','PHY',810610132, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY004','PHY',810610132, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY001','PHY',810610133, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY002','PHY',810610133, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY003','PHY',810610133, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY004','PHY',810610133, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY001','PHY',810610134, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY002','PHY',810610134, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY003','PHY',810610134, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY004','PHY',810610134, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY001','PHY',810610135, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY002','PHY',810610135, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY003','PHY',810610135, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY004','PHY',810610135, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY001','PHY',810610136, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY002','PHY',810610136, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY003','PHY',810610136, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY004','PHY',810610136, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY001','PHY',810610137, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY002','PHY',810610137, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY003','PHY',810610137, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY004','PHY',810610137, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY001','PHY',810610138, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY002','PHY',810610138, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY003','PHY',810610138, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY004','PHY',810610138, 'FA15', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY005','PHY',810610139, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY006','PHY',810610139, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY007','PHY',810610139, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY008','PHY',810610139, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY005','PHY',810610140, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY006','PHY',810610140, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY007','PHY',810610140, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY008','PHY',810610140, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY005','PHY',810610141, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY006','PHY',810610141, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY007','PHY',810610141, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY008','PHY',810610141, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY005','PHY',810610142, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY006','PHY',810610142, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY007','PHY',810610142, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY008','PHY',810610142, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY005','PHY',810610143, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY006','PHY',810610143, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY007','PHY',810610143, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY008','PHY',810610143, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY005','PHY',810610144, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY006','PHY',810610144, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY007','PHY',810610144, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY008','PHY',810610144, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY005','PHY',810610145, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY006','PHY',810610145, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY007','PHY',810610145, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY008','PHY',810610145, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY005','PHY',810610146, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY006','PHY',810610146, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY007','PHY',810610146, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY008','PHY',810610146, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY005','PHY',810610147, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY006','PHY',810610147, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY007','PHY',810610147, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY008','PHY',810610147, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY005','PHY',810610148, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY006','PHY',810610148, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY007','PHY',810610148, 'WI16', 'A', 3, 12.0);
INSERT INTO StudentGrade VALUES ( 'PHY008','PHY',810610148, 'WI16', 'A', 3, 12.0);
COMMIT;

INSERT INTO Prereq VALUES ('PHY005','PHY',  'PHY001', 'PHY');
INSERT INTO Prereq VALUES ('PHY006','PHY',  'PHY002', 'PHY');
INSERT INTO Prereq VALUES ('PHY007','PHY',  'PHY003', 'PHY');
INSERT INTO Prereq VALUES ('PHY008','PHY',  'PHY004', 'PHY');
INSERT INTO Prereq VALUES ('ITS510','ITS',  'ITS504', 'ITS');
INSERT INTO Prereq VALUES ('ITS514','ITS',  'ITS503', 'ITS');
INSERT INTO Prereq VALUES ('ITS556','ITS',  'ITS506', 'ITS');
INSERT INTO Prereq VALUES ('ITS525','ITS',  'ITS501', 'ITS');
COMMIT;

INSERT INTO RegistrationRequest VALUES (810610110, 1010, 'WI16', 1014, 'WI16');
INSERT INTO RegistrationRequest VALUES (810610111, 1010, 'WI16', 1014, 'WI16');
INSERT INTO RegistrationRequest VALUES (810610112, 1010, 'WI16', 1014, 'WI16');
INSERT INTO RegistrationRequest VALUES (810610144, 4009, 'WI16', 4013, 'WI16');
INSERT INTO RegistrationRequest VALUES (810610145, 4009, 'WI16', 4013, 'WI16');
INSERT INTO RegistrationRequest VALUES (810610146, 4009, 'WI16', 4013, 'WI16');
COMMIT;

