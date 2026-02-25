(define-configuration buffer
		      ((default-modes
			 (pushnew 'nyxt/mode/vi:vi-normal-mode %slot-value%))))
(define-configuration web-buffer
		      ((default modes
				(pushnew 'nyxt/mode/blocker:blocker-mode %slot-value%))))
(defvar *my-search-engines*
  (list
    '("google" "https://google.com/search?q=~a" "https://google.com")))

(define-configuration context-buffer
		      ((search-engines
			 (append
			   (mapcar (lamba (engine) (apply 'make-search-engine engine))
				   *my-search-engines*)
			   %slot-default%))))
