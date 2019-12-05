#!/usr/local/bin/perl

use strict;
use warnings;
use Data::Dumper;

my $debug = 0;


print "\n--------------------------------------------------------------\n";
print "Welcome to the Thermal Environment Supervision Terminal (TEST)\n";
print "--------------------------------------------------------------\n";
print "-> DIAG Tool loaded. ID 42 \n\n";
print "-> DEBUG Mode enabled. You'll get alota output...\n" if $debug;
open(my $fh, "<", "input.txt") or die "Ooops! No input.txt";
my @int_prog = split(',', <$fh>);
close $fh;

my $step = 0;
my $jump;
my @errors;

while ( defined( $int_prog[$step] ) ) {
	print "[DEBUG] Pointer position: $step \n" if $debug;
	my @opmode = get_modes(\@int_prog, $step) or die "Cant get opmodes\n";
	
	if ( $opmode[0] == 99 ) {
		my $diagcode = pop @errors;
		print "Code stopped at pointer position $step\n";
		print "TEST completed successfully with DIAG Code: $diagcode \n";
		print "--------------------------------------------------------------\n";
		print "\n------ ERRRORS ------\n" if $debug;
		print "[DEBUG] ",join(",",@errors),"\n" if $debug;
		last;
	}
	
	$jump = int (do_magic(\@int_prog, \@opmode, \@errors, $step ));
	print "[DEBUG] Moving pointer $jump units to position ".($step + $jump)."\n"  if $debug;
	$step = $step + $jump;	
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
	my @params = (0,0,0,0);
	my $opcode = $this_mode->[0];
	
	print "[DEBUG] We have OPC: $opcode (" if $debug;
	print join(",",@$this_mode),")\n" if $debug;
	
	for (my $i = 1; $i <= 2; $i++) {
		# 0 == position mode
		# 1 == immediate mode
		if ( $this_mode->[$i]  eq "0" ) {
			print "[DEBUG] Position Mode.... Param $i comes from ",$this_prog->[($mystep + $i)], 
				  " value is ",$this_prog->[( $this_prog->[($mystep + $i)] )],"\n" if $debug;
			$params[$i] = $this_prog->[( $this_prog->[($mystep + $i)] )];	
		} else {
			print "[DEBUG] Immediate mode... Param $i comes from ",($mystep + $i),
				  " value is ",$this_prog->[($mystep + $i)],"\n" if $debug ;
			$params[$i] = $this_prog->[($mystep + $i)];
		}	
	}
	$params[3] = $this_prog->[($mystep + 3)]; 
	print "[DEBUG] Params are: " if $debug;
	print join(",",@params),"\n" if $debug;
	
	if ($opcode == 1) {
		#Add
		$this_prog->[ $params[3] ] = $params[1] + $params[2];
		print "[DEBUG] Addition: $params[1] + $params[2] written to $params[3] \n" if $debug;
		return 4;
		
	} elsif ($opcode == 2) {
		#Multiply
		$this_prog->[$params[3]] = $params[1] * $params[2];
		print "[DEBUG] Multiply: $params[1] * $params[2] written to $params[3] \n" if $debug;
		return 4;
		
	} elsif ($opcode == 3) {
		# input (get user input)
		print "Please enter system ID to test\n";
		print "1 - air conditioner unit\n";
		print "5 - thermal radiator controller\n";
		print "-> ";
		my $id = <STDIN>;
		chomp $id;
		$this_prog->[ $this_prog->[($mystep + 1)] ] = $id;
		print "[DEBUG] Wrote $id to $this_prog->[($step + 1)]\n" if $debug;
		
		return 2;
		
	} elsif ($opcode == 4) {
		# output
		if ($params[1] == 0) {
			print "Part OK... \n";
		} else {
			#print "Part has ERROR! ($params[1])\n";
			push @$errors, $params[1]; 
		}
		return 2;
	} elsif ($opcode == 5) {
		# Jump if true
		if ( $params[1] ne "0" ) {
			# Step next step is param 2
			my $nextstep = $params[2] - $mystep; 
			return $nextstep;
		}
		return 3;
	} elsif ($opcode == 6) {
		# Jump if false
		if ( $params[1] eq "0" ) {
			# Step next step is param 2
			my $nextstep = $params[2] - $mystep; 
			return $nextstep;
		}
		return 3;
		
	} elsif ($opcode == 7) {
		# Less then
		if ( $params[1] < $params[2] ) {
			$this_prog->[$params[3]] = 1;
			print "[DEBUG] Less: Wrote 1 to $params[3]\n" if $debug;
		} else {
			$this_prog->[$params[3]] = 0;
			print "[DEBUG] Not Less: Wrote 0 to $params[3]\n" if $debug;	
		}
		return 4;
		
	} elsif ($opcode == 8) {
		# Equals
		if ( $params[1] eq $params[2] ) {
			$this_prog->[$params[3]] = 1;
			print "[DEBUG] Eql: Wrote 1 to $params[3]\n" if $debug;
		} else {
			print "[DEBUG] Not eql: Wrote 1 to $params[3]\n" if $debug;
			$this_prog->[$params[3]] = 0;
		}
		return 4;
	} else {
		die "Unknown opcode: $opcode!\n";
	}
}

sub get_modes {
    print "Getting modes.....\n" if $debug;
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


