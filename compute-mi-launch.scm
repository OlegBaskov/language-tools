;
; parse-launch.scm
;
; Run the cogserver, needed for the language-learning disjunct
; counting pipeline. Starts the cogserver, opens the database,
; loads the database (which can take an hour or more!)
;
(use-modules (opencog) (opencog persist) (opencog persist-sql))
(use-modules (opencog cogserver))
(use-modules (opencog nlp) (opencog nlp learn))

(load "utilities_local.scm")

; Get the database connection details
(define database-uri (get-connection-uri))

; Start the cogserver.
; Edit the below, setting it to the desired langauge.
; This sets the cogserver port-number and the prompt-style.
(start-cogserver "opencog-en.conf")

; Open the database.
(sql-open database-uri)

(batch-clique-pairs)

; FIXME Is an sql-store needed?
(sql-close)

(display "Done\n")
