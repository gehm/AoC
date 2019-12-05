#!/usr/local/bin/perl

use strict;
use warnings;
use Data::Dumper;


print "Welcome to the Thermal Environment Supervision Terminal (TEST)\n";
print "DIAG Tool loaded....\n\n";

open(my $fh, "<", "input.txt") or die "Ooops! No input.txt";
my @int_prog = split(',', <$fh>);
close $fh;

my $debug = 0;
my $step = 0;
my $last;
my %errors;

while ( defined( $int_prog[$step] ) ) {
	
	my @opmode = get_modes(\@int_prog, $step) or die "Cant get opmodes\n";
	print "Processing: $step \n" if $debug;
	
	if ( $opmode[0] == 99 ) {
		print "TEST completed successfully with DIAG Code: $errors{($step - $last)}\n";
		print "EOP at $step\n";
		print Dumper \%errors if $debug;
		last;
	}
	$last = int (do_magic(\@int_prog, \@opmode, \%errors, $step ));
	$step = $step + $last;	
}

sub do_magic {
	 
	my $this_prog = shift;
	my $this_mode = shift;
	my $errors = shift;
	my $mystep = shift;
	
	#this_prog: [array_ref] working copy of input
	#this_mode: [array_ref] 
	#			0: opmode
	#			1-3: mode parm 1-3
	#errors: [hash_ref] error register
	#		 [step] -> [operation]
	my @params = (0,0,0,0 );
	my $opcode = $this_mode->[0];
	
	print "We have OPC: $opcode\n" if $debug;
	print Dumper $this_mode if $debug;
	
	
	print "Params are: \n" if $debug;
	print Dumper \@params if $debug;
	
	for (my $i = 1; $i <= 2; $i++) {
		# 0 == position mode
		# 1 == immediate mode
		if ( $this_mode->[$i]  eq "0" ) {
			print "Position Mode.... Param $i comes from $this_prog->[($mystep + $i)] value is $this_prog->[( $this_prog->[($mystep + $i)] )]\n" if $debug;
			$params[$i] = $this_prog->[( $this_prog->[($mystep + $i)] )];	
		} else {
			print "Immediate mode\n" if $debug ;
			$params[$i] = $this_prog->[($mystep + $i)];
		}	
	}
	$params[3] = $this_prog->[($mystep + 3)]; 
	
	
	if ($opcode == 1) {
		#Add
		$this_prog->[ $params[3] ] = $params[1] + $params[2];
		print "Addition: $params[1] + $params[2] written to $params[3] \n" if $debug;
		return 4;
		
	} elsif ($opcode == 2) {
		#Multiply
		$this_prog->[$params[3]] = $params[1] * $params[2];
		print "Multiply: $params[1] * $params[2] written to $params[3] \n" if $debug;
		return 4;
		
	} elsif ($opcode == 3) {
		# input (get user input)
		print "Please enter system ID to test: ";
		my $id = <STDIN>;
		chomp $id;
		$this_prog->[ $this_prog->[($mystep + 1)] ] = $id;
		print "Wrote $id to $this_prog->[($step + 1)]\n" if $debug;
		
		return 2;
		
	} elsif ($opcode == 4) {
		# output
		if ($params[1] == 0) {
			print "Part OK... \n";
		} else {
			#print "Part has ERROR! ($params[1])\n";
			$errors{$mystep} = $params[1]; 
		}
		return 2;
		
	} else {
		die "Unknown opcode: $opcode!\n";
	}
}

sub get_modes {
	my ($this_prog,$this_step) = @_;
	# ABCDE
	my @modes = ();
	# CD: Opcode ( x mod 1000 )
	push @modes, ($this_prog->[$this_step] % 100); #DE	
	
	my $mode = int($this_prog->[$this_step] / 100); # ABC or BC
	
	push @modes, ($mode % 10); #C
	$mode /= 10; #AB or B or 0
	push @modes, int($mode % 10);# B or 0
	push @modes, int($mode / 10);# A or 0
	return @modes;
}


