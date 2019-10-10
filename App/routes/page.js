var express = require('express');
var router = express.Router();

router.get('/', function(req, res, next) {
  res.render('error', { title: 'Error Page' });
});

module.exports = router;