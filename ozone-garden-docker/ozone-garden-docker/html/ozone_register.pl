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
use Data::Entropy::Algorithms qw(rand_bits);
use Digest;

# uncomment line below to send debug messages to the browser, comment back when ready for production
use CGI::Carp qw( warningsToBrowser fatalsToBrowser );

# set the time vars
my $now = localtime;
my $time_email = $now->strftime('%A, %B %d, %G at %I:%M%p'); 
my $date_current = $now->strftime('%Y.%m.%d'); 
my $time_current = $now->strftime('%R'); 
my $time_file = $now->strftime('%Y%m%d%H%M%S');


# set the default after var
my $after = 'none';


# cgi vars
my $cgi = CGI->new;

# tt vars
my %tt_options = (INCLUDE_PATH => 'tmps', ABSOLUTE => 1, EVAL_PERL => 1);
my $tt = Template->new(\%tt_options);
my $tt_vars;



# check for an after variable to be set
if (defined $cgi->param('after')) {
	# check if the after var contains good chars
	if ( $cgi->param('after') =~ /^([-\/\w]+)$/ ) {
		# good chars so set after
		$after = $1;
	}
}

# push into the vars to return
$tt_vars->{'after'} = $after;


# check if the user submitted a register form
if ( defined $cgi->param('formUser') && $cgi->param('formUser') eq 'register') {
	# initalize the vars
	my $name;
	my $email;
	my $institution;
	my $password;
	my $password2;

	# set them to return
	$tt_vars->{'name'} = $cgi->param('register_name');
	$tt_vars->{'email'} = $cgi->param('register_email');
	$tt_vars->{'institution'} = $cgi->param('register_institution');



	# untaint the vars by matching against a regex of allowed characters
	# check the name parameter

	if ( $cgi->param('name') =~ /(^[a-zA-Z0-9\s]+$)/) {
		# data is good so set it
		$name = $1;

		# add to tt_vars to be returned
		$tt_vars->{'name'} = $name;
	}
	else {
		# add error msg
		$tt_vars->{'msg_err'} = "Error with name field, please try again";

		# data is bad so end
		&showForm();
	}
	# check the email parameter
	if ( $cgi->param('email') =~ /(^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$)/) {
		# data is good so set it
		$email = lc($1);

		# add to tt_vars to be returned
		$tt_vars->{'email'} = $email;
	}
	else {
		# add error msg
		$tt_vars->{'msg_err'} = "Invalid email address";

		# data is bad so end
		&showForm();
	}
	# check the institution parameter
	if ( $cgi->param('institution') =~ /(^[a-zA-Z0-9\s]+$)/) {
		# data is good so set it
		$institution = $1;

		# add to tt_vars to be returned
		$tt_vars->{'institution'} = $institution;
	}
	else {
		# add error msg
		$tt_vars->{'msg_err'} = "Error with institution field, please try again";

		# data is bad so end
		&showForm();
	}

	# check the password parameter
	if ( $cgi->param('password') =~ /(.+)/) {
		# data is good so set it
		$password = $1;
		
	}

	else {
		# data is bad so end
		&showForm();
	}
	# check the password2 parameter
	if ( $cgi->param('password2') =~ /(.+)/) {
		# data is good so set it
		$password2 = $1;
	}
	else {
		# data is bad so end
		&showForm();
	}



	# compare the passwords
	if ( "$password" ne "$password2" ) {
		# passwords dont match so return with error
		$tt_vars->{'msg_err'} = "Passwords do not match, please try again";

		# data is bad so end
		&showForm();
	}


#Location 
	#=1600+Amphitheatre+Parkway,+Mountain+View,+CA
	#StreetAddreess+,City,STATE
	#Replace all spaces with +
	
	# my $streetAddreess = $cgi->param('street');
	# my $cityState = $cgi->param('cityState');
	# my $fullAddress = $streetAddreess . ',' . $cityState;
	
	#Replace all spaces with +
	# $fullAddress =~ tr/''/+;

	#  my $geocodeapi = "https://maps.googleapis.com/maps/api/geocode/";

	#   my $url = $geocodeapi . $format . "?sensor=false&address=" . $address;

	#   my $json = get($url);

	#   my $d_json = decode_json( $json );

	#   my $lat = $d_json->{results}->[0]->{geometry}->{location}->{lat};
	#   my $lng = $d_json->{results}->[0]->{geometry}->{location}->{lng};

	# Psuedo code check for valid address
	# if lat && lng are error or invalid tt_Vars ="Invalid address"



	#Database connection for inserting into usertable
	my $data_source = "DBI:mysql:greenteam.cfl3ojixyyg2.us-west-1.rds.amazonaws.com:greenteam.cfl3ojixyyg2.us-west-1.rds.amazonaws.com:database=TannerTester";
	my $username = "admin";
	my $auth = "greenteam";
	my $dbh = DBI->connect($data_source, $username, $auth,
	          {RaiseError => 1} );
	my $sth = $dbh->prepare("SELECT count(email) FROM UserTable WHERE email='$email';");
	$sth -> execute();
	my @row = $sth->fetchrow_array();
	my $testEmail = $row[0];

	# check to make sure that the email doesn't exist
	if($testEmail == 0){
		# make a salt
		my $bs = rand_bits(16*8);
		my $salt = "". $bs;
		my $bcrypt = Digest->new('Bcrypt', cost => 12, salt => $salt);
		$bcrypt->add($password);
		my $digest = $bcrypt->digest;

		#Insert new user into UserTable -- dummy value for locationid right now
        my $insertIntoUserTable = "INSERT INTO UserTable(email, name, institution, password, salt, locationID) VALUES ('$email', '$name','$institution', '$digest', '$salt', 24);";
        eval {$dbh->do($insertIntoUserTable)};
        $sth = $dbh->prepare("SELECT userID FROM UserTable WHERE email='$email';");
        $sth->execute();
        @row = $sth->fetchrow_array();
        my $uid = $row[0];
    	$tt_vars->{'msg_err'} = "Garden manager user created. Awaiting location approval.";

		&showForm();
	}
	else {
		$tt_vars->{'msg_err'} = "Email is already in use";

		# data is bad so end
		&showForm();
	}

}
# no form submit so show register page
else {
	# call the sub to show the form
	&showForm();
}




# sub to show the form
sub showForm {
	# set the template to use
	my $tt_template = 'ozone_register.htm';

	# starting stuff
	$| = 1;
	print "Content-type: text/html\n\n";

	# debugging to display submitted form values in browser
	# uncomment the lines below
	#my @param_names = $cgi->param();
	#foreach my $p (@param_names) {
	#	my $value = $cgi->param($p);
	#	print "Param $p = $value<br>";
	#}

	# process the template
	$tt->process($tt_template, $tt_vars) || die $tt->error();
	exit;
}


# sub to encrypt the password
sub encryptPassword {
	# set the variables
	my ($pass) = @_;
	my ($salt) = "0xCGD";

	# encrypt and return the pass
	return crypt($pass, $salt);
}


