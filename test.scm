(import (scheme base) (cyclone io popen) (cyclone test))
(test-group "popen"
  (define p (popen "echo test"))
  (let ((l (read-line p)))
    (test "test" l))
  (test #t (pclose p))
)
(test-exit)

