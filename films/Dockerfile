#define what images we want to build from
FROM node:latest

#bundle source code from the src dir inside the Docker image
COPY . /src

#create dir to hold app code inside the image
WORKDIR /src

#production flag keeps container smaller / unused dependecies not installed
RUN npm install --production

#map to port the app binds to
EXPOSE 3000

#command to run app
CMD npm start