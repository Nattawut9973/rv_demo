#!/usr/bin/perl
use lib qw(/usr/local/rv_demo_acct_manage);
use lib::Cpacct;
use strict;
my $command = defined($ARGV[0]) ? $ARGV[0] : '';
my $user = defined($ARGV[1]) ? $ARGV[1] : '';

if($command eq ''){
        print "Missing argument command\n";
        exit;
}
elsif(($command eq 'regisaccount' || $command eq 'unregisaccount') && $user eq ''){
        print "Missing argument user after $command\n";
        exit;      
}
elsif($#ARGV > 1){
        print "No command specified\n";
        exit;
}
elsif($command eq 'listaccount'){
        Cpacct::listaccount();
}
elsif($command eq 'regisaccount'){
	Cpacct::regisaccount($user);
}
elsif($command eq 'restoreaccount'){     
        Cpacct::restoreaccount($user);      
}
elsif($command eq 'unregisaccount'){
        Cpacct::unregisaccount($user);
}
else{
        print "Command is invalid";
}