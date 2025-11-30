(setq inhibit-startup-message t)

(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'tooltip-mode) (tooltip-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(set-fringe-mode 10) ;; give some breathing room

;; Set up the visible bell
(setq visible-bell t)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Line numbers and cols:
(column-number-mode)
(global-display-line-numbers-mode t)

;; disable line numbers for some modes
(dolist (mode '(org-mode-hook
    term-mode-hook
    eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package command-log-mode)

(use-package mood-line
  :config
  (mood-line-mode 1))

(use-package doom-themes
  :init (load-theme 'doom-dracula t))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config (setq which-key-idle-delay 1.0))

(use-package ivy-rich
  :init (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
   ("C-x b" . counsel-ibuffer)
   ("C-x C-f" . counsel-find-file)
   ("C-M-j" . 'counsel-switch-buffer)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (counsel-mode 1))

(use-package ivy
  :diminish ;; diminish the mode name in the mode list
  :bind (("C-s" . swiper)
   :map ivy-minibuffer-map
   ("TAB" . ivy-alt-done)
   ("C-l" . ivy-alt-done)
   ("C-j" . ivy-next-line)
   ("C-k" . ivy-previous-line)
   :map ivy-switch-buffer-map
   ("C-k" . ivy-previous-line)
   ("C-l" . ivy-done)
   ("C-d" . ivy-switch-buffer-kill)
   :map ivy-reverse-i-search-map
   ("C-k" . ivy-previous-line)
   ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package swiper)

;; replacement for built-in help:
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;;(use-package fennel-mode)
(autoload 'antifennel-mode "~/src/git.sr.ht/technomancy/fennel-mode/antifennel.el" nil t)
(add-hook 'lua-mode-hook 'antifennel-mode)

(use-package ripgrep
  :bind ("C-x C-g" . 'ripgrep-regexp))

(use-package paredit)
(use-package try)

(use-package markdown-mode)
(use-package keyfreq)
(use-package writegood-mode)

;; Org mode settings (until set up later)
(require 'org-tempo)
(use-package org-journal
  :defer t)
(use-package org
  :defer t
  :mode (("\\.org$" . org-mode)))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-icon-type 'all-the-icons))

(use-package page-break-lines)
(use-package all-the-icons
  :if (display-graphic-p))

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map)))

(use-package org-mem
  :defer
  :config
  ;; At least one of these two is needed
  (setq org-mem-do-sync-with-org-id t)
  (setq org-mem-watch-dirs
        (list "~/org/personal"))
  (org-mem-updater-mode))

(use-package org-node
  :init
  ;; Optional key bindings
  ;; Tip: Try changing these to just "M-o"!
  (keymap-global-set "M-o n" org-node-global-prefix-map)
  (with-eval-after-load 'org
    (keymap-set org-mode-map "M-o n" org-node-org-prefix-map))
  :config
  (org-node-cache-mode))

(setq org-log-into-drawer "LOGBOOK")
(setq org-todo-keywords
  '((sequence "TODO(t)" "IN PROGRESS(!)" "WAITING(w@/!)" "DOING(!)" "DONE(d!)" "CANCELED(c@)")))

(with-eval-after-load 'org
  ;;(setq org-startup-indented t) ; Enable `org-indent-mode' by default
  (add-hook 'org-mode-hook #'visual-line-mode)) ; Enable visual line mode

(setq org-directory "~/org/personal")

;; Set to the name of the file where new capture notes will be stored
(setq org-default-notes-file (concat org-directory "/notes.org"))
(define-key global-map "\C-cc" 'org-capture)

(setq org-capture-templates
      '(("n" "Note"
	 entry (file "~/org/personal/notes.org")
	 "* %U %?\n\n  %i\n\n  From: %a")
	("j" "Journal Entry"
	 entry (file+function "~/org/personal/journal.org"
			      (lambda ()
				(org-datetree-find-date-create
				 (org-date-to-gregorian (org-today)) t)
				(re-search-forward "^\\*.+ log" nil t)))
	 "* Entry: %?\n\n  %i\n\n  From: %a"
	 :empty-lines 1)
	("t" "TODO"
	 entry (file "~/org/personal/notes.org")
	 "* TODO %U %?\n\n %i \n\n From: %a"
	 :empty-lines 1)
	("a" "annotate.mattgauger.com link"
	 entry (file "~/org/personal/annotate.mattgauger.com/index.org")
	 "* %? %U\n\n%i"
	 :prepend 1)))


;; bind Org agendas view
(global-set-key "\C-ca" 'org-agenda)

;; org-journal setup
(setq org-journal-dir (concat org-directory "/journal"))

(defun get-journal-file-today ()
  "Return filename for today's journal entry."
  (let ((daily-name (format-time-string "%Y%m%d.org")))
    (expand-file-name (concat org-journal-dir "/" daily-name))))

(defun journal-file-today ()
  "Create and load a journal file based on today's date."
  (interactive)
  (find-file (get-journal-file-today)))

(global-set-key (kbd "C-c f j") 'journal-file-today)

(defun journal-file-insert ()
  "Insert's the journal heading based on the file's name."
  (interactive)
  (insert (format-time-string
	   "#+TITLE: Journal Entry - %Y-%b-%d (%A)\n\n")))

(add-hook 'find-file-hook 'auto-insert)
(define-auto-insert "/[0-9]\\{8\\}\\.org$" [journal-file-insert])

(require 'ox-publish)
(setq org-publish-project-alist
      '(
	;; TODO: https://orgmode.org/worg/org-tutorials/org-publish-html-tutorial.html
	))

;; Global keybindings
(global-set-key (kbd "C-c t") 'toggle-truncate-lines)

;; change font size, interactively
(global-set-key (kbd "s-+") 'text-scale-increase)
(global-set-key (kbd "s-=") 'text-scale-increase)
(global-set-key (kbd "s--") 'text-scale-decrease)

;; Do not save autosave/swap files in current directory
;; Save all tempfiles in $TMPDIR/emacs$UID/ instead
(defconst emacs-tmp-dir (format "%s/%s%s/" temporary-file-directory "emacs" (user-uid)))

(setq backup-directory-alist
      `((".*" . ,emacs-tmp-dir)))
(setq auto-save-file-name-transforms
      `((".*" ,emacs-tmp-dir t)))
(setq auto-save-list-file-prefix
      emacs-tmp-dir)

(setq custom-file "~/.emacs.d/custom.el")
;; Revert Dired and other buffers
(setq global-auto-revert-non-file-buffers t)

;; Autorevert files (mandatory if working with VCS like git)
(global-auto-revert-mode t)
