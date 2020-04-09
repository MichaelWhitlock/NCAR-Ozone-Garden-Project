#!/usr/bin/perl -T

# bring em in
use strict;
use warnings;
use Template;
use Time::Piece;
use CGI qw(:standard);
use CGI::Session qw/-ip-match/;
use DBI;
use Text::CSV;

# uncomment line below to send debug messages to the browser, comment back when ready for production
use CGI::Carp qw( warningsToBrowser fatalsToBrowser );


#Database connection
#my $user = "admin";
#my $auth = "greenteam";
#my $dsn = "DBI:mysql:database=TannerTester;host=greenteam.cfl3ojixyyg2.us-west-1.rds.amazonaws.com;port=3306";
#my $dbh = DBI->connect($dsn,$user,$auth);
#my $sth = $dbh->prepare("SELECT * FROM Plants;");
#eval {$dbh->do("DROP TABLE foo")};


# time vars
my $now = localtime;
my $time_email = $now->strftime('%A, %B %d, %G at %I:%M%p');
my $date_current = $now->strftime('%Y-%m-%d');
my $year_current = $now->strftime('%Y');
my $time_current = $now->strftime('%R');
my $time_file = $now->strftime('%Y%m%d%H%M%S');

# set the more vars
my $email_ryanj = 'ryanj@ucar.edu';

#Database connection for map markers -Hunter
my $data_source = "DBI:mysql:greenteam.cfl3ojixyyg2.us-west-1.rds.amazonaws.com:greenteam.cfl3ojixyyg2.us-west-1.rds.amazonaws.com:database=TannerTester";
my $username = "admin";
my $auth = "greenteam";
my $dbh = DBI->connect($data_source, $username, $auth,
          {RaiseError => 1} );
my $sth = $dbh->prepare("SELECT Latitude,Longitude,MarkerLabel,GardenName FROM GardenLocations");
$sth -> execute();

#using db info to create map markers with popups
my $locations = "<script type='text/javascript'>";
my $locationsSelect = ".";
while (my @row = $sth->fetchrow_array()){
    #add the map marker
    $locations = $locations . "var " . $row[2] . " = L.marker([". $row[0] . ", " . $row[1] . "],{icon: greenIcon}).addTo(mymap);";
    #add name variable so we can pass it to our selectLocation function when button is clicked
    $locations = $locations . "var $row[2]" . "nameVar = \'$row[2]\';"; 
    #add the popup for the marker
    $locations = $locations . $row[2] . ".bindPopup(\"<form onSubmit=\'selectLocation($row[2]" . "nameVar" . "); return false\';><input type='submit' name='MapButton' value='$row[3]' /></form>\");";
    #set options for garden location select to be the same as map markers
    $locationsSelect = $locationsSelect . "<option value=\"" . $row[2] . "\">" . $row[3] . "</option>";
}
$locations = $locations . "</script>";


# cgi vars
my $cgi = CGI->new;

# tt vars
my %tt_options = (INCLUDE_PATH => 'tmps', ABSOLUTE => 1, EVAL_PERL => 1);
my $tt = Template->new(\%tt_options);

my $tt_vars;
my $tt_vars1;


#variables for form
my @leaves;
my @leaves = ('leaf1','leaf2','leaf3','leaf4','leaf5','leaf6','leaf7','leaf8','leaf9','leaf10');



#Holders for the for look inside the submit button
my $counter = 0;
my $holder;

#Case counters
my $Leaf0sCounter = 0;
my $Leaf1sCounter = 0;
my $Leaf2sCounter = 0;
my $Leaf3sCounter = 0;
my $Leaf4sCounter = 0;
my $Leaf5sCounter = 0;
my $Leaf6sCounter = 0;

#Form variables being pulled
my $date_recorder = param('date-today');
my $leaf1 = param('leaf1');
my $location = param('garden-location');
my $plantType = param('plant-type');

#variable for substring
my $char;

#Database variables
my $insertLineUserEntriesTable;
my $insertIntoPLantTable;

my $tt_vars = {
        mapMarkers => $locations,
        locationsSelect => $locationsSelect,
};


