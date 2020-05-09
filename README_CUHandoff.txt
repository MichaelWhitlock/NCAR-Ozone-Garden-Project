Thank you Ryan for being so helpful with the project!


Quick docker build commands:

sudo docker build -t ozonedocker .
sudo docker run -p 80:80 ozonedocker
(Linux specifically)

Backend File Overview:

Dockerfile 			- docker imports
	
data_add.pl			- data entry page for database

data_visual.pl		- data visualization using graphs
data_visual.js		- actual script that builds the graphs

gallery.pl			- photo repository
index.pl			- homepage
training.pl			- "game" perl page

map.js				- javascript file containing what builds the world map for clicking on leafs


Mysql Build Commands:

Can copy paste from line 26->68 successfully

CREATE TABLE UserEntries (
	entryID INTEGER NOT NULL AUTO_INCREMENT,
	curDate DATE,
	curYear YEAR,
	plantID INTEGER,
	userID INTEGER,
	daysSinceEmergence INTEGER,
	NLeaves INTEGER,
	0_damage INTEGER,
	1_6_damage INTEGER,
	7_25_damage INTEGER,
	26_50_damage INTEGER,
	51_75_damage INTEGER,
	76_100_damage INTEGER,
	PRIMARY KEY(entryID)
);

CREATE TABLE Plants (
	plantID INTEGER NOT NULL AUTO_INCREMENT,
	location varchar(255),
	plantType varchar(255),
	dateOfEmergence DATE,
	dateGrowthStarted DATE,
	PRIMARY KEY(plantID)
);

CREATE TABLE UserTable (
	UserID INTEGER NOT NULL AUTO_INCREMENT,
	email varchar(255),
	name varchar(255),
	institution varchar(255),
	password varchar(255),
	salt varchar(255),
	locationID integer,
	 PRIMARY KEY(UserID)
);

CREATE TABLE GardenLocations (
	GardenID int NOT NULL AUTO_INCREMENT,
    GardenName varchar(255),
    GardenLocation varchar(255),
    Latitude float(24),
    Longitude float(24),
    ContactPerson varchar(255),
	MarkerLabel varchar(255),
	Status int,
	  PRIMARY KEY(GardenID)
);

INSERT INTO GardenLocations(GardenID, GardenName, GardenLocation, Latitude, Longitude, ContactPerson, MarkerLabel, Status)
VALUES
(1,"NCAR","Boulder,CO",39.977804,-105.275076,"Danica Lombardoz)zi", "NCAR",1),
(2,"Virginia Living Museum","Newport News, VA",37.06994,-76.479491,"Nicole Burns and Emily Hoffman", "Virginia_Living_Museum",1),
(3,"UCCS","Colorado Springs, CO",38.892251,-104.799477,"Kevin Gilford", "UCCS",1),
(4,"South Dakota Discovery Center","Pierre, SD",44.371886,-100.363439,"Rhea Waldman", "South_Dakota_Discovery_Center",1),
(5,"Children's Museum of New Hampshire","Dover, NH",43.194811,-70.873172,"Xanti Gray and Coli Haahr", "Childrens_Museum_of_New_Hampshire",1),
(6,"Appalachian Highlands Science Learning Center","Great Smokies National Park, NC",35.586098,-83.073584,"Susan Sacks", "Appalachian_Highlands_Science_Learning_Center",1),
(7,"Denver University","Denver, CO",39.676882,-104.962454,"Erica Larson", "Denver_University",1),
(8,"Phipps Botanical Garden","Pittsburgh, PA",40.439777,-79.947304,"Sarah States", "Phipps_Botanical_Garden",1),
(9,"Spelman College","PAtlanta, GA",33.745511,-84.410212,"Guanyu Huang", "Spelman_College",1),
(10,"Harris-Stowe State University","St. Louis, MO",38.631823,-90.224007,"Nichole Gosselin", "HarrisStowe_State_University",1),
(11,"Framingham State University/Challenger Center","Framingham, MA",42.2984,-71.435894,"Bryan Connolly","Framingham_State_University",1),
(12,"University of Norway - Oslo","Oslo, Norway",59.939835,10.722908,"Ane Vosages", "University_of_Norway",1),
(13,"University of Sheffield","Sheffield, UK",53.381952,-1.490372,"Maria Val Martin", "University_of_Sheffield",1);

MySQL Notes;

UserEntries has primary key entryID. Table is used for storing data entered.

Plants has primary key plantID. Tables is used to keep track of plants details such as their first time they get leaves, where it's located (not updated for locationID), and what plant type it is. Each entry has a unique type and location combination. Perl code auto creates new plants for any new combo.

UserTable has primary key UserID, also can contain encrypted passwords and salts compatible with perl code. Was not implimented in perl to create a new location for each user if they desire.

GardenLocation has primary key GardenID. Is used to draw the leafs on the user interactable map. 


Notes:

Any page using the database needs the database information updated

database line number for files
ozone_login.pl 		- line 63
data_visual.pl 		- line 17
ozone_register.pl 	- line 178
data_add.pl 		- line 37 and 174
index.pl 			- line 27