console.log('==============================================================');
console.log('GTFS to MySQL');
console.log('==============================================================');

var path      = require('path');
var fs        = require('fs');
var async     = require('async');
var mysql     = require('mysql');
var settings  = require('./settings.json');

var conn = mysql.createConnection({
  host     : settings['database']['host'],
  user     : settings['database']['user'],
  password : settings['database']['password'],
  database : settings['database']['name']
});

var data = [
	'agency',
	'calendar',
	'calendar_dates',
	'routes',
	'stop_times',
	'stops',
	'transfers',
	'trips'
];

function getFile(filename, cb) {
	var filepath = path.join(__dirname, settings.path, `${filename}.txt`);
	console.log(filepath); // TODO: remove!!
	fs.readFile(filepath, 'utf8', function(err, csv) {
		if (err) return cb(err);

		if (!csv) return cb(new Error('csv is empty'));

		csv = csv.split(/\r?\n/);

		cb(null, {
			table: filename,
			csv: csv
		});
	});
}

function parse(data, cb) {
	if (!data) return cb(new Error('data is empty or undefined'));

	var header = data.csv.splice(0, 1);
	var rows = data.csv;

	cb(null, {
		table: data.table,
		header: header.toString().trim(),
		rows: rows
	});
}

function doInsert(data, cb) {

	async.eachSeries(data.rows, function(row, cb) {

		row = row.split(',');
		var query = `INSERT INTO ${data.table} (${data.header}) VALUES ('${row.join("','")}');`
		
		conn.query(query, function(err) {
			if (err) return cb(err);

			cb();
		});
		
	}, function(err) {
		if (err) return cb(err);

		cb();
	})
}

function main(item, cb) {
	async.waterfall([
		function(cb) {
			cb(null, item);
		},
		getFile,
		parse,
		doInsert
	], function(err) {
		if (err) return cb(err);

		cb();
	});
}

async.eachSeries(data, main, function(err) {
	if (err) {
		console.log('Import ERROR');
		throw err;
	}

	console.log('Import OK');
});
