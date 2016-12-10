model Database -- User[] users appendonly;

model      Session -- User user nowrite;
controller Session -- user write(string pass) => user.passHash == hash(pass);

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
