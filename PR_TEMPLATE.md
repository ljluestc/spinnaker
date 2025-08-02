# PR Title: Fix broken AWS CLI in Halyard image by upgrading awscli and urllib3

Closes #7118

## Changes
- Upgraded `awscli` to 1.33.2 and `urllib3` to 2.2.2 in Dockerfile to resolve `ModuleNotFoundError: No module named 'urllib3.packages.six.moves'`.
- Added verification step (`aws --version`) during build.
- Tested with EKS kubeconfig using `aws eks get-token`.

## Testing
- Built image: `docker build -t halyard-custom .`
- Ran container: `docker run --rm -v ~/.kube/config:/kubeconfig halyard-custom hal deploy apply --kubeconfig /kubeconfig`
- Verified no AWS CLI error and successful deployment.

## Notes
This aligns with AWS CLI 1.x; consider 2.x in future for better compatibility.
