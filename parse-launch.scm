;
; parse-launch.scm
;
; Run the cogserver, needed for the language-learning disjunct
; counting pipeline. Starts the cogserver, opens the database,
; loads the database (which can take an hour or more!)
;
(use-modules (opencog) (opencog cogserver))
(use-modules (opencog persist) (opencog persist-sql))
(use-modules (opencog nlp) (opencog nlp learn))

(load "utilities_local.scm")

; Get the database connection details
(define database-uri (get-connection-uri))

; Start the cogserver.
; Edit the below, setting it to the desired langauge.
; This has almost no effect, other than to set the cogserver
; port-number and the prompt-style.
(start-cogserver "opencog-en.conf")

; Open the database.
(sql-open database-uri)

; NOTE: This script assumes that compute-mi-launch.scm has
; already stored the mutual information for the pairs after
; an observe pass over the same sentences to be parsed.

; Load up the words
(display "Fetch all words from database. This may take a few minutes.\n")
(fetch-all-words)

; Load up the word-pairs -- this can take over half an hour!
(display "Fetch all word-pairs. This may take a few minutes!\n")

; The object which will be providing pair-counts for us.
; We can also do MST parsing with other kinds of pair-count objects,
; for example, the clique-pairs, or the distance-pairs.
(define pair-obj (make-clique-pair-api))
(pair-obj 'fetch-pairs)

(display "Done fetching pairs.\n")
