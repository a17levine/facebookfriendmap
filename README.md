# Mutual Map

## Users are

People who check in but also Facebook friends who are slurped in from the API.


## Friendships are

A table of who is friends with who. There should only be one entry for each friendship. 

For example, for `user_id` and for `friend` they could be the flipped but represent the same relationship. This should be avoided by the code.


## Mutual friendships are

Each mutual friendship record is one friend that a user shares with one other person at the party.

`user_at_party` is the main user at the party in question
`user_at_party_2` is the other user at the party who has a mutual friend with `user_at_party`
`mutual_friend` is the friend that `user_at_party` shares with `user_at_party_2` but that person may not be at the party

Again, if you flipped `user_at_party` and `user_at_party_2`, you'd have the same relationship with two entries which would be bad. The code should avoid that.


## I should use this for my database in the future

[Neo4j](http://neo4j.com/graphacademy/online-course/)