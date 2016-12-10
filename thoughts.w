model Database {
    User[] users appendonly;
}

/* there are a few approaches I see
 * 1) as it is right now
 * 2) use a controller to do the same
 * 3) define a custom keyboard
 * 4) define a function and a generic keyword-functor thingamajig closure lambda foo bar baz whiz bang boop { did i miss any buzzwords? }
 */

model Session {
    User user write?(authenticate); /* should this be a property of Session or User? */
}

controller User {
    bool authenticate(string password) = passHash == hash(password);
}

/* c.f. */

model Session {
    User user write?(authenticate);
}

controller Session {
    bool authenticate(User u, string password) = u.passHash == hash(password);
}

/* musings on functions in general: do they exist globally?
 * wings doesn't have real OOP anyway, defining something in a controller
 * just means that it takes that class as the first argument
 */

keyword myauth(string password) {
    bool read  : true;
    bool write : this.passHash == hash(password);
}

model Session -- User user myauth;

/* actually nvm that's repulsive */


/* unified model-controller might be okay: */

model Session {
    User user write(string password => authenticate(user, password));
}

/* or seperate */

model      Session -- User user nowrite;
controller Session -- user write(string pass) => user.passHash == hash(pass);

/* dunno what syntax you'd like for that, but you get the gist */

model User {
    string username    readonly unique;

    string password    destroy;
    string passHash    private : hash(p);

    string bio         self;

    User[] following   self;
    User[] followers : Users.filter(u => u.following.has(this));

    Thought[] thoughts self;
    Thought[] feed   : following.map(thoughts).sort(date).reverse;
}

view User {
    string follow-test : Session.user.following.has(this) ? "Unfollow" : "Follow";
}

model Thought {
    User author  readonly : owner.user;
    string body  readonly;
    Date date    readonly fulfill(create);
}
