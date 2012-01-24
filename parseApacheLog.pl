#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  parseApacheLog.pl
#
#        USAGE:  ./parseApacheLog.pl
#
#  DESCRIPTION:  Parses the Apache log file looking for access to a particular repository
#
#
#      OPTIONS:  ---
# REQUIREMENTS:  ./parseApacheLog.pl <path to access log file>
#         BUGS:  ---
#        NOTES:  The ncisvn apache access log files are in NCSA extended/combined log format
#                See http://httpd.apache.org/docs/2.2/mod/mod_log_config.html#logformat for more info
#       AUTHOR:  Jim McMahon (mcmahonj@mail.nih.gov),
#      COMPANY:  TerpSys
#      VERSION:  1.0
#      CREATED:  01/24/2012 04:53:09 PM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use Apache::LogRegex;

The 

my $log_format = '%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"';

my $lr;

eval { $lr = Apache::LogRegex->new($log_format) };
die "Unable to parse log line: $@" if ($@);

my %data;

while ( my $line_from_logfile = <> ) {
    eval { %data = $lr->parse($line_from_logfile); };
    if (%data) {

        # We have data to process
		print $data{'%r'} . "\n";
    }
    else {

        # we could not parse this line
		print "no good\n";
    }
}

