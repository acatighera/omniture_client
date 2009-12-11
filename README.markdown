# OmnitureClient
General description

## Installation
    gem install omniture_client

## Omniture on Rails
This gem provides the ability to track a Rails application at the controller level. I prefer a completely sever-side implementation as opposed to using Omniture's s_code.js. This gem supports using both; however, the majority of the examples will be for a completely 

### File Structure
You create reporters in 'app/reporters' directory, which correspond to your controllers. The example I will use is a `MoviesController`. Omniture client will first attempt to use `MoviesReporter`. If you have not defined the `MoviesReporter`, then it will use the `BasicReporter`, which is what all controllers that do not have any special functionality should use. If you have not yet defined a `BasicReporter`, then it will use a stub that tracks nothing. You will pretty much always at least want a basic reporter, and for controllers that need to track special events or custom variables you should use a custom reporter.
    rails_project/
    ..../app
    ......../reporters
    ............/movies_reporter.rb
    ............/basic_reporter.rb
    ..../config
    ......../omniture.yml


### Configuration
You must configure the Omniture namespace, suite(s), version that you wish to use. Optionally, you can set up aliases to make things easier for yourself when coding reporters. Omniture uses `c1`, `e1`, `r`, etc to represent custom variables, e_vars, the referrer, etc. These param names are obscure and can be hard to remember so you can set up aliases for them. From the example below `movie_title` repersents custom varibale 2 (`c2`).
    # config/omniture.yml
    development:
      base_url: http://102.112.2O7.net
      ssl_url: https://102.112.2O7.net
      suite: suite1
      version: G.4--NS
      aliases:
        search_term: c1
        movie_titles: c2
        referrer: r

As well as the omniture.yml you need to also add the `app/reporters` directory to your load path. So in your enviroment file add the 2 following lines:
    # config/enviroment.rb
    Rails::Initializer.run do |config|
      config.load_paths += %W( #{RAILS_ROOT}/app/reporters )
      config.gem "omniture_client"
    end

### Implementation
Here is an example of a controller we would like to track:
    # app/controller/movies_controller.rb
    class MoviesController < ApplicationController
      def index
        @movies = Movie.all
      end

      def show
        @movie = Movie.find(params[:id])
      end

      def search
        @keyword = params[:keyword]
        @movies = Movie.search(@keyword)
      end

      def new
        @movie = Movie.new
      end

      def create
        @movie = Movie.new(params[:movie])
        if @movie.save
          flash[:notice] = 'Movie was successfully created.'
          omniture_flash[:events] = 'event6'        
          redirect_to(@movie)
        else
          render :action => "new"
        end
      end
    end

Reporters have access to all controller instance variables and methods. Below we use the `@movie` instance variable and `request` instance method which are from the controller instance. Also, be aware of the omniture.yml configuration, `:search_term` and `movie_titles` are aliases specific to this movies example. In your app you will want to use `c1` and `c2` or set up your own aliases in your omniture.yml. 

    class MoviesReporter < OmnitureClient::Base
      var :pageName do 
        page_name = "Movie Page"
      end

      # We can use any instance methods from the controller, here we use the `request` method
      var :r do
        request.referrer
      end

      # trigger event5 if user is doing a search and trigger event6 if movie is R rated
      var :events do
        events = []
        events << 'event5' if action_name == 'search' && @keyword
        events << 'event6' if action_name == 'show' && @movie.rating == "R"
        events
      end

      var :search_term do
        @keyword if action_name == 'search'
      end    
      
      # list prop that is delimited by |
      var :movie_titles, '|' do
        @movies.map{ |movie| movie.title } if action_name == 'index'
      end
    end

The `pageName` param is extremely important param, the most important in fact. The `r` param which represents the referrer is also very important. The page name will default the the URL if you do not specify it, which is probably what you do not want. For the purposes of simiplicity I made the page name simple but in reality you will want it to be something like this:
    var :pageName do 
      case action_name
        when 'show' : "Movie - #{@movie.title}"
        when 'index' : "Movie List Page"
        when 'new' : "Movie Create Page"
      end
    end

#### 

### Server-side events

## Omniture Client for Sinatra (or other ruby web framework)


## Javascript Implementation

### Configuration
