#!/usr/bin/perl -w

#====================================================================================================================================================#
#<use>
$|++; #---turn on the auto flush for the progress bar
use strict;
use File::Path;
use Time::HiRes qw( time );
use Getopt::Long;
use File::Basename;
use File::Spec::Functions qw(rel2abs);
use Cwd 'abs_path';
#<\use>
#====================================================================================================================================================#

#====================================================================================================================================================#
#<doc>
#
#	Description
#		This is a Perl script to tidy-up the subroutines of another perl script written in a custom format. It will copy the subroutines into a folder for future use.
#
#	Input

#	Usage
#		perl perlScriptCleaner_v0.1.pl /Volumes/A_MPro2TB/softwareForNGS/myPerlScripts/general/perlScriptCleaner/v0.1/perlScriptCleaner_v0.1.pl
#
#	Output
#
#<\doc>
#====================================================================================================================================================#

#====================================================================================================================================================#
#<lastCmdCalled>
#
#	[2013-09-17 14:20]	/Volumes/A_MPro2TB/softwareForNGS/myPerlScripts/general/perlScriptCleaner/v0.1/perlScriptCleaner_v0.1.pl /Volumes/A_MPro2TB/softwareForNGS/myPerlScripts/general/perlScriptCleaner/v0.1/perlScriptCleaner_v0.1.pl
#
#<\lastCmdCalled>
#====================================================================================================================================================#

#====================================================================================================================================================#
#<global>
#<\global>
#====================================================================================================================================================#

#====================================================================================================================================================#
{	#Main sections lexical scope starts
#====================================================================================================================================================#

#====================================================================================================================================================#
#	section 0_startingTask
#	primaryDependOnSub: printCMDLogOrFinishMessage|754
#	secondaryDependOnSub: currentTime|400, reportStatus|1025
#
#<section ID="startingTask" num="0">
&printCMDLogOrFinishMessage("CMDLog");#->754
#<\section>
#====================================================================================================================================================#

#====================================================================================================================================================#
#	section 1_readInputScript
#	primaryDependOnSub: getInputPerlScriptAndBackup|450
#	secondaryDependOnSub: checkInputFiles|304, reportStatus|1025
#
#<section ID="readInputScript" num="1">
my $pathToRead = $ARGV[0];
my ($inScriptAry_ref, $inputPath) = &getInputPerlScriptAndBackup($pathToRead);#->450
#<\section>
#====================================================================================================================================================#

#====================================================================================================================================================#
#	section 2_hardCodedParameters
#	primaryDependOnSub: >none
#	secondaryDependOnSub: >none
#
#<section ID="hardCodedParameters" num="2">
my $IDPrefix = ">";
#<\section>
#====================================================================================================================================================#

#====================================================================================================================================================#
#	section 3_defineOutDirPath
#	primaryDependOnSub: >none
#	secondaryDependOnSub: >none
#
#<section ID="defineOutDirPath" num="3">
my @mkDirAry;
my $scriptDirPath = dirname(rel2abs($0));
my $subroutineDir = "$scriptDirPath/subroutine/"; push @mkDirAry, $subroutineDir;
foreach my $dir (@mkDirAry) {system ("mkdir -pm 777 $dir");}
#<\section>
#====================================================================================================================================================#

#====================================================================================================================================================#
#	section 4_getOtherInfo
#	primaryDependOnSub: getDefinedSubroutineCategories|419, getLastCalledCmd|575
#	secondaryDependOnSub: >none
#
#<section ID="getOtherInfo" num="4">
my ($lastCmdCalled) = &getLastCalledCmd($pathToRead);#->575
my ($definedSubCtgryHsh_ref) = &getDefinedSubroutineCategories($subroutineDir);#->419
#<\section>
#====================================================================================================================================================#

#====================================================================================================================================================#
#	section 5_getSectionSubIndex
#	primaryDependOnSub: getItemIndex|488
#	secondaryDependOnSub: reportStatus|1025
#
#<section ID="getSectionSubIndex" num="5">
my ($intitialItemAry_ref, $intitialItemIndexHsh_ref, $sectionIndexHsh_ref, $subroutineIndexHsh_ref, $subCtgryHsh_ref) = &getItemIndex($inScriptAry_ref);#->488
#<\section>
#====================================================================================================================================================#

#====================================================================================================================================================#
#	section 6_checkSubCallFormat
#	primaryDependOnSub: addAndSignToInTextSubroutine|209, checkMissingSubroutine|320
#	secondaryDependOnSub: reportStatus|1025
#
#<section ID="checkSubCallFormat" num="6">
&addAndSignToInTextSubroutine($inScriptAry_ref, $subroutineIndexHsh_ref);#->209
&checkMissingSubroutine($inScriptAry_ref, $subroutineIndexHsh_ref);#->320
#<\section>
#====================================================================================================================================================#

#====================================================================================================================================================#
#	section 7_getDependency
#	primaryDependOnSub: getSectionSubDependency|604, getSubrountineCategory|661, getSubrountineInAndOut|717
#	secondaryDependOnSub: recursiveSubroutineDependencySearch|953
#
#<section ID="getDependency" num="7">
my ($subroutineDependencyHsh_ref, $sectionDependencyHsh_ref) = &getSectionSubDependency($inScriptAry_ref, $sectionIndexHsh_ref, $subroutineIndexHsh_ref, $IDPrefix);#->604
my ($subroutineInOutHsh_ref) = &getSubrountineInAndOut($subroutineIndexHsh_ref, $inScriptAry_ref);#->717
my ($subCtgryOutputLineAry_ref) = &getSubrountineCategory($subroutineIndexHsh_ref, $inScriptAry_ref, $subCtgryHsh_ref, $definedSubCtgryHsh_ref);#->661
#<\section>
#====================================================================================================================================================#

#====================================================================================================================================================#
#	section 8_outputCleanedScript
#	primaryDependOnSub: addLineNumberToCleanScript|236, checkSubroutineInOutputInMainText|345, printCleanScript|787, pushCleanedScriptIntoAry|807
#	secondaryDependOnSub: reportStatus|1025
#
#<section ID="outputCleanedScript" num="8">
my ($cleanScriptAry_ref, $sectionSubLineNumHsh_ref, $subroutineFinalTextHsh_ref) = &pushCleanedScriptIntoAry($subroutineDependencyHsh_ref, $sectionDependencyHsh_ref, $inScriptAry_ref, $sectionIndexHsh_ref, $subroutineIndexHsh_ref, $subroutineInOutHsh_ref, $intitialItemAry_ref, $intitialItemIndexHsh_ref, $IDPrefix, $lastCmdCalled, $subCtgryHsh_ref, $subCtgryOutputLineAry_ref);#->807
my ($subroutineCallLineHsh_ref, $uncalledSubHsh_ref) = &addLineNumberToCleanScript($cleanScriptAry_ref, $sectionSubLineNumHsh_ref, $IDPrefix, $subroutineIndexHsh_ref);#->236
&checkSubroutineInOutputInMainText($subroutineCallLineHsh_ref, $subroutineInOutHsh_ref, $cleanScriptAry_ref);#->345
&printCleanScript($inputPath, $cleanScriptAry_ref);#->787
#<\section>
#====================================================================================================================================================#

#====================================================================================================================================================#
#	section 9_warnings
#	primaryDependOnSub: warnUncalledSubroutinerm|1046
#	secondaryDependOnSub: reportStatus|1025
#
#<section ID="warnings" num="9">
&warnUncalledSubroutinerm($subroutineDependencyHsh_ref, $uncalledSubHsh_ref);#->1046
#<\section>
#====================================================================================================================================================#

#====================================================================================================================================================#
#	section 10_recordTheSubroutines
#	primaryDependOnSub: removeDeletedSubroutineFromSubroutineDir|978, writeSubroutineToExternalDir|1081
#	secondaryDependOnSub: currentTime|400
#
#<section ID="recordTheSubroutines" num="10">
&writeSubroutineToExternalDir($subroutineFinalTextHsh_ref, $inputPath, $subroutineDir, $subCtgryHsh_ref);#->1081
&removeDeletedSubroutineFromSubroutineDir($subroutineDir, $inputPath, $subroutineFinalTextHsh_ref);#->978
#<\section>
#====================================================================================================================================================#

#====================================================================================================================================================#
#	section 11_finishingTask
#	primaryDependOnSub: printCMDLogOrFinishMessage|754
#	secondaryDependOnSub: currentTime|400, reportStatus|1025
#
#<section ID="finishingTask" num="11">
&printCMDLogOrFinishMessage("finishMessage");#->754
#<\section>
#====================================================================================================================================================#

#====================================================================================================================================================#
}	#Main sections lexical scope ends
#====================================================================================================================================================#

