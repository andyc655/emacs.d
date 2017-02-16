;; non-evil init.el

(setq load-prefer-newer t)
(setq ad-redefinition-action 'accept)

;; basic packages settings
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(load-theme 'zenburn t)
;; (menu-bar-mode -1)

;; comment uncomment
(global-set-key (kbd "C-c C-c") 'comment-region)
(global-set-key (kbd "C-c C-q") 'uncomment-region)

;; highlight regexp
(global-set-key (kbd "C-c /") 'highlight-regexp)

;; replace string
(global-set-key (kbd "C-c '") 'replace-string)
(global-set-key (kbd "C-c ;") 'replace-regexp)

;; remap mark-sexp
(global-set-key (kbd "M-s") 'mark-sexp)

(setq-default line-spacing 1)

;;helm config
(require 'helm)
(require 'helm-config)

(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-buffers-fuzzy-matching           t
      helm-recentf-fuzzy-match              t
      helm-imenu-fuzzy-match                t)

;; autoresize helm buffer
;;(helm-autoresize-mode t)
;; replace default M-x
(global-set-key (kbd "M-x") 'helm-M-x)
(setq helm-M-x-fuzzy-match t) ;; optional fuzzy matching for helm-M-x
;; kill ring keybind
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
;; buffer
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-b") 'helm-buffers-list)
;; find files
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-x C-r") 'helm-recentf)
;; swoop
(require 'helm-swoop)
(global-set-key (kbd "M-q") 'helm-swoop)
;; Change the keybinds to whatever you like :)
(global-set-key (kbd "M-Q") 'helm-swoop-back-to-last-point)
(global-set-key (kbd "C-c M-q") 'helm-multi-swoop)
(global-set-key (kbd "C-x M-q") 'helm-multi-swoop-all)

;; When doing isearch, hand the word over to helm-swoop
(define-key isearch-mode-map (kbd "M-q") 'helm-swoop-from-isearch)
;; From helm-swoop to helm-multi-swoop-all
(define-key helm-swoop-map (kbd "M-q") 'helm-multi-swoop-all-from-helm-swoop)
;; When doing evil-search, hand the word over to helm-swoop
;; (define-key evil-motion-state-map (kbd "M-q") 'helm-swoop-from-evil-search)

;; Instead of helm-multi-swoop-all, you can also use helm-multi-swoop-current-mode
(define-key helm-swoop-map (kbd "M-m") 'helm-multi-swoop-current-mode-from-helm-swoop)

;; Move up and down like isearch
(define-key helm-swoop-map (kbd "C-r") 'helm-previous-line)
(define-key helm-swoop-map (kbd "C-s") 'helm-next-line)
(define-key helm-multi-swoop-map (kbd "C-r") 'helm-previous-line)
(define-key helm-multi-swoop-map (kbd "C-s") 'helm-next-line)

;; Save buffer when helm-multi-swoop-edit complete
(setq helm-multi-swoop-edit-save t)

;; If this value is t, split window inside the current window
(setq helm-swoop-split-with-multiple-windows nil)

;; Split direcion. 'split-window-vertically or 'split-window-horizontally
(setq helm-swoop-split-direction 'split-window-vertically)

;; If nil, you can slightly boost invoke speed in exchange for text color
(setq helm-swoop-speed-or-color nil)

;; ;; Go to the opposite side of line from the end or beginning of line
(setq helm-swoop-move-to-line-cycle t)

;; Optional face for line numbers
;; Face name is `helm-swoop-line-number-face`
(setq helm-swoop-use-line-number-face t)

;; If you prefer fuzzy matching
(setq helm-swoop-use-fuzzy-match t)
;; occur
(global-set-key (kbd "C-c o") 'helm-occur)
;; top
(global-set-key (kbd "C-c t") 'helm-top)
;; resume
(global-set-key (kbd "C-c r") 'helm-resume)

(add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)

;;(helm-do-grep-ag)
(global-set-key (kbd "C-c e") 'helm-do-grep-ag)
(global-set-key (kbd "C-c a") 'helm-do-ag)

;;(helm-ls-git-ls)
(global-set-key (kbd "C-c l") 'helm-ls-git-ls)

;;(require 'helm-git-grep) ;; Not necessary if installed by package.el
(global-set-key (kbd "C-c g") 'helm-git-grep)
;; Invoke `helm-git-grep' from isearch.
(define-key isearch-mode-map (kbd "C-c g") 'helm-git-grep-from-isearch)
;; Invoke `helm-git-grep' from other helm.
(eval-after-load 'helm
    '(define-key helm-map (kbd "C-c g") 'helm-git-grep-from-helm))

(setq helm-grep-default-command
      "grep --color=always -d skip %e -n%cH -e %p %f"
      helm-grep-default-recurse-command
      "grep --color=always -d recurse %e -n%cH -e %p %f")

(when (executable-find "ack-grep")
  (setq helm-grep-default-command "ack-grep -Hn --no-group --no-color %e %p %f"
        helm-grep-default-recurse-command "ack-grep -H --no-group --no-color %e %p %f"))

(when (executable-find "git-grep")
  (setq helm-ls-git-grep-command
        "git grep -n%cH --color=always --full-name -e %p %f"))

(helm-adaptive-mode t)
(helm-mode 1)

;; semantic mode
;; (semantic-mode 1)

;; make all backup files to go to .saves
(setq backup-directory-alist `(("." . "~/.saves")))

;; type after select will replace
(delete-selection-mode 1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-basic-offset 4)
 '(c-offsets-alist
   (quote
    ((substatement . +)
     (arglist-cont-nonempty . 8)
     (innamespace . 0))))
 '(column-number-mode t)
 '(custom-buffer-indent 4)
 '(font-use-system-font t)
 '(helm-git-grep-candidate-number-limit 2000)
 '(indent-tabs-mode nil)
 '(nxml-child-indent 4)
 '(nxml-outline-child-indent 4)
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil))

;; Shortcut to open dired
(global-set-key (kbd "S-<f1>")
                (lambda ()
                  (interactive)
                  (dired "~/")))

;; Winner mode
(when (fboundp 'winner-mode)
  (winner-mode 1))

;; enable windmove switching
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

(global-set-key (kbd "C-c <deletechar>") 'windmove-left)
(global-set-key (kbd "C-c <next>")       'windmove-right)
(global-set-key (kbd "C-c <home>")       'windmove-up)
(global-set-key (kbd "C-c <select>")     'windmove-down)

;; Configure auto-complete
(ac-config-default)

;; Configure C indentation style
(require 'cc-mode)
(setq c-default-style "linux")
(setq c-basic-offset 4)
(setq tab-width 4)
(setq-default indent-tabs-mode nil)

; use c style comments in c++
(add-hook 'c++-mode-hook (lambda ()
                           (setq comment-start "/* " comment-end " */")))

;; If the filepath has 'linux' in it, use linux style
(defun maybe-linux-style ()
  (when (and buffer-file-name
             (string-match "linux" buffer-file-name))
    (progn
      (c-set-style "linux")
      (setq tab-width 8)
      (setq indent-tabs-mode t)
      (setq c-basic-offset 8))))

(add-hook 'c-mode-hook 'maybe-linux-style)

;; Deal with pesky whitespace
(add-hook 'c-mode-hook
          (lambda () (setq show-trailing-whitespace t)))
(add-hook 'c++-mode-hook
          (lambda () (setq show-trailing-whitespace t)))

(c-set-offset 'case-label '+)

;; unbind control z to stop accidentally exiting emacs
(define-key global-map (kbd "RET") 'newline-and-indent)

;; Set global linenum and hl-line mode
(global-linum-mode 1)
(electric-pair-mode 1)

(require 'whitespace)
(setq whitespace-style '(face empty tabs lines-tail trailing))
 (global-whitespace-mode t)

(global-set-key "\M-[1;5C"    'forward-word)  ; Ctrl+right => forward word
(global-set-key "\M-[1;5D"    'backward-word) ; Ctrl+left  => backward word
(define-key input-decode-map "\e[1;5A" [C-up])
(define-key input-decode-map "\e[1;5B" [C-down])

;; more compact mode line
(setq sml/shorten-directory t)
(setq sml/shorten-modes t)
(sml/setup)

;; y or n
(fset 'yes-or-no-p 'y-or-n-p)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; unset the sh-case binding
;;(add-hook 'sh-mode-hook (lambda () (local-set-key (kbd "C-c C-c")))

(setq confirm-kill-emacs 'yes-or-no-p)

(setq x-select-enable-clipboard t)

;; magit Shortcut
(global-set-key (kbd "C-c s") 'magit-status)
(global-set-key (kbd "C-c d") 'magit-diff)
(global-set-key (kbd "C-c b") 'magit-diff-buffer-file)
(global-set-key (kbd "C-c v") 'magit-log-buffer-file)
(global-set-key (kbd "C-c c") 'magit-log-current)
(global-set-key (kbd "C-c f") 'magit-find-file)
