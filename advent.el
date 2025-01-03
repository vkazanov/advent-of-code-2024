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
  (file-name-concat (expand-file-name advent-dir) "template.lua")
  "A template for the first source of the day.")

(defvar advent-lib-template
  (file-name-concat (expand-file-name advent-dir) "aoc.lua")
  "A template for the util code.")

(defvar advent-submit-level-history nil
  "History of level submission.")

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
    (eww (format "https://adventofcode.com/%s/day/%d" year day))
    (advent-src day)
    (advent-input day)
    (switch-to-buffer "*eww*")))

(defun advent-submit (answer level &optional day)
  "Submits ANSWER for LEVEL to todays adventofcode.com problem.
LEVEL - either 1 or 2.
DAY - day to submit (Defaults to today)."
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
    (let ((default-level (or (car advent-submit-level-history) "1")))
      (read-string (format "Level (%s): " default-level)
                   nil 'advent-submit-level-history default-level))))
  (let* ((year (format-time-string "%Y"))
         (day (or day (advent--day)))
         (url (format "https://adventofcode.com/%s/day/%d/answer" year day))
         (url-request-method "POST")
         (url-request-data (format "level=%s&answer=%s" level answer))
         (url-request-extra-headers '(("Content-Type" . "application/x-www-form-urlencoded"))))
    (eww-browse-url url)))

(defun advent-src (&optional day)
  "Open a file for DAY.
If non-existant, use `advent-file-template' to create one."
  (interactive "P")
  (let* ((day (format "%d" (or day (advent--day))))
         (dir (file-name-concat (expand-file-name advent-dir) day))
         (file1 (file-name-concat dir "part1.lua"))
         (file2 (file-name-concat dir "part2.lua")))
    (when (and (not (file-exists-p file1))
               (file-exists-p advent-file-template))
      (mkdir dir t)
      (copy-file advent-file-template file1)
      (copy-file advent-file-template file2)
      (copy-file advent-lib-template (concat dir "/")))
    (find-file file1)))

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
  "Save the results retrieved to a specified FILE.
STATUS - request status."
  (if (plist-get status :error)
      (message "Failed to download todays advent %s" (plist-get status :error))
    (mkdir (file-name-directory file) t)
    (goto-char (point-min))
    (re-search-forward "\r?\n\r?\n")
    (write-region (point) (point-max) file)
    (find-file-other-window file)))

(defun advent--day ()
  "Return current day as a number based on the correct time zone."
  (elt (decode-time (current-time) "America/New_York") 3))

(defun advent--default-answer ()
  "Use current region as a default answer."
  (and transient-mark-mode mark-active
       (/= (point) (mark))
       (buffer-substring-no-properties (point) (mark))))


(provide 'advent)
;;; advent.el ends here
