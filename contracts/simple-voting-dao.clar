;; simple-voting-dao.clar
;; Purpose: A basic decentralized voting system on Stacks
;; License: MIT

;; -----------------------------
;; Data Structures
;; -----------------------------

;; Proposal storage
(define-map proposals
  {id: uint}
  {creator: principal,
   title: (string-ascii 64),
   yes-votes: uint,
   no-votes: uint,
   end-block: uint,
   closed: bool})

;; Track who has voted on what
(define-map votes
  {proposal-id: uint, voter: principal}
  {voted: bool})

;; DAO admin (deployer)
(define-data-var dao-admin principal tx-sender)

;; -----------------------------
;; Error Codes
;; -----------------------------

(define-constant ERR-NOT-ADMIN u100)
(define-constant ERR-PROPOSAL-EXISTS u101)
(define-constant ERR-PROPOSAL-NOT-FOUND u102)
(define-constant ERR-VOTING-CLOSED u103)
(define-constant ERR-ALREADY-VOTED u104)

;; -----------------------------
;; Admin Functions
;; -----------------------------

;; Create a new proposal
(define-public (create-proposal (id uint) (title (string-ascii 64)) (duration uint))
  (if (not (is-eq tx-sender (var-get dao-admin)))
      (err ERR-NOT-ADMIN)
      (if (is-some (map-get? proposals {id: id}))
          (err ERR-PROPOSAL-EXISTS)
          (begin
            ;; Fixed map-set syntax to use proper curly brace tuple notation
            (map-set proposals {id: id}
              {creator: tx-sender,
               title: title,
               yes-votes: u0,
               no-votes: u0,
               end-block: (+ stacks-block-height duration),
               closed: false})
            (ok true)))))

;; -----------------------------
;; Voting Functions
;; -----------------------------

;; Vote YES or NO on a proposal
(define-public (vote (id uint) (support bool))
  ;; Fixed match syntax to correct order: (match input success-binding success-expr none-expr)
  (match (map-get? proposals {id: id})
    proposal
      (begin
        (if (>= stacks-block-height (get end-block proposal))
            (err ERR-VOTING-CLOSED)
            (if (is-some (map-get? votes {proposal-id: id, voter: tx-sender}))
                (err ERR-ALREADY-VOTED)
                (begin
                  ;; Fixed map-set syntax for votes and proposals using proper tuple notation
                  (map-set votes {proposal-id: id, voter: tx-sender} {voted: true})
                  (map-set proposals {id: id}
                    {creator: (get creator proposal),
                     title: (get title proposal),
                     yes-votes: (if support (+ (get yes-votes proposal) u1) (get yes-votes proposal)),
                     no-votes: (if support (get no-votes proposal) (+ (get no-votes proposal) u1)),
                     end-block: (get end-block proposal),
                     closed: false})
                  (ok true)))))
    (err ERR-PROPOSAL-NOT-FOUND)))

;; -----------------------------
;; Read-Only Functions
;; -----------------------------

;; Get proposal details
(define-read-only (get-proposal (id uint))
  (map-get? proposals {id: id}))

;; Check if voting has ended
(define-read-only (voting-ended (id uint))
  ;; Fixed match syntax to correct order
  (match (map-get? proposals {id: id})
    proposal (>= stacks-block-height (get end-block proposal))
    false))
