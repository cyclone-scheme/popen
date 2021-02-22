(import (scheme base) (popen) (cyclone test))
(test-group "popen"
  (define p (popen "echo test"))
  (let ((l (read-line p)))
    (test "test" l))
  (pclose p)
)
(test-exit)

