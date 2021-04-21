/* Responsible for configuring and exporting our Database URI  */

//set URI withe the specified port and the database name "mydb"
let DB_URI="mongodb://10.0.0.133:27017/mydb";

//best practice to allow URI changes through process.env variables
if (process.env.MONGO_DB_URI) {
    DB_URI = process.env.MONGO_DB_URI;
}

module.exports = {
    DB_URI
};