select * from master.dbo.Air_Quality order by FIPScode;
select * from master.dbo.[123] ;

--
alter table master.dbo.[123]
alter column MeasureType int ;

exec sp_rename 'master.dbo.[123]', 'Air_Quality';

--
CREATE VIEW QryPatientFIPSView AS
SELECT p.Person_id as Person_id, a.*FROM Person p 
Inner join Air_quality a on p.FIPScode=a.FIPScode;

--
INSERT into person VALUES ( ' 1003 ', '1970', 'Male', '40143','1');
INSERT into person VALUES ( ' 1004 ', '1980', 'Female', '39151','1');
INSERT into person VALUES ( ' 1005 ', '1984', 'Male', '4003','1');
INSERT into person VALUES ( ' 1006 ', '1988', 'Male', '17115','1');
INSERT into person VALUES ( ' 1007 ', '1977', 'Female', '19193','1');

INSERT into person VALUES ( '1001 ', '1990', 'Male', '1027', '1' );
INSERT into person VALUES ( '1002 ', '1980', 'Female', '1051', '1');
INSERT into person VALUES ( ' 1003 ', '1970', 'Male', '40143','1');
INSERT into person VALUES ( ' 1004 ', '1980', 'Female', '39151','1');
INSERT into person VALUES ( ' 1005 ', '1984', 'Male', '4003','1');
INSERT into person VALUES ( ' 1006 ', '1988', 'Male', '17115','1');
INSERT into person VALUES ( ' 1007 ', '1977', 'Female', '19193','1');



select * from QryPatientFIPSView
order by person_id, ReportYear;
--
INSERT into Condition_occurrence values('3023', '1007', '2000-1-1 00:00:00', '2006-1-10 00:00:00', 'asthma');
INSERT into Condition_occurrence values('3002', '1002', '1999-1-1 00:00:00', '2000-1-10 00:00:00', 'asthma');
INSERT into Condition_occurrence values('3003', '1002', '2001-1-1 00:00:00', '2002-1-10 00:00:00', 'asthma');
INSERT into Condition_occurrence values('3004', '1002', '1999-1-1 00:00:00', '2003-1-10 00:00:00', 'asthma');

INSERT into Condition_occurrence values('3005', '1003', '2004-1-1 00:00:00', '2004-1-10 00:00:00', 'asthma');
INSERT into Condition_occurrence values('3006', '1003', '2005-1-1 00:00:00', '2005-1-10 00:00:00', 'asthma');
INSERT into Condition_occurrence values('3007', '1003', '1999-1-1 00:00:00', '2003-1-10 00:00:00', 'asthma');

INSERT into Condition_occurrence values('3008', '1004', '2004-1-1 00:00:00', '2005-1-10 00:00:00', 'asthma');
INSERT into Condition_occurrence values('3009', '1004', '2003-1-1 00:00:00', '2004-1-10 00:00:00', 'asthma');
INSERT into Condition_occurrence values('3010', '1004', '2003-1-1 00:00:00', '2004-1-10 00:00:00', 'asthma');

INSERT into Condition_occurrence values('3011', '1005', '2000-1-1 00:00:00', '2005-1-10 00:00:00', 'asthma');
INSERT into Condition_occurrence values('3012', '1005', '2003-1-1 00:00:00', '2004-1-10 00:00:00', 'asthma');
INSERT into Condition_occurrence values('3013', '1007', '2005-1-1 00:00:00', '2006-1-10 00:00:00', 'asthma');

INSERT into Condition_occurrence values('3014', '1006', '2004-1-1 00:00:00', '2005-1-10 00:00:00', 'asthma');
INSERT into Condition_occurrence values('3015', '1006', '2003-1-1 00:00:00', '2004-1-10 00:00:00', 'asthma');
INSERT into Condition_occurrence values('3016', '1007', '2005-1-1 00:00:00', '2006-1-10 00:00:00', 'asthma');

--
CREATE VIEW QryConditionPatientFIPSView as 
select c.*,q.FIPScode,StateName,CountyName,ReportYear,MeasureValue,MeasureType from Condition_occurrence c
inner join QryPatientFIPSView q on c.Person_id=q.Person_id;

--
select * from QryConditionPatientFIPSView where FIPScode like'19___';

--
CREATE VIEW QryAsthmaConditionView AS
select *  from QryConditionPatientFIPSView
where ReportYear<=year(Condition_end_date) 
and ReportYear>=year(Condition_start_date) 
and Condition_name='asthma';
--
CREATE VIEW QryAsthmaType2View as 
SELECT FIPScode,ReportYear,avg(MeasureValue) as avg_MeasureValue,COUNT(Condition_occurrence_id) AS Condition_Number FROM QryAsthmaConditionView
WHERE MeasureType=2
GROUP BY ReportYear,FIPScode;

select * from QryAsthmaType2View
drop view  QryAsthmaType2View;
select Condition_Number/sum(Condition_Number) from QryAsthmaType1View
group by FIPScode, ReportYear;

