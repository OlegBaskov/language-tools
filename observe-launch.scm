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

;(load "utilities.scm")
(use-modules (ice-9 getopt-long))

(define (get-connection-uri)
"
  Used to specify the command-line arguments for getting database details.
  Depending on your database configuration, the usage patterns for scripts
  that invoke this function are,

    guile -l script.scm -- --db wiki --user opencog_user --password cheese
  or
    guile -l script.scm -- --db wiki --user opencog_user

"
  ;TODO This assumes local connection update for networked access.
  (let* ((option-spec
            '((db (required? #t) (value #t))
              (user (required? #f) (value #t))
              (password (required? #f) (value #t))))
        (options (getopt-long (command-line) option-spec))
        (pw (option-ref options 'password ""))
        (db_user (option-ref options 'user "")))

    (string-append
      "postgres:///" (option-ref options 'db #f)
      (if (equal? "" db_user) "" (format #f "?user=~a" db_user))
      (if (equal? "" pw) "" (format #f "&password=~a" pw)))
  )
)

; Get the database connection details
(define database-uri (get-connection-uri))

; Start the cogserver.
; Edit the below, setting it to the desired langauge.
; This sets the cogserver port-number and the prompt-style.
(start-cogserver "opencog-en.conf")

; Open the database.
(sql-open database-uri)
(display "Opened database: ")
(display database-uri)
(display "\n")
(display "Checking for empty database\n")
(fetch-all-words)

(define (cnt-all)
    (define cnt 0)
    (define (ink a) (set! cnt (+ cnt 1)) #f)
    (define (cnt-type x) (cog-map-type ink x))
    (map cnt-type (cog-get-types))
    cnt
)

(define atom-count (cnt-all))
(if (> atom-count 9)
    (begin
        (display "CAUTION: Database has ")
        (display atom-count)
        (display " atoms\n"))
    (begin
        (display "Database empty and ready for observe.\n")))
