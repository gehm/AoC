#!/usr/local/bin/perl

package IntComp;

use strict;
use warnings;
use Data::Dumper;
use threads::shared;

my $debug = 1;

sub run {
	my ($step, $run) = 0;
	my $jump;
	my @errors;
	my @errors_old;
	my $diagcode;
	my $in_queue = shift;
	my $pass_prog = shift;
	my $out_queue = shift; 
	my $name = shift;
	
	my @int_prog = @{$pass_prog};

	while ( defined( $int_prog[$step] ) ) {
		print "[DEBUG $name] ----------------- RUN $run --------------------\n" if $debug; 
		print "[DEBUG $name] Pointer position: $step \n" if $debug;
		my @opmode = get_modes(\@int_prog, $step) or die "Cant get opmodes\n";
		if ($opmode[0] == 99) {
			threads->exit();
		}
		$jump = int (do_magic(\@int_prog, \@opmode, \@errors, $in_queue , $step ));
		$step = $step + $jump;
		print "[DEBUG $name] Moving pointer $jump units to position $step\n"  if $debug;

		my @nextop = get_modes(\@int_prog, $step); # Check next Code!!!!
		
		if ( $nextop[0] == 99 ) {
			print "Next will be Code 99 on $name\n" if $debug ;
			$diagcode = pop @errors_old;
			print "--------> OUT: $diagcode\n" if $debug;
			$out_queue->enqueue( $diagcode );
			return $diagcode;
			last;
		} 
		if (@errors ) { 
			my $output = pop @errors;
			print "$name is passing $output to next node\n" if $debug;
			push @errors_old, $output;
			$out_queue->enqueue( $output );
		}
		$run++;
	}

	sub do_magic {
		 
		my $this_prog = shift;
		my $this_mode = shift;
		my $errors = shift;
		my $queue = shift;
		my $mystep = shift;
		
		#this_prog: [array_ref] working copy of input
		#this_mode: [array_ref] 
		#			0: opmode
		#			1-3: mode parm 1-3
		#errors: [hash_ref] error register
		#		 [step] -> [operation]
		my @params = (0,0,0,0);
		my $opcode = $this_mode->[0];
		
		print "[DEBUG $name] We have OPC: $opcode (" if $debug;
		print join(",",@$this_mode),")\n" if $debug;
		
		for (my $i = 1; $i <= 2; $i++) {
			# 0 == position mode
			# 1 == immediate mode
			if ( $this_mode->[$i]  eq "0" ) {
				print "[DEBUG $name] Position Mode.... Param $i comes from ",$this_prog->[($mystep + $i)], 
					  " value is ",$this_prog->[( $this_prog->[($mystep + $i)] )],"\n" if $debug;
				$params[$i] = $this_prog->[( $this_prog->[($mystep + $i)] )];	
			} else {
				print "[DEBUG $name] Immediate mode... Param $i comes from ",($mystep + $i),
					  " value is ",$this_prog->[($mystep + $i)],"\n" if $debug ;
				$params[$i] = $this_prog->[($mystep + $i)];
			}	
		}
		$params[3] = $this_prog->[($mystep + 3)]; 
		print "[DEBUG $name] Params are: " if $debug;
		print join(",",@params),"\n" if $debug;
		
		if ($opcode == 1) {
			#Add
			$this_prog->[ $params[3] ] = $params[1] + $params[2];
			print "[DEBUG $name] Addition: $params[1] + $params[2] written to $params[3] \n" if $debug;
			return 4;
			
		} elsif ($opcode == 2) {
			#Multiply
			$this_prog->[$params[3]] = $params[1] * $params[2];
			print "[DEBUG $name] Multiply: $params[1] * $params[2] written to $params[3] \n" if $debug;
			return 4;
			
		} elsif ($opcode == 3) {
			# input (get user input)
			my $id = $in_queue->dequeue();
			chomp $id;
			$this_prog->[ $this_prog->[($mystep + 1)] ] = $id;
			print "[DEBUG $name] INPUT: Wrote $id to $this_prog->[($step + 1)]\n" if $debug;
			
			return 2;
			
		} elsif ($opcode == 4) {
			# output
			if ($params[1] == 0) {
				 push @$errors, "0"; 
			 } else {
				 push @$errors, $params[1]; 
			 }
			print "[DEBUG $name] OUTPUT ", $params[1],"\n" if $debug;
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
				print "[DEBUG $name] Less: Wrote 1 to $params[3]\n" if $debug;
			} else {
				$this_prog->[$params[3]] = 0;
				print "[DEBUG $name] Not Less: Wrote 0 to $params[3]\n" if $debug;	
			}
			return 4;
			
		} elsif ($opcode == 8) {
			# Equals
			if ( $params[1] eq $params[2] ) {
				$this_prog->[$params[3]] = 1;
				print "[DEBUG $name] Eql: Wrote 1 to $params[3]\n" if $debug;
			} else {
				print "[DEBUG $name] Not eql: Wrote 1 to $params[3]\n" if $debug;
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
}
1;
