#!/usr/local/bin/perl


use strict;
use warnings;
use threads;
use threads::shared;
use Thread::Queue;

use List::Permutor;
use List::Util qw( max );

use FindBin;
use lib "$FindBin::Bin/../lib";
use IntComp;

my $input = "$FindBin::Bin/input.txt";
open(my $fh, "<", $input ) or die "Ooops! No $input";
my @int_prog = split(',', <$fh>);
close $fh;


my $a_queue = Thread::Queue->new(0);
my $amp_a = threads->create(\&IntComp::run, $a_queue , $realprog, $a_queue, "A");
