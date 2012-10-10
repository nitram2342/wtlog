#!/usr/bin/perl
#
# This is a simple worktime logging tool.
#
# Author: Martin Schobert <martin@mailbeschleuniger.de>
#
#
use strict;

#
# config
#

my $dir = $ENV{HOME} . '/.wtlog';
my $log_template = $dir . '/log_template.tex';

# more includes

use Data::Dumper;
use Date::Calc qw(:all);
use HTML::Template;


# Translation table for characters to LaTeX symbols.
my %set = (
	"\x79" => "y",
	"\xb8" => "\x5cc\x7b\x7d",
	"\xc7" => "\x5cc\x7bC\x7d",
	"\xad" => "\x5c\x2d",
	"\xa5" => "\x7b\x5ctextyen\x7d",
	"\x2a" => "\x2a",
	"\xcc" => "\x5c\x60I",
	"\xfb" => "\x5c\x5eu",
	"\xd9" => "\x5c\x60U",
	"\x74" => "t",
	"\xe6" => "\x7b\x5cae\x7d",
	"\xdc" => "\x5c\x22U",
	"\x73" => "s",
	"\xed" => "\x5c\x27i",
	"\x66" => "f",
	"\x44" => "D",
	"\x3d" => "\x3d",
	"\xec" => "\x5c\x60i",
	"\x51" => "Q",
	"\x2f" => "\x2f",
	"\xd5" => "\x5c\x7eO",
	"\x5b" => "\x5b",
	"\xa1" => "\x21\x60",
	"\xd7" => "\x7b\x5ctexttimes\x7d",
	"\xa8" => "\x7b\x5ctextasciidieresis\x7d",
	"\x2c" => "\x2c",
	"\xb5" => "\x7b\x5ctextmu\x7d",
#	"\xb0" => " \$ \\textdegree \$ ",
	"\xb0" => "\x7b\x5ctextdegree\x7d",

	"\x38" => "8",
	"\x63" => "c",
	"\x21" => "\x21",
	"\x3a" => "\x3a",
	"\x7e" => "\x5c\x7e\x7b\x7d",
	"\xd3" => "\x5c\x27O",
	"\x36" => "6",
	"\x7c" => "\x7b\x5ctextbar\x7d",
	"\xdd" => "\x5c\x27Y",
	"\xf7" => "\x7b\x5ctextdiv\x7d",
	"\xea" => "\x5c\x5ee",
	"\x42" => "B",
	"\xf4" => "\x5c\x5eo",
	"\xfd" => "\x5c\x27y",
	"\x54" => "T",
	"\xcf" => "\x5c\x22I\x27",
	"\x68" => "h",
	"\x50" => "P",
	"\xe4" => "\x5c\x22a",
	"\x65" => "e",
	"\x48" => "H",
	"\xaf" => "\x7b\x5ctextasciimacron\x7d",
	"\xfa" => "\x5c\x27u",
	"\xf8" => "\x7b\x5co\x7d",
	"\xe2" => "\x5c\x5ea",
	"\x5f" => "\x5c\x5f",
	"\x28" => "\x28",
	"\xbe" => "\x7b\x5ctextthreequarters\x7d",
	"\x4d" => "M",
	"\xc0" => "\x5c\x60A",
	"\xce" => "\x5c\x5eI",
	"\x5d" => "\x5d",
	"\xcb" => "\x5c\x22E\x27",
	"\xf2" => "\x5c\x60o",
	"\x4b" => "K",
	"\x58" => "X",
	"\xff" => "\x5c\x22y\x27",
	"\xab" => "\x7b\x5cguillemotleft\x7d",
	"\xa3" => "\x7b\x5cpounds\x7d",
	"\x3b" => "\x3b",
	"\xf1" => "\x5c\x7en",
	"\x3e" => "\x7b\x5ctextgreater\x7d",
	"\x55" => "U",
	"\x49" => "I",
	"\x6e" => "n",
	"\x62" => "b",
	"\x24" => "\x5c\x24",
	"\x3c" => "\x7b\x5ctextless\x7d",
	"\xc5" => "\x7b\x5cAA\x7d",
	"\x6f" => "o",
	"\x32" => "2",
	"\xb2" => "\x7b\x5ctexttwosuperior\x7d",
	"\xef" => "\x5c\x22i\x27",
	"\x53" => "S",
	"\x26" => "\x5c\x26",
	"\xa7" => "\x7b\x5cS\x7d",
	"\xe9" => "\x5c\x27e",
	"\x43" => "C",
	"\xeb" => "\x5c\x22e\x27",
	"\x57" => "W",
	"\xa9" => "\x7b\x5ctextcopyright\x7d",
	"\xb6" => "\x7b\x5cP\x7d",
	"\xbb" => "\x7b\x5cguillemotright\x7d",
	"\x76" => "v",
	"\xd0" => "\x7b\x5cDH\x7d",
	"\x33" => "3",
	"\xe0" => "\x5c\x60a",
	"\x4e" => "N",
	"\x30" => "0",
	"\x5a" => "Z",
	"\x52" => "R",
	"\xf6" => "\x5c\x22o",
	"\x70" => "p",
	"\x5c" => "\x7b\x5ctextbackslash\x7d",
	"\xe5" => "\x7b\x5caa\x7d",
	"\xd4" => "\x5c\x5eO",
	"\x60" => "\x5c\x60\x7b\x7d",
	"\xdf" => "\x7b\x5css\x7d",
	"\xfe" => "\x7b\x5cth\x7d",
	"\x72" => "r",
	"\x2b" => "\x2b",
	"\xe7" => "\x5cc\x7bc\x7d",
	"\xb7" => "\x7b\x5ctextperiodcentered\x7d",
	"\xd8" => "\x7b\x5cO\x7d",
	"\x41" => "A",
	"\xc9" => "\x5c\x27E",
	"\x2d" => "\x7b\x7d\x2d",
	"\xf5" => "\x5c\x7eo",
	"\x6c" => "l",
	"\xf3" => "\x5c\x27o",
	"\xc2" => "\x5c\x5eA",
	"\xc6" => "\x7b\x5cAE\x7d",
	"\x35" => "5",
	"\x69" => "i",
	"\x37" => "7",
	"\x64" => "d",
	"\xb3" => "\x7b\x5ctextthreesuperior\x7d",
	"\x40" => "\x40",
	"\xe8" => "\x5c\x60e",
	"\x67" => "g",
	"\xa0" => "\x7e",
	"\xb9" => "\x7b\x5ctextonesuperior\x7d",
	"\x75" => "u",
	"\xc1" => "\x5c\x27A",
	"\xb4" => "\x7b\x5ctextasciiacute\x7d",
	"\xbf" => "\x3f\x60",
	"\x59" => "Y",
	"\xae" => "\x7b\x5ctextregistered\x7d",
	"\xa2" => "\x7b\x5ctextcent\x7d",
	"\xb1" => "\x7b\x5ctextpm\x7d",
	"\xde" => "\x7b\x5cTH\x7d",
	"\x45" => "E",
	"\xbd" => "\x7b\x5ctextonehalf\x7d",
	"\xee" => "\x5c\x5ei",
	"\x7b" => "\x5c\x7b",
	"\xfc" => "\x5c\x22u",
	"\xd2" => "\x5c\x60O",
	"\x2e" => "\x2e",
	"\x22" => "\x7b\x5ctextquotedbl\x7d",
	"\xe3" => "\x5c\x7ea",
	"\x6d" => "m",
	"\xba" => "\x7b\x5ctextordmasculine\x7d",
	"\x27" => "\x27",
	"\x46" => "F",
	"\xca" => "\x5c\x5eE",
	"\xc8" => "\x5c\x60E",
	"\xa6" => "\x7b\x5ctextbrokenbar\x7d",
	"\x4c" => "L",
	"\x7d" => "\x5c\x7d",
	"\xf0" => "\x7b\x5cdh\x7d",
	"\x6a" => "j",
	"\xaa" => "\x7b\x5ctextordfeminine\x7d",
	"\xf9" => "\x5c\x60u",
	"\x4a" => "J",
	"\x77" => "w",
	"\xda" => "\x5c\x27U",
	" " => " ",
	"\xe1" => "\x5c\x27a",
	"\x23" => "\x5c\x23",
	"\xcd" => "\x5c\x27I",
	"\xc4" => "\x5c\x22A",
	"\x5e" => "\x5c\x5e\x7b\x7d",
	"\x47" => "G",
	"\x6b" => "k",
	"\x56" => "V",
	"\x31" => "1",
	"\xd6" => "\x5c\x22O",
	"\xac" => "\x7b\x5ctextlnot\x7d",
	"\x78" => "x",
	"\xbc" => "\x7b\x5ctextonequarter\x7d",
	"\x34" => "4",
	"\x29" => "\x29",
	"\xd1" => "\x5c\x7eN",
	"\x39" => "9",
	"\x25" => "\x5c\x25",
	"\x7a" => "z",
	"\xc3" => "\x5c\x7eA",
	"\x3f" => "\x3f",
	"\x61" => "a",
	"\x7f" => "",
	"\xdb" => "\x5c\x5eU",
	"\x71" => "q",
	"\xa4" => "\x7b\x5ctextcurrency\x7d",
	"\x4f" => "O"
);


