/* Defines how our server handles requests */

//A6 - includes the JWT module
const jwt = require('jsonwebtoken');

//instructs to include npm's cors module, which enables cross domain requests in our app
const cors = require('cors');

//for our film objects
const Film = require('./models/film_model');

//includes express module
//express is the node.js web app server framework
const express = require('express'); 

//creates an Express application object and assigns to var called 'app'
const app = express(); 

//binds the cors middleware to our app object
app.use(cors()); 

//enables our Express application to parse incoming JSON post bodies
//extract the entire body portion of an incoming request stream and exposes it on req.body
const bodyParser = require('body-parser') ;
const { Mongoose } = require('mongoose');
const { db } = require('./models/film_model');
app.use(bodyParser.json()); //tell express app to use body parser

// ------- > REQUEST HANDLING ------- >

//for 10.0.0.133:3001, returns "films" as our message
app.get("/", (req, res) => {
  res.json({ msg: "films" });
});

//for http://10.0.0.133:3001/api/v1/films, returns the array of films
//await waits for the return of the whole result before proceeding to the next line
//find will return all data entries in the film collection
app.get("/api/v1/films", async (req, res) => {
  const films = await Film.find({});
  res.json(films);
});

//for http://10.0.0.133:3001/api/v1/films, adds a new film to the films array
app.post("/api/v1/films", verifyToken, async (req, res) => {
  console.log("post..................");
  const {name, rating} = req.body; //parse body into 2 vars
  const film = new Film({name, rating}); //create new film object from film schema
  const savedFilm = await film.save(); //await on creating new film in mongo
  res.json(savedFilm); //return newly saved DB entry
});

app.post("/api/v1/login", (req,res) => {
  const user = {
    username: req.body.username
  }
  jwt.sign({ user }, 'secretkey', (err, token) => {
    res.json({
      token
    })
  });
});

app.get("/api/v1/login", (req,res) => {
  const user = {
    username: req.body.username
  }
  jwt.sign({ user }, 'secretkey', (err, token) => {
    res.json({
      token
    })
  });
});

//for http://10.0.0.133:3001/api/v1/films, updates ratings for films currently in database
//reference: https://www.w3schools.com/nodejs/nodejs_mongodb_update.asp
app.patch("/api/v1/films", verifyToken, async (req, res) => {
  console.log("patch request received..................");
  const {name, rating} = req.body; //parse body into 2 vars
  console.log(name,rating);
  var myquery = { "name": name }; //set the film title we're looking to update (one of the updateOne() params)
  var newvalues = { $set: {"rating": rating } }; //what we're changing the rating to 
  await updateOne(myquery,newvalues); //updates database object to new rating 
  });


function verifyToken(req, res, next) {
  const bearerHeader = req.headers['authorization'];
  if (typeof bearerHeader !== 'undefined') {
    const bearerToken = bearerHeader.split(' ')[1];
    jwt.verify(bearerToken, 'secretkey', (err, authData) => {
      if (err) {
        res.sendStatus(403);
      } else {
        next();
      }
    })
  } else {
    res.sendStatus(403);
  }
}

//export 'app'
module.exports = app;


