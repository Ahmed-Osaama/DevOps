# MongoDB Atlas Setup Guide

## 1. Create an Atlas database

Create a cluster and database user in MongoDB Atlas. Restrict network access to the IP addresses that need to connect. Do not use a broad public allow-list for production.

## 2. Configure the application

Copy the Atlas connection URI from Atlas and place it in the environment variable required by each backend service. Check the `.env.example` file in the relevant service for the expected variable name. Keep the URI in a local environment file; do not commit it to Git or paste it into source code.

The previous version of this guide contained a credential-bearing connection URI. That value has been removed from this copy. Rotate the corresponding database user's password in Atlas before continuing.

## 3. Optional database initialization

The repository includes `database/mongo-init.js`, which creates the application databases, collections, indexes, and three sample categories. To run it against your Atlas cluster, pass your URI securely to `mongosh` and execute the script:

```bash
mongosh "<YOUR_ATLAS_CONNECTION_URI>" --file database/mongo-init.js
```

Replace the placeholder locally; do not commit the real URI.

## 4. Start the application

From the repository root, install dependencies and start the configured frontend/backend services:

```bash
npm install
npm run dev
```

The frontend is configured for `http://localhost:3000` and the API Gateway for `http://localhost:4000`.
