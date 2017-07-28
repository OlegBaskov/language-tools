# C++ Language Tools #

These tools are scripts to analyze language text corpora by creating word pair observation atoms for language processing and then analyzing the word pairs to create mutual information pairs. Further processes allow the generation of mutual information-based parse trees connected by high-mi pairs using a heuristic greedy maximum spanning tree alogorithm.

These tools interface to the C++ versions of observe and parse which are replacements for the observe-text and mst-parse scheme functions. The "observe" and "parse" tools have been implemented as CogServer Request handlers. This was done so that the workflow could stay as similar to the scheme-based text processing tools. The scheme-based tools use Bash shell and perl scripts to split Wikipedia and other text corpora into sentence files and then processes those files by sending commands to generation word-pair observation atoms in the CogServer.

The scripts in this repository are analogous except they replace the calls to scheme functions with custom request handlers in the CogServer which process sentences using pure C++ and no scheme. These request handlers implement the keywords "observe" and "parse" on the CogServer.

## Observe ###
The observe command takes a sentence and creates word-pair observation atoms for all word pairs up to `pair_distance` words away from each other in the sentence.

It has several options:

```
Observe the sentence and create corresponding language learning atoms
Usage: learn [-pair_distance <limit>] "<sentence-in-quotes>"

Create language learning atoms for the sentence. Optional flags are:
    -pair_distance <limit>    Create pairs up to <limit> distance apart (default 6).
    -quiet                    Do not return status over telnet.
    -noop                     Perform no op-erations (useful for timing).
```

NOTE: Memory usage is proportional to the pair_distance specified, so it is suggested that one first observe a corpus using a fairly low number like 1 or 2 to estimate memory requirements if the default setting takes too much memory.

## Parse ###
The parse command takes a sentence and creates a parse of each sentence for potential parse pairs up to `pair_distance` words away from each other in the sentence. It is important that this distance be no greater than the `pair_distance` used by a prior Observe over the same data. So if you observed a sentence using a pair_distance of 3, then you can parse with distances 1 to 3 but not 4 and greater.

Parse has several options:

```
Parse the sentence.
Usage: parse [-pair_distance <limit>] "<sentence-in-quotes>"

Parse the sentence. Optional flags are:
    -open_parse <file_name>    Open the file <file_name> for output.
    -close_parse               Close the output file.
    -dump_weights <file>       Dump the word pair weights for the sentence to
                               <file> as a C++ struct.\n"
    -delimiter <string>        Use <string> to delimit fields in output.
    -check_pairs               Check pair sentence observations.
    -pair_distance <limit>     Create pairs up to <limit> distance apart.
    -quiet                     Do not return status over telnet.
    -noop                      Perform no op-erations (useful for timing).

```
## Set scripts to executable ##
The first time you use each of the scripts, you may need to make them executable because git does not set them that way by default:
```
chmod +x wiki-split-observe.sh
chmod +x wiki-split-parse.sh
chmod +x download/down-guten-tranch-1.sh
chmod +x guten-1-split-observe.sh
chmod +x guten-1-split-parse.sh
chmod +x observe-one.pl
chmod +x parse-one.pl
```

## Wikipedia - Observing ##

Follow the instructions for downloading and processing the Simple English Wikipedia text:

https://github.com/opencog/opencog/tree/master/opencog/nlp/learn/download/wikipedia

Those scripts will process the downloaded wikipedia text and split it into text articles sorted by directories for the starting letter of each article's title.

Now copy the entire "alpha_pages" directory to a new directory called "text/beta_pages". 
```
mkdir text/beta_pages
cp -R path_to_alpha_pages/alpha_pages text/beta_pages
```

This new directory, `text/beta_pages`,  will be the source directory for the processing scripts.

To process Wikipedia, create an empty database.

```
createdb wiki
<atom.sql psql wiki
```

Now edit the `observe-launch.scm` scheme script to use the 'wiki' database, then run it:
```
nano observe-launch.scm
guile -l observe-launch.scm
```

NOTE: At this point, the terminal tab or window will have a Guile prompt. This prompt will be used later to save the contents of the observation to the PostgreSQL backing store for use by the mutual information script. So don't close it before running the calls below to store atoms to SQL and close the database; or you will close the CogServer and lose the data in the AtomSpace.

This script opens the database and tests that there are no atoms. Once you have tested the scripts you can add to an existing database, but I would not recommend this approach until you are certain that your process works properly since it takes a long time to observe and analayze a large corpus of text.

To begin the observing of wikipedia articles, run:
```
./wiki-split-observe.sh
```

This script, in turn, calls the `split-observe-one.sh` script. This script, takes a single wiki article (aka text file), splits it into lines with one sentence per line, and then calls the `observe-one.pl` perl script. The `observe-one.pl` perl script sends each line in the input file to the CogServer using the ports defined in the script.

IMPORTANT: The above scripts only create the atoms, they do not save them to the database. When the script is done running, observe using `top` or `ps` to check if there are any PostgreSQL threads processing because it takes a while before the writer threads in the CogServer complete. The observe scripts will complete seconds and sometimes minutes before the processing of PostgreSQL commands is finished on the CogServer because atom creation is handled asynchronously in separate threads in the CogServer. So please do this:
```
(sql-store)
(sql-close)
```
at the Guile prompt (after checking that the postgres processes are finished), to store the atoms (will take minutes) and then close the database.

### Wikipedia - Computing Mutual Information ###
Once the files have been observed, and saved to the database, you can run the `compute-mi-launch.scm` scheme script to calculate mutual information for the observed word pairs. This script, opens the database, loads the word pairs, then computes the statistics for mutual information for the pairs and saves the result atoms to the database.

