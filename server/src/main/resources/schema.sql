CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS users (
  id SERIAL PRIMARY KEY,
  user_name VARCHAR(255) NOT NULL,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  password TEXT NOT NULL,
  phone VARCHAR(50) NOT NULL,
  photo_uri TEXT,
  is_verified BOOLEAN NOT NULL DEFAULT FALSE,
  is_landlord BOOLEAN NOT NULL DEFAULT FALSE,
  is_admin BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS countries(
  id SERIAL PRIMARY KEY,
  country_name TEXT NOT NULL,
  country_code VARCHAR(3) NOT NULL,
  lat DECIMAL(10,6) NOT NULL,
  long DECIMAL(10,6) NOT NULL
);

CREATE TABLE IF NOT EXISTS city_filters(
 id SERIAL PRIMARY KEY,
 min_rent INTEGER NOT NULL,
 max_rent INTEGER NOT NULL,
 min_bedrooms INTEGER NOT NULL,
 max_bedrooms INTEGER NOT NULL,
 min_bathrooms INTEGER NOT NULL,
 max_bathrooms INTEGER NOT NULL,
 min_floors INTEGER NOT NULL,
 max_floors INTEGER NOT NULL
);

CREATE TABLE IF NOT EXISTS cities(
  id SERIAL PRIMARY KEY,
  city_name TEXT NOT NULL,
  city_code VARCHAR(3) NOT NULL,
  country_id INTEGER REFERENCES countries (id),
  city_filters_id INTEGER REFERENCES city_filters (id),
  lat DECIMAL(10,6) NOT NULL,
  long DECIMAL(10,6) NOT NULL
);

CREATE TABLE IF NOT EXISTS neighborhood(
  id SERIAL PRIMARY KEY,
  neighborhood_name TEXT NOT NULL,
  city_id INTEGER REFERENCES cities (id)
);

DO '
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = ''listing_types'') THEN
    CREATE TYPE listing_types AS ENUM (''PRIVATE_ROOM'', ''SHARED_ROOM'', ''APARTMENT'');
  END IF;
END';

CREATE TABLE IF NOT EXISTS listings(
  id SERIAL PRIMARY KEY,
  rent INTEGER NOT NULL,
  lat DECIMAL(10,6) NOT NULL,
  long DECIMAL(10,6) NOT NULL,
  listing_name TEXT NOT NULL,
  sqm INTEGER NOT NULL,
  floor INTEGER NOT NULL,
  photos_uri TEXT NOT NULL,
  number_of_bedrooms INTEGER NOT NULL,
  number_of_bathrooms INTEGER NOT NULL,
  country_id INTEGER REFERENCES countries (id),
  city_id INTEGER REFERENCES cities (id),
  neighborhood_id INTEGER REFERENCES neighborhood (id),
  code VARCHAR(4) NOT NULL,
  listing_type listing_types NOT NULL,
  rating DECIMAL(10, 2) DEFAULT 0,
  description TEXT NOT NULL,
  is_listed BOOLEAN NOT NULL,
  owner_id INTEGER REFERENCES users (id),
  max_guests INTEGER NOT NULL
);

DO '
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = ''minimum_stay_enum'') THEN
    CREATE TYPE minimum_stay_enum AS ENUM (''DAYS'', ''MONTHS'');
  END IF;
END';

CREATE TABLE IF NOT EXISTS minimum_stay(
  id SERIAL PRIMARY KEY,
  listing_id INTEGER REFERENCES listings (id),
  amount INTEGER NOT NULL,
  count_in minimum_stay_enum NOT NULL
  );

CREATE TABLE IF NOT EXISTS rules(
  id SERIAL PRIMARY KEY,
  listing_id INTEGER REFERENCES listings (id),
  party BOOLEAN NOT NULL,
  pets BOOLEAN NOT NULL,
  smocking BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS amenities(
  id SERIAL PRIMARY KEY,
  amenity TEXT NOT NULL,
  listing_id INTEGER REFERENCES listings (id)
);

CREATE TABLE IF NOT EXISTS comments  (
  id SERIAL PRIMARY KEY,
  comment TEXT NOT NULL,
  user_id INTEGER REFERENCES users (id),
  listing_id INTEGER REFERENCES listings (id)
);