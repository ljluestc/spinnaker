## Build the Image Locally
1. Clone `spinnaker/halyard`: `git clone https://github.com/spinnaker/halyard.git`
2. cd to `halyard-web`.
3. Apply the updated Dockerfile.
4. Build: `docker build -t halyard-fixed:1.35.0 .`

## Test AWS CLI in Image
- Run: `docker run --rm halyard-fixed:1.35.0 aws --version`
- Expected: Outputs version without errors.

## Test Halyard Deployment
- Prepare EKS kubeconfig with `exec: aws eks get-token`.
- Run: `docker run -v ~/.hal:/home/spinnaker/.hal -v ~/.kube/config:/kube/config halyard-fixed:1.35.0 hal deploy apply --kubeconfig /kube/config`
- Expected: Deploys without AWS CLI error.

## Test on K8s
- Deploy Halyard pod with the fixed image.
- Run deployment command inside pod.
- Verify logs for no errors.

## Edge Cases
- Test with invalid kubeconfig: Expect non-AWS errors.
- Test AWS CLI commands: `docker run --rm halyard-fixed:1.35.0 aws sts get-caller-identity` (with credentials mounted).

## Local vs Online
- Local: Use the built image for testing.
- Online: Push to Docker Hub (`docker push yourusername/halyard-fixed:1.35.0`), use in K8s deployment.
