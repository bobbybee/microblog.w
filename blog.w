handleGET(url, session, fs, db) = dispatch(url):
    "/profile/{username}" -> viewProfile(session, fs, db, db.users[username]),
    "/login"              -> fs.login
    "/"                   -> fs.home

handlePOST(url, session, fs, db, query) = dispatch(url):
    "/login"              -> login(query, session, db)
    "/think"              -> think(session.user, query)
    "/bio"                -> changeBio(session.user, query)
    "/follow"             -> follow(session.user, query)
    "/unfollow"           -> unfollow(session.user, query)

viewProfile(session, fs, db, user) = profile(session, db, user).mustache(fs.profile)

profile(session, db, user) = {
    username: user.username, bio: user.bio,
    following: user.following, followers: db.users.filter(u => u.following.has(user)),

    authed: session.user?, me: user == session.user,

    follow: {
        action: "/follow" if session.user.following.has(user) else "/unfollow",
        text:   "Follow"  if session.user.following.has(user) else "Unfollow",
        target: user.username
    }
}

login(q, sess, db) = if validAuth(q, db): sess.set(user = db.users[q.username])
                                              .then(handleGET("/profile/" + q.username))
                     else:                "Bad login"

validAuth(query, db) = db.users[query.username].password == hash(query.password)

think(me, query)     = me.thoughts.append(query)
changeBio(me, query) = me.set(bio = query.bio)

follow(me, query)    = me.following.append(query.target)
unfollow(me, query)  = me.following.remove(query.target)

serve_http(get = handleGET, post = handlePOST)
