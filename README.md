# CoolNestedForms
[![Gem Version](https://badge.fury.io/rb/cool_nested_forms.svg)](https://badge.fury.io/rb/cool_nested_forms)        

Add Nested Forms to your Forms. Currently tested with a depth of 2.
For example a Form can add an Item and this Item can add a sub Item.
It can probably support longer nests but I haven't tested it yet.

By the way, this is intended to simplify adding the javascript required to add form_field dynamically while following form builder conventions. What that means is that there is some work to be done in the form of configuring models and controllers and adding a couple of views.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cool_nested_forms'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install cool_nested_forms

Then require the javascript in your app/assets/javascripts/application.js
```javascript
//= require cool_nested_forms
```

## Usage Example
For this example I will use Job and Task models

### Preparing your models

#### Job Model
```ruby
class Job < ActiveRecord::Base
  has_many :tasks, :dependent => :destroy
  # :name is required - User your own required field here
  accepts_nested_attributes_for :tasks, :reject_if => lambda { |a| a[:name].blank? }, :allow_destroy => true
end
```
#### Task Model
```ruby
class Task < ActiveRecord::Base
  belongs_to :job
end
```
### Preparing the Job Controller
```ruby
class JobsController < ApplicationController

  # other code #

  def job_params
    # :id and :_destroy are required. Substitute name with your own fields
    params.require(:job).permit(:name,
      :tasks_attributes => [:id, :name, :_destroy])
  end
end
```
### The view used to generate tasks
Due to laziness remove_child_button needs to be nested right under the containing div. this will be fixed in the next version.
app/views/jobs/_task.html.rb
```html
<div>
  <%= remove_child_button "Remove" %>
  <%= f.hidden_field :_destroy, :class => 'removable' %>

  <%= f.label :name %>
  <%= f.text_field :name %>
</div>
```

## Adding functionality to the Job form
app/views/jobs/_form.html.erb
```html
  <%= form_for(@job) do |f| %>


    <!-- your other job fields go here -->


    <!-- this generates a template for javascript -->  
    <%= new_fields_template f, :tasks, {object: Tasks.new, :template => "tasks_#{f.object.id}_fields"} %>  
    <!-- this generates a button that adds a task into    <div id="tasks_<%=f.object.id%>"> -->  
    <%= add_child_button "Add Task", :tasks, "tasks_#{f.object.id}", "tasks_#{f.object.id}", "<your-css-classes>" %>  

    <div id="tasks_<%=f.object.id%>">
      <%= f.fields_for :tasks, @job.tasks do |builder| %>
        <%= render "task", :f => builder %>
      <% end %>
    </div>

  <%end%>
```

### After add/remove events
If you need to perform any other javascript actions after a child is added or removed, you can add a listener to these events
```javascript
coolNestedForms.childAdded
coolNestedForms.childRemoved
```
Something like this
```javascript
$(document).bind('coolNestedForms.childAdded', function(){
  // do something
});
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cool_nested_forms. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
