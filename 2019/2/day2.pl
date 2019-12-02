#!/usr/local/bin/perl

use strict;
use warnings;

my ($noun,$verb);

$noun = 0;

while ($noun < 100) {
	$verb = 0;
	if (runprog($noun,$verb) == 19690720) {
		print "Noun: $noun Verb: $verb\n";
	}
	
	while($verb < 100) {
		if (runprog($noun,$verb) == 19690720) {
		print "Noun: $noun Verb: $verb\n";
	}
		$verb++;
	}
	$noun++;
}

sub runprog {
    my $step = 0;
	my ($noun,$verb) = @_;
	
	open(my $fh, "<", "input.txt") or die "Ooops! No input.txt";
    my @int_prog = split /,/, <$fh>;
	close $fh;
	
	$int_prog[1] = $noun;
	$int_prog[2] = $verb;
	
	while ( defined($int_prog[$step]) ) {
		my $opcode = $int_prog[$step];
		last if $opcode == 99;
		#print "Step: $step Opcode: $opcode \n";
		domagic(\@int_prog, $opcode, $int_prog[$step + 1], $int_prog[$step + 2], $int_prog[$step + 3] );
		$step += 4;	
	}
	return $int_prog[0];
}

sub domagic {
	 
	my ($this_prog,$opcode,$int1,$int2,$outpos) = @_;
	
	if ($opcode == 1) {
		$this_prog->[$outpos] = $this_prog->[$int1] + $this_prog->[$int2];
	} elsif ($opcode == 2) {
		$this_prog->[$outpos] = $this_prog->[$int1] * $this_prog->[$int2];
	} else {
		die "Unknown opcode: $opcode!\n";
	}
}



