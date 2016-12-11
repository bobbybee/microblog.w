model Database -- appendonly User[] users;

model  Session -- User user;
verify Session -- user write(string pass) = user.password == hash(pass);

model User {
    const unique string username;
    private string password = hash(password);
    string bio;

    User[] following;
    User[] followers = Users[following.has(this)];

    Thought[] thoughts;
    Thought[] feed = following.thoughts.sort(date).reverse;
}

view User(Session s) {
    bool me        = this == s;
    bool following = followers.has(s.user);
} 

model Thought {
    const User author = owner.user;
    const string body;
    const Date date fulfill(create);
}
