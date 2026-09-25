GitHub Secrets Required

Go to GitHub → Repository → Settings → Secrets and variables → Actions and create:

Secret Name

	

Value




GCP_SA_KEY

	

Entire JSON key of the GCP Service Account

Create Service Account (Run Once)
gcloud iam service-accounts create github-actions \
    --display-name="GitHub Actions Service Account"

gcloud projects add-iam-policy-binding iris-gke-production \
  --member="serviceAccount:github-actions@iris-gke-production.iam.gserviceaccount.com" \
  --role="roles/artifactregistry.writer"

gcloud projects add-iam-policy-binding iris-gke-production \
  --member="serviceAccount:github-actions@iris-gke-production.iam.gserviceaccount.com" \
  --role="roles/storage.admin"

gcloud iam service-accounts keys create key.json \
  --iam-account=github-actions@iris-gke-production.iam.gserviceaccount.com

Upload the contents of key.json into the GCP_SA_KEY GitHub secret.

Create Artifact Registry Repository (Run Once)
gcloud artifacts repositories create production-images \
  --repository-format=docker \
  --location=us-central1 \
  --description="Production Docker Images"
Images Produced

After every push to the main branch:

us-central1-docker.pkg.dev/iris-gke-production/production-images/webapp-a:latest
us-central1-docker.pkg.dev/iris-gke-production/production-images/webapp-a:<commit-sha>

us-central1-docker.pkg.dev/iris-gke-production/production-images/webapp-b:latest
us-central1-docker.pkg.dev/iris-gke-production/production-images/web
