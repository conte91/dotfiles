(add-to-list 'load-path "~/utils/emacs/")

(require 'package)
(add-to-list 'package-archives 
             '("melpa" . "http://melpa.org/packages/"))
(package-initialize) 


(require 'evil)
(require 'evil-leader)
(require 'evil-matchit)
(require 'evil-surround)
(require 'evil-nerd-commenter)

(setq evil-leader/in-all-states 1)
(global-evil-leader-mode)
;; Tag matching
(global-evil-matchit-mode 1)
(global-evil-surround-mode 1)
(evil-mode 1)
(evil-vimish-fold-mode 1)

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

(require 'org-annotate-file)
(evil-leader/set-key "a" 'org-annotate-file)


;; Helm-Projectile
(require 'projectile)
(require 'helm-projectile)
(projectile-global-mode)

(setq projectile-completion-system 'helm)
(helm-projectile-on)

;; Buffers/tabs management
(defvar my-skippable-buffers '("*Messages*" "*scratch*" "*Help*")
  "Buffer names ignored by `my-next-buffer' and `my-previous-buffer'.")

(defun my-change-buffer (change-buffer)
  "Call CHANGE-BUFFER until current buffer is not in `my-skippable-buffers'."
  (let ((initial (current-buffer)))
    (funcall change-buffer)
    (let ((first-change (current-buffer)))
      (catch 'loop
        (while (member (buffer-name) my-skippable-buffers)
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
(global-set-key (kbd "C-n") 'elscreen-create)
(global-set-key (kbd "C-h") 'elscreen-previous)
(global-set-key (kbd "C-l") 'elscreen-next)
(global-set-key (kbd "C-j") 'my-previous-buffer)
(global-set-key (kbd "C-k") 'my-next-buffer)

;;;;;;;;;;;;;;;; Indentation stuff ;;;;;;;;;;;;;;;;;;

;; Indentation with spaces everywhere (not TABs).
;; Exceptions: Makefile
(add-hook 'find-file-hook '(lambda ()
                             (if (and buffer-file-name
                                      (not (string-equal mode-name "Makefile")))
                               (setq indent-tabs-mode nil))))
(setq-default tab-width 3)
(setq-default c-basic-offset 3)
(setq-default cperl-indent-level 3)
(setq-default evil-shift-width 3)
(add-hook 'python-mode-hook
          (function (lambda () (setq evil-shift-width python-indent))))

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
(require 'p4)
(p4-set-client-name (getenv "P4CLIENT"))
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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
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
