;; Music Rights and Royalty Distribution Contract in Clarity 6.0
;; Contract Name: music-royalties.clar
;; This smart contract enables the registration, management, and transfer of music rights 
;; and royalty data. It also facilitates the secure distribution of royalties 
;; and ownership transfers for registered music rights.

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

;; -------------------- Private Functions -------------------------

;; Verifies if the given sender is the owner of the specified music right
(define-private (is-right-owner (right-id uint) (sender principal))
    (is-eq sender (unwrap! (map-get? right-owners right-id) false)))

;; Validates the format and length of royalty data
(define-private (is-valid-royalty-data (data (string-ascii 256)))
    (let ((data-length (len data)))
        (and (>= data-length u1)  ;; Data must not be empty
             (<= data-length max-royalty-data-length))))  ;; Data must not exceed maximum length

;; Checks if a principal is valid (assumes all principals are valid)
(define-private (is-valid-principal (p principal))
    true)

;; Registers a single music right and assigns its ownership to the caller
(define-private (register-single-right (royalty-data (string-ascii 256)))
    (let ((right-id (+ (var-get last-right-id) u1)))
        (try! (nft-mint? music-right right-id tx-sender)) ;; Mint the NFT for the caller
        (map-set royalty-data-map right-id royalty-data)  ;; Store royalty data
        (map-set right-owners right-id tx-sender)         ;; Assign ownership
        (var-set last-right-id right-id)                 ;; Update the last-right-id variable
        (ok right-id)))

;; --------------------- Public Functions -------------------------

;; Registers a new music right with the provided royalty data
(define-public (register-right (royalty-data (string-ascii 256)))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-owner-only)         ;; Only contract owner can register
        (asserts! (is-valid-royalty-data royalty-data) err-invalid-royalty-data) ;; Validate data
        (register-single-right royalty-data)))                            ;; Register the music right

;; Transfers ownership of a music right to a new owner
(define-public (transfer-right (right-id uint) (new-owner principal))
    (begin
        (asserts! (is-right-owner right-id tx-sender) err-unauthorized)   ;; Verify sender is the owner
        (asserts! (is-valid-principal new-owner) err-invalid-new-owner)  ;; Validate new owner
        (try! (nft-transfer? music-right right-id tx-sender new-owner))  ;; Transfer NFT ownership
        (map-set right-owners right-id new-owner)                        ;; Update ownership map
        (ok true)))

;; Updates the royalty data for an existing music right
(define-public (update-royalty-data (right-id uint) (new-data (string-ascii 256)))
    (begin
        (asserts! (is-right-owner right-id tx-sender) err-unauthorized)  ;; Verify sender is the owner
        (asserts! (is-valid-royalty-data new-data) err-invalid-royalty-data) ;; Validate new data
        (map-set royalty-data-map right-id new-data)                    ;; Update royalty data
        (ok true)))

(define-public (revoke-right (right-id uint))
(begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)   ;; Only contract owner can revoke
    (asserts! (is-some (map-get? right-owners right-id)) err-right-not-found) ;; Ensure right exists
    (map-delete right-owners right-id)                          ;; Remove ownership
    (ok true)))

(define-public (register-multiple-rights (royalty-data-list (list 10 (string-ascii 256))))
(begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (map register-single-right royalty-data-list)
    (ok true)))

(define-public (is-caller-owner)
(ok (is-eq tx-sender contract-owner)))

(define-public (get-last-registered-right-id)
(ok (var-get last-right-id)))

(define-public (is-caller-contract-owner)
(ok (is-eq tx-sender contract-owner)))

(define-public (is-right-registered? (right-id uint))
(ok (is-some (map-get? right-owners right-id))))


;; -------------------- Read-Only Functions -----------------------

;; Retrieves the royalty data for a specific music right
(define-read-only (get-royalty-data (right-id uint))
    (ok (map-get? royalty-data-map right-id)))

;; Retrieves the owner of a specific music right
(define-read-only (get-owner (right-id uint))
    (ok (map-get? right-owners right-id)))

;; Checks if a music right with the given ID exists
(define-read-only (right-exists (right-id uint))
    (ok (map-get? right-owners right-id)))

;; Retrieves the ID of the last registered music right
(define-read-only (get-last-right-id)
    (ok (var-get last-right-id)))

(define-read-only (is-right-registered (right-id uint))
(ok (is-some (map-get? right-owners right-id))))

(define-read-only (get-total-rights)
(ok (var-get last-right-id)))

(define-read-only (get-total-registered-rights)
(ok (var-get last-right-id)))

(define-read-only (is-right-owned (right-id uint))
  (ok (is-some (map-get? right-owners right-id))))

(define-read-only (get-owner-of-right (right-id uint))
(ok (map-get? right-owners right-id)))

(define-read-only (right-does-exist (right-id uint))
(ok (is-some (map-get? right-owners right-id))))

(define-read-only (get-all-registered-rights)
(ok (var-get last-right-id)))

(define-read-only (count-registered-rights)
(ok (var-get last-right-id)))

;; ------------------ Contract Initialization ---------------------

;; Initialize the contract by setting the last-right-id variable
(begin
    (var-set last-right-id u0))