#
# startup
# 

my $customer = shift;
my $cmd = shift;

if((not defined $customer) or (not defined $cmd)) {
    die "wtlog.pl <customer> [start | stop | edit | pause | info | list | timereport | holiday] \n";
}

if($customer !~ m!^[a-z\d\_\-\.]+$!) {
    die "Error: invalid identifier string used for the customer name.\n";
}

my @today = Today();
wt_checkdir($dir);
my $stat_file = $dir . '/.current.' . $customer; # the file that contais the current log file

my $filename = get_current_file($stat_file);
my $new_filename = sprintf("$dir/%4d-%02d-%02d_%s.dat", @today, $customer);
if($filename eq '') {
    $filename = $new_filename;
}

#
# handle commands
#

if($cmd eq 'start') {

    # first, check if there exists an unfinished session
    my $record = load_record($filename);


    if(exists($record->{state}) and
       ($record->{state} ne 'finished')) {
	die "invalid state $record->{state}\n";
    }
    else {
	my $record = {};
	$record->{work_time} = [];
	push @{$record->{work_time}},  { start => [Today_and_Now()],
					 finish => undef};
	$record->{state} =  'working';

	write_record($new_filename, $record);
	wt_print_info($record);
	set_current_file($stat_file, $new_filename);
    }
}
elsif(($cmd eq 'finish') or ($cmd eq 'end') or ($cmd eq 'stop')) {
    my $record = load_record($filename);

    if(($record->{state} eq 'working')) {

	$record->{work_time}->[$#{$record->{work_time}}]->{finish} = [Today_and_Now()];
	$record->{state} =  'working';

	$record->{state} = 'finished';
	write_record($filename, $record);
	wt_print_info($record);
	
	unset_current_file($stat_file);
    }
    else {
	die "invalid state $record->{state}\n";
    }
}
elsif($cmd eq 'holiday') {
    my $date = shift;
    my $hours = shift;

    if(not defined($date) or not defined($hours)) {
	die "wtlog.pl <customer> holiday <date> <hours>\n" .
	    "\n" .
	    "where <date> is in the form of yyyy-mm-dd and <hours> is the number of regular work hours.\n";
    }

    my $date_start = ts_parse($date);
    if(not defined $date_start) {
	die "Error: invalid date format.\n";
    }

    my $minutes = $hours * 60;

    $date_start->[3] = 9; # start at 9:00
    my @date_end = Add_Delta_DHMS(@$date_start, 0, 0, $minutes, 0);
    
    my $record = {};
    push @{$record->{holiday}},  { start => $date_start,
				   finish => \@date_end};
    $record->{state} =  'finished';
    $record->{invoice_logs} = '- Holiday';

    my $new_filename = sprintf("$dir/%4d-%02d-%02d_%s.dat", $date_start->[0], $date_start->[1], $date_start->[2], $customer);
    write_record($new_filename, $record);
    wt_print_info($record);
#    print Dumper($record);

}
elsif($cmd eq 'edit') {

    if($ENV{EDITOR}) {
	system($ENV{EDITOR}, $filename);
    }
    else {
	system('emacs', $filename);
    }
    my $record = load_record($filename);
    wt_print_info($record);
}
elsif(($cmd eq 'info') or 
      ($cmd eq 'status') or 
      ($cmd eq 'stat') ) {
    my $record = load_record($filename);
    wt_print_info($record);
}
elsif($cmd eq 'list') {
    my $from = shift;
    my $to = shift;

    my @files = get_matching_files($from, $to, $customer);
    wt_print_info_many(@files);
    
}
elsif($cmd eq 'timereport') {
    my $from = shift;
    my $to = shift;

    if(not $from and not $to) {
	die "wtlog.pl <customer> timereport <from-date> <to-date>\n" .
	    "\n" .
	    "where date is in the form of yyyy-mm-dd and <to-date> is not included.\n";
    }
    my @files = get_matching_files($from, $to, $customer);

    render_timereport($from, $to, $customer, @files);
    
}
elsif($cmd eq 'pause') {
    my $record = load_record($filename);

    $record->{pause} = [] if(not exists $record->{pause});

    if($record->{state} eq 'working') {
	push @{$record->{pause}},  { start => [Today_and_Now()],
				     finish => undef};
	$record->{state} =  'pause';
	write_record($filename, $record);
	wt_print_info($record);
    }
    elsif($record->{state} eq 'pause') {
	$record->{pause}->[$#{$record->{pause}}]->{finish} = [Today_and_Now()];
	$record->{state} =  'working';
	write_record($filename, $record);
	wt_print_info($record);
    }
    else {
	die "invalid state $record->{state}\n";
    }
}
else {
    die "unknown command '$cmd'\n";
}


sub wt_checkdir {
    my $dir = shift;
    if(not -d $dir) {
	mkdir($dir, 0700) or die "can't create directory '$dir': $!\n";
    }
}

sub load_record {
    my $filename = shift;
    my $r = {};

    if(-f $filename) {
	my $line;
	my $log_section = 0; # flag: in a free style text log section?

	open(WTLOGFILE, "< $filename") or die "can't open $filename: $!\n";
	while(defined ($line = <WTLOGFILE>)) {

	    if((not $log_section) and ($line =~ m!^state: (.*)!)) {
		$r->{state} = $1;
	    }
	    elsif((not $log_section) and ($line =~ m!^work_time: (.*?) to (.*)!)) {
		$r->{work_time} = [] if(not exists $r->{work_time});
		push @{$r->{work_time}}, { start => ts_parse($1),
				       finish => ts_parse($2)};
	    }
	    elsif((not $log_section) and ($line =~ m!^work_time: (.*?) for (.*)!)) {
		$r->{work_time} = [] if(not exists $r->{work_time});
		push @{$r->{work_time}}, { start => ts_parse($1),
				       finish => parse_and_calc($2, ts_parse($1))};
	    }
	    elsif((not $log_section) and ($line =~ m!^personal_start: (.*)!)) {
		$r->{work_time} = [] if(not exists $r->{work_time});
		push @{$r->{work_time}}, { start => ts_parse($1),
					   finish => undef}
	    }
	    elsif((not $log_section) and ($line =~ m!^personal_finish: (.*)!)) {
		$r->{work_time} = [] if(not exists $r->{work_time});

		$r->{work_time}->[$#{$r->{work_time}}]->{finish} = ts_parse($1);
		$r->{personal_finish} = ts_parse($1);
	    }
	    elsif((not $log_section) and ($line =~ m!^pause: (.*?) to (.*)!)) {
		$r->{pause} = [] if(not exists $r->{pause});
		push @{$r->{pause}}, { start => ts_parse($1),
				       finish => ts_parse($2)};
	    }
	    elsif((not $log_section) and ($line =~ m!^holiday: (.*?) to (.*)!)) {
		$r->{holiday} = [] if(not exists $r->{holiday});
		push @{$r->{holiday}}, { start => ts_parse($1),
					 finish => ts_parse($2)};
	    }
	    elsif($line =~ m!^==\s+Invoice\s+logs\s+==!) {
		$log_section = 1;
	    }
	    elsif(($line =~ m!^==\s+Personal\s+logs\s+==!) or
		  ($line =~ m!^==\s+Private\s+logs\s+==!)) {
		$log_section = 2;
	    }
	    elsif($log_section) {
		my $key = $log_section == 1 ? 'invoice_logs' : 'personal_logs';
		$r->{$key} .= $line;
	    }
	    elsif($line =~ m!^\s*$!) {
		# ignore
	    }
#	    else {
#		die "can't parse line: $line";
#	    }

	}
	close WTLOGFILE;
    }
    return $r;
}

sub write_record {
    my $filename = shift;
    my $record = shift;

    if(not ref($record) or ($filename eq '')) {
	warn "write_record() bad params\n";
	return;
    }

    open(WTLOGFILE, "> $filename") or die "can't open $filename: $!\n";
    print WTLOGFILE
	"state: ", $record->{state}, "\n";
    
    foreach  ( @{$record->{work_time}}  ) { 
	print WTLOGFILE 
	    "work_time: ", ts_to_str($_->{start}), " to ", ts_to_str($_->{finish}), "\n";
    }

    foreach  ( @{$record->{holiday}}  ) { 
	print WTLOGFILE 
	    "holiday: ", ts_to_str($_->{start}), " to ", ts_to_str($_->{finish}), "\n";
    }

    foreach  ( @{$record->{pause}}  ) { 
	print WTLOGFILE 
	    "pause: ", ts_to_str($_->{start}), " to ", ts_to_str($_->{finish}), "\n";
    }

    print WTLOGFILE
	"== Invoice logs ==\n",
	$record->{invoice_logs}, "\n",
	"== Personal logs ==\n",
	$record->{personal_logs}, "\n"
	;
    close WTLOGFILE;
}

sub wt_info {
    my $record = shift;

    my $sum_breaks = 0;
    my $sum_wt = 0;
    my $sum_holiday = 0;

    foreach  ( @{$record->{pause}}  ) { 
	$sum_breaks += time_span($_);
    }

    foreach  ( @{$record->{work_time}}  ) { 
	$sum_wt += time_span($_);
    }

    foreach  ( @{$record->{holiday}}  ) { 
	$sum_holiday += time_span($_);
    }

    return { sum_wt => $sum_wt,
	     sum_breaks => $sum_breaks,
	     sum_holiday => $sum_holiday,
	     netto_work_time => $sum_wt- $sum_breaks
	     };
}

sub wt_print_info {
    my $record = shift;

    my $stats = wt_info($record);

    print "Current state    : ", $record->{state}, "\n";
    print "Sum of work time : ", periode_to_str($stats->{sum_wt}), "\n";
    print "Sum of breaks    : ", periode_to_str($stats->{sum_breaks}), "\n";
    print "Netto work time  : ", periode_to_str($stats->{netto_work_time}), "\n";
    print "Holiday          : ", periode_to_str($stats->{sum_holiday}), "\n";

}

sub wt_print_info_many {
    foreach my $file (@_) {

	my $rec = load_record($file);
	print "\n\n[$file]:\n";
	wt_print_info($rec);
    }
}

sub periode_to_str{
    my $sec = shift;
    if($sec < 60) {
	return "$sec s";
    }
    elsif($sec < 3600) {
	return sprintf("%d m", $sec / 60);
    }
    else {
	return sprintf("%d:%02d h", $sec / 3600, ($sec % 3600) / 60);
    }
}

sub ts_parse {
    my $str = shift;

    if($str =~ m!(\d\d\d\d)-(\d\d)-(\d\d) (\d\d):(\d\d):(\d\d)!) {
	return [ $1, $2, $3, $4, $5, $6 ];
    }
    elsif($str =~ m!(\d\d\d\d)-(\d\d)-(\d\d)!) {
	return [ $1, $2, $3, 0, 0, 0];
    }
    else {
	return undef;
    }
}

sub parse_and_calc {
    my $str = shift;
    my $start_date = shift; # result from ts_parse($1)
    if($str =~ m!(\d+):(\d+)!) {
	return [ Add_Delta_DHMS(@$start_date, 0, $1, $2, 0) ];
    }
}

sub ts_to_str {
    my $ref = shift;
    if(ref($ref) and ($#$ref + 1 == 6)) {
	return sprintf("%4d-%02d-%02d %02d:%02d:%02d", @$ref);
    }
    if(ref($ref) and ($#$ref + 1 == 5)) {
	return sprintf("%4d-%02d-%02d %02d:%02d", @$ref);
    }
    else {
	return undef;
    }
}

sub ts_to_hr_date {
    my $ref = shift;
    if(ref($ref)) {
	return sprintf("%02d.%02d.%4d", $ref->[2], $ref->[1], $ref->[0]);
    }
}

sub get_current_file {
    my $stat_file = shift;

    my $result = '';
    if( -f $stat_file) {
	open(STAT, "< $stat_file") or die "can't read stat_file: $!\n";
	$result = <STAT>;
	chomp($result);
#	print "got [$result]\n";
	close STAT;
    }
    return $result;
}

sub set_current_file {
    my $stat_file = shift;
    my $file = shift;
    open(STAT, "> $stat_file") or die "can't write stat_file: $!\n";
    print STAT $file;
    close STAT;
}

sub unset_current_file {
    my $stat_file = shift;
    unlink $stat_file;
}

sub get_matching_files {
    my $from = Mktime(@{ts_parse(shift)});
    my $to = Mktime(@{ts_parse(shift)});
    my $customer = shift;

    my @file_set;
    while(<$dir/*.dat>) {
	
	if(m!(\d\d\d\d-\d\d-\d\d)_$customer(\.\d+)?!) {
	    my $t = Mktime(@{ts_parse($1)});
	    if(($from <= $t) and ($t < $to)) {
		push @file_set, $_;
	    }
	}
    }
    return @file_set;
}

sub convert {
    my $str = shift;
    my $single_newline = shift; 
#    printf("%02x\n", ord $str);
    $str =~ s!(.)!$set{$1}!g;
    if($single_newline) {
	$str =~ s!\n!\\\\\n!gs;
    }
    else {
	$str =~ s!\n\n!\\\\\n\n!gs;
    }

    my $str2 = "";

    my $itemize_on = 0;
    foreach my $line (split(/\n/, $str)) {
	if(not $itemize_on and ($line =~ m!^\s*\*!s)) {
	    $itemize_on = 1;
	    $str2 .= "\\begin{itemize}\n";
	}

	if($itemize_on and ($line =~ m!^\s*\*(.*)!s)) {
	    $str2 .= "\\item " . $1 . "\n";

	}
	elsif($itemize_on and ($line =~ m!^\s*$!s)) {
	    $str2 .= "\\end{itemize}\n";
	    $itemize_on = 0;
	}
	else {
	    $str2 .= $line . "\n";
	}
    }
    chomp $str2;
    return $str2;
}

sub render_timereport {
    my $first_date = shift;
    my $last_date = shift;
    my $customer = shift;
    my $base_filename = "${first_date}__${last_date}___${customer}___";
    
    my @workdays;
    my $overall_wt = 0;
    my $overall_sparetime = 0;
    my $week_worktime = 0;
    my $week_sparetime = 0;
    my $last_week = 0;
    my @files = @_;

    # first, check all files
    foreach my $file (@files) {
	my $rec = load_record($file);
	if($rec->{state} ne 'finished') {
	    die "File $file is not in state finished.";
	}
    }

    foreach my $file (@files) {

	print "+ Processing file $file\n";

	my $rec = load_record($file);

#	wt_print_info($rec);
#	print Dumper($rec->{work_time}->[0]->{start});
	
	my @worktimes;
	my @sparetimes;
	my $netto_wt = 0;
	my $sparetime = 0;

	foreach (@{$rec->{work_time}}) { 
	    $_->{KIND} = 'Arbeit'; 
	    push @worktimes, $_; 
	    $netto_wt += time_span($_);
	}
	foreach (@{$rec->{pause}}) { 
	    $_->{KIND} = 'Pause'; 
	    push @worktimes, $_;
	    $netto_wt -= time_span($_);
	}
	foreach (@{$rec->{holiday}}) { 
	    $_->{KIND} = 'Urlaub'; 
	    push @sparetimes, $_;
	    $sparetime += time_span($_);
	    # no work time
	}

	foreach my $i (@worktimes) {
	    $i->{START_TIME} = ts_to_str($i->{start});
	    $i->{END_TIME} = ts_to_str($i->{finish});
#	    print Dumper(\@worktimes);
	}

#	my $key =  ? 'holiday' : 'work_time';
	my @start_date;
	if(exists($rec->{holiday}) and ($#{$rec->{holiday}} > -1)) {
	    print Dumper($rec);
	    @start_date = @{$rec->{holiday}->[0]->{start}}[0..2];
	}
	else {
	    @start_date = @{$rec->{work_time}->[0]->{start}}[0..2];
	}
	print "start date: @start_date\n";

	my $week = Week_of_Year(@start_date);
	my $week_day = Day_of_Week(@start_date);

	my @weekday_name = qw(Mo Di Mi Do Fr Sa So);

	$worktimes[0]->{NETTO_WT} = periode_to_str($netto_wt);
	$worktimes[0]->{WEEK_INFO} = "KW $week / " . $weekday_name[$week_day - 1];


	my $log = "\n" . $rec->{invoice_logs};
	$log =~ s!\n+$!!s;
	$log =~ s!\"!\'!g;
	$log = convert($log);
	$log =~ s!\n(\s+) !"\n" . indent($1)!ge;
#	$log =~ s! !~!g;
	$log =~ s!\n!"\\\\ \n"!egs;

	print STDOUT $log;

	if($week != $last_week) {
	    $week_worktime = $netto_wt;
	    $week_sparetime = $sparetime;
	}
	else {
	    $week_worktime += $netto_wt;
	    $week_sparetime += $sparetime;
	}

	push @workdays, { WT_LOOP => \@worktimes,
			  ILOG => $log,
			  WEEK_CHANGE_BEFORE => ($week != $last_week) ? 1:0,
			  WEEK_WORKTIME => periode_to_str($week_worktime),
			  WEEK_SPARETIME => periode_to_str($week_sparetime),
			  WEEK_SUM => periode_to_str($week_sparetime + $week_worktime)};

	$overall_wt += $netto_wt;
	$overall_sparetime += $sparetime;

	$last_week = $week;

    }
    for(my $i = 0; $i < $#workdays; $i++) {
	if($workdays[$i+1]->{WEEK_CHANGE_BEFORE}) {
	    $workdays[$i]->{DISPLAY_WEEK_WORKTIME} = 1;
	}
    }
    $workdays[$#workdays]->{DISPLAY_WEEK_WORKTIME} = 1;

    open(REPORT, "> ${base_filename}timereport.tex") or 
	die "can't write time report: $!\n";

    my $template = HTML::Template->new(filename => $log_template,
				       die_on_bad_params => 0);

    $template->param(FIRST_DATE => ts_to_hr_date(ts_parse($first_date)),
		     LAST_DATE  => ts_to_hr_date(ts_parse($last_date)),
		     LOG_LOOP => \@workdays,
		     OVERALL_WORKTIME => periode_to_str($overall_wt),
		     OVERALL_SPARETIME => periode_to_str($overall_sparetime),
		     OVERALL_SUM => periode_to_str($overall_sparetime + $overall_wt)
		     );
    print REPORT $template->output();
    close REPORT;
    system('texi2pdf', $base_filename . 'timereport.tex');

}

sub time_span {
    my $time_record = shift;
    my $ret = 0;
    if(defined $time_record->{finish}) {
	my ($Dd,$Dh,$Dm,$Ds) = Delta_DHMS( @{$time_record->{start}}, 
					   @{$time_record->{finish}});
	$ret = $Dd*86400 + $Dh*3600 + $Dm*60 + $Ds;
    }
    else {
	my ($Dd,$Dh,$Dm,$Ds) = Delta_DHMS( @{$time_record->{start}}, 
					   Today_and_Now());
	$ret = $Dd*86400 + $Dh*3600 + $Dm*60 + $Ds;
    }
    die "invalid time: duration cannot be negative." if($ret < 0);
    return $ret;
}

sub indent {
    my $spaces = shift;
    return "\\hspace*{0.105cm} " x length($spaces);
}

