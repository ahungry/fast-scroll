;;; fast-scroll.el --- Some utilities for faster scrolling over large buffers. -*- lexical-binding: t; -*-

;; Copyright (C) 2019 Matthew Carter <m@ahungry.com>

;; Author: Matthew Carter <m@ahungry.com>
;; Maintainer: Matthew Carter <m@ahungry.com>
;; URL: https://github.com/ahungry/fast-scroll
;; Version: 0.0.1
;; Keywords: ahungry fast scroll scrolling
;; Package-Requires: ((emacs "25.1"))

;; This file is NOT part of GNU Emacs.

;;; License:

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; An enhanced scrolling experience when quickly navigating through a buffer
;; with fast scrolling (usually via key-repeat instead of manual scrolling).

;;; Code:

;; Fix for slow scrolling

(defvar fast-scroll-mode-line-original mode-line-format)
(defvar fast-scroll-pending-reset nil)
(defvar fast-scroll-timeout 0)

(defun fast-scroll-default-mode-line ()
  "An Emacs default/bare bones mode-line."
  (list "%e" mode-line-front-space
        mode-line-client
        mode-line-modified
        mode-line-frame-identification
        mode-line-buffer-identification "   "
        mode-line-position
        "  " mode-line-modes mode-line-misc-info mode-line-end-spaces))

(defun fast-scroll-get-milliseconds ()
  "Get the current MS in float up to 3 precision."
  (read (format-time-string "%s.%3N")))

(defun fast-scroll-end? ()
  "See if we can end or not."
  (> (- (fast-scroll-get-milliseconds) fast-scroll-timeout) 0.04))

(defun fast-scroll-end ()
  "Re-enable the things we disabled during the fast scroll."
  (when (fast-scroll-end?)
    (setq mode-line-format fast-scroll-mode-line-original)
    (font-lock-mode 1)))

(defun fast-scroll-up ()
  "Enables lightning fast scrolling up/down by disabling certain
  modes that can frequently cause a slow down during scrolling."
  (interactive)
  (setq fast-scroll-timeout (fast-scroll-get-milliseconds))
  (setq mode-line-format (fast-scroll-default-mode-line))
  (font-lock-mode 0)
  (ignore-errors (scroll-up-command))
  (run-at-time 0.05 nil #'fast-scroll-end))

(defun fast-scroll-down ()
  "Enables lightning fast scrolling up/down by disabling certain
  modes that can frequently cause a slow down during scrolling."
  (interactive)
  (setq fast-scroll-timeout (fast-scroll-get-milliseconds))
  (setq mode-line-format (fast-scroll-default-mode-line))
  (font-lock-mode 0)
  (ignore-errors (scroll-down-command))
  (run-at-time 0.05 nil #'fast-scroll-end))

;;;###autoload
(defun fast-scroll-config ()
  "Load some config defaults / binds."
  (global-set-key (kbd "<prior>") 'fast-scroll-down)
  (global-set-key (kbd "<next>") 'fast-scroll-up))

(provide 'fast-scroll)
;;; fast-scroll.el ends here
