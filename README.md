# Goodnight Backend

## API Endpoints

- create a user (POST   /api/v1/users)
- follow a user (POST   /api/v1/follow)
- unfollow a user (POST   /api/v1/unfollow)
- sleep/clock-in or wake/clock-out (POST    /api/v1/sleep-records)
- list for user sleep records (GET    /api/v1/sleep-records)
- list of sleep logs of the user's friends in the past week's time span, descending order of duration (GET    /api/v1/friends-sleep-records)

## Authentication

all endpoints except for users endpoint(POST /api/v1/users), must provide `key` and `secret` in header request. Examples:

```
curl -X POST localhost:3000/api/v1/sleep-records -H 'key: <key>' -H 'secret: <secret>' -H 'Accept: application/json'
```

```
curl -X GET localhost:3000/api/v1/sleep-records -H 'key: <key>' -H 'secret: <secret>' -H 'Accept: application/json'
```

```
curl -X GET localhost:3000/api/v1/friends-sleep-records -H 'key: <key>' -H 'secret: <secret>' -H 'Accept: application/json'
```

## Body format

Provide `follow` key for follow(POST /api/v1/follow) and unfollow(POST /api/v1/unfollow) endpoints. Examples:

```
curl -X POST localhost:3000/api/v1/follow  -d '{"follow": {"follower_id": 2} }' -H 'key: <key>' -H 'secret: <secret>' -H 'Accept: application/json'
```

```
curl -X POST localhost:3000/api/v1/unfollow -d '{"follow": {"user_id": 2} }' -H 'key: <key>' -H 'secret: <secret>' -H 'Accept: application/json'
```

and also provide `user` key for user endpoint (POST /api/v1/user). Example:

```
curl -X POST localhost:3000/api/v1/users -d '{"user": {"name": "Mirzalazuardi"} }' -H 'key: <key>' -H 'secret: <secret>' -H 'Accept: application/json'
```

## Testing & Scenario Documentations

```
rspec --format documentation
```
