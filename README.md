# Homelander

- [Homelander](#homelander)
  - [Database](#database)
    - [Setup database](#setup-database)
    - [Access database](#access-database)

## Database

### Setup database

To access database you'll need to download and install docker. You can follow the steps in this [guide](https://docs.docker.com/get-docker/). After this is complete follow the steps below:

1. Copy `PGADMIN_EMAIL`, `PGADMIN_PASS`, `POSTGRES_USER`, `POSTGRES_PASSWORD` and `POSTGRES_DB` from `.env.sample` and paste them in your local .env file.
2. Run `docker-compose up -d` to download and run postgres and pgadmin images.

### Access database

You can access the database with pgadmin. To do so follow the steps below:

1. Navigate to [pgadmin](http://localhost:5050/).
2. Provide email and password. These are located in your .env file with names `PGADMIN_EMAIL` and `PGADMIN_PASS` respectively.
3. After that right click on `Servers` -> `Register` -> `Server`.
4. In `General` tab add the name of the database.
5. On connection tab you will need to add the host name. To do that:
   - Run `docker ps` and copy the containers id.
   - Then run `docker inspect ${container_id} | grep IPAddress` where container_id is the id we copied.
   - Copy and paste the result into `host name/address`
6. Then in username and password fields add the `POSTGRES_USER` and `POSTGRES_PASSWORD` available in your .env file.
7. Click on `save` and you should be ready.
