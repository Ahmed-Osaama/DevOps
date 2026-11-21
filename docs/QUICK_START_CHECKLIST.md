# ApniDukaan Local Development Checklist

## Requirements

- [ ] Node.js 18+ installed (`node --version`)
- [ ] npm 8+ installed (`npm --version`)
- [ ] MongoDB reachable locally or through Atlas
- [ ] Required supporting services (such as Redis, Kafka, or Elasticsearch) are reachable for the services being run

## Install and configure

```bash
npm install
```

- [ ] Copy the relevant `.env.example` files to local environment files.
- [ ] Set database and supporting-service connection strings.
- [ ] Use payment-provider test credentials only.
- [ ] Never commit secrets.

## Start the application

```bash
npm run dev
```

Or start the parts separately:

```bash
npm run dev:frontend
npm run dev:backend
```

- [ ] Frontend responds at `http://localhost:3000`.
- [ ] API Gateway responds at `http://localhost:4000`.

## Database initialization

`database/mongo-init.js` creates the application databases, collections, indexes, and sample categories. To run it against a local MongoDB instance:

```bash
mongosh "mongodb://localhost:27017" --file database/mongo-init.js
```

For MongoDB Atlas, use your Atlas connection URI in the relevant service environment variables.

## Test and build

```bash
npm test
npm run test:frontend
npm run test:backend
npm run build
npm run lint
npm run type-check
```

## Development workflow

- [ ] Make application changes under `frontend/` or the relevant `backend/` service.
- [ ] Add or update tests for behavior changes.
- [ ] Run the relevant tests and build before committing.
- [ ] Update application documentation when behavior or configuration changes.
