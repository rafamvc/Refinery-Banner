# Authentication

## About

At the heart of Refinery's user management is the authentication plugin located in ``vendor/plugins/authentication``

What this really is is just a standard [RESTFul authentication](http://github.com/technoweenie/restful-authentication) install extended with a few extra features like "I forgot my password" and hooked directly into the heart of Refinery's plugin system.

## Adding New Users

New users can be easily added by going to the 'Users' area admin and clicking on "Add new user".

## Limiting and Granting Access

Each user has a set of plugins they're allowed to see. You can control which plugins each user can see by checking and unchecking the checkboxes next to the plugin name when editing or adding a new user.