;; This sets up the load path so that we can override it
(package-initialize nil)

;;;; Load org in.
(require 'package)
(setq package-enable-at-startup nil)

(org-babel-load-file "~/.emacs.d/mathias.org")
