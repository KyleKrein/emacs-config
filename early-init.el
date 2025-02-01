;;; -*- lexical-binding: t; -*-
(when (string-equal system-type "android")
  ;; Add Termux binaries to PATH environment
  (let ((termuxpath "/data/data/com.termux/files/usr/bin"))
    (setenv "PATH" (concat (getenv "PATH") ":" termuxpath))
    (setq exec-path (append exec-path (list termuxpath))))
  (let ((termuxlib "/data/data/com.termux/files/usr/lib"))
    (setenv "PATH" (concat (getenv "PATH") ":" termuxlib))
    (setq exec-path (append exec-path (list termuxlib)))
)

