# Primer3 - Manual

## CONTENTS

[1. COPYRIGHT AND LICENSE](#copyrightLicense)
[2. INTRODUCTION](#introduction)
[3. CITING PRIMER3](#citationRequest)
[4. FAIR USE OF PRIMER3](#licenseExplain)
[5. DIFFERENCE BETWEEN PRIMER3 AND PRIMER3PLUS](#differencePrimer3vsPrimer3Plus)
[6. CHANGES FROM VERSION 2.2.3](#changesFrom2.2.3)
[7. INSTALLATION INSTRUCTIONS - UNIX/LINUX](#installLinux)
[8. INSTALLATION INSTRUCTIONS - Mac OSX](#installMac)
[9. INSTALLATION INSTRUCTIONS - WINDOWS](#installWindows)
[10. SYSTEM REQUIREMENTS](#systemRequirements)
[11. INVOKING primer3_core](#invokingPrimer3)
[12. COMMAND LINE ARGUMENTS](#commandLineTags)
[13. INPUT AND OUTPUT CONVENTIONS](#inputOutputConventions)
[14. AN EXAMPLE](#example)
[15. HOW TO MIGRATE TAGS TO IO VERSION 4](#migrateTags)
[16. "SEQUENCE" INPUT TAGS](#sequenceTags)
[17. "GLOBAL" INPUT TAGS](#globalTags)
[18. "PROGRAM" INPUT TAGS](#programTags)
[19. HOW PRIMER3 CALCULATES THE PENALTY VALUE](#calculatePenalties)
[20. PRIMER3 SETTINGS FILE FORMAT](#fileFormat)
[21. OUTPUT TAGS](#outputTags)
[22. EXAMPLE OUTPUT](#exampleOutput)
[23. ADVICE FOR PICKING PRIMERS](#pickAdvice)
[24. GENERAL THOUGHTS ON PRIMER BINDING](#primerBinding)
[25. CAUTIONS](#cautions)
[26. WHAT TO DO IF PRIMER3 CANNOT FIND ANY PRIMERS?](#findNoPrimers)
[27. DIFFERENCES FROM EARLIER VERSIONS](#earlierVersions)
[28. EXIT STATUS CODES](#exitStatusCodes)
[29. PRIMER3 WWW INTERFACES](#webInterface)
[30. ACKNOWLEDGMENTS](#acknowledgments)

## [1. COPYRIGHT AND LICENSE]{#copyrightLicense}

```
Copyright (c) 1996 - 2022
Whitehead Institute for Biomedical Research, Steve Rozen
(http://purl.com/STEVEROZEN/), Helen Skaletsky, Triinu Koressaar,
Maido Remm and Andreas Untergasser. All rights reserved.
    This file is part of the Primer3 suite and libraries.
    The Primer3 suite and libraries are free software;
    you can redistribute them and/or modify them under the terms
    of the GNU General Public License as published by the Free
    Software Foundation; either version 2 of the License, or (at
    your option) any later version.
```

## [2. INTRODUCTION]{#introduction}

Primer3 picks primers for PCR reactions, considering as criteria:

- oligonucleotide melting temperature, size, GC content, and primer-dimer possibilities
- PCR product size
- positional constraints within the source (template) sequence
- possibilities for ectopic priming (amplifying the wrong sequence)
- many other constraints

All of these criteria are user-specifiable as constraints, and some are specifiable as terms in an objective function that characterizes an optimal primer pair.

## [3. CITING PRIMER3]{#citationRequest}

We request but do not require that use of this software be cited in publications as:

* Untergasser A, Cutcutache I, Koressaar T, Ye J, Faircloth BC, Remm M and Rozen SG.
Primer3--new capabilities and interfaces.
Nucleic Acids Res. 2012 Aug 1;40(15):e115.
The paper is available at http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3424584/

and

* Koressaar T and Remm M.
Enhancements and modifications of primer design program Primer3.
Bioinformatics 2007;23(10):1289-1291.
The paper is available at https://www.ncbi.nlm.nih.gov/pubmed/17379693

If you use masker function, please cite:

* Koressaar T, Lepamets M, Kaplinski L, Raime K, Andreson R and Remm M.
Primer3_masker: integrating masking of template sequence with primer design software.
Bioinformatics 2018;34(11):1937-1938.
The paper is available at https://www.ncbi.nlm.nih.gov/pubmed/29360956

Source code available at https://github.com/primer3-org/primer3.

## [4. FAIR USE OF PRIMER3]{#licenseExplain}

The development of Primer3 is promoted by a small group of enthusiastic scientists mainly in their free time. They do not gain any financial profit with Primer3.

There are two groups of Primer3 users: end users, who run Primer3 to pick their primers and programmers, who use Primer3 in their scripts or software packages. We encourage both to use Primer3.

If you are an end user, we request but do not require that use of this software be cited in publications as listed above under CITING PRIMER3.

If you are a programmer, you will see that Primer3 is now distributed under the GNU General Public License, version 2 or (at your option) any later version of the License (GPL2). As we understand it, if you include parts of the Primer3 source code in your source code or link to Primer3 binary libraries in your executable, you have to release your software also under GPL2. If you only call Primer3 from your software and interpret its output, you can use any license you want for your software. If you modify Primer3 and then release your modified software, you have to release your modifications in source code under GPL2 as well.


## [5. DIFFERENCE BETWEEN PRIMER3 AND PRIMER3PLUS]{#differencePrimer3vsPrimer3Plus}

Primer3Plus is a web interface to Primer3, so if you pick primers with Primer3Plus, it will collect and reformat your input, run the command line tool Primer3, collet and reformat it\'s output and display it to you.
In principle, both tools would give you the same output. In practice, the default settings ob both tools differ. While Primer3 default settings are usually kept for backward compatibility, the Primer3Plus default settings are adapted for regular wetlab use.

#### Primer3 Values:

      PRIMER_PRODUCT_SIZE_RANGE=100-300
      PRIMER_SECONDARY_STRUCTURE_ALIGNMENT=0
      PRIMER_NUM_RETURN=5
      PRIMER_MAX_HAIRPIN_TH=47.0
      PRIMER_INTERNAL_MAX_HAIRPIN_TH=47.0
      PRIMER_MAX_END_STABILITY=100.0
      PRIMER_MIN_LEFT_THREE_PRIME_DISTANCE=-1
      PRIMER_MIN_RIGHT_THREE_PRIME_DISTANCE=-1
      PRIMER_EXPLAIN_FLAG=0
      PRIMER_LIBERAL_BASE=0
      PRIMER_FIRST_BASE_INDEX=0
      PRIMER_MAX_TEMPLATE_MISPRIMING=-1.00
      PRIMER_MAX_TEMPLATE_MISPRIMING_TH=-1.00
      PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING=-1.00
      PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING_TH=-1.00

#### Primer3Plus Values:

      PRIMER_PRODUCT_SIZE_RANGE=501-600 601-700 401-500 701-850 851-1000 1001-1500
                                1501-3000 3001-5000 401-500 301-400 201-300
                                101-200 5001-7000 7001-10000 10001-20000
      PRIMER_SECONDARY_STRUCTURE_ALIGNMENT=1
      PRIMER_NUM_RETURN=10
      PRIMER_MAX_HAIRPIN_TH=47.00
      PRIMER_INTERNAL_MAX_HAIRPIN_TH=47.00
      PRIMER_MAX_END_STABILITY=9.0
      PRIMER_MIN_LEFT_THREE_PRIME_DISTANCE=3
      PRIMER_MIN_RIGHT_THREE_PRIME_DISTANCE=3
      PRIMER_EXPLAIN_FLAG=1
      PRIMER_LIBERAL_BASE=1
      PRIMER_FIRST_BASE_INDEX=1
      PRIMER_MAX_TEMPLATE_MISPRIMING=12.00
      PRIMER_MAX_TEMPLATE_MISPRIMING_TH=47.00
      PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING=24.00
      PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING_TH=47.00

## [6. CHANGES FROM VERSION 2.2.3]{#changesFrom2.2.3}

1\. The tag PRIMER_THERMODYNAMIC_ALIGNMENT was replaced by two new tags:\
\
-
[PRIMER_THERMODYNAMIC_OLIGO_ALIGNMENT](#PRIMER_THERMODYNAMIC_OLIGO_ALIGNMENT)
which governs hairpin and oligo-oligo interactions. Therefore, whenever
it is set to 1 (the default) thermodynamic alignments will be used for
oligo-oligo interactions and hairpins.\
\
-
[PRIMER_THERMODYNAMIC_TEMPLATE_ALIGNMENT](#PRIMER_THERMODYNAMIC_TEMPLATE_ALIGNMENT)
which governs the oligo-template interactions and, when set to 1
(default is 0), will cause Primer3 to use the thermodynamic alignment
against templates.\
\
The reason for this change is to provide the option of using the old
alignment for oligo-template interactions when the thermodynamic
alignment is too slow or the template is too long (there is a hard limit
THAL_MAX_SEQ=10k on the length of sequences involved in thermodynamic
alignments).\
\
2. We changed the following default values:\
\
2.1. Changing default oligo temperature calculations\
\
[PRIMER_TM_FORMULA](#PRIMER_TM_FORMULA)=1 (was 0)\
[PRIMER_SALT_CORRECTIONS](#PRIMER_SALT_CORRECTIONS)=1 (was 0)\
\
2.2. Making thermodynamic secondary structure calculations for oligos
the default:\
\
[PRIMER_THERMODYNAMIC_OLIGO_ALIGNMENT](#PRIMER_THERMODYNAMIC_OLIGO_ALIGNMENT)=1
(was 0)\
\
2.3. The following need reasonable values to support the changes in 2.1
and 2.2 above:\
\
[PRIMER_SALT_DIVALENT](#PRIMER_SALT_DIVALENT)=1.5 (was 0.0)\
[PRIMER_DNTP_CONC](#PRIMER_DNTP_CONC)=0.6 (was 0.0)\
\
2.4. To make old defaults easily accessible, we added a command line
argument, \--default_version=1, which directs primer3_core to use the
old defaults. \--default_version=2 directs primer3_core to use the new
defaults. The default is \--default_version=2.\
\
2.5. IMPORTANT: because
[PRIMER_THERMODYNAMIC_OLIGO_ALIGNMENT](#PRIMER_THERMODYNAMIC_OLIGO_ALIGNMENT)=1,
[PRIMER_THERMODYNAMIC_PARAMETERS_PATH](#PRIMER_THERMODYNAMIC_PARAMETERS_PATH)
must point to the right location. This tag specifies the path to the
directory that contains all the parameter files used by the
thermodynamic approach. In Linux, there are two \*default\* locations
that are tested if this tag is not defined: ./primer3_config/ and
/opt/primer3_config/. For Windows, there is only one default location:
.\\primer3_config\\. If the the parameter files are not in one these
locations, be sure to set
[PRIMER_THERMODYNAMIC_PARAMETERS_PATH](#PRIMER_THERMODYNAMIC_PARAMETERS_PATH).\
\
2.6. Changed default for\
\
[PRIMER_LIB_AMBIGUITY_CODES_CONSENSUS](#PRIMER_LIB_AMBIGUITY_CODES_CONSENSUS)=0
(was 1)\
\
(0 is almost always the the behavior one wants.)\
\
2.7. To get the behavior of -default_version=1 when -default_version=2
set the following:\
\
[PRIMER_TM_FORMULA](#PRIMER_TM_FORMULA)=0\
[PRIMER_SALT_CORRECTIONS](#PRIMER_SALT_CORRECTIONS)=0\
[PRIMER_THERMODYNAMIC_OLIGO_ALIGNMENT](#PRIMER_THERMODYNAMIC_OLIGO_ALIGNMENT)=0\
[PRIMER_THERMODYNAMIC_TEMPLATE_ALIGNMENT](#PRIMER_THERMODYNAMIC_TEMPLATE_ALIGNMENT)=0\
[PRIMER_SALT_DIVALENT](#PRIMER_SALT_DIVALENT)=0.0\
[PRIMER_DNTP_CONC](#PRIMER_DNTP_CONC)=0.0\
[PRIMER_LIB_AMBIGUITY_CODES_CONSENSUS](#PRIMER_LIB_AMBIGUITY_CODES_CONSENSUS)=1\
\
2.8. To get the behavior of -default_version=2 when -default_version=1
set the following:\
\
[PRIMER_TM_FORMULA](#PRIMER_TM_FORMULA)=1\
[PRIMER_SALT_CORRECTIONS](#PRIMER_SALT_CORRECTIONS)=1\
[PRIMER_THERMODYNAMIC_OLIGO_ALIGNMENT](#PRIMER_THERMODYNAMIC_OLIGO_ALIGNMENT)=1\
[PRIMER_THERMODYNAMIC_TEMPLATE_ALIGNMENT](#PRIMER_THERMODYNAMIC_TEMPLATE_ALIGNMENT)=0\
[PRIMER_SALT_DIVALENT](#PRIMER_SALT_DIVALENT)=1.5\
[PRIMER_DNTP_CONC](#PRIMER_DNTP_CONC)=0.6\
[PRIMER_LIB_AMBIGUITY_CODES_CONSENSUS](#PRIMER_LIB_AMBIGUITY_CODES_CONSENSUS)=0\
\
3. We changed the NULL value for SEQUENCE_FORCE\_{LEFT,RIGHT}\_START_END
to -1000000, and made it an error to select
[PRIMER_FIRST_BASE_INDEX](#PRIMER_FIRST_BASE_INDEX) \<= this value. This
is to correct an error when SEQUENCE_FORCE\_{LEFT,RIGHT}\_START_END was
-1 (value previously used to indicate a NULL) but
[PRIMER_FIRST_BASE_INDEX](#PRIMER_FIRST_BASE_INDEX) was \< 0, which
caused the intended NULL value (-1) to be treated as a constraint on
primer location (a constraint that was not possible to satisfy).\
\
4. We changed the [PRIMER_TASK](#PRIMER_TASK) called
\'pick_detection_primers\' to \'generic\' while retaining
\'pick_detection_primers\' as an alias for backward compatibility.\
\
5. The code now uses \'end\' alignments when assessing template
mispriming using thermodynamic alignments. This is consistent with the
approach taken with the previous alignment algorithm and with checking
for mispriming against repeat libraries.\
\
6. We removed PRIMER_PAIR_MAX_HAIRPIN_TH (which was ignored
previously).\
\
7. Primer3 now requires the user to set
[SEQUENCE_TARGET](#SEQUENCE_TARGET), not
[SEQUENCE_INCLUDED_REGION](#SEQUENCE_INCLUDED_REGION) when
[PRIMER_TASK](#PRIMER_TASK)=pick_discriminative_primers\
\
8. When [PRIMER_TASK](#PRIMER_TASK)=pick_discriminative_primers or
[PRIMER_TASK](#PRIMER_TASK)=pick_cloning_primers the value of
[SEQUENCE_INCLUDED_REGION](#SEQUENCE_INCLUDED_REGION) is no longer
changed to the entire input sequence.\
\
9. The handling of divalent cations when
[PRIMER_SALT_CORRECTIONS](#PRIMER_SALT_CORRECTIONS)=2 (not the default
and not the recommended value) has been updated. The rationale is that,
when divalent cations are present, the formula by Owczarzy et al., 2004
(used previously by Primer3) can be improved upon as described in (Ahsen
et al., 2010; Owczarzy et al., 2008). Therefore we have updated the
melting temperature calculation to follow the scheme in Figure 9 of
(Owczarzy et al., 2008). Please find references to these papers below in
the manual.\
\
10. We modified the error handling of non-memory related errors that can
occur during the thermodynamic alignment. They are no longer fatal
errors.\
\
11. We removed io_version 3, which was only kept for backward
compatibility with very old versions of Primer3.\
\
12. In addition, several error corrections:\
\
12.1. Corrected a short, fixed-size buffer for the file/path names
specified by the command line arguments -output, -error and for the
settings file.\
\
12.2. Two other corrected errors were in p3_set_gs_primer_self_end and
p3_set_gs_primer_internal_oligo_self_end, which erroneously multiplied
their \'val\' arguments by 100.\
\
12.3. Primer3 now detects and handles the situation in which
user-supplied primers ([SEQUENCE_PRIMER](#SEQUENCE_PRIMER) and
[SEQUENCE_PRIMER_REVCOMP](#SEQUENCE_PRIMER_REVCOMP)) have the left
primer to the right of the right primer. Also issue a warning if
user-supplied primers occur in more than one location in the template.\

## [7. INSTALLATION INSTRUCTIONS - UNIX/LINUX]{#installLinux}

Unzip and untar the distribution. DO NOT do this on a PC if you are
going to compile and/or test on a different operation system.
Primer3_core will not compile and various tests will fail if pc newlines
get inserted into the code and test files. Instead, move the
distribution (primer3-\<release\>.tar.gz) to Unix/Linux, and then\
\
\$ unzip primer3-\<release\>.tar.gz\
\$ tar xvf primer3-\<release\>.tar\
\$ cd primer3-\<release\>/src\
\
If you do not use gcc, then you will probably have to modify the
makefile to use your (ANSI) C compiler with the compile and link flags
it understands.\
\
\$ make all\
\
\# You should have created executables primer3_core, ntdpal,\
\# olgotm, and long_seq_tm_test\
\
\$ make test\
\
\# You should not see \'FAILED\' during the tests.\
\
If your perl command is not called perl (for example, if it is called
perl5) you will have to modify the Makefile in the test/ directory.\
\
ntdpal (NucleoTide Dynamic Programming ALignment) is a stand-alone
program that provides Primer3\'s alignment functionality (local, a.k.a.
Smith-Waterman, global, a.k.a. Needleman-Wunsch, plus \"half global\").
It is provided strictly as is; for further documentation please see the
code.

## [8. INSTALLATION INSTRUCTIONS - Mac OSX]{#installMac}

How to install this software\
============================\
\
1. Double click on the .tar.gz file to extract the archive.\
\
2. The binary files are located in the \'bin\' \[for \'binary\'\]
folder\
\
3. (Optional) To run the tests, cd to the new directory and then the
test folder\
\
4. (Optional) Within this folder run: a. \'perl -w p3test.pl\'\
\
5. (Optional) You should not see \'FAILED\' during the tests.\
\
6. (Optional) \*NOTE\*: If your perl command is not called perl (for
example, if it is called perl5) you will have to modify the internals of
the test scripts).\
\
7. Copy the following files to a location of your choice:\
a. bin/long_seq_tm_test\
b. bin/ntdpal\
c. bin/oligotm\
d. bin/primer3_core\
\
8. (Optional) Make sure this location is within your \$PATH (see below)\
\
\
Where to put the binary files\
=============================\
\
A good place to put these is within \~/bin/ (this means in your home
folder, within a folder named \`bin\` \[for \'binary\'\]).\
\
You can also just drag the \'bin\' folder to a location within your home
directory.\
\
You can certainly also copy the files within \'bin\' to /usr/local/bin
(if you are an administrator) or another similar location.\
\
You may need to adjust the permissions on the binaries if you get
fancy.\
\
\
Add the location to your \$PATH\
==============================\
\
This is an optional step, but it will allow you to run Primer3 in any
directory on your machine as your user just by typing its name
(primer3_core).\
\
\*\*\* You should be very careful when altering your \$PATH as things
can go very wrong. See below for an alternate method. \*\*\*\
\
If you added the binaries to /usr/local/bin, then you do not need to do
this.\
\
If you added the binaries to a local directory (let\'s say \~/bin/), do
the following:\
\
1. Edit your \~/.bash_profile. You can edit this on the command line
(Terminal) with:\
\
nano \~/.bash_profile\
\
2. Add the following line if it is not present (replacing \'\~/bin\' if
you used another directory):\
\
PATH=\$PATH:\~/bin/\
\
3. If a PATH line \*is\* present, ensure you add a colon to the end of
what is there and then the directory, so if you have something like:\
\
a) PATH=\$PATH:/usr/local/genome/bin:/sw/bin\
\
make it look like:\
\
b) PATH=\$PATH:/usr/local/genome/bin:/sw/bin:\~/bin\
\
4. Quit and restart terminal for the changes to take effect.\
\
If you don\'t add the location to your \$PATH\
===========================================\
\
Assuming you don\'t want to modify your \$PATH, you can still run the
binaries. Let\'s assume you put the files in \'\~/bin/. You may run
primer3_core by doing either of the following:\
\
1. \~/bin/primer3_core \< yourInputFile\
2. /Users/\<your username\>/bin/primer3_core \< yourInputFile\
\
The first option is just a shortcut to the second.

## [9. INSTALLATION INSTRUCTIONS - WINDOWS]{#installWindows}

Functionality warning\
=====================\
\
The windows version does not support the masker functionality.

How to install this software\
============================\
\
Get your copy of the source code\
\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--\
1. Install Git for Windows from\
https://git-scm.com/download/win\
2. Open Git for Windows and run\
git clone https://github.com/primer3-org/primer3.git\
cd primer3\
3. Use git commands to obtain tagged version\
git tag\
git checkout tags/v2.3.7\
or 1. Download and unpack latest from\
https://github.com/primer3-org/primer3/releases\
Compile Primer3\
\-\-\-\-\-\-\-\-\-\-\-\-\-\--\
\
1. Download and install TDM-GCC MinGW Compiler from\
https://sourceforge.net/projects/tdm-gcc/ 2. Open the windows command
line and change to the src folder in Primer3\
3. Run: mingw32-make TESTOPTS=\--windows\
\
Running the tests\
=================\
You must install a perl distribution to run the windows tests.\
\
We \*strongly\* recommend you install ActiveState perl
(http://www.activestate.com/products/activeperl/) as this was used to
test our Primer3 builds, and it is known to work.\
\
1. Click on \'Start \> Run\...\'\
2. Type \'cmd\' into the space provided\
3. Hit enter (or select \'OK\')\
4. Navigate to the location of the tests:\
\
A. if you put it in\
C:/Documents and Settings/YourName/primer3-\<release\>/test/,\
you would type\
\'cd c:/Documents and Settings/YourName/primer3-\<release\>/test/\'\
\
B. you can also type \'cd \' (don\'t forget the space after cd) and drag
the primer3-\<release\> folder onto the command-line window from windows
explorer, this will fill in the location for you\
\
5. On the command line, run \'mingw32-make TESTOPTS=\--windows\' in this
directory. You can also run the tests individually, for example \'perl
p3test.pl \--windows\'.\
6. You should see \[OK\] for the majority of the tests. The masker
functionality is not supported on Windows and coresponding tests will
fail.\
\
Running the software\
====================\
\
To run the program, you must do so from the MS-DOS command-line. The
intricacies of the DOS command line are beyond the scope of this
document. Google for more information, if needed. Here is a quick
summary:\
\
1. Click on \'Start \> Run\...\'\
2. Type \'cmd\' into the space provided\
3. Hit enter (or select \'OK\')\
4. Navigate to the location of the binary:\
\
A. if you put it in\
C:/Documents and Settings/YourName/Temp,\
you would type\
\'cd c:/Documents and Settings/YourName/Temp\'\
\
B. you can also type \'cd \' (don\'t forget the space after cd) and drag
the Primer3 folder onto the command-line window from windows explorer,
this will fill in the location for you\
\
5. Run the example file by typing:\
\
primer3_core.exe \< example\
\
Other files may be run in a similar fashion. If your input filename is
\'MyData.txt\' you can run Primer3 using this file (in the correct
format; see README) with:\
\
primer3_core.exe \< MyData.txt\
\
If your file is not in the folder containing primer3_core.exe, you could
run the program from the primer3_core folder using:\
\
primer3_core.exe \< c:/someOtherFolder/someOtherFolder/MyData.txt\
\
Finally, if you want to run the program without going to its folder,
assuming primer3_core.exe is in c:/Temp, you could run:\
\
c:/Temp/primer3_core.exe \<
c:/someOtherFolder/someOtherFolder/MyData.txt

## [10. SYSTEM REQUIREMENTS]{#systemRequirements}

Please see <https://github.com/primer3-org/primer3> for up-to-date
information. Primer3 should compile on any system using with an ANSI C
compiler like Linux/Unix, MacOS 10 or MS Windows. The Makefile will
probably need to be modified for compilation with C compilers other than
gcc.

## [11. INVOKING primer3_core]{#invokingPrimer3}

By default, the executable program produced by the Makefile is called
primer3_core. This is the C program that does the heavy lifting of
primer picking. There are also two, more user-friendly, web interfaces
(distributed separately).\
\
The command line for Primer3 is:\
\
primer3_core \[ \--format_output \] \[
\--default_version=1\|\--default_version=2 \] \[ \--io_version=4 \] \[
\--p3_settings_file=\<file_path\> \] \[ \--echo_settings_file \] \[
\--strict_tags \] \[ \--output=\<file_path\> \] \[
\--error=\<file_path\> \] \[ input_file \]\
\
A complete list of valid command line arguments can be found in COMMAND
LINE ARGUMENTS below.\
\
If no input file is specified, primer3_core will read its input from
stdin.

## [12. COMMAND LINE ARGUMENTS]{#commandLineTags}

This section presents the list of arguments that may given in the
command line. Any unique abbreviation of the arguments is allowed (e.g.
-ab instead of -about) and each argument can be preceded by either one
or two dashes. In the case of arguments that receive values, the \'=\'
can be replaced by a space.

### \--about

With this argument Primer3 generates one line of output indicating the
release number and then exits. This allows scripts to query Primer3 for
its version.

### \--default_version=n

*n*=2 is the default, and directs primer3_core to use the latest default
values (the ones documented here). *n*=1 directs primer3_core to use
defaults from version 2.2.3 and before.

### \--format_output

This argument indicates that primer3_core should generate user-oriented
(rather than program-oriented) output.

### \--strict_tags

This argument indicates that primer3_core should generate a fatal error
if there is any tag in the input that it does not recognize. This tag
also applies to the settings file (see documentation for the
\--p3_settings_file argument), if any, but with limitations: lines that
do not begin with PRIMER\_ or P3_FILE_ID are always ignored in the
settings file.

### \--p3_settings_file=file_path

This argument specifies a settings file, *file_path*. Primer3 reads the
global (\"PRIMER\_\...\") parameters from this file first. Tags
appearing in the settings file override default Primer3 settings. The
values set in the settings files can be also overridden by tags in the
input file. See Primer3 file documentation for details on the file
format. **WARNING: the \--strict_tags flag applies only to tags
beginning with the string \"PRIMER\_\"; lines that do not begin with the
string \"PRIMER\_\" are ignored.**

### \--echo_settings_file

This argument indicates that primer3_core should print the input tags
specified in the given settings file. If no settings file is provided or
if the \--format_output option is given, this argument will have no
effect.

### \--io_version=n

This argument is provided for backward compatibility. \--io_version=4
**is the only legal value and the default** .

### \--output=file_path

This argument specifies the file where the output should be written. If
omitted, stdout is used.

### \--error=file_path

This argument specifies the file where the error messages should be
written. If omitted, stderr is used.

## [13. INPUT AND OUTPUT CONVENTIONS]{#inputOutputConventions}

By default, Primer3 accepts input in Boulder-IO format, a pre-XML,
pre-RDF, text-based input/output format for program-to-program data
interchange. By default, Primer3 also produces output in the same
format.\
\
When run with the \--format_output command-line flag, Primer3 prints a
more user-oriented report for each sequence.\
\
Primer3 exits with 0 status if it operates correctly. See EXIT STATUS
CODES below for additional information.\
\
The syntax of the version of Boulder-IO recognized by Primer3 is as
follows:

      o Input consists of a sequence of RECORDs.
      o A RECORD consists of a sequence of (TAG,VALUE) pairs, each terminated
        by a newline character (\n). A RECORD is terminated by  '='
        appearing by itself on a line.
      o A (TAG,VALUE) pair has the following requirements:
        o the TAG must be immediately (without spaces)
              followed by '='.

An example of a legal (TAG,VALUE) pair is\
\
[SEQUENCE_ID](#SEQUENCE_ID)=my_marker\
\
and an example of a Boulder-IO record is\
\
[SEQUENCE_ID](#SEQUENCE_ID)=test1\
[SEQUENCE_TEMPLATE](#SEQUENCE_TEMPLATE)=GACTGATCGATGCTAGCTACGATCGATCGATGCATGCTAGCTAGCTAGCTGCTAGC\
=\
\
Many records can be sent, one after another. Below is an example of
three different records which might be passed through a Boulder-IO
stream:\
\
[SEQUENCE_ID](#SEQUENCE_ID)=test1\
[SEQUENCE_TEMPLATE](#SEQUENCE_TEMPLATE)=GACTGATCGATGCTAGCTACGATCGATCGATGCATGCTAGCTAGCTAGCTGCTAGC\
=\
[SEQUENCE_ID](#SEQUENCE_ID)=test2\
[SEQUENCE_TEMPLATE](#SEQUENCE_TEMPLATE)=CATCATCATCATCGATGCTAGCATCNNACGTACGANCANATGCATCGATCGT\
=\
[SEQUENCE_ID](#SEQUENCE_ID)=test3\
[SEQUENCE_TEMPLATE](#SEQUENCE_TEMPLATE)=NACGTAGCTAGCATGCACNACTCGACNACGATGCACNACAGCTGCATCGATGC\
=\
\
Primer3 reads Boulder-IO on stdin and echos its input and returns
results in Boulder-IO format on stdout. Primer3 indicates many
user-correctable errors by a value in the output tag
[PRIMER_ERROR](#PRIMER_ERROR) (see below). Primer3 indicates other
errors, including system configuration errors, resource errors (such
out-of-memory errors), and detected programming errors by a message on
stderr and a non-zero exit status.\
\
This document lists the input tags that Primer3 recognizes. Primer3
echos and ignores any tags it does not recognize, unless the
\--strict_tags flag is set on the command line, in which case Primer3
prints an error in the [PRIMER_ERROR](#PRIMER_ERROR) output tag (see
below), and prints additional information on stdout; this option can be
useful for debugging systems that incorporate Primer3.\
\
Except for tags with the type \"interval list\" each tag should only
appear ONCE in any given input record. This restriction is not
systematically checked, and if a tag appears more than once, the new
value silently over-writes the previous value.

## [14. AN EXAMPLE]{#example}

One might be interested in performing PCR on an STS with a CA repeat in
the middle of it. Primers need to be chosen based on the criteria of the
experiment.\
\
We need to create a Boulder-IO record to send to Primer3 via stdin.
There are lots of ways to accomplish this. We could save the record into
a text file called \'example\', and then type the Unix command
\'primer3_core \< example\'.\
\
Let\'s look at the input record itself:\
[SEQUENCE_ID](#SEQUENCE_ID)=example\
[SEQUENCE_TEMPLATE](#SEQUENCE_TEMPLATE)=GTAGTCAGTAGACNATGACNACTGACGATGCAGACNACACACACACACACAGCACACAGGTATTAGTGGGCCATTCGATCCCGACCCAAATCGATAGCTACGATGACG\
[SEQUENCE_TARGET](#SEQUENCE_TARGET)=37,21\
[PRIMER_TASK](#PRIMER_TASK)=generic\
[PRIMER_PICK_LEFT_PRIMER](#PRIMER_PICK_LEFT_PRIMER)=1\
[PRIMER_PICK_INTERNAL_OLIGO](#PRIMER_PICK_INTERNAL_OLIGO)=1\
[PRIMER_PICK_RIGHT_PRIMER](#PRIMER_PICK_RIGHT_PRIMER)=1\
[PRIMER_OPT_SIZE](#PRIMER_OPT_SIZE)=18\
[PRIMER_MIN_SIZE](#PRIMER_MIN_SIZE)=15\
[PRIMER_MAX_SIZE](#PRIMER_MAX_SIZE)=21\
[PRIMER_MAX_NS_ACCEPTED](#PRIMER_MAX_NS_ACCEPTED)=1\
[PRIMER_PRODUCT_SIZE_RANGE](#PRIMER_PRODUCT_SIZE_RANGE)=75-100\
[P3_FILE_FLAG](#P3_FILE_FLAG)=1\
[SEQUENCE_INTERNAL_EXCLUDED_REGION](#SEQUENCE_INTERNAL_EXCLUDED_REGION)=37,21\
[PRIMER_EXPLAIN_FLAG](#PRIMER_EXPLAIN_FLAG)=1\
=\
\
A breakdown of the reasoning behind each of the TAG=VALUE pairs is
below:\
\
[SEQUENCE_ID](#SEQUENCE_ID)=example\
\
The main intent of this tag is to provide an identifier for the sequence
that is meaningful to the user, for example when Primer3 processes
multiple records, and by default this tag is optional. However, this tag
is \_required\_ when [P3_FILE_FLAG](#P3_FILE_FLAG) is non-0 Because it
provides the names of the files that contain lists of oligos that
Primer3 considered.\
\
[SEQUENCE_TEMPLATE](#SEQUENCE_TEMPLATE)=GTAGTCAGTAGACNATGACNACTGACGATGCAGACNACACACACACACACAGCACACAGGTATTAGTGGGCCATTCGATCCCGACCCAAATCGATAGCTACGATGACG\
\
The [SEQUENCE_TEMPLATE](#SEQUENCE_TEMPLATE) provides the sequence from
which Primer3 will design primers. Note that there is no newline until
the sequence terminates completely.\
\
[SEQUENCE_TARGET](#SEQUENCE_TARGET)=37,21\
\
There is a simple sequence repeat in this sequence. The repeat starts at
base 37, and has a length of 21 bases. We instruct Primer3 to choose
primers that flank the repeat site (because we want to use the PCR
product for determining the length of the repeat, which is likely to be
polymorphic).\
\
[PRIMER_TASK](#PRIMER_TASK)=generic\
\
The [PRIMER_TASK](#PRIMER_TASK) tells Primer3 which type of primers to
pick. You can select typical primers for PCR detection, primers for
cloning or for sequencing.\
\
[PRIMER_PICK_LEFT_PRIMER](#PRIMER_PICK_LEFT_PRIMER)=1\
[PRIMER_PICK_INTERNAL_OLIGO](#PRIMER_PICK_INTERNAL_OLIGO)=1\
[PRIMER_PICK_RIGHT_PRIMER](#PRIMER_PICK_RIGHT_PRIMER)=1\
\
We would like to pick a left primer, an internal oligo and a right
primer, so we set these flags to 1 (true). In combination with the
[PRIMER_TASK](#PRIMER_TASK) this tags control which primers are picked.\
\
[PRIMER_OPT_SIZE](#PRIMER_OPT_SIZE)=18\
\
Since our sequence length is rather small (only 108 bases long), we
lower the [PRIMER_OPT_SIZE](#PRIMER_OPT_SIZE) from 20 to 18. It is more
likely that Primer3 will succeed if it aims for smaller primers.\
\
[PRIMER_MIN_SIZE](#PRIMER_MIN_SIZE)=15\
[PRIMER_MAX_SIZE](#PRIMER_MAX_SIZE)=21\
\
With the lowering of optimal primer size, it\'s good to lower the
minimum and maximum sizes as well.\
\
[PRIMER_MAX_NS_ACCEPTED](#PRIMER_MAX_NS_ACCEPTED)=1\
\
Since the sequence is short with a non-negligible amount of unknown
bases (N\'s) in it, we make Primer3\'s job easier by allowing it to pick
primers that have at most 1 unknown base.\
\
[PRIMER_PRODUCT_SIZE_RANGE](#PRIMER_PRODUCT_SIZE_RANGE)=75-100\
\
We reduce the product size range from the default of 100-300 because our
source sequence is only 108 base pairs long. If we insisted on a product
size of 100 base pairs Primer3 would have few possibilities to choose
from.\
\
[P3_FILE_FLAG](#P3_FILE_FLAG)=1\
\
Because we have a short sequence with many Ns and with a simple sequence
repeat that we must amplify, Primer3 might fail to pick and primers.
Therefore, we want to get the list of primers it considered, so that we
could manually pick primers ourselves if Primer3 fails to do so. Setting
this flag to 1 asks Primer3 to output the primers it considered to a
forwar primers and reverse primers to output files.\
\
[SEQUENCE_INTERNAL_EXCLUDED_REGION](#SEQUENCE_INTERNAL_EXCLUDED_REGION)=37,21\
\
Normally CA-repeats make poor hybridization probes (because they not
specific enough). Therefore, we exclude the CA repeat (which is the
TARGET) from consideration for the internal oligo.\
\
[PRIMER_EXPLAIN_FLAG](#PRIMER_EXPLAIN_FLAG)=1\
\
We want to see statistics about the oligos and oligo triples (left
primer, internal oligo, right primer) that Primer3 examined.\
\
=\
\
The \'=\' character terminates the record.\
\
There were many Boulder-IO input tags that were not specified, which is
legal. For the tags with default values, those defaults will be used in
the analysis. For the tags with NO default values (for example
[SEQUENCE_TARGET](#SEQUENCE_TARGET)), the functionality requested by the
those tags will be absent. Also, please note that it is not the case
that we need to surround a simple sequence repeat every time we want to
pick primers!

## [15. HOW TO MIGRATE TAGS TO IO VERSION 4]{#migrateTags}

With Primer3 release 2.0, many Boulder-IO tags were modified and new
tags were introduced. The new Primer3 tags are designed with the idea in
mind that computer scripts and other programs use primer3_core. The
modifications make it easier for programs to read and write Primer3
input and output.\
\
Furthermore the Primer3 default values and the use of
[PRIMER_WT_TEMPLATE_MISPRIMING](#PRIMER_WT_TEMPLATE_MISPRIMING) and
[PRIMER_PAIR_WT_TEMPLATE_MISPRIMING](#PRIMER_PAIR_WT_TEMPLATE_MISPRIMING)
have changed in version 2.0.\
\
There are three classes of input: \"Sequence\" input tags describe a
particular input sequence to Primer3, and are reset after every Boulder
record (now starting with SEQUENCE\_). \"Global\" input tags describe
the general parameters that Primer3 should use in its searches, and the
values of these tags persist between input Boulder records until or
unless they are explicitly reset (now starting with PRIMER\_).
\"Program\" parameters that deal with the behavior of the Primer3
program itself (now starting with P3\_). See below for a list of the
modified tags.\
\
The handling of PRIMER_TASK changed completely. In the past we used it
to tell Primer3 what task to perform. Now the task is complemented with
[PRIMER_PICK_RIGHT_PRIMER](#PRIMER_PICK_RIGHT_PRIMER),
[PRIMER_PICK_INTERNAL_OLIGO](#PRIMER_PICK_INTERNAL_OLIGO) and
[PRIMER_PICK_LEFT_PRIMER](#PRIMER_PICK_LEFT_PRIMER), which specify which
primers are to be picked.\
\
These Tags are modified:\
\
The \"per sequence\" tags:

    NEW VERSION                       - OLD VERSION
    ----------------------------------------------------------------------------------------
    SEQUENCE_ID                       - PRIMER_SEQUENCE_ID
    SEQUENCE_TEMPLATE                 - SEQUENCE
    SEQUENCE_QUALITY                  - PRIMER_SEQUENCE_QUALITY
    SEQUENCE_INCLUDED_REGION          - INCLUDED_REGION
    SEQUENCE_TARGET                   - TARGET
    SEQUENCE_EXCLUDED_REGION          - EXCLUDED_REGION
    SEQUENCE_START_CODON_POSITION     - PRIMER_START_CODON_POSITION
    SEQUENCE_PRIMER                   - PRIMER_LEFT_INPUT
    SEQUENCE_PRIMER_REVCOMP           - PRIMER_RIGHT_INPUT
    SEQUENCE_INTERNAL_OLIGO           - PRIMER_INTERNAL_OLIGO_INPUT
    SEQUENCE_INTERNAL_EXCLUDED_REGION - PRIMER_INTERNAL_OLIGO_EXCLUDED_REGION
    --------------------------------------------------------------------------------
    The "global" tags:
    NEW VERSION                       - OLD VERSION
    PRIMER_TASK                       - PRIMER_TASK (modified use)
    PRIMER_PICK_RIGHT_PRIMER          - --- did not exist
    PRIMER_PICK_INTERNAL_OLIGO        - PRIMER_PICK_INTERNAL_OLIGO (modified use)
    PRIMER_PICK_LEFT_PRIMER           - --- did not exist
    PRIMER_PAIR_WT_TEMPLATE_MISPRIMING- PRIMER_PAIR_WT_TEMPLATE_MISPRIMING (modified use)
    PRIMER_WT_TEMPLATE_MISPRIMING     - PRIMER_WT_TEMPLATE_MISPRIMING (modified use)
    PRIMER_MAX_LIBRARY_MISPRIMING     - PRIMER_MAX_MISPRIMING
    PRIMER_INTERNAL_MAX_LIBRARY_MISHYB- PRIMER_INTERNAL_OLIGO_MAX_MISHYB
    PRIMER_PAIR_MAX_LIBRARY_MISPRIMING- PRIMER_PAIR_MAX_MISPRIMING
    PRIMER_WT_LIBRARY_MISPRIMING      - PRIMER_WT_REP_SIM
    PRIMER_INTERNAL_WT_LIBRARY_MISHYB - PRIMER_INTERNAL_WT_REP_SIM
    PRIMER_PAIR_WT_LIBRARY_MISPRIMING - PRIMER_PAIR_WT_REP_SIM
    PRIMER_MAX_NS_ACCEPTED            - PRIMER_NUM_NS_ACCEPTED
    PRIMER_PAIR_MAX_DIFF_TM           - PRIMER_MAX_DIFF_TM
    PRIMER_SALT_MONOVALENT            - PRIMER_SALT_CONC
    PRIMER_SALT_DIVALENT              - PRIMER_DIVALENT_CONC
    PRIMER_TM_FORMULA                 - PRIMER_TM_SANTALUCIA
    PRIMER_MAX_SELF_ANY               - PRIMER_SELF_ANY
    PRIMER_MAX_SELF_END               - PRIMER_SELF_END
    PRIMER_WT_SELF_ANY                - PRIMER_WT_COMPL_ANY
    PRIMER_WT_SELF_END                - PRIMER_WT_COMPL_END
    PRIMER_PAIR_MAX_COMPL_ANY         - PRIMER_PAIR_ANY
    PRIMER_PAIR_MAX_COMPL_END         - PRIMER_PAIR_END
    P3_FILE_FLAG                      - PRIMER_FILE_FLAG
    P3_COMMENT                        - PRIMER_COMMENT
    PRIMER_INTERNAL_SALT_MONOVALENT   - PRIMER_INTERNAL_OLIGO_SALT_CONC
    PRIMER_INTERNAL_SALT_DIVALENT     - PRIMER_INTERNAL_OLIGO_DIVALENT_CONC
    PRIMER_INTERNAL_WT_SELF_ANY       - PRIMER_IO_WT_COMPL_ANY
    PRIMER_INTERNAL_WT_SELF_END       - PRIMER_IO_WT_COMPL_END
    PRIMER_INTERNAL_MAX_NS_ACCEPTED   - PRIMER_INTERNAL_OLIGO_NUM_NS
    PRIMER_INTERNAL_MAX_SELF_ANY      - PRIMER_INTERNAL_OLIGO_SELF_ANY
    PRIMER_INTERNAL_MAX_SELF_END      - PRIMER_INTERNAL_OLIGO_SELF_END
    The following tags INTERNAL_OLIGO is replaced by INTERNAL:
    PRIMER_INTERNAL_OPT_SIZE          - PRIMER_INTERNAL_OLIGO_OPT_SIZE
    PRIMER_INTERNAL_MIN_SIZE          - PRIMER_INTERNAL_OLIGO_MIN_SIZE
    PRIMER_INTERNAL_MAX_SIZE          - PRIMER_INTERNAL_OLIGO_MAX_SIZE
    PRIMER_INTERNAL_OPT_TM            - PRIMER_INTERNAL_OLIGO_OPT_TM
    PRIMER_INTERNAL_MIN_TM            - PRIMER_INTERNAL_OLIGO_MIN_TM
    PRIMER_INTERNAL_MAX_TM            - PRIMER_INTERNAL_OLIGO_MAX_TM
    PRIMER_INTERNAL_MIN_GC            - PRIMER_INTERNAL_OLIGO_MIN_GC
    PRIMER_INTERNAL_OPT_GC_PERCENT    - PRIMER_INTERNAL_OLIGO_OPT_GC_PERCENT
    PRIMER_INTERNAL_MAX_GC            - PRIMER_INTERNAL_OLIGO_MAX_GC
    PRIMER_INTERNAL_DNTP_CONC         - PRIMER_INTERNAL_OLIGO_DNTP_CONC
    PRIMER_INTERNAL_DNA_CONC          - PRIMER_INTERNAL_OLIGO_DNA_CONC
    PRIMER_INTERNAL_MAX_POLY_X        - PRIMER_INTERNAL_OLIGO_MAX_POLY_X
    PRIMER_INTERNAL_MISHYB_LIBRARY    - PRIMER_INTERNAL_OLIGO_MISHYB_LIBRARY
    PRIMER_INTERNAL_MIN_QUALITY       - PRIMER_INTERNAL_OLIGO_MIN_QUALITY
    The following tags IO is replaced by INTERNAL:
    PRIMER_INTERNAL_WT_TM_GT          - PRIMER_IO_WT_TM_GT
    PRIMER_INTERNAL_WT_TM_LT          - PRIMER_IO_WT_TM_LT
    PRIMER_INTERNAL_WT_SIZE_LT        - PRIMER_IO_WT_SIZE_LT
    PRIMER_INTERNAL_WT_SIZE_GT        - PRIMER_IO_WT_SIZE_GT
    PRIMER_INTERNAL_WT_GC_PERCENT_LT  - PRIMER_IO_WT_GC_PERCENT_LT
    PRIMER_INTERNAL_WT_GC_PERCENT_GT  - PRIMER_IO_WT_GC_PERCENT_GT
    PRIMER_INTERNAL_WT_NUM_NS         - PRIMER_IO_WT_NUM_NS
    PRIMER_INTERNAL_WT_SEQ_QUAL       - PRIMER_IO_WT_SEQ_QUAL

\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\-\--\
OUTPUT TAGS:\
\
There are three big changes on the output:\
- INTERNAL_OLIGO is now replaced by INTERNAL.\
- The first version is numbered 0.\
- The \"PRODUCT\" tags are renamed\
- The errors are modified\
- Errors caused by a specific primer are given as
[PRIMER_LEFT_4_PROBLEMS](#PRIMER_LEFT_4_PROBLEMS)\
\
Now all primer related output follows the rule:
PRIMER\_{LEFT,RIGHT,INTERNAL,PAIR}\_\<j\>\_\<tag_name\>. where \<j\> is
an integer from 0 to n, where n is at most the value of
[PRIMER_NUM_RETURN](#PRIMER_NUM_RETURN) - 1.\
\
This allows easy scripting by using the underscores \_ to split the
name. The first part is PRIMER, the second the type of oligo or pair
parameters, the third is always a number, starting at 0 and the rest is
used by the tags.\
\
That affects also (shown for output number 4):

    NEW VERSION                             - OLD VERSION
    ------------------------------------------------------------------------------------------------------
    PRIMER_PAIR_4_PENALTY                   - PRIMER_PAIR_PENALTY_4 (number moved behind PAIR)
    PRIMER_PAIR_4_PRODUCT_SIZE              - PRIMER_PRODUCT_SIZE_4 (grouped with PAIR)
    PRIMER_PAIR_4_PRODUCT_TM                - PRIMER_PRODUCT_TM_4 (grouped with PAIR)
    PRIMER_PAIR_4_PRODUCT_TM_OLIGO_TM_DIFF  - PRIMER_PRODUCT_TM_OLIGO_TM_DIFF_4 (grouped with PAIR)
    PRIMER_INTERNAL_EXPLAIN                 - PRIMER_INTERNAL_OLIGO_EXPLAIN
    PRIMER_LEFT_4_LIBRARY_MISPRIMING                   - PRIMER_LEFT_4_MISPRIMING_SCORE
    PRIMER_INTERNAL_4_LIBRARY_MISHYB                   - PRIMER_INTERNAL_OLIGO_4_MISHYB_SCORE
    PRIMER_RIGHT_4_LIBRARY_MISPRIMING                  - PRIMER_RIGHT_4_MISPRIMING_SCORE
    PRIMER_PAIR_4_LIBRARY_MISPRIMING                   - PRIMER_PAIR_4_MISPRIMING_SCORE

## [16. \"SEQUENCE\" INPUT TAGS]{#sequenceTags}

\"Sequence\" input tags start with SEQUENCE\_\... and describe a
particular input sequence to Primer3. They are reset after every Boulder
record. Errors in \"Sequence\" input tags invalidate the current record,
but Primer3 will continue to process additional records.

  ----------------------------------------------------------- ------------------------------------------------------------------------------------- -----------------------------------------------------------------------------
  [SEQUENCE_EXCLUDED_REGION](#SEQUENCE_EXCLUDED_REGION)       [SEQUENCE_INTERNAL_EXCLUDED_REGION](#SEQUENCE_INTERNAL_EXCLUDED_REGION)               [SEQUENCE_PRIMER_PAIR_OK_REGION_LIST](#SEQUENCE_PRIMER_PAIR_OK_REGION_LIST)
  [SEQUENCE_FORCE_LEFT_END](#SEQUENCE_FORCE_LEFT_END)         [SEQUENCE_INTERNAL_OLIGO](#SEQUENCE_INTERNAL_OLIGO)                                   [SEQUENCE_PRIMER_REVCOMP](#SEQUENCE_PRIMER_REVCOMP)
  [SEQUENCE_FORCE_LEFT_START](#SEQUENCE_FORCE_LEFT_START)     [SEQUENCE_INTERNAL_OVERLAP_JUNCTION_LIST](#SEQUENCE_INTERNAL_OVERLAP_JUNCTION_LIST)   [SEQUENCE_QUALITY](#SEQUENCE_QUALITY)
  [SEQUENCE_FORCE_RIGHT_END](#SEQUENCE_FORCE_RIGHT_END)       [SEQUENCE_OVERHANG_LEFT](#SEQUENCE_OVERHANG_LEFT)                                     [SEQUENCE_START_CODON_POSITION](#SEQUENCE_START_CODON_POSITION)
  [SEQUENCE_FORCE_RIGHT_START](#SEQUENCE_FORCE_RIGHT_START)   [SEQUENCE_OVERHANG_RIGHT](#SEQUENCE_OVERHANG_RIGHT)                                   [SEQUENCE_START_CODON_SEQUENCE](#SEQUENCE_START_CODON_SEQUENCE)
  [SEQUENCE_ID](#SEQUENCE_ID)                                 [SEQUENCE_OVERLAP_JUNCTION_LIST](#SEQUENCE_OVERLAP_JUNCTION_LIST)                     [SEQUENCE_TARGET](#SEQUENCE_TARGET)
  [SEQUENCE_INCLUDED_REGION](#SEQUENCE_INCLUDED_REGION)       [SEQUENCE_PRIMER](#SEQUENCE_PRIMER)                                                   [SEQUENCE_TEMPLATE](#SEQUENCE_TEMPLATE)
  ----------------------------------------------------------- ------------------------------------------------------------------------------------- -----------------------------------------------------------------------------

### [SEQUENCE_ID (string; default empty)]{#SEQUENCE_ID}

Short description of the sequence. It is used as an identifier that is
reproduced in the output to enable users to identify the source of the
chosen primers.\
\
This tag must be present if [P3_FILE_FLAG](#P3_FILE_FLAG) is non-zero.

### [SEQUENCE_TEMPLATE (nucleotide sequence; default empty)]{#SEQUENCE_TEMPLATE}

The sequence from which to choose primers. The sequence must be
presented 5\' -\> 3\' (i.e, in the normal way). In general, the bases
may be upper or lower case, but lower case letters are treated specially
if [PRIMER_LOWERCASE_MASKING](#PRIMER_LOWERCASE_MASKING) is set. The
entire sequence MUST be all on a single line. (In other words, the
sequence cannot span several lines.)

### [SEQUENCE_INCLUDED_REGION (interval list; default empty)]{#SEQUENCE_INCLUDED_REGION}

A sub-region of the given sequence in which to pick primers. For
example, often the first dozen or so bases of a sequence are vector, and
should be excluded from consideration. The value for this parameter has
the form

    <start>,<length>

where [*\<start\>*]{.p3_prop} is the index of the first base to
consider, and [*\<length\>*]{.p3_prop} is the number of subsequent bases
in the primer-picking region.

### [SEQUENCE_TARGET (interval list; default empty)]{#SEQUENCE_TARGET}

If one or more targets is specified then a legal primer pair must flank
at least one of them. A target might be a simple sequence repeat site
(for example a CA repeat) or a single-base-pair polymorphism, or an exon
for resequencing. The value should be a space-separated list of

    <start>,<length>

pairs where [*\<start\>*]{.p3_prop} is the index of the first base of a
target, and [*\<length\>*]{.p3_prop} is its length.

See also PRIMER_INSIDE_PENALTY, PRIMER_OUTSIDE_PENALTY. Has a different
meaning when PRIMER_TASK=pick_sequencing_primers. See PRIMER_TASK for
more information.

### [SEQUENCE_EXCLUDED_REGION (interval list; default empty)]{#SEQUENCE_EXCLUDED_REGION}

Left and Right primers and oligos may not overlap any region specified
in this tag. The middle oligo may overlap, they may be limited by
[SEQUENCE_INTERNAL_EXCLUDED_REGION](#SEQUENCE_INTERNAL_EXCLUDED_REGION).
The associated value must be a space-separated list of

    <start>,<length>

pairs where [*\<start\>*]{.p3_prop} is the index of the first base of
the excluded region, and [*\<length\>*]{.p3_prop} is its length. This
tag is useful for tasks such as excluding regions of low sequence
quality or for excluding regions containing repetitive elements such as
ALUs or LINEs.

### [SEQUENCE_PRIMER_PAIR_OK_REGION_LIST (semicolon separated list of integer quadruples; default empty)]{#SEQUENCE_PRIMER_PAIR_OK_REGION_LIST}

This tag allows detailed specification of possible locations of left and
right primers in primer pairs.\
\
The associated value must be a semicolon-separated list of

    <left_start>,<left_length>,<right_start>,<right_length>

quadruples. The left primer must be in the region specified by
[*\<left_start\>*]{.p3_prop},[*\<left_length\>*]{.p3_prop} and the right
primer must be in the region specified by
[*\<right_start\>*]{.p3_prop},[*\<right_length\>*]{.p3_prop}.
[*\<left_start\>*]{.p3_prop} and [*\<left_length\>*]{.p3_prop} specify
the location of the left primer in terms of the index of the first base
in the region and the length of the region.
[*\<right_start\>*]{.p3_prop} and [*\<right_length\>*]{.p3_prop} specify
the location of the right primer in analogous fashion. As seen in the
example below, if no integers are specified for a region then the
location of the corresponding primer is not constrained.\
\
Example:

    SEQUENCE_PRIMER_PAIR_OK_REGION_LIST=100,50,300,50 ; 900,60,, ; ,,930,100

\
Specifies that there are three choices:\
\
Left primer in the 50 bp region starting at position 100 AND right
primer in the 50 bp region starting at position 300\
\
OR\
\
Left primer in the 60 bp region starting at position 900 (and right
primer anywhere)\
\
OR\
\
Right primer in the 100 bp region starting at position 930 (and left
primer anywhere)

### [SEQUENCE_OVERLAP_JUNCTION_LIST (space separated integers; default empty)]{#SEQUENCE_OVERLAP_JUNCTION_LIST}

If this list is not empty, then the forward OR the reverse primer must
overlap one of these junction points by at least
[PRIMER_MIN_3_PRIME_OVERLAP_OF_JUNCTION](#PRIMER_MIN_3_PRIME_OVERLAP_OF_JUNCTION)
nucleotides at the 3\' end and at least
[PRIMER_MIN_5_PRIME_OVERLAP_OF_JUNCTION](#PRIMER_MIN_5_PRIME_OVERLAP_OF_JUNCTION)
nucleotides at the 5\' end.\
\
In more detail: The junction associated with a given position is the
space immediately to the right of that position in the template sequence
on the strand given as input.\
\
For example:


    SEQUENCE_OVERLAP_JUNCTION_LIST=20
    # 1-based indexes
    PRIMER_MIN_3_PRIME_OVERLAP_OF_JUNCTION=4
    template: atcataggccatgcctgagc^gctacgact
              ok           ...gagc^gcta-3'  (left primer)
              not ok       ...gagc^gct-3'   (left primer)
              ok           3'-ctcg^cgat...  (right pimer)
              not ok        3'-tcg^cgat...  (right primer)
    PRIMER_MIN_5_PRIME_OVERLAP_OF_JUNCTION=5
             ok           5'-tgagc^gccg...  (left primer)
             not ok        5'-gagc^gccg...  (left primer)
             ok           ...tgagc^gctac-5' (right primer)
             not ok       ...tgagc^gcta-5'  (right primer)

### [SEQUENCE_INTERNAL_OVERLAP_JUNCTION_LIST (space separated integers; default empty)]{#SEQUENCE_INTERNAL_OVERLAP_JUNCTION_LIST}

If this list is not empty, then the internal (middle) oligo must overlap
one of these junction points by at least
[PRIMER_INTERNAL_MIN_3_PRIME_OVERLAP_OF_JUNCTION](#PRIMER_INTERNAL_MIN_3_PRIME_OVERLAP_OF_JUNCTION)
nucleotides at the 3\' (right) end and at least
[PRIMER_INTERNAL_MIN_5_PRIME_OVERLAP_OF_JUNCTION](#PRIMER_INTERNAL_MIN_5_PRIME_OVERLAP_OF_JUNCTION)
nucleotides at the 5\' (left) end.\
\
See [SEQUENCE_OVERLAP_JUNCTION_LIST](#SEQUENCE_OVERLAP_JUNCTION_LIST)
for more detail.

### [SEQUENCE_INTERNAL_EXCLUDED_REGION (interval list; default empty)]{#SEQUENCE_INTERNAL_EXCLUDED_REGION}

Middle oligos may not overlap any region specified by this tag. Left and
right primers may overlap. The associated value must be a
space-separated list of

    <start>,<length>

pairs, where \<start\> is the index of the first base of an excluded
region, and \<length\> is its length. Often one would make Target
regions excluded regions for internal oligos.

### [SEQUENCE_PRIMER (nucleotide sequence; default empty)]{#SEQUENCE_PRIMER}

The sequence of a left primer to check and around which to design right
primers and optional internal oligos. Must be a substring of
[SEQUENCE_TEMPLATE](#SEQUENCE_TEMPLATE).

### [SEQUENCE_INTERNAL_OLIGO (nucleotide sequence; default empty)]{#SEQUENCE_INTERNAL_OLIGO}

The sequence of an internal oligo to check and around which to design
left and right primers. Must be a substring of
[SEQUENCE_TEMPLATE](#SEQUENCE_TEMPLATE).

### [SEQUENCE_PRIMER_REVCOMP (nucleotide sequence; default empty)]{#SEQUENCE_PRIMER_REVCOMP}

The sequence of a right primer to check and around which to design left
primers and optional internal oligos. Must be a substring of the reverse
strand of [SEQUENCE_TEMPLATE](#SEQUENCE_TEMPLATE).

### [SEQUENCE_OVERHANG_LEFT (string; default empty)]{#SEQUENCE_OVERHANG_LEFT}

The provided sequence is added to the 5\' end of the left primer. The
overhang sequences are utilized in calculating SELF_ANY, SELF_END,
HAIRPIN, COMPL_ANY, COMPL_END, plus the \_TH and \_STRUCT versions of
those outputs, as well as PRODUCT_SIZE. Internal oligos may not have an
overhang.\
\
The length of SEQUENCE_OVERHANG_LEFT and SEQUENCE_OVERHANG_RIGHT do not
add to the binding product size of
[PRIMER_PRODUCT_SIZE_RANGE](#PRIMER_PRODUCT_SIZE_RANGE) or
[PRIMER_PRODUCT_OPT_SIZE](#PRIMER_PRODUCT_OPT_SIZE).\
\
The TM anG GC_PERCENT calculations will only be based on the 3\' portion
of the oligo that binds to the template.\
\
The following elements include SEQUENCE_OVERHANG_LEFT:
[PRIMER_LEFT_4_SELF_ANY](#PRIMER_LEFT_4_SELF_ANY),
[PRIMER_LEFT_4_SELF_ANY_TH](#PRIMER_LEFT_4_SELF_ANY_TH),
[PRIMER_LEFT_4_SELF_ANY_STUCT](#PRIMER_LEFT_4_SELF_ANY_STUCT),
[PRIMER_LEFT_4_SELF_END](#PRIMER_LEFT_4_SELF_END),
[PRIMER_LEFT_4_SELF_END_TH](#PRIMER_LEFT_4_SELF_END_TH),
[PRIMER_LEFT_4_SELF_END_STUCT](#PRIMER_LEFT_4_SELF_END_STUCT),
[PRIMER_LEFT_4_HAIRPIN_TH](#PRIMER_LEFT_4_HAIRPIN_TH),
[PRIMER_LEFT_4_HAIRPIN_STUCT](#PRIMER_LEFT_4_HAIRPIN_STUCT),
[PRIMER_PAIR_4_COMPL_ANY](#PRIMER_PAIR_4_COMPL_ANY),
[PRIMER_PAIR_4_COMPL_ANY_TH](#PRIMER_PAIR_4_COMPL_ANY_TH),
[PRIMER_PAIR_4_COMPL_ANY_STUCT](#PRIMER_PAIR_4_COMPL_ANY_STUCT),
[PRIMER_PAIR_4_COMPL_END](#PRIMER_PAIR_4_COMPL_END),
[PRIMER_PAIR_4_COMPL_END_TH](#PRIMER_PAIR_4_COMPL_END_TH),
[PRIMER_PAIR_4_COMPL_END_STUCT](#PRIMER_PAIR_4_COMPL_END_STUCT),
[PRIMER_PAIR_4_PRODUCT_SIZE](#PRIMER_PAIR_4_PRODUCT_SIZE).

### [SEQUENCE_OVERHANG_RIGHT (string; default empty)]{#SEQUENCE_OVERHANG_RIGHT}

The provided sequence is added to the 5\' end of the right primer. It is
reverse complementary to the template sequence.\
\
See [SEQUENCE_OVERHANG_LEFT](#SEQUENCE_OVERHANG_LEFT) for more details.

### [SEQUENCE_START_CODON_POSITION (int; default -2000000)]{#SEQUENCE_START_CODON_POSITION}

This parameter should be considered EXPERIMENTAL at this point. Please
check the output carefully; some erroneous inputs might cause an error
in Primer3.\
\
Index of the first base of a start codon. This parameter allows Primer3
to select primer pairs to create in-frame amplicons e.g. to create a
template for a fusion protein. Primer3 will attempt to select an
in-frame left primer, ideally starting at or to the left of the start
codon, or to the right if necessary. Negative values of this parameter
are legal if the actual start codon is to the left of available
sequence. If this parameter is non-negative Primer3 signals an error if
the codon at the position specified by this parameter is not an ATG. A
value less than or equal to -10\^6 indicates that Primer3 should ignore
this parameter.\
\
Primer3 selects the position of the right primer by scanning right from
the left primer for a stop codon. Ideally the right primer will end at
or after the stop codon.

### [SEQUENCE_START_CODON_SEQUENCE (string; default ATG)]{#SEQUENCE_START_CODON_SEQUENCE}

The sequence of the start codon, by default ATG. Some bacteria use
different start codons, this tag allows to specify alternative start
codons.\
\
Any triplet can be provided as start codon.

### [SEQUENCE_QUALITY (space separated integers; default empty)]{#SEQUENCE_QUALITY}

A list of space separated integers. There must be exactly one integer
for each base in [SEQUENCE_TEMPLATE](#SEQUENCE_TEMPLATE) if this
argument is non-empty. For example, for the sequence ANNTTCA\...
[SEQUENCE_QUALITY](#SEQUENCE_QUALITY) might be 45 10 0 50 30 34 50 67
\.... High numbers indicate high confidence in the base called at that
position and low numbers indicate low confidence in the base call at
that position. This parameter is only relevant if you are using a base
calling program that provides quality information (for example phred).

### [SEQUENCE_FORCE_LEFT_START (int; default -1000000)]{#SEQUENCE_FORCE_LEFT_START}

Forces the 5\' end of the left primer to be at the indicated position.
Primers are also picked if they violate certain constraints. The default
value indicates that the start of the left primer can be anywhere.

### [SEQUENCE_FORCE_LEFT_END (int; default -1000000)]{#SEQUENCE_FORCE_LEFT_END}

Forces the 3\' end of the left primer to be at the indicated position.
Primers are also picked if they violate certain constraints. The default
value indicates that the end of the left primer can be anywhere.

### [SEQUENCE_FORCE_RIGHT_START (int; default -1000000)]{#SEQUENCE_FORCE_RIGHT_START}

Forces the 5\' end of the right primer to be at the indicated position.
Primers are also picked if they violate certain constraints. The default
value indicates that the start of the right primer can be anywhere.

### [SEQUENCE_FORCE_RIGHT_END (int; default -1000000)]{#SEQUENCE_FORCE_RIGHT_END}

Forces the 3\' end of the right primer to be at the indicated position.
Primers are also picked if they violate certain constraints. The default
value indicates that the end of the right primer can be anywhere.

## [17. \"GLOBAL\" INPUT TAGS]{#globalTags}

\"Global\" input tags start with PRIMER\_\... and describe the general
parameters that Primer3 should use in its searches. The values of these
tags persist between input Boulder records until or unless they are
explicitly reset. Errors in \"Global\" input tags are fatal because they
invalidate the basic conditions under which primers are being picked.\
\
Because the laboratory detection step using internal oligos is
independent of the PCR amplification procedure, internal oligo tags have
defaults that are independent of the parameters that govern the
selection of PCR primers. For example, the melting temperature of an
oligo used for hybridization might be considerably lower than that used
as a PCR primer.\

  ----------------------------------------------------------------------------------------------------- ----------------------------------------------------------------------------------- -------------------------------------------------------------------------------------
  [PRIMER_ANNEALING_TEMP](#PRIMER_ANNEALING_TEMP)                                                       [PRIMER_INTERNAL_WT_SIZE_LT](#PRIMER_INTERNAL_WT_SIZE_LT)                           [PRIMER_PAIR_WT_COMPL_END](#PRIMER_PAIR_WT_COMPL_END)
  [PRIMER_DMSO_CONC](#PRIMER_DMSO_CONC)                                                                 [PRIMER_INTERNAL_WT_TM_GT](#PRIMER_INTERNAL_WT_TM_GT)                               [PRIMER_PAIR_WT_COMPL_END_TH](#PRIMER_PAIR_WT_COMPL_END_TH)
  [PRIMER_DMSO_FACTOR](#PRIMER_DMSO_FACTOR)                                                             [PRIMER_INTERNAL_WT_TM_LT](#PRIMER_INTERNAL_WT_TM_LT)                               [PRIMER_PAIR_WT_DIFF_TM](#PRIMER_PAIR_WT_DIFF_TM)
  [PRIMER_DNA_CONC](#PRIMER_DNA_CONC)                                                                   [PRIMER_LIBERAL_BASE](#PRIMER_LIBERAL_BASE)                                         [PRIMER_PAIR_WT_IO_PENALTY](#PRIMER_PAIR_WT_IO_PENALTY)
  [PRIMER_DNTP_CONC](#PRIMER_DNTP_CONC)                                                                 [PRIMER_LIB_AMBIGUITY_CODES_CONSENSUS](#PRIMER_LIB_AMBIGUITY_CODES_CONSENSUS)       [PRIMER_PAIR_WT_LIBRARY_MISPRIMING](#PRIMER_PAIR_WT_LIBRARY_MISPRIMING)
  [PRIMER_EXPLAIN_FLAG](#PRIMER_EXPLAIN_FLAG)                                                           [PRIMER_LOWERCASE_MASKING](#PRIMER_LOWERCASE_MASKING)                               [PRIMER_PAIR_WT_PRODUCT_SIZE_GT](#PRIMER_PAIR_WT_PRODUCT_SIZE_GT)
  [PRIMER_FIRST_BASE_INDEX](#PRIMER_FIRST_BASE_INDEX)                                                   [PRIMER_MASK_3P_DIRECTION](#PRIMER_MASK_3P_DIRECTION)                               [PRIMER_PAIR_WT_PRODUCT_SIZE_LT](#PRIMER_PAIR_WT_PRODUCT_SIZE_LT)
  [PRIMER_FORMAMIDE_CONC](#PRIMER_FORMAMIDE_CONC)                                                       [PRIMER_MASK_5P_DIRECTION](#PRIMER_MASK_5P_DIRECTION)                               [PRIMER_PAIR_WT_PRODUCT_TM_GT](#PRIMER_PAIR_WT_PRODUCT_TM_GT)
  [PRIMER_GC_CLAMP](#PRIMER_GC_CLAMP)                                                                   [PRIMER_MASK_FAILURE_RATE](#PRIMER_MASK_FAILURE_RATE)                               [PRIMER_PAIR_WT_PRODUCT_TM_LT](#PRIMER_PAIR_WT_PRODUCT_TM_LT)
  [PRIMER_INSIDE_PENALTY](#PRIMER_INSIDE_PENALTY)                                                       [PRIMER_MASK_KMERLIST_PATH](#PRIMER_MASK_KMERLIST_PATH)                             [PRIMER_PAIR_WT_PR_PENALTY](#PRIMER_PAIR_WT_PR_PENALTY)
  [PRIMER_INTERNAL_DMSO_CONC](#PRIMER_INTERNAL_DMSO_CONC)                                               [PRIMER_MASK_KMERLIST_PREFIX](#PRIMER_MASK_KMERLIST_PREFIX)                         [PRIMER_PAIR_WT_TEMPLATE_MISPRIMING](#PRIMER_PAIR_WT_TEMPLATE_MISPRIMING)
  [PRIMER_INTERNAL_DMSO_FACTOR](#PRIMER_INTERNAL_DMSO_FACTOR)                                           [PRIMER_MASK_TEMPLATE](#PRIMER_MASK_TEMPLATE)                                       [PRIMER_PAIR_WT_TEMPLATE_MISPRIMING_TH](#PRIMER_PAIR_WT_TEMPLATE_MISPRIMING_TH)
  [PRIMER_INTERNAL_DNA_CONC](#PRIMER_INTERNAL_DNA_CONC)                                                 [PRIMER_MAX_BOUND](#PRIMER_MAX_BOUND)                                               [PRIMER_PICK_ANYWAY](#PRIMER_PICK_ANYWAY)
  [PRIMER_INTERNAL_DNTP_CONC](#PRIMER_INTERNAL_DNTP_CONC)                                               [PRIMER_MAX_END_GC](#PRIMER_MAX_END_GC)                                             [PRIMER_PICK_INTERNAL_OLIGO](#PRIMER_PICK_INTERNAL_OLIGO)
  [PRIMER_INTERNAL_FORMAMIDE_CONC](#PRIMER_INTERNAL_FORMAMIDE_CONC)                                     [PRIMER_MAX_END_STABILITY](#PRIMER_MAX_END_STABILITY)                               [PRIMER_PICK_LEFT_PRIMER](#PRIMER_PICK_LEFT_PRIMER)
  [PRIMER_INTERNAL_MAX_BOUND](#PRIMER_INTERNAL_MAX_BOUND)                                               [PRIMER_MAX_GC](#PRIMER_MAX_GC)                                                     [PRIMER_PICK_RIGHT_PRIMER](#PRIMER_PICK_RIGHT_PRIMER)
  [PRIMER_INTERNAL_MAX_GC](#PRIMER_INTERNAL_MAX_GC)                                                     [PRIMER_MAX_HAIRPIN_TH](#PRIMER_MAX_HAIRPIN_TH)                                     [PRIMER_PRODUCT_MAX_TM](#PRIMER_PRODUCT_MAX_TM)
  [PRIMER_INTERNAL_MAX_HAIRPIN_TH](#PRIMER_INTERNAL_MAX_HAIRPIN_TH)                                     [PRIMER_MAX_LIBRARY_MISPRIMING](#PRIMER_MAX_LIBRARY_MISPRIMING)                     [PRIMER_PRODUCT_MIN_TM](#PRIMER_PRODUCT_MIN_TM)
  [PRIMER_INTERNAL_MAX_LIBRARY_MISHYB](#PRIMER_INTERNAL_MAX_LIBRARY_MISHYB)                             [PRIMER_MAX_NS_ACCEPTED](#PRIMER_MAX_NS_ACCEPTED)                                   [PRIMER_PRODUCT_OPT_SIZE](#PRIMER_PRODUCT_OPT_SIZE)
  [PRIMER_INTERNAL_MAX_NS_ACCEPTED](#PRIMER_INTERNAL_MAX_NS_ACCEPTED)                                   [PRIMER_MAX_POLY_X](#PRIMER_MAX_POLY_X)                                             [PRIMER_PRODUCT_OPT_TM](#PRIMER_PRODUCT_OPT_TM)
  [PRIMER_INTERNAL_MAX_POLY_X](#PRIMER_INTERNAL_MAX_POLY_X)                                             [PRIMER_MAX_SELF_ANY](#PRIMER_MAX_SELF_ANY)                                         [PRIMER_PRODUCT_SIZE_RANGE](#PRIMER_PRODUCT_SIZE_RANGE)
  [PRIMER_INTERNAL_MAX_SELF_ANY](#PRIMER_INTERNAL_MAX_SELF_ANY)                                         [PRIMER_MAX_SELF_ANY_TH](#PRIMER_MAX_SELF_ANY_TH)                                   [PRIMER_QUALITY_RANGE_MAX](#PRIMER_QUALITY_RANGE_MAX)
  [PRIMER_INTERNAL_MAX_SELF_ANY_TH](#PRIMER_INTERNAL_MAX_SELF_ANY_TH)                                   [PRIMER_MAX_SELF_END](#PRIMER_MAX_SELF_END)                                         [PRIMER_QUALITY_RANGE_MIN](#PRIMER_QUALITY_RANGE_MIN)
  [PRIMER_INTERNAL_MAX_SELF_END](#PRIMER_INTERNAL_MAX_SELF_END)                                         [PRIMER_MAX_SELF_END_TH](#PRIMER_MAX_SELF_END_TH)                                   [PRIMER_SALT_CORRECTIONS](#PRIMER_SALT_CORRECTIONS)
  [PRIMER_INTERNAL_MAX_SELF_END_TH](#PRIMER_INTERNAL_MAX_SELF_END_TH)                                   [PRIMER_MAX_SIZE](#PRIMER_MAX_SIZE)                                                 [PRIMER_SALT_DIVALENT](#PRIMER_SALT_DIVALENT)
  [PRIMER_INTERNAL_MAX_SIZE](#PRIMER_INTERNAL_MAX_SIZE)                                                 [PRIMER_MAX_TEMPLATE_MISPRIMING](#PRIMER_MAX_TEMPLATE_MISPRIMING)                   [PRIMER_SALT_MONOVALENT](#PRIMER_SALT_MONOVALENT)
  [PRIMER_INTERNAL_MAX_TM](#PRIMER_INTERNAL_MAX_TM)                                                     [PRIMER_MAX_TEMPLATE_MISPRIMING_TH](#PRIMER_MAX_TEMPLATE_MISPRIMING_TH)             [PRIMER_SECONDARY_STRUCTURE_ALIGNMENT](#PRIMER_SECONDARY_STRUCTURE_ALIGNMENT)
  [PRIMER_INTERNAL_MIN_3_PRIME_OVERLAP_OF_JUNCTION](#PRIMER_INTERNAL_MIN_3_PRIME_OVERLAP_OF_JUNCTION)   [PRIMER_MAX_TM](#PRIMER_MAX_TM)                                                     [PRIMER_SEQUENCING_ACCURACY](#PRIMER_SEQUENCING_ACCURACY)
  [PRIMER_INTERNAL_MIN_5_PRIME_OVERLAP_OF_JUNCTION](#PRIMER_INTERNAL_MIN_5_PRIME_OVERLAP_OF_JUNCTION)   [PRIMER_MIN_3_PRIME_OVERLAP_OF_JUNCTION](#PRIMER_MIN_3_PRIME_OVERLAP_OF_JUNCTION)   [PRIMER_SEQUENCING_INTERVAL](#PRIMER_SEQUENCING_INTERVAL)
  [PRIMER_INTERNAL_MIN_BOUND](#PRIMER_INTERNAL_MIN_BOUND)                                               [PRIMER_MIN_5_PRIME_OVERLAP_OF_JUNCTION](#PRIMER_MIN_5_PRIME_OVERLAP_OF_JUNCTION)   [PRIMER_SEQUENCING_LEAD](#PRIMER_SEQUENCING_LEAD)
  [PRIMER_INTERNAL_MIN_GC](#PRIMER_INTERNAL_MIN_GC)                                                     [PRIMER_MIN_BOUND](#PRIMER_MIN_BOUND)                                               [PRIMER_SEQUENCING_SPACING](#PRIMER_SEQUENCING_SPACING)
  [PRIMER_INTERNAL_MIN_QUALITY](#PRIMER_INTERNAL_MIN_QUALITY)                                           [PRIMER_MIN_END_QUALITY](#PRIMER_MIN_END_QUALITY)                                   [PRIMER_TASK](#PRIMER_TASK)
  [PRIMER_INTERNAL_MIN_SIZE](#PRIMER_INTERNAL_MIN_SIZE)                                                 [PRIMER_MIN_GC](#PRIMER_MIN_GC)                                                     [PRIMER_THERMODYNAMIC_OLIGO_ALIGNMENT](#PRIMER_THERMODYNAMIC_OLIGO_ALIGNMENT)
  [PRIMER_INTERNAL_MIN_THREE_PRIME_DISTANCE](#PRIMER_INTERNAL_MIN_THREE_PRIME_DISTANCE)                 [PRIMER_MIN_LEFT_THREE_PRIME_DISTANCE](#PRIMER_MIN_LEFT_THREE_PRIME_DISTANCE)       [PRIMER_THERMODYNAMIC_PARAMETERS_PATH](#PRIMER_THERMODYNAMIC_PARAMETERS_PATH)
  [PRIMER_INTERNAL_MIN_TM](#PRIMER_INTERNAL_MIN_TM)                                                     [PRIMER_MIN_QUALITY](#PRIMER_MIN_QUALITY)                                           [PRIMER_THERMODYNAMIC_TEMPLATE_ALIGNMENT](#PRIMER_THERMODYNAMIC_TEMPLATE_ALIGNMENT)
  [PRIMER_INTERNAL_MISHYB_LIBRARY](#PRIMER_INTERNAL_MISHYB_LIBRARY)                                     [PRIMER_MIN_RIGHT_THREE_PRIME_DISTANCE](#PRIMER_MIN_RIGHT_THREE_PRIME_DISTANCE)     [PRIMER_TM_FORMULA](#PRIMER_TM_FORMULA)
  [PRIMER_INTERNAL_MUST_MATCH_FIVE_PRIME](#PRIMER_INTERNAL_MUST_MATCH_FIVE_PRIME)                       [PRIMER_MIN_SIZE](#PRIMER_MIN_SIZE)                                                 [PRIMER_WT_BOUND_GT](#PRIMER_WT_BOUND_GT)
  [PRIMER_INTERNAL_MUST_MATCH_THREE_PRIME](#PRIMER_INTERNAL_MUST_MATCH_THREE_PRIME)                     [PRIMER_MIN_THREE_PRIME_DISTANCE](#PRIMER_MIN_THREE_PRIME_DISTANCE)                 [PRIMER_WT_BOUND_LT](#PRIMER_WT_BOUND_LT)
  [PRIMER_INTERNAL_OPT_BOUND](#PRIMER_INTERNAL_OPT_BOUND)                                               [PRIMER_MIN_TM](#PRIMER_MIN_TM)                                                     [PRIMER_WT_END_QUAL](#PRIMER_WT_END_QUAL)
  [PRIMER_INTERNAL_OPT_GC_PERCENT](#PRIMER_INTERNAL_OPT_GC_PERCENT)                                     [PRIMER_MISPRIMING_LIBRARY](#PRIMER_MISPRIMING_LIBRARY)                             [PRIMER_WT_END_STABILITY](#PRIMER_WT_END_STABILITY)
  [PRIMER_INTERNAL_OPT_SIZE](#PRIMER_INTERNAL_OPT_SIZE)                                                 [PRIMER_MUST_MATCH_FIVE_PRIME](#PRIMER_MUST_MATCH_FIVE_PRIME)                       [PRIMER_WT_GC_PERCENT_GT](#PRIMER_WT_GC_PERCENT_GT)
  [PRIMER_INTERNAL_OPT_TM](#PRIMER_INTERNAL_OPT_TM)                                                     [PRIMER_MUST_MATCH_THREE_PRIME](#PRIMER_MUST_MATCH_THREE_PRIME)                     [PRIMER_WT_GC_PERCENT_LT](#PRIMER_WT_GC_PERCENT_LT)
  [PRIMER_INTERNAL_SALT_DIVALENT](#PRIMER_INTERNAL_SALT_DIVALENT)                                       [PRIMER_NUM_RETURN](#PRIMER_NUM_RETURN)                                             [PRIMER_WT_HAIRPIN_TH](#PRIMER_WT_HAIRPIN_TH)
  [PRIMER_INTERNAL_SALT_MONOVALENT](#PRIMER_INTERNAL_SALT_MONOVALENT)                                   [PRIMER_OPT_BOUND](#PRIMER_OPT_BOUND)                                               [PRIMER_WT_LIBRARY_MISPRIMING](#PRIMER_WT_LIBRARY_MISPRIMING)
  [PRIMER_INTERNAL_WT_BOUND_GT](#PRIMER_INTERNAL_WT_BOUND_GT)                                           [PRIMER_OPT_GC_PERCENT](#PRIMER_OPT_GC_PERCENT)                                     [PRIMER_WT_MASK_FAILURE_RATE](#PRIMER_WT_MASK_FAILURE_RATE)
  [PRIMER_INTERNAL_WT_BOUND_LT](#PRIMER_INTERNAL_WT_BOUND_LT)                                           [PRIMER_OPT_SIZE](#PRIMER_OPT_SIZE)                                                 [PRIMER_WT_NUM_NS](#PRIMER_WT_NUM_NS)
  [PRIMER_INTERNAL_WT_END_QUAL](#PRIMER_INTERNAL_WT_END_QUAL)                                           [PRIMER_OPT_TM](#PRIMER_OPT_TM)                                                     [PRIMER_WT_POS_PENALTY](#PRIMER_WT_POS_PENALTY)
  [PRIMER_INTERNAL_WT_GC_PERCENT_GT](#PRIMER_INTERNAL_WT_GC_PERCENT_GT)                                 [PRIMER_OUTSIDE_PENALTY](#PRIMER_OUTSIDE_PENALTY)                                   [PRIMER_WT_SELF_ANY](#PRIMER_WT_SELF_ANY)
  [PRIMER_INTERNAL_WT_GC_PERCENT_LT](#PRIMER_INTERNAL_WT_GC_PERCENT_LT)                                 [PRIMER_PAIR_MAX_COMPL_ANY](#PRIMER_PAIR_MAX_COMPL_ANY)                             [PRIMER_WT_SELF_ANY_TH](#PRIMER_WT_SELF_ANY_TH)
  [PRIMER_INTERNAL_WT_HAIRPIN_TH](#PRIMER_INTERNAL_WT_HAIRPIN_TH)                                       [PRIMER_PAIR_MAX_COMPL_ANY_TH](#PRIMER_PAIR_MAX_COMPL_ANY_TH)                       [PRIMER_WT_SELF_END](#PRIMER_WT_SELF_END)
  [PRIMER_INTERNAL_WT_LIBRARY_MISHYB](#PRIMER_INTERNAL_WT_LIBRARY_MISHYB)                               [PRIMER_PAIR_MAX_COMPL_END](#PRIMER_PAIR_MAX_COMPL_END)                             [PRIMER_WT_SELF_END_TH](#PRIMER_WT_SELF_END_TH)
  [PRIMER_INTERNAL_WT_NUM_NS](#PRIMER_INTERNAL_WT_NUM_NS)                                               [PRIMER_PAIR_MAX_COMPL_END_TH](#PRIMER_PAIR_MAX_COMPL_END_TH)                       [PRIMER_WT_SEQ_QUAL](#PRIMER_WT_SEQ_QUAL)
  [PRIMER_INTERNAL_WT_SELF_ANY](#PRIMER_INTERNAL_WT_SELF_ANY)                                           [PRIMER_PAIR_MAX_DIFF_TM](#PRIMER_PAIR_MAX_DIFF_TM)                                 [PRIMER_WT_SIZE_GT](#PRIMER_WT_SIZE_GT)
  [PRIMER_INTERNAL_WT_SELF_ANY_TH](#PRIMER_INTERNAL_WT_SELF_ANY_TH)                                     [PRIMER_PAIR_MAX_LIBRARY_MISPRIMING](#PRIMER_PAIR_MAX_LIBRARY_MISPRIMING)           [PRIMER_WT_SIZE_LT](#PRIMER_WT_SIZE_LT)
  [PRIMER_INTERNAL_WT_SELF_END](#PRIMER_INTERNAL_WT_SELF_END)                                           [PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING](#PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING)         [PRIMER_WT_TEMPLATE_MISPRIMING](#PRIMER_WT_TEMPLATE_MISPRIMING)
  [PRIMER_INTERNAL_WT_SELF_END_TH](#PRIMER_INTERNAL_WT_SELF_END_TH)                                     [PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING_TH](#PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING_TH)   [PRIMER_WT_TEMPLATE_MISPRIMING_TH](#PRIMER_WT_TEMPLATE_MISPRIMING_TH)
  [PRIMER_INTERNAL_WT_SEQ_QUAL](#PRIMER_INTERNAL_WT_SEQ_QUAL)                                           [PRIMER_PAIR_WT_COMPL_ANY](#PRIMER_PAIR_WT_COMPL_ANY)                               [PRIMER_WT_TM_GT](#PRIMER_WT_TM_GT)
  [PRIMER_INTERNAL_WT_SIZE_GT](#PRIMER_INTERNAL_WT_SIZE_GT)                                             [PRIMER_PAIR_WT_COMPL_ANY_TH](#PRIMER_PAIR_WT_COMPL_ANY_TH)                         [PRIMER_WT_TM_LT](#PRIMER_WT_TM_LT)
  ----------------------------------------------------------------------------------------------------- ----------------------------------------------------------------------------------- -------------------------------------------------------------------------------------

### [PRIMER_TASK (string; default generic)]{#PRIMER_TASK}

This tag tells Primer3 what task to perform. Legal values are:\
\
[*generic*]{.p3_prop}\
\
Design a primer pair (the classic Primer3 task) if the
[PRIMER_PICK_LEFT_PRIMER](#PRIMER_PICK_LEFT_PRIMER)=1, and
[PRIMER_PICK_RIGHT_PRIMER](#PRIMER_PICK_RIGHT_PRIMER)=1. In addition,
pick an internal hybridization oligo if
[PRIMER_PICK_INTERNAL_OLIGO](#PRIMER_PICK_INTERNAL_OLIGO)=1.\
\
NOTE: If [PRIMER_PICK_LEFT_PRIMER](#PRIMER_PICK_LEFT_PRIMER)=1,
[PRIMER_PICK_RIGHT_PRIMER](#PRIMER_PICK_RIGHT_PRIMER)=0 and
[PRIMER_PICK_INTERNAL_OLIGO](#PRIMER_PICK_INTERNAL_OLIGO)=1, then
behaves similarly to [PRIMER_TASK](#PRIMER_TASK)=pick_primer_list.\
\
[*pick_detection_primers*]{.p3_prop}\
\
Deprecated alias for [PRIMER_TASK](#PRIMER_TASK)=generic\
\
[*check_primers*]{.p3_prop}\
\
Primer3 only checks the primers provided in
[SEQUENCE_PRIMER](#SEQUENCE_PRIMER),
[SEQUENCE_INTERNAL_OLIGO](#SEQUENCE_INTERNAL_OLIGO) and
[SEQUENCE_PRIMER_REVCOMP](#SEQUENCE_PRIMER_REVCOMP). It is the only task
that does not require a sequence. However, if
[SEQUENCE_TEMPLATE](#SEQUENCE_TEMPLATE) is provided, it is used.\
\
[*pick_primer_list*]{.p3_prop}\
\
Pick all primers in [SEQUENCE_TEMPLATE](#SEQUENCE_TEMPLATE) (possibly
limited by [SEQUENCE_INCLUDED_REGION](#SEQUENCE_INCLUDED_REGION),
[SEQUENCE_EXCLUDED_REGION](#SEQUENCE_EXCLUDED_REGION),
[SEQUENCE_PRIMER_PAIR_OK_REGION_LIST](#SEQUENCE_PRIMER_PAIR_OK_REGION_LIST),
etc.). Returns the primers sorted by quality starting with the best
primers. If [PRIMER_PICK_LEFT_PRIMER](#PRIMER_PICK_LEFT_PRIMER) and
[PRIMER_PICK_RIGHT_PRIMER](#PRIMER_PICK_RIGHT_PRIMER) is selected
Primer3 does not to pick primer pairs but generates independent lists of
left primers, right primers, and, if requested, internal oligos.\
\
[*pick_sequencing_primers*]{.p3_prop}\
\
Pick primers suited to sequence a region.
[SEQUENCE_TARGET](#SEQUENCE_TARGET) can be used to indicate several
targets. The position of each primer is calculated for optimal
sequencing results.\
\
[*pick_cloning_primers*]{.p3_prop}\
\
Pick primers suited to clone a gene were the start nucleotide and the
end nucleotide of the PCR fragment must be fixed, for example to clone
an ORF. [SEQUENCE_INCLUDED_REGION](#SEQUENCE_INCLUDED_REGION) must be
used to indicate the first and the last nucleotide. Due to these
limitations Primer3 can only vary the length of the primers. Set
[PRIMER_PICK_ANYWAY](#PRIMER_PICK_ANYWAY)=1 to obtain primers even if
they violate specific constraints.\
\
[*pick_discriminative_primers*]{.p3_prop}\
\
Pick primers suited to select primers which bind with their end at a
specific position. This can be used to force the end of a primer to a
polymorphic site, with the goal of discriminating between sequence
variants. [SEQUENCE_TARGET](#SEQUENCE_TARGET) must be used to provide a
single target indicating the last nucleotide of the left (nucleotide
before the first nucleotide of the target) and the right primer
(nucleotide following the target). The primers border the
[SEQUENCE_TARGET](#SEQUENCE_TARGET). Due to these limitations Primer3
can only vary the length of the primers. Set
[PRIMER_PICK_ANYWAY](#PRIMER_PICK_ANYWAY)=1 to obtain primers even if
they violate specific constraints.\
\
[*pick_pcr_primers*]{.p3_prop}\
\
Deprecated shortcut for the following settings:\
[PRIMER_TASK](#PRIMER_TASK)=generic\
[PRIMER_PICK_LEFT_PRIMER](#PRIMER_PICK_LEFT_PRIMER)=1\
[PRIMER_PICK_INTERNAL_OLIGO](#PRIMER_PICK_INTERNAL_OLIGO)=0\
[PRIMER_PICK_RIGHT_PRIMER](#PRIMER_PICK_RIGHT_PRIMER)=1\
\
WARNING: this task changes the values of
[PRIMER_PICK_LEFT_PRIMER](#PRIMER_PICK_LEFT_PRIMER),
[PRIMER_PICK_INTERNAL_OLIGO](#PRIMER_PICK_INTERNAL_OLIGO), and
[PRIMER_PICK_RIGHT_PRIMER](#PRIMER_PICK_RIGHT_PRIMER) in a way that is
not obvious by looking at the input.\
\
[*pick_pcr_primers_and_hyb_probe*]{.p3_prop}\
\
Deprecated shortcut for the following settings:\
[PRIMER_TASK](#PRIMER_TASK)=generic\
[PRIMER_PICK_LEFT_PRIMER](#PRIMER_PICK_LEFT_PRIMER)=1\
[PRIMER_PICK_INTERNAL_OLIGO](#PRIMER_PICK_INTERNAL_OLIGO)=1\
[PRIMER_PICK_RIGHT_PRIMER](#PRIMER_PICK_RIGHT_PRIMER)=1\
\
WARNING: this task changes the values of
[PRIMER_PICK_LEFT_PRIMER](#PRIMER_PICK_LEFT_PRIMER),
[PRIMER_PICK_INTERNAL_OLIGO](#PRIMER_PICK_INTERNAL_OLIGO), and
[PRIMER_PICK_RIGHT_PRIMER](#PRIMER_PICK_RIGHT_PRIMER) in a way that is
not obvious by looking at the input.\
\
[*pick_left_only*]{.p3_prop}\
\
Deprecated shortcut for the following settings:\
[PRIMER_TASK](#PRIMER_TASK)=generic\
[PRIMER_PICK_LEFT_PRIMER](#PRIMER_PICK_LEFT_PRIMER)=1\
[PRIMER_PICK_INTERNAL_OLIGO](#PRIMER_PICK_INTERNAL_OLIGO)=0\
[PRIMER_PICK_RIGHT_PRIMER](#PRIMER_PICK_RIGHT_PRIMER)=0\
\
WARNING: this task changes the values of
[PRIMER_PICK_LEFT_PRIMER](#PRIMER_PICK_LEFT_PRIMER),
[PRIMER_PICK_INTERNAL_OLIGO](#PRIMER_PICK_INTERNAL_OLIGO), and
[PRIMER_PICK_RIGHT_PRIMER](#PRIMER_PICK_RIGHT_PRIMER) in a way that is
not obvious by looking at the input.\
\
[*pick_right_only*]{.p3_prop}\
\
Deprecated shortcut for the following settings:\
[PRIMER_TASK](#PRIMER_TASK)=generic\
[PRIMER_PICK_LEFT_PRIMER](#PRIMER_PICK_LEFT_PRIMER)=0\
[PRIMER_PICK_INTERNAL_OLIGO](#PRIMER_PICK_INTERNAL_OLIGO)=0\
[PRIMER_PICK_RIGHT_PRIMER](#PRIMER_PICK_RIGHT_PRIMER)=1\
\
WARNING: this task changes the values of
[PRIMER_PICK_LEFT_PRIMER](#PRIMER_PICK_LEFT_PRIMER),
[PRIMER_PICK_INTERNAL_OLIGO](#PRIMER_PICK_INTERNAL_OLIGO), and
[PRIMER_PICK_RIGHT_PRIMER](#PRIMER_PICK_RIGHT_PRIMER) in a way that is
not obvious by looking at the input.\
\
[*pick_hyb_probe_only*]{.p3_prop}\
\
Deprecated shortcut for the following settings:\
[PRIMER_TASK](#PRIMER_TASK)=generic\
[PRIMER_PICK_LEFT_PRIMER](#PRIMER_PICK_LEFT_PRIMER)=0\
[PRIMER_PICK_INTERNAL_OLIGO](#PRIMER_PICK_INTERNAL_OLIGO)=1\
[PRIMER_PICK_RIGHT_PRIMER](#PRIMER_PICK_RIGHT_PRIMER)=0\
\
WARNING: this task changes the values of
[PRIMER_PICK_LEFT_PRIMER](#PRIMER_PICK_LEFT_PRIMER),
[PRIMER_PICK_INTERNAL_OLIGO](#PRIMER_PICK_INTERNAL_OLIGO), and
[PRIMER_PICK_RIGHT_PRIMER](#PRIMER_PICK_RIGHT_PRIMER) in a way that is
not obvious by looking at the input.\

### [PRIMER_PICK_LEFT_PRIMER (boolean; default 1)]{#PRIMER_PICK_LEFT_PRIMER}

If the associated value = 1 (non-0), then Primer3 will attempt to pick
left primers.

### [PRIMER_PICK_INTERNAL_OLIGO (boolean; default 0)]{#PRIMER_PICK_INTERNAL_OLIGO}

If the associated value = 1 (non-0), then Primer3 will attempt to pick
an internal oligo (hybridization probe to detect the PCR product).

### [PRIMER_PICK_RIGHT_PRIMER (boolean; default 1)]{#PRIMER_PICK_RIGHT_PRIMER}

If the associated value = 1 (non-0), then Primer3 will attempt to pick a
right primer.

### [PRIMER_NUM_RETURN (int; default 5)]{#PRIMER_NUM_RETURN}

The maximum number of primer (pairs) to return. Primer pairs returned
are sorted by their \"quality\", in other words by the value of the
objective function (where a lower number indicates a better primer
pair). Caution: setting this parameter to a large value will increase
running time.

### [PRIMER_MIN_3_PRIME_OVERLAP_OF_JUNCTION (int; default 4)]{#PRIMER_MIN_3_PRIME_OVERLAP_OF_JUNCTION}

The 3\' end of the left OR the right primer must overlap one of the
junctions in
[SEQUENCE_OVERLAP_JUNCTION_LIST](#SEQUENCE_OVERLAP_JUNCTION_LIST) by
this amount. See details in
[SEQUENCE_OVERLAP_JUNCTION_LIST](#SEQUENCE_OVERLAP_JUNCTION_LIST).

### [PRIMER_INTERNAL_MIN_3_PRIME_OVERLAP_OF_JUNCTION (int; default 4)]{#PRIMER_INTERNAL_MIN_3_PRIME_OVERLAP_OF_JUNCTION}

The 3\' end of the middle oligo / probe must overlap one of the
junctions in
[SEQUENCE_INTERNAL_OVERLAP_JUNCTION_LIST](#SEQUENCE_INTERNAL_OVERLAP_JUNCTION_LIST)
by this amount. See details in
[SEQUENCE_OVERLAP_JUNCTION_LIST](#SEQUENCE_OVERLAP_JUNCTION_LIST).

### [PRIMER_MIN_5_PRIME_OVERLAP_OF_JUNCTION (int; default 7)]{#PRIMER_MIN_5_PRIME_OVERLAP_OF_JUNCTION}

The 5\' end of the left OR the right primer must overlap one of the
junctions in
[SEQUENCE_OVERLAP_JUNCTION_LIST](#SEQUENCE_OVERLAP_JUNCTION_LIST) by
this amount. See details in
[SEQUENCE_OVERLAP_JUNCTION_LIST](#SEQUENCE_OVERLAP_JUNCTION_LIST).

### [PRIMER_INTERNAL_MIN_5_PRIME_OVERLAP_OF_JUNCTION (int; default 7)]{#PRIMER_INTERNAL_MIN_5_PRIME_OVERLAP_OF_JUNCTION}

The 5\' end of the middle oligo / probe must overlap one of the
junctions in
[SEQUENCE_INTERNAL_OVERLAP_JUNCTION_LIST](#SEQUENCE_INTERNAL_OVERLAP_JUNCTION_LIST)
by this amount. See details in
[SEQUENCE_OVERLAP_JUNCTION_LIST](#SEQUENCE_OVERLAP_JUNCTION_LIST).

### [PRIMER_MUST_MATCH_FIVE_PRIME (ambiguous nucleotide sequence; default empty)]{#PRIMER_MUST_MATCH_FIVE_PRIME}

Discards all primers which do not match this match sequence at the 5\'
end. (New in v. 2.3.6, added by A. Untergasser.)\
\
The match sequence must be 5 nucletides long and can contain the
following letters:

        N   Any nucleotide
        A   Adenine
        G   Guanine
        C   Cytosine
        T   Thymine
        R   Purine (A or G)
        Y   Pyrimidine (C or T)
        W   Weak (A or T)
        S   Strong (G or C)
        M   Amino (A or C)
        K   Keto (G or T)
        B   Not A (G or C or T)
        H   Not G (A or C or T)
        D   Not C (A or G or T)
        V   Not T (A or G or C)

Any primer which will not match the entire match sequence at the 5\' end
will be discarded and not evaluated. Setting strict requirements here
will result in low quality primers due to the high numbers of primers
discarded at this step.\
\
**Example 1:**\
PRIMER_MUST_MATCH_FIVE_PRIME=tgnnn\
\
Could result in the following matching:

        tgcatgattggatacgtttga
        |||||
        tgnnn
     -> This primer would be used.
        attcgattctccccggtatc
          |||
        tgnnn
     -> This primer would be discarded.

\

**Example 2:**\
PRIMER_MUST_MATCH_FIVE_PRIME=hnnnn\
\
Could result in the following matching:

        tgcatgattggatacgtttga
        |||||
        hnnnn
     -> This primer would be used.
        ggctgatgaaggaaagcaag
         ||||
        hnnnn
     -> This primer would be discarded.

\

This parameter would force all primers selected by Primer3 to not have
guanosine at the 5\' end of any primer which could be useful to avoid
quenching of flourochromes.

### [PRIMER_INTERNAL_MUST_MATCH_FIVE_PRIME (ambiguous nucleotide sequence; default empty)]{#PRIMER_INTERNAL_MUST_MATCH_FIVE_PRIME}

Equivalent parameter of
[PRIMER_MUST_MATCH_FIVE_PRIME](#PRIMER_MUST_MATCH_FIVE_PRIME) for the
internal oligo.

### [PRIMER_MUST_MATCH_THREE_PRIME (ambiguous nucleotide sequence; default empty)]{#PRIMER_MUST_MATCH_THREE_PRIME}

Discards all primers which do not match this match sequence at the 3\'
end. Similar parameter to
[PRIMER_MUST_MATCH_FIVE_PRIME](#PRIMER_MUST_MATCH_FIVE_PRIME), but
limits the 3\' end. (New in v. 2.3.6, added by A. Untergasser.)\
\
The match sequence must be 5 nucletides long and can contain the
following letters:

        N   Any nucleotide
        A   Adenine
        G   Guanine
        C   Cytosine
        T   Thymine
        R   Purine (A or G)
        Y   Pyrimidine (C or T)
        W   Weak (A or T)
        S   Strong (G or C)
        M   Amino (A or C)
        K   Keto (G or T)
        B   Not A (G or C or T)
        H   Not G (A or C or T)
        D   Not C (A or G or T)
        V   Not T (A or G or C)

Any primer which will not match the entire match sequence at the 3\' end
will be discarded and not evaluated. Setting strict requirements here
will result in low quality primers due to the high numbers of primers
discarded at this step.\
\
**Example 1:**\
PRIMER_MUST_MATCH_FIVE_PRIME=nnnga\
\
Could result in the following matching:

        tgcatgattggatacgtttga
                        |||||
                        nnnga
     -> This primer would be used.
        attcgattctccccggtatc
                       |||
                       nnnga
     -> This primer would be discarded.

### [PRIMER_INTERNAL_MUST_MATCH_THREE_PRIME (ambiguous nucleotide sequence; default empty)]{#PRIMER_INTERNAL_MUST_MATCH_THREE_PRIME}

Equivalent parameter of
[PRIMER_MUST_MATCH_THREE_PRIME](#PRIMER_MUST_MATCH_THREE_PRIME) for the
internal oligo.

### [PRIMER_PRODUCT_SIZE_RANGE (size range list; default 100-300)]{#PRIMER_PRODUCT_SIZE_RANGE}

The associated values specify the lengths of the product that the user
wants the primers to create, and is a space separated list of elements
of the form

    <x>-<y>

where an [*\<x\>-\<y\>*]{.p3_prop} pair is a legal range of lengths for
the product. For example, if one wants PCR products to be between 100 to
150 bases (inclusive) then one would set this parameter to
[*100-150*]{.p3_prop}. If one desires PCR products in either the range
from 100 to 150 bases or in the range from 200 to 250 bases then one
would set this parameter to [*100-150 200-250*]{.p3_prop}.\
\
Primer3 favors product-size ranges to the left side of the parameter
string. Primer3 will return legal primers pairs in the first range
regardless the value of the objective function for pairs in subsequent
ranges. Only if there are an insufficient number of primers in the first
range will Primer3 return primers in a subsequent range.\
\
For those with primarily a computational background, the PCR product
size is the size (in base pairs) of the DNA fragment that would be
produced by the PCR reaction on the given sequence template. This would,
of course, include the primers themselves.\
\
The length of [SEQUENCE_OVERHANG_LEFT](#SEQUENCE_OVERHANG_LEFT) and
[SEQUENCE_OVERHANG_RIGHT](#SEQUENCE_OVERHANG_RIGHT) do not add to the
binding product size of PRIMER_PRODUCT_SIZE_RANGE or
[PRIMER_PRODUCT_OPT_SIZE](#PRIMER_PRODUCT_OPT_SIZE).

### [PRIMER_PRODUCT_OPT_SIZE (int; default 0)]{#PRIMER_PRODUCT_OPT_SIZE}

The optimum size for the PCR product. 0 indicates that there is no
optimum product size. This parameter influences primer pair selection
only if
[PRIMER_PAIR_WT_PRODUCT_SIZE_GT](#PRIMER_PAIR_WT_PRODUCT_SIZE_GT) or
[PRIMER_PAIR_WT_PRODUCT_SIZE_LT](#PRIMER_PAIR_WT_PRODUCT_SIZE_LT) is
non-0.\
A non-0 value for this parameter will likely increase calculation time,
so set this only if a product size near a specific value is truly
important.\
\
The length of [SEQUENCE_OVERHANG_LEFT](#SEQUENCE_OVERHANG_LEFT) and
[SEQUENCE_OVERHANG_RIGHT](#SEQUENCE_OVERHANG_RIGHT) do not add to the
binding product size of
[PRIMER_PRODUCT_SIZE_RANGE](#PRIMER_PRODUCT_SIZE_RANGE) or
PRIMER_PRODUCT_OPT_SIZE.

### [PRIMER_PAIR_WT_PRODUCT_SIZE_LT (float; default 0.0)]{#PRIMER_PAIR_WT_PRODUCT_SIZE_LT}

Penalty weight for products shorter than
[PRIMER_PRODUCT_OPT_SIZE](#PRIMER_PRODUCT_OPT_SIZE).

### [PRIMER_PAIR_WT_PRODUCT_SIZE_GT (float; default 0.0)]{#PRIMER_PAIR_WT_PRODUCT_SIZE_GT}

Penalty weight for products longer than
[PRIMER_PRODUCT_OPT_SIZE](#PRIMER_PRODUCT_OPT_SIZE).

### [PRIMER_MIN_SIZE (int; default 18)]{#PRIMER_MIN_SIZE}

Minimum acceptable length of a primer. Must be greater than 0 and less
than or equal to [PRIMER_MAX_SIZE](#PRIMER_MAX_SIZE).

### [PRIMER_INTERNAL_MIN_SIZE (int; default 18)]{#PRIMER_INTERNAL_MIN_SIZE}

Equivalent parameter of [PRIMER_MIN_SIZE](#PRIMER_MIN_SIZE) for the
internal oligo.

### [PRIMER_OPT_SIZE (int; default 20)]{#PRIMER_OPT_SIZE}

Optimum length (in bases) of a primer. Primer3 will attempt to pick
primers close to this length.

### [PRIMER_INTERNAL_OPT_SIZE (int; default 20)]{#PRIMER_INTERNAL_OPT_SIZE}

Equivalent parameter of [PRIMER_OPT_SIZE](#PRIMER_OPT_SIZE) for the
internal oligo.

### [PRIMER_MAX_SIZE (int; default 27)]{#PRIMER_MAX_SIZE}

Maximum acceptable length (in bases) of a primer. Currently this
parameter cannot be larger than 35. This limit is governed by maximum
oligo size for which Primer3\'s melting-temperature is valid.

### [PRIMER_INTERNAL_MAX_SIZE (int; default 27)]{#PRIMER_INTERNAL_MAX_SIZE}

Equivalent parameter of [PRIMER_MAX_SIZE](#PRIMER_MAX_SIZE) for the
internal oligo.

### [PRIMER_WT_SIZE_LT (float; default 1.0)]{#PRIMER_WT_SIZE_LT}

Penalty weight for primers shorter than
[PRIMER_OPT_SIZE](#PRIMER_OPT_SIZE).

### [PRIMER_INTERNAL_WT_SIZE_LT (float; default 1.0)]{#PRIMER_INTERNAL_WT_SIZE_LT}

Equivalent parameter of [PRIMER_WT_SIZE_LT](#PRIMER_WT_SIZE_LT) for the
internal oligo.

### [PRIMER_WT_SIZE_GT (float; default 1.0)]{#PRIMER_WT_SIZE_GT}

Penalty weight for primers longer than
[PRIMER_OPT_SIZE](#PRIMER_OPT_SIZE).

### [PRIMER_INTERNAL_WT_SIZE_GT (float; default 1.0)]{#PRIMER_INTERNAL_WT_SIZE_GT}

Equivalent parameter of
[PRIMER_INTERNAL_WT_SIZE_GT](#PRIMER_INTERNAL_WT_SIZE_GT) for the
internal oligo.

### [PRIMER_MIN_GC (float; default 20.0)]{#PRIMER_MIN_GC}

Minimum allowable percentage of Gs and Cs in any primer.

### [PRIMER_INTERNAL_MIN_GC (float; default 20.0)]{#PRIMER_INTERNAL_MIN_GC}

Equivalent parameter of [PRIMER_MIN_GC](#PRIMER_MIN_GC) for the internal
oligo.

### [PRIMER_OPT_GC_PERCENT (float; default 50.0)]{#PRIMER_OPT_GC_PERCENT}

Optimum GC percent. This parameter influences primer selection only if
[PRIMER_WT_GC_PERCENT_GT](#PRIMER_WT_GC_PERCENT_GT) or
[PRIMER_WT_GC_PERCENT_LT](#PRIMER_WT_GC_PERCENT_LT) are non-0.

### [PRIMER_INTERNAL_OPT_GC_PERCENT (float; default 50.0)]{#PRIMER_INTERNAL_OPT_GC_PERCENT}

Equivalent parameter of [PRIMER_OPT_GC_PERCENT](#PRIMER_OPT_GC_PERCENT)
for the internal oligo.

### [PRIMER_MAX_GC (float; default 80.0)]{#PRIMER_MAX_GC}

Maximum allowable percentage of Gs and Cs in any primer generated by
Primer.

### [PRIMER_INTERNAL_MAX_GC (float; default 80.0)]{#PRIMER_INTERNAL_MAX_GC}

Equivalent parameter of [PRIMER_MAX_GC](#PRIMER_MAX_GC) for the internal
oligo.

### [PRIMER_WT_GC_PERCENT_LT (float; default 0.0)]{#PRIMER_WT_GC_PERCENT_LT}

Penalty weight for primers with GC percent lower than
[PRIMER_OPT_GC_PERCENT](#PRIMER_OPT_GC_PERCENT).

### [PRIMER_INTERNAL_WT_GC_PERCENT_LT (float; default 0.0)]{#PRIMER_INTERNAL_WT_GC_PERCENT_LT}

Equivalent parameter of
[PRIMER_WT_GC_PERCENT_LT](#PRIMER_WT_GC_PERCENT_LT) for the internal
oligo.

### [PRIMER_WT_GC_PERCENT_GT (float; default 0.0)]{#PRIMER_WT_GC_PERCENT_GT}

Penalty weight for primers with GC percent higher than
[PRIMER_OPT_GC_PERCENT](#PRIMER_OPT_GC_PERCENT).

### [PRIMER_INTERNAL_WT_GC_PERCENT_GT (float; default 0.0)]{#PRIMER_INTERNAL_WT_GC_PERCENT_GT}

Equivalent parameter of
[PRIMER_WT_GC_PERCENT_GT](#PRIMER_WT_GC_PERCENT_GT) for the internal
oligo.

### [PRIMER_GC_CLAMP (int; default 0)]{#PRIMER_GC_CLAMP}

Require the specified number of consecutive Gs and Cs at the 3\' end of
both the left and right primer. (This parameter has no effect on the
internal oligo if one is requested.)

### [PRIMER_MAX_END_GC (int; default 5)]{#PRIMER_MAX_END_GC}

The maximum number of Gs or Cs allowed in the last five 3\' bases of a
left or right primer.

### [PRIMER_MIN_TM (float; default 57.0)]{#PRIMER_MIN_TM}

Minimum acceptable melting temperature (Celsius) for a primer oligo.

### [PRIMER_INTERNAL_MIN_TM (float; default 57.0)]{#PRIMER_INTERNAL_MIN_TM}

Equivalent parameter of [PRIMER_MIN_TM](#PRIMER_MIN_TM) for the internal
oligo.

### [PRIMER_OPT_TM (float; default 60.0)]{#PRIMER_OPT_TM}

Optimum melting temperature (Celsius) for a primer. Primer3 will try to
pick primers with melting temperatures are close to this temperature.
The oligo melting temperature formula used can be specified by user.
Please see [PRIMER_TM_FORMULA](#PRIMER_TM_FORMULA) for more information.

### [PRIMER_INTERNAL_OPT_TM (float; default 60.0)]{#PRIMER_INTERNAL_OPT_TM}

Equivalent parameter of [PRIMER_OPT_TM](#PRIMER_OPT_TM) for the internal
oligo.

### [PRIMER_MAX_TM (float; default 63.0)]{#PRIMER_MAX_TM}

Maximum acceptable melting temperature (Celsius) for a primer oligo.

### [PRIMER_INTERNAL_MAX_TM (float; default 63.0)]{#PRIMER_INTERNAL_MAX_TM}

Equivalent parameter of [PRIMER_MAX_TM](#PRIMER_MAX_TM) for the internal
oligo.

### [PRIMER_PAIR_MAX_DIFF_TM (float; default 100.0)]{#PRIMER_PAIR_MAX_DIFF_TM}

Maximum acceptable (unsigned) difference between the melting
temperatures of the left and right primers.

### [PRIMER_WT_TM_LT (float; default 1.0)]{#PRIMER_WT_TM_LT}

Penalty weight for primers with Tm lower than
[PRIMER_OPT_TM](#PRIMER_OPT_TM).

### [PRIMER_INTERNAL_WT_TM_LT (float; default 1.0)]{#PRIMER_INTERNAL_WT_TM_LT}

Equivalent parameter of [PRIMER_WT_TM_LT](#PRIMER_WT_TM_LT) for the
internal oligo.

### [PRIMER_WT_TM_GT (float; default 1.0)]{#PRIMER_WT_TM_GT}

Penalty weight for primers with Tm over [PRIMER_OPT_TM](#PRIMER_OPT_TM).

### [PRIMER_INTERNAL_WT_TM_GT (float; default 1.0)]{#PRIMER_INTERNAL_WT_TM_GT}

Equivalent parameter of [PRIMER_WT_TM_GT](#PRIMER_WT_TM_GT) for the
internal oligo.

### [PRIMER_PAIR_WT_DIFF_TM (float; default 0.0)]{#PRIMER_PAIR_WT_DIFF_TM}

Penalty weight for the TM difference between the left primer and the
right primer.

### [PRIMER_PRODUCT_MIN_TM (float; default -1000000.0)]{#PRIMER_PRODUCT_MIN_TM}

The minimum allowed melting temperature of the amplicon. Please see the
documentation on [PRIMER_PRODUCT_MAX_TM](#PRIMER_PRODUCT_MAX_TM) for
details.

### [PRIMER_PRODUCT_OPT_TM (float; default 0.0)]{#PRIMER_PRODUCT_OPT_TM}

The optimum melting temperature for the PCR product. 0 indicates that
there is no optimum temperature.

### [PRIMER_PRODUCT_MAX_TM (float; default 1000000.0)]{#PRIMER_PRODUCT_MAX_TM}

The maximum allowed melting temperature of the amplicon. Primer3
calculates product Tm calculated using the formula from Bolton and
McCarthy, PNAS 84:1390 (1962) as presented in Sambrook, Fritsch and
Maniatis, Molecular Cloning, p 11.46 (1989, CSHL Press).

       Tm = 81.5 + 16.6(log10([Na+])) + .41*(%GC) - 600/length

Where \[Na+\] is the molar sodium concentration, (%GC) is the percent of
Gs and Cs in the sequence, and length is the length of the sequence.\
\
A similar formula is used by the prime primer selection program in GCG
(<http://www.gcg.com>), which instead uses 675.0 / length in the last
term (after F. Baldino, Jr, M.-F. Chesselet, and M.E. Lewis, Methods in
Enzymology 168:766 (1989) eqn (1) on page 766 without the mismatch and
formamide terms). The formulas here and in Baldino et al. assume Na+
rather than K+. According to J.G. Wetmur, Critical Reviews in BioChem.
and Mol. Bio. 26:227 (1991) 50 mM K+ should be equivalent in these
formulae to .2 M Na+. Primer3 uses the same salt concentration value for
calculating both the primer melting temperature and the oligo melting
temperature. If you are planning to use the PCR product for
hybridization later this behavior will not give you the Tm under
hybridization conditions.

### [PRIMER_PAIR_WT_PRODUCT_TM_LT (float; default 0.0)]{#PRIMER_PAIR_WT_PRODUCT_TM_LT}

Penalty weight for products with a Tm lower than
[PRIMER_PRODUCT_OPT_TM](#PRIMER_PRODUCT_OPT_TM).

### [PRIMER_PAIR_WT_PRODUCT_TM_GT (float; default 0.0)]{#PRIMER_PAIR_WT_PRODUCT_TM_GT}

Penalty weight for products with a Tm higher than
[PRIMER_PRODUCT_OPT_TM](#PRIMER_PRODUCT_OPT_TM).

### [PRIMER_TM_FORMULA (int; default 1)]{#PRIMER_TM_FORMULA}

Specifies details of melting temperature calculation. (New in v. 1.1.0,
added by Maido Remm and Triinu Koressaar.)\
\
A value of 0 directs Primer3 to a backward compatible calculation (in
other words, the only calculation available in previous version of
Primer3).\
\
This backward compatible calculation uses the table of thermodynamic
parameters in the paper \[Breslauer KJ, Frank R, Blöcker H and Marky LA
(1986) \"Predicting DNA duplex stability from the base sequence\" Proc
Natl Acad Sci 83:4746-50 <http://dx.doi.org/10.1073/pnas.83.11.3746>\],
and the method in the paper \[Rychlik W, Spencer WJ and Rhoads RE (1990)
\"Optimization of the annealing temperature for DNA amplification in
vitro\", Nucleic Acids Res 18:6409-12
<http://dx.doi.org/10.1093/nar/18.21.6409>\].\
\
A value of 1 (\*RECOMMENDED\*) directs Primer3 to use the table of
thermodynamic values and the method for melting temperature calculation
suggested in the paper \[SantaLucia JR (1998) \"A unified view of
polymer, dumbbell and oligonucleotide DNA nearest-neighbor
thermodynamics\", Proc Natl Acad Sci 95:1460-65
<http://dx.doi.org/10.1073/pnas.95.4.1460>\].\
\
Use tag [PRIMER_SALT_CORRECTIONS](#PRIMER_SALT_CORRECTIONS), to specify
the salt correction method for melting temperature calculation.\
\
Example of calculating the melting temperature of an oligo if
[PRIMER_TM_FORMULA](#PRIMER_TM_FORMULA)=1 and
[PRIMER_SALT_CORRECTIONS](#PRIMER_SALT_CORRECTIONS)=1 recommended
values):\
\
primer=CGTGACGTGACGGACT\
\
Using default salt and DNA concentrations we have

    Tm = deltaH/(deltaS + R*ln(C/4))

where R is the gas constant (1.987 cal/K mol) and C is the DNA
concentration.

    deltaH(predicted) =
      = dH(CG) + dH(GT) + dH(TG) + .. + dH(CT) +
         + dH(init.w.term.GC) + dH(init.w.term.AT) =
      = -10.6 + (-8.4) + (-8.5) + .. + (-7.8) + 0.1 + 2.3  =
      = -128.8 kcal/mol

where \'init.w.term GC\' and \'init.w.term AT\' are two initiation
parameters for duplex formation: \'initiation with terminal GC\' and
\'initiation with terminal AT\'

    deltaS(predicted) =
      = dS(CG) + dS(GT) + dS(TG) + .. + dS(CT) +
        + dS(init.w.term.GC) + dS(init.w.term.AT) =
      = -27.2 + (-22.4) + (-22.7) + .. + (-21.0) + (-2.8) + 4.1 =
      = -345.2 cal/k*mol
    deltaS(salt corrected) =
      = deltaS(predicted) + 0.368*15(NN pairs)*ln(0.05M monovalent cations) =
      = -361.736
    Tm = -128.800/(-361.736+1.987*ln((5*10^(-8))/4)) =
       = 323.704 K
    Tm(C) = 323.704 - 273.15 = 50.554 C

### [PRIMER_SALT_MONOVALENT (float; default 50.0)]{#PRIMER_SALT_MONOVALENT}

The millimolar (mM) concentration of monovalent salt cations (usually
KCl) in the PCR. Primer3 uses this argument to calculate oligo and
primer melting temperatures. Use tag
[PRIMER_SALT_DIVALENT](#PRIMER_SALT_DIVALENT) and
[PRIMER_INTERNAL_SALT_DIVALENT](#PRIMER_INTERNAL_SALT_DIVALENT) to
specify the concentrations of divalent cations (in which case you also
should also set tag [PRIMER_DNTP_CONC](#PRIMER_DNTP_CONC) to a
reasonable value).

### [PRIMER_INTERNAL_SALT_MONOVALENT (float; default 50.0)]{#PRIMER_INTERNAL_SALT_MONOVALENT}

Equivalent parameter of
[PRIMER_SALT_MONOVALENT](#PRIMER_SALT_MONOVALENT) for the internal
oligo.

### [PRIMER_SALT_DIVALENT (float; default 1.5)]{#PRIMER_SALT_DIVALENT}

The millimolar concentration of divalent salt cations (usually
MgCl\^(2+)) in the PCR. (New in v. 1.1.0, added by Maido Remm and Triinu
Koressaar)\
\
Primer3 converts concentration of divalent cations to concentration of
monovalent cations using formula suggested in the paper \[Ahsen von N,
Wittwer CT, Schutz E (2001) \"Oligonucleotide Melting Temperatures under
PCR Conditions: Nearest-Neighbor Corrections for Mg\^(2+),
Deoxynucleotide Triphosphate, and Dimethyl Sulfoxide Concentrations with
Comparison to Alternative Empirical Formulas\", Clinical Chemistry
47:1956-61 <http://www.clinchem.org/cgi/content/full/47/11/1956>\].

    [Monovalent cations] = [Monovalent cations] + 120*(([divalent cations] - [dNTP])^0.5)

In addition, if the specified concentration of dNTPs
([PRIMER_DNTP_CONC](#PRIMER_DNTP_CONC)) is larger than the concentration
of divalent cations ([PRIMER_SALT_DIVALENT](#PRIMER_SALT_DIVALENT)) then
the effect of the divalent cations is not considered. The concentration
of dNTPs is considered in the formula above because of some magnesium is
bound by the dNTP. The adjusted concentration of monovalent cations is
used in the calculation of oligo/primer melting temperature, PCR product
melting temperature, the stability of oligo dimers and secondary
structures (when
[PRIMER_THERMODYNAMIC_OLIGO_ALIGNMENT](#PRIMER_THERMODYNAMIC_OLIGO_ALIGNMENT)
is 1), and the stability of ectopic annealing of oligos to template
(when
[PRIMER_THERMODYNAMIC_TEMPLATE_ALIGNMENT](#PRIMER_THERMODYNAMIC_TEMPLATE_ALIGNMENT)
is 1). If [PRIMER_SALT_DIVALENT](#PRIMER_SALT_DIVALENT) \> 0.0, be sure
to set tag [PRIMER_DNTP_CONC](#PRIMER_DNTP_CONC) to specify the
concentration of dNTPs.

### [PRIMER_INTERNAL_SALT_DIVALENT (float; default 0.0)]{#PRIMER_INTERNAL_SALT_DIVALENT}

Equivalent parameter of [PRIMER_SALT_DIVALENT](#PRIMER_SALT_DIVALENT)
for the internal oligo.

### [PRIMER_DNTP_CONC (float; default 0.6)]{#PRIMER_DNTP_CONC}

The millimolar concentration of the sum of all deoxyribonucleotide
triphosphates. A reaction mix containing 0.2 mM ATP, 0.2 mM CTP, 0.2 mM
GTP and 0.2 mM TTP would have a PRIMER_DNTP_CONC=0.8. This argument is
considered for oligo and primer melting temperatures, for PCR product
melting temperature, or for secondary structure calculations only if
[PRIMER_SALT_DIVALENT](#PRIMER_SALT_DIVALENT) is \> 0.0. See
[PRIMER_SALT_DIVALENT](#PRIMER_SALT_DIVALENT).

### [PRIMER_INTERNAL_DNTP_CONC (float; default 0.0)]{#PRIMER_INTERNAL_DNTP_CONC}

Parameter for internal oligos analogous to
[PRIMER_DNTP_CONC](#PRIMER_DNTP_CONC).

### [PRIMER_SALT_CORRECTIONS (int; default 1)]{#PRIMER_SALT_CORRECTIONS}

Specifies the salt correction formula for the melting temperature
calculation. (New in v. 1.1.0, added by Maido Remm and Triinu
Koressaar)\
\
A value of 0 directs Primer3 to use the the salt correction formula in
the paper \[Schildkraut, C, and Lifson, S (1965) \"Dependence of the
melting temperature of DNA on salt concentration\", Biopolymers
3:195-208 (not available on-line)\]. This was the formula used in older
versions of Primer3.\
\
A value of 1 (\*RECOMMENDED\*) directs Primer3 to use the salt
correction formula in the paper \[SantaLucia JR (1998) \"A unified view
of polymer, dumbbell and oligonucleotide DNA nearest-neighbor
thermodynamics\", Proc Natl Acad Sci 95:1460-65
<http://dx.doi.org/10.1073/pnas.95.4.1460>\]\
\
A value of 2 directs Primer3 to use the salt correction formula in the
paper \[Owczarzy, R., Moreira, B.G., You, Y., Behlke, M.A., and Walder,
J.A. (2008). Predicting stability of DNA duplexes in solutions
containing magnesium and monovalent cations. Biochemistry 47, 5336-5353
<http://dx.doi.org/10.1021/bi702363u>\] following recommendations in the
paper \[Ahsen, v.N., Wittwer, C.T., and Schütz, E. (2010). Monovalent
and divalent salt correction algorithms for Tm
prediction-recommendations for Primer3 usage. Brief Bioinform 12, 514
<http://dx.doi.org/10.1093/bib/bbq081>\].\
\
For all values of [PRIMER_SALT_CORRECTIONS](#PRIMER_SALT_CORRECTIONS),
Primer3 also considers the values of the tags
[PRIMER_SALT_DIVALENT](#PRIMER_SALT_DIVALENT),
[PRIMER_INTERNAL_SALT_DIVALENT](#PRIMER_INTERNAL_SALT_DIVALENT),
[PRIMER_DNTP_CONC](#PRIMER_DNTP_CONC), and
[PRIMER_INTERNAL_DNTP_CONC](#PRIMER_INTERNAL_DNTP_CONC).

### [PRIMER_DNA_CONC (float; default 50.0)]{#PRIMER_DNA_CONC}

A value to use as nanomolar (nM) concentration of each annealing oligo
over the course the PCR. Primer3 uses this argument to esimate oligo
melting temperatures. This parameter corresponds to \'c\' in equation
(ii) of the paper \[SantaLucia (1998) A unified view of polymer,
dumbbell, and oligonucleotide DNA nearest-neighbor thermodynamics. Proc
Natl Acad Sci 95:1460-1465
<http://www.pnas.org/content/95/4/1460.full.pdf+html>\], where a
suitable value (for a lower initial concentration of template) is
\"empirically determined\".\
\
The default (50nM) works well with the standard protocol used at the
Whitehead/MIT Center for Genome Research\--0.5 microliters of 20
micromolar concentration for each primer in a 20 microliter reaction
with 10 nanograms template, 0.025 units/microliter Taq polymerase in 0.1
mM each dNTP, 1.5mM MgCl2, 50mM KCl, 10mM Tris-HCL (pH 9.3) using 35
cycles with an annealing temperature of 56 degrees Celsius.\
\
The value of this parameter is less than the actual concentration of
oligos in the initial reaction mix because it is the concentration of
annealing oligos, which in turn depends on the amount of template
(including PCR product) in a given cycle. This concentration increases a
great deal during a PCR; fortunately PCR seems quite robust for a
variety of oligo melting temperatures.\
See ADVICE FOR PICKING PRIMERS.

### [PRIMER_INTERNAL_DNA_CONC (float; default 50.0)]{#PRIMER_INTERNAL_DNA_CONC}

Equivalent parameter of [PRIMER_DNA_CONC](#PRIMER_DNA_CONC) for the
internal oligo.

### [PRIMER_DMSO_CONC (float; default 0.0)]{#PRIMER_DMSO_CONC}

The concentration of DMSO in percent. See PRIMER_DMSO_FACTOR for details
of Tm correction.

### [PRIMER_INTERNAL_DMSO_CONC (float; default 0.0)]{#PRIMER_INTERNAL_DMSO_CONC}

Equivalent parameter of [PRIMER_DMSO_CONC](#PRIMER_DMSO_CONC) for the
internal oligo.

### [PRIMER_DMSO_FACTOR (float; default 0.6)]{#PRIMER_DMSO_FACTOR}

The melting temperature of primers can be approximately corrected for
DMSO:\
\
Tm = Tm (without DMSO) - PRIMER_DMSO_FACTOR \* PRIMER_DMSO_CONC\
\
The PRIMER_DMSO_CONC concentration must be given in %. By default the
PRIMER_DMSO_FACTOR for correction is 0.6 as suggested by Musielski et al
(H Musielski, W Mann, R Laue and S Michel. Z allg Microbiol,
21:447--456, 1981). Ahsen et al. propose a factor of 0.75 (N von Ahsen,
C T Wittwer and E Schutz. Clinical Chemistry, 47:1956--1961, 2001),
Cullen et al. a factor of 0.5 (B Cullen and M Bick. Nucleic acids
research, 3:49--62, 1976) and Escara et al. a factor of 0.675 (J Escara
and J Hutton. Biopolymers, 19:1315--1327, 1980).

### [PRIMER_INTERNAL_DMSO_FACTOR (float; default 0.6)]{#PRIMER_INTERNAL_DMSO_FACTOR}

Equivalent parameter of [PRIMER_DMSO_FACTOR](#PRIMER_DMSO_FACTOR) for
the internal oligo.

### [PRIMER_FORMAMIDE_CONC (float; default 0.0)]{#PRIMER_FORMAMIDE_CONC}

The concentration od DMSO in mol/l. The melting temperature of primers
can be approximately corrected for formamide:\
\
Tm = Tm (without formamide) +(0.453 \*
PRIMER\_\[LEFT/INTERNAL/RIGHT\]\_4_GC_PERCENT / 100 - 2.88) \*
PRIMER_FORMAMIDE_CONC\
\
The PRIMER_FORMAMIDE_CONC correction was suggested by Blake and Delcourt
(R D Blake and S G Delcourt. Nucleic Acids Research, 24, 11:2095--2103,
1996).\
\
Convert % into mol/l:\
\
\[DMSO in mol/l\] = \[DMSO in % weight\] \* 10 / 45.04 g/mol\
\
\[DMSO in mol/l\] = \[DMSO in % volume\] \* 10 \* 1.13 g/cm3 / 45.04
g/mol\
\
Casey, Davidson and Hutton suggest an alternative formula (N Casey and J
Davidson. Nucleic acids research, 4:1539--1532, 1977; JR Hutton. Nucleic
acids research, 4:3537--3555, 1977):\
\
Tm = Tm (without formamide) - 0.65 \* formamide_conc (in %)\
\
To apply this formula in Primer3,
[PRIMER_FORMAMIDE_CONC](#PRIMER_FORMAMIDE_CONC) could be set to 0.0,
[PRIMER_DMSO_FACTOR](#PRIMER_DMSO_FACTOR) set to 1.0. Then the
formamide_conc can be multiplied by 0.65 and added to the
[PRIMER_DMSO_CONC](#PRIMER_DMSO_CONC) multiplied by
[PRIMER_DMSO_FACTOR](#PRIMER_DMSO_FACTOR). The resulting value is given
in [PRIMER_DMSO_CONC](#PRIMER_DMSO_CONC).

### [PRIMER_INTERNAL_FORMAMIDE_CONC (float; default 0.0)]{#PRIMER_INTERNAL_FORMAMIDE_CONC}

Equivalent parameter of [PRIMER_FORMAMIDE_CONC](#PRIMER_FORMAMIDE_CONC)
for the internal oligo.

### [PRIMER_THERMODYNAMIC_OLIGO_ALIGNMENT (boolean; default 1)]{#PRIMER_THERMODYNAMIC_OLIGO_ALIGNMENT}

If the associated value = 1, then Primer3 will use thermodynamic models
to calculate the the propensity of oligos to form hairpins and dimers.

### [PRIMER_THERMODYNAMIC_TEMPLATE_ALIGNMENT (boolean; default 0)]{#PRIMER_THERMODYNAMIC_TEMPLATE_ALIGNMENT}

If the associated value = 1, then Primer3 will use thermodynamic models
to calculate the the propensity of oligos to anneal to undesired sites
in the template sequence.

### [PRIMER_SECONDARY_STRUCTURE_ALIGNMENT (boolean; default 0)]{#PRIMER_SECONDARY_STRUCTURE_ALIGNMENT}

If the associated value = 1, then Primer3 will print out the calculated
secondary structures, for example:

#### Dimers:

    t: 7.8  dG: -1724  dH: -91400  dS: -289
      5' ACGCAAAGCACGCTCC-CGATC 3'
          ||   |||  |||   ||
    3' CTAGCCC-TCGCACGAAACGCA 5'

#### Hairpins:

    t: 36.4  dG: 42  dH: -22500  dS: -73
    5' CGCAAAGCACGCT┐
                ||  │
            3' AGCCC┘

The tags [PRIMER_LEFT_4_SELF_ANY_STUCT](#PRIMER_LEFT_4_SELF_ANY_STUCT),
[PRIMER_LEFT_4_SELF_END_STUCT](#PRIMER_LEFT_4_SELF_END_STUCT),
[PRIMER_LEFT_4_HAIRPIN_STUCT](#PRIMER_LEFT_4_HAIRPIN_STUCT) (these tags
are also present for RIGHT and INTERNAL primers),
[PRIMER_PAIR_4_COMPL_ANY_STUCT](#PRIMER_PAIR_4_COMPL_ANY_STUCT) and
[PRIMER_PAIR_4_COMPL_END_STUCT](#PRIMER_PAIR_4_COMPL_END_STUCT) are only
present if a secondary structure could be calculated.\
\
As the string has to fit on one line, the newlines are indicated by the
two characters \'\\\' and \'n\' and have to be replaced (regex:
/\\\\n/\\n/g). Hairpins use unicode characters for the turn. For html
they have to be replaced (regex: /U\\+25(\\d\\d)/&#x25\$1;/g).

### [PRIMER_THERMODYNAMIC_PARAMETERS_PATH (string; default ./primer3_config)]{#PRIMER_THERMODYNAMIC_PARAMETERS_PATH}

This tag specifies the path to the directory that contains all the
parameter files used by the thermodynamic approach. In Linux, there are
two default locations that are tested if this tag is not defined:
*./primer3_config/* and */opt/primer3_config/*. For Windows, there is
only one default location: *.\\primer3_config\\*.

### [PRIMER_ANNEALING_TEMP (float; default -10.0)]{#PRIMER_ANNEALING_TEMP}

The annealing temperature (Celsius) used in the PCR reaction. Usually it
is chosen up to 10°C below the melting temperature of the primers. If
provided, Primer3 will calculate the fraction of primers bound at the
provided annealing temperature for each oligo. By default not active,
see [\"GENERAL THOUGHTS ON PRIMER BINDING\"](#primerBinding) for more
details.

### [PRIMER_MIN_BOUND (float; default -10.0)]{#PRIMER_MIN_BOUND}

Minimum acceptable fraction of primer bound at
[PRIMER_ANNEALING_TEMP](#PRIMER_ANNEALING_TEMP) for a primer oligo in
percent. By default not active, see [\"GENERAL THOUGHTS ON PRIMER
BINDING\"](#primerBinding) for more details.

### [PRIMER_INTERNAL_MIN_BOUND (float; default -10.0)]{#PRIMER_INTERNAL_MIN_BOUND}

Equivalent parameter of [PRIMER_MIN_BOUND](#PRIMER_MIN_BOUND) for the
internal oligo.

### [PRIMER_OPT_BOUND (float; default 97.0)]{#PRIMER_OPT_BOUND}

Optimum fraction of primer bound at
[PRIMER_ANNEALING_TEMP](#PRIMER_ANNEALING_TEMP) for a primer oligo in
percent. By default not active, see [\"GENERAL THOUGHTS ON PRIMER
BINDING\"](#primerBinding) for more details.

### [PRIMER_INTERNAL_OPT_BOUND (float; default 97.0)]{#PRIMER_INTERNAL_OPT_BOUND}

Equivalent parameter of [PRIMER_OPT_BOUND](#PRIMER_OPT_BOUND) for the
internal oligo.

### [PRIMER_MAX_BOUND (float; default 110.0)]{#PRIMER_MAX_BOUND}

Maximum acceptable fraction of primer bound at
[PRIMER_ANNEALING_TEMP](#PRIMER_ANNEALING_TEMP) for a primer oligo in
percent. By default not active, see [\"GENERAL THOUGHTS ON PRIMER
BINDING\"](#primerBinding) for more details.

### [PRIMER_INTERNAL_MAX_BOUND (float; default 110.0)]{#PRIMER_INTERNAL_MAX_BOUND}

Equivalent parameter of [PRIMER_MAX_BOUND](#PRIMER_MAX_BOUND) for the
internal oligo.

### [PRIMER_WT_BOUND_LT (float; default 0.0)]{#PRIMER_WT_BOUND_LT}

Penalty weight for primers with a fraction of primer bound lower than
[PRIMER_OPT_BOUND](#PRIMER_OPT_BOUND). By default not active, see
[\"GENERAL THOUGHTS ON PRIMER BINDING\"](#primerBinding) for more
details.

### [PRIMER_INTERNAL_WT_BOUND_LT (float; default 0.0)]{#PRIMER_INTERNAL_WT_BOUND_LT}

Equivalent parameter of [PRIMER_WT_BOUND_LT](#PRIMER_WT_BOUND_LT) for
the internal oligo.

### [PRIMER_WT_BOUND_GT (float; default 0.0)]{#PRIMER_WT_BOUND_GT}

Penalty weight for primers with a fraction of primer bound over
[PRIMER_OPT_BOUND](#PRIMER_OPT_BOUND). By default not active, see
[\"GENERAL THOUGHTS ON PRIMER BINDING\"](#primerBinding) for more
details.

### [PRIMER_INTERNAL_WT_BOUND_GT (float; default 0.0)]{#PRIMER_INTERNAL_WT_BOUND_GT}

Equivalent parameter of [PRIMER_WT_BOUND_GT](#PRIMER_WT_BOUND_GT) for
the internal oligo.

### [PRIMER_MAX_SELF_ANY (decimal, 9999.99; default 8.00)]{#PRIMER_MAX_SELF_ANY}

PRIMER_MAX_SELF_ANY describes the tendency of a primer to bind to itself
(interfering with target sequence binding). It will score ANY binding
occurring within the entire primer sequence.\
It is the maximum allowable local alignment score when testing a single
primer for (local) self-complementarity. Local self-complementarity is
taken to predict the tendency of primers to anneal to each other without
necessarily causing self-priming in the PCR. The scoring system gives
1.00 for complementary bases, -0.25 for a match of any base (or N) with
an N, -1.00 for a mismatch, and -2.00 for a gap. Only single-base-pair
gaps are allowed. For example, the alignment

       5' ATCGNA 3'
          || | |
       3' TA-CGT 5'

is allowed (and yields a score of 1.75), but the alignment

       5' ATCCGNA 3'
          ||  | |
       3' TA--CGT 5'

is not considered. Scores are non-negative, and a score of 0.00
indicates that there is no reasonable local alignment between two
oligos.

### [PRIMER_MAX_SELF_ANY_TH (decimal, 9999,99; default 47.00)]{#PRIMER_MAX_SELF_ANY_TH}

The same as PRIMER_MAX_SELF_ANY but all calculations are based on
thermodynamical approach. The melting temperature of the most stable
structure is calculated. To calculate secondary structures
nearest-neighbor parameters for perfect matches, single internal
mismatches, terminal mismatches, dangling ends have been used. Also
parameters for increments for length dependence of bulge and internal
loops have been used. This parameter is calculated only if
PRIMER_THERMODYNAMIC_OLIGO_ALIGNMENT=1. The default value is 10 degrees
lower than the default value of PRIMER_MIN_TM. For example, the
alignment width length 15nt

      5' ATTAGATAGAGCATC 3'
      3' TAATCTATCTCGTAG 5'

is allowed (and yields a melting temperature of 32.1493 width by default
Primer3 parameters), but the alignment

         T        C
      5'  GCGGCCGC GCGC 3'
      3'  CGCCGGCG CGCG 5'
         A        A

is not considered (Tm=57.0997 and the length of oligo is 14nt).
Thermodynamical parameters and methods for finding the most stable
structure are described in following papers:

-   \[SantaLucia JR (1998) \"A unified view of polymer, dumbbell and
    oligonucleotide DNA nearest-neighbor thermodynamics\", Proc Natl
    Acad Sci 95:1460-65 <http://dx.doi.org/10.1073/pnas.95.4.1460>\]
-   \[SantaLucia JR and Hicks D (2004) \"The thermodynamics of DNA
    structural motifs\", Annu Rev Biophys Biomol Struct 33:415-40
    <http://dx.doi.org/10.1146/annurev.biophys.32.110601.141800>\]
-   \[Bommarito S, Peyret N and SantaLucia J Jr (2000) \"Thermodynamic
    parameters for DNA sequences with dangling ends\", Nucleic Acids Res
    28(9):1929-34 <http://dx.doi.org/10.1093/nar/28.9.1929>\]
-   \[Peyret N, Seneviratne PA, Allawi HT, SantaLucia J Jr. (1999)
    \"Nearest-neighbor thermodynamics and NMR of DNA sequences with
    internal A.A, C.C, G.G, and T.T mismatches\", Biochemistry
    38(12):3468-77 <http://dx.doi.org/10.1021/bi9825091>\]
-   \[Allawi HT and SantaLucia J Jr. (1998) \"Nearest-Neighbor
    Thermodynamics of Internal A·C Mismatches in DNA: Sequence
    Dependence and pH Effects\", Biochemistry 37(26):9435-44
    <http://dx.doi.org/10.1021/bi9803729>
-   \[Allawi HT and SantaLucia J Jr. (1998) \"Thermodynamics of internal
    C.T mismatches in DNA.\" Nucleic Acids Res
    26(11):2694-701<http://dx.doi.org/10.1093/nar/26.11.2694>\]
-   \[Allawi HT and SantaLucia J Jr. (1998) \"Nearest neighbor
    thermodynamic parameters for internal G.A mismatches in DNA.\"
    Biochemistry 37(8):2170-9 <http://dx.doi.org/10.1021/bi9724873>\]
-   \[Allawi HT and SantaLucia J Jr. (1997) \"Thermodynamics and NMR of
    internal G.T mismatches in DNA.\" Biochemistry 36(34):10581-94
    <http://dx.doi.org/10.1021/bi962590c>\]
-   \[SantaLucia J Jr and Peyret N. (2001) \"Method and system for
    predicting nucleic acid hybridization thermodynamics and
    computer-readable storage medium for use therein\" World
    Intellectual Property Organization, WO 01/94611
    <http://www.wipo.int/pctdb/en/wo.jsp?wo=2001094611>\]

\
Predicting secondary structures can improve primer design by eliminating
sequences with high possibility to form alternative secondary
structures.

### [PRIMER_INTERNAL_MAX_SELF_ANY (decimal, 9999.99; default 12.00)]{#PRIMER_INTERNAL_MAX_SELF_ANY}

Equivalent parameter of [PRIMER_MAX_SELF_ANY](#PRIMER_MAX_SELF_ANY) for
the internal oligo.

### [PRIMER_INTERNAL_MAX_SELF_ANY_TH (decimal, 9999.99; default 47.00)]{#PRIMER_INTERNAL_MAX_SELF_ANY_TH}

Equivalent parameter of
[PRIMER_MAX_SELF_ANY_TH](#PRIMER_MAX_SELF_ANY_TH) for the internal
oligo.

### [PRIMER_PAIR_MAX_COMPL_ANY (decimal, 9999.99; default 8.00)]{#PRIMER_PAIR_MAX_COMPL_ANY}

PRIMER_PAIR_MAX_COMPL_ANY describes the tendency of the left primer to
bind to the right primer. It is the maximum allowable local alignment
score when testing for complementarity between left and right primers.
It is similar to [PRIMER_MAX_SELF_ANY](#PRIMER_MAX_SELF_ANY).

### [PRIMER_PAIR_MAX_COMPL_ANY_TH (decimal, 9999.99; default 47.00)]{#PRIMER_PAIR_MAX_COMPL_ANY_TH}

PRIMER_PAIR_MAX_COMPL_ANY_TH describes the tendency of the left primer
to bind to the right primer. It is similar to
[PRIMER_MAX_SELF_ANY_TH](#PRIMER_MAX_SELF_ANY_TH).

### [PRIMER_WT_SELF_ANY (float; default 0.0)]{#PRIMER_WT_SELF_ANY}

Penalty weight for the individual primer self binding value as in
[PRIMER_MAX_SELF_ANY](#PRIMER_MAX_SELF_ANY).

### [PRIMER_WT_SELF_ANY_TH (float; default 0.0)]{#PRIMER_WT_SELF_ANY_TH}

Penalty weight for the individual primer self binding value as in
[PRIMER_MAX_SELF_ANY_TH](#PRIMER_MAX_SELF_ANY_TH).

### [PRIMER_INTERNAL_WT_SELF_ANY (float; default 0.0)]{#PRIMER_INTERNAL_WT_SELF_ANY}

Equivalent parameter of [PRIMER_WT_SELF_ANY](#PRIMER_WT_SELF_ANY) for
the internal oligo.

### [PRIMER_INTERNAL_WT_SELF_ANY_TH (float; default 0.0)]{#PRIMER_INTERNAL_WT_SELF_ANY_TH}

Equivalent parameter of [PRIMER_WT_SELF_ANY_TH](#PRIMER_WT_SELF_ANY_TH)
for the internal oligo.

### [PRIMER_PAIR_WT_COMPL_ANY (float; default 0.0)]{#PRIMER_PAIR_WT_COMPL_ANY}

Penalty weight for the binding value of the primer pair as in
[PRIMER_MAX_SELF_ANY](#PRIMER_MAX_SELF_ANY).

### [PRIMER_PAIR_WT_COMPL_ANY_TH (float; default 0.0)]{#PRIMER_PAIR_WT_COMPL_ANY_TH}

Penalty weight for the binding value of the primer pair as in
[PRIMER_MAX_SELF_ANY_TH](#PRIMER_MAX_SELF_ANY_TH).

### [PRIMER_MAX_SELF_END (decimal, 9999.99; default 3.00)]{#PRIMER_MAX_SELF_END}

PRIMER_MAX_SELF_END tries to bind the 3\'-END to a identical primer and
scores the best binding it can find. This is critical for primer quality
because it allows primers use itself as a target and amplify a short
piece (forming a primer-dimer). These primers are then unable to bind
and amplify the target sequence.\
PRIMER_MAX_SELF_END is the maximum allowable 3\'-anchored global
alignment score when testing a single primer for self-complementarity.
The 3\'-anchored global alignment score is taken to predict the
likelihood of PCR-priming primer-dimers, for example

       5' ATGCCCTAGCTTCCGGATG 3'
                    ||| |||||
                 3' AAGTCCTACATTTAGCCTAGT 5'

or

       5` AGGCTATGGGCCTCGCGA 3'
                      ||||||
                   3' AGCGCTCCGGGTATCGGA 5'

The scoring system is as for the Maximum Complementarity argument. In
the examples above the scores are 7.00 and 6.00 respectively. Scores are
non-negative, and a score of 0.00 indicates that there is no reasonable
3\'-anchored global alignment between two oligos. In order to estimate
3\'-anchored global alignments for candidate primers, Primer3 assumes
that the sequence from which to choose primers is presented 5\'-\>3\'.
It is nonsensical to provide a larger value for this parameter than for
the Maximum (local) Complementarity parameter
([PRIMER_MAX_SELF_ANY](#PRIMER_MAX_SELF_ANY)) because the score of a
local alignment will always be at least as great as the score of a
global alignment.

### [PRIMER_MAX_SELF_END_TH (decimal 9999.99; default 47.00)]{#PRIMER_MAX_SELF_END_TH}

Same as [PRIMER_MAX_SELF_END](#PRIMER_MAX_SELF_END) but is based on
thermodynamical approach - the stability of structure is analyzed. The
value of tag is expressed as melting temperature. See
[PRIMER_MAX_SELF_ANY_TH](#PRIMER_MAX_SELF_ANY_TH) for details.

### [PRIMER_INTERNAL_MAX_SELF_END (decimal 9999.99; default 12.00)]{#PRIMER_INTERNAL_MAX_SELF_END}

[PRIMER_INTERNAL_MAX_SELF_END](#PRIMER_INTERNAL_MAX_SELF_END) is
meaningless when applied to internal oligos used for hybridization-based
detection, since primer-dimer will not occur. We recommend that
[PRIMER_INTERNAL_MAX_SELF_END](#PRIMER_INTERNAL_MAX_SELF_END) be set at
least as high as
[PRIMER_INTERNAL_MAX_SELF_ANY](#PRIMER_INTERNAL_MAX_SELF_ANY).

### [PRIMER_INTERNAL_MAX_SELF_END_TH (decimal 9999.99; default 47.00)]{#PRIMER_INTERNAL_MAX_SELF_END_TH}

Same as [PRIMER_INTERNAL_MAX_SELF_END](#PRIMER_INTERNAL_MAX_SELF_END)
but for calculating the score (melting temperature of structure)
thermodynamical approach is used.

### [PRIMER_PAIR_MAX_COMPL_END (decimal, 9999.99; default 3.00)]{#PRIMER_PAIR_MAX_COMPL_END}

PRIMER_PAIR_MAX_COMPL_END tries to bind the 3\'-END of the left primer
to the right primer and scores the best binding it can find. It is
similar to [PRIMER_MAX_SELF_END](#PRIMER_MAX_SELF_END).

### [PRIMER_PAIR_MAX_COMPL_END_TH (decimal, 9999.99; default 47.00)]{#PRIMER_PAIR_MAX_COMPL_END_TH}

Same as [PRIMER_PAIR_MAX_COMPL_END](#PRIMER_PAIR_MAX_COMPL_END) but for
calculating the score (melting temperature of structure) thermodynamical
approach is used.

### [PRIMER_WT_SELF_END (float; default 0.0)]{#PRIMER_WT_SELF_END}

Penalty weight for the individual primer self binding value as in
[PRIMER_MAX_SELF_END](#PRIMER_MAX_SELF_END).

### [PRIMER_WT_SELF_END_TH (float; default 0.0)]{#PRIMER_WT_SELF_END_TH}

Penalty weight for the individual primer self binding value as in
[PRIMER_MAX_SELF_END_TH](#PRIMER_MAX_SELF_END_TH)

### [PRIMER_INTERNAL_WT_SELF_END (float; default 0.0)]{#PRIMER_INTERNAL_WT_SELF_END}

Equivalent parameter of [PRIMER_WT_SELF_END](#PRIMER_WT_SELF_END) for
the internal oligo.

### [PRIMER_INTERNAL_WT_SELF_END_TH (float; default 0.0)]{#PRIMER_INTERNAL_WT_SELF_END_TH}

Equivalent parameter of [PRIMER_WT_SELF_END_TH](#PRIMER_WT_SELF_END_TH)
for the internal oligo.

### [PRIMER_PAIR_WT_COMPL_END (float; default 0.0)]{#PRIMER_PAIR_WT_COMPL_END}

Penalty weight for the binding value of the primer pair as in
[PRIMER_MAX_SELF_END](#PRIMER_MAX_SELF_END).

### [PRIMER_PAIR_WT_COMPL_END_TH (float; default 0.0)]{#PRIMER_PAIR_WT_COMPL_END_TH}

Penalty weight for the binding value of the primer pair as in
[PRIMER_MAX_SELF_END_TH](#PRIMER_MAX_SELF_END_TH).

### [PRIMER_MAX_HAIRPIN_TH (float; default 47.0)]{#PRIMER_MAX_HAIRPIN_TH}

This is the most stable monomer structure of internal oligo calculated
by thermodynamic approach. The hairpin loops, bulge loops, internal
loops, internal single mismatches, dangling ends, terminal mismatches
have been considered. This parameter is calculated only if
PRIMER_THERMODYNAMIC_OLIGO_ALIGNMENT=1. The default value is 10 degrees
lower than the default value of PRIMER_MIN_TM. For example the
structure:

          -///------\\\-
       5' ACGCTGTGCTGCGA 3'

with melting temperature 53.7263 (calculated according to by default
values of Primer3) and

          //////----\\\\\\
       5' CCGCAGTAAGCTGCGG 3'

with melting temperature 71.0918 (calculated according to by default
values of Primer3) For details about papers used for calculating
hairpins see [PRIMER_MAX_SELF_ANY_TH](#PRIMER_MAX_SELF_ANY_TH)

### [PRIMER_INTERNAL_MAX_HAIRPIN_TH (float; default 47.0)]{#PRIMER_INTERNAL_MAX_HAIRPIN_TH}

The most stable monomer structure of internal oligo calculated by
thermodynamic approach. See
[PRIMER_MAX_HAIRPIN_TH](#PRIMER_MAX_HAIRPIN_TH) for details.

### [PRIMER_WT_HAIRPIN_TH (float; default 0.0)]{#PRIMER_WT_HAIRPIN_TH}

Penalty weight for the individual primer hairpin structure value as in
[PRIMER_MAX_HAIRPIN_TH](#PRIMER_MAX_HAIRPIN_TH).

### [PRIMER_INTERNAL_WT_HAIRPIN_TH (float; default 0.0)]{#PRIMER_INTERNAL_WT_HAIRPIN_TH}

Penalty weight for the most stable primer hairpin structure value as in
[PRIMER_INTERNAL_MAX_HAIRPIN_TH](#PRIMER_INTERNAL_MAX_HAIRPIN_TH).

### [PRIMER_MAX_END_STABILITY (float, 999.9999; default 100.0)]{#PRIMER_MAX_END_STABILITY}

The maximum stability for the last five 3\' bases of a left or right
primer. Bigger numbers mean more stable 3\' ends. The value is the
maximum delta G (kcal/mol) for duplex disruption for the five 3\' bases
as calculated using the nearest-neighbor parameter values specified by
the option of [PRIMER_TM_FORMULA](#PRIMER_TM_FORMULA)\
\
For example if the table of thermodynamic parameters suggested by
[SantaLucia 1998,
DOI:10.1073/pnas.95.4.1460](http://dx.doi.org/10.1073/pnas.95.4.1460) is
used the deltaG values for the most stable and for the most labile 5mer
duplex are 6.86 kcal/mol (GCGCG) and 0.86 kcal/mol (TATAT)
respectively.\
\
If the table of thermodynamic parameters suggested by [Breslauer et al.
1986,
10.1073/pnas.83.11.3746](http://dx.doi.org/10.1073/pnas.83.11.3746) is
used the deltaG values for the most stable and for the most labile 5mer
are 13.4 kcal/mol (GCGCG) and 4.6 kcal/mol (TATAC) respectively.

### [PRIMER_WT_END_STABILITY (float; default 0.0)]{#PRIMER_WT_END_STABILITY}

Penalty factor for the calculated maximum stability for the last five
3\' bases of a left or right primer.

### [PRIMER_MAX_NS_ACCEPTED (int; default 0)]{#PRIMER_MAX_NS_ACCEPTED}

Maximum number of unknown bases (N) allowable in any primer.

### [PRIMER_INTERNAL_MAX_NS_ACCEPTED (int; default 0)]{#PRIMER_INTERNAL_MAX_NS_ACCEPTED}

Equivalent parameter of
[PRIMER_MAX_NS_ACCEPTED](#PRIMER_MAX_NS_ACCEPTED) for the internal
oligo.

### [PRIMER_WT_NUM_NS (float; default 0.0)]{#PRIMER_WT_NUM_NS}

Penalty weight for the number of Ns in the primer.

### [PRIMER_INTERNAL_WT_NUM_NS (float; default 0.0)]{#PRIMER_INTERNAL_WT_NUM_NS}

Equivalent parameter of [PRIMER_WT_NUM_NS](#PRIMER_WT_NUM_NS) for the
internal oligo.

### [PRIMER_MAX_POLY_X (int; default 5)]{#PRIMER_MAX_POLY_X}

The maximum allowable length of a mononucleotide repeat, for example
AAAAAA, \'GGGNNN\' violates MAX_POLY_X=5. It is based on the worst
possible case (all 3 Ns could be Gs).

### [PRIMER_INTERNAL_MAX_POLY_X (int; default 5)]{#PRIMER_INTERNAL_MAX_POLY_X}

Equivalent parameter of [PRIMER_MAX_POLY_X](#PRIMER_MAX_POLY_X) for the
internal oligo.

### [PRIMER_MIN_LEFT_THREE_PRIME_DISTANCE (int; default -1)]{#PRIMER_MIN_LEFT_THREE_PRIME_DISTANCE}

When returning multiple primer pairs, the minimum number of base pairs
between the 3\' ends of any two left primers.\
\
Primers with 3\' ends at positions e.g. 30 and 31 in the template
sequence have a three-prime distance of 1.\
\
In addition to positive values, the values -1 and 0 are acceptable and
have special interpretations:\
\
-1 indicates that a given left primer can appear in multiple primer
pairs returned by Primer3. This is the default behavior.\
\
0 indicates that a left primer is acceptable if it was not already used.
In other words, two left primers are allowed to have the same 3\'
position provided their 5\' positions differ.\
\
For *n* \> 0: A left primer is acceptable if:\
\
NOT(3\' end of left primer closer than *n* to the 3\' end of a
previously used left primer)\

### [PRIMER_INTERNAL_MIN_THREE_PRIME_DISTANCE (int; default -1)]{#PRIMER_INTERNAL_MIN_THREE_PRIME_DISTANCE}

Analogous to
[PRIMER_MIN_LEFT_THREE_PRIME_DISTANCE](#PRIMER_MIN_LEFT_THREE_PRIME_DISTANCE),
but for internal primer / probe.\

### [PRIMER_MIN_RIGHT_THREE_PRIME_DISTANCE (int; default -1)]{#PRIMER_MIN_RIGHT_THREE_PRIME_DISTANCE}

Analogous to
[PRIMER_MIN_LEFT_THREE_PRIME_DISTANCE](#PRIMER_MIN_LEFT_THREE_PRIME_DISTANCE),
but for right primers.\

### [PRIMER_MIN_THREE_PRIME_DISTANCE (int; default -1)]{#PRIMER_MIN_THREE_PRIME_DISTANCE}

A \"convenience\" tag that simultaneously sets
[PRIMER_MIN_LEFT_THREE_PRIME_DISTANCE](#PRIMER_MIN_LEFT_THREE_PRIME_DISTANCE)
and
[PRIMER_MIN_RIGHT_THREE_PRIME_DISTANCE](#PRIMER_MIN_RIGHT_THREE_PRIME_DISTANCE)\
\
For example

    PRIMER_MIN_THREE_PRIME_DISTANCE=3

is equivalent to

    PRIMER_MIN_LEFT_THREE_PRIME_DISTANCE=3
    PRIMER_MIN_RIGHT_THREE_PRIME_DISTANCE=3

It is an error to specify both PRIMER_MIN_THREE_PRIME_DISTANCE and
either
[PRIMER_MIN_LEFT_THREE_PRIME_DISTANCE](#PRIMER_MIN_LEFT_THREE_PRIME_DISTANCE)
or
[PRIMER_MIN_RIGHT_THREE_PRIME_DISTANCE](#PRIMER_MIN_RIGHT_THREE_PRIME_DISTANCE)
in the same input record.

### [PRIMER_PICK_ANYWAY (boolean; default 0)]{#PRIMER_PICK_ANYWAY}

If true use primer provided in [SEQUENCE_PRIMER](#SEQUENCE_PRIMER),
[SEQUENCE_PRIMER_REVCOMP](#SEQUENCE_PRIMER_REVCOMP), or
[SEQUENCE_INTERNAL_OLIGO](#SEQUENCE_INTERNAL_OLIGO) even if it violates
specific constraints.

### [PRIMER_LOWERCASE_MASKING (int; default 0)]{#PRIMER_LOWERCASE_MASKING}

This option allows for intelligent design of primers in sequence in
which masked regions (for example repeat-masked regions) are
lower-cased. (New in v. 1.1.0, added by Maido Remm and Triinu
Koressaar)\
\
A value of 1 directs Primer3 to reject primers overlapping lowercase a
base exactly at the 3\' end.\
\
This property relies on the assumption that masked features (e.g.
repeats) can partly overlap primer, but they cannot overlap the 3\'-end
of the primer. In other words, lowercase bases at other positions in the
primer are accepted, assuming that the masked features do not influence
the primer performance if they do not overlap the 3\'-end of primer.

### [PRIMER_EXPLAIN_FLAG (boolean; default 0)]{#PRIMER_EXPLAIN_FLAG}

If this flag is 1 (non-0), produce
[PRIMER_LEFT_EXPLAIN](#PRIMER_LEFT_EXPLAIN),
[PRIMER_RIGHT_EXPLAIN](#PRIMER_RIGHT_EXPLAIN),
[PRIMER_INTERNAL_EXPLAIN](#PRIMER_INTERNAL_EXPLAIN) and/or
[PRIMER_PAIR_EXPLAIN](#PRIMER_PAIR_EXPLAIN) output tags as appropriate.
These output tags are intended to provide information on the number of
oligos and primer pairs that Primer3 examined and counts of the number
discarded for various reasons. If -format_output is set similar
information is produced in the user-oriented output.

### [PRIMER_LIBERAL_BASE (boolean; default 0)]{#PRIMER_LIBERAL_BASE}

This parameter provides a quick-and-dirty way to get Primer3 to accept
IUB / IUPAC codes for ambiguous bases (i.e. by changing all unrecognized
bases to N). If you wish to include an ambiguous base in an oligo, you
must set [PRIMER_MAX_NS_ACCEPTED](#PRIMER_MAX_NS_ACCEPTED) to a 1
(non-0) value.\
\
Perhaps \'-\' and \'\* \' should be squeezed out rather than changed to
\'N\', but currently they simply get converted to N\'s. The authors
invite user comments.

### [PRIMER_FIRST_BASE_INDEX (int; default 0)]{#PRIMER_FIRST_BASE_INDEX}

This parameter is the index of the first base in the input sequence. For
input and output using 1-based indexing (such as that used in GenBank
and to which many users are accustomed) set this parameter to 1. For
input and output using 0-based indexing set this parameter to 0. (This
parameter also affects the indexes in the contents of the files produced
when the primer file flag is set.)

### [PRIMER_MAX_TEMPLATE_MISPRIMING (decimal, 9999.99; default -1.00)]{#PRIMER_MAX_TEMPLATE_MISPRIMING}

The maximum allowed similarity to ectopic sites in the template. A
negative value means do not check. The scoring system is the same as
used for
[PRIMER_MAX_LIBRARY_MISPRIMING](#PRIMER_MAX_LIBRARY_MISPRIMING), except
that an ambiguity code in the template is never treated as a consensus
(see
[PRIMER_LIB_AMBIGUITY_CODES_CONSENSUS](#PRIMER_LIB_AMBIGUITY_CODES_CONSENSUS)).

### [PRIMER_MAX_TEMPLATE_MISPRIMING_TH (decimal, 9999.99; default -1.00)]{#PRIMER_MAX_TEMPLATE_MISPRIMING_TH}

Similar to
[PRIMER_MAX_TEMPLATE_MISPRIMING](#PRIMER_MAX_TEMPLATE_MISPRIMING) but
assesses alternative binding sites in the template using thermodynamic
models (when PRIMER_THERMODYNAMIC_TEMPLATE_ALIGNMENT=1). This parameter
specifies the maximum allowed melting temperature of an oligo (primer)
at an \"ectopic\" site within the template sequence; 47.0 would be a
reasonable choice if [PRIMER_MIN_TM](#PRIMER_MIN_TM) is 57.0.

### [PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING (decimal, 9999.99; default -1.00)]{#PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING}

The maximum allowed summed similarity of both primers to ectopic sites
in the template. A negative value means do not check. The scoring system
is the same as used for
[PRIMER_PAIR_MAX_LIBRARY_MISPRIMING](#PRIMER_PAIR_MAX_LIBRARY_MISPRIMING),
except that an ambiguity code in the template is never treated as a
consensus (see
[PRIMER_LIB_AMBIGUITY_CODES_CONSENSUS](#PRIMER_LIB_AMBIGUITY_CODES_CONSENSUS)).
Primer3 does not check the similarity of hybridization oligos (internal
oligos) to locations outside of the amplicon.

### [PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING_TH (decimal, 9999.99; default -1.00)]{#PRIMER_PAIR_MAX_TEMPLATE_MISPRIMING_TH}

The maximum allowed summed melting temperatures of both primers at
ectopic sites within the template (with the two primers in an
orientation that would allow PCR amplification.) The melting
temperatures are calculated as for
[PRIMER_MAX_TEMPLATE_MISPRIMING_TH](#PRIMER_MAX_TEMPLATE_MISPRIMING_TH).

### [PRIMER_WT_TEMPLATE_MISPRIMING (float; default 0.0)]{#PRIMER_WT_TEMPLATE_MISPRIMING}

Penalty for a single primer binding to the template sequence.\
\
The use of this Tag is modified from Primer3 version 2.0 on: The values
used with the older versions have to be multiplied by the factor 100 to
have the same effect.

### [PRIMER_WT_TEMPLATE_MISPRIMING_TH (float; default 0.0)]{#PRIMER_WT_TEMPLATE_MISPRIMING_TH}

Penalty for a single primer binding to the template sequence
(thermodynamic approach, when
PRIMER_THERMODYNAMIC_TEMPLATE_ALIGNMENT=1).

### [PRIMER_PAIR_WT_TEMPLATE_MISPRIMING (float; default 0.0)]{#PRIMER_PAIR_WT_TEMPLATE_MISPRIMING}

Penalty for a primer pair binding to the template sequence.\
\
The use of this Tag is modified from Primer3 version 2.0 on: The values
used with the older versions have to be multiplied by the factor 100 to
have the same effect.

### [PRIMER_PAIR_WT_TEMPLATE_MISPRIMING_TH (float; default 0.0)]{#PRIMER_PAIR_WT_TEMPLATE_MISPRIMING_TH}

Penalty for a primer pair binding to the template sequence
(thermodynamic approach, when
PRIMER_THERMODYNAMIC_TEMPLATE_ALIGNMENT=1).

### [PRIMER_MISPRIMING_LIBRARY (string; default empty)]{#PRIMER_MISPRIMING_LIBRARY}

The name of a file containing a nucleotide sequence library of sequences
to avoid amplifying (for example repetitive sequences, or possibly the
sequences of genes in a gene family that should not be amplified.) The
file must be in (a slightly restricted) FASTA format (W. B. Pearson and
D.J. Lipman, PNAS 85:8 pp 2444-2448 \[1988\]); we briefly discuss the
organization of this file below. If this parameter is specified then
Primer3 locally aligns each candidate primer against each library
sequence and rejects those primers for which the local alignment score
times a specified weight (see below) exceeds
[PRIMER_MAX_LIBRARY_MISPRIMING](#PRIMER_MAX_LIBRARY_MISPRIMING). (The
maximum value of the weight is arbitrarily set to 100.0.)\
\
Each sequence entry in the FASTA-format file must begin with an \"id
line\" that starts with \'\>\'. The contents of the id line is
\"slightly restricted\" in that Primer3 parses everything after any
optional asterisk (\'\*\') as a floating point number to use as the
weight mentioned above. If the id line contains no asterisk then the
weight defaults to 1.0. The alignment scoring system used is the same as
for calculating complementarity among oligos (e.g.
[PRIMER_MAX_SELF_ANY](#PRIMER_MAX_SELF_ANY)), except for the handling of
IUB/IUPAC ambiguity codes (discussed below).\
\
The remainder of an entry contains the sequence as lines following the
id line up until a line starting with \'\>\' or the end of the file.
Whitespace and newlines are ignored. Characters \'A\', \'T\', \'G\',
\'C\', \'a\', \'t\', \'g\', \'c\' and IUB/IUPAC \'ambiguity\' codes
(\'R, \'Y\', \'K\', \'M\', \'S\', \'W\', \'N\', including lower case)
are retained. For technical reasons the length of the sequence must be
\>= 3. Of course, sequences of length \< 10 or so are probably useless,
but will be accepted without complaint.\
\
WARNING: always set
[PRIMER_LIB_AMBIGUITY_CODES_CONSENSUS](#PRIMER_LIB_AMBIGUITY_CODES_CONSENSUS)=0
if any sequence in the library contains strings of \'N\'s:
NNNNNNNNNNNNNNNNNNNN.\
\
There are no restrictions on line length.\
\
An empty value for this parameter indicates that no repeat library
should be used and \"turns off\" the use of a previously specified
library.\
\
Repbase (J. Jurka, A.F.A. Smit, C. Pethiyagoda, and others, 1995-1996,
<ftp://ftp.ncbi.nih.gov/repository/repbase/>) is an excellent source of
repeat sequences and pointers to the literature. (The Repbase files need
to be converted to Fasta format before they can be used by Primer3.)\
\
See [providedMisprimingLibs](#providedMisprimingLibs) for the sequence
libraries available on this server.

### [PRIMER_INTERNAL_MISHYB_LIBRARY (string; default empty)]{#PRIMER_INTERNAL_MISHYB_LIBRARY}

Similar to [PRIMER_MISPRIMING_LIBRARY](#PRIMER_MISPRIMING_LIBRARY),
except that the event we seek to avoid is hybridization of the internal
oligo to sequences in this library rather than priming from them.

### [PRIMER_LIB_AMBIGUITY_CODES_CONSENSUS (boolean; default 0)]{#PRIMER_LIB_AMBIGUITY_CODES_CONSENSUS}

If set to 1, treat ambiguity codes as if they were consensus codes when
matching oligos to mispriming or mishyb libraries. For example, if this
flag is set, then a C in an oligo will be scored as a perfect match to
an S in a library sequence, as will a G in the oligo. More importantly,
though, any base in an oligo will be scored as a perfect match to an N
in the library. This is very bad if the library contains strings of Ns,
as no oligo will be legal (and it will take a long time to find this
out). So unless you know for sure that your library does not have runs
of Ns (or Xs), then set this flag to 0.

### [PRIMER_MAX_LIBRARY_MISPRIMING (decimal, 9999.99; default 12.00)]{#PRIMER_MAX_LIBRARY_MISPRIMING}

The maximum allowed weighted similarity with any sequence in
[PRIMER_MISPRIMING_LIBRARY](#PRIMER_MISPRIMING_LIBRARY).

### [PRIMER_INTERNAL_MAX_LIBRARY_MISHYB (decimal,9999.99; default 12.00)]{#PRIMER_INTERNAL_MAX_LIBRARY_MISHYB}

Similar to
[PRIMER_MAX_LIBRARY_MISPRIMING](#PRIMER_MAX_LIBRARY_MISPRIMING) except
that this parameter applies to the similarity of candidate internal
oligos to the library specified in
[PRIMER_INTERNAL_MISHYB_LIBRARY](#PRIMER_INTERNAL_MISHYB_LIBRARY).

### [PRIMER_PAIR_MAX_LIBRARY_MISPRIMING (decimal, 9999.99; default 24.00)]{#PRIMER_PAIR_MAX_LIBRARY_MISPRIMING}

The maximum allowed sum of similarities of a primer pair (one similarity
for each primer) with any single sequence in
[PRIMER_MISPRIMING_LIBRARY](#PRIMER_MISPRIMING_LIBRARY). Library
sequence weights are not used in computing the sum of similarities.

### [PRIMER_WT_LIBRARY_MISPRIMING (float; default 0.0)]{#PRIMER_WT_LIBRARY_MISPRIMING}

Penalty for a single primer binding to any single sequence in
[PRIMER_MISPRIMING_LIBRARY](#PRIMER_MISPRIMING_LIBRARY).

### [PRIMER_INTERNAL_WT_LIBRARY_MISHYB (float; default 0.0)]{#PRIMER_INTERNAL_WT_LIBRARY_MISHYB}

Equivalent parameter of
[PRIMER_WT_LIBRARY_MISPRIMING](#PRIMER_WT_LIBRARY_MISPRIMING) for the
internal oligo.

### [PRIMER_PAIR_WT_LIBRARY_MISPRIMING (float; default 0.0)]{#PRIMER_PAIR_WT_LIBRARY_MISPRIMING}

Penalty for a primer pair binding to any single sequence in
[PRIMER_MISPRIMING_LIBRARY](#PRIMER_MISPRIMING_LIBRARY).

### [PRIMER_MASK_TEMPLATE (boolean; default 0)]{#PRIMER_MASK_TEMPLATE}

This feature helps to prevent designing primers to template regions that
are repetitive. Primers with more binding sites tend to have higher
failure rates. The masking is based on statistical model, which
calculates the probability of failure P~f~ as follows:

    Pf= em / (1 + em),

where m =0.1772 \* K11 + 0.239 \* K16 - 4.336\
and K11 and K16 are frequencies of 11-mers and 16-mers in given genome.
The frequencies are stored in species-specific k-mer list files. Users
can build their own k-mer lists for species of interest. GenomeTester4
software for making properly formatted k-mer lists can be downloaded
from GitHub: <https://github.com/bioinfo-ut/GenomeTester4>.

### [PRIMER_MASK_FAILURE_RATE (float; default 0.1)]{#PRIMER_MASK_FAILURE_RATE}

Cutoff value of accepted failure rate for masking algorithm. Higher
value gives lower stringency, meaning that fewer nucleotides in target
sequence is masked.

### [PRIMER_WT_MASK_FAILURE_RATE (float; default 0.0)]{#PRIMER_WT_MASK_FAILURE_RATE}

Penalty weight for the primer failure rate.

### [PRIMER_MASK_5P_DIRECTION (int; default 1)]{#PRIMER_MASK_5P_DIRECTION}

The number of nucleotides masking algorithm should mask from 5\'
direction.

### [PRIMER_MASK_3P_DIRECTION (int; default 0)]{#PRIMER_MASK_3P_DIRECTION}

The number of nucleotides masking algorithm should mask from 3\'
direction.

### [PRIMER_MASK_KMERLIST_PATH (string; default ../kmer_lists/)]{#PRIMER_MASK_KMERLIST_PATH}

This tag specifies the path to the directory that contains k-mer list
files for masking algorithm. Required for command-line execution. On web
interface the species is selected from drop-down menu

### [PRIMER_MASK_KMERLIST_PREFIX (string; default homo_sapiens)]{#PRIMER_MASK_KMERLIST_PREFIX}

This tag specifies the species whose k-mer lists are used for
pre-masking.

### [PRIMER_MIN_QUALITY (int; default 0)]{#PRIMER_MIN_QUALITY}

The minimum sequence quality (as specified by
[SEQUENCE_QUALITY](#SEQUENCE_QUALITY)) allowed within a primer.

### [PRIMER_INTERNAL_MIN_QUALITY (int; default 0)]{#PRIMER_INTERNAL_MIN_QUALITY}

Equivalent parameter of [PRIMER_MIN_QUALITY](#PRIMER_MIN_QUALITY) for
the internal oligo.

### [PRIMER_MIN_END_QUALITY (int; default 0)]{#PRIMER_MIN_END_QUALITY}

The minimum sequence quality (as specified by
[SEQUENCE_QUALITY](#SEQUENCE_QUALITY)) allowed within the 5\' pentamer
of a primer. Note that there is no PRIMER_INTERNAL_MIN_END_QUALITY.

### [PRIMER_QUALITY_RANGE_MIN (int; default 0)]{#PRIMER_QUALITY_RANGE_MIN}

The minimum legal sequence quality (used for error checking of
[PRIMER_MIN_QUALITY](#PRIMER_MIN_QUALITY) and
[PRIMER_MIN_END_QUALITY](#PRIMER_MIN_END_QUALITY)).

### [PRIMER_QUALITY_RANGE_MAX (int; default 100)]{#PRIMER_QUALITY_RANGE_MAX}

The maximum legal sequence quality (used for error checking of
[PRIMER_MIN_QUALITY](#PRIMER_MIN_QUALITY) and
[PRIMER_MIN_END_QUALITY](#PRIMER_MIN_END_QUALITY)).

### [PRIMER_WT_SEQ_QUAL (float; default 0.0)]{#PRIMER_WT_SEQ_QUAL}

Penalty weight for the sequence quality of the primer.

### [PRIMER_INTERNAL_WT_SEQ_QUAL (float; default 0.0)]{#PRIMER_INTERNAL_WT_SEQ_QUAL}

Equivalent parameter of [PRIMER_WT_SEQ_QUAL](#PRIMER_WT_SEQ_QUAL) for
the internal oligo.

### [PRIMER_PAIR_WT_PR_PENALTY (float; default 1.0)]{#PRIMER_PAIR_WT_PR_PENALTY}

Penalty factor for the sum of the left and the right primer added to the
pair penalty. Setting this value below 1.0 will increase running time.\
\
As [PRIMER_PAIR_WT_PR_PENALTY](#PRIMER_PAIR_WT_PR_PENALTY) or the
per-primer penalties it multiplies become lower with respect to various
pair penalties (for example
[PRIMER_PAIR_WT_PRODUCT_SIZE_LT](#PRIMER_PAIR_WT_PRODUCT_SIZE_LT)
[PRIMER_PAIR_WT_PRODUCT_SIZE_GT](#PRIMER_PAIR_WT_PRODUCT_SIZE_GT)
[PRIMER_PAIR_WT_DIFF_TM](#PRIMER_PAIR_WT_DIFF_TM), etc.) the running
time of the search for primer pairs is likely to grow substantially. The
reason is that the search algorithm must calculate the penalty for more
primer pairs (as opposed to excluding them based on the penalties of the
individual oligos).

### [PRIMER_PAIR_WT_IO_PENALTY (float; default 0.0)]{#PRIMER_PAIR_WT_IO_PENALTY}

Penalty factor for the internal oligo added to the pair penalty.

### [PRIMER_INSIDE_PENALTY (float; default -1.0)]{#PRIMER_INSIDE_PENALTY}

Non-default values are valid only for sequences with 0 or 1 target
regions. If the primer is part of a pair that spans a target and
overlaps the target, then multiply this value times the number of
nucleotide positions by which the primer overlaps the (unique) target to
get the \'position penalty\'. The effect of this parameter is to allow
Primer3 to include overlap with the target as a term in the objective
function.

### [PRIMER_OUTSIDE_PENALTY (float; default 0.0)]{#PRIMER_OUTSIDE_PENALTY}

Non-default values are valid only for sequences with 0 or 1 target
regions. If the primer is part of a pair that spans a target and does
not overlap the target, then multiply this value times the number of
nucleotide positions from the 3\' end to the (unique) target to get the
\'position penalty\'. The effect of this parameter is to allow Primer3
to include nearness to the target as a term in the objective function.

### [PRIMER_WT_POS_PENALTY (float; default 1.0)]{#PRIMER_WT_POS_PENALTY}

Penalty for the primer which do not overlap the target.

### [PRIMER_SEQUENCING_LEAD (int; default 50)]{#PRIMER_SEQUENCING_LEAD}

Defines the space from the 3\'end of the primer to the point were the
trace signals are readable. Value only used if
[PRIMER_TASK](#PRIMER_TASK)=pick_sequencing_primers.

### [PRIMER_SEQUENCING_SPACING (int; default 500)]{#PRIMER_SEQUENCING_SPACING}

Defines the space from the 3\'end of the primer to the 3\'end of the
next primer on the same strand. Value only used if
[PRIMER_TASK](#PRIMER_TASK)=pick_sequencing_primers.

### [PRIMER_SEQUENCING_INTERVAL (int; default 250)]{#PRIMER_SEQUENCING_INTERVAL}

Defines the space from the 3\'end of the primer to the 3\'end of the
next primer on the reverse strand. Value only used if
[PRIMER_TASK](#PRIMER_TASK)=pick_sequencing_primers.

### [PRIMER_SEQUENCING_ACCURACY (int; default 20)]{#PRIMER_SEQUENCING_ACCURACY}

Defines the space from the calculated position of the 3\'end to both
sides in which Primer3Plus picks the best primer. Value only used if
[PRIMER_TASK](#PRIMER_TASK)=pick_sequencing_primers.

### [PRIMER_WT_END_QUAL (float; default 0.0)]{#PRIMER_WT_END_QUAL}

### [PRIMER_INTERNAL_WT_END_QUAL (float; default 0.0)]{#PRIMER_INTERNAL_WT_END_QUAL}

## [18. \"PROGRAM\" INPUT TAGS]{#programTags}

\"Program\" input tags start with P3\_\... describe the parameters that
deal with the behavior of the Primer3 program itself.)

### [P3_FILE_ID (string; default empty)]{#P3_FILE_ID}

This tag is only valid in Primer3 setting files. It should be used to
identify the purpose of the settings files it appears in. It is always
printed out on the output of Primer3. See also also the command line
flag -echo_settings_file, which causes the entire settings file to be
echoed in primer3_core\'s output.

### [P3_FILE_TYPE (string; default sequence)]{#P3_FILE_TYPE}

This tag is only valid in the header of Primer3 setting files. It should
be used in the second line to identify the type files it appears in.
Valid options are sequence, settings or all. In Primer3Plus it can
control which parameters are loaded.

### [P3_FILE_FLAG (boolean; default 0)]{#P3_FILE_FLAG}

If the associated value = 1 (non-0), then Primer3 creates one or more
output files for each input [SEQUENCE_TEMPLATE](#SEQUENCE_TEMPLATE).
File \<sequence_id\>.for lists all acceptable left primers for
\<sequence_id\>, and \<sequence_id\>.rev lists all acceptable right
primers for \<sequence_id\>, where \<sequence_id\> is the value of the
[SEQUENCE_ID](#SEQUENCE_ID) tag (which must be supplied). If internal
oligos are requested, Primer3 produces a file \<sequence_id\>.int, which
lists all acceptable internal oligos. Obviously, \<sequence_id\> needs
to be a string that will work as a file name.\
\
See also the `pick_primer_list` argument to [PRIMER_TASK](#PRIMER_TASK),
which offers similar functionality on stdout.

### [P3_COMMENT (string; default empty)]{#P3_COMMENT}

The value of this tag is ignored. It can be used to annotate input.

## [19. HOW PRIMER3 CALCULATES THE PENALTY VALUE]{#calculatePenalties}

In essense, the penalty values define what is the best primer pair. The
calculation of penalty values takes into consideration penalty weights,
which allow one to fine-tune the selection of primers to specific
needs.\
\
This section will explain the selection process of primers by Primer3.
In general the selection is a multi step process:\
\
In the first step, Primer3 evaluates every primer that can be picked in
the region of interest, possibly subject to constraints due to target
regions, product size ranges, and so forth, that might preclude the use
of primers in the eventually selected primer pairs. In this pass the
hard limits are tested like [PRIMER_MAX_GC](#PRIMER_MAX_GC) or
[PRIMER_MIN_TM](#PRIMER_MIN_TM). Primers with a GC lower than
[PRIMER_MAX_GC](#PRIMER_MAX_GC) or a Tm higher than
[PRIMER_MIN_TM](#PRIMER_MIN_TM) are memorized, the primers which fail in
one of these tests are excluded. Primer3 can be forced to use primers
failing to pass this test by setting
[PRIMER_PICK_ANYWAY](#PRIMER_PICK_ANYWAY) to one (only available for
primers provided by the user).\
\
In the second step, Primer3 calculates a penalty for each primer. This
penalty is the only score by which Primer3 evaluates the primers It is
also provided as output [PRIMER_LEFT_4_PENALTY](#PRIMER_LEFT_4_PENALTY),
[PRIMER_INTERNAL_4_PENALTY](#PRIMER_INTERNAL_4_PENALTY) and
[PRIMER_RIGHT_4_PENALTY](#PRIMER_RIGHT_4_PENALTY) (shown for the primer
set 4). For each primer, it is calculated like that:

### Left Primers:

    PRIMER_LEFT_4_PENALTY =
       If PRIMER_LEFT_4_TM > PRIMER_OPT_TM then this is added (+):
           + PRIMER_WT_TM_GT * ( PRIMER_LEFT_4_TM - PRIMER_OPT_TM )
       If PRIMER_LEFT_4_TM < PRIMER_OPT_TM then this is added (+):
           + PRIMER_WT_TM_LT * ( PRIMER_OPT_TM - PRIMER_LEFT_4_TM )
       If PRIMER_LEFT_4_BOUND > PRIMER_OPT_BOUND then this is added (+):
           + PRIMER_WT_BOUND_GT * ( PRIMER_LEFT_4_BOUND - PRIMER_OPT_BOUND )
       If PRIMER_LEFT_4_BOUND < PRIMER_OPT_BOUND then this is added (+):
           + PRIMER_WT_BOUND_LT * ( PRIMER_OPT_BOUND - PRIMER_LEFT_4_BOUND )
       If PRIMER_LEFT_4_GC_PERCENT > PRIMER_OPT_GC_PERCENT then
           this is added (+):
           + PRIMER_WT_GC_PERCENT_GT *
                ( PRIMER_LEFT_4_GC_PERCENT - PRIMER_OPT_GC_PERCENT )
       If PRIMER_LEFT_4_GC_PERCENT < PRIMER_OPT_GC_PERCENT then
           this is added (+):
           + PRIMER_WT_GC_PERCENT_LT *
                ( PRIMER_OPT_GC_PERCENT - PRIMER_LEFT_4_GC_PERCENT )
       If masking is used (PRIMER_MASK_TEMPLATE=1), then this is added (+):
           + PRIMER_WT_MASK_FAILURE_RATE * PRIMER_LEFT_4_MASK_FAILURE_RATE
       The following section uses <primer length> as part of
       the term which is given as output in
       PRIMER_LEFT_4=position,<primer length>
       If <primer length> > PRIMER_OPT_SIZE then
           this is added (+):
           + PRIMER_WT_SIZE_GT *
                ( <primer length> - PRIMER_OPT_SIZE )
       If <primer length> < PRIMER_OPT_SIZE then
           this is added (+):
           + PRIMER_WT_SIZE_LT *
                ( PRIMER_OPT_SIZE - <primer length> )
       If the primer does not overlap a target then
           this is added (+):
           + PRIMER_WT_POS_PENALTY * PRIMER_LEFT_4_POSITION_PENALTY
       These are allways added (+) to the penalty
       (if the thermodynamic approach is used then the part in italic
          is substituted with text below this calculation):
        + PRIMER_WT_SELF_ANY * PRIMER_LEFT_4_SELF_ANY
           + PRIMER_WT_SELF_END * PRIMER_LEFT_4_SELF_END
           + PRIMER_WT_TEMPLATE_MISPRIMING *
                PRIMER_LEFT_4_TEMPLATE_MISPRIMING
           + PRIMER_WT_END_STABILITY * PRIMER_LEFT_4_END_STABILITY
           + PRIMER_WT_NUM_NS * <numbers of N in the selected primer>
           + PRIMER_WT_LIBRARY_MISPRIMING * PRIMER_LEFT_4_LIBRARY_MISPRIMING
           + PRIMER_WT_SEQ_QUAL *
                ( PRIMER_QUALITY_RANGE_MAX -
                  PRIMER_LEFT_4_MIN_SEQ_QUALITY )
          If the thermodynamic approach is used then the part of italic in
              the above calculation is replaced by this:
     
         If ((PRIMER_LEFT_4_TM - 5) ≤ PRIMER_LEFT_4_SELF_ANY_TH) then is added (+):
          + PRIMER_WT_SELF_ANY_TH *
                      (PRIMER_LEFT_4_SELF_ANY_TH - (PRIMER_LEFT_4_TM - 5 - 1))
        else if ((PRIMER_LEFT_4_TM - 5) > PRIMER_LEFT_4_SELF_ANY_TH) then is added (+):
          + PRIMER_WT_SELF_ANY_TH *
                (1/(PRIMER_LEFT_4_TM - 5 + 1 - PRIMER_LEFT_4_SELF_ANY_TH));
        If ((PRIMER_LEFT_4_TM - 5) ≤ PRIMER_LEFT_4_SELF_END_TH) then is added (+):
         + PRIMER_WT_SELF_END_TH *
                   (PRIMER_LEFT_4_SELF_END_TH - (PRIMER_LEFT_4_TM - 5 - 1))
        else if ((PRIMER_LEFT_4_TM - 5) > PRIMER_LEFT_4_SELF_END_TH) then is added (+):
         + PRIMER_WT_SELF_END_TH *
           (1/(PRIMER_LEFT_4_TM - 5 + 1 - PRIMER_LEFT_4_SELF_ANY_TH));
        If ((PRIMER_LEFT_4_TM - 5) ≤ PRIMER_LEFT_4_TEMPLATE_MISPRIMING_TH) then is added (+):
         + PRIMER_WT_TEMPLATE_MISPRIMING_TH *
           (PRIMER_LEFT_4_TEMPLATE_MISPRIMING_TH - (PRIMER_LEFT_4_TM - 5 - 1))
        else if ((PRIMER_LEFT_4_TM - 5) > PRIMER_LEFT_4_TEMPLATE_MISPRIMING_TH) then is added (+):
         + PRIMER_WT_TEMPLATE_MISPRIMING_TH *
          (1/(PRIMER_LEFT_4_TM - 5 + 1 - PRIMER_LEFT_4_TEMPLATE_MISPRIMING_TH));
        If ((PRIMER_LEFT_4_TM - 5) ≤ PRIMER_LEFT_4_HAIRPIN_TH) then is added (+):
          + PRIMER_WT_HAIRPIN_TH *
                 (PRIMER_LEFT_4_HAIRPIN_TH - (PRIMER_LEFT_4_TM - 5 - 1))
        else if ((PRIMER_LEFT_4_TM - 5) > PRIMER_LEFT_4_HAIRPIN_TH) then is added (+):
          + PRIMER_WT_HAIRPIN_TH *
                (1/(PRIMER_LEFT_4_TM - 5 + 1 - PRIMER_LEFT_4_HAIRPIN_TH));
     

### Right Primers (identical to Left Primers):

    PRIMER_RIGHT_4_PENALTY =
       If PRIMER_RIGHT_4_TM > PRIMER_OPT_TM then
           this is added (+):
           + PRIMER_WT_TM_GT * ( PRIMER_RIGHT_4_TM - PRIMER_OPT_TM )
       If PRIMER_RIGHT_4_TM < PRIMER_OPT_TM then
           this is added (+):
           + PRIMER_WT_TM_LT * ( PRIMER_OPT_TM - PRIMER_RIGHT_4_TM )
       If PRIMER_RIGHT_4_GC_PERCENT > PRIMER_OPT_GC_PERCENT then
           this is added (+):
           + PRIMER_WT_GC_PERCENT_GT *
                ( PRIMER_RIGHT_4_GC_PERCENT - PRIMER_OPT_GC_PERCENT )
       If PRIMER_RIGHT_4_GC_PERCENT < PRIMER_OPT_GC_PERCENT then
           this is added (+):
           + PRIMER_WT_GC_PERCENT_LT *
                ( PRIMER_OPT_GC_PERCENT - PRIMER_RIGHT_4_GC_PERCENT )
       If masking is used (PRIMER_MASK_TEMPLATE=1), then this is added (+):
           + PRIMER_WT_MASK_FAILURE_RATE * PRIMER_RIGHT_4_MASK_FAILURE_RATE
       The following section uses <primer length> as part of
       the term which is given as output in
       PRIMER_RIGHT_4=position,<primer length>
       If <primer length> > PRIMER_OPT_SIZE then
           this is added (+):
           + PRIMER_WT_SIZE_GT *
                ( <primer length> - PRIMER_OPT_SIZE )
       If <primer length> < PRIMER_OPT_SIZE then
           this is added (+):
           + PRIMER_WT_SIZE_LT *
                ( PRIMER_OPT_SIZE - <primer length> )
       If the primer does not overlap a target then
           this is added (+):
           + PRIMER_WT_POS_PENALTY * PRIMER_RIGHT_4_POSITION_PENALTY
       These are allways added (+) to the penalty
       (if the thermodynamic approach is used then the part in italic
          is substituted with text below this calculation):
        + PRIMER_WT_SELF_ANY * PRIMER_RIGHT_4_SELF_ANY
           + PRIMER_WT_SELF_END * PRIMER_RIGHT_4_SELF_END
           + PRIMER_WT_TEMPLATE_MISPRIMING *
                PRIMER_RIGHT_4_TEMPLATE_MISPRIMING
           + PRIMER_WT_END_STABILITY * PRIMER_RIGHT_4_END_STABILITY
           + PRIMER_WT_NUM_NS * <numbers of N in the selected primer>
           + PRIMER_WT_LIBRARY_MISPRIMING * PRIMER_RIGHT_4_LIBRARY_MISPRIMING
           + PRIMER_WT_SEQ_QUAL *
                ( PRIMER_QUALITY_RANGE_MAX -
                  PRIMER_RIGHT_4_MIN_SEQ_QUALITY )
         If the thermodynamic approach is used then the part of italic in
             the above calculation is replaced by this:

        If ((PRIMER_RIGHT_4_TM - 5) ≤ PRIMER_RIGHT_4_SELF_ANY_TH) then is added (+):
          + PRIMER_WT_SELF_ANY_TH *
                      (PRIMER_RIGHT_4_SELF_ANY_TH - (PRIMER_RIGHT_4_TM - 5 - 1))
        else if ((PRIMER_RIGHT_4_TM - 5) > PRIMER_RIGHT_4_SELF_ANY_TH) then is added (+):
          + PRIMER_WT_SELF_ANY_TH *
                (1/(PRIMER_RIGHT_4_TM - 5 + 1 - PRIMER_RIGHT_4_SELF_ANY_TH));
        If ((PRIMER_RIGHT_4_TM - 5) ≤ PRIMER_RIGHT_4_SELF_END_TH) then is added (+):
         + PRIMER_WT_SELF_END_TH *
                   (PRIMER_RIGHT_4_SELF_END_TH - (PRIMER_RIGHT_4_TM - 5 - 1))
        else if ((PRIMER_RIGHT_4_TM - 5) > PRIMER_RIGHT_4_SELF_END_TH) then is added (+):
         + PRIMER_WT_SELF_END_TH *
                   (1/(PRIMER_RIGHT_4_TM - 5 + 1 - PRIMER_RIGHT_4_SELF_ANY_TH));
        If ((PRIMER_RIGHT_4_TM - 5) ≤ PRIMER_RIGHT_4_TEMPLATE_MISPRIMING_TH) then is added (+):
          + PRIMER_WT_TEMPLATE_MISPRIMING_TH *
           (PRIMER_RIGHT_4_TEMPLATE_MISPRIMING_TH - (PRIMER_RIGHT_4_TM - 5 - 1))
        else if ((PRIMER_RIGHT_4_TM - 5) > PRIMER_RIGHT_4_TEMPLATE_MISPRIMING_TH) then is added (+):
          + PRIMER_WT_TEMPLATE_MISPRIMING_TH *
          (1/(PRIMER_RIGHT_4_TM - 5 + 1 - PRIMER_RIGHT_4_TEMPLATE_MISPRIMING_TH));
        If ((PRIMER_RIGHT_4_TM - 5) ≤ PRIMER_RIGHT_4_HAIRPIN_TH) then is added (+):
          + PRIMER_WT_HAIRPIN_TH *
                 (PRIMER_RIGHT_4_HAIRPIN_TH - (PRIMER_RIGHT_4_TM - 5 - 1))
        else if ((PRIMER_RIGHT_4_TM - 5) > PRIMER_RIGHT_4_HAIRPIN_TH) then is added (+):
          + PRIMER_WT_HAIRPIN_TH *
                (1/(PRIMER_RIGHT_4_TM - 5 + 1 - PRIMER_RIGHT_4_HAIRPIN_TH));

### Internal Oligos:

    PRIMER_INTERNAL_4_PENALTY =
       If PRIMER_INTERNAL_4_TM > PRIMER_INTERNAL_OPT_TM then
           this is added (+):
           + PRIMER_INTERNAL_WT_TM_GT *
                ( PRIMER_INTERNAL_4_TM - PRIMER_INTERNAL_OPT_TM )
       If PRIMER_INTERNAL_4_TM < PRIMER_INTERNAL_OPT_TM then
           this is added (+):
           + PRIMER_INTERNAL_WT_TM_LT *
                ( PRIMER_INTERNAL_OPT_TM - PRIMER_INTERNAL_4_TM )
       If PRIMER_INTERNAL_4_BOUND > PRIMER_INTERNAL_OPT_BOUND then
           this is added (+):
           + PRIMER_INTERNAL_WT_BOUND_GT *
                ( PRIMER_INTERNAL_4_BOUND - PRIMER_INTERNAL_OPT_BOUND )
       If PRIMER_INTERNAL_4_BOUND < PRIMER_INTERNAL_OPT_BOUND then
           this is added (+):
           + PRIMER_INTERNAL_WT_BOUND_LT *
                ( PRIMER_INTERNAL_OPT_BOUND - PRIMER_INTERNAL_4_BOUND )
       If PRIMER_INTERNAL_4_GC_PERCENT > PRIMER_INTERNAL_OPT_GC_PERCENT
           then this is added (+):
           + PRIMER_INTERNAL_WT_GC_PERCENT_GT *
                ( PRIMER_INTERNAL_4_GC_PERCENT -
                  PRIMER_INTERNAL_OPT_GC_PERCENT )
       If PRIMER_INTERNAL_4_GC_PERCENT < PRIMER_INTERNAL_OPT_GC_PERCENT
           then this is added (+):
           + PRIMER_INTERNAL_WT_GC_PERCENT_LT *
                ( PRIMER_INTERNAL_OPT_GC_PERCENT -
                  PRIMER_INTERNAL_4_GC_PERCENT )
       The following section uses <primer length> as part of
       the term which is given as output in
       PRIMER_INTERNAL_4=position,<primer length>
       If <primer length> > PRIMER_INTERNAL_OPT_SIZE then
           this is added (+):
           + PRIMER_INTERNAL_WT_SIZE_GT *
                ( <primer length> - PRIMER_INTERNAL_OPT_SIZE )
       If <primer length> < PRIMER_INTERNAL_OPT_SIZE then
           this is added (+):
           + PRIMER_INTERNAL_WT_SIZE_LT *
                ( PRIMER_INTERNAL_OPT_SIZE - <primer length> )
       These are always added (+) to the penalty:
       (if the thermodynamic approach is used then the part in italic
          is substituted with text below this calculation):
      + PRIMER_INTERNAL_WT_SELF_ANY * PRIMER_INTERNAL_4_SELF_ANY
         + PRIMER_INTERNAL_WT_SELF_END * PRIMER_INTERNAL_4_SELF_END
         + PRIMER_INTERNAL_WT_NUM_NS *
              <numbers of N in the selected primer>
         + PRIMER_INTERNAL_WT_LIBRARY_MISHYB *
              PRIMER_INTERNAL_4_LIBRARY_MISHYB
         + PRIMER_INTERNAL_WT_SEQ_QUAL *
              ( PRIMER_QUALITY_RANGE_MAX -
                PRIMER_INTERNAL_4_MIN_SEQ_QUALITY )
       If the thermodynamic approach is used then the part of italic in
       the above calculation is replaced by this:

       If ((PRIMER_INTERNAL_4_TM - 5) ≤ PRIMER_INTERNAL_4_SELF_ANY_TH) then is added (+):
        + PRIMER_INTERNAL_WT_SELF_ANY_TH *
            (PRIMER_INTERNAL_4_SELF_ANY_TH - (PRIMER_INTERNAL_4_TM - 5 - 1))
        else if ((PRIMER_INTERNAL_4_TM - 5) > PRIMER_INTERNAL_4_SELF_ANY_TH) then is added (+):
        + PRIMER_INTERNAL_WT_SELF_ANY_TH *
            (1/(PRIMER_INTERNAL_4_TM - 5 + 1 - PRIMER_INTERNAL_4_SELF_ANY_TH));
        If ((PRIMER_INTERNAL_4_TM - 5) ≤ PRIMER_INTERNAL_4_SELF_END_TH) then is added (+):
         + PRIMER_INTERNAL_WT_SELF_END_TH *
             (PRIMER_INTERNAL_4_SELF_END_TH - (PRIMER_INTERNAL_4_TM - 5 - 1))
        else if ((PRIMER_INTERNAL_4_TM - 5) > PRIMER_INTERNAL_4_SELF_END_TH) then is added (+):
          + PRIMER_INTERNAL_WT_SELF_END_TH *
              (1/(PRIMER_INTERNAL_4_TM - 5 + 1 - PRIMER_INTERNAL_4_SELF_ANY_TH));
        If ((PRIMER_INTERNAL_4_TM - 5) ≤ PRIMER_INTERNAL_4_HAIRPIN_TH) then is added (+):
          + PRIMER_INTERNAL_WT_HAIRPIN_TH *
            (PRIMER_INTERNAL_4_HAIRPIN_TH - (PRIMER_INTERNAL_4_TM - 5 - 1))
        else if ((PRIMER_INTERNAL_4_TM - 5) > PRIMER_INTERNAL_4_HAIRPIN_TH) then is added (+):
          + PRIMER_INTERNAL_WT_HAIRPIN_TH *
            (1/(PRIMER_INTERNAL_4_TM - 5 + 1 - PRIMER_INTERNAL_4_HAIRPIN_TH));

The primers are then sorted by penalty and Primer3 tries to pick the
primers with the lowest penalty. For the [PRIMER_TASK](#PRIMER_TASK)

    pick_primer_list

or

    pick_sequencing_primers

the selection ends at this point. If primer pairs have to be selected, a
[PRIMER_PAIR_4_PENALTY](#PRIMER_PAIR_4_PENALTY) is calculated:

    PRIMER_PAIR_4_PENALTY =
       To the pair penalty are at first the single primer penalties
       added (+):
           + PRIMER_PAIR_WT_PR_PENALTY *
                ( PRIMER_LEFT_4_PENALTY + PRIMER_RIGHT_4_PENALTY )
       If internal oligo is picked then this is added (+):
           + PRIMER_PAIR_WT_IO_PENALTY * PRIMER_INTERNAL_4_PENALTY
       If PRIMER_PAIR_4_PRODUCT_TM > PRIMER_PRODUCT_OPT_TM then
           this is added (+):
           + PRIMER_PAIR_WT_PRODUCT_TM_GT *
                ( PRIMER_PAIR_4_PRODUCT_TM - PRIMER_PRODUCT_OPT_TM )
       If PRIMER_PAIR_4_PRODUCT_TM < PRIMER_PRODUCT_OPT_TM then
           this is added (+):
           + PRIMER_PAIR_WT_PRODUCT_TM_LT *
                ( PRIMER_PRODUCT_OPT_TM - PRIMER_PAIR_4_PRODUCT_TM )
       If PRIMER_PAIR_4_PRODUCT_SIZE > PRIMER_PRODUCT_OPT_SIZE then
           this is added (+):
           + PRIMER_PAIR_WT_PRODUCT_SIZE_GT *
                ( PRIMER_PAIR_4_PRODUCT_SIZE - PRIMER_PRODUCT_OPT_SIZE )
       If PRIMER_PAIR_4_PRODUCT_SIZE < PRIMER_PRODUCT_OPT_SIZE then
           this is added (+):
           + PRIMER_PAIR_WT_PRODUCT_SIZE_LT *
                ( PRIMER_PRODUCT_OPT_SIZE - PRIMER_PAIR_4_PRODUCT_SIZE )
       These are allways added (+) to the penalty:
       (if the thermodynamic approach is used then the part in italic
           is substituted with text below this calculation):
         + PRIMER_PAIR_WT_DIFF_TM *
              <difference in Tm between the left and the right primer>
      + PRIMER_PAIR_WT_COMPL_ANY * PRIMER_PAIR_4_COMPL_ANY
         + PRIMER_PAIR_WT_COMPL_END * PRIMER_PAIR_4_COMPL_END
         + PRIMER_PAIR_WT_LIBRARY_MISPRIMING * PRIMER_PAIR_4_LIBRARY_MISPRIMING
         + PRIMER_PAIR_WT_TEMPLATE_MISPRIMING *
              PRIMER_PAIR_4_TEMPLATE_MISPRIMING
         If the thermodynamic approach is used then the part of italic in
         the above calculation is replaced by this:

       If ((min(PRIMER_LEFT_4_TM,PRIMER_RIGHT_4_TM) - 5) ≤ PRIMER_PAIR_4_COMPL_ANY_TH) then is added (+):
       + PRIMER_PAIR_WT_COMPL_ANY_TH *
           (PRIMER_PAIR_4_COMPL_ANY_TH - (min(PRIMER_LEFT_4_TM,PRIMER_RIGHT_4_TM) - 5 - 1))
      else if ((min(PRIMER_LEFT_4_TM,PRIMER_RIGHT_4_TM) - 5) > PRIMER_PAIR_4_COMPL_ANY_TH) then is added (+):
       + PRIMER_PAIR_WT_COMPL_ANY_TH *
          (1/(min(PRIMER_LEFT_4_TM,PRIMER_RIGHT_4_TM - 5 + 1 - PRIMER_PAIR_4_COMPL_ANY_TH));
       If ((min(PRIMER_LEFT_4_TM,PRIMER_RIGHT_4_TM - 5) ≤ PRIMER_PAIR_4_COMPL_END_TH) then is added (+):
       + PRIMER_PAIR_WT_COMPL_END_TH *
           (PRIMER_PAIR_4_COMPL_END_TH - (min(PRIMER_LEFT_4_TM,PRIMER_RIGHT_4_TM) - 5 - 1))
      else if ((min(PRIMER_LEFT_4_TM,PRIMER_RIGHT_4_TM - 5) > PRIMER_PAIR_4_COMPL_END_TH) then is added (+):
        + PRIMER_PAIR_WT_COMPL_END_TH *
             (1/(min(PRIMER_LEFT_4_TM,PRIMER_RIGHT_4_TM - 5 + 1 - PRIMER_PAIR_4_COMPL_ANY_TH));
      If ((min(PRIMER_LEFT_4_TM,PRIMER_RIGHT_4_TM - 5) ≤ PRIMER_PAIR_4_TEMPLATE_MISPRIMING_TH) then is added (+):
       + PRIMER_PAIR_WT_TEMPLATE_MISPRIMING_TH *
        (PRIMER_PAIR_4_TEMPLATE_MISPRIMING_TH - (min(PRIMER_LEFT_4_TM,PRIMER_RIGHT_4_TM - 5 - 1))
      else if ((min(PRIMER_LEFT_4_TM,PRIMER_RIGHT_4_TM - 5) > PRIMER_PAIR_4_TEMPLATE_MISPRIMING_TH) then is added (+):
       + PRIMER_PAIR_WT_TEMPLATE_MISPRIMING_TH *
         (1/(min(PRIMER_LEFT_4_TM,PRIMER_RIGHT_4_TM - 5 + 1 - PRIMER_PAIR_4_TEMPLATE_MISPRIMING_TH));

Primer3 tries to select pairs with the lowest penalty which still
fulfill all necessary requirements like non-redundancy or product size
limits.

## [20. PRIMER3 SETTINGS FILE FORMAT]{#fileFormat}

Primer3 can read global settings from a text file at program start up.
This allows the user to save and exchange settings tailored to special
applications.\
\
Such a Primer3 settings file is a text file. The first three lines of
the file have to be as described below followed by tags as they would be
provided at standard input:

    Primer3 File - http://primer3.org
    P3_FILE_TYPE=settings
    P3_FILE_ID=Description of the settings
    SEQUENCE_TEMPLATE=ATG...
    ...
    ...
    ...
    =

In the first line \"Primer3 File - http://primer3.org\" without tailing
space. In the second line \"P3_FILE_TYPE=settings\". Valid values for
P3_FILE_TYPE are all_parameters, sequence and settings. Up to now, only
settings is supported. The third line has to be empty. It is strongly
advised to describe the settings using the P3_FILE_ID tag. It will print
the description of the settings on the output. From the fourth line on
regular Boulder-IO can be used as it is used in regular input. It also
has to be terminated with a single \"=\". There can be only one input
per file.

## [21. OUTPUT TAGS]{#outputTags}

For each Boulder-IO record passed into Primer3 via stdin, exactly one
Boulder-IO record comes out of Primer3 on stdout. If a settings file is
provided and the option to echo the settings file is given on the
command line, then the contents of the settings file will also be part
of the output. Two additional tags are used to indicate where the
records of the settings file begin and end: P3_SETTINGS_FILE_USED
specifies the path to the settings file that was provided,
P3_SETTINGS_FILE_END does not have any value and it just indicates the
end of the settings records.\
\
The output records contain everything that the input record contains,
plus a subset of the following tag/value pairs. Unless noted by (\*),
each tag appears for each primer pair returned.\
\
Tags are of the form
PRIMER\_{LEFT,RIGHT,INTERNAL,PAIR}\_\<j\>\_\<tag_name\> where \<j\> is
an integer from 0 to n, where n is at most the value of
[PRIMER_NUM_RETURN](#PRIMER_NUM_RETURN). In the documentation the output
number 4 is shown as for example:
[PRIMER_LEFT_4_TM](#PRIMER_LEFT_4_TM).\
\
In the descriptions below, \'i,n\' represents a start/length pair, \'s\'
represents a string, x represents an arbitrary integer, and f represents
a float.

### [PRIMER_ERROR=s (\*)]{#PRIMER_ERROR}

s describes user-correctable errors detected in the input (separated by
semicolons). This tag is absent if there are no errors.

### [PRIMER_WARNING=s (\*)]{#PRIMER_WARNING}

s lists warnings generated by Primer3\` (separated by semicolons); this
tag is absent if there are no warnings.

### [PRIMER_LEFT_NUM_RETURNED=i]{#PRIMER_LEFT_NUM_RETURNED}

### [PRIMER_RIGHT_NUM_RETURNED=i]{#PRIMER_RIGHT_NUM_RETURNED}

### [PRIMER_INTERNAL_NUM_RETURNED=i]{#PRIMER_INTERNAL_NUM_RETURNED}

### [PRIMER_PAIR_NUM_RETURNED=i]{#PRIMER_PAIR_NUM_RETURNED}

i is the number of primers or primer pairs returned on standard output.
These tags are always generated under IO version 4 if there are no
internal errors and if [PRIMER_ERROR](#PRIMER_ERROR) is not present.\
\
If primer pairs were requested, PRIMER_LEFT_NUM_RETURNED and
PRIMER_RIGHT_NUM_RETURNED will be equal to the number of pairs returned,
even if the actual number of distinct left or right primers was lower
than the number of pairs. If primer pairs with internal oligos were
requested, PRIMER_INTERNAL_NUM_RETURNED will also be set to the number
of pairs returned.\
\
If only left or right primers or hybridization (internal) oligos were
requested, PRIMER_PAIR_NUM_RETURNED will be 0 and only the relevant tag
will have a non-zero value. For example, if only left primers were
requested, PRIMER_RIGHT_NUM_RETURNED, PRIMER_INTERNAL_NUM_RETURNED and
PRIMER_PAIR_NUM_RETURNED will be 0.\
\
Some tasks, such as pick_sequencing_primers or pick_primer_list, return
left and right primers that are not parts of primer pairs. In this case
PRIMER_PAIR_NUM_RETURNED will be 0.

### [PRIMER_LEFT_4_PROBLEMS=s (\*)]{#PRIMER_LEFT_4_PROBLEMS}

### [PRIMER_INTERNAL_4_PROBLEMS=s (\*)]{#PRIMER_INTERNAL_4_PROBLEMS}

### [PRIMER_RIGHT_4_PROBLEMS=s (\*)]{#PRIMER_RIGHT_4_PROBLEMS}

s lists the problems (constraint violations) associated with the
corresponding primer oligo.

### [PRIMER_LEFT_EXPLAIN=s (\*)]{#PRIMER_LEFT_EXPLAIN}

### [PRIMER_INTERNAL_EXPLAIN=s (\*)]{#PRIMER_INTERNAL_EXPLAIN}

### [PRIMER_RIGHT_EXPLAIN=s (\*)]{#PRIMER_RIGHT_EXPLAIN}

s is a (more or less) self-documenting string containing statistics on
the possibilities that Primer3 considered in selecting a single oligo.
For example

    PRIMER_LEFT_EXPLAIN=considered 62, too many Ns 53, ok 9
    PRIMER_RIGHT_EXPLAIN=considered 62, too many Ns 53, ok 9
    PRIMER_INTERNAL_OLIGO_EXPLAIN=considered 87, too many Ns 39, overlap excluded region 40, ok 8

All the categories are exclusive, except the \'considered\' category. In
some cases the ok count may be higher than the actual number of ok
oligos. This is because a primer can be considered as part of pair
before all of the primer\'s characteristics have been computed and
checked. If a primer is never in a legal pair or never in a pair with a
fully evaluated penalty, then this may occur. This situation never
results in a primer pair that contains an illegal primer.

### [PRIMER_PAIR_EXPLAIN=s (\*)]{#PRIMER_PAIR_EXPLAIN}

s is a self-documenting string containing statistics on picking a primer
pair (plus internal oligo if requested). For example

    PRIMER_PAIR_EXPLAIN=considered 81, unacceptable product size 49, no internal oligo 32, ok 0

The purpose of this string is to provide information in the case that
not enough primer pairs are returned. This information can be used, for
example, to decide which constraints to relax. In some cases the
information in this string can also give insight into the causes of long
running time. The counts in the string are only approximate, because of
several reasons:

-   When there are multiple
    [PRIMER_PRODUCT_SIZE_RANGE](#PRIMER_PRODUCT_SIZE_RANGE)s, a primer
    pair may not be ok in one size range but ok in another.
    Approximately, the counts for each statistic are summed over all
    product size ranges.
-   When
    [PRIMER_MIN_THREE_PRIME_DISTANCE](#PRIMER_MIN_THREE_PRIME_DISTANCE)
    is \> -1, the number of ok primer pairs reported may be larger than
    the actual number. The discrepancy is due to a primer in the pair
    that would overlap a primer in a \'better\' (lower penalty) pair.
    (The search algorithm does not record state that would allow it to
    detect when a pair that was formerly ok becomes not ok as the result
    of another primer being inserted into the output list before it is.)
-   In some instances, Primer3 will examine a primer pair before it
    discovers that one of the individual primers in the pair violates
    specified constraints. In this case
    [PRIMER_PAIR_EXPLAIN](#PRIMER_PAIR_EXPLAIN) might have a non-0
    number \'considered\', even though one or more of
    [PRIMER_LEFT_EXPLAIN](#PRIMER_LEFT_EXPLAIN),
    [PRIMER_RIGHT_EXPLAIN](#PRIMER_RIGHT_EXPLAIN), or
    [PRIMER_INTERNAL_EXPLAIN](#PRIMER_INTERNAL_EXPLAIN) has \'ok 0\'.

### [PRIMER_LEFT_4=i,n]{#PRIMER_LEFT_4}

The selected left primer (the primer to the left in the input sequence).
i is the 0-based index of the start base of the primer, and n is t its
length.

### [PRIMER_INTERNAL_4=i,n]{#PRIMER_INTERNAL_4}

The selected internal oligo. Primer3 outputs this tag if
[PRIMER_PICK_INTERNAL_OLIGO](#PRIMER_PICK_INTERNAL_OLIGO) was non-0. If
Primer3 fails to pick a middle oligo upon request, this tag will not be
output. i is the 0-based index of start base of the internal oligo, and
n is its length.

### [PRIMER_RIGHT_4=i,n]{#PRIMER_RIGHT_4}

The selected right primer (the primer to the right in the input
sequence). i is the 0-based index of the last base of the primer, and n
is its length.

### [PRIMER_LEFT_4_SEQUENCE=s]{#PRIMER_LEFT_4_SEQUENCE}

### [PRIMER_INTERNAL_4_SEQUENCE=s]{#PRIMER_INTERNAL_4_SEQUENCE}

### [PRIMER_RIGHT_4_SEQUENCE=s]{#PRIMER_RIGHT_4_SEQUENCE}

The actual sequence of the oligo. The sequence of left primer and
internal oligo is presented 5\' -\> 3\' on the same strand as the input
[SEQUENCE_TEMPLATE](#SEQUENCE_TEMPLATE) (which must be presented 5\' -\>
3\'). The sequence of the right primer is presented 5\' -\> 3\' on the
opposite strand from the input [SEQUENCE_TEMPLATE](#SEQUENCE_TEMPLATE).

### [PRIMER_PAIR_4_PRODUCT_SIZE=x]{#PRIMER_PAIR_4_PRODUCT_SIZE}

x is the product size of the PCR product.

### [PRIMER_LEFT_4_PENALTY=f]{#PRIMER_LEFT_4_PENALTY}

### [PRIMER_INTERNAL_4_PENALTY=f]{#PRIMER_INTERNAL_4_PENALTY}

### [PRIMER_RIGHT_4_PENALTY=f]{#PRIMER_RIGHT_4_PENALTY}

The contribution of this individual primer or oligo to the objective
function.

### [PRIMER_PAIR_4_PENALTY=f]{#PRIMER_PAIR_4_PENALTY}

The value of the objective function for this pair (lower is better).

### [PRIMER_LEFT_4_TM=f]{#PRIMER_LEFT_4_TM}

### [PRIMER_INTERNAL_4_TM=f]{#PRIMER_INTERNAL_4_TM}

### [PRIMER_RIGHT_4_TM=f]{#PRIMER_RIGHT_4_TM}

The melting TM for the selected oligo.

### [PRIMER_LEFT_4_BOUND=f]{#PRIMER_LEFT_4_BOUND}

### [PRIMER_INTERNAL_4_BOUND=f]{#PRIMER_INTERNAL_4_BOUND}

### [PRIMER_RIGHT_4_BOUND=f]{#PRIMER_RIGHT_4_BOUND}

The calculated fraction of primers bound to a template at the
[PRIMER_ANNEALING_TEMP](#PRIMER_ANNEALING_TEMP) in percent if the primer
and template would be at equal concentration. See [\"GENERAL THOUGHTS ON
PRIMER BINDING\"](#primerBinding) for more details.

### [PRIMER_PAIR_4_PRODUCT_TM=f]{#PRIMER_PAIR_4_PRODUCT_TM}

f is the melting temperature of the product. Calculated using equation
(iii) from the paper \[Rychlik W, Spencer WJ and Rhoads RE (1990)
\"Optimization of the annealing temperature for DNA amplification in
vitro\", Nucleic Acids Res 18:6409-12
<http://dx.doi.org/10.1093/nar/18.21.6409>\]. Printed only if a
non-default value of [PRIMER_PRODUCT_MAX_TM](#PRIMER_PRODUCT_MAX_TM) or
[PRIMER_PRODUCT_MIN_TM](#PRIMER_PRODUCT_MIN_TM) is specified.

### [PRIMER_PAIR_4_PRODUCT_TM_OLIGO_TM_DIFF=f]{#PRIMER_PAIR_4_PRODUCT_TM_OLIGO_TM_DIFF}

f is the difference between the melting temperature of the product and
the melting temperature of the less stable primer. Printed only if
[PRIMER_PRODUCT_MAX_TM](#PRIMER_PRODUCT_MAX_TM) or
[PRIMER_PRODUCT_MIN_TM](#PRIMER_PRODUCT_MIN_TM) is specified.

### [PRIMER_PAIR_4_T_OPT_A=f]{#PRIMER_PAIR_4_T_OPT_A}

f is T sub a super OPT from equation (i) in \[Rychlik W, Spencer WJ and
Rhoads RE (1990) \"Optimization of the annealing temperature for DNA
amplification in vitro\", Nucleic Acids Res 18:6409-12.
<http://dx.doi.org/10.1093/nar/18.21.6409>\]. Printed only if
[PRIMER_PRODUCT_MAX_TM](#PRIMER_PRODUCT_MAX_TM) or
[PRIMER_PRODUCT_MIN_TM](#PRIMER_PRODUCT_MIN_TM) is specified.

### [PRIMER_LEFT_4_GC_PERCENT=f]{#PRIMER_LEFT_4_GC_PERCENT}

### [PRIMER_INTERNAL_4_GC_PERCENT=f]{#PRIMER_INTERNAL_4_GC_PERCENT}

### [PRIMER_RIGHT_4_GC_PERCENT=f]{#PRIMER_RIGHT_4_GC_PERCENT}

The percent GC for the selected oligo (denominator is the number of
non-ambiguous bases).

### [PRIMER_LEFT_4_SELF_ANY=f]{#PRIMER_LEFT_4_SELF_ANY}

### [PRIMER_INTERNAL_4_SELF_ANY=f]{#PRIMER_INTERNAL_4_SELF_ANY}

### [PRIMER_RIGHT_4_SELF_ANY=f]{#PRIMER_RIGHT_4_SELF_ANY}

The calculated value for the tendency of a primer to bind to itself
(interfering with target sequence binding). It will score ANY binding
occurring within the entire primer sequence. For details see
[PRIMER_MAX_SELF_ANY](#PRIMER_MAX_SELF_ANY).\
The self-complementarity measures for the selected oligo.

### [PRIMER_LEFT_4_SELF_ANY_TH=f]{#PRIMER_LEFT_4_SELF_ANY_TH}

### [PRIMER_INTERNAL_4_SELF_ANY_TH=f]{#PRIMER_INTERNAL_4_SELF_ANY_TH}

### [PRIMER_RIGHT_4_SELF_ANY_TH=f]{#PRIMER_RIGHT_4_SELF_ANY_TH}

The calculated value for the tendency of a primer to bind to itself
(interfering with target sequence binding). It will calculate the
melting temperature for ANY binding occurring within the entire primer
sequence. For details see
[PRIMER_MAX_SELF_ANY_TH](#PRIMER_MAX_SELF_ANY_TH). The
self-complementarity measures for the selected oligo.

### [PRIMER_LEFT_4_SELF_ANY_STUCT=s]{#PRIMER_LEFT_4_SELF_ANY_STUCT}

### [PRIMER_INTERNAL_4_SELF_ANY_STUCT=s]{#PRIMER_INTERNAL_4_SELF_ANY_STUCT}

### [PRIMER_RIGHT_4_SELF_ANY_STUCT=s]{#PRIMER_RIGHT_4_SELF_ANY_STUCT}

A string representation of the calculated secondary structure. The tag
is only present if a secondary structure could be calculated and
[PRIMER_SECONDARY_STRUCTURE_ALIGNMENT](#PRIMER_SECONDARY_STRUCTURE_ALIGNMENT)=1.\
See
[PRIMER_SECONDARY_STRUCTURE_ALIGNMENT](#PRIMER_SECONDARY_STRUCTURE_ALIGNMENT)
for examples and notes on the necessary reformating of the string.

### [PRIMER_LEFT_4_SELF_END=f]{#PRIMER_LEFT_4_SELF_END}

### [PRIMER_INTERNAL_4_SELF_END=f]{#PRIMER_INTERNAL_4_SELF_END}

### [PRIMER_RIGHT_4_SELF_END=f]{#PRIMER_RIGHT_4_SELF_END}

The calculated value for the tendency of the 3\'-END to bind to a
identical primer. This is critical for primer quality because it allows
primers use itself as a target and amplify a short piece (forming a
primer-dimer). These primer are then unable to bind and amplify the
target sequence. For details see
[PRIMER_MAX_SELF_END](#PRIMER_MAX_SELF_END).\
The self-complementarity measures for the ends of selected oligo.

### [PRIMER_LEFT_4_SELF_END_TH=f]{#PRIMER_LEFT_4_SELF_END_TH}

### [PRIMER_INTERNAL_4_SELF_END_TH=f]{#PRIMER_INTERNAL_4_SELF_END_TH}

### [PRIMER_RIGHT_4_SELF_END_TH=f]{#PRIMER_RIGHT_4_SELF_END_TH}

The calculated value for the tendency of the 3\'-END to bind to a
identical primer. This is critical for primer quality because it allows
primers use itself as a target and amplify a short piece (forming a
primer-dimer). These primer are then unable to bind and amplify the
target sequence. For details see
[PRIMER_MAX_SELF_END_TH](#PRIMER_MAX_SELF_END_TH). The
self-complementarity measures for the ends of selected oligo.

### [PRIMER_LEFT_4_SELF_END_STUCT=s]{#PRIMER_LEFT_4_SELF_END_STUCT}

### [PRIMER_INTERNAL_4_SELF_END_STUCT=s]{#PRIMER_INTERNAL_4_SELF_END_STUCT}

### [PRIMER_RIGHT_4_SELF_END_STUCT=s]{#PRIMER_RIGHT_4_SELF_END_STUCT}

A string representation of the calculated secondary structure. The tag
is only present if a secondary structure could be calculated and
[PRIMER_SECONDARY_STRUCTURE_ALIGNMENT](#PRIMER_SECONDARY_STRUCTURE_ALIGNMENT)=1.\
See
[PRIMER_SECONDARY_STRUCTURE_ALIGNMENT](#PRIMER_SECONDARY_STRUCTURE_ALIGNMENT)
for examples and notes on the necessary reformating of the string.

### [PRIMER_LEFT_4_HAIRPIN_TH=f]{#PRIMER_LEFT_4_HAIRPIN_TH}

### [PRIMER_INTERNAL_4_HAIRPIN_TH=f]{#PRIMER_INTERNAL_4_HAIRPIN_TH}

### [PRIMER_RIGHT_4_HAIRPIN_TH=f]{#PRIMER_RIGHT_4_HAIRPIN_TH}

The calculated value of melting temperature of hairpin structure of
primer. For details see [PRIMER_MAX_HAIRPIN_TH](#PRIMER_MAX_HAIRPIN_TH)

### [PRIMER_LEFT_4_HAIRPIN_STUCT=s]{#PRIMER_LEFT_4_HAIRPIN_STUCT}

### [PRIMER_INTERNAL_4_HAIRPIN_STUCT=s]{#PRIMER_INTERNAL_4_HAIRPIN_STUCT}

### [PRIMER_RIGHT_4_HAIRPIN_STUCT=s]{#PRIMER_RIGHT_4_HAIRPIN_STUCT}

A string representation of the calculated secondary structure. The tag
is only present if a secondary structure could be calculated and
[PRIMER_SECONDARY_STRUCTURE_ALIGNMENT](#PRIMER_SECONDARY_STRUCTURE_ALIGNMENT)=1.\
See
[PRIMER_SECONDARY_STRUCTURE_ALIGNMENT](#PRIMER_SECONDARY_STRUCTURE_ALIGNMENT)
for examples and notes on the necessary reformating of the string.

### [PRIMER_PAIR_4_COMPL_ANY=f]{#PRIMER_PAIR_4_COMPL_ANY}

The calculated value for the tendency of a primer pair to bind to each
other (interfering with target sequence binding). It will score ANY
binding occurring within the entire primer sequence. For details see
[PRIMER_MAX_SELF_ANY](#PRIMER_MAX_SELF_ANY).\
The inter-pair complementarity measures over the complete primer for
selected left and right primer.

### [PRIMER_PAIR_4_COMPL_ANY_TH=f]{#PRIMER_PAIR_4_COMPL_ANY_TH}

The calculated value for the tendency of a primer pair to bind to each
other (interfering with target sequence binding). It will calculate the
melting temperature of ANY binding occurring within the entire primer
sequence. For details see
[PRIMER_MAX_SELF_ANY_TH](#PRIMER_MAX_SELF_ANY_TH). The inter-pair
complementarity measures over the complete primer for selected left and
right primer.

### [PRIMER_PAIR_4_COMPL_ANY_STUCT=s]{#PRIMER_PAIR_4_COMPL_ANY_STUCT}

A string representation of the calculated secondary structure. The tag
is only present if a secondary structure could be calculated and
[PRIMER_SECONDARY_STRUCTURE_ALIGNMENT](#PRIMER_SECONDARY_STRUCTURE_ALIGNMENT)=1.\
See
[PRIMER_SECONDARY_STRUCTURE_ALIGNMENT](#PRIMER_SECONDARY_STRUCTURE_ALIGNMENT)
for examples and notes on the necessary reformating of the string.

### [PRIMER_PAIR_4_COMPL_END=f]{#PRIMER_PAIR_4_COMPL_END}

The calculated value for the tendency of the 3\'-ENDs of a primer pair
to bind to each other. This is critical for primer quality because it
allows primers use itself as a target and amplify a short piece (forming
a primer-dimer). These primer are then unable to bind and amplify the
target sequence. For details see
[PRIMER_MAX_SELF_END](#PRIMER_MAX_SELF_END).\
The inter-pair complementarity measures for the ends of selected left
and right primer.

### [PRIMER_PAIR_4_COMPL_END_TH=f]{#PRIMER_PAIR_4_COMPL_END_TH}

The calculated value for the tendency of the 3\'-ENDs of a primer pair
to bind to each other. This is critical for primer quality because it
allows primers use itself as a target and amplify a short piece (forming
a primer-dimer). These primer are then unable to bind and amplify the
target sequence. For details see
[PRIMER_MAX_SELF_END_TH](#PRIMER_MAX_SELF_END_TH). The inter-pair
complementarity measures for the ends of selected left and right primer.

### [PRIMER_PAIR_4_COMPL_END_STUCT=s]{#PRIMER_PAIR_4_COMPL_END_STUCT}

A string representation of the calculated secondary structure. The tag
is only present if a secondary structure could be calculated and
[PRIMER_SECONDARY_STRUCTURE_ALIGNMENT](#PRIMER_SECONDARY_STRUCTURE_ALIGNMENT)=1.\
See
[PRIMER_SECONDARY_STRUCTURE_ALIGNMENT](#PRIMER_SECONDARY_STRUCTURE_ALIGNMENT)
for examples and notes on the necessary reformating of the string.

### [PRIMER_LEFT_4_END_STABILITY=f]{#PRIMER_LEFT_4_END_STABILITY}

### [PRIMER_RIGHT_4_END_STABILITY=f]{#PRIMER_RIGHT_4_END_STABILITY}

f is the delta G of disruption of the five 3\' bases of the primer.

### [PRIMER_LEFT_4_TEMPLATE_MISPRIMING=f]{#PRIMER_LEFT_4_TEMPLATE_MISPRIMING}

### [PRIMER_RIGHT_4_TEMPLATE_MISPRIMING=f]{#PRIMER_RIGHT_4_TEMPLATE_MISPRIMING}

### [PRIMER_PAIR_4_TEMPLATE_MISPRIMING=f]{#PRIMER_PAIR_4_TEMPLATE_MISPRIMING}

Analogous to PRIMER\_{LEFT,RIGHT,PAIR}\_LIBRARY_MISPRIMING, except that
these output tags apply to mispriming within the template sequence. This
often arises, for example, in genes with repeated exons. For backward
compatibility, these tags only appear if the corresponding input tags
have defined values.

### [PRIMER_LEFT_4_TEMPLATE_MISPRIMING_TH=f]{#PRIMER_LEFT_4_TEMPLATE_MISPRIMING_TH}

### [PRIMER_RIGHT_4_TEMPLATE_MISPRIMING_TH=f]{#PRIMER_RIGHT_4_TEMPLATE_MISPRIMING_TH}

### [PRIMER_PAIR_4_TEMPLATE_MISPRIMING_TH=f]{#PRIMER_PAIR_4_TEMPLATE_MISPRIMING_TH}

These output tags apply to mispriming within the template sequence and
the calculation method is based on thermodynamical approach. This often
arises, for example, in genes with repeated exons.

### [PRIMER_LEFT_4_LIBRARY_MISPRIMING=f, s]{#PRIMER_LEFT_4_LIBRARY_MISPRIMING}

### [PRIMER_RIGHT_4_LIBRARY_MISPRIMING=f, s]{#PRIMER_RIGHT_4_LIBRARY_MISPRIMING}

### [PRIMER_PAIR_4_LIBRARY_MISPRIMING=f, s]{#PRIMER_PAIR_4_LIBRARY_MISPRIMING}

f is the maximum mispriming score for the right primer against any
sequence in the given
[PRIMER_MISPRIMING_LIBRARY](#PRIMER_MISPRIMING_LIBRARY); s is the id of
corresponding library sequence.
[PRIMER_PAIR_MAX_LIBRARY_MISPRIMING](#PRIMER_PAIR_MAX_LIBRARY_MISPRIMING)
is the maximum sum of mispriming scores in any single library sequence
(perhaps a more reasonable estimator of the likelihood of mispriming).

### [PRIMER_INTERNAL_4_LIBRARY_MISHYB=f, s]{#PRIMER_INTERNAL_4_LIBRARY_MISHYB}

f is the maximum mishybridization score for the right primer against any
sequence in the given
[PRIMER_INTERNAL_MISHYB_LIBRARY](#PRIMER_INTERNAL_MISHYB_LIBRARY); s is
the id of corresponding library sequence.

### [PRIMER_LEFT_4_MIN_SEQ_QUALITY=i]{#PRIMER_LEFT_4_MIN_SEQ_QUALITY}

### [PRIMER_INTERNAL_4_MIN_SEQ_QUALITY=i]{#PRIMER_INTERNAL_4_MIN_SEQ_QUALITY}

### [PRIMER_RIGHT_4_MIN_SEQ_QUALITY=i]{#PRIMER_RIGHT_4_MIN_SEQ_QUALITY}

i is the minimum \_sequence\_ quality within the primer or oligo (not to
be confused with the [PRIMER_PAIR_4_PENALTY](#PRIMER_PAIR_4_PENALTY)
output tag, which is really the value of the objective function.)

### [PRIMER_STOP_CODON_POSITION=i]{#PRIMER_STOP_CODON_POSITION}

i is the position of the first base of the stop codon, if Primer3 found
one, or -1 if Primer3 did not. Printed only if the input tag
[SEQUENCE_START_CODON_POSITION](#SEQUENCE_START_CODON_POSITION) with a
non-default value is supplied.

### [PRIMER_LEFT_4_POSITION_PENALTY=i]{#PRIMER_LEFT_4_POSITION_PENALTY}

### [PRIMER_RIGHT_4_POSITION_PENALTY=i]{#PRIMER_RIGHT_4_POSITION_PENALTY}

i is the penalty of the primer by its position.

## [22. EXAMPLE OUTPUT]{#exampleOutput}

You should run it yourself. Use the file \'example\' that came with this
distribution directory as input.

## [23. ADVICE FOR PICKING PRIMERS]{#pickAdvice}

We suggest consulting: Wojciech Rychlik (1993) \"Selection of Primers
for Polymerase Chain Reaction\" in BA White, Ed., \"Methods in Molecular
Biology, Vol. 15: PCR Protocols: Current Methods and Applications\", pp
31-40, Humana Press, Totowa NJ.

## [24. GENERAL THOUGHTS ON PRIMER BINDING]{#primerBinding}

The binding of primers to a template DNA is depending on the primer
sequence and the concentration of primer and template DNA, monovalent,
divalent ions and dNTPs. Also other components like DMSO or contaminants
influence the binding of primers. In primer design, the melting
temperature is a critical factor and is calculated using thermodynamic
equations (see [PRIMER_TM_FORMULA](#PRIMER_TM_FORMULA) for more
information). The melting temperature is defined as the temperature
where half of the primers are bound to target and it can be measured by
heating up a double stranded DNA while monitoring the UV absorbance. In
this situation, the double stranded DNA \[AB\] melts into two single
strands (\[A\] and \[B\]) of equal concentration. The situation at the
start of a PCR reaction is quite different. Usually the concentration of
primer \[A\] in a typical PCR reaction (see
[PRIMER_DNA_CONC](#PRIMER_DNA_CONC)) is with 0.5 micromolar high, the
concentration of template DNA \[B\] with 10 nanograms low. The actual
micromolar concentration of the primer binding sites which would be
required for the thermodynamic calculations depends on the type of DNA
and will be very different in genomic DNA (few binding sites per
nanogram) or plasmid and cDNA (many binding sites per nanogram). As the
concentration of \[AB\], \[A\] and \[B\] changes dramatically during a
PCR run (this is the aim of the PCR reaction), so does the melting
temperature. For the thermodynamic calculations in Primer3 we use
[PRIMER_DNA_CONC](#PRIMER_DNA_CONC) as an \"empirically determined\"
concentration of annealing oligo over the course the PCR (see
[PRIMER_DNA_CONC](#PRIMER_DNA_CONC) for details), which is less than the
actual concentration of oligos in the initial reaction mix because of
its dependence on the amount of template (including PCR product) in a
given cycle. The melting temperature is calculated based on:

    Tm = deltaH / ( deltaS + R * ln ( [PRIMER_DNA_CONC] / 4 ) )

Primers are rarely used at melting temperature. Usually, the annealing
temperature in a PCR reaction is usually chosen 6-10°C below the melting
temperature of the primers and can be indicated to Primer3 with the
[PRIMER_ANNEALING_TEMP](#PRIMER_ANNEALING_TEMP) parameter. The idea
behind this reduction in temperature is to increase the fraction of
primers bound to target. While at the melting temperature 50% of the
primers are bound to target, at the reduced annealing temperature 95-98%
should be bound. The fraction of bound primers depends on dH and dS and
can be calculated based on (see
[PRIMER_LEFT_4_BOUND](#PRIMER_LEFT_4_BOUND) for details):

    dG = dH - T * dS
    K = e^[-dG / ( R * T )]
    K = e^[( dS / R ) - ( dH / ( R * T ) ) ]
    fract = ( 1 / ( 1 + sqrt( 1 / ( ( PRIMER_DNA_CONC / 4000000000.0 ) * K)))) * 100

Unfortunately, the effect of dH on the fraction of bound primers is
depending on the temperature, while the effect of dS is not. Therefore,
primers which do have the same melting temperature and bind to 50% at
melting temperature, may differ in binding at annealing temperature. Or
on the other hand, primers which are dG matched to have identical
binding at annealing temperature may differ in melting temperature. This
dates back to the third myth described by SantaLucia on page 18 in
\[SantaLucia (2007) Physical principles and visual-OMP software for
optimal PCR design. Methods Mol Biol. 2007;402:3-34. doi:
10.1007/978-1-59745-528-2_1.\] SantaLucia argues, that primers should
not be matched on melting temperature ([PRIMER_OPT_TM](#PRIMER_OPT_TM))
but on the fraction of primers bound at annealing temperature
([PRIMER_OPT_BOUND](#PRIMER_OPT_BOUND)). Especially multiplex primers
should profit from thermodynamic parameters where the individual primers
match better to each other.\
\
It may come as a surprise that the calculated melting temperature and
bound fractions do not reflect the actual situation in the final PCR
reaction and you could wonder if this parameters are at all useful.
Although this parameters are representations of the primers
thermodynamic properties under ideal conditions, they are useful to
select primers with matching thermodynamic properties that perform well
together in a PCR reaction. The melting temperature and the fraction of
primer bound at annealing temperature are intuitive parameters that are
easier to evaluate than the dG, dH and dS values they are based on.\
\
In Primer3 dG matching can be archived by setting a group of parameters
as described below. Please consider this feature experimental. Primer
selection based on melting temperature proved successful over the last
decades. The selection based on deltaG by setting a bound fraction at
melting temperature as target value is new and the optimal parameters
still have to be found. As a start the fraction of bound primers may be
calculated with no big impact on primer selection by solely providing an
annealing temperature ([PRIMER_ANNEALING_TEMP](#PRIMER_ANNEALING_TEMP)).
For true dG matching the selection on melting temperature has to be
switched off.

    # Activate statistics
    PRIMER_EXPLAIN_FLAG=1
    # Activate the SantaLucia Tm calculation and salt correction
    PRIMER_TM_FORMULA=1
    PRIMER_SALT_CORRECTIONS=1
    # Provide the annealing temperature
    PRIMER_ANNEALING_TEMP=50.0
    # Set the fraction of bound primers
    PRIMER_MIN_BOUND=96.5
    PRIMER_OPT_BOUND=97.0
    PRIMER_MAX_BOUND=97.5
    PRIMER_INTERNAL_MIN_BOUND=96.5
    PRIMER_INTERNAL_OPT_BOUND=97.0
    PRIMER_INTERNAL_MAX_BOUND=97.5
    # Activate selection by penalty values
    PRIMER_WT_BOUND_LT=1.0
    PRIMER_WT_BOUND_GT=1.0
    PRIMER_INTERNAL_WT_BOUND_LT=1.0
    PRIMER_INTERNAL_WT_BOUND_GT=1.0
    # Do not exclude primers based on Tm
    PRIMER_MAX_TM=80.0
    PRIMER_MIN_TM=40.0
    PRIMER_INTERNAL_MAX_TM=80.0
    PRIMER_INTERNAL_MIN_TM=40.0
    # Inactivate selection by penalty values
    PRIMER_WT_TM_LT=0.0
    PRIMER_WT_TM_GT=0.0
    PRIMER_INTERNAL_WT_TM_LT=0.0
    PRIMER_INTERNAL_WT_TM_GT=0.0

The fraction of primers bound to a template at the
[PRIMER_ANNEALING_TEMP](#PRIMER_ANNEALING_TEMP) can be calculated for
the situation where the primer and template would be at equal
concentration.\
\
The thermodynamic parameter dG of the primer are used to calculate the
equilibrium constant:

       R = 1.9872
       T = (PRIMER_ANNEALING_TEMP) + 273.15
       dG = dH - T * dS
       K = e^[-dG / ( R * T )]
       K = e^[( dS / R ) - ( dH / ( R * T ) ) ]

The equilibrium constant for the reaction is based on the concentration
of primer \[A\], template\[B\] and primer bound to template \[AB\]:

       A + B <==> AB
       K = c[AB] / ( c[A] * c[B] )

c\[AB\] of this equation is the \"empirically determined\", the molar
concentration of each annealing oligo over the course the PCR. It is
provided in PRIMER_DNA_CONC.\
c\[A\] is the molar concentration of oligos in the initial reaction
mix.\
c\[B\] is the molar concentration of template in the initial reaction
mix.\
\
The molar concentration of template in a PCR reaction is usually not
known and low. The molar concentration of oligos is high. Therefore the
fraction of primers bound is calculated for a situation, where primer
and template are at an equal concentration. This simplifies the
equation:

       c[A] = c[B]
       K = c[AB] / ( c[A] * c[A] )

The faction of primers bound to a template can be calculated:

       frac = c[AB] / ( c[A] + c[AB] )
       c[A] = ( 1 / frac - 1 ) * c[AB]
       K = c[AB] / ( c[A] * c[A] )
       K = c[AB] / [ ( 1 / frac - 1 ) * c[AB] * ( 1 / frac - 1 ) * c[AB] ]
       K = 1 / [ ( 1 / frac - 1 ) ^ 2 * c[AB] ]
       ( 1 / frac - 1 ) ^ 2 = 1 / ( K * c[AB] )
       1 / frac - 1 = sqrt[ 1 / ( K * c[AB] ) ]
       frac = 1 / ( 1 + sqrt[ 1 / ( K * c[AB] ) ] )

As the fraction should be in percent and the PRIMER_DNA_CONC is in
nanomolar, the final calculation is for symmetrical oligos:

       fract = ( 1 / ( 1 + sqrt( 1 / ( ( PRIMER_DNA_CONC / 1000000000.0 ) * K)))) * 100

and for unsymmetrical oligos:

       fract = ( 1 / ( 1 + sqrt( 1 / ( ( PRIMER_DNA_CONC / 4000000000.0 ) * K)))) * 100

with

       K = e^[( dS / R ) - ( dH / ( R * T ) ) ]

These calculations are not available if PRIMER_SALT_CORRECTIONS=2
(Owczarzy, R), as this empirical salt correction corrects the melting
temperature of primers and does not allow the correction of the
thermodynamic parameters required for the bound fraction calculation.

## [25. CAUTIONS]{#cautions}

Some of the most important issues in primer picking can be addressed
only before using Primer3. These are sequence quality (including making
sure the sequence is not vector and not chimeric) and avoiding
repetitive elements.\
\
Techniques for avoiding problems include a thorough understanding of
possible vector contaminants and cloning artifacts coupled with database
searches using blast, Fasta, or other similarity searching program to
screen for vector contaminants and possible repeats. Repbase (J. Jurka,
A.F.A. Smit, C. Pethiyagoda, and others, 1995-1996,
<ftp://ftp.ncbi.nih.gov/repository/repbase/>) is an excellent source of
repeat sequences and pointers to the literature. (The Repbase files need
to be converted to Fasta format before they can be used by Primer3.)\
Primer3 now allows you to screen candidate oligos against a Mispriming
Library (or a Mishyb Library in the case of internal oligos).\
\
Sequence quality can be controlled by manual trace viewing and quality
clipping or automatic quality clipping programs. Low- quality bases
should be changed to N\'s or can be made part of Excluded Regions. The
beginning of a sequencing read is often problematic because of primer
peaks, and the end of the read often contains many low-quality or even
meaningless called bases. Therefore, when picking primers from
single-pass sequence it is often best to use the
[SEQUENCE_INCLUDED_REGION](#SEQUENCE_INCLUDED_REGION) parameter to
ensure that Primer3 chooses primers in the high quality region of the
read.\
\
In addition, Primer3 takes as input a
[SEQUENCE_QUALITY](#SEQUENCE_QUALITY) list for use with those base
calling programs (e.g. Phred) that output this information.

## [26. WHAT TO DO IF PRIMER3 CANNOT FIND ANY PRIMERS?]{#findNoPrimers}

Try relaxing various parameters, including the self-complementarity
parameters and max and min oligo melting temperatures. For example, for
very A-T-rich regions you might have to increase maximum primer size or
decrease minimum melting temperature. It is usually unwise to reduce the
minimum primer size if your template is complex (e.g. a mammalian
genome), since small primers are more likely to be non-specific. Make
sure that there are adequate stretches of non-Ns in the regions in which
you wish to pick primers. If necessary you can also allow an N in your
primer and use an oligo mixture containing all four bases at that
position.\
\
Try setting the [PRIMER_EXPLAIN_FLAG](#PRIMER_EXPLAIN_FLAG) input tag.

## [27. DIFFERENCES FROM EARLIER VERSIONS]{#earlierVersions}

The section HOW TO MIGRATE TAGS TO IO VERSION 4 describes the modified
tags in detail. See also the file release_notes.txt in this directory.

## [28. EXIT STATUS CODES]{#exitStatusCodes}

     0 on normal operation
    -1 under the following conditions:
       illegal command-line arguments.
       unable to fflush stdout.
       unable to open (for writing and creating) a .for, .rev
         or .int file (probably due to a protection problem).
    -2 on out-of-memory
    -3 empty input
    -4 error in a "Global" input tag (message in PRIMER_ERROR).

Primer3 calls abort() and dumps core (if possible) if a programming
error is detected by an assertion violation.\
\
SIGINT and SIGTERM are handled essentially as empty input, except the
signal received is returned as the exit status and printed to stderr.\
\
In all of the error cases above Primer3 prints a message to stderr.

## [29. PRIMER3 WWW INTERFACES]{#webInterface}

There are two web interfaces available :\
The Bioinformatics workgroup at University of Tartu provides a basic
web-based interface to Primer3 named Primer3Web at
<http://primer3.ut.ee/>\
\
A Primer3Plus web services is at <http://primer3plus.com>\
\
\
Web interface code is available on GitHub:
<https://github.com/primer3-org>.

## [30. ACKNOWLEDGMENTS]{#acknowledgments}

Initial development of Primer3 was funded by Howard Hughes Medical
Institute and by the National Institutes of Health, National Human
Genome Research Institute under grants R01-HG00257 (to David C. Page)
and P50-HG00098 (to Eric S. Lander), but ongoing development and
maintenance are not currently funded.\
\
Primer3 was originally written by Helen J. Skaletsky (Howard Hughes
Medical Institute, Whitehead Institute) and Steve Rozen (Duke-NUS
Graduate Medical School Singapore, formerly at Whitehead Institute)
based on the design of earlier versions, notably Primer 0.5 (Steve
Lincoln, Mark Daly, and Eric S. Lander). The original web interface was
designed by Richard Resnick. Lincoln Stein designed the Boulder-IO
format in the days before XML and RDF, and championed the idea of making
Primer3 a software component, which has been key to its wide utility.\
\
In addition, among others, Ernst Molitor, Carl Foeller, and James
Bonfield contributed to the early design of Primer3. Brant Faircloth has
helped with ensuring that Primer3 runs on Windows and MacOS and with the
Primer3 web site. Triinu Koressaar and Maido Remm modernized the melting
temperature calculations in 2008. Triinu Koressaar added secondary
structure, primer-dimer, and template mispriming based on a
thermodynamic model in 2.2.0. Ioana Cutcutache is responsible for most
of the remaining improvements in 2.2.0, including performance
enhancements, modern command line arguments, and new input tags to
control primer location (with the \"overlap junction\" tags initially
implemented by Andreas Untergasser). Jian Ye patiently provided new
requirements.\
\
Harm Nijveen and Andreas Untergasser developed the webinterface
Primer3Plus in 2006-2009. Currently Primer3Plus is maintained by Andreas
Untergasser.\
\
Primer3 is an open software development project hosted on GitHub:
<https://github.com/primer3-org>.
:::

::: {#sidebar}
### Run Primer3:

[Primer3Web](http://primer3.ut.ee/)

[Primer3Plus](http://www.primer3plus.com)
:::

::: {#footer}
last updated: 08.Jan.2022 - [Impressum](impressum.html) - [Privacy
Policy](privacy.html)
:::
:::::::::
