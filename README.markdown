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
You must configure the Omniture namespace, suite(s), version that you wish to use. Optionally, you can set up aliases to make things easier for yourself when coding reporters. Omniture uses `c1`, `e1`, `r`, etc for custom variables, e_vars, the referrer, etc. These param names are obscure and can be hard to remember so you can set up aliases for them. From the example below `movie_title` repersents custom varibale 2 (c2).
    #config/omniture.yml
    development:
      base_url: http://102.112.2O7.net
      ssl_url: https://102.112.2O7.net
      suite: suite1
      version: G.4--NS
      aliases:
        search_terms: c1
        movie_title: c2

### Impletmenation

#### 

### Server-side events

## Omniture on Sinatra (or other ruby web framework)


## Javascript Implementation

