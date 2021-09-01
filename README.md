# AutoScaling Platform
The auto-scaling platform enables better auto scaling between the three type of jobs i.e priority, misc, and higher.

## Dependencies
- Ruby 2.7.3
- Rails 6.1.4.1
- sqlite3
- sidekiq 6.2.2

## To setup project
- Install deps using `bundle install`
- Copy `config/application.example.yml` to `config/application.yml` after running `bundle exec figaro install`
- Setup DB using `rails db:setup`
- Run `bundle exec sidekiq` at project root and go to rake tasks and saw rake files

## Lint
- `rubocop`

## Assumptions/considerations
* Currently there is 10 threads for single worker instance
  * Three types of jobs priority, misc and heavy
  * Autoscalar run to manage the priority jobs if it is found in a queue and it will create new worker instance.

## Answers to additional questions
If no priority job exists then our autoscalar task run to verify and remove the extra obsolete running worker instances.

Example Considerations:
* If all 10 threads in a worker are busy executing jobs 1.e 3 priority jobs, 3 misc jobs, 4 heavy jobs.
* If new jobs are enqueued within 5 minutes, auto-scalar will initiate a new worker.
* We have a rake task that terminates idle instances.

### Example tasks
#### Task to perform the autoscaling
- rake autoscale:scale_servers
#### Task to create the jobs
- rake autoscale:create_and_enqueue_jobs
#### Task to create the jobs on EC2
- rake autoscale:create_and_enqueue_jobs
#### Task to perform the autoscaling on EC2
- rake autoscale:scale_ec2_servers
#### Task to emilinate the idle worker instances on development
-  rake autoscale:terminate_idle_instances
#### Task to emilinate the idle worker instances on EC2
-  rake autoscale:terminate_ec2_idle_instances