First, edit `compute-mi-launch.scm` to use the 'wiki' database, then run it:
```
nano compute-mi-launch.scm
guile -l compute-mi-launch.scm
```

### Wikipedia - Generating MST parses ###
To start parsing, first edit `parse-launch.scm` to use the 'wiki' database. Then launch the CogServer and load the word pair atoms and mutual information using:
```
nano parse-launch.scm
guile -l parse-launch.scm
```

Now, run the `wiki-split-parse.sh` script, which will take the same Wikipedia files and generate parses for them using the mutual information computed during the prior phase. Before running this script, edit it to place the parse output file wherever you wish. NOTE: the file is opened from the CogServer so relative file paths will be relative to the CogServer's working directory.
```
nano wiki-split-parse.sh
./wiki-split-parse.sh
```
This script opens the parse file on the CogServer, then runs `split-parse-one.sh` for each article, which, in turn, calls the `parse-one.pl` script to send each sentence to the CogServer for parsing.

After the script completes, the parse output file will contain output like:
```
1 1 Dorénaz 3 a
1 2 is 3 a
1 3 a 5 in
1 4 municipality 5 in
1 5 in 6 the
1 6 the 8 of
1 6 the 7 district
1 8 of 9 Saint
1 9 Saint 11 in
1 10 Maurice 11 in
1 11 in 12 the
1 12 the 14 of
1 12 the 13 canton
1 14 of 16 in
1 14 of 15 Valais
1 16 in 17 Switzerland
```
You can specify additional delimiters besides the default space " " using the -delimiter flag for the parse command.

## Project Gutenberg - Observing ##
Use the script `down-guten-tranche-1.sh` to download and process the input files from Project Gutenberg for the 50+ public domain books included in the English Tranche 1 corpus.
```
cd download
./down-guten-tranch-1.sh
```

This script copies downloaded files, cleans them up a bit, and places them in the directory specified at the head of the script. This defaults to:
```
destination="../../text/en-tranche-1"
```
which outputs the books to a text directory at the same level as the language directory which contains this ReadMe.

To process the files in `en-tranche-1`, first create an empty database:
```
createdb guten
<atom.sql psql guten
```

Now edit the `observe-launch.scm` scheme script to use the 'guten' database, then run it:
```
nano observe-launch.scm
guile -l observe-launch.scm
```

NOTE: At this point, the terminal tab or window will have a Guile prompt. This prompt will be used later to save the contents of the observation to the PostgreSQL backing store for use by the mutual information script. So don't close it before running the calls below to store atoms to SQL and close the database; or you will close the CogServer and lose the data in the AtomSpace.

This script opens the database and tests that there are no atoms. Once you have tested the scripts you can add to an existing database, but I would not recommend this approach until you are certain that your process works properly since it takes a long time to observe and analayze a large corpus of text.

To begin the observing of `en-tranche-1` books, run:
```
./guten-1-split-observe.sh
```

This script, in turn, calls the `split-observe-one-book.sh` script. This script, takes a single book (aka text file), splits it into lines with one sentence per line, and then calls the `observe-one.pl` perl script. The `observe-one.pl` perl script sends each line in the input file to the CogServer using the ports defined in the script.

IMPORTANT: The above scripts only create the atoms, they do not save them to the database. When the script is done running, observe using `top` or `ps` to check if there are any PostgreSQL threads processing because it takes a while before the writer threads in the CogServer complete. The observe scripts will complete seconds and sometimes minutes before the processing of PostgreSQL commands is finished on the CogServer because atom creation is handled asynchronously in separate threads in the CogServer. So please do this:
```
(sql-store)
(sql-close)
```
at the Guile prompt (after checking that the postgres processes are finished), to store the atoms (will take minutes) and then close the database.

### Project Gutenberg - Computing Mutual Information ###
Once the files have been observed, and saved to the database, you can run the `compute-mi-launch.scm` scheme script to calculate mutual information for the observed word pairs. This script, opens the database, loads the word pairs, then computes the statistics for mutual information for the pairs, then saves the result atoms to the database.

First, edit the file to use the 'guten' database, then run it:
```
nano compute-mi-launch.scm
guile -l compute-mi-launch.scm
```

### Project Gutenberg - Generating MST parses ###
To start parsing, first edit the parse-launch.scm script to use the 'guten' database; then launch the CogServer; and load the word pair atoms and mutual information using:
```
nano parse-launch.scm
guile -l parse-launch.scm
```

Now, run the `guten-1-split-parse.sh` script, which will take the same Project Gutenberg book files and generate parses for them using the mutual information computed during the prior phase. Before running this script, edit it to place the parse output file wherever you wish. NOTE: the file is opened from the CogServer so relative file paths will be relative to the CogServer's working directory.
```
nano guten-1-split-parse.sh
./guten-1-split-parse.sh
```
This script opens the parse file on the CogServer, then runs `split-parse-one-book.sh` for each book, which, in turn, calls the `parse-one.pl` script to send each sentence to the CogServer for parsing.

After the script completes, the parse output file will contain output like:
```
1 1 Dorénaz 3 a
1 2 is 3 a
1 3 a 5 in
1 4 municipality 5 in
1 5 in 6 the
1 6 the 8 of
1 6 the 7 district
1 8 of 9 Saint
1 9 Saint 11 in
1 10 Maurice 11 in
1 11 in 12 the
1 12 the 14 of
1 12 the 13 canton
1 14 of 16 in
1 14 of 15 Valais
1 16 in 17 Switzerland
```
You can specify additional delimiters besides the default space " " using the -delimiter flag for the parse command.
