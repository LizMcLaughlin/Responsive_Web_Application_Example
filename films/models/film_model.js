const mongoose = require("mongoose"); //require mongo (called mongoose in npm)
const Schema = mongoose.Schema; //get the Schema obj

//create new schema of type Schema w 1 attribute - can add more later
const FilmSchema = new Schema({
    name:String,
    rating:Number //New attribute added for assignment 4
});

module.exports = mongoose.model("Film", FilmSchema); 