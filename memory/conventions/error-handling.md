# Error handling

> Filled by architect agent during /new-project.

## API error format
```json
{
  "error": {
    "code": "RESOURCE_NOT_FOUND",
    "message": "The requested resource does not exist.",
    "details": {}
  }
}
```

## HTTP error codes
- 400: invalid data (validation failed)
- 401: unauthenticated
- 403: unauthorized (authenticated but without permission)
- 404: resource does not exist
- 409: conflict (e.g. email already used)
- 422: syntactically correct but semantically incorrect
- 500: unexpected server error (log it, never expose stack trace)

## Rules
- Always return the same error format
- 500 errors: full stack trace server-side only, never to client
