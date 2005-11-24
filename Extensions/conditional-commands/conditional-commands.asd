;; -*- Mode: Lisp; -*-

(in-package :common-lisp-user)

(asdf:defsystem conditional-commands
  :depends-on (:mcclim)
  :components ((:file "package")
               (:file "command-and-command-table-utilities" :depends-on ("package"))
               (:file "creating-assoc" :depends-on ("package"))
               (:file "entity-enabledness-handling" :depends-on ("command-and-command-table-utilities"
                                                                 "creating-assoc"))))
