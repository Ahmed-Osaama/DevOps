# ApniDukaan Quick Start

## Requirements

- Node.js 18 or later
- npm 8 or later
- MongoDB and any supporting services required by the backend services you plan to run

## Install dependencies

From the repository root:

```bash
npm install
```

Copy the applicable environment example files and set the connection strings and test credentials required by the services. Do not commit real secrets.

## Run the application

```bash
# Start the frontend and the backend services configured in package.json
npm run dev

# Or run them separately
npm run dev:frontend
npm run dev:backend
```

The frontend is configured for `http://localhost:3000` and the API Gateway for `http://localhost:4000`.

## Test and build

```bash
npm test
npm run build
npm run lint
npm run type-check
```

To initialize MongoDB collections and sample categories, use `database/mongo-init.js` with your MongoDB shell, for example:

```bash
mongosh "mongodb://localhost:27017" --file database/mongo-init.js
```

## Troubleshooting

- Check that the environment variables for each service are set.
- Check that MongoDB and any other required supporting services are reachable.
- Check the terminal output for the service that failed to start.
- Confirm that ports 3000 and 4000 are not already in use.
