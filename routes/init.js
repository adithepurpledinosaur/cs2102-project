const sql_query = require('../sql');
const express = require('express');
const passport = require('passport');
const bcrypt = require('bcrypt')
const router = express.Router();

// SQL Connection
const { Pool } = require('pg');
const pool = new Pool({
    connnectionString: process.env.DATABASE_URL,
});

function initRouter(app) {
    app.use('/', require('./indexRoute'));
    app.use('/about', require('./about'));

    app.get('/register', passport.antiMiddleware(), register);
}

function register(req, res, next) {
    res.render('register', { page: 'register', auth: false});
}

module.exports = initRouter;
