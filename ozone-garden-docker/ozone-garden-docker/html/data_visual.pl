#!/usr/bin/perl -T

# bring em in
use strict;
use warnings;
use Template;
use Time::Piece;
use CGI qw(:standard);
use CGI::Session qw/-ip-match/;
use DBI;
#use Text::CSV;
use Text::CSV qw( csv );

# uncomment line below to send debug messages to the browser, comment back when ready for production
use CGI::Carp qw( warningsToBrowser fatalsToBrowser );

#database connection -Hunter
my $data_source = "DBI:mysql:greenteam.cfl3ojixyyg2.us-west-1.rds.amazonaws.com:greenteam.cfl3ojixyyg2.us-west-1.rds.amazonaws.com:database=TannerTester";
my $username = "admin";
my $auth = "greenteam";
my $dbh = DBI->connect($data_source, $username, $auth,
          {RaiseError => 1} );

# time vars
my $now = localtime;
my $time_email = $now->strftime('%A, %B %d, %G at %I:%M%p'); 
my $date_current = $now->strftime('%Y.%m.%d'); 
my $time_current = $now->strftime('%R'); 
my $time_file = $now->strftime('%Y%m%d%H%M%S');

# set the more vars
my $email_ryanj = 'ryanj@ucar.edu';



# cgi vars
my $cgi = CGI->new;
my $selectedLoc;
my $selectedPlant = $cgi->param('plant-type');
my $selectedYear = $cgi->param('year-select');
my $graphType = $cgi->param('graph-type');
$selectedLoc = $cgi->param('MapButton');

#default mapButton to NCAR unless there is a cookie passed from data add
my $data_cookie = $cgi->cookie('entry_cookie');

#If-else to see if the user inputted data then went to data visualization. This is so that they see data relevant to them
if($selectedLoc eq ""){
  if ($data_cookie eq ""){
    $selectedLoc = "NCAR";
  }
  else{
    my $sth = $dbh->prepare("SELECT location FROM Plants WHERE plantID = $data_cookie;");
    $sth->execute();
    my @row = $sth->fetchrow_array();
    $selectedLoc = $row[0];
    my $datavis_cookie = cookie( -NAME    => 'entry_cookie',
                  -VALUE   => "",
                  -EXPIRES => '+1m');
    


  }
}
#default plant to coneflower
if ($selectedPlant eq ""){
  $selectedPlant = "coneflower";
}
#default year to 2020
if ($selectedYear eq ""){
  $selectedYear = "2020";
}
if ($selectedYear eq "select-year"){
  $selectedYear = "2020";
}
#default graphType to single
if ($graphType eq ""){
  $graphType = "single"
}


my $locationsSelect = ".";
#This code is stolen from main page map, it uses info from database to fill in garden location markers for the map
my $sth = $dbh->prepare("SELECT Latitude,Longitude,MarkerLabel,GardenName FROM GardenLocations WHERE Status = 1");
$sth -> execute();
#using db info to create map markers with popups
my $locations = "<script type='text/javascript'>";
while (my @row = $sth->fetchrow_array()){
    #add the map marker
    $locations = $locations . "var " . $row[2] . " = L.marker([". $row[0] . ", " . $row[1] . "],{icon: greenIcon}).addTo(mymap);";
    #add the popup for the marker
    $locations = $locations . $row[2] . ".bindPopup(\"<form action='data_visual.pl' method='post'><input type='submit' name='MapButton' value='$row[3]' /></form>\");";
    #set options for garden location select to be the same as map markers
    $locationsSelect = $locationsSelect . "<option value=\"" . $row[2] . "\">" . $row[3] . "</option>";
}
$locations = $locations . "</script>";

#This code just pulls the actual garden name from database based on the markerlabel that we got from map post
my $sqlString = "SELECT MarkerLabel FROM GardenLocations WHERE GardenName='$selectedLoc';";
my $sth = $dbh->prepare($sqlString);
$sth -> execute();
my $selectedLocMarker = "";
while (my @row = $sth->fetchrow_array()){
    $selectedLocMarker = $row[0];
}

#Use sql to fill in only the options that we have data for - Year Options
my $sqlString = "SELECT DISTINCT curYear from Plants
                INNER JOIN UserEntries ON Plants.plantID = UserEntries.plantID
                WHERE location='$selectedLocMarker';";
my $sth = $dbh->prepare($sqlString);
$sth -> execute();
my $fillDate = "";
#fill in date options
while (my @row = $sth->fetchrow_array()){
    $fillDate = $fillDate . "<option id='$row[0]' value='$row[0]'>$row[0]</option>";
}
#Use sql to fill in only the options that we have data for - Plant Options
$sqlString = "SELECT DISTINCT plantType from Plants
                INNER JOIN UserEntries ON Plants.plantID = UserEntries.plantID
                WHERE location='$selectedLocMarker';";
