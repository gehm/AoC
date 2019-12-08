#!/usr/local/bin/perl
# AoC 2019 day 6

use strict;
use warnings;
#no warnings 'recursion';
use Data::Dumper;
use Tree::Simple;
use Data::TreeDumper;


# Create Tree
my $tree = Tree::Simple->new("0", Tree::Simple->ROOT) or die "Cant init tree!\n";
my @planets = (  );
my @input;

print Dumper @planets;

# Get the damn inputfile
open(my $fh, "<", "input.txt") or die "Ooops! No input.txt";

while (my $kn = <$fh>) {
	chomp ($kn);
	push @input, $kn;
}
close $fh;

while ( @input) { 
	my $next = shift @input;
	my ($node, $child) = split /\)/, $next;
	if ( ($node ~~ @planets) ) {
		$tree->traverse(
			sub {
				my ($this) = @_;
				if ($this->getNodeValue() eq $node) {
					$this->addChild(Tree::Simple->new($child)) or die "Cant add $node\n";
					push @planets, $child;
					
				}	
			}
		)
	
	} elsif ($child ~~ @planets ) {
		$tree->traverse(
			sub {
				my ($this) = @_;
				if ($this->getNodeValue() eq $child) {
					$tree->insertChild( $this->getIndex(), Tree::Simple->new($node) );
					push @planets, $node;
				}
			}
			
		)
	} elsif ($node eq 'COM') {	
		my $newnode = Tree::Simple->new($node);
		my $newchild = Tree::Simple->new($child);
		$newnode->addChild($newchild);
		$tree->addChild($newnode);
		push @planets, $node;
		push @planets, $child;
	} else {
		push @input, $next;
	}
	
}


my $count = 0;
my $count2 = 0;
$tree->traverse(
	sub {
		my ($this) = @_;
		$count += $this->getDepth();
		$count2++
		}
);

# print "\n";

# print "We have ", $tree->size() ," nodes.\n";
# print "We have processed $count2 nodes\n";
#print "We had ", scalar @planets, " Planets\n";

print "Total Number of Orbits is (Part 1): $count\n";
$tree->DESTROY;




