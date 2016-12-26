(struct user (username password bio following thoughts))
(struct thought (author body date))

(define (user-followers user)
  (filter (lambda (k) (has? (user-following user) k)) Users))

(define (user-feed user)
  (map (lambda (u) (reverse (sort thought-date (user-thoughts u))))
       (user-following user)))

(define (view-user user session)
  (hash 'username   (user-username user)
        'bio        (user-bio user)
        'following  (user-following user)
        'followers  (user-followers user)
        'thoughts   (user-thoughts user)
        'me         (eq? user session)
        'following? (has? (user-following session) user)))

(define (new-thought session body)
  (thought session body (date)))

(define (verify-login user password)
  (= (user-password user) (secure-hash password)))

(map (ror-style-server (user thought) "config.yml") (http-requests 80))
