NHL Snapshot
=============

Midterm project for Lighthouse Labs - group members include Grant Bradshaw, Kay Cheng and Coleson Luterbach. Built in 2016, this application is now inactive - links to scrape
relevant data have changed, as have the relevant packages. The purpose of this project was to provide a tool for people who are not fans of the NHL to have a resource for talking
points about the league. I was personally responsible for the backend of the project, including models, web scraping / API hookins, and simple natural language processing.

Overview
--------

#### Sinatra
This application is built in Sinatra, interfacting with a MySQL database using Active Record. With a simple CRUD layout, users could view the the multiple data sources outlined below,
and with profiles, share collections of saved phrases and upvote others to filter the 'talking points' generated by our application.

#### Web Scraping
The Rakefile outlines multiple scraping jobs that were run on a daily basis while live - this allowed for up to date data on the following league data,
- A league overview of top teams, scorers, and goaltenders
- Team profiles, giving the team's rank, best players, results of their past game, and the next game on the schedule

This data was pulled both from JSON files generated by the NHL, and using Nokogiri to scrape web pages.

#### Twitter API
In addition to scraping the web pages outlined above, up to date information on the league was pulled from the Twitter API. This involved searching the most popular tweets about
the NHL and displaying them to users.

#### Talking Points
Finally, this project attempted to provide novel talking points to users. This was done in 2 ways,
- Manually, using sentence fragments found in 'app/words.json'. These fragments were manually input, and then randomly assembled to create sentences
- Using Markov Chains, with the 'Marky Markov' library. Temporary dictionaries were created using 400 of the most popular nhl tweets at that time, cleaning the tweets
of text like hashtages and user references.