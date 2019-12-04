#!/usr/local/bin/perl

use strict;
use warnings;
use Array::Utils qw(:all);
use List::MoreUtils qw(firstidx);
use List::Util qw( min max );
use Data::Dumper;

my @list;
my @list2;
# 172930-683082
foreach (my $i=172930; $i < 683082; $i++) {
#foreach (my $i=172930; $i < 422223; $i++) {
		if (nondecnr($i) && hasDupes($i)) {
			push @list, $i;
			
			my @doubles = hasDupes($i);
			my $max = max @doubles;
			my $sec = (sort @doubles)[-2];
			#print "$i -> $max/$sec : @doubles\n";
			
			if ( ($max == 3) && ($sec == 3) ) {} 
			elsif ( ($sec == 2) || ($sec == 3) ){
				 push @list2, $i;
			} elsif (( $max == 2) && ($sec == 1) ) {
				 push @list2, $i;
			}
		} 
}


#print Dumper \@list;
print "Part 1: ".scalar @list."\n";;
#print Dumper \@list2;
#foreach (@list2) {print "$_\n";}
print "Part 2: ".scalar @list2."\n";

sub nondecnr {
	my $n = shift; 		
	my $x = $n % 10; 	
	my $y = int($n / 10); 
	
	while ($y) {
		return 0 if ( ($y % 10) > $x );
		$x = $y % 10;
		$y /= 10;
	}
	
	return 1;
}

sub hasDupes {
	my $n = shift;
    my @used = ( 0,0,0,0,0,0,0,0,0,0 );
    return 1 if ( $n > 9999999999 );
	
    while ($n) {
        #return 1 if ($used[ $n % 10 ] == 1 );
		my $digit = $n % 10;
        $used[ $digit ] = ($used[ $digit ] + 1);
        $n = int( $n / 10 );
    }
	my $max = max @used;
	
	#print $max;
	#print Dumper \@used;
	return @used if ( $max > 1 );
    return 0;
}