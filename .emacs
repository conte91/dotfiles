(add-to-list 'load-path "~/utils/emacs/")

(require 'package)
(add-to-list 'package-archives 
             '("melpa" . "http://melpa.org/packages/"))
(package-initialize) 

;; evil-mode maps C-z to "disable evil mode" :(
(setq evil-toggle-key "")

(require 'evil)
(require 'evil-leader)
(require 'evil-matchit)
(require 'evil-tabs)
;(require 'evil-matchit-systemverilog)
;list-put evilmi-plugins 'verilog-mode '((evilmi-systemverilog-get-tag evilmi-systemverilog-jump)))

(require 'evil-surround)
;(require 'evil-nerd-commenter)

;(setq evil-leader/in-all-states 1)
(evil-leader/set-leader "<SPC>")
(global-evil-leader-mode)
;;; Tag matching
(global-evil-matchit-mode 1)
(global-evil-surround-mode 1)

(evil-mode 1)

;(evil-vimish-fold-mode 1)

; Either close the current elscreen, or if only one screen, use the ":q" Evil
; command; this simulates the ":q" behavior of Vim when used with tabs.
(defun vimlike-quit ()
    "Vimlike ':q' behavior: close current window if there are split windows;
otherwise, close current tab (elscreen)."
    (interactive)
    (let ((one-elscreen (elscreen-one-screen-p))
          (one-window (one-window-p))
          )
      (cond
      ; if current tab has split windows in it, close the current live window
       ((not one-window)
        (delete-window) ; delete the current window
        (balance-windows) ; balance remaining windows
        nil)
      ; if there are multiple elscreens (tabs), close the current elscreen
       ((not one-elscreen)
        (elscreen-kill)
        nil)
      ; if there is only one elscreen, just try to quit (calling elscreen-kill
      ; will not work, because elscreen-kill fails if there is only one
      ; elscreen)
       (one-elscreen
        (evil-quit)
        nil)
            )))

(evil-ex-define-cmd "q[uit]" 'vimlike-quit)

;(require 'org-annotate-file)
;(evil-leader/set-key "a" 'org-annotate-file)

(setq tags-file-name ".etags")

;(require 'helm-config)
;(global-set-key (kbd "M-x") #'helm-M-x)
;(global-set-key (kbd " r b") #'helm-filtered-bookmarks)
;(global-set-key (kbd " ") #'helm-find-files)
;(helm-mode)
; Helm-Projectile
(require 'projectile)
(require 'helm-projectile)
(projectile-global-mode)
(setq projectile-tags-file-name tags-file-name)
(setq projectile-tags-backend "ctags")
(setq projectile-tags-command "git ls-files -oc --exclude-standard | ctags -Re -L - -f \"%s\"")

(setq projectile-completion-system 'helm)
(helm-projectile-on)

; add Ctrl-P functionality to normal mode
(define-key evil-normal-state-map (kbd "C-p") 'helm-projectile-find-file)
(evil-leader/set-key "pp" 'helm-projectile-switch-project)
(evil-leader/set-key "pg" 'helm-projectile-ag)

;; Buffers/tabs management
(defvar my-skippable-buffers '"(^\\*.*\\*$|^Dired\\(.*)"
  "Buffer names ignored by `my-next-buffer' and `my-previous-buffer'.")

(defun my-change-buffer (change-buffer)
  "Call CHANGE-BUFFER until current buffer is not in `my-skippable-buffers'."
  (let ((initial (current-buffer)))
    (funcall change-buffer)
    (let ((first-change (current-buffer)))
      (catch 'loop
        (while (string-match my-skippable-buffers (buffer-name))
          (funcall change-buffer)
          (when (eq (current-buffer) first-change)
            (switch-to-buffer initial)
            (throw 'loop t)))))))

(defun my-next-buffer ()
  "Variant of `next-buffer' that skips `my-skippable-buffers'."
  (interactive)
  (my-change-buffer 'next-buffer))

(defun my-previous-buffer ()
  "Variant of `previous-buffer' that skips `my-skippable-buffers'."
  (interactive)
  (my-change-buffer 'previous-buffer))

(global-set-key [remap next-buffer] 'my-next-buffer)
(global-set-key [remap previous-buffer] 'my-previous-buffer)



(global-evil-tabs-mode t)
(define-key evil-normal-state-map (kbd "C-n") 'elscreen-create)
(define-key evil-normal-state-map (kbd "C-h") 'elscreen-previous)
(define-key evil-normal-state-map (kbd "C-l") 'elscreen-next)
(define-key evil-normal-state-map (kbd "C-j") 'my-previous-buffer)
(define-key evil-normal-state-map (kbd "C-k") 'my-next-buffer)

;; Newline should extend comments if you're in a comment.
(defun insert-newline () (interactive) (if (nth 4 (syntax-ppss)) (funcall (key-binding (kbd "M-j"))) (newline 1 t)))
(define-key evil-insert-state-map (kbd "RET") 'insert-newline)

(evil-leader/set-key "j" 'next-error)
(evil-leader/set-key "k" 'previous-error)
(defun save-and-make () "Saves the current buffer and runs make" (interactive) (save-buffer) (evil-make nil))
(evil-leader/set-key "m" 'save-and-make)

;;;;;;;;;;;;;;;; Indentation stuff ;;;;;;;;;;;;;;;;;;

;; Indentation with spaces everywhere (not TABs).
;; Exceptions: Makefile
(add-hook 'python-mode '(lambda ()
                            (setq indent-tabs-mode t)))
(setq-default indent-tabs-mode t)
(setq-default tab-width 4)
(setq-default c-basic-offset 4)
(setq-default c-block-comment-prefix "* ")
(setq-default c-default-style "linux")

(setq-default cperl-indent-level 4)
;(setq-default evil-shift-width 4)

;Make trailing whitespace visible
(setq whitespace-style '(tab-mark space-before-tab trailing))
(global-whitespace-mode)

; Enable folding

;Make tabs visible
(standard-display-ascii ?\t "»\t")

;(add-hook 'python-mode-hook
          ;(function (lambda () (setq evil-shift-width python-indent))))
(add-hook 'dired-mode-hook 'evil-mode)
(add-hook 'compilation-mode-hook 'evil-mode)

;; esc quits
(defun minibuffer-keyboard-quit ()
    "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
    (interactive)
    (if (and delete-selection-mode transient-mark-mode mark-active)
	(setq deactivate-mark  t)
      (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
      (abort-recursive-edit)))
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(global-set-key [escape] 'evil-exit-emacs-state)

;; Perforce (sigh) integration
;;(require 'p4)
;(p4-set-client-name (getenv "P4CLIENT"))
;;(defun p4-update-global-key-prefix (symbol value)
;;    "Update the P4 global key prefix based on the
;;`p4-global-key-prefix' user setting."
;;    (set symbol value)
;;    (let ((map (current-global-map)))
;;      ;; Remove old binding(s).
;;      (dolist (key (where-is-internal p4-prefix-map map))
;;        (define-key map key nil))
;;      ;; Add new binding.
;;      (when p4-global-key-prefix
;;        (define-key map p4-global-key-prefix p4-prefix-map))))

;; Relative numbers + normal numbers
(global-linum-mode t)

;; Parenthesis highlight
(show-paren-mode 1)

;; Don't ask when editing a symlink that points to a version controlled file.
;; Always follow symlinks.
(setq vc-follow-symlinks t)

;; Random/obvious stuff
;;No newline for verilog
(setq-default verilog-auto-newline nil)
;; No 1000 spaces when declaring a verilog variable
(setq-default verilog-auto-lineup nil)
;; Save history at exit
(savehist-mode 1)
;; Select "word" text-objects as any symbol, depending on the language (e.g. foo-bar as a whole in LISP mode, but not C)
(with-eval-after-load 'evil
      (defalias #'forward-evil-word #'forward-evil-symbol))

;; Case-sensitive search
(setq case-fold-search nil)
;; Also, case-sensitive autocompletion.
(setq dabbrev-case-fold-search nil)

; Save the startup CWD
;;(setq startup-cwd default-directory)
;;; Reset it every time we open a file.
;;(add-hook 'find-file-hook #'(lambda () (setq default-directory startup-cwd)))
;;(advice-add 'cd :after (lambda(r) (setq startup-cwd default-directory)))

(defalias 'yes-or-no-p 'y-or-n-p) ;; short yes-or-now answers

; We're not in 1980 anymore, so opening a >10MB file should work
; without annoying prompts.
(setq large-file-warning-threshold 100000000)

; When opening one of the specified modes (C-like languages,
; python, add more as needed), treat underscore as part of words.
(dolist
  (mode-with-underscores (list 'python-mode-hook 'c-mode-common-hook))
  (add-hook mode-with-underscores #'(lambda () (modify-syntax-entry ?_ "w")))
)

; Don't scroll half window at the time
(setq scroll-step 1)
(setq scroll-margin 1)

(add-hook 'c-mode-common-hook
          #'(lambda ()
              (add-to-list 'c-cleanup-list 'brace-else-brace)
              (add-to-list 'c-cleanup-list 'brace-elseif-brace)
              (add-to-list 'c-cleanup-list 'defun-close-semi)
          )
)
(add-hook 'prog-mode-hook 'hs-minor-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (origami ggtags telega cmake-mode ag helm-ag magit ## elscreen-tab flycheck dash cmake-ide rtags helm-projectile evil-tabs evil-surround evil-matchit evil-leader)))
 '(safe-local-variable-values
   (quote
    ((demo . Whatever)
     (eval setq-local flycheck-clang-include-path
           (list "/home/simone/shift/bitbox02-firmware/src" "/home/simone/shift/bitbox02-firmware/external/asf4-drivers/"))
     (eval setq-local flycheck-clang-definitions
           (list "APP_BTC=1" "APP_LTC=1" "PRODUCT_BITBOX_MULTI=1"))
     (flycheck-clang-include-path
      ("/home/simone/shift/bitbox02-firmware/src" "/home/simone/shift/bitbox02-firmware/external/asf4-drivers/"))
     (flycheck-clang-definitions
      ("APP_BTC=1" "APP_LTC=1" "PRODUCT_BITBOX_MULTI=1"))
     (flycheck-clang-include-path
      (list
       (concatenate
        (file-name-directory
         (buffer-file-name))
        "/src")
       (concatenate
        (file-name-directory
         (buffer-file-name))
        "/external/asf4-drivers/")))
     (flycheck-clang-definitions
      (list "APP_BTC=1" "APP_LTC=1" "PRODUCT_BITBOX_MULTI=1"))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-added ((t (:inherit diff-changed :background "green"))))
 '(diff-changed ((t (:foreground "black"))))
 '(diff-context ((t (:weight extra-light))))
 '(diff-removed ((t (:inherit diff-changed :background "#ff0000"))))
 '(elscreen-tab-other-screen-face ((t (:background "color-243" :foreground "black" :underline t))))
 '(font-lock-comment-delimiter-face ((t (:inherit font-lock-comment-face :weight bold))))
 '(font-lock-comment-face ((t (:foreground "color-42"))))
 '(font-lock-function-name-face ((t (:foreground "brightcyan" :weight normal))))
 '(font-lock-keyword-face ((t (:foreground "brightmagenta"))))
 '(font-lock-preprocessor-face ((t (:inherit default :foreground "magenta"))))
 '(font-lock-string-face ((t (:foreground "white"))))
 '(font-lock-type-face ((t (:foreground "color-172"))))
 '(font-lock-variable-name-face ((t (:foreground "green" :weight bold))))
 '(linum ((t (:inherit (shadow default) :foreground "cyan"))))
 '(minibuffer-prompt ((t (:foreground "brightyellow")))))
(put 'narrow-to-region 'disabled nil)
