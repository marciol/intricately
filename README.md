# README

This is a example of Rails project, to run it follow:

  1. Install ruby, the current project was created using ruby 2.6.3 installed through [asdf](https://github.com/asdf-vm/asdf-ruby).
  2. Install postgresql.
  3. Inside project directory run `bundle install`.
  4. Create database with `rake db:create && rake db:migrate` and populate it with `rake db:seed`

After that you can run the tests with `rake test` or run the app with `rails s`.

You can exercise the endpoints, running for example:

```
curl -X GET -g 'http://localhost:3000/api/v1/dns_records?include_hostnames[]=ipsum.com&include_hostnames[]=dolor.com&exclude_hostnames[]=sit.com&page=1'
```

That is all.