$sth = $dbh->prepare($sqlString);
$sth -> execute();
my $fillPlants = "";

while (my @row = $sth->fetchrow_array()){
    $fillPlants = $fillPlants . "<option id='$row[0]' value='$row[0]'>$row[0]</option>";
}

#since there are 5 options for amount of damage on a leaf we need 5 variables to store traces for the bar graph, bardates and bardates1 set the range for x axis
  my $barDates = "";
  my $barDates1 = "";
  my $barValues0 = "";
  my $barValues1 = "";
  my $barValues2 = "";
  my $barValues3 = "";
  my $barValues4 = "";
  my $barValues5 = "";
  my $graphVariables = "";
  my $graphTitle = "";

#make variables for bar graph if graphType is single
if($graphType eq "single"){
  #For the bar graphs there is 6 seperate variables, each one represents a section of the leaf damage, ex: 0 Damage
  $sqlString = "SELECT curDate, NLeaves, 0_damage, 1_6_damage, 7_25_damage, 26_50_damage, 51_75_damage, 76_100_damage from Plants
                INNER JOIN UserEntries ON Plants.plantID = UserEntries.plantID
                WHERE location='$selectedLocMarker' AND plantType='$selectedPlant' AND curYear='$selectedYear';";
  $sth = $dbh->prepare($sqlString);
  $sth -> execute();

  my $lastDate = '';

  while (my @row = $sth->fetchrow_array()){
      if ($lastDate ne $row[0]) {
        $barDates = $barDates . "'$row[0]'" . ",";
        $barValues0 = $barValues0 . $row[2]/$row[1] . ",";
        $barValues1 = $barValues1 . $row[3]/$row[1] . ",";
        $barValues2 = $barValues2 . $row[4]/$row[1] . ",";
        $barValues3 = $barValues3 . $row[5]/$row[1] . ",";
        $barValues4 = $barValues4 . $row[6]/$row[1] . ",";
        $barValues5 = $barValues5 . $row[7]/$row[1] . ",";
      }
      $lastDate = $row[0];
  }
  #Adjust formatting to fit JS variable style
  $barValues0 = "var line0 = {
    x: [$barDates],
    y: [$barValues0],
    name: '0%',
    type: 'bar'
  };";
  $barValues1 = "var line1 = {
    x: [$barDates],
    y: [$barValues1],
    name: '1-6%',
    type: 'bar'
  };";
  $barValues2 = "var line2 = {
    x: [$barDates],
    y: [$barValues2],
    name: '7-25%',
    type: 'bar'
  };";
  $barValues3 = "var line3 = {
    x: [$barDates],
    y: [$barValues3],
    name: '26-50%',
    type: 'bar'
  };";
  $barValues4 = "var line4 = {
    x: [$barDates],
    y: [$barValues4],
    name: '51-75%',
    type: 'bar'
  };";
  $barValues5 = "var line5 = {
    x: [$barDates],
    y: [$barValues5],
    name: '76-100%',
    type: 'bar'
  };";
 $graphVariables = "<script> $barValues0 $barValues1 $barValues2 $barValues3 $barValues4 $barValues5 
                    var dataBar = [line0,line1,line2,line3,line4,line5];</script>";
#formatting for the title and axis for bar graph, passed through tt  vars as with script tags
 $graphTitle = "<script> var layoutBar = {barmode: 'stack', title: '$selectedLoc: $selectedPlant $selectedYear',
                                      xaxis: {
                                            title: 'Day Of Year',
                                            titlefont: {
                                            family: 'Arial, sans-serif',
                                            size: 18,
                                            color: 'grey'
                                          },},
                                       yaxis: {
                                            title: 'Proportion Of Injured Leaves',
                                            titlefont: {
                                            family: 'Arial, sans-serif',
                                            size: 18,
                                            color: 'grey'
                                          },
                                          }}; </script>";

