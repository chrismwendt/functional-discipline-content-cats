;; LIU Xinyu
;; Started from 2007

(setq debug-on-error nil)

;;==========================================
;;  start the emacsserver that listens to emacsclietn
;; (server-start)


;; =======================================
;; proxy settings
;; set the use-proxy to true (t) when need proxy

(defvar use-proxy nil)
(when use-proxy
  (setq url-proxy-services
        '(("no_proxy" . "^\\(localhost\\|10.*\\)")
          ("http"  . "proxy.ip.addr:port")
          ("https" . "proxy.ip.addr:port"))))


;; uncomment the below section in case the proxy need authentication
;; ===========================================
;; (setq url-http-proxy-basic-auth-storage
;;     (list (list "proxy.com:8080"
;;                 (cons "Input your LDAP UID !"
;;                       (base64-encode-string "LOGIN:PASSWORD")))))

(defvar use-socks-proxy nil)
(when use-socks-proxy
  (setq socks-noproxy '("127.0.0.1"))
  (setq socks-server '("Default server" "127.0.0.1" 7070 5))
  (setq url-gateway-method 'socks))

(defvar my-site-lisp "~/.emacs.d/site-lisp")


;; ==========================================
;; ELPA and MELPA

(require 'package)

(setq package-archives
      '(("gnu" . "http://elpa.gnu.org/packages/")
        ("melpa-stable" . "http://stable.melpa.org/packages/")))

(custom-set-variables
 '(current-language-environment "UTF-8")
 '(package-selected-packages
   (quote
    (auto-complete graphviz-dot-mode smart-tabs-mode flyspell-popup markdown-mode flycheck haskell-mode)))
 '(tab-stop-list
   (quote
    (4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120)))
 '(tool-bar-mode nil))

(package-initialize)

;; =====================================
;;   Theme
(load-theme 'tango-dark t) ;;solarize-dark  ;;zenburn-dark

;; =====================================
;;   Don't use tab for indent

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; =======================================
;;    Interactive with host OS
;; ======================================

;; clipboard between emacs and X
(when (equal system-type 'gnu/linux)
  (setq x-select-enable-clipboard t))

;; Fix a problem in Mac OS X that shell path are not sync with emacs
(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable
   to match that used by the user's shell.
   This is particularly useful under Mac OSX, where GUI apps
   are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string "[ \t\n]*$" "" (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(when (equal system-type 'darwin)
  (set-exec-path-from-shell-PATH))

;; ==================================
;;    Mac OS X only: set drag-drop to open file instead of append
(when (equal system-type 'darwin)
  (global-set-key [ns-drag-file] 'ns-find-file))

;; =======================================
;; CSCOPE
;; (require 'xcscope)
;; (require 'ascope)

;; =======================================
;;   Winner Mode
;;    Support undo/redo with windows, C-c left/right
;;(when (fboundp 'winner-mode)
;;      (winner-mode 1))

;; ========================================
;;    ASpell
(setq-default ispell-program-name "aspell")
(setq ispell-list-command "list")

;; ========================================
;;    FlySpell
(flyspell-mode +1)
(define-key flyspell-mode-map (kbd "C-;") #'flyspell-popup-correct)
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

;; =======================================
;;      Syntax check
;; (global-flycheck-mode)

;; Defines tab spacing in sgml mode (includes XML mode)
;; source: http://www.emacswiki.org/emacs/IndentingHtml
(add-hook 'sgml-mode-hook
        (lambda ()
          ;; Default indentation is usually 2 spaces, changing to 4.
          (set (make-local-variable 'sgml-basic-offset) 4)))

;; Set to C indent
(setq-default c-basic-offset 4)

;; =============================================
;; Auto completion mode
;;
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories
             (concat my-site-lisp "/data/ac-dict")) ;; my own dict
(ac-config-default)
;; (setq ac-auto-start nil) ;; Uncomment this line to stop auto start

;; =================================
;; Enable the built-in CEDET
;;
;; (when (boundp 'semantic-mode)
;;   (semantic-mode 1)
;;   (global-ede-mode 1)
;;   (ede-enable-generic-projects)
;;   (global-semantic-idle-summary-mode 1))

;; ==================================
;; ggtags
;;
;; (add-hook 'c-mode-common-hook
;;           (lambda ()
;;             (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
;;               (ggtags-mode 1))))

(global-set-key [(f5)] 'speedbar)

;; =================================================
;; helper function for case insenstive sort lines
(defun sort-lines-nocase ()
  (interactive)
  (let ((sort-fold-case t))
    (call-interactively 'sort-lines)))

;; ============================================
;; auto save desktop session
(desktop-save-mode 1)

;; ============================================
;; language and font

(set-language-environment 'UTF-8)
(set-locale-environment "UTF-8")

(defun qiang-font-existsp (font)
  (if (null (x-list-fonts font))
      nil t))

(defun qiang-make-font-string (font-name font-size)
  (if (and (stringp font-size)
           (equal ":" (string (elt font-size 0))))
      (format "%s%s" font-name font-size)
    (format "%s-%s" font-name font-size)))

(defvar bhj-english-font-size nil)
(defun qiang-set-font (english-fonts
                       english-font-size
                       chinese-fonts
                       &optional chinese-fonts-scale
                       )
  (setq chinese-fonts-scale (or chinese-fonts-scale 1.0))
  (setq face-font-rescale-alist `(("Microsoft Yahei" . ,chinese-fonts-scale)
                                  ("STHeiti" . ,chinese-fonts-scale)
                                  ("微软雅黑" . ,chinese-fonts-scale)
                                  ("STSong" . ,chinese-fonts-scale)
                                  ("WenQuanYi Zen Hei" . ,chinese-fonts-scale)))
  (require 'cl)                         ; for find if
  (setq bhj-english-font-size english-font-size)
  (let ((en-font (qiang-make-font-string
                  (find-if #'qiang-font-existsp english-fonts)
                  english-font-size))
        (zh-font (font-spec :family (find-if #'qiang-font-existsp chinese-fonts))))

    ;; Set the default English font
    (set-face-attribute
     'default nil :font en-font)
    (condition-case font-error
        (progn
          (set-face-font 'italic (font-spec :family "Courier New" :slant 'italic :weight 'normal :size (+ 0.0 english-font-size)))
          (set-face-font 'bold-italic (font-spec :family "Courier New" :slant 'italic :weight 'bold :size (+ 0.0 english-font-size)))

          (set-fontset-font t 'symbol (font-spec :family "Courier New")))
      (error nil))
    (set-fontset-font t 'symbol (font-spec :family "Unifont") nil 'append)
    (set-fontset-font t nil (font-spec :family "DejaVu Sans"))

    ;; Set Chinese font
    ;; Do not use 'unicode charset, it will cause the english font setting invalid
    (dolist (charset '(kana han cjk-misc bopomofo))
      (set-fontset-font t charset zh-font)))
  (when (and (boundp 'global-emojify-mode)
             global-emojify-mode)
    (global-emojify-mode 1))
  (shell-command-to-string "sawfish-client -e '(maximize-window (input-focus))'&"))


(defvar bhj-english-fonts '("Monaco" "Consolas" "DejaVu Sans Mono" "Monospace" "Courier New"))
(defvar bhj-chinese-fonts '("Microsoft Yahei" "Microsoft_Yahei" "微软雅黑" "STSong" "STHei" "文泉驿等宽微米黑" "黑体" "新宋体" "宋体"))

(qiang-set-font
 bhj-english-fonts
 (if (file-exists-p "~/.config/system-config/emacs-font-size")
     (save-excursion
       (find-file "~/.config/system-config/emacs-font-size")
       (goto-char (point-min))
       (let ((monaco-font-size (read (current-buffer))))
         (kill-buffer (current-buffer))
         (if (numberp monaco-font-size)
             monaco-font-size
           12.5)))
   12.5)
 bhj-chinese-fonts)

(defvar chinese-font-size-scale-alist nil)

;; On different platforms, I need to set different scaling rate for
;; differnt font size.
(cond
 ((and (boundp '*is-a-mac*) *is-a-mac*)
  (setq chinese-font-size-scale-alist '((10.5 . 1.3) (11.5 . 1.3) (16 . 1.3) (18 . 1.25))))
 ((and (boundp '*is-a-win*) *is-a-win*)
  (setq chinese-font-size-scale-alist '((11.5 . 1.25) (16 . 1.25))))
 (t ;; is a linux:-)
  (setq chinese-font-size-scale-alist '((12.5 . 1.25) (14 . 1.25) (16 . 1.25) (20 . 1.25)))))

(defvar bhj-english-font-size-steps '(9 10.5 11.5 12.5 14 16 18 20 22))
(defun bhj-step-frame-font-size (step)
  (let ((steps bhj-english-font-size-steps)
        next-size)
    (when (< step 0)
        (setq steps (reverse bhj-english-font-size-steps)))
    (setq next-size
          (cadr (member bhj-english-font-size steps)))
    (when next-size
        (qiang-set-font bhj-english-fonts next-size bhj-chinese-fonts (cdr (assoc next-size chinese-font-size-scale-alist)))
        (message "Your font size is set to %.1f" next-size))))

(global-set-key [(control x) (meta -)] (lambda () (interactive) (bhj-step-frame-font-size -1)))
(global-set-key [(control x) (meta +)] (lambda () (interactive) (bhj-step-frame-font-size 1)))

(set-face-attribute 'default nil :font (font-spec))

;; Some memo:
;; ===============================
;; alias in eshell:
;; stored in ~/.eshell/alias
;; example:
;;   alias ff 'find-file $1'
;;   alias ll 'ls -l $*'
