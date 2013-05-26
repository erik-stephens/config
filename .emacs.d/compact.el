
(defun compact-uncompact-block ()
  "Remove or add line endings on the current block of text.
This command similar to a toggle for `fill-paragraph' and `unfill-paragraph'
When there is a text selection, act on the region.

When in text modes, the “current block” is equivalent to the
current paragraph.  When in programing language modes, “current block”
is defined by between empty lines.

Todo: when in a programing lang mode, make the function more
smart, so that it doesn't cut strings.  Right now, the code uses
fill* functions. A proper implementation to compact is replacing
newline chars by space when the newline char is not inside
string. To uncompact, a proper solution needs to know the basic
syntax of each lang. A simple implementation is to simply insert
newline after “}” or “;” for c-like syntaxes."
  (interactive)

  ;; This command symbol has a property “'stateIsCompact-p”, the
  ;; possible values are t and nil. This property is used to easily
  ;; determine whether to compact or uncompact, when this command is
  ;; called again

  (let (bds currentLineCharCount currentStateIsCompact
            (bigFillColumnVal 4333999) (deactivate-mark nil))

    (save-excursion
      ;; currentLineCharCount is used to determine whether current state
      ;; is compact or not, when the command is run for the first time
      (setq currentLineCharCount
            (progn
              (setq bds (bounds-of-thing-at-point 'line))
              (length (buffer-substring-no-properties (car bds) (cdr bds)))    
              ;; Note: 'line includes eol if it is not buffer's last line
              )
            )

      ;; Determine whether the text is currently compact.  when the last
      ;; command is this, then symbol property easily tells, but when
      ;; this command is used fresh, right now we use num of chars of
      ;; the cursor line as a way to define current compatness state
      (setq currentStateIsCompact
            (if (eq last-command this-command)
                (get this-command 'stateIsCompact-p)
              (if (> currentLineCharCount fill-column) t nil)
              )
            )

      (if (region-active-p)
          (if currentStateIsCompact
              (fill-region (region-beginning) (region-end))
            (let ((fill-column bigFillColumnVal))
              (fill-region (region-beginning) (region-end)))
            )
        (if currentStateIsCompact
            (fill-paragraph nil)
          (let ((fill-column bigFillColumnVal))
            (fill-paragraph nil))
          )
        )

      (put this-command 'stateIsCompact-p
           (if currentStateIsCompact
               nil t)) ) ) )
