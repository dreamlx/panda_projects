== README

Run this cmd, and import all data using SQL
```
rake db:drop; rake db:create; rake db:migrate VERSION=20150131150856
```

revise the database.yml and run:
```
rake db:create RAILS_ENV=production
```

run `rake secret`, the revise the belowed file
```
secrets.yml
```

run vi config/environments/production.rb
```
config.assets.compile = true
```

if GemNotFound
remove the `.ruby-version` and `.ruby-gemset` and reboot the system
then bundle it again.