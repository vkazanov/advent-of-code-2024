;;; advent.el --- advent of code utils               -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Vladimir Kazanov

;; Author: Vladimir Kazanov <vekazanov@gmail.com>
;; Keywords: lisp

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; A set of little advent of code helpers, based on
;; https://github.com/keegancsmith/advent/

;;; Code:

(require 'url)

(defvar advent-dir
  (expand-file-name "~/projects-my/advent-of-code-2024/")
  "The directory you are doing advent of code in.")

(defvar advent-file-template
  (file-name-concat (expand-file-name advent-dir) "part1.lua.template")
  "A template for the first source of the day.")

(defvar advent-lib-template
  (file-name-concat (expand-file-name advent-dir) "aoc.lua")
  "A template for the util code.")

(defun advent-login (session)
  "Login to Advent of Code.
Argument SESSION - session cookie to use."
  (interactive "sValue of session cookie from logged in browser: ")
  (url-cookie-store "session" session "Thu, 25 Dec 2027 20:17:36 -0000" ".adventofcode.com" "/" t)
  (message "Cookie stored"))

(defun advent (&optional day)
  "Load todays adventofcode.com problem and input.
Optional argument DAY Load this day instead.  Defaults to today."
  (interactive "P")
  (let ((year (format-time-string "%Y"))
        (day (or day (advent--day))))
    (delete-other-windows)
    (split-window-right)
    (eww (format "https://adventofcode.com/%s/day/%d" year day))
    (advent-input day)
    (split-window-below)
    (advent-src day)))

(defun advent-submit (answer level &optional day)
  "Submits ANSWER for LEVEL to todays adventofcode.com problem.
Argument LEVEL is either 1 or 2.
Optional argument DAY is the day to submit for.  Defaults to today."
  (interactive
   (list
    ;; answer
    (let ((answer-default (advent--default-answer)))
      (read-string
       (cond
        ((and answer-default (> (length answer-default) 0))
         (format "Submit (default %s): " answer-default))
        (t "Submit: "))
       nil nil answer-default))
    ;; level
    (read-string "Level (1 or 2): ")))
  (let* ((year (format-time-string "%Y"))
         (day (or day (advent--day)))
         (url (format "https://adventofcode.com/%s/day/%d/answer" year day))
         (url-request-method "POST")
         (url-request-data (format "level=%s&answer=%s" level answer))
         (url-request-extra-headers '(("Content-Type" . "application/x-www-form-urlencoded"))))
    (eww-browse-url url)))

(defun advent-src (&optional day)
  "Open a file for DAY. If non-existant, use 'advent-file-template'
to create one."
  (interactive "P")
  (let* ((day (format "%d" (or day (advent--day))))
         (dir (file-name-concat (expand-file-name advent-dir) day))
         (bname (file-name-base advent-file-template))
         (file (file-name-concat dir bname)))
    (when (and (not (file-exists-p file))
               (file-exists-p advent-file-template))
      (mkdir dir t)
      (copy-file advent-file-template file)
      (copy-file advent-lib-template (concat dir "/")))
    (find-file file)))

(defun advent-input (&optional day)
  "Load adventofcode.com daily input.txt in other window.
Optional argument DAY Load this day instead.  Defaults to today."
  (interactive "P")
  (let* ((year (format-time-string "%Y"))
         (day (format "%d" (or day (advent--day))))
         (url (format "https://adventofcode.com/%s/day/%s/input" year day))
         (dir (file-name-concat (expand-file-name advent-dir) day))
         (file (file-name-concat dir "input.txt")))
    (if (not (file-exists-p file))
        (url-retrieve url 'advent--download-callback (list file))
      (find-file-other-window file))))

(defun advent--download-callback (status file)
  (if (plist-get status :error)
      (message "Failed to download todays advent %s" (plist-get status :error))
    (mkdir (file-name-directory file) t)
    (goto-char (point-min))
    (re-search-forward "\r?\n\r?\n")
    (write-region (point) (point-max) file)
    (find-file-other-window file)))

(defun advent--day ()
  (elt (decode-time (current-time) "America/New_York") 3))

(defun advent--default-answer ()
  "Use current region as a default answer."
  (and transient-mark-mode mark-active
       (/= (point) (mark))
       (buffer-substring-no-properties (point) (mark))))


(provide 'advent)
;;; advent.el ends here
