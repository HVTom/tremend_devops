# official Node.js image as the base
FROM node:16
# container working directory
WORKDIR /app
# copy package.json file
COPY package*.json ./
# install dependencies
RUN npm install
# copy the application code
COPY . .
# use port 8080
EXPOSE 8080
# command to start the note.js app with node
CMD ["node", "notes.js"]
