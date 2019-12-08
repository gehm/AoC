#!/usr/local/bin/perl
# AoC 2019 day 6

use strict;
#use warnings;
no warnings 'recursion';
use Data::Dumper;
use Tree::Simple;
#use Data::TreeDumper;


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

my @input2 = @input;

while ( @input) { 
	my $next = shift @input;
	my ($node, $child) = split /\)/, $next;
	my %noch;
	$noch{$node} = $child;
	
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
my %hash;
foreach ( @input2 ) { 
	my ($node, $child) = split /\)/, $_;
	$hash{$child} = $node;
	
}

my @way;
my $i = "SAN";
my ($parent, $common);
while ( 1 ) {
	$parent = $hash{$i};
	last if $parent eq "COM";
	push @way, $parent;
	$i = $parent;
}

$i = "YOU";
while ( 1 ) {
	$parent = $hash{$i};
	if ( $parent ~~ @way ) {
		$common = $parent;
		last;
	};
	$i = $parent;
}

my ($san_depth, $you_depth, $common_depth);

$tree->traverse(
	sub {
		my ($this) = @_;
		if ($this->getNodeValue() eq "SAN" ){
			print "SAN depth: ",$this->getDepth(),"\n";
			$san_depth = $this->getDepth();
		} elsif ($this->getNodeValue() eq "YOU" ){
			print "YOU depth: ",$this->getDepth(),"\n";	
			$you_depth = $this->getDepth();
		} elsif ($this->getNodeValue() eq $common ){
			print "Common $common depth is: ",$this->getDepth(),"\n";
			$common_depth = $this->getDepth();
		}
		
		$count += $this->getDepth();
		$count2++
		}
);




print "Total Number of Orbits is (Part 1): $count\n";
print "The total hops from YOU to SAN: ", ( $san_depth + $you_depth - 2 - 2 * $common_depth), "\n";
$tree->DESTROY;