# checking for a form submission
if ($cgi->param('submit')) {
#For each leaf that is in the carasal it grabs the variable with it and merges it into a string
    foreach my $curLeaf (@leaves){
        $holder = param($curLeaf);
        $counter = "$counter"."$holder";
    }
    
    #For each char in the string just get it right now
    for my $i (0..length($counter)-1){
        $char = substr($counter, $i, 1);

        #cascading cases of the carasal 
        #0=no data, 1 = 0% damage, 2 = 1_6% damage, 3 = 7-25
        #4 = 25-50, 5 = 51-75, 6 = 76-100
        if($char == 0){
            $Leaf0sCounter = $Leaf0sCounter + 1;
        }elsif($char == 1){
            $Leaf1sCounter = $Leaf1sCounter + 1;
        }elsif($char == 2){
            $Leaf2sCounter = $Leaf2sCounter + 1;
        }elsif($char == 3){
            $Leaf3sCounter = $Leaf3sCounter + 1;
        }elsif($char == 4){
            $Leaf4sCounter = $Leaf4sCounter + 1;
        }elsif($char == 5){
            $Leaf5sCounter = $Leaf5sCounter + 1;
        }elsif($char == 6){
            $Leaf6sCounter = $Leaf6sCounter + 1;
        }

    }

    #Gets the amount of leaves used
    $Leaf0sCounter = 10-$Leaf0sCounter + 1;
    

    #DB connection
    my $user = "admin";
    my $auth = "greenteam";
    my $dsn = "DBI:mysql:database=TannerTester;host=greenteam.cfl3ojixyyg2.us-west-1.rds.amazonaws.com;port=3306";
    my $dbh = DBI->connect($dsn,$user,$auth);


    

    #Statement that pulls/gives to the database
    my $sth = $dbh->prepare("SELECT count(plantID), plantID FROM Plants WHERE location = '$location' AND plantType = '$plantType';");
    $sth->execute();
    my @row = $sth->fetchrow_array();
        
    #Variables for the ifstatement/plantid
    my $plantCount = $row[0];
    my $plantID;

    
    #Sets plant id to the row, if row is empty plantID is nothing
    $plantID = $row[1];

    #If the select statement did not find a plant w/ location and type, then make a new entry in the table.
    if($plantCount == 0){
        #Insert into the plant table a new one w/ plantType and location of entered data and current date_current(this assumes the first time it is entered is the date of emergence)
        $insertIntoPLantTable = "INSERT INTO Plants(location, plantType, dateOfEmergence) VALUES ('$location','$plantType',CURDATE());";
        eval {$dbh->do($insertIntoPLantTable)};
        $sth = $dbh->prepare("SELECT plantID FROM Plants WHERE location = '$location' AND plantType = '$plantType';");
        $sth->execute();
        @row = $sth->fetchrow_array();
        $plantID = $row[0];
    }

    #Get date difference from current date and dateOfEmergence
    $sth = $dbh->prepare("SELECT DATEDIFF(CURDATE(),dateOfEmergence) FROM Plants WHERE plantID = $plantID;");
    $sth->execute();
    @row = $sth->fetchrow_array();
    my $dateDifference = $row[0];

    
    $insertLineUserEntriesTable = "INSERT INTO UserEntries(curDate, curYear, plantID, userID, daysSinceEmergence, NLeaves, 0_damage, 1_6_damage, 7_25_damage, 26_50_damage, 51_75_damage, 76_100_damage)VALUES("."CURDATE()". ", "."CURDATE()". ", "."$plantID".", ". "0".", ". "$dateDifference".", ". "$Leaf0sCounter".", ". "$Leaf1sCounter".", ". "$Leaf2sCounter".", ". "$Leaf3sCounter".", ". "$Leaf4sCounter".", ". "$Leaf5sCounter".", ". "$Leaf6sCounter".");";

    eval {$dbh->do($insertLineUserEntriesTable)};
    
    #Output variable of the submit button
    $tt_vars->{'msg_err'} = "Data Submitted!";
    
    # get form submission variables
    my $leaf1 = $cgi->param('leaf1');
    my $leaf2 = $cgi->param('leaf2');
    my $leaf3 = $cgi->param('leaf3');
    my $leaf4 = $cgi->param('leaf4');
    my $leaf5 = $cgi->param('leaf5');
    my $leaf6 = $cgi->param('leaf6');
    my $leaf7 = $cgi->param('leaf7');
    my $leaf8 = $cgi->param('leaf8');
    my $leaf9 = $cgi->param('leaf9');
    my $leaf10 = $cgi->param('leaf10');

    my $date = $cgi->param('date-today');
    my $location = $cgi->param('garden-location');
    my $plant = $cgi->param('plant-type');

    # dev message
    $tt_vars->{'msg_err'} = "Worksheet Submitted";
}


# set the template to use
my $tt_template = 'data_add.htm';

# starting stuff
$| = 1;
print "Content-type: text/html\n\n";


# process the template
$tt->process($tt_template, $tt_vars) || die $tt->error();
exit;



# Send a plain-text, UTF-8 email to the specified recipients, taken from account_request.cgi
sub send_email
{
    my ($subject, $content, $from, @recipients) = @_;

    my $cmd = '/usr/sbin/sendmail';
    my @args = qw(-t); # Specify recipients in To: header, not command line

    open my $fh, '|-:utf8', $cmd, @args or die "Failed to start '$cmd' with args @args";

    # Generate SMTP headers for message
    my $headers;
    {
        local $" = ', ';

        $headers =<<MAIL_HEADERS;
            From: $from
            To: @recipients
            Content-type: text/html; charset=utf-8
            Subject: $subject

MAIL_HEADERS
    }

    $headers =~ s/^\s+//gm;
    say $fh $headers;
    say $fh $content;

    close $fh;

    die "'$cmd' killed by signal" . ($? & 127) if $? & 127;
    die "'$cmd' exited with error" . ($? >> 8) if $? >> 8;
}