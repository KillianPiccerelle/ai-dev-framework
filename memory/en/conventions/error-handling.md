# Error handling

> Filled by the architect agent during the /new-project workflow.

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
- 422: syntactically correct but semantically incorrect data
- 500: unexpected server error (log it, never expose details)

## Rules
- Always return the same error format
- 500 errors are logged with full stack trace server-side
- 500 errors never return the stack trace to the client
- Error messages are in English client-side
