# Peak List: an Ascent-Tracking application

A ascent-tracking application for climbs of [Colorado's Fourteeners](http://www.14ers.com).

Built using Sinatra and Bootstrap for styling. Inspired by [Lists of John](http://www.listsofjohn.com) and [Peakbagger](http://www.peakbagger.com).

Deployed on Heroku at http://marktrumpet-peaklist.herokuapp.com. Peak List uses a postgreSQL database for tracking data. Have fun playing around!

#### Features:
- Sign Up, passwords hashed using [BCrypt](https://github.com/codahale/bcrypt-ruby).
- Sign In
- View a list of your ascents and peaks climbed.
- Log Ascents, date and comments
- Edit ascent date and comments (you may only edit your own ascents)
- Delete ascents
- View sortable lists of Peaks, Ascents, and Users
- On Peaks page, shows numbered badges for peaks climbed
- On an individual peak's page, shows all logged ascents for that peak.
- Ascents are public, but can only be edited and deleted by its user.

#### Future Features:
- Delete users
- Change passwords
- Add user profile info
- Add peaks or edit peak data
- Upload images for ascents
