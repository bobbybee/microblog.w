model Database -- User[] users appendonly;

model  Session -- User user nowrite;
verify Session -- user write(string pass) => user.password == hash(pass);

model User {
    string username    readonly unique;
    string password  : hash(password);
    string bio         self;

    User[] following   self;
    User[] followers : Users.filter(following.has(this));

    Thought[] thoughts self;
    Thought[] feed   : following.map(thoughts).sort(date).reverse;
}

view User -- string followText : followers.has(Session.user) ? "Unfollow" : "Follow";

model Thought {
    User author  readonly : owner.user;
    string body  readonly;
    Date date    readonly fulfill(create);
}
