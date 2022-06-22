/**
 MONGO DB:
 username: rindra
 password: rindra123456789
 */

// Import from packages

// Init
const express = require("express");
const app = express();
const mongoose = require("mongoose");
const db =
  "mongodb+srv://rindra:rindra123456789@cluster0.u2iqq.mongodb.net/?retryWrites=true&w=majority";
const PORT = 3000;

// Import from other files
const authRouter = require("./routes/auth");

// middleware
app.use(express.json()); // very useful cause it parse json
app.use(authRouter);

// Connection
mongoose
  .connect(db)
  .then(() => {
    console.log("Connection success");
  })
  .catch((e) => {
    console.log(e);
  });

// Listening to the PORT
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Connected at port ${PORT}`);
});
