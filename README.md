# theScore "the Rush" Interview Challenge
At theScore, we are always looking for intelligent, resourceful, full-stack developers to join our growing team. To help us evaluate new talent, we have created this take-home interview question. This question should take you no more than a few hours.

**All candidates must complete this before the possibility of an in-person interview. During the in-person interview, your submitted project will be used as the base for further extensions.**

### Why a take-home challenge?
In-person coding interviews can be stressful and can hide some people's full potential. A take-home gives you a chance work in a less stressful environment and showcase your talent.

We want you to be at your best and most comfortable.

### A bit about our tech stack
As outlined in our job description, you will come across technologies which include a server-side web framework (like Elixir/Phoenix, Ruby on Rails or a modern Javascript framework) and a front-end Javascript framework (like ReactJS)

### Challenge Background
We have sets of records representing football players' rushing statistics. All records have the following attributes:
* `Player` (Player's name)
* `Team` (Player's team abbreviation)
* `Pos` (Player's postion)
* `Att/G` (Rushing Attempts Per Game Average)
* `Att` (Rushing Attempts)
* `Yds` (Total Rushing Yards)
* `Avg` (Rushing Average Yards Per Attempt)
* `Yds/G` (Rushing Yards Per Game)
* `TD` (Total Rushing Touchdowns)
* `Lng` (Longest Rush -- a `T` represents a touchdown occurred)
* `1st` (Rushing First Downs)
* `1st%` (Rushing First Down Percentage)
* `20+` (Rushing 20+ Yards Each)
* `40+` (Rushing 40+ Yards Each)
* `FUM` (Rushing Fumbles)

In this repo is a sample data file [`rushing.json`](/rushing.json).

##### Challenge Requirements
1. Create a web app. This must be able to do the following steps
    1. Create a webpage which displays a table with the contents of [`rushing.json`](/rushing.json)
    2. The user should be able to sort the players by _Total Rushing Yards_, _Longest Rush_ and _Total Rushing Touchdowns_
    3. The user should be able to filter by the player's name
    4. The user should be able to download the sorted data as a CSV, as well as a filtered subset
    
2. The system should be able to potentially support larger sets of data on the order of 10k records.

3. Update the section `Installation and running this solution` in the README file explaining how to run your code

### Submitting a solution
1. Download this repo
2. Complete the problem outlined in the `Requirements` section
3. In your personal public GitHub repo, create a new public repo with this implementation
4. Provide this link to your contact at theScore

We will evaluate you on your ability to solve the problem defined in the requirements section as well as your choice of frameworks, and general coding style.

### Help
If you have any questions regarding requirements, do not hesitate to email your contact at theScore for clarification.

### Installation and running this solution

##### Requirements

- Mongodb is running, at the default port `27017`, on ubuntu/debian start it via `sudo systemctl start mongod`
- Ruby 2.7 or higher
- ruby gem `puma` or similar rack http server gem

##### Starting the server
- start the server via `puma config.ru`, by default it runs on port 9292
- (during development shotgun can be used as well `shotgun --server=puma --port=9292 config.ru`)
- navigate to `http://localhost:9292/v1/players` in the browser
- optionally navigate to `http://localhost:9292/doc` for swagger docs (even though the json api is not used)

### Brief notes on framework choice

##### Why Mongodb?
- we're optimizing for reads, there's no realtime update of player records in the requirements
- there's only one entity type in the data, we literally documents fit for a document db
- we only need to simple filter (search) and sort, mongodb can provide simple indexing for text search
- conversely, we don't need transactionals and relational joins so we don't need a sql database for this

##### Why Grape instead of Rails/Sinatra?
- we only need to implement 2-3 endpoints, and initially I started off with the assumption that we only need to implement simple query responses in json
- we're using mongo so we don't need to whole ActiveRecord ORM or full blown MVC like rails (though rails has API mode)
- lightweight and sits right on top of rack
- easy to switch to rendering html when the need arose, with slim being the template library as well

##### Why htmx for frontend?
- a backend developer is being asked to implement a full stack solution in a few hours :)
- it is in some ways a cleaner, more declarative way of routing ajax calls to insert/replace elements in the DOM, a PJAX pattern like turbolinks or Phoenix LiveView so I have heard
- we don't have a lot of dynamic or complicated frontend calls, each command is one button press that fires a GET request to the server no json body payload
- no need to use javascript to assemble rest calls since they're so simple (by design) and the response are almost just the table of data as well


##### Caveats
-  Will explain in interview :)  but it's still pretty clunky, given more time to experiement I would still use React and picky up prettier UI framework
-  As they say, if you start with Sinatra or similarly minimal frameworks for Ruby, eventually you'll end up building Rails anyway :)


Overall, for something more serious, we should probably use Rails and React, or maybe even something more that can perform better, with more security out of the box, but I intentionally picked a minimal framework for the scope of this assignment.