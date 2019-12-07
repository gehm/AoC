#!/usr/local/bin/perl
# AoC 2019 day 6

use strict;
use warnings;
use Data::Dumper;
use Tree::Simple;
use Data::TreeDumper;


# Create Tree
my $tree = Tree::Simple->new("0", Tree::Simple->ROOT) or die "Cant init tree!\n";
my @planets = ();

# Get the damn inputfile
open(my $fh, "<", "input.txt") or die "Ooops! No input.txt";

while (my $kn = <$fh>) {
	chomp ($kn); 
	my ($node, $child) = split /\)/, $kn;
	if ($node ~~ @planets) {
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
	} else {
		my $newnode = Tree::Simple->new($node);
		my $newchild = Tree::Simple->new($child);
		$newnode->addChild($newchild);
		$tree->addChild($newnode);
		push @planets, $node;
		push @planets, $child;
	}
	
}

close $fh;

#print DumpTree($tree);

my $count = 0;
my $count2 = 0;
$tree->traverse(
	sub {
		my ($this) = @_;
		$count += $this->getDepth();
		$count2++
		}
);

print "We have ", $tree->size() ," nodes.\n";
print "We have processed $count2 nodes\n";
print "We had ", scalar @planets, " Planets\n";

print "Total is: $count\n";
$tree->DESTROY;




