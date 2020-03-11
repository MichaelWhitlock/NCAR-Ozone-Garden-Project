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
	if ( $cgi->param('name') =~ /(^[a-zA-Z0-9]+$)/) {
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
		$tt_vars->{'msg_err'} = "Error with email field, please try again";

		# data is bad so end
		&showForm();
	}
	# check the institution parameter
	if ( $cgi->param('institution') =~ /(^[a-zA-Z0-9]+$)/) {
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
	if ( "$password" eq "$password2" ) {
		# passwords match so register user
		# encrypt the password
		my $encPassword = &encryptPassword($password);

		# TODO
		# check DB for email already in and insert new user
		$tt_vars->{'msg_err'} = "Register User";
		&showForm();
	}
	else {
		# passwords dont match so return with error
		$tt_vars->{'msg_err'} = "Passwords do not match, please try again";

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


