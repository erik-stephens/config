;;; .emacs --- Flycheck, this is my initialization file, umkay?

;;; Commentary:

;; No comment!

;;; Code:

(dolist (mode '(menu-bar-mode tool-bar-mode scroll-bar-mode))
  (when (fboundp mode) (funcall mode -1)))

;; Always ALWAYS use UTF-8
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Always ask for y/n keypress instead of typing out 'yes' or 'no'
(defalias 'yes-or-no-p 'y-or-n-p)

;; Get hostname
(setq hostname (replace-regexp-in-string "\\(^[[:space:]\n]*\\|[[:space:]\n]*$\\)" "" (with-output-to-string (call-process "hostname" nil standard-output))))

;;; Set the PATH, even if not started from the shell -- stolen from Mahmoud
(setenv "PATH" (shell-command-to-string "/bin/bash -l -c 'echo -n $PATH'"))

(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(if (or window-system (and (>= emacs-major-version 23) (daemonp)))
    ;; We're a server
    (progn (global-set-key [(meta \3)] 'server-edit-or-close)
	   (custom-set-variables '(server-use-tcp t))
	   (server-start))
  ;; We're a client
  (global-set-key [(meta \3)]
		  (lambda () (interactive) (save-buffers-kill-emacs t))))
;; (define-key global-map [(meta \3)]
;;   (lambda ()
;;     "Save the edit client buffer and exit in one fell swoop."
;;     (interactive)
;;     (save-buffer)
;;     (server-edit)))

; Edit server for "Edit with Emacs" Chrome extension.
;; (require 'edit-server)
;; (edit-server-start)

(defun my-display-buffer-function (buf not-this-window)
  "Keep emacs from splitting the window so much."
  (if (and (not pop-up-frames)
           (one-window-p)
           (or not-this-window
               (not (eq (window-buffer (selected-window)) buf)))
           (> (frame-width) 162))
      (split-window-horizontally))
  ;; Note: Some modules sets `pop-up-windows' to t before calling
  ;; `display-buffer' -- Why, oh, why!
  (let ((display-buffer-function nil)
        (pop-up-windows nil))
    (display-buffer buf not-this-window)))

(setq display-buffer-function     'my-display-buffer-function
      pop-up-frame                 nil
      display-buffer-reuse-frames  t)

(defadvice split-window-horizontally (after rebalance-windows activate)
  "Tell emacs to keep the windows with equal width."
  (balance-windows))
(ad-activate 'split-window-horizontally)

(defun join-region (beg end)
  "Apply `join-line` over region from BEG to END."
  (interactive "r")
  (if mark-active
      (let ((beg (region-beginning))
            (end (copy-marker (region-end))))
        (goto-char beg)
        (while (< (point) end)
          (join-line 1)))))

;; (defun visit-file ()
;;   "Visit file under point at line number under point (file:number)."
;;   (interactive)
;;   (execute-kbd-macro (read-kbd-macro "C-s : C-b C-f C-@ ESC f C-x r s l ESC b C-b C-@ C-a C-x r s f C-x C-f C-x h C-x r i f RET ESC g C-x r i l RET")))

;; (defun grep-project (s)
;;   (interactive "sSearch project for: ")
;;    (grep-find (concat "files=(`hg manifest`); grep -nH -e \"" s "\" ${files[@]/#/`hg root`/}")))

;;; Key bindings.

; Motion key bindings.
(define-key global-map [(meta i)]
  (lambda ()
    "Scroll current window up 1 line, without affecting the cursor."
    (interactive)
    (scroll-down 1)))
(define-key global-map [(button4)]
  (lambda ()
    "Scroll current window up 1 line, without affecting the cursor."
    (interactive)
    (scroll-down 1)))
(define-key global-map [(meta I)]
  (lambda ()
    "Scroll other window up 1 line, without affecting the cursor."
    (interactive)
    (scroll-other-window -1)))
(define-key global-map [(meta o)]
  (lambda ()
    "Scroll current window down 1 line, without affecting the cursor."
    (interactive)
    (scroll-up 1)))
(define-key global-map [(button5)]
  (lambda ()
    "Scroll current window down 1 line, without affecting the cursor."
    (interactive)
    (scroll-up 1)))
(define-key global-map [(meta O)]
  (lambda ()
    "Scroll current window down 1 line, without affecting the cursor."
    (interactive)
    (scroll-other-window 1)))

(define-key global-map [(meta k)]
  (lambda ()
    "Closes current buffer even if unsaved changes."
    (interactive)
    (kill-buffer (current-buffer))))

(delete-selection-mode 1)
(define-key global-map [(ctrl h)]   	     'delete-backward-char)
(define-key global-map [(meta n)]      	     'universal-argument)
(define-key global-map [(ctrl u)]   	     'scroll-down)
(define-key global-map [(ctrl c) <] 	     'py-shift-region-left)
(define-key global-map [(ctrl c) >] 	     'py-shift-region-right)
(define-key global-map [(ctrl c) (ctrl i)]   'indent-region)
(define-key global-map "\C-c#"   	     'comment-region)
(define-key global-map [(meta r)]      	     'query-replace)
(define-key global-map "\C-xk" 	             'compile)
(define-key global-map [(ctrl -)]   	     'undo)
(define-key global-map [(meta \9)]           'start-kbd-macro)
(define-key global-map [(meta \0)]           'end-kbd-macro)
(define-key global-map [(meta -)]	     'call-last-kbd-macro)
(define-key global-map [(ctrl x) (ctrl m)]   'execute-extended-command)

;;; General customizations.

; Variables.
(setq make-backup-files            nil
      dired-use-ls-dired           nil
      auto-save-default            nil
      next-screen-context-lines    5
      bar-cursor                   2
      line-number-mode             t
      truncate-lines               t
      column-number-mode           t
      tab-width                    4
      bell-volume                  0
      truncate-lines               t
      track-eol                    t
      require-final-newline        nil
      delete-key-deletes-forward   t
      shell-multiple-shells        t
      query-user-mail-address      nil
      one-buffer-one-frame         nil)

; What to do when there are emacs/lisp errors.
(setq debug-on-error nil)
(setq debug-on-signal nil)

; These minor modes always on unless explicitly turned on/off.
(turn-on-auto-fill)
(global-font-lock-mode t)
(pending-delete-mode 1)

; Don't need or want toolbars, menu bars, or scroll bars.
(when (or window-system t) ;; (and (>= emacs-major-version 23) (daemonp)))
  (if (fboundp 'menu-bar-mode)
      (menu-bar-mode 0))
  (if (fboundp 'tool-bar-mode)
      (tool-bar-mode 0))
  (if (fboundp 'scroll-bar-mode)
      (scroll-bar-mode -1))
  (if (fboundp 'scroll-bar-mode)
      (tooltip-mode 0)))

;;; Mode customizations.

; Subversion mode.
(setq svn-status-default-diff-arguments '("--diff-cmd" "diff" "-x" "-wbBu"))

; Python mode.
(add-hook 'python-mode-hook
          '(lambda ()
             (auto-fill-mode 0)
             (modify-syntax-entry ?\_ "." py-mode-syntax-table)))

; Shell mode.
(add-hook 'shell-mode-hook
          '(lambda ()
             (define-key (current-local-map) "\C-l"
               (lambda ()
                 "Emulate clear screen command."
                 (interactive)
                 (kill-region (point-min) (point-max))
                 (execute-kbd-macro (read-kbd-macro "RET"))))))

; Shell script mode.
(add-hook 'sh-mode-hook
          '(lambda ()
             (define-key (current-local-map) "\C-c\C-c"
               (lambda ()
                 "Execute contents of buffer by shell."
                 (interactive)
                 (sh-execute-region (point-min) (point-max))))))

(add-to-list 'auto-mode-alist '("mako" . sgml-mode))
(add-to-list 'auto-mode-alist '("html" . sgml-mode))

; CSS mode.
;; (autoload 'css-mode "css-mode")
;; (add-to-list 'auto-mode-alist '("css$" . css-mode))
;; (setq cssm-indent-function #'cssm-c-style-indenter
;;       cssm-indent-level '2)

; C mode.
(add-hook 'c-mode-hook
	  '(lambda ()
	     (c-set-style "k&r")
	     (setq c-basic-offset             2)))
(add-to-list 'auto-mode-alist '("nasl$" . c++-mode))

; Ediff mode.
;(setq ediff-control-frame-upward-shift        -100
;      ediff-wide-control-frame-rightward-shift 125)

;(setq mac-option-modifier 'meta)
;(setq mac-pass-option-to-system nil)

(setq whitespace-action '(auto-cleanup)) ;; automatically clean up bad whitespace
(setq whitespace-style '(trailing space-before-tab indentation empty space-after-tab)) ;; only show bad whitespace

(setq-default c-basic-offset 2
              python-indent 4
              js-indent-level 2
	      coffee-tab-width 2
              css-indent-offset 2)

; Never insert tab characters for indentation
(setq-default indent-tabs-mode nil)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; (require 'coffee-mode)
;; (require 'less-css-mode)
(require 'sws-mode)
(require 'jade-mode)
(add-to-list 'auto-mode-alist '("\\.md$" . markdown-mode))

; Make sure color codes handled correctly in compilation output and when in a shell.
;; (defun colorize-compilation-buffer ()
;;   (toggle-read-only)
;;   (ansi-color-apply-on-region (point-min) (point-max))
;;   (toggle-read-only))
;; (add-hook 'compilation-filter-hook 'colorize-compilation-buffer)
;; (add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(add-to-list 'load-path "~/.emacs.d/elpa/")

(let ((base "~/.emacs.d/themes"))
  (add-to-list 'custom-theme-load-path base)
  (dolist (f (directory-files base))
    (let ((name (concat base "/" f)))
      (when (and (file-directory-p name) 
                 (not (equal f ".."))
                 (not (equal f ".")))
        (add-to-list 'custom-theme-load-path name)))))
(load-theme 'zenburn' t)

(require 'tramp)
(setq tramp-default-method "ssh")

(require 'desktop)
(desktop-save-mode 1)
(defun my-desktop-save ()
  (interactive)
  "Don't call desktop-save-in-desktop-dir, as it prints a message."
  (if (eq (desktop-owner) (emacs-pid))
      (desktop-save desktop-dirname)))
(add-hook 'auto-save-hook 'my-desktop-save)

(global-hl-line-mode 1)
(set-face-attribute hl-line-face nil :underline t)

(require 'google-translate)
(require 'rvm)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("52b5da0a421b020e2d3429f1d4929089d18a56e8e43fe7470af2cea5a6c96443" "fc5fcb6f1f1c1bc01305694c59a1a861b008c534cae8d0e48e4d5e81ad718bc6" "1e7e097ec8cb1f8c3a912d7e1e0331caeed49fef6cff220be63bd2a6ba4cc365" default)))
 '(global-company-mode f)
 '(server-use-tcp t))

;; (add-hook 'after-init-hook #'global-flycheck-mode)
(global-flycheck-mode t)

;; (require 'flex-autopair)
;; (flex-autopair-mode t)

(require 'php-mode)
(setq php-mode-force-pear t)
(add-hook 'php-mode-hook
          '(lambda ()
             (setq indent-tabs-mode t)
             (setq tab-width 4)
             (setq c-basic-offset 4)))

;; (require 'geben)

(provide '.emacs)

;;; .emacs ends here
