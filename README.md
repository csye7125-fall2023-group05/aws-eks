# Elastic Kubernetes Service

Set up a managed kubernetes cluster on AWS (EKS) using Hashicorp Terraform Infrastructure as Code tool.

> \[!NOTE]\
> This is a work in progress. Feel free to open PRs if you want to contribute to the project.

## Working with Terraform

In order to setup the infrastructure for a managed Kubernetes cluster on AWS (EKS), we will use Hashicorp Terraform to install the required resources on the AWS cloud. You will need to follow the `examples.tfvars` [located here](./root/example.tfvars) in order to successfully deploy the infrastructure on AWS.

> \[!IMPORTANT]\
> Please note that you will need to configure the `AWS_PROFILE` environment variable to match your specified local AWS CLI profile in order to successfully deploy the infrastructure on AWS.
> You can do so by running `export AWS_PROFILE=<profile-name>` to set the variable locally on your terminal.

- Initialize Terraform

  ```bash
  terraform init
  ```

- Plan the infrastructure installation

  ```bash
  terraform plan -var-file="prod.tfvars"
  ```

- Apply the infrastructure changes

  ```bash
  terraform apply --auto-approve -var-file="prod.tfvars"
  ```

## Configure KUBECONFIG

To access the cluster from the command line, we need to set some variables beforehand.

- `REGION`: This should be set to the AWS region in which we have deployed our EKS cluster.

  ```bash
  export REGION="us-east-1"
  ```

- `CLUSTER_NAME`: This should be set to the cluster name we have provided in our IaC using Terraform.

  ```bash
  export CLUSTER_NAME="pwncorp-dev-eks-39htbsdk"
  ```

> \[!NOTE]\
> You need to configure your `AWS_PROFILE` environment variable before you can run the below command to get the AWS EKS cluster credentials

In order to update the kubeconfig on your local workstation, we need to run the following command:

```bash
aws eks update-kubeconfig --region $REGION --name $CLUSTER_NAME
```

You should now be able to access the cluster via your local terminal.

> \[!IMPORTANT]\
> Since this is still a WIP, we are planning to provide access to the cluster via a bastion host instead of direct access to the cluster after running the above command. Feel free to open a PR in case you want to contribute and help us out in setting up a bastion host to access the AWS EKS cluster.

## Working with ArgoCD

- To setup and install AgoCD on the cluster, run the command:

```bash
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

- To access the ArgoCD dashboard, we need to port-forward and expose the port for ArgoCD:

```bash
# remember to open the port forward in another terminal window
# the port should always be open to access the ArgoCD dashboard
kubectl port-forward svc/argocd-server 8080:443 -n argocd
```

- To get the initial admin password to access the ArgoCD dashboard, we need to get the `base64` encoded password from the `secrets` resource in the `argocd` namespace and display the value using `-o yaml` parameter. Once done, we can then decode the `base64` value:

```bash
echo "<base64-encoded-pwd> | base64 -d"
# ignore the % at the end of the decoded string
```

You can now access the ArgoCD dashboard via `https://localhost:8080` and login using the username `admin` and password retrieved from the previous step.

## LICENSE

This project is licensed under the MIT open-source license.

## Authors

[Siddharth Rawat](https://github.com/sydrawat01)
