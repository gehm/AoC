#!/usr/local/bin/perl
#AoC 2019 Day 8 Complete

use strict;
use warnings;
use Data::Dumper;

my $input = "input.txt";
open(my $fh, "<", $input ) or die "Ooops! No $input";

# Each Array Entry is one Layer
my @lines = unpack("(A150)*", <$fh>);

# Part One
print "Part 1: ", (count_digits( min_zero(@lines), 1 ) * count_digits( min_zero(@lines), 2) ), "\n";

print "Part 2:\n";
my @image = make_image(@lines);
my $pic = join("",@image);
foreach (unpack("(A25)*", $pic)) {
	(my $newstring = $_) =~ s/0/ /g;
	print $newstring,"\n";
}

#### SUBS

sub min_zero {
	my @lines = @_;

	my $min = $lines[0];
	for (my $i= 1; $i < (scalar @lines);$i++ ) {
		if (count_digits( $lines[$i], 0) < count_digits( $min, 0) ) {
			$min = $lines[$i];
		}
	} 	
	return $min;	
}

sub count_digits {
	my ($string,$digit) = @_;
	return length( $string =~ s/[^\Q$digit\E]//rg );
}

sub make_image {
	my @lines = @_;
	my $first = shift @lines;
	my @image = unpack("(A1)*", $first) or die "No imput in make_image!";
	
	for my $l (@lines){
		my @line = unpack("(A1)*", $l);
		foreach (my $i=0 ; $i < (scalar @image); $i++ ) {
			next if $line[$i] == 2;
			next if (($image[$i] == 0) || ($image[$i] == 1));
			$image[$i] = $line[$i];
		}
	}

	return @image;
	
}