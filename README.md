## Pet Tracker

### Description
This is a simple pet tracker application that allows users to keep track of their pets. Users can add, update, and delete pets.

### Technologies
- Rails 7.1.3
- Ruby 3.3.0
- SQLite3 (in memory database, can be easily changed to persistent database like PostgreSQL)

### Installation
1. Clone the repository
2. Run `bundle install` to install the required gems
3. Run `bin/setup` to setup the database and other necessary configurations
4. Run `rails s` to start the server

### Testing
Run `rspec spec/` to run the test suite

### API Documentation

#### Create a pet

```sh
curl -X POST -H "Content-Type: application/json" -d '{"pet": {"type": "Cat", "tracker_type": "small", "owner_id": 1, "in_zone": false, "lost_tracker": false}}' http://localhost:3000/pets
```

#### List all pets

```sh
curl http://localhost:3000/pets
```

#### Get Pets Outside Power Saving Zone Grouped by Pet Type and Tracker Type:

```sh
curl http://localhost:3000/pets?in_zone=false&group_by=type,tracker_type
```




**Note:** The API documentation is not complete. Please refer to the tests for more examples.

### Assumptions and Limitations
- We need to use same API to list pets and get count of pets grouped by certain attributes. This complicates things a little bit. We can have separate APIs for listing pets and getting count of pets grouped by certain attributes.

- We are using in-memory database (SQLite3) for simplicity. We can easily switch to a persistent database like PostgreSQL.

- We are not handling authentication and authorization in this application. We can use Devise for authentication and Pundit for authorization.

- No specs added for `FilterGroupQuery` and `PetsFilterGroupQuery` classes due to time constraints.

- The error handling is not very robust. The application is mostly focused on happy path.

- There's scope for code refactoring and optimization.
