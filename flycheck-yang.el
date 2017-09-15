;;; flycheck-yang.el --- YANG flycheck checker
;; Copyright (c) 2016 Andrew Fort

;; Author: Andrew Fort (@andaru)
;; Version: 0.0
;; Package-Requires: ((yang-mode "0") (flycheck "0.18"))

;;; Commentary:
;; This package configures provides YANG syntax checking via flycheck
;; in Emacs using the pyang YANG parser[1].
;;
;; [1] https://github.com/mbj4668/pyang

;;;; Setup
;;
;; Add this to your Emacs configuration:
;;
;;   ;; autoload yang-mode for .yang files
;;   (autoload 'yang-mode "yang-mode" "Major mode for editing YANG modules." t)
;;   (add-to-list 'auto-mode-alist '("\\.yang\\'" . yang-mode))
;;
;;   ;; enable the YANG checker after flycheck loads
;;   (eval-after-load 'flycheck '(require 'flycheck-yang))
;;
;;   ;; ensure flycheck-mode is enabled in yang mode
;;   (add-hook 'yang-mode-hook
;;     (lambda () (flycheck-mode)))

;;; Code:

(require 'flycheck)

(defgroup flycheck-yang-pyang nil
  "Support for Flycheck in YANG via pyang"
  :group 'flycheck-yang)

(defcustom flycheck-yang-pyang-verbose nil
  "Validate the module(s) according to IETF rules."
  :type 'boolean
  :group 'flycheck-yang-pyang)

(defcustom flycheck-yang-pyang-ietf nil
  "Enable ietf output from pyang."
  :type 'boolean
  :group 'flycheck-yang-pyang)

(flycheck-define-checker yang-pyang
                         "A YANG syntax checker using the pyang parser."
                         :command ("pyang"
				   "--max-identifier-length=60"
				   (option-flag "-V" flycheck-yang-pyang-verbose)
				   (option-flag "--ietf" flycheck-yang-pyang-ietf)
				   source)
                         :error-patterns ((error line-start (file-name) ":"
                                                 line ": " "error: " (message) line-end)
					  (warning line-start (file-name) ":"
                                                 line ": " "warning: " (message) line-end))
                         :modes yang-mode
			 :error-filter
			 (lambda (errors)
			   (-> errors
			       flycheck-dedent-error-messages
			       flycheck-sanitize-errors)))


(add-to-list 'flycheck-checkers 'yang-pyang)

(provide 'flycheck-yang)

;;; flycheck-yang.el ends here
