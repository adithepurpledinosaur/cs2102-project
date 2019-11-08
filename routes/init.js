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
    app.get('/', page('index'));

    app.get('/register', passport.antiMiddleware(), page('register'));
    app.post('/register', passport.antiMiddleware(), create_user);

    app.get('/login', passport.antiMiddleware(), page('login'));
    app.post('/login', passport.authenticate('local', {
        successRedirect: '/dashboard',
        failureRedirect: '/login?login=fail'
    }));

    app.get('/about', passport.authMiddleware(), require('./samples/about'));
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

function page(pageName) {
    return (req, res, next) => res.render(pageName, { page: pageName, auth: false })
}

module.exports = initRouter;
