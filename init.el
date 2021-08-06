(setq inhibit-start-up-message t)

(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'tooltip-mode) (tooltip-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(set-fringe-mode 10) ;; give some breathing room

;; Set up the visible bell
(setq visible-bell t)

