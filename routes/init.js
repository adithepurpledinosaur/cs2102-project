const sql_query = require('../sql');
const express = require('express');
const passport = require('passport');
const bcrypt = require('bcrypt')
const router = express.Router();

// SQL Connection
const { Pool } = require('pg');
const pool = new Pool({
    connectionString: process.env.DATABASE_URL
});
const salt  = bcrypt.genSaltSync(10);

function initRouter(app) {
    app.use('/', require('./indexRoute'));
    app.use('/about', require('./about'));

    app.get('/register', passport.antiMiddleware(), register);
    app.post('/register', passport.antiMiddleware(), create_user);
}

function register(req, res, next) {
    res.render('register', { page: 'register', auth: false});
}

function create_user(req, res, next) {
    const username = req.body.username;
    const passwordHash = bcrypt.hashSync(req.body.password, salt);
    const fullname = req.body.fullname;

    pool.query(sql_query.query.create_user, [username, passwordHash, fullname])
        .then(() => res.redirect("/login"))
        .catch(err => {
            console.log("Error adding user", err);
            res.redirect("/register?reg=fail");
        })
}

module.exports = initRouter;
