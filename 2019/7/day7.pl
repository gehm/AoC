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

# The Phases....

my @thrust;
my $perm = new List::Permutor qw/ 5 6 7 8 9 /;
#my @set = ( 9,6,5,9,7 );
while (my @set = $perm->next) {	
my $a_queue = Thread::Queue->new($set[0],0);
my $b_queue = Thread::Queue->new($set[1]);
my $c_queue = Thread::Queue->new($set[2]);
my $d_queue = Thread::Queue->new($set[3]);
my $e_queue = Thread::Queue->new($set[4]);

my $realprog = \@int_prog;

my $amp_a = threads->create(\&IntComp::run, $a_queue , $realprog, $b_queue, "A");
my $amp_b = threads->create(\&IntComp::run, $b_queue , $realprog, $c_queue, "B");
my $amp_c = threads->create(\&IntComp::run, $c_queue , $realprog, $d_queue, "C");
my $amp_d = threads->create(\&IntComp::run, $d_queue , $realprog, $e_queue, "D");
my ($amp_e) = threads->create(\&IntComp::run, $e_queue , $realprog, $a_queue, "E");

$amp_a->join();
$amp_b->join();
$amp_c->join();
$amp_d->join();

my @value = $amp_e->join();
#print $value[0],"\n";
push @thrust, $value[0];
}

my $max = max @thrust;
print "Number of permutations: ", scalar @thrust, "\n";
print "Maximum is $max\n";


