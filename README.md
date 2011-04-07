# Install

## Dependencies

Gems:

 - tidy
 - sinatra
 - json

## Configs

Set environment variable `RACK_ENV` to `production` if in production. This will make the API listen on port 80 instead of port 4567.

# API Documentation

## POST /clear

### Parameters

#### Required

- String `html`
  - HTML content to be cleaned.

### Response

    {
        "html": "<form style=\"opacity: 0.5; color: red;\"><button>submit</button></form>",
    }
