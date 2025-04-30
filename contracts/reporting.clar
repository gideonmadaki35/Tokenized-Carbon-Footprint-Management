;; Reporting Contract
;; Generates authenticated sustainability disclosures

(define-data-var admin principal tx-sender)

;; Structure for sustainability reports
(define-map reports
  { report-id: uint }
  { entity: principal,
    total-emissions: uint,
    total-offsets: uint,
    net-footprint: uint,
    timestamp: uint,
    verified: bool })

;; Counter for report IDs
(define-data-var report-counter uint u0)

;; Function to create a new report
(define-public (create-report
                (total-emissions uint)
                (total-offsets uint))
  (let ((report-id (var-get report-counter))
        (net-footprint (if (> total-emissions total-offsets)
                          (- total-emissions total-offsets)
                          u0)))
    (begin
      (var-set report-counter (+ report-id u1))
      (ok (map-set reports
                   { report-id: report-id }
                   { entity: tx-sender,
                     total-emissions: total-emissions,
                     total-offsets: total-offsets,
                     net-footprint: net-footprint,
                     timestamp: block-height,
                     verified: false })))))

;; Function to verify a report (only admin can verify)
(define-public (verify-report (report-id uint))
  (let ((report (unwrap! (map-get? reports { report-id: report-id }) (err u400))))
    (begin
      (asserts! (is-eq tx-sender (var-get admin)) (err u401))
      (ok (map-set reports
                   { report-id: report-id }
                   (merge report { verified: true }))))))

;; Function to get report details
(define-read-only (get-report (report-id uint))
  (map-get? reports { report-id: report-id }))
