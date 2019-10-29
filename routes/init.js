const sql_query = require('../sql');
const express = require('express');
const router = express.Router();

// SQL Connection
const { Pool } = require('pg');
const pool = new Pool({
    connnectionString: process.env.DATABASE_URL,
});

function initRouter(app) {
    app.use('/', require('./indexRoute'));
    app.use('/about', require('./about'));
}

module.exports = initRouter;
