model Database {
    User[] users appendonly;
}

model Session {
    User user write?(string password => this.user.password == hash(password));
}

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

view User(Session s) {
    string follow-test : s.user.following.has(this) ? "Unfollow" : "Follow";
}

model Thought(Session creator) {
    User author  readonly : creator.user;
    string body  readonly;
    Date date    readonly (Date d)    : d;
}
