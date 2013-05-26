;;; elpy-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (elpy-mode elpy-disable elpy-enable) "elpy" "elpy.el"
;;;;;;  (20716 22899 0 0))
;;; Generated autoloads from elpy.el

(autoload 'elpy-enable "elpy" "\
Enable Elpy in all future Python buffers.

\(fn)" t nil)

(autoload 'elpy-disable "elpy" "\
Disable Elpy in all future Python buffers.

\(fn)" t nil)

(autoload 'elpy-mode "elpy" "\
Minor mode in Python buffers for the Emacs Lisp Python Environment.

Key bindings

Indentation and Filling:

TAB          indent line if at the beginning of it, else complete
C-j          `newline-and-indent'
C-c <        `python-indent-shift-left'
C-c >        `python-indent-shift-right'
C-M-q        `prog-indent-sexp'
M-q          `python-fill-paragraph'

Python Shell Interaction:

C-c C-z      `python-shell-switch-to-shell'

C-M-x        `python-shell-send-defun'
C-c C-c      `elpy-shell-send-region-or-buffer'

Virtual Environments:

C-c C-e      `pyvirtualenv'

Code Navigation

C-c C-j      `imenu'
C-c C-f      `rope-find-file'
C-c C-g C-d  `rope-goto-definition'
C-c C-g C-c  `rope-find-occurrences'
C-c C-g C-i  `rope-find-implementations'
C-c C-g C-g  `rope-jump-to-global'

C-M-up       `python-nav-backward-up-list'
M-a          `elpy-nav-backward-statement'
M-e          `elpy-nav-forward-statement'

Documentation

C-c C-v      `elpy-check'

C-c C-d      `elpy-doc-rope'
C-c C-w C-s  `elpy-doc-search'
C-c C-w C-w  `elpy-doc-show'

Project support

C-c C-p C-o  `rope-open-project'
C-c C-p C-c  `rope-close-project'
C-c C-p C-p  `rope-project-config'

Refactoring

C-c C-r      `elpy-refactor'

\(fn &optional ARG)" t nil)

;;;***

;;;### (autoloads nil nil ("elpy-pkg.el") (20716 22899 723883 0))

;;;***

(provide 'elpy-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; elpy-autoloads.el ends here