#====================================================================================================================================================#
#List of subroutines by category
#
#	general [n=4]:
#		checkInputFiles, currentTime, printCMDLogOrFinishMessage
#		reportStatus
#
#	reporting [n=1]:
#		currentTime
#
#	specific [n=17]:
#		addAndSignToInTextSubroutine, addLineNumberToCleanScript, checkMissingSubroutine
#		checkSubroutineInOutputInMainText, getDefinedSubroutineCategories, getInputPerlScriptAndBackup
#		getItemIndex, getLastCalledCmd, getSectionSubDependency
#		getSubrountineCategory, getSubrountineInAndOut, printCleanScript
#		pushCleanedScriptIntoAry, recursiveSubroutineDependencySearch, removeDeletedSubroutineFromSubroutineDir
#		warnUncalledSubroutinerm, writeSubroutineToExternalDir
#
#====================================================================================================================================================#

sub addAndSignToInTextSubroutine {
#....................................................................................................................................................#
#	subroutineCategory: specific
#	dependOnSub: reportStatus|1025
#	appearInSub: >none
#	primaryAppearInSection: 6_checkSubCallFormat|118
#	secondaryAppearInSection: >none
#	input: $inScriptAry_ref, $subroutineIndexHsh_ref
#	output: none
#	toCall: &addAndSignToInTextSubroutine($inScriptAry_ref, $subroutineIndexHsh_ref);
#	calledInLine: 123
#....................................................................................................................................................#
	
	my ($inScriptAry_ref, $subroutineIndexHsh_ref) = @_;

	&reportStatus("Check subroutines calling in section", 20, "\n");#->1025
	
	foreach my $i (0..$#{$inScriptAry_ref}) {
		next if ($inScriptAry_ref->[$i] =~ m/^#/); 
		foreach my $subID (keys %{$subroutineIndexHsh_ref}) {
			next if ($inScriptAry_ref->[$i] !~ m/$subID/); 
			if ($inScriptAry_ref->[$i] !~ m/^sub/ and $inScriptAry_ref->[$i] !~ m/^\#/ and ($inScriptAry_ref->[$i] =~ m/[^\&]$subID/ or $inScriptAry_ref->[$i] =~ m/^$subID/)) {
				$inScriptAry_ref->[$i] =~ s/\&*$subID/\&$subID/g;
			}
		}
	}
}
sub addLineNumberToCleanScript {
#....................................................................................................................................................#
#	subroutineCategory: specific
#	dependOnSub: reportStatus|1025
#	appearInSub: >none
#	primaryAppearInSection: 8_outputCleanedScript|141
#	secondaryAppearInSection: >none
#	input: $IDPrefix, $cleanScriptAry_ref, $sectionSubLineNumHsh_ref, $subroutineIndexHsh_ref
#	output: $subroutineCallLineHsh_ref, $uncalledSubHsh_ref
#	toCall: my ($subroutineCallLineHsh_ref, $uncalledSubHsh_ref) = &addLineNumberToCleanScript($cleanScriptAry_ref, $sectionSubLineNumHsh_ref, $IDPrefix, $subroutineIndexHsh_ref);
#	calledInLine: 147
#....................................................................................................................................................#
	
	my ($cleanScriptAry_ref, $sectionSubLineNumHsh_ref, $IDPrefix, $subroutineIndexHsh_ref) = @_;

	my $subroutineCallLineHsh_ref = {};

	&reportStatus("Adding line number to cleaned script", 20, "\n");#->1025

	#---remove previously annotated line num at line end
	foreach my $i (0..$#{$cleanScriptAry_ref}) {
		$cleanScriptAry_ref->[$i] =~ s/(\#->\d+)+$//;
	}

	#---add the line number of the sub and section
	foreach my $ID (keys %{$sectionSubLineNumHsh_ref}) {

		my $lineNum = $sectionSubLineNumHsh_ref->{$ID};
		foreach my $i (0..$#{$cleanScriptAry_ref}) {
			
			#add line number in the comment
			if ($cleanScriptAry_ref->[$i] =~ m/$IDPrefix$ID/ and $cleanScriptAry_ref->[$i] =~ m/^\#/) {
				$cleanScriptAry_ref->[$i] =~ s/$IDPrefix$ID/$ID\|$lineNum/;
				
			}
			
			#add line number of to the sub at section line where it was called
			if (exists $subroutineIndexHsh_ref->{$ID}) {#---the ID is sub but not section
				if (($cleanScriptAry_ref->[$i] =~ m/\&$ID *[\(]/ or $cleanScriptAry_ref->[$i] =~ m/\\\&$ID *[\,]/) and $cleanScriptAry_ref->[$i] !~ m/^#/) {
					chomp $cleanScriptAry_ref->[$i];
					$cleanScriptAry_ref->[$i] .= "#->$lineNum\n";
					$subroutineCallLineHsh_ref->{$ID}{$i+1}++;
				}
			}
		}
	}
	
	my $uncalledSubHsh_ref = {};
	
	#---add line num of the sub being called
	foreach my $subID (sort {$a cmp $b} keys %{$subroutineIndexHsh_ref}) {
		my $calledInLine = 'none';
		$calledInLine = join ", ", (sort {$a <=> $b} keys %{$subroutineCallLineHsh_ref->{$subID}}) if exists $subroutineCallLineHsh_ref->{$subID};
		my $searchString = "#\t$subID calledInLine: ";
		foreach my $i (0..$#{$cleanScriptAry_ref}) {
			#add line number in the comment
			if ($cleanScriptAry_ref->[$i] =~ m/^$searchString/) {
				$cleanScriptAry_ref->[$i] =~ s/$searchString/#\tcalledInLine: $calledInLine/;
			}
		}
		if ($calledInLine eq 'none') {
			$uncalledSubHsh_ref->{$subID}++;
		}
	}
	
	return ($subroutineCallLineHsh_ref, $uncalledSubHsh_ref);
	
}
sub checkInputFiles {
#....................................................................................................................................................#
#	subroutineCategory: general
#	dependOnSub: >none
#	appearInSub: getInputPerlScriptAndBackup|450
#	primaryAppearInSection: >none
#	secondaryAppearInSection: 1_readInputScript|63
#	input: $fileToCheck
#	output: none
#	toCall: &checkInputFiles($fileToCheck);
#	calledInLine: 469
#....................................................................................................................................................#
	my ($fileToCheck) = @_;
	
	die "$fileToCheck does not exist\n" if not -s $fileToCheck;
}
sub checkMissingSubroutine {
#....................................................................................................................................................#
#	subroutineCategory: specific
#	dependOnSub: reportStatus|1025
#	appearInSub: >none
#	primaryAppearInSection: 6_checkSubCallFormat|118
#	secondaryAppearInSection: >none
#	input: $inScriptAry_ref, $subroutineIndexHsh_ref
#	output: none
#	toCall: &checkMissingSubroutine($inScriptAry_ref, $subroutineIndexHsh_ref);
#	calledInLine: 124
#....................................................................................................................................................#

	my ($inScriptAry_ref, $subroutineIndexHsh_ref) = @_;
	
	&reportStatus("Check missing subroutines", 20, "\n");#->1025
	
	foreach my $i (0..$#{$inScriptAry_ref}) {
		if ($inScriptAry_ref->[$i] =~ m/&(\w+)/) {
			if (not defined $subroutineIndexHsh_ref->{$1} and length $1 > 1) {
				&reportStatus("!!!---WARNING---!!! subroutine $1 seems to be missing", 20, "\n");#->1025
			}
		}
	}
}
sub checkSubroutineInOutputInMainText {
#....................................................................................................................................................#
#	subroutineCategory: specific
#	dependOnSub: reportStatus|1025
#	appearInSub: >none
#	primaryAppearInSection: 8_outputCleanedScript|141
#	secondaryAppearInSection: >none
#	input: $cleanScriptAry_ref, $subroutineCallLineHsh_ref, $subroutineInOutHsh_ref
#	output: 
#	toCall: &checkSubroutineInOutputInMainText($subroutineCallLineHsh_ref, $subroutineInOutHsh_ref, $cleanScriptAry_ref);
#	calledInLine: 148
#....................................................................................................................................................#

	my ($subroutineCallLineHsh_ref, $subroutineInOutHsh_ref, $cleanScriptAry_ref) = @_;
	
	&reportStatus("Checking variable input ouput numbers being called in subroutines", 20, "\n");#->1025

	#---go thr all lines
	foreach my $subID (keys %{$subroutineInOutHsh_ref}) {
		my %tmpSubInOutVarNumHsh = ();
		foreach my $inputOrOutput (qw/input output/) {
			$tmpSubInOutVarNumHsh{$inputOrOutput} = 0;
			$tmpSubInOutVarNumHsh{$inputOrOutput} = keys %{$subroutineInOutHsh_ref->{$subID}{$inputOrOutput}} if not exists $subroutineInOutHsh_ref->{$subID}{$inputOrOutput}{'none'};
		}

		foreach my $calledLine (sort keys %{$subroutineCallLineHsh_ref->{$subID}}) {
			
			#---skip the subroutine called as reference
			next if $cleanScriptAry_ref->[$calledLine-1] =~ m/\\\&$subID/;
			
			my %tmpInlineInOutVarNumHsh = ();
			$tmpInlineInOutVarNumHsh{$_} = 0 foreach (qw/input output/);
			
			if ($cleanScriptAry_ref->[$calledLine-1] =~ m/m*y* *\(* *([\|\/\#\!\(\)\_\$\@\%\w\d\s\,\'\[\]\"\-\{\}\>\<\\\.\=\+\:]+) *\)* *= *\&*$subID/) {
				my @tmpAry = split / *, */, $1;
				$tmpInlineInOutVarNumHsh{'output'} += @tmpAry;
			}
			
			if ($cleanScriptAry_ref->[$calledLine-1] =~ m/$subID *\( *([\|\/\#\!\(\)\_\$\@\%\w\d\s\,\'\[\]\"\-\{\}\>\<\\\.\=\+\:]+) *\) *;*/) {
				my @tmpAry = split / *, */, $1;
				$tmpInlineInOutVarNumHsh{'input'} += @tmpAry;
			}
			
			foreach my $inputOrOutput (qw/input output/) {
				if ($tmpSubInOutVarNumHsh{$inputOrOutput} != $tmpInlineInOutVarNumHsh{$inputOrOutput}) {
					if (not ($tmpSubInOutVarNumHsh{'output'} == 1 and $tmpInlineInOutVarNumHsh{'output'} == 0)) {#---exclude the subroutine like current time, returns a scalar but not collected
						&reportStatus("!!!---WARNING---!!! $inputOrOutput var of $subID in line $calledLine might be wrong", 20, "\n");#->1025
					}
				}
			}
		}
	}
	
	return ();
}
sub currentTime {
#....................................................................................................................................................#
#	subroutineCategory: general, reporting
#	dependOnSub: >none
#	appearInSub: printCMDLogOrFinishMessage|754, reportStatus|1025, writeSubroutineToExternalDir|1081
#	primaryAppearInSection: >none
#	secondaryAppearInSection: 0_startingTask|53, 10_recordTheSubroutines|164, 11_finishingTask|175
#	input: none
#	output: $runTime
#	toCall: my ($runTime) = &currentTime();
#	calledInLine: 774, 1041, 1159
#....................................................................................................................................................#
	
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);
	my $runTime = sprintf "%04d-%02d-%02d %02d:%02d", $year+1900, $mon+1,$mday,$hour,$min;	
	
	return ($runTime);

}
sub getDefinedSubroutineCategories {
#....................................................................................................................................................#
#	subroutineCategory: specific
#	dependOnSub: >none
#	appearInSub: >none
#	primaryAppearInSection: 4_getOtherInfo|97
#	secondaryAppearInSection: >none
#	input: $subroutineDir
#	output: $definedSubCtgryHsh_ref
#	toCall: my ($definedSubCtgryHsh_ref) = &getDefinedSubroutineCategories($subroutineDir);
#	calledInLine: 103
#....................................................................................................................................................#
	my ($subroutineDir) = @_;
	
	my $definedSubCtgryHsh_ref = {};
	opendir (SUBDIR, "$subroutineDir/bySub/");
	while (my $existingCtgry = readdir(SUBDIR)) {
		next if $existingCtgry =~ /^\./;
		opendir (CTGRYDIR, "$subroutineDir/bySub/$existingCtgry/");
		while (my $subID = readdir(CTGRYDIR)) {
			next if $subID =~ /^\./;
			if ($existingCtgry ne 'unassigned') {
				push @{$definedSubCtgryHsh_ref->{$subID}}, $existingCtgry;
			}
		}
		close CTGRYDIR;
	}
	close SUBDIR;

	return ($definedSubCtgryHsh_ref);
}
sub getInputPerlScriptAndBackup {
#....................................................................................................................................................#
#	subroutineCategory: specific
#	dependOnSub: checkInputFiles|304, reportStatus|1025
#	appearInSub: >none
#	primaryAppearInSection: 1_readInputScript|63
#	secondaryAppearInSection: >none
#	input: $pathToRead
#	output: $inScriptAry_ref, $pathToRead
#	toCall: my ($inScriptAry_ref, $pathToRead) = &getInputPerlScriptAndBackup($pathToRead);
#	calledInLine: 69
#....................................................................................................................................................#

	my ($pathToRead) = @_;
	
	if ($pathToRead eq 'itself') {
		$pathToRead = abs_path($0);
		&reportStatus("Alright. I am cleaning myself now", 20, "\n");#->1025
	}
	
	&checkInputFiles($pathToRead);#->304
	
	my $inScriptAry_ref = ();
	open (INSCRIPT, "<", $pathToRead);
	@{$inScriptAry_ref} = (<INSCRIPT>);
	close INSCRIPT;
	
	#---push some line to the end for the new subRoutine to take
	push @{$inScriptAry_ref} ,"\n";#--- aryIndex $#inScriptAry_ref-4
	push @{$inScriptAry_ref} ,"\tmy () = \@\_;\n";
	push @{$inScriptAry_ref} ,"\t\n";
	push @{$inScriptAry_ref} ,"\n\treturn ();\n";
	push @{$inScriptAry_ref} ,"\n";#--- aryIndex $#inScriptAry_ref
	
	&reportStatus("$#{$inScriptAry_ref} lines read", 20, "\n");#->1025
	system ("cp -f $pathToRead $pathToRead.clean.bak");
	return ($inScriptAry_ref, $pathToRead);
}
sub getItemIndex {
#....................................................................................................................................................#
#	subroutineCategory: specific
#	dependOnSub: reportStatus|1025
#	appearInSub: >none
#	primaryAppearInSection: 5_getSectionSubIndex|108
#	secondaryAppearInSection: >none
#	input: $inScriptAry_ref
#	output: $intitialItemAry_ref, $intitialItemIndexHsh_ref, $sectionIndexHsh_ref, $subCtgryHsh_ref, $subroutineIndexHsh_ref
#	toCall: my ($intitialItemAry_ref, $intitialItemIndexHsh_ref, $sectionIndexHsh_ref, $subroutineIndexHsh_ref, $subCtgryHsh_ref) = &getItemIndex($inScriptAry_ref);
#	calledInLine: 113
#....................................................................................................................................................#
	
	my ($inScriptAry_ref) = @_;
	
	#---get the intitial item index
	my $intitialItemAry_ref = ();
	my $subCtgryHsh_ref = ();
	
	@{$intitialItemAry_ref} = qw/use doc global/;
	my $intitialItemIndexHsh_ref = {};
	foreach my $intitialItem (@{$intitialItemAry_ref}) {
		foreach my $i (0..$#{$inScriptAry_ref}) {
			$intitialItemIndexHsh_ref->{$intitialItem}{'start'} = $i if $inScriptAry_ref->[$i] =~ m/^#<$intitialItem>/;
			$intitialItemIndexHsh_ref->{$intitialItem}{'end'} = $i if $inScriptAry_ref->[$i] =~ m/^#<\\$intitialItem>/;
		}
	}
	my @tmpKeyAry = keys %{$intitialItemIndexHsh_ref}; 
	&reportStatus("items: @tmpKeyAry found", 20, "\n");#->1025
	
	#---get the section index
	my $sectionNum = 0;
	my $sectionIndexHsh_ref = {};
	foreach my $i (0..$#{$inScriptAry_ref}) {
		if ($inScriptAry_ref->[$i] =~ m/^#<section ID="([^\"]+)"/) {
			$sectionIndexHsh_ref->{$sectionNum}{'start'} = $i;
			$sectionIndexHsh_ref->{$sectionNum}{'ID'} = $1;
		}
		
		if ($inScriptAry_ref->[$i] =~ m/^#<\\section>/) {
			$sectionIndexHsh_ref->{$sectionNum}{'end'} = $i;
			$sectionNum++;
		}
	}
	my $numSection = keys %{$sectionIndexHsh_ref};
	&reportStatus("$numSection sections found", 20, "\n");#->1025
	
	#---get the subroutine index
	my $subID;
	my $subroutineIndexHsh_ref = {};
	foreach my $i (0..$#{$inScriptAry_ref}) {
		if ($inScriptAry_ref->[$i] =~ m/^sub +(\w+) *\{/) {
			$subID = $1;
			$subroutineIndexHsh_ref->{$subID}{'start'} = $i;
			@{$subCtgryHsh_ref->{$subID}} = qw/unassigned/;
		}
		
		if ($inScriptAry_ref->[$i] =~ m/#make (\w+) ([\w|_|-]+)/) {
			$subroutineIndexHsh_ref->{$1}{'start'} = $#{$inScriptAry_ref}-4;
			$subroutineIndexHsh_ref->{$1}{'end'} = $#{$inScriptAry_ref};
			&reportStatus("!!!---NEW---!!! subroutine $1 of ctgry $2 found", 20, "\n");#->1025
			@{$subCtgryHsh_ref->{$1}} = split /,/, $2;
		}
		
		if ($inScriptAry_ref->[$i] =~ m/^\}/ and $subID) {
			$subroutineIndexHsh_ref->{$subID}{'end'} = $i;
		}
	}
	
	my $numSubroutine = keys %{$subroutineIndexHsh_ref};
	&reportStatus("$numSubroutine subroutines found", 20, "\n");#->1025

	my %tmpIDHsh;
	foreach my $sectionNum (keys %{$sectionIndexHsh_ref}) {
		$tmpIDHsh{$sectionIndexHsh_ref->{$sectionNum}{'ID'}}++;
	}

	foreach my $ID (keys %{$subroutineIndexHsh_ref}) {
		$tmpIDHsh{$ID}++;
	}
	#---check potential sub ID and session ID duplication
	foreach my $ID (keys %tmpIDHsh) {
		&reportStatus("session or sub $ID appeared for $tmpIDHsh{$ID} times. Please check", 20, "\n") if $tmpIDHsh{$ID} > 1;#->1025
	}

	return ($intitialItemAry_ref, $intitialItemIndexHsh_ref, $sectionIndexHsh_ref, $subroutineIndexHsh_ref, $subCtgryHsh_ref);
}
sub getLastCalledCmd {
#....................................................................................................................................................#
#	subroutineCategory: specific
#	dependOnSub: >none
#	appearInSub: >none
#	primaryAppearInSection: 4_getOtherInfo|97
#	secondaryAppearInSection: >none
#	input: $pathToRead
#	output: $lastCmdCalled
#	toCall: my ($lastCmdCalled) = &getLastCalledCmd($pathToRead);
#	calledInLine: 102
#....................................................................................................................................................#
	my ($pathToRead) = @_;
	
	my $absoluteScriptPath = abs_path($pathToRead);
	my $dirPath = dirname(rel2abs($absoluteScriptPath));
	my ($scriptName, $callScriptPath, $scriptSuffix) = fileparse($absoluteScriptPath, qr/\.[^.]*/);
	my $cmdPath = "$dirPath/$scriptName.cmd.log.txt";
	my $lastCmdCalled = 'notCalledBefore';

	if (-s $cmdPath) {
		open (CMDLOG, "<", $cmdPath); #---append the CMD log file
		my @CMDLogAry = <CMDLOG>;
		close CMDLOG;
		chomp ($lastCmdCalled = $CMDLogAry[-1]);
	}

	return ($lastCmdCalled);
}
sub getSectionSubDependency {
#....................................................................................................................................................#
#	subroutineCategory: specific
#	dependOnSub: recursiveSubroutineDependencySearch|953
#	appearInSub: >none
#	primaryAppearInSection: 7_getDependency|129
#	secondaryAppearInSection: >none
#	input: $IDPrefix, $inScriptAry_ref, $sectionIndexHsh_ref, $subroutineIndexHsh_ref
#	output: $sectionDependencyHsh_ref, $subroutineDependencyHsh_ref
#	toCall: my ($subroutineDependencyHsh_ref, $sectionDependencyHsh_ref) = &getSectionSubDependency($inScriptAry_ref, $sectionIndexHsh_ref, $subroutineIndexHsh_ref, $IDPrefix);
#	calledInLine: 134
#....................................................................................................................................................#

	my ($inScriptAry_ref, $sectionIndexHsh_ref, $subroutineIndexHsh_ref, $IDPrefix) = @_;
	
	my $subroutineDependencyHsh_ref = {};
	my $sectionDependencyHsh_ref = {};
	
	#---get the dependency in a recurrsive subroutine
	foreach my $subID (keys %{$subroutineIndexHsh_ref}) {
		&recursiveSubroutineDependencySearch($subID, $subroutineIndexHsh_ref, $subroutineDependencyHsh_ref, $inScriptAry_ref);#->953
	}
	
	#---get the appeareance of subroutines based on dependency
	foreach my $subID (sort keys %{$subroutineDependencyHsh_ref}) {
		foreach my $dependentSubID (sort keys %{$subroutineDependencyHsh_ref->{$subID}{'dependOnSub'}}) {
			$subroutineDependencyHsh_ref->{$dependentSubID}{'appearInSub'}{$subID}++;
		}
	}
	
	#---get the appeareance of subroutines based on dependency
	foreach my $sectionNum (sort keys %{$sectionIndexHsh_ref}) {
		my $tmpSectionContentStr = join "\n", @{$inScriptAry_ref}[$sectionIndexHsh_ref->{$sectionNum}{'start'}+1..$sectionIndexHsh_ref->{$sectionNum}{'end'}-1];
		my $sectionTag = $sectionNum."_".$sectionIndexHsh_ref->{$sectionNum}{'ID'};
		foreach my $subID (keys %{$subroutineIndexHsh_ref}) {
			if ($tmpSectionContentStr =~ m/$subID *[\(|,]/) {#----incase of using subroutine as a reference in threads
				$sectionDependencyHsh_ref->{$sectionNum}{'primaryDependOnSub'}{$subID}++;
				$subroutineDependencyHsh_ref->{$subID}{'primaryAppearInSection'}{$sectionTag}++;
				foreach my $dependentSubID (sort keys %{$subroutineDependencyHsh_ref->{$subID}{'dependOnSub'}}) {
					$sectionDependencyHsh_ref->{$sectionNum}{'secondaryDependOnSub'}{$dependentSubID}++;
					$subroutineDependencyHsh_ref->{$dependentSubID}{'secondaryAppearInSection'}{$sectionTag}++;
				}
			}
		}
		foreach (qw/primaryDependOnSub secondaryDependOnSub/) {
			$sectionDependencyHsh_ref->{$sectionNum}{$_}{'none'}++ if keys %{$sectionDependencyHsh_ref->{$sectionNum}{$_}} < 1;
		}
	}

	foreach my $subID (keys %{$subroutineIndexHsh_ref}) {
		foreach (qw/dependOnSub appearInSub primaryAppearInSection secondaryAppearInSection/) {
			$subroutineDependencyHsh_ref->{$subID}{$_}{'none'}++ if keys %{$subroutineDependencyHsh_ref->{$subID}{$_}} < 1;
		}
	}

	return ($subroutineDependencyHsh_ref, $sectionDependencyHsh_ref);
}
sub getSubrountineCategory {
#....................................................................................................................................................#
#	subroutineCategory: specific
#	dependOnSub: >none
#	appearInSub: >none
#	primaryAppearInSection: 7_getDependency|129
#	secondaryAppearInSection: >none
#	input: $definedSubCtgryHsh_ref, $inScriptAry_ref, $subCtgryHsh_ref, $subroutineIndexHsh_ref
#	output: $subCtgryOutputLineAry_ref
#	toCall: my ($subCtgryOutputLineAry_ref) = &getSubrountineCategory($subroutineIndexHsh_ref, $inScriptAry_ref, $subCtgryHsh_ref, $definedSubCtgryHsh_ref);
#	calledInLine: 136
#....................................................................................................................................................#
	
	my ($subroutineIndexHsh_ref, $inScriptAry_ref, $subCtgryHsh_ref, $definedSubCtgryHsh_ref) = @_;

	#---get the input and output of the subroutines
	my %subIDByctgryHsh = ();
	foreach my $subID (keys %{$subroutineIndexHsh_ref}) {
		my $tmpSubroutineContentStr = join "\n", @{$inScriptAry_ref}[$subroutineIndexHsh_ref->{$subID}{'start'}+1..$subroutineIndexHsh_ref->{$subID}{'end'}-1];
		if ($tmpSubroutineContentStr =~ m/\n\#\tsubroutineCategory: ([^\n]+)\n/) {
			@{$subCtgryHsh_ref->{$subID}} = split / ?, ?/, $1;
		}
		
		#---get the defined SubCtgryHsh if it is unassifned
		if ($subCtgryHsh_ref->{$subID}->[0] eq 'unassigned' and $definedSubCtgryHsh_ref->{$subID}) {
			$subCtgryHsh_ref->{$subID} = $definedSubCtgryHsh_ref->{$subID};
		}
		
		#---get subID by ctgry;
		push @{$subIDByctgryHsh{$_}}, $subID foreach @{$subCtgryHsh_ref->{$subID}};
	}

	#---generate subroutine category output lines
	my $subCtgryOutputLineAry_ref = [];
	my $chunkSize = 3;
	foreach my $ctgry (sort keys %subIDByctgryHsh) {
		my $numSub = @{$subIDByctgryHsh{$ctgry}};
		push @{$subCtgryOutputLineAry_ref}, "#\t$ctgry [n=$numSub]:\n";
		@{$subIDByctgryHsh{$ctgry}} = sort @{$subIDByctgryHsh{$ctgry}};
		
		#---split the array into chunks
		my @subIDChunkAry;
		while( my @chunkAry = splice(@{$subIDByctgryHsh{$ctgry}}, 0, $chunkSize)) {
			push @subIDChunkAry, \@chunkAry;
		}

		foreach (@subIDChunkAry) {
			my $subIDStr = join ", ", @{$_};
			push @{$subCtgryOutputLineAry_ref}, "#\t\t$subIDStr\n";
		}

		push @{$subCtgryOutputLineAry_ref}, "#\n";
	}

	return ($subCtgryOutputLineAry_ref);
}
sub getSubrountineInAndOut {
#....................................................................................................................................................#
#	subroutineCategory: specific
#	dependOnSub: >none
#	appearInSub: >none
#	primaryAppearInSection: 7_getDependency|129
#	secondaryAppearInSection: >none
#	input: $inScriptAry_ref, $subroutineIndexHsh_ref
#	output: $subroutineInOutHsh_ref
#	toCall: my ($subroutineInOutHsh_ref) = &getSubrountineInAndOut($subroutineIndexHsh_ref, $inScriptAry_ref);
#	calledInLine: 135
#....................................................................................................................................................#
	
	my ($subroutineIndexHsh_ref, $inScriptAry_ref) = @_;

	my $subroutineInOutHsh_ref = {};
	#---get the input and output of the subroutines
	foreach my $subID (keys %{$subroutineIndexHsh_ref}) {
		my $tmpInOutHsh_ref = {};
		$tmpInOutHsh_ref->{'input'} = 'none';
		$tmpInOutHsh_ref->{'output'} = 'none';
		my $tmpSubroutineContentStr = join "\n", @{$inScriptAry_ref}[$subroutineIndexHsh_ref->{$subID}{'start'}+1..$subroutineIndexHsh_ref->{$subID}{'end'}-1];
		$tmpInOutHsh_ref->{'input'} = $1 if ($tmpSubroutineContentStr =~ m/\n\tmy *(\(.+\)) *= *\@_;/);
		$tmpInOutHsh_ref->{'output'} = $1 if ($tmpSubroutineContentStr =~ m/\n\treturn *(\(*.+\)*);\n/);
		foreach my $inputOrOutput (keys %{$tmpInOutHsh_ref}) {
			my $position = 0;
			foreach (split /\(| *, *| +|\)/, $tmpInOutHsh_ref->{$inputOrOutput}) {
				if (length > 0) {
					$subroutineInOutHsh_ref->{$subID}{$inputOrOutput}{$_} = $position;
					$position++;
				}
			}
		}
	}
	
	return $subroutineInOutHsh_ref;
}
sub printCMDLogOrFinishMessage {
#....................................................................................................................................................#
#	subroutineCategory: general
#	dependOnSub: currentTime|400, reportStatus|1025
#	appearInSub: >none
#	primaryAppearInSection: 0_startingTask|53, 11_finishingTask|175
#	secondaryAppearInSection: >none
#	input: $CMDLogOrFinishMessage
#	output: none
#	toCall: &printCMDLogOrFinishMessage($CMDLogOrFinishMessage);
#	calledInLine: 58, 180
#....................................................................................................................................................#

	my ($CMDLogOrFinishMessage) = @_;
	
	if ($CMDLogOrFinishMessage eq "CMDLog") {
		#---open a log file if it doesnt exists
		my $absoluteScriptPath = abs_path($0);
		my $dirPath = dirname(rel2abs($absoluteScriptPath));
		my ($scriptName, $callScriptPath, $scriptSuffix) = fileparse($absoluteScriptPath, qr/\.[^.]*/);
		open (CMDLOG, ">>$dirPath/$scriptName.cmd.log.txt"); #---append the CMD log file
		print CMDLOG "[".&currentTime()."]\t"."$dirPath/$scriptName$scriptSuffix ".(join " ", @ARGV)."\n";#->400
		close CMDLOG;
		print "\n=========================================================================\n";
		&reportStatus("starts running ......", 20, "\n");#->1025
		print "=========================================================================\n\n";

	} elsif ($CMDLogOrFinishMessage eq "finishMessage") {
		print "\n=========================================================================\n";
		&reportStatus("finished running .......", 20, "\n");#->1025
		print "=========================================================================\n\n";
	}
}
sub printCleanScript {
#....................................................................................................................................................#
#	subroutineCategory: specific
#	dependOnSub: >none
#	appearInSub: >none
#	primaryAppearInSection: 8_outputCleanedScript|141
#	secondaryAppearInSection: >none
#	input: $cleanScriptAry_ref, $inputPath
#	output: none
#	toCall: &printCleanScript($inputPath, $cleanScriptAry_ref);
#	calledInLine: 149
#....................................................................................................................................................#
	
	my ($inputPath, $cleanScriptAry_ref) = @_;
	
	open (CLEANSCRIPT, ">", $inputPath);
	print CLEANSCRIPT foreach @{$cleanScriptAry_ref};
	close CLEANSCRIPT;

}
sub pushCleanedScriptIntoAry {
#....................................................................................................................................................#
#	subroutineCategory: specific
#	dependOnSub: reportStatus|1025
#	appearInSub: >none
#	primaryAppearInSection: 8_outputCleanedScript|141
#	secondaryAppearInSection: >none
#	input: $IDPrefix, $inScriptAry_ref, $intitialItemAry_ref, $intitialItemIndexHsh_ref, $lastCmdCalled, $sectionDependencyHsh_ref, $sectionIndexHsh_ref, $subCtgryHsh_ref, $subCtgryOutputLineAry_ref, $subroutineDependencyHsh_ref, $subroutineInOutHsh_ref, $subroutineIndexHsh_ref
#	output: $cleanScriptAry_ref, $sectionSubLineNumHsh_ref, $subroutineFinalTextHsh_ref
#	toCall: my ($cleanScriptAry_ref, $sectionSubLineNumHsh_ref, $subroutineFinalTextHsh_ref) = &pushCleanedScriptIntoAry($subroutineDependencyHsh_ref, $sectionDependencyHsh_ref, $inScriptAry_ref, $sectionIndexHsh_ref, $subroutineIndexHsh_ref, $subroutineInOutHsh_ref, $intitialItemAry_ref, $intitialItemIndexHsh_ref, $IDPrefix, $lastCmdCalled, $subCtgryHsh_ref, $subCtgryOutputLineAry_ref);
#	calledInLine: 146
#....................................................................................................................................................#

	my ($subroutineDependencyHsh_ref, $sectionDependencyHsh_ref, $inScriptAry_ref, $sectionIndexHsh_ref, $subroutineIndexHsh_ref, $subroutineInOutHsh_ref, $intitialItemAry_ref, $intitialItemIndexHsh_ref, $IDPrefix, $lastCmdCalled, $subCtgryHsh_ref, $subCtgryOutputLineAry_ref) = @_;
	
	my $subroutineFinalTextHsh_ref = {};
	
	&reportStatus("Pushing content into output array", 20, "\n");#->1025

	my $seperatorStart = "#====================================================================================================================================================#\n";
	my $seperatorEnd = "#====================================================================================================================================================#\n";
	my $seperatorSubOut = "######################################################################################################################################################\n";
	my $seperatorSubIn = "#....................................................................................................................................................#\n";
	
	my $cleanScriptAry_ref = ();
	
	push @{$cleanScriptAry_ref}, '#!/usr/bin/perl -w'."\n";
	push @{$cleanScriptAry_ref}, "\n";
	foreach my $intitialItem (@{$intitialItemAry_ref}) {
		push @{$cleanScriptAry_ref}, $seperatorStart;
		push @{$cleanScriptAry_ref}, "#<$intitialItem>\n";
		push @{$cleanScriptAry_ref}, @{$inScriptAry_ref}[$intitialItemIndexHsh_ref->{$intitialItem}{'start'}+1..$intitialItemIndexHsh_ref->{$intitialItem}{'end'}-1];
		push @{$cleanScriptAry_ref}, "#<\\$intitialItem>\n";
		push @{$cleanScriptAry_ref}, $seperatorEnd;
		push @{$cleanScriptAry_ref}, "\n";
		
		if ($intitialItem eq "doc") {#---print the lastCmdCalled after the doc
			push @{$cleanScriptAry_ref}, $seperatorStart;
			push @{$cleanScriptAry_ref}, "#<lastCmdCalled>\n";
			push @{$cleanScriptAry_ref}, "#\n";
			push @{$cleanScriptAry_ref}, "#\t$lastCmdCalled\n";
			push @{$cleanScriptAry_ref}, "#\n";
			my $lastCmdCalledNoTime = $lastCmdCalled;
			$lastCmdCalledNoTime =~ s/^\[.+\]\s+//; 
			my @lastCmdCalledAry = split /\s+/, $lastCmdCalledNoTime;
			push @{$cleanScriptAry_ref}, "#\t$_\n" foreach (@lastCmdCalledAry);
			push @{$cleanScriptAry_ref}, "#\n";
			push @{$cleanScriptAry_ref}, "#<\\lastCmdCalled>\n";
			push @{$cleanScriptAry_ref}, $seperatorEnd;
			push @{$cleanScriptAry_ref}, "\n";
		}
	}

	push @{$cleanScriptAry_ref}, $seperatorStart;
	push @{$cleanScriptAry_ref}, "{\t#Main sections lexical scope starts\n";
	push @{$cleanScriptAry_ref}, $seperatorEnd;
	push @{$cleanScriptAry_ref}, "\n";

	my $sectionSubLineNumHsh_ref = {};
	
	foreach my $sectionNum (sort {$a <=> $b} keys %{$sectionIndexHsh_ref}) {
		my $sectionID = $sectionIndexHsh_ref->{$sectionNum}{'ID'};
		my $sectionTag = "$sectionNum\_$sectionID";
		my $primaryDependOnSub = join ", $IDPrefix", sort keys %{$sectionDependencyHsh_ref->{$sectionNum}{'primaryDependOnSub'}};
		my $secondaryDependOnSub = join ", $IDPrefix", sort keys %{$sectionDependencyHsh_ref->{$sectionNum}{'secondaryDependOnSub'}};
		push @{$cleanScriptAry_ref}, $seperatorStart;
		push @{$cleanScriptAry_ref}, "#	section $sectionTag\n";

		$sectionSubLineNumHsh_ref->{$sectionTag} = $#{$cleanScriptAry_ref}+1;

		push @{$cleanScriptAry_ref}, "#	primaryDependOnSub: $IDPrefix$primaryDependOnSub\n";
		push @{$cleanScriptAry_ref}, "#	secondaryDependOnSub: $IDPrefix$secondaryDependOnSub\n";
		push @{$cleanScriptAry_ref}, "#\n";
		#push @{$cleanScriptAry_ref}, "&reportStatus(\"<--- section $sectionNum $sectionID starts --->\", 20, \"\\n\");\n";#->1025
		push @{$cleanScriptAry_ref}, "#<section ID=\"$sectionID\" num=\"$sectionNum\">\n";
		push @{$cleanScriptAry_ref}, @{$inScriptAry_ref}[$sectionIndexHsh_ref->{$sectionNum}{'start'}+1..$sectionIndexHsh_ref->{$sectionNum}{'end'}-1];
		push @{$cleanScriptAry_ref}, "#<\\section>\n";
		#push @{$cleanScriptAry_ref}, "&reportStatus(\"<--- section $sectionNum $sectionID ends --->\", 20, \"\\n\\n\");\n";#->1025
		push @{$cleanScriptAry_ref}, $seperatorEnd;
		push @{$cleanScriptAry_ref}, "\n";
	}

	push @{$cleanScriptAry_ref}, $seperatorStart;
	push @{$cleanScriptAry_ref}, "}\t#Main sections lexical scope ends\n";
	push @{$cleanScriptAry_ref}, $seperatorEnd;
	push @{$cleanScriptAry_ref}, "\n";

	push @{$cleanScriptAry_ref}, $seperatorStart;
	push @{$cleanScriptAry_ref}, "#List of subroutines by category\n";
	push @{$cleanScriptAry_ref}, "#\n";
	push @{$cleanScriptAry_ref}, @{$subCtgryOutputLineAry_ref};
	push @{$cleanScriptAry_ref}, $seperatorEnd;
	push @{$cleanScriptAry_ref}, "\n";

	foreach my $subID (sort keys %{$subroutineIndexHsh_ref}) {
		my %tmpDependencyHsh = ();
		foreach my $dependency (qw/dependOnSub appearInSub primaryAppearInSection secondaryAppearInSection/) {
			$tmpDependencyHsh{$dependency} = join ", $IDPrefix", sort keys %{$subroutineDependencyHsh_ref->{$subID}{$dependency}};
		}

		my %tmpVarInOrderHsh = ();
		foreach my $inputOrOutput (qw/input output/) {
			$tmpDependencyHsh{$inputOrOutput} = join ", ", sort {$a cmp $b} keys %{$subroutineInOutHsh_ref->{$subID}{$inputOrOutput}};
			$tmpVarInOrderHsh{$inputOrOutput} = join ", ", sort {$subroutineInOutHsh_ref->{$subID}{$inputOrOutput}{$a} <=> $subroutineInOutHsh_ref->{$subID}{$inputOrOutput}{$b}} keys %{$subroutineInOutHsh_ref->{$subID}{$inputOrOutput}};
			$tmpVarInOrderHsh{$inputOrOutput} = '' if $tmpVarInOrderHsh{$inputOrOutput} eq 'none';
		}
		
		my $toCall = 'my ('.$tmpVarInOrderHsh{'output'}.') = &'.$subID.'('.$tmpVarInOrderHsh{'input'}.');';
		$toCall =~ s/my \(\) \= //;#---remove the 1st half if no output;
	
		#push @{$cleanScriptAry_ref}, $seperatorSubOut;
		#push @{$cleanScriptAry_ref}, "#\n";
		#push @{$cleanScriptAry_ref}, "#	subID: $subID {\n";
		#push @{$cleanScriptAry_ref}, "#\n";
		push @{$cleanScriptAry_ref}, "sub $subID {\n";
		my $startCleanScriptAryIndex = $#{$cleanScriptAry_ref};

		$sectionSubLineNumHsh_ref->{$subID} = $#{$cleanScriptAry_ref}+2;#--- just plus to directly step inside the sub
		
		my $subCtgryStr = join ", ", @{$subCtgryHsh_ref->{$subID}};
		
		push @{$cleanScriptAry_ref}, $seperatorSubIn;
		push @{$cleanScriptAry_ref}, "#	subroutineCategory: $subCtgryStr\n";
		push @{$cleanScriptAry_ref}, "#	dependOnSub: $IDPrefix$tmpDependencyHsh{dependOnSub}\n";
		push @{$cleanScriptAry_ref}, "#	appearInSub: $IDPrefix$tmpDependencyHsh{appearInSub}\n";
		push @{$cleanScriptAry_ref}, "#	primaryAppearInSection: $IDPrefix$tmpDependencyHsh{primaryAppearInSection}\n";
		push @{$cleanScriptAry_ref}, "#	secondaryAppearInSection: $IDPrefix$tmpDependencyHsh{secondaryAppearInSection}\n";
		push @{$cleanScriptAry_ref}, "#	input: $tmpDependencyHsh{input}\n";
		push @{$cleanScriptAry_ref}, "#	output: $tmpDependencyHsh{output}\n";
		push @{$cleanScriptAry_ref}, "#	toCall: $toCall\n";
		push @{$cleanScriptAry_ref}, "#	$subID calledInLine: \n";
		push @{$cleanScriptAry_ref}, $seperatorSubIn;
		#----all lines begin with # within the sub block will be removed
		push @{$cleanScriptAry_ref}, grep /^[^\#]/, @{$inScriptAry_ref}[$subroutineIndexHsh_ref->{$subID}{'start'}+1..$subroutineIndexHsh_ref->{$subID}{'end'}-1];
		push @{$cleanScriptAry_ref}, "}\n";
		my $endCleanScriptAryIndex = $#{$cleanScriptAry_ref};
		
		#---get the finalized subroutine text
		@{$subroutineFinalTextHsh_ref->{$subID}} = @{$cleanScriptAry_ref}[$startCleanScriptAryIndex..$endCleanScriptAryIndex];
	}

	push @{$cleanScriptAry_ref}, "\n";
	push @{$cleanScriptAry_ref}, "exit;\n";
	
	return ($cleanScriptAry_ref, $sectionSubLineNumHsh_ref, $subroutineFinalTextHsh_ref);
}
sub recursiveSubroutineDependencySearch {
#....................................................................................................................................................#
#	subroutineCategory: specific
#	dependOnSub: >none
#	appearInSub: getSectionSubDependency|604
#	primaryAppearInSection: >none
#	secondaryAppearInSection: 7_getDependency|129
#	input: $inScriptAry_ref, $subID, $subroutineDependencyHsh_ref, $subroutineIndexHsh_ref
#	output: none
#	toCall: &recursiveSubroutineDependencySearch($subID, $subroutineIndexHsh_ref, $subroutineDependencyHsh_ref, $inScriptAry_ref);
#	calledInLine: 623, 973
#....................................................................................................................................................#

	my ($subID, $subroutineIndexHsh_ref, $subroutineDependencyHsh_ref, $inScriptAry_ref) = @_;
	
	my $tmpSubroutineContentStr = join "\n", grep /^[^#]/, @{$inScriptAry_ref}[$subroutineIndexHsh_ref->{$subID}{'start'}+1..$subroutineIndexHsh_ref->{$subID}{'end'}-1];
	
	foreach my $dependentSubID (keys %{$subroutineIndexHsh_ref}) {
		if ($tmpSubroutineContentStr =~ m/([ |&|\n]$dependentSubID *[\(|,])/ and $subID ne $dependentSubID) {
			$subroutineDependencyHsh_ref->{$subID}{'dependOnSub'}{$dependentSubID}++;
			#print $subID."\t".$1."\n";
			&recursiveSubroutineDependencySearch($dependentSubID, $subroutineIndexHsh_ref, $subroutineDependencyHsh_ref, $inScriptAry_ref);#->953
		}
	}
}
sub removeDeletedSubroutineFromSubroutineDir {
#....................................................................................................................................................#
#	subroutineCategory: specific
#	dependOnSub: >none
#	appearInSub: >none
#	primaryAppearInSection: 10_recordTheSubroutines|164
#	secondaryAppearInSection: >none
#	input: $inputPath, $subroutineDir, $subroutineFinalTextHsh_ref
#	output: 
#	toCall: &removeDeletedSubroutineFromSubroutineDir($subroutineDir, $inputPath, $subroutineFinalTextHsh_ref);
#	calledInLine: 170
#....................................................................................................................................................#

	my ($subroutineDir, $inputPath, $subroutineFinalTextHsh_ref) = @_;

	my ($scriptName, undef, undef) = fileparse($inputPath, qr/_v[\d|.]+\.[^.]*/);

	opendir (BYSUBDIR, "$subroutineDir/bySub/");
	while (my $ctgry = readdir(BYSUBDIR)) {
		next if $ctgry =~ /^\./;
		opendir (CTGRYDIR, "$subroutineDir/bySub/$ctgry/");
		while (my $subID = readdir(CTGRYDIR)) {
			next if $subID =~ /^\./;
			opendir (SUBIDDIR, "$subroutineDir/bySub/$ctgry/$subID");
			my $numScript = 0;
			while (my $existingScriptname = readdir(SUBIDDIR)) {
				#---remove the folder if the subID is not present anymore
				if ($scriptName eq $existingScriptname and not $subroutineFinalTextHsh_ref->{$subID}) {
					system ("rm -rf $subroutineDir/bySub/$ctgry/$subID/$scriptName");
				} else {
					$numScript++;
				}
			}
			
			#---remove the subID folder if it is empty
			system ("rm -rf $subroutineDir/bySub/$ctgry/$subID") if ($numScript == 0);
			
			close SUBIDDIR;
		}
		close CTGRYDIR;
	}
	close BYSUBDIR;

	return ();

	return ();
}
sub reportStatus {
#....................................................................................................................................................#
#	subroutineCategory: general
#	dependOnSub: currentTime|400
#	appearInSub: addAndSignToInTextSubroutine|209, addLineNumberToCleanScript|236, checkMissingSubroutine|320, checkSubroutineInOutputInMainText|345, getInputPerlScriptAndBackup|450, getItemIndex|488, printCMDLogOrFinishMessage|754, pushCleanedScriptIntoAry|807, warnUncalledSubroutinerm|1046
#	primaryAppearInSection: >none
#	secondaryAppearInSection: 0_startingTask|53, 11_finishingTask|175, 1_readInputScript|63, 5_getSectionSubIndex|108, 6_checkSubCallFormat|118, 8_outputCleanedScript|141, 9_warnings|154
#	input: $lineEnd, $message, $numTrailingSpace
#	output: 
#	toCall: &reportStatus($message, $numTrailingSpace, $lineEnd);
#	calledInLine: 223, 252, 334, 339, 359, 390, 466, 483, 515, 532, 547, 557, 569, 777, 782, 823, 879, 883, 1075
#....................................................................................................................................................#
	my ($message, $numTrailingSpace, $lineEnd) = @_;

	my $trailingSpaces = '';
	$trailingSpaces .= " " for (1..$numTrailingSpace);
	
	print "[".&currentTime()."] ".$message.$trailingSpaces.$lineEnd;#->400

	return ();
}
sub warnUncalledSubroutinerm {
#....................................................................................................................................................#
#	subroutineCategory: specific
#	dependOnSub: reportStatus|1025
#	appearInSub: >none
#	primaryAppearInSection: 9_warnings|154
#	secondaryAppearInSection: >none
#	input: $subroutineDependencyHsh_ref, $uncalledSubHsh_ref
#	output: 
#	toCall: &warnUncalledSubroutinerm($subroutineDependencyHsh_ref, $uncalledSubHsh_ref);
#	calledInLine: 159
#....................................................................................................................................................#
	my ($subroutineDependencyHsh_ref, $uncalledSubHsh_ref) = @_;
	
	my %uncalledSubroutineTypeHsh = ();
	
	foreach my $subID (keys %{$uncalledSubHsh_ref}) {
		$uncalledSubroutineTypeHsh{$subID} = 'NOT called in main sections';
		if (not exists $subroutineDependencyHsh_ref->{$subID}{'dependOnSub'}{'none'}) {
			foreach my $dependentSubID (keys %{$subroutineDependencyHsh_ref->{$subID}{'dependOnSub'}}) {
				my $calledOutsideMissedSub = 'no';
				foreach my $appearInSubID (keys %{$subroutineDependencyHsh_ref->{$dependentSubID}{'appearInSub'}}) {
					$calledOutsideMissedSub = 'yes' if not $uncalledSubHsh_ref->{$appearInSubID};
				}
				$uncalledSubroutineTypeHsh{$dependentSubID} = "ONLY called within $subID which is not called in main sections" if $calledOutsideMissedSub eq 'no';
			}
		}
	}

	foreach my $subID (sort keys %uncalledSubroutineTypeHsh) {
		&reportStatus("!!!---WARNING---!!! $subID is $uncalledSubroutineTypeHsh{$subID}", 20, "\n");#->1025
	}

	return ();
}
sub writeSubroutineToExternalDir {
#....................................................................................................................................................#
#	subroutineCategory: specific
#	dependOnSub: currentTime|400
#	appearInSub: >none
#	primaryAppearInSection: 10_recordTheSubroutines|164
#	secondaryAppearInSection: >none
#	input: $inputPath, $subCtgryHsh_ref, $subroutineDir, $subroutineFinalTextHsh_ref
#	output: 
#	toCall: &writeSubroutineToExternalDir($subroutineFinalTextHsh_ref, $inputPath, $subroutineDir, $subCtgryHsh_ref);
#	calledInLine: 169
#....................................................................................................................................................#
	my ($subroutineFinalTextHsh_ref, $inputPath, $subroutineDir, $subCtgryHsh_ref) = @_;
	
	my ($scriptName, $inputDir, $inputSuffix) = fileparse($inputPath, qr/_v[\d|.]+\.[^.]*/);
	
	#---remove the script specific folders
	system ("rm -rf $subroutineDir/bySub/specific/$scriptName/ $subroutineDir/byScript/$scriptName/");
	
	foreach my $subID (keys %{$subroutineFinalTextHsh_ref}) {
		foreach my $ctgry (@{$subCtgryHsh_ref->{$subID}}) {
			my $subpmName = "$subID.pm";
			my $bySubDir = "";
			if ($ctgry ne "specific") {
				$bySubDir = "$subroutineDir/bySub/$ctgry/$subID/$scriptName/";
			} else {
				$bySubDir = "$subroutineDir/bySub/$ctgry/$scriptName/";
			}
			my $byScriptDir = "$subroutineDir/byScript/$scriptName/$ctgry/";
		
			system ("mkdir -pm 777 $bySubDir $byScriptDir");
		
			#---check for obsolete ctgry
			opendir (BYSUBDIR, "$subroutineDir/bySub/");
			while (my $existingCtgry = readdir(BYSUBDIR)) {
				
				#---next if the existingCtgry is in @{$subCtgryHsh_ref->{$subID}}
				next if grep /$existingCtgry/, @{$subCtgryHsh_ref->{$subID}};
				
				#---obsolete mean the subID changed category
				my $obsoleteScriptDirPath = "$subroutineDir/bySub/$existingCtgry/$subID/$scriptName/"; 

				if (-s $obsoleteScriptDirPath) {
					system ("rm -rf $obsoleteScriptDirPath");
				
					#---rm the subID dir if this script is the only item
					my $obsoleteSubIDDirPath = "$subroutineDir/bySub/$existingCtgry/$subID/";
					opendir (SUBIDDIR, "$obsoleteSubIDDirPath");
					my $numScript = 0;
					while (readdir(SUBIDDIR)) {
						next if $_ =~ /^\./; #---skip the .DS_Store
						$numScript++;
					}
					close SUBIDDIR;
				
					if ($numScript == 0) {
						system ("rm -rf $obsoleteSubIDDirPath");
					
						#---rm the ctgyr dir if this script is the only item
						my $obsoleteCtgryDirPath = "$subroutineDir/bySub/$existingCtgry/";
						opendir (CTGRYDIR, "$obsoleteCtgryDirPath");
						my $numSub = 0;
						while (readdir(CTGRYDIR)) {
							next if $_ =~ /^\./; #---skip the .DS_Store
							$numSub++;
						}
						close CTGRYDIR;
					
						system ("rm -rf $obsoleteCtgryDirPath") if $numSub == 0;
					}
				}
			}
			close BYSUBDIR;
		
			my @subTextAry = @{$subroutineFinalTextHsh_ref->{$subID}};
			my %FHHsh = ();
			open $FHHsh{'bySub'}, ">", "$bySubDir/$subpmName";
			open $FHHsh{'byScript'}, ">", "$byScriptDir/$subpmName";
			foreach my $bySubOrByScript (keys %FHHsh) {
				print {$FHHsh{$bySubOrByScript}} join "", ("# [".&currentTime()."] $inputPath"), "\n";#->400
				print {$FHHsh{$bySubOrByScript}} @subTextAry;
			}
		}
	}
	return ();
}

exit;
