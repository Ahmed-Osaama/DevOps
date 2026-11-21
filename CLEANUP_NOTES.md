# Application-only cleanup notes

This copy removes the previous deployment/infrastructure implementation so a new DevOps solution can be designed separately.

Removed: Dockerfiles, Docker Compose manifests, Kubernetes manifests, Nginx/SSL configuration, Prometheus/Grafana configuration, and root scripts that referenced those missing deployment files. Stale root commands that referenced absent startup, setup, test, or seed scripts were also removed; `test:all` now delegates to the workspace test command. Deployment-only guides and stale DevOps claims were also removed or updated.

Preserved: frontend and backend application source, microservices, package dependencies, tests, application scripts, environment examples, API documentation, and MongoDB initialization. The MongoDB initialization script now lives at `database/mongo-init.js`.

No application services or business-logic files were intentionally deleted.

Security cleanup: credential-bearing MongoDB Atlas URIs were removed from sample environment files, documentation, the Replit command, and backend source defaults. Local development defaults now target localhost; configure your own URI through each service's environment variables. The original files contained a credential-bearing Atlas URI, so rotate that database user's password before reuse.
