# ApniDukaan — E-Commerce Application

ApniDukaan is a full-stack e-commerce application organized as a set of backend services with a Next.js frontend. This repository contains the application source code, local development scripts, tests, and database initialization assets. Deployment infrastructure is intentionally not included.

## Application capabilities

- Product catalog, categories, reviews, and search
- User accounts and authentication
- Shopping cart and order management
- Payment service integrations (use provider test credentials during development)
- Notifications
- Next.js frontend and Express-based backend services

## Technology

- **Frontend:** Next.js, TypeScript, Tailwind CSS
- **Backend:** Node.js, Express, TypeScript/JavaScript
- **Data and supporting services:** MongoDB, Redis, Elasticsearch, and Kafka (where configured by the relevant service)

## Requirements

- Node.js 18 or later
- npm 8 or later
- The external data/messaging services required by the services you intend to run (for example MongoDB and Redis)

## Install

```bash
npm install
```

Copy the relevant environment example files and set connection strings and credentials for the services you will run:

- Root: `env.example` or `.env.example`
- Frontend: `frontend/.env.example` (if present)
- Backend: the `.env.example` file in the relevant service (if present)

Do not commit real credentials or production payment keys. Use Stripe/Razorpay test credentials for development.

## Run locally

```bash
# Frontend and the backend services configured by the root workspace script
npm run dev

# Or run them separately
npm run dev:frontend
npm run dev:backend
```

The frontend uses `http://localhost:3000`; the API Gateway uses `http://localhost:4000` according to the project configuration. Individual backend services may require their own environment variables and supporting services.

## Build and test

```bash
npm run build
npm test
npm run lint
npm run type-check
```

Useful scoped commands include `npm run build:frontend`, `npm run build:backend`, `npm run test:frontend`, and `npm run test:backend`.

## Database initialization

`database/mongo-init.js` contains the MongoDB database, collection, index, and sample-category initialization script. It is kept separate from the old container configuration so it can be used with your chosen MongoDB setup.

## Repository structure

```text
frontend/       Next.js application
backend/        API Gateway and backend services
database/       MongoDB initialization script
docs/           Application and development documentation
scripts/        Application setup, test, and data utility scripts
```

## Documentation

See `docs/QUICK_START.md`, `docs/DEVELOPMENT_GUIDE.md`, and the API / database guides under `docs/`.

## License

MIT — see `LICENSE`.
