ARPKI

You can use the most recent version of Tamarin by going to
https://github.com/tamarin-prover/tamarin-prover
and following the instructions there. The relevant ARPKI model is
https://github.com/tamarin-prover/tamarin-prover/tree/develop/examples/ccs14

You can also use the version of Tamarin included in this tarball, but may need to work around Haskell quirks.



Formal analysis models


For our analysis, we used a custom version of the Tamarin prover, found
in the 'tamarin-prover-enhanced' subdirectory.


Note that this works fine and is tested on Ubuntu 12.04, but does not
currently work with Ubuntu 14.04 (without manual tweaking of the
tamarin-prover.cabal file) due to Haskell-specific dependencies.

Initially, follow the instructions on
http://www.infsec.ethz.ch/research/software/tamarin but do NOT run the
command "cabal install tamarin-prover" as described there, but instead
> cd tamarin-prover-enhanced
> make
the Tamarin prover from the included subdirectory after the
prerequisites are installed. Run the self-test with the command (where
tamarin-prover points to your installation), getting the result below:

> ~/.cabal/bin/tamarin-prover test

*** TEST SUMMARY ***
All tests successful.
The tamarin-prover should work as intended.

           :-) happy proving (-:



Once the Tamarin installation self-tested correctly, you are ready to
reproduce our results, following these instructions.



Run `make' to create the Tamarin input ".spthy" files from the given
"arpki.sphtypp" specification file and the given property files
"*.propp" - this combines them into analyzable Tamarin input. The
whole specification of ARPKI is found in the one "arpki.spthypp" file,
while the different properties we analyzed are given the other files,
and then combined with the specification.

To reproduce the results we reported in the paper, run all ".spthy"
files with Tamarin, using the commands shown below and expecting the
results below. For each experiment we have added a summary of that it
means. We also show the runtime on our machine. [Note that our machine
has 32GB of memory, and some of the runs below will possibly fail with
only 16GB, depending on the amount of concurrency.]



- The 'arpki-tests' show that all kinds of regular executions work as
  expected.
runtime: about 5 minutes real time

> tamarin-prover --prove arpki-tests.spthy
==============================================================================
summary of summaries:

analyzed: arpki-tests.spthy

  test (exists-trace): verified (15 steps)
  test2arg (exists-trace): verified (15 steps)
  can_accept_connection (exists-trace): verified (46 steps)
  private_key_secrecy (all-traces): verified (3 steps)
  cert_accepted_has_been_requested (all-traces): verified (5 steps)
  cert_logged_has_been_accepted (all-traces): verified (92 steps)
  connection_accepted (all-traces): verified (939 steps)

==============================================================================



- The 'arpki-proofNoUntrusted' shows that the property is verified
  when no untrusted, i.e., adversary-controlled, participants exist.
runtime: about 7 minutes real time

> tamarin-prover --prove arpki-proofNoUntrusted.spthy
==============================================================================
summary of summaries:

analyzed: arpki-proofNoUntrusted.spthy

  main (all-traces): verified (1390 steps)

==============================================================================



- The 'arpki-proofNoThreeUntrusted' shows that the property is
  verified when no more than two untrusted, i.e.,
  adversary-controlled, participants exist.
runtime: about 80 minutes real time

> tamarin-prover --prove arpki-proofNoThreeUntrusted.spthy
==============================================================================
summary of summaries:

analyzed: arpki-proofNoThreeUntrusted.spthy

  main (all-traces): verified (26423 steps)

==============================================================================



- The 'arpki-attackUnlimitedUntrusted' finds an attack, using three
  adversary-controlled, untrusted, parties. This is shown by the
  "falsified - found trace" result
runtime: about 52 minutes real time

> tamarin-prover --prove arpki-attackUnlimitedUntrusted.spthy
==============================================================================
summary of summaries:

analyzed: arpki-attackUnlimitedUntrusted.spthy

  main (all-traces): falsified - found trace (57 steps)

==============================================================================

