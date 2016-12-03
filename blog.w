handleGET(url, session, fs, db) = dispatch(url):
    "/profile/{username}" -> profile(session, username, db),
    "/login"              -> fs.login
    "/"                   -> fs.home

handlePOST(url, session, fs, db, query) = dispatch(url):
    "/login"              -> login(query, session, db)
    "/think"              -> think(db.users[session.username], query)
    "/bio"                -> changeBio(db.users[session.username], query)

profile(username, session, db) = db.users[username].mustache(fs.profile)

login(q, sess, db) = if validAuth(q, db): sess.set(username = q.username)
                                              .set(authed = true)
                                              .then(profile(sess.username))
                     else:                "Bad login"

validAuth(query, db) = db.users[query.username].password == hash(query.password)

think(me, query)     = me.thoughts.append(query)
changeBio(me, query) = me.set(bio = query.bio)

serve_http(get = handleGET, post = handlePOST)
