/*  

Script contributed by Michael Perkins, refined by Francesco Tonini

example usage:
cat create_db.sql | mysql -u -p root

*/

CREATE DATABASE IF NOT EXISTS gtfs;

USE gtfs;

DROP TABLE IF EXISTS agency;

CREATE TABLE `agency` (
    agency_id VARCHAR(11) PRIMARY KEY,
    agency_name VARCHAR(255),
    agency_url VARCHAR(255),
    agency_timezone VARCHAR(50),
    agency_lang VARCHAR(2),
    agency_phone VARCHAR(15),
    agency_fare_url VARCHAR(255),
    agency_email VARCHAR(255)
);

DROP TABLE IF EXISTS calendar;

CREATE TABLE `calendar` (
    service_id VARCHAR(25) PRIMARY KEY NOT NULL,
	monday TINYINT(1) NOT NULL,
	tuesday TINYINT(1) NOT NULL,
	wednesday TINYINT(1) NOT NULL,
	thursday TINYINT(1) NOT NULL,
	friday TINYINT(1) NOT NULL,
	saturday TINYINT(1) NOT NULL,
	sunday TINYINT(1) NOT NULL,
	start_date VARCHAR(8) NOT NULL,	
	end_date VARCHAR(8) NOT NULL,
	KEY `service_id` (service_id)
);

DROP TABLE IF EXISTS calendar_dates;

CREATE TABLE `calendar_dates` (
    service_id VARCHAR(25) NOT NULL,
    `date` VARCHAR(8) NOT NULL,
    exception_type INT(2) NOT NULL,
    KEY `service_id` (service_id),
    KEY `date` (`date`),
    KEY `exception_type` (exception_type)    
);

DROP TABLE IF EXISTS routes;

CREATE TABLE `routes` (
    route_id INT(11) PRIMARY KEY NOT NULL,
	agency_id VARCHAR(11),
	route_short_name VARCHAR(255) NOT NULL,
	route_long_name VARCHAR(255) NOT NULL,
	route_type INT(2) NOT NULL,
	route_text_color VARCHAR(255),
	route_color VARCHAR(255),
	route_url VARCHAR(255),
	route_desc VARCHAR(255),
	route_sequence TINYINT(1) NOT NULL,
	city VARCHAR(2) NOT NULL,
	KEY `agency_id` (agency_id),
	KEY `route_type` (route_type)
);

DROP TABLE IF EXISTS stop_times;

CREATE TABLE `stop_times` (
    trip_id VARCHAR(25) NOT NULL,
	arrival_time VARCHAR(8) NOT NULL,
	departure_time VARCHAR(8) NOT NULL,
	stop_id INT(11) PRIMARY KEY NOT NULL,
	stop_sequence INT(11) NOT NULL,
	stop_headsign VARCHAR(50),
	pickup_type INT(2),
	drop_off_type INT(2),
	shape_dist_traveled VARCHAR(50),
	KEY `trip_id` (trip_id),
	KEY `stop_id` (stop_id),
	KEY `stop_sequence` (stop_sequence),
	KEY `pickup_type` (pickup_type),
	KEY `drop_off_type` (drop_off_type)
);

DROP TABLE IF EXISTS stops;

CREATE TABLE `stops` (
    stop_id INT(11) PRIMARY KEY NOT NULL,
    stop_code VARCHAR(50),
	stop_name VARCHAR(255) NOT NULL,
	stop_desc VARCHAR(255),
	stop_lat DECIMAL(8,6) NOT NULL,
	stop_lon DECIMAL(8,6) NOT NULL,
	zone_id INT(11),
	stop_url VARCHAR(255),
	location_type INT(2),
	parent_station INT(11),
	KEY `zone_id` (zone_id),
	KEY `stop_lat` (stop_lat),
	KEY `stop_lon` (stop_lon),
	KEY `location_type` (location_type),
	KEY `parent_station` (parent_station)
);

DROP TABLE IF EXISTS trips;

CREATE TABLE `trips` (
	route_id INT(11) NOT NULL,
	service_id VARCHAR(25) NOT NULL,
	trip_id VARCHAR(25) PRIMARY KEY NOT NULL,
	trip_headsign VARCHAR(255),
	trip_short_name VARCHAR(255),
	direction_id TINYINT(1),
	block_id INT(11),
	shape_id INT(11),
	wheelchair_accessible TINYINT(1),
	bikes_allowed TINYINT(1),
	KEY `route_id` (route_id),
	KEY `service_id` (service_id),
	KEY `direction_id` (direction_id),
	KEY `block_id` (block_id),
	KEY `shape_id` (shape_id)
);

DROP TABLE IF EXISTS transfers;

CREATE TABLE `transfers` (
	from_stop_id INT(11) NOT NULL,
	to_stop_id INT(11) NOT NULL,
	transfer_type TINYINT(1) NOT NULL,
	min_transfer_time INT(11)
);
