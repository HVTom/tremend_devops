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
 - the build and tag is done with this command: "docker build -f my_dockerfile -t node-notes-app ."
 ```bash
[toma@hp ex2]$ ls
Dockerfile  notes.js  package.json  README2.md
(base) [toma@hp ex2]$ docker build -f Dockerfile -t node-notes-app .
DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
            Install the buildx component to build images with BuildKit:
            https://docs.docker.com/go/buildx/

Sending build context to Docker daemon  8.704kB
Step 1/7 : FROM node:16
16: Pulling from library/node
311da6c465ea: Pulling fs layer
7e9bf114588c: Pulling fs layer
ffd9397e94b7: Pulling fs layer
513d77925604: Pulling fs layer
ae3b95bbaa61: Pulling fs layer
0e421f66aff4: Pulling fs layer
ca266fd61921: Pulling fs layer
ee7d78be1eb9: Pulling fs layer
513d77925604: Waiting
ca266fd61921: Waiting
ee7d78be1eb9: Waiting
ae3b95bbaa61: Waiting
7e9bf114588c: Verifying Checksum
7e9bf114588c: Download complete
ffd9397e94b7: Verifying Checksum
ffd9397e94b7: Download complete
311da6c465ea: Verifying Checksum
311da6c465ea: Download complete
ae3b95bbaa61: Verifying Checksum
ae3b95bbaa61: Download complete
311da6c465ea: Pull complete
ca266fd61921: Verifying Checksum
ca266fd61921: Download complete
7e9bf114588c: Pull complete
ee7d78be1eb9: Download complete
ffd9397e94b7: Pull complete
0e421f66aff4: Verifying Checksum
0e421f66aff4: Download complete
513d77925604: Verifying Checksum
513d77925604: Download complete
513d77925604: Pull complete
ae3b95bbaa61: Pull complete
0e421f66aff4: Pull complete
ca266fd61921: Pull complete
ee7d78be1eb9: Pull complete
Digest: sha256:f77a1aef2da8d83e45ec990f45df50f1a286c5fe8bbfb8c6e4246c6389705c0b
Status: Downloaded newer image for node:16
 ---> 1ddc7e4055fd
Step 2/7 : WORKDIR /app
 ---> Running in 3d725f373807
Removing intermediate container 3d725f373807
 ---> a660ed27e851
Step 3/7 : COPY package*.json ./
 ---> 21a1308b0aeb
Step 4/7 : RUN npm install
 ---> Running in ef7b875e100b

up to date, audited 1 package in 211ms

found 0 vulnerabilities
Removing intermediate container ef7b875e100b
 ---> 61f24e52ad2f
Step 5/7 : COPY . .
 ---> 399fe00df70c
Step 6/7 : EXPOSE 8080
 ---> Running in 6adb673ae6c6
Removing intermediate container 6adb673ae6c6
 ---> 72538874ee35
Step 7/7 : CMD ["node", "notes.js"]
 ---> Running in f40fc4807d5c
Removing intermediate container f40fc4807d5c
 ---> c64ea484cc17
Successfully built c64ea484cc17
Successfully tagged node-notes-app:latest

Use 'docker scan' to run Snyk tests against images to find vulnerabilities and learn how to fix them

 ```

## Test the Dockerized application to ensure it functions correctly within the
container.
 - docker run -p 8080:8080 node-notes-app
 

## Testing steps
