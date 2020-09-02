#!/usr/bin/perl
use strict;
use warnings;

sub Main {
	my $moveToLast = &HandleARGV;
	my $filename = "Runner/GeneratedPluginRegistrant.m";
	my @lines = &Parse($filename);
	my @output = &AdjustOrder(\@lines, $moveToLast);
	&Output($filename, \@output);
}

sub HandleARGV {
	my $moveToLast;
	if (scalar(@ARGV) == 2 && shift @ARGV eq "-last") {
		$moveToLast = shift @ARGV;
	}
	print "Target to last: ", $moveToLast, "\n";
	return $moveToLast;
}

sub AdjustOrder {
	my ($linesRef, $moveToLast) = @_;
	my @plugins;
	my @output;
	foreach (@$linesRef){
		if (/^\s*}\s*$/) {
			@plugins = sort @plugins;
	
			if (defined $moveToLast) {
				my ($pluginFound) = grep(/$moveToLast registerWithRegistrar:/, @plugins);
				print "Found: ", $pluginFound;
				if (defined $pluginFound) {
					@plugins = grep($_ ne $pluginFound, @plugins);
					push @plugins, $pluginFound;
				}
			}
						
			push @output, @plugins;
			push @output, $_;
		} elsif (/\[\w+ registerWithRegistrar:/) {
			push @plugins, $_;
		} else {
			push @output, $_;
		}
	}
	return @output;
}

sub Parse {
	my ($filename) = @_;
	open(FH, '<', $filename) or die $!;
	my @lines = <FH>;
	close(FH);
	return @lines;
}

sub Output {
	my ($filename, $outputRef) = @_;
	open(FH, '>', $filename) or die $!;
	print FH @$outputRef;
	close(FH);
}

&Main;
