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

use Digest;
use CGI::Carp qw( warningsToBrowser fatalsToBrowser );


# set the time vars
my $now = localtime;
my $time_email = $now->strftime('%A, %B %d, %G at %I:%M%p'); 
my $date_current = $now->strftime('%Y.%m.%d'); 
my $time_current = $now->strftime('%R'); 
my $time_file = $now->strftime('%Y%m%d%H%M%S');


# set some rando vars
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

# set it to return
$tt_vars->{'after'} = $after;


# check which kind of user form was sent - login or register
# if user is loging in
if ( defined $cgi->param('formUser') && $cgi->param('formUser') eq 'login') {
	# TODO validate user
	# push into the vars to return
	#
	my $email = param('email');
	my $password = param('password');


	my $data_source = "DBI:mysql:greenteam.cfl3ojixyyg2.us-west-1.rds.amazonaws.com:greenteam.cfl3ojixyyg2.us-west-1.rds.amazonaws.com:database=TannerTester";
	my $username = "admin";
	my $auth = "greenteam";
	my $dbh = DBI->connect($data_source, $username, $auth,
	          {RaiseError => 1} );
	my $sth = $dbh->prepare("SELECT count(email), salt FROM UserTable WHERE email='$email';");
	$sth -> execute();
	my @row = $sth->fetchrow_array();
	my $testEmail = $row[0];

	if($testEmail == 0){
		$tt_vars->{'msg'} = "Email doesn't exist. Register now if you are a garden manager.";
		&showForm();
	}else{
		my $salt = $row[1];#Here
		my $bcrypt = Digest->new('Bcrypt', cost => 12, salt => $salt);
		$bcrypt->add($password);
		my $digest = $bcrypt->digest;

		my $sth = $dbh->prepare("SELECT count(UserID), UserID, name FROM UserTable WHERE email='$email' AND password='$digest';");
		$sth -> execute();
		my @row = $sth->fetchrow_array();

		my $passwordValidation = $row[0];

		#Password validation
		if($passwordValidation == 0){
			$tt_vars->{'msg'} = "This password not associated with username.";
			&showForm();
		}
		else{#Database grabbing the userID
			my $userID = $row[1];
			my $name = $row[2];
			$tt_vars->{'msg'} = "Hello ". $name;

			my $userID_cookie = cookie( -NAME    => 'entry_cookie',
	                    -VALUE   => $userID,
	                    -EXPIRES => '+100m');    # M for month, m for minute

			my $data_entry_url = "http://localhost/data_add.pl";

			print redirect( -URL     => $data_entry_url,
	                        -COOKIE  => $userID_cookie);
		}
			
		&showForm();
	}


	$tt_vars->{'msg'} = "";

	&showForm();

}
# no other type of login so display login page
else {
	# show the form
	&showForm();
}





# sub to show the form
sub showForm {
	# set the template to use
	my $tt_template = 'ozone_login.htm';

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