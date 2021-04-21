# Responsive Web Application

Simple web application using the Node.js framework, illustrating the client-server paradigm to submit and display film reviews stored in a MongoDB Backend. The different components are implemented via Docker containers, with Nginx integrated into the application to eliminate custom port mappings and handle reverse proxy and load balancing.

## TO RUN

## Web Application
 ```sh
>> git clone https://github.com/LizMcLaughlin/Responsive_Web_Application_Example
>> cd Responsive_Web_Application_Example
>> cd films; npm install
>> cd ../web; npm install
>> cd ..; docker-compose up
```

Open in Browser at [http://localhost:3000/](http://localhost:3000/)

*Security implemented via JWT tokens. 
Enter username 'Liz' prior to submitting new film reviews.*

## Mobile App

Once the above is up and running, you can view a simulation of an iphone application connecting to the server. Film ratings submitted via the iphone app can be viewed from the web side, and vice verse via the MongoDB backend. 

Open 'mobile/9.2.xcodeproj' in Xcode and click 'play' (triangle) button or 'command R' (Mac) to run/test the simulator.
