Getting started
===============

Environment
-----------

Ruby 2.0.0

Rails 4.0.2

Configuration
-------------

Tokens for Facebook, AWS, and Bitly need to be requested from the author and added as environment variables locally.

You also need to be added to the Dev Facebook App for Time Auction if you are working with the Facebook OAuth component.

Database
--------

To set up databases in development and test environments:
```
bundle exec rake db:create db:migrate db:test:prepare
```

Testing
-------

To run entire suite just type:
```
rspec
```

Emails
------

In development mode, make sure to run the following command in terminal:
```
mailcatcher
```
You can see the "caught" emails by going to localhost:1080 in your browser.  Failure to do this may result in the error:

```
Errno::ECONNREFUSED: Connection refused - connect(2) for "localhost" port 1025
```

Confirming users
----------------

Devise's ```:confirmable``` setting is on, so confirmation emails will be sent with new signups (unless user signs up via Facebook OAuth).

To confirm, you can go into console and find your user, and type:

```
user.confirm!
```
Or, you can set the ```confirmed_at``` column to something like ```Time.current.to_datetime```

Alternatively, you can also simple follow the confirmation link in the email that is caught by the mailcatcher gem.

Other
-----

Enjoy! We hope you enjoy helping us improve the world - one volunteer hour at a time.