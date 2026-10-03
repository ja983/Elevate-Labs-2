# Jenkins CI/CD Pipeline Demo (Task 2)

A Jenkins pipeline that **tests, builds and deploys** a small Node.js app using Docker.

## Files
| File | Purpose |
|---|---|
| `Jenkinsfile` | Declarative pipeline: Checkout → Test → Build → Deploy |
| `Dockerfile` | Multi-stage: `test` stage runs `npm test`, `production` stage is the final image |
| `docker-compose.yml` + `jenkins/Dockerfile` | Runs Jenkins (with Docker CLI) locally |
| `app.js`, `server.js`, `test/` | Sample Express app and tests |

## Pipeline stages
1. **Checkout** – pulls the repo.
2. **Test** – `docker build --target test` runs the tests; failure stops the pipeline.
3. **Build** – builds the production image, tagged `latest` and the build number.
4. **Deploy** – replaces the running container and health-checks `/health`.

Trigger: SCM polling every ~2 minutes (`pollSCM`), so each new commit starts a build.

## Run it
```bash
docker compose up -d --build        # Jenkins on http://localhost:8080
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```
Then in Jenkins: install suggested plugins → **New Item → Pipeline** → *Pipeline script from SCM* → Git → your repo URL → branch `*/main` → script path `Jenkinsfile` → Save → **Build Now**.

App URL after a successful deploy: http://localhost:3001
