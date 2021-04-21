/* This file points to our app.js file with our API code
   Listens to port 3000 for incoming requests */

   
   const app = require("./app"); //points to (includes) our app.js script
   const {DB_URI} = require("./src/config"); //get DB URI from the config
   const mongoose = require("mongoose"); //require mongo
   mongoose.connect(DB_URI); //connect to the URI

   //listens on port 3000
   app.listen(3000, () => {
       console.log("running on port 3000");
       console.log("---------------------");
   });

  