;; Offset Verification Contract
;; Validates carbon reduction projects

(define-data-var admin principal tx-sender)

;; Structure for offset projects
(define-map offset-projects
  { project-id: uint }
  { owner: principal,
    name: (string-utf8 100),
    offset-amount: uint,
    verified: bool,
    verifier: (optional principal) })

;; Counter for project IDs
(define-data-var project-counter uint u0)

;; Function to register a new offset project
(define-public (register-offset-project
                (name (string-utf8 100))
                (offset-amount uint))
  (let ((project-id (var-get project-counter)))
    (begin
      (var-set project-counter (+ project-id u1))
      (ok (map-set offset-projects
                   { project-id: project-id }
                   { owner: tx-sender,
                     name: name,
                     offset-amount: offset-amount,
                     verified: false,
                     verifier: none })))))

;; Function to verify an offset project (only admin can verify)
(define-public (verify-offset-project (project-id uint))
  (let ((project (unwrap! (map-get? offset-projects { project-id: project-id }) (err u300))))
    (begin
      (asserts! (is-eq tx-sender (var-get admin)) (err u301))
      (ok (map-set offset-projects
                   { project-id: project-id }
                   (merge project
                          { verified: true,
                            verifier: (some tx-sender) }))))))

;; Function to get project details
(define-read-only (get-offset-project (project-id uint))
  (map-get? offset-projects { project-id: project-id }))
