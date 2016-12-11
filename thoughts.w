model Database -- User[] users appendonly;

model  Session -- User user nowrite;
verify Session -- user write(string pass) : user.password == hash(pass);

model User {
    string username readonly unique;
    string password private : hash(password);
    string bio;

    User[] following;
    User[] followers : Users[following.has(this))];

    Thought[] thoughts;
    Thought[] feed : following.thoughts.sort(date).reverse;
}

view User(Session s) {
    bool me        : this == s;
    bool following : followers.has(s.user);
} 

model Thought {
    User author  readonly : owner.user;
    string body  readonly;
    Date date    readonly fulfill(create);
}