SELECT A.FIPScode, A.ReportYear,A.avg_MeasureValue, ROUND(A.count1*1.0/B.count2,3) as Frequency
FROM (
		SELECT  FIPScode,ReportYear,avg(MeasureValue) as avg_MeasureValue,COUNT(Condition_occurrence_id) AS count1
		FROM QryAsthmaConditionView
		WHERE MeasureType=1
		GROUP BY ReportYear,FIPScode
		) as A
		Inner Join(
					SELECT FIPScode,COUNT(Condition_occurrence_id) AS count2
					FROM QryAsthmaConditionView
					WHERE MeasureType=1
					GROUP BY FIPScode
					) as B
					ON A.FIPScode=B.FIPScode;

Create table Visit_occurrence (
Visit_occurrence_id int NOT NULL,
Person_id int NULL,
Visit_start_date datetime NULL,
Visit_end_date datetime NULL,
Visit_type varchar(225) NULL,
CONSTRAINT PK_Visit PRIMARY KEY (Visit_occurrence_id),
CONSTRAINT FK_Visit FOREIGN KEY (Person_id)
	REFERENCES Person(Person_id) ON UPDATE 
CASCADE

);

INSERT into Visit_occurrence( '2001 ', '1001', '2000-1-1 00:00:00', '2000-1-10 00:00:00','1');
INSERT into Visit_occurrence( '2002 ', '1001', '2000-1-2 00:00:00', '2000-1-12 00:00:00','1');
INSERT into Visit_occurrence( '2003 ', '1001', '2000-1-3 00:00:00', '2000-1-13 00:00:00','2');
INSERT into Visit_occurrence( '2004 ', '1002', '2000-1-4 00:00:00', '2000-1-14 00:00:00','2');
INSERT into Visit_occurrence( '2005 ', '1002', '2000-1-5 00:00:00', '2000-1-15 00:00:00','2');

Create table Condition_occurrence (
Condition_occurrence_id int NOT NULL,
Person_id int NULL,
Visit_occurrence_id int NULL,
Condition_start_date datetime NULL,
Condition_end_date datetime NULL,
Condition_name varchar(225) NULL,
CONSTRAINT PK_Con PRIMARY KEY (Condition_occurrence_id),
CONSTRAINT FK_Con FOREIGN KEY (Person_id) 
	REFERENCES Person(Person_id),
CONSTRAINT FK_Con_Visit FOREIGN KEY (Visit_occurrence_id) 
REFERENCES Visit_occurrence(Visit_occurrence_id) ON UPDATE 
CASCADE
);

SELECT * FROM Condition_occurrence;

Create table Drug_exposure(
Drug_exposure_id int NOT NULL,
Person_id int NULL,
Visit_occurrence_id int NULL,
Drug_exposure_start_date datetime NULL,
Drug_exposure_end_date datetime NULL,
Drug_name varchar(225) NULL,
CONSTRAINT PK_Drug PRIMARY KEY (Drug_exposure_id),
CONSTRAINT FK_Drug FOREIGN KEY (Person_id) 
	REFERENCES Person(Person_id),
CONSTRAINT FK_Drug_Visit FOREIGN KEY (Visit_occurrence_id) 
REFERENCES Visit_occurrence(Visit_occurrence_id) ON UPDATE 
CASCADE
);

INSERT into Procedure_occurrence  ( '5001', '1001','2001','2000-1-1 00:00:00', '2000-1-10 00:00:00','abc');
INSERT into Procedure_occurrence  ( '5002', '1001','2002','2000-1-2 00:00:00', '2000-1-12 00:00:00','bcc');
INSERT into Procedure_occurrence  ( '5003', '1001','2003','2000-1-3 00:00:00', '2000-1-13 00:00:00','cdd');
INSERT into Procedure_occurrence  ( '5004', '1002','2004','2000-1-4 00:00:00', '2000-1-14 00:00:00','add');
INSERT into Procedure_occurrence  ( '5005', '1002','2005','2000-1-5 00:00:00', '2000-1-15 00:00:00','bee');


Create table Procedure_occurrence( 
Procedure_occurrence_id int NOT NULL,
Person_id int NULL,
Visit_occurrence_id int NULL,
Procedure_date datetime NULL,
Procedure_name varchar(225) NULL,
CONSTRAINT PK_Pro PRIMARY KEY (Procedure_occurrence_id),
CONSTRAINT FK_Pro FOREIGN KEY (Person_id) 
	REFERENCES Person(Person_id),
CONSTRAINT FK_Pro_Visit FOREIGN KEY(Visit_occurrence_id) 
REFERENCES Visit_occurrence(Visit_occurrence_id) ON UPDATE 
CASCADE

);


Create table Air_quality(
Record_id int NOT NULL,
FIPScode int NULL,
StateName varchar(225) NULL,
CountyName varchar(225) NULL,
ReportYear int NULL,
MeasureType int NULL,
MeasureValue int NULL,
CONSTRAINT PK_Air PRIMARY KEY (Record_id)
);
