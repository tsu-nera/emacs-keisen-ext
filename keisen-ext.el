;; keisen-ext.el -- provide keisen utilities like hidemaru macro
;; 
;; based on http://d.hatena.ne.jp/tamura70/20100125/ditaa
;;          http://www.pitecan.com/Keisen/keisen.el

;;; Code:

(require 'picture)

(defgroup keisen-ext nil
  "keisen utilities"
  :group 'files)

(defvar keisen-ext-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-M-<right>") 'keisen-ext-line-draw-right)
    (define-key map (kbd "C-M-<left>") 'keisen-ext-line-draw-left)
    (define-key map (kbd "C-M-<up>") 'keisen-ext-line-draw-up)
    (define-key map (kbd "C-M-<down>") 'keisen-ext-line-draw-down)
    (define-key map (kbd "M-S-<right>") 'keisen-ext-line-delete-right)
    (define-key map (kbd "M-S-<left>") 'keisen-ext-line-delete-left)
    (define-key map (kbd "M-S-<up>") 'keisen-ext-line-delete-up)
    (define-key map (kbd "M-S-<down>") 'keisen-ext-line-delete-down)
    map)
  "Alist containing the default keisen-ext bindings.")

(defvar keisen-ext-mode-hook nil
  "Hooks run during mode start.")

(defun keisen-ext-line-draw-str (h v str)
  (cond ((/= h 0) (cond ((string= str "|") "+")
			((string= str "+") "+")
			(t "-")))
	((/= v 0) (cond ((string= str "-") "+")
			((string= str "+") "+")
			(t "|")))
	(t str)
	))

(defun keisen-ext-line-delete-str (h v str)
  (cond ((/= h 0) (cond ((string= str "|") "|")
			((string= str "+") "|")
			(t " ")))
	((/= v 0) (cond ((string= str "-") "-")
			((string= str "+") "-")
			(t " ")))
	(t str)
	))

(defun keisen-ext-line-draw (num v h del)
  (let ((indent-tabs-mode nil)
	(old-v picture-vertical-step)
	(old-h picture-horizontal-step))
    (setq picture-vertical-step v)
    (setq picture-horizontal-step h)
    (while (>= num 0)
      (when (= num 0)
	(setq picture-vertical-step 0)
	(setq picture-horizontal-step 0))
      (setq num (1- num))
      (let (str new-str)
	(setq str
	      (if (eobp) " " (buffer-substring (point) (+ (point) 1))))
	(setq new-str
	      (if del (keisen-ext-line-delete-str h v str)
		(keisen-ext-line-draw-str h v str)))
	(picture-clear-column (string-width str))
	(picture-update-desired-column nil)
	(picture-insert (string-to-char new-str) 1)))
    (setq picture-vertical-step old-v)
    (setq picture-horizontal-step old-h)))

(defun keisen-ext-line-draw-right (n)
  "Draw line right."
  (interactive "p")
  (keisen-ext-line-draw n 0 1 nil))
			  
(defun keisen-ext-line-draw-left (n)
  "Draw line left."
  (interactive "p")
  (keisen-ext-line-draw n 0 -1 nil))

(defun keisen-ext-line-draw-up (n)
  "Draw line up."
  (interactive "p")
  (keisen-ext-line-draw n -1 0 nil))

(defun keisen-ext-line-draw-down (n)
  "Draw line down."
  (interactive "p")
  (keisen-ext-line-draw n 1 0 nil))

(defun keisen-ext-line-delete-right (n)
  "Delete line right."
  (interactive "p")
  (keisen-ext-line-draw n 0 1 t))
			  
(defun keisen-ext-line-delete-left (n)
  "Delete line left."
  (interactive "p")
  (keisen-ext-line-draw n 0 -1 t))

(defun keisen-ext-line-delete-up (n)
  "Delete line up."
  (interactive "p")
  (keisen-ext-line-draw n -1 0 t))

(defun keisen-ext-line-delete-down (n)
  "Delete line down."
  (interactive "p")
  (keisen-ext-line-draw n 1 0 t))

;;;###autoload
(define-minor-mode keisen-ext-mode
  "keisen-ext minor mode"
  :group 'keisen-ext
  :keymap keisen-ext-mode-map
  :lighter " Keisen-ext")

;;;###autoload
(defun keisen-ext-mode-launch ()
  "Turn on `keisen-ext-mode'."
  (keisen-ext-mode 1))

(provide 'keisen-ext)
;;; keisen-ext.el ends here
