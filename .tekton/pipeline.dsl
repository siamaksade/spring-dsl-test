name: spring-petclinic

on:
  push:
    branches: [main]

params:
  image_url: "quay.io/siamaksade/spring-petclinic:{{ source_branch }}"

cache:
  image: oci://quay.io/siamaksade/spring-petclinic-m2-cache
  credentials: quay-credentials

defaults:
  image: registry.access.redhat.com/ubi9-minimal
  before_run: |
    echo "#### BEFORE RUN ####"
  after_run: |
    echo "#### AFTER RUN ####"

tasks:
  git:
    uses: git-clone:0.10.0
    params:
      url: {{ repo_url }}
      revision: {{ revision }}

  build-jar:
    uses: maven:0.4.0
    params:
      GOALS: ["clean", "package"]
    workspaces:
      maven-local-repo: shared-workspace
    cache:
      path: /workspace/maven-local-repo/.m2
      key: ["**/pom.xml"]

  build-image:
    uses: tasks/task-s2i-java.yaml
    params:
      IMAGE: $(params.image_url)

  deploy:
    image: registry.redhat.io/rhel8/nodejs-22-minimal:latest
    run: npx ascii-themes generate OpenShift
