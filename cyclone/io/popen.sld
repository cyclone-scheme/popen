;;;;
;;;; Cyclone Scheme interface to the POSIX popen functions
;;;;
(define-library (cyclone io popen)
  (import 
    (scheme base)
    (scheme read)
    (scheme write)
    (cyclone foreign))
  (export
    popen
    pclose
    open-input-pipe
    close-pipe-port
    with-input-from-pipe
    read-all-from-pipe
    read-lines-from-pipe)
  (begin

    (define-c popen
      "(void *data, int argc, closure _, object k, object cmd)"
      " Cyc_check_str(data, cmd);
        
        FILE *fp = popen(string_str(cmd), \"r\");
        if (fp == NULL) {
          fprintf(stderr, \"Failed to run command\\n\" );
          exit(1);
        }
        make_input_port(p, fp, 1);
        return_closcall1(data, k, &p);")

    (define-c pclose
      "(void *data, int argc, closure _, object k, object port)"
      " Cyc_check_port(data, port);
        port_type *p = port;
        pclose(p->fp);
        return_closcall1(data, k, boolean_t);")

    (define open-input-pipe popen)

    (define close-pipe-port pclose)

    (define (with-input-from-pipe cmd thunk)
      (let* ((proc-port (open-input-pipe cmd))
             (result (parameterize
                         ((current-input-port proc-port))
                       (thunk))))
        (close-pipe-port proc-port)
        result))

    ;; Read everything as Scheme objects
    (define (read-all-from-pipe cmd)
      (with-input-from-pipe
       cmd
       (lambda ()
         (read-all (current-input-port)))))

    ;; Read everything from pipe as strings
    (define (read-lines-from-pipe cmd)
      (with-input-from-pipe
       cmd
       (lambda ()
         (let loop ((result '()))
           (define str (read-line (current-input-port)))
           (cond
             ((eof-object? str)
              (reverse result))
             (else
              (loop (cons str result))))))))

  )
)
