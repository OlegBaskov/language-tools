;
; mst-count-en.scm
;
; Run the cogserver, needed for the language-learning disjunct
; counting pipeline. Starts the cogserver, opens the database,
; loads the database (which can take an hour or more!)
;
(use-modules (opencog) (opencog cogserver))
(use-modules (opencog persist) (opencog persist-sql))
(use-modules (opencog nlp) (opencog nlp learn))

; Start the cogserver.
; Edit the below, setting it to the desired langauge.
; This has almost no effect, other than to set the cogserver
; port-number and the prompt-style.
(start-cogserver "opencog-en.conf")

; Open the database.
; Edit the below, setting the database name, user and password.
(sql-open "postgres:///nlp")

; Load up the words
(display "Fetch all words from database. This may take several minutes.\n")
(fetch-all-words)

; Load up the word-pairs -- this can take over half an hour!
(display "Fetch all word-pairs. This may over half-an-hour!\n")

; The object which will be providing pair-counts for us.
; We can also do MST parsing with other kinds of pair-count objects,
; for example, the clique-pairs, or the distance-pairs.
(define pair-obj (make-clique-pair-api))
(pair-obj 'fetch-pairs)

; Print the sql stats
(sql-stats)

; Clear the sql cache and the stats counters
(sql-clear-cache)
(sql-clear-stats)


(define (first-index line) (caar (cadr line)))
(define (second-index line) (caadr (cadr line)))
(define (first-name line) (cog-name (cadar (cadr line))))
(define (second-name line) (cog-name (cadadr (cadr line))))

(define (write-parse-lines line_number parse-lines out_port)
    (for-each
        (lambda (line)
            (write (first-index line) out_port)
            (display ", " out_port)
            (write (first-name line) out_port)
            (display ", " out_port)
            (write (second-index line) out_port)
            (display ", " out_port)
            (write  (second-name line) out_port)
            (newline out_port)
        )
        parse-lines
    )
)

(define (mst-write line_number sentence out_file)
    (define parse_lines (mst-parse-text sentence))
    (write-parse-lines line_number parse_lines out_file)
)

(define (test)
    (define out_file (open-output-file "scheme_out.txt"))
    (mst-write 1, "He made a grand entrance." out_file)
    (mst-write 2, "She is very beautiful." out_file)
    (mst-write 3, "She dances well." out_file)
    (close out_file)
)
(test)

(define line_count 0)
(define (increment_line_count count) (set! line_count (+ line_count count)) #f)
(define parse_count 0)
(define (increment_parse_count) (set! parse_count (+ parse_count 1)) #f)

(define (count-parse-lines parse-lines)
    (define parse_line_count 0)
    (define (count_one_line) (set! parse_line_count (+ parse_line_count 1)) #f)
    (for-each
        (lambda (line)
            (count_one_line)
        )
        parse-lines
    )
    (increment_line_count parse_line_count)
)

(define (mst-count sentence)
    (count-parse-lines (mst-parse-text sentence))
    (increment_parse_count)
)

(define (display_parse_counts)
    (display "Parse count: ")
    (display parse_count)
    (newline)
    (display "Line count: ")
    (display line_count)
    (newline)
)

(define (test)
    (mst-count "He made a grand entrance.")
    (mst-count "She is very beautiful.")
    (mst-count "She dances well.")
    (display_parse_counts)
)
(test)

(define out_file (open-output-file "scheme_out.txt"))
