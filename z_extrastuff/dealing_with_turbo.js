    //add to application.js to turn off turbo

    <script>    
      document.querySelectorAll('form').forEach(function (el) {    
                el.dataset.turbo = false    
      })    
    </script>


// removed from layout.html.erb
    <%= stylesheet_link_tag "fontawesome-all.min", "data-turbo-track": "reload" %>
    <%= stylesheet_link_tag "main", "data-turbo-track": "reload" %>
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.12.1/css/jquery.dataTables.css">




// removed from layout
    <% if notice %>
      <p class="alert alert-success"><%= notice %></p>
    <% end %>
    <br>
    <% if alert %>
      <p class="alert alert-danger"><%= alert %></p>
    <% end %>




// removed from layout
      <!-- Scripts -->

      <%= javascript_include_tag "jquery.min", "data-turbo-track" => "reload"  %>
      <%= javascript_include_tag "browser.min", "data-turbo-track" => "reload"  %>
      <%= javascript_include_tag "breakpoints.min", "data-turbo-track" => "reload"  %>
      <%= javascript_include_tag "util", "data-turbo-track" => "reload"  %>
      <%= javascript_include_tag "main", "data-turbo-track" => "reload"  %>
      <%= javascript_include_tag "custom", "data-turbo-track" => "reload"  %>
      <script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.12.1/js/jquery.dataTables.js"></script>