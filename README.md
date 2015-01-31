This is our afternoon/evening project to get ROM and Roda working together.

To run this:

~~~ shell
bundle exec rackup
~~~

To test GET:

~~~ shell
curl -X GET http://localhost:9292/artist/1
~~~

To test updates:

~~~ shell
curl -X POST http://localhost:9292/artist/1 -d "name=John"
curl -X GET http://localhost:9292/artist/1
~~~

To test deletions:

~~~ shell
curl -X DELETE http://localhost:9292/artist/1
~~~

* Piotr Solnica (@solnic)
* Don Morrison (@elskwid)
* Craig Buchek (@booch)

