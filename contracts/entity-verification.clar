;; Entity Verification Contract
;; Stores and verifies business identities

(define-data-var admin principal tx-sender)

;; Map to store verified entities
(define-map verified-entities principal bool)

;; Function to verify an entity (only admin can call)
(define-public (verify-entity (entity principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u100))
    (ok (map-set verified-entities entity true))))

;; Function to check if an entity is verified
(define-read-only (is-verified (entity principal))
  (default-to false (map-get? verified-entities entity)))

;; Function to revoke verification
(define-public (revoke-verification (entity principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u100))
    (ok (map-set verified-entities entity false))))

;; Function to transfer admin rights
(define-public (set-admin (new-admin principal))
  (begin
    (asserts! (is-eq tx-sender (var-get admin)) (err u101))
    (ok (var-set admin new-admin))))
