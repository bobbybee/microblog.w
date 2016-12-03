handleGET(url, session, fs, db) = dispatch(url):
    "/profile/{username}" -> profile(session, username, db),
    "/login"              -> fs.login
    "/"                   -> fs.home

handlePOST(url, session, fs, db, query) = dispatch(url):
    "/login"              -> login(query, session, db)
    "/think"              -> think(query, session, db)

profile(username, session, db) = db.users[username].mustache(fs.profile)

login(query, session, db) = if validAuth(query, db)
    then session.set(username = query.username).then(profile(session.username))
    else "Bad login"

validAuth(query, db) = db.users[query.username]
                    && hash(query.password) == db.users[query.username]

think(query, session, db) = db.users[query.username].thoughts.append(query)

serve_http(get = handleGET, post = handlePOST)
