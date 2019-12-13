#!/usr/local/bin/perl

package IntComp;

use strict;
use warnings;
use Data::Dumper;
use threads::shared;

my $debug = 0;

sub run {
	my ($step, $run, $rel_base) = 0;
	my $jump;
	my @output;
	my $diagcode;
	my $in_queue = shift;
	my $pass_prog = shift;
	my $out_queue = shift; 
	my $name = shift;
	
	my @int_prog = @{$pass_prog};
	push @int_prog, "0" x 1024; 

	while ( defined( $int_prog[$step] ) ) {
		print "[DEBUG $name] ----------------- RUN $run --------------------\n" if $debug; 
		print "[DEBUG $name] Pointer position: $step \n" if $debug;
		my @opmode = get_modes(\@int_prog, $step) or die "Cant get opmodes\n";
		if ($opmode[0] == 99) {
			print "[DEBUG $name] Code 99 quitting...\n" if $debug;
			 return pop @output;
			 threads->exit();
		 }
		$jump = int (do_magic(\@int_prog, \@opmode, \@output, $in_queue , $step, \$rel_base ));
		$step = $step + $jump;
		print "[DEBUG $name] Moving pointer $jump units to position $step\n"  if $debug;

		
		$run++;
	}

	sub do_magic {
		 
		my $this_prog = shift;
		my $this_mode = shift;
		my $errors = shift;
		my $queue = shift;
		my $mystep = shift;
		my $rel_base= shift;
		
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
				print "[DEBUG $name] Position Mode.... ",
				      "Param $i comes from ",$this_prog->[($mystep + $i)], 
					  " value is ",$this_prog->[( $this_prog->[($mystep + $i)] )],"\n" if $debug;
				$params[$i] = $this_prog->[( $this_prog->[($mystep + $i)] )];	
			
			} elsif ( $this_mode->[$i]  eq "1" ) {
				print "[DEBUG $name] Immediate mode... ",
				      "Param $i comes from ",($mystep + $i),
					  " value is ",$this_prog->[($mystep + $i)],"\n" if $debug ;
					  
				$params[$i] = $this_prog->[($mystep + $i)];
				
			} elsif ( $this_mode->[$i]  eq "2" ) {
				print "[DEBUG $name] Relative mode... ",
					  "Relativ Base is $rel_base ",
				       "Param $i comes from ",$this_prog->[($rel_base + ($mystep + $i))], 
					  " value is ",$this_prog->[( $this_prog->[($rel_base + ($mystep + $i))] )],"\n" if $debug;
					  
				$params[$i] = $this_prog->[( $this_prog->[($rel_base + ($mystep + $i))] )];
				
			} else {
				die "No such mode!";
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
			push @output, $params[1];
			$out_queue->enqueue( $params[1] );
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
		} elsif ($opcode == 9) {
			# Adjust relative base
			$rel_base += $params[1];
			return 2;
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
