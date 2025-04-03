# Exercise 2

# Chosen project: nodejs

# Create a Dockerfile:

## Write a Dockerfile to containerize the application chosen at the previousstep.

## Include necessary instructions to set up the environment and dependencies.

## Ensure the application runs on port 8080.
 - first, we change the port inside notes.js file:
```javascript
   const PORT = 8080;
   app.listen(PORT, () => {
      console.log(`Server running on http://localhost:${PORT}`);
   });
```
