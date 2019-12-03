#!/usr/local/bin/perl

use strict;
use warnings;
use Array::Utils qw(:all);
use List::MoreUtils qw(firstidx);
use List::Util qw( min );
use Data::Dumper;
 
my @grid;
my $cablenr = 0;

open(my $fh, "<", "input.txt") or die "Ooops! No input.txt";
while (my $cableline = <$fh>) {
	
	chomp $cableline;
	my @cable = split /,/, $cableline;
	my @pos = (0,0);
	
	foreach ( @cable ) {
		my $dir = substr $_,0,1;
		my $len = substr $_, 1; 
		
		# We have R,L,U,D
		if ($dir eq "R"){
			for (1..$len) {
			# Move on X Axis from POS len times in + 		
				$pos[0]++;
				push @{$grid[$cablenr]}, $pos[0].",".$pos[1];
			}
		} elsif ($dir eq "L"){
			# Move on X Axis from POS len times in -
			for (1..$len) {
				$pos[0]--;
				push @{$grid[$cablenr]}, $pos[0].",".$pos[1];
			}			
		} elsif ($dir eq "U"){
			# Move on Y Axis from POS len times in +
			for (1..$len) {
				$pos[1]++;
				push @{$grid[$cablenr]}, $pos[0].",".$pos[1];	
			}			
		} elsif ($dir eq "D"){
			# Move on X Axis from POS len times in -
			for (1..$len ) {
				$pos[1]--;
				push @{$grid[$cablenr]}, $pos[0].",".$pos[1];	
			}			
		} else {
			die "Unknown direction $dir\n";
		}
		
	}
	$cablenr++;
}

my %crossings = map { $_ => taxicab("0","0", split(/,/,$_)) } intersect( @{$grid[0]},@{$grid[1]} );
my $min = min values %crossings;
print "Minimum Distance:  $min \n";

my %steps;
my @cable_0 =@{$grid[0]};
my @cable_1 =@{$grid[1]};

foreach my $cross (keys %crossings) {
	my $idx = (firstidx { $_ eq $cross } @cable_0) + (firstidx { $_ eq $cross } @cable_1) + 2;
	$steps{$cross} = $idx;
}

my $min_steps = min values %steps;
print "Minimum Steps:  $min_steps \n";


sub taxicab {
	my ($x1,$y1,$x2,$y2) = @_;
	my $dist = abs($x1 - $x2) + abs($y1 - $y2);
	return $dist;

}

# print Dumper \@{$grid[0]};
# print Dumper \@{$grid[1]};
# print Dumper \%steps;
# print Dumper \@dist;

close ($fh);



