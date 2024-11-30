;; Music Rights and Royalty Distribution Contract in Clarity 6.0
;; This smart contract enables the registration, management, and transfer of music rights 
;; and royalty data. 
;; --------------------------- Constants ---------------------------

;; The principal that owns and controls the contract
(define-constant contract-owner tx-sender)

;; Error codes for different failure cases
(define-constant err-owner-only (err u200))               ;; Caller is not the contract owner
(define-constant err-unauthorized (err u201))             ;; Unauthorized action attempted
(define-constant err-invalid-royalty-data (err u202))     ;; Royalty data is invalid
(define-constant err-right-already-registered (err u203)) ;; Music right is already registered
(define-constant err-right-not-found (err u204))          ;; Music right does not exist
(define-constant err-invalid-new-owner (err u205))        ;; Provided new owner is invalid

;; Maximum allowable length for royalty data
(define-constant max-royalty-data-length u256)

;; ---------------------- Data Variables --------------------------

;; Non-fungible token representing unique music rights
(define-non-fungible-token music-right uint)

;; Tracks the ID of the last registered music right
(define-data-var last-right-id uint u0)

;; --------------------------- Maps -------------------------------

;; Stores royalty metadata for each music right
(define-map royalty-data-map uint (string-ascii 256))

;; Tracks the ownership of each music right by its ID
(define-map right-owners uint principal)

;; 