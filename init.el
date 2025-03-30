;;; -*- lexical-binding: t; -*-
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.
;; See `package-archive-priorities` and `package-pinned-packages`.
;; Most users will not need or want to do this.
;; (add-to-list 'package-archives
;;              '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(org-babel-load-file
 (expand-file-name
  "config.org"
  user-emacs-directory))
(use-package edraw-org
  :ensure t
  ;;:after org
  :vc (:url "https://github.com/misohena/el-easydraw.git"
            :branch master))
