# Exercise 2

# Chosen project: nodejs

# Create a Dockerfile:
 
## Write a Dockerfile to containerize the application chosen at the previous step.

 -> https://github.com/HVTom/tremend_devops/blob/main/ex2/Dockerfile

## Include necessary instructions to set up the environment and dependencies.

## Ensure the application runs on port 8080.
 - first, we change the port inside notes.js file:
```javascript
   const PORT = 8080;
   app.listen(PORT, () => {
      console.log(`Server running on http://localhost:${PORT}`);
   });
```


# Local testing

## Build the Docker image locally.
 - (https://docs.docker.com/get-started/docker-concepts/building-images/build-tag-and-publish-an-image/)
 - the build and tag is done with this command: "docker build -t node-notes-app"

## Test the Dockerized application to ensure it functions correctly within the
container.
 - docker run -p 8080:8080 node-notes-app
 

## Testing steps