#the next three else if statements check for which comparison choice was selected and build graph variables accordingly
#If compare plants
}elsif($cgi->param('comparison-choice') eq "compare-plants"){
  my $selectedPlant1 = $cgi->param('comparison-plant1');
  my $selectedPlant2 = $cgi->param('comparison-plant2');
  $sqlString = "SELECT  curDate, NLeaves, 0_damage, 1_6_damage, 7_25_damage, 26_50_damage, 51_75_damage, 76_100_damage from Plants
                INNER JOIN UserEntries ON Plants.plantID = UserEntries.plantID
                WHERE location='$selectedLocMarker' AND plantType='$selectedPlant1' AND curYear='$selectedYear';";
  $sth = $dbh->prepare($sqlString);
  $sth -> execute();

  my $lastDate = '';

  while (my @row = $sth->fetchrow_array()){
      if ($lastDate ne $row[0]) {
        $barDates = $barDates . "'$row[0]'" . ",";
        $barValues0 = $barValues0 . "1-$row[2]/$row[1]" . ",";
      }
      $lastDate = $row[0];
  }

  $sqlString = "SELECT  curDate, NLeaves, 0_damage, 1_6_damage, 7_25_damage, 26_50_damage, 51_75_damage, 76_100_damage from Plants
                INNER JOIN UserEntries ON Plants.plantID = UserEntries.plantID
                WHERE location='$selectedLocMarker' AND plantType='$selectedPlant2' AND curYear='$selectedYear';";
  $sth = $dbh->prepare($sqlString);
  $sth -> execute();

  $lastDate = '';

  while (my @row = $sth->fetchrow_array()){
      if ($lastDate ne $row[0]) {
        $barDates1 = $barDates1 . "'$row[0]'" . ",";
        $barValues1 = $barValues1 . "1-$row[2]/$row[1]" . ",";
      }
      $lastDate = $row[0];
  }

  $barValues0 = "var line0 = {
    x: [$barDates],
    y: [$barValues0],
    name: '$selectedPlant1',
    type: 'scatter'
  };";
  $barValues1 = "var line1 = {
    x: [$barDates1],
    y: [$barValues1],
    name: '$selectedPlant2',
    type: 'scatter'
  };";

  $graphVariables = "<script> $barValues0 $barValues1 var dataBar = [line0,line1];</script>";
  $graphTitle = "<script> var layoutBar = {title: '$selectedLoc: Compare Plants $selectedYear',
                                      xaxis: {
                                            title: 'Day Of Year',
                                            titlefont: {
                                            family: 'Arial, sans-serif',
                                            size: 18,
                                            color: 'grey'
                                          },},
                                       yaxis: {
                                            title: 'Proportion Of Injured Leaves',
                                            titlefont: {
                                            family: 'Arial, sans-serif',
                                            size: 18,
                                            color: 'grey',
                                            range: [0,1]
                                          },
                                          }}; </script>";

#if compare locations
}elsif($cgi->param('comparison-choice') eq "compare-locations"){
  my $selectedLocation1 = $cgi->param('comparison-location1');
  my $selectedLocation2 = $cgi->param('comparison-location2');
  $sqlString = "SELECT  curDate, NLeaves, 0_damage, 1_6_damage, 7_25_damage, 26_50_damage, 51_75_damage, 76_100_damage from Plants
                INNER JOIN UserEntries ON Plants.plantID = UserEntries.plantID
                WHERE location='$selectedLocation1' AND curYear='$selectedYear';";
  $sth = $dbh->prepare($sqlString);
  $sth -> execute();

  my $lastDate = '';

  while (my @row = $sth->fetchrow_array()){
      if ($lastDate ne $row[0]) {
        $barDates = $barDates . "'$row[0]'" . ",";
        $barValues0 = $barValues0 . "1-$row[2]/$row[1]" . ",";
      }
      $lastDate = $row[0];
  }

  $sqlString = "SELECT  curDate, NLeaves, 0_damage, 1_6_damage, 7_25_damage, 26_50_damage, 51_75_damage, 76_100_damage from Plants
                INNER JOIN UserEntries ON Plants.plantID = UserEntries.plantID
                WHERE location='$selectedLocation2' AND curYear='$selectedYear';";
  $sth = $dbh->prepare($sqlString);
  $sth -> execute();

  $lastDate = '';

  while (my @row = $sth->fetchrow_array()){
      if ($lastDate ne $row[0]) {
        $barDates1 = $barDates1 . "'$row[0]'" . ",";
        $barValues1 = $barValues1 . "1-$row[2]/$row[1]" . ",";
      }
      $lastDate = $row[0];
  }

  $barValues0 = "var line0 = {
    x: [$barDates],
    y: [$barValues0],
    name: '$selectedLocation1',
    type: 'scatter'
  };";
  $barValues1 = "var line1 = {
    x: [$barDates1],
    y: [$barValues1],
    name: '$selectedLocation2',
    type: 'scatter'
  };";

  $graphVariables = "<script> $barValues0 $barValues1 var dataBar = [line0,line1];</script>";
  $graphTitle = "<script> var layoutBar = {title: 'Compare Locations $selectedYear',
                                      xaxis: {
                                            title: 'Day Of Year',
                                            titlefont: {
                                            family: 'Arial, sans-serif',
                                            size: 18,
                                            color: 'grey'
                                          },},
                                       yaxis: {
                                            title: 'Proportion Of Injured Leaves',
                                            titlefont: {
                                            family: 'Arial, sans-serif',
                                            size: 18,
                                            color: 'grey',
                                            range: [0,1]
                                          },
                                          }}; </script>";
