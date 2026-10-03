# Interview Questions — Short Answers

**1. What is Jenkins, and how is it used in CI/CD?**
Jenkins is an open-source automation server. It watches a repository, and on each change runs a pipeline that builds, tests and deploys the code. Its large plugin ecosystem integrates it with Git, Docker, Kubernetes, cloud providers and notification tools.

**2. What is a Jenkinsfile?**
A text file, stored in the repo root, that defines the pipeline as code (stages, steps, triggers, environment). Keeping it in source control makes the pipeline versioned, reviewable and reproducible.

**3. How do you create and configure Jenkins pipelines?**
Install Jenkins and the Git/Pipeline plugins → create a *Pipeline* job (or Multibranch Pipeline) → choose *Pipeline script from SCM* → give the repo URL, credentials and branch → set the Jenkinsfile path → configure a trigger (webhook or poll SCM) → save and run *Build Now*.

**4. Common stages in a Jenkins pipeline?**
Checkout, Build/Compile, Unit Test, Code Quality/Security scan, Package (e.g. Docker image), Publish/Push to a registry, Deploy (staging/production), and Notify.

**5. Declarative vs scripted pipeline?**
Declarative uses a structured `pipeline { agent / stages / steps / post }` syntax: simpler, validated up front, recommended for most cases. Scripted is Groovy code inside `node { }`: more flexible and powerful, but harder to read and maintain.
