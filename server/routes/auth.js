const express = require("express");
const User = require("../models/user");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");

/// Create router
const authRouter = express.Router();

/// SIGNUP route
authRouter.post("/api/signup", async (req, res) => {
  try {
    // get the data from client
    const { name, email, password } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ msg: "🧑‍🦲 User with same email already exists!" });
    }

    // we use bcryptjs to hash our password mean to really secure password
    const hashedPassword = await bcryptjs.hash(password, 8);

    let user = new User({
      email,
      password: hashedPassword,
      name,
    });

    // post that data in database
    user = await user.save();

    // return that data to the user
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Sign In Route
authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;

    // find the user
    const user = await User.findOne({ email });

    if (!user) {
      return res
        .status(400)
        .json({ msg: "☠️ User with this email does not exist!" });
    }

    // comparing hashed password
    const isMatch = await bcryptjs.compare(password, user.password);

    if (!isMatch) {
      return res.status(400).json({ msg: " 😵 Incorrect Password!" });
    }

    // jwt to make sure that user is verified not a hacker
    const token = jwt.sign({ id: user._id }, "passwordKey");

    res.json({ token, ...user._doc });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = authRouter;