#if compare years
}elsif($cgi->param('comparison-choice') eq "compare-years"){
  my $selectedYear1 = $cgi->param('comparison-year1');
  my $selectedYear2 = $cgi->param('comparison-year2');
  $sqlString = "SELECT  curDate, NLeaves, 0_damage, 1_6_damage, 7_25_damage, 26_50_damage, 51_75_damage, 76_100_damage from Plants
                INNER JOIN UserEntries ON Plants.plantID = UserEntries.plantID
                WHERE location='$selectedLocMarker' AND curYear='$selectedYear1';";
  $sth = $dbh->prepare($sqlString);
  $sth -> execute();

  my $lastDate = '';

  while (my @row = $sth->fetchrow_array()){
      if ($lastDate ne $row[0]) {
        $barDates = $barDates . "'$row[0]'" . ",";
        $barValues0 = $barValues0 . "1-$row[2]/$row[1]" . ",";
      }
      $lastDate = $row[0];
  }

  $sqlString = "SELECT  curDate, NLeaves, 0_damage, 1_6_damage, 7_25_damage, 26_50_damage, 51_75_damage, 76_100_damage from Plants
                INNER JOIN UserEntries ON Plants.plantID = UserEntries.plantID
                WHERE location='$selectedLocMarker' AND curYear='$selectedYear2';";
  $sth = $dbh->prepare($sqlString);
  $sth -> execute();

  $lastDate = '';

  while (my @row = $sth->fetchrow_array()){
      if ($lastDate ne $row[0]) {
        $barDates1 = $barDates1 . "'$row[0]'" . ",";
        $barValues1 = $barValues1 . "1-$row[2]/$row[1]" . ",";
      }
      $lastDate = $row[0];
  }

  $barValues0 = "var line0 = {
    x: [$barDates],
    y: [$barValues0],
    name: '$selectedYear1',
    type: 'scatter'
  };";
  $barValues1 = "var line1 = {
    x: [$barDates1],
    y: [$barValues1],
    name: '$selectedYear2',
    type: 'scatter'
  };";

  $graphVariables = "<script> $barValues0 $barValues1 var dataBar = [line0,line1];</script>";
  $graphTitle = "<script> var layoutBar = {title: '$selectedLoc: Compare Years',
                                      xaxis: {
                                            title: 'Day Of Year',
                                            titlefont: {
                                            family: 'Arial, sans-serif',
                                            size: 18,
                                            color: 'grey'
                                          },},
                                       yaxis: {
                                            title: 'Proportion Of Injured Leaves',
                                            titlefont: {
                                            family: 'Arial, sans-serif',
                                            size: 18,
                                            color: 'grey',
                                            range: [0,1]
                                          },
                                          }}; </script>";

}




# tt vars
my %tt_options = (INCLUDE_PATH => 'tmps', ABSOLUTE => 1, EVAL_PERL => 1);
my $tt = Template->new(\%tt_options);

my $tt_vars;
#Sending javascript variables using templating - Hunter
my $tt_vars = {
                barTitle => $graphTitle,
                fillPlants => $fillPlants,
                fillDate => $fillDate,
                keepLoc => '<input type="hidden" name="MapButton" value= "' . $selectedLoc . '"/>',
                tester2 => "",
                barVariables => $graphVariables,
                gardenLoc => $selectedLoc,
                mapMarkers => $locations,
                fillLoc => $locationsSelect,
             };

 my $tt_vars1;

# checking for a form submission
if ($cgi->param('submit')) {

	# dev message
	$tt_vars->{'msg_err'} = $data_cookie;
}

#Downlaod the data
if ($cgi->param('Download')) {

  # dev message
  my $sth = $dbh->prepare("SELECT * FROM UserEntries;");
  $sth->execute();

  my @rows = $sth->fetchrow_array();
  open my $fh, ">:encoding(utf8)", "new.csv" or die "new.csv: $!";
  my $csv->say ($fh, $_) for @rows;
  close $fh or die "new.csv: $!";
  $tt_vars->{'msg_err'} = $data_cookie;

}

# set the template to use
my $tt_template = 'data_visual.htm';

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