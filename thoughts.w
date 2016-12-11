model Database -- User[] users appendonly;

model  Session -- User user;
verify Session -- write user(string pass) : user.password == hash(pass);

model User {
    string username const unique;
    string password private : password.hash;
    string bio;

    User[] following;
    User[] followers : Users[following.has(this)];

    Thought[] thoughts;
    Thought[] feed : following.thoughts.sort(date).reverse;
}

view User(Session s) {
    bool me        : this == s;
    bool following : followers.has(s.user);
} 

model Thought {
    User author  const : owner.user;
    string body  const;
    Date date    const fulfill(create);
}
