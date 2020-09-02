#!/usr/bin/perl
use strict;
use warnings;

my @moveToLast = @ARGV;

my $filename = "Runner/GeneratedPluginRegistrant.m";
open(FH, '<', $filename) or die $!;
my @lines = <FH>;
close(FH);

my @plugins;
my @output;

foreach (@lines){
	if (/^\s*}\s*$/) {
		@plugins = sort @plugins;

		foreach my $name (@moveToLast) {
			my ($pluginFound) = grep(/$name registerWithRegistrar:/, @plugins);
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

open(FH, '>', $filename) or die $!;
print FH @output;
close(FH);
