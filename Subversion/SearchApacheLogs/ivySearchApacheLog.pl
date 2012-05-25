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
# REQUIREMENTS:  ./parseApacheLog.pl <svn repo> <date in dd/Mon/yyyy format> <path to access log file>
#         BUGS:  ---
#        NOTES:  The ncisvn apache access log files are in NCSA extended/combined log format
#                See http://httpd.apache.org/docs/2.2/mod/mod_log_config.html#logformat for more info
#       AUTHOR:  Jim McMahon (mcmahonj@mail.nih.gov),
#      COMPANY:  TerpSys
#      VERSION:  1.0
#      CREATED:  01/24/2012 04:53:09 PM
#     REVISION:  ---
#===============================================================================
#############################################################################
# sample usage: ./parseApacheLog.pl automation '24/Jan/2012' access-ssl.log #
#############################################################################


use strict;
use warnings;

use Apache::LogRegex;

#my $svn_repo = shift(@ARGV); # 1st argument should be svn repo name or search argument (e.g., automation)
#my $date = shift(@ARGV); # 2nd argument should be date to search in dd/Mon/yyyy

################################################################################################################
# %h = remote host                                                                                             #
# %l = remote logname (from identd, if supplied, otherwise -                                                   #
# %u = remote user (from auth; may be bogus if return status %s is 401)                                        #
# %t = time the request was received (standard english format)                                                 #
# %r = first line of request                                                                                   #
# %>s = status (e.g., 200 for OK)                                                                              #
# %b = size of response in bytes, excluding HTTP headers. In CLF (Common Logging Format), so '-' means 0 bytes #
# %{Referer}i = contents of Referer                                                                            #
# %{User-agent}i = User agent                                                                                  #
################################################################################################################
my $log_format = '%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"';

my $lr;

eval { $lr = Apache::LogRegex->new($log_format) };
die "Unable to parse log line: $@" if ($@);

my %data;

while ( my $line_from_logfile = <> ) {
    eval { %data = $lr->parse($line_from_logfile); };
    if (%data) {

        # We have data to process. ignore requests from WebSVN, which will also exclude Googlebot
        if ( $data{'%{User-Agent}i'} =~ "Apache Ivy")
		{
			print "\nhost: $data{'%h'}\n";
			print "date and time: $data{'%t'}\n";
			print "user agent: $data{'%{User-Agent}i'}\n";
			print "first line of request: $data{'%r'}\n";
        }
    }
}

