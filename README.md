# README

Start solid_queue

``` shell
bundle exec rake solid_queue:star
```

Watch the logs
``` shell
tail -f log/development.log
```

Run some jobs
``` shell
echo '10.times { ::Rails.application.dynflow.world.plan_elsewhere(Counter, 100) }' | bundle exec rails console
```
