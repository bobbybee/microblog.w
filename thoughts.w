model Session {
    User user;
}

model User {
    string username    readonly;
    string password    self private;

    User[] following   self;
    User[] followers  : Users.filter(u => u.following.has(this));

    Thought[] thoughts self;
    Thought[] feed    : following.map(u => u.thoughts).sort(t => t.date).reverse;
}

model Thought {
    User author  readonly;
    string body  readonly;
    Date date    readonly;
}

controller Session {
    user(string password)? -> user.password == hash(password);
}

controller Thought {
    author(Session s) = s.user;
    date(Date d)      = d;
}
