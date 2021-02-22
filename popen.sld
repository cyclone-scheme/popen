;;;;
;;;; Cyclone Scheme interface to the POSIX popen functions
;;;;
(define-library (popen)
  (import 
    (scheme base)
    (scheme write)
    (cyclone foreign))
  (export
    popen
    pclose)
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
  )
)
