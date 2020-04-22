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


# set some rando vars
my $after = 'none';


# cgi vars
my $cgi = CGI->new;

# tt vars
my %tt_options = (INCLUDE_PATH => 'tmps', ABSOLUTE => 1, EVAL_PERL => 1);
my $tt = Template->new(\%tt_options);
my $tt_vars;


@rows = $sth->fetchrow_array();

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
	$tt_vars->{'msg'} = "Login User";
	$tt_vars->{'email'} = $cgi->param('email');

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
	my $tt_template = 'login.htm';

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