# Explorer

### `Applocation setup steps`
1. Clone the repo: ```git clone git@github.com:trekview/explorer.git``` 
2. Switch to it folder ```cd explorer```
3. Run ```bundle install```
4. Create DB ```rails db:create```
5. Migrate DB ```rails db:migrate```
6. Seed DB ```rails db:seed```
7. Start your application ```rails server```
8. Visit page in your browser ```http://localhost:3000```

Register a user. After registration you will be able to get you API-KEY. With an API-KEY you`ll 
be able to post ypu tours from Tourer app from your local computer.

##API endpoints

POST /api/v1/tours

**Request**

```
{
    "tour": {
        "name": "Euro-tour adventure",
        "description": "Tour description - long text",
        "country_name": "Holland",
        "tag_names": "plumb, red, yellow",
        "local_id": "ebe8af59b9",
        "google_link": "https://youtube.com",
        "tour_type": "air"
    }
}
```
**Response**

```
{
    "id": 18,
    "name": "Euro-tour adventure",
    "description": "Tour description - long text",
    "country_id": 7,
    "user_id": 4,
    "google_link": "https://youtube.com",
    "created_at": "2019-07-29T09:51:11.215Z",
    "updated_at": "2019-07-29T09:51:11.215Z",
    "slug": "euro-tour-adventure",
    "local_id": "ebe8af59b9",
    "tour_type": "air"
}

OR

{
    "errors": {
        "local_id": [
            "has already been taken"
        ]
    }
}

```

PATCH /api/v1/tours/:local_id

with this request you wil not be able to update ```local_id```

**Request**

```
{
    "tour": {
        "name": "Euro-tour adventure number two",
        "description": "Tour description - long text",
        "country_name": "Holland",
        "tag_names": "plumb, red, yellow",        
        "google_link": "https://youtube.com",
        "tour_type": "water"
    }
}
```

**Response**

```
{
    "id": 18,
    "name": "Euro-tour adventure number two",
    "description": "Tour description - long text",
    "country_id": 7,
    "user_id": 4,
    "google_link": "https://youtube.com",
    "created_at": "2019-07-29T09:51:11.215Z",
    "updated_at": "2019-07-29T09:55:14.609Z",
    "slug": "euro-tour-adventure",
    "local_id": "ebe8af59b9",
    "tour_type": "water"
}

OR

{
    "errors": "'waterr' is not a valid tour_type"
}

{
    "errors": {
        "authorization": "Invalid token"
    }
}
```

DELETE /api/v1/tours/:local_id


**Response**

```
{
    "id": 18,
    "name": "Euro-tour adventure number two",
    "description": "Tour description - long text",
    "country_id": 7,
    "user_id": 4,
    "google_link": "https://youtube.com",
    "created_at": "2019-07-29T09:51:11.215Z",
    "updated_at": "2019-07-29T09:55:14.609Z",
    "slug": "euro-tour-adventure",
    "local_id": "ebe8af59b9",
    "tour_type": "water"
}

OR

{
    "errors": "You cannot delete this tour"
}

```


