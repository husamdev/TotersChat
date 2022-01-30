## Save Message Use Case

### Primary Course
1. Execute save message.
2. System creates local message from message.
3. System saves message into cache.

### Error course (sad path):
1. System delivers error.




## Load Messages From Cache Use Case

### Primary Course
1. Execute load messages with contact command.
2. System retrieves local messages made with contact from cache.
3. System creates messages from cached data.
4. System delivers messages with contact.

### Empty cache course:
1. System delivers no messages.

### Error course (sad path):
1. System delivers error.




## Load Conversations From Cache Use Case

TODO
