model Database -- User[] users appendonly;

model  Session -- User user nowrite;
verify Session -- user write(string pass) => user.password == hash(pass);

view Session {
    Thought[] feed : user.following.map(thoughts).sort(date).reverse;
}

model User {
    string username    readonly unique;
    string password  : hash(password);
    string bio;

    User[] following;
    User[] followers : Users.filter(following.has(this));

    Thought[] thoughts;
}

view User(Session s) {
    bool me         : this == s;
    bool following  : followers.has(s.user);
} 

model Thought {
    User author  readonly : owner.user;
    string body  readonly;
    Date date    readonly fulfill(create);
}
