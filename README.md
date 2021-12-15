# Valutachange Assignment

Here we are deploying an EKS cluster with 2 very very basic Python Flask microservices. The users will hit the m1 microservice at /getInfo path and the m1 service will connect to m2 microservice which will query the RDS DB and displays the information. 

The users will be hitting the API gateway URL first. The API GW will connect to the EKS cluster via the private integration using VPC Link. A security group has been created for the VPC link which will accept traffice from internet on port 80. The traffic will reach the ELB created by the Istio Ingress Gateway. The ELB SG will have an inbound rule with the the VPC link SG reaching over port 80. The istio ingress gateway will handle the incoming traffic. In our case when the /getInfo path is hit, the traffic will be routed to the m1 microservice deployment and it will internally connect to m2 microservice which queries the RDS DB. The outbound connection from EKS to RDS DB will be controlled via the Istio Egress Controller. The RDS security group will accept connections from the EKS nodes on port 3306. 

## Steps

1. Create S3 bucket, Goto Valutachange\Terraform\global\backend

    terraform init
    
    terraform plan
    
    terraform apply
    
2. Goto Valutachange\Terraform\global\

    terraform init
    
    
   This will configure s3 bucket as remote backend
   
3. To create VPC, Goto Valutachange\Terraform\infra\vpc

    terraform init
    
    terraform plan
    
    terraform apply
    
4. To create EKS cluster, Goto Valutachange\Terraform\infra\eks
    
    terraform init
    
    terraform plan
    
    terraform apply
    
    
5. To create RDS, goto Valutachange\Terraform\infra\rds and perform terraform worfklow
6. To create API GW, goto Valutachange\Terraform\infra\apigw and perform terraform worfklow
7. Install and configure istio (https://istio.io/latest/docs/setup/getting-started/)
8. Create the deployments for microservices m1 and m2. Goto Kubenetes folder and:

    kubectl create -f m1app-deploy.yaml
    
    kubectl create -f m2app-deploy.yaml
    
This will create m1 and m2 deployments along with its respective services which will be of type ClusterIP

9. Create istio ingress gateway which will route the traffic to prefix /getInfo to the m1 service.

    kubectl create -f ingress-gw.yaml
    
10. Create the Istio Engress Gateway which will route the traffic from the cluster to the external RDS mysql DB via the Istio Proxies.

     kubectl create -f rds_egress.yaml   


## Flow: 

apigw-->vpc private link-->ELB-->Istio Ingress Gateway-->Gateway-->VirtualService-->Route to diff services.-->egress to RDS


## Security Group flow:
- Internet to VPC Link SG
- VPC link SG inside ELB SG
- ELB SG inside EKS node group SG
- EKS Node group to RDS

## Next steps:
- IAM users and Kubernetes RBAC using aws-auth configmap
- API Gateway Authorizer
- For monitoring and visualization we can install Prometheus, Grafana and Kiali.
- Multi region architecture
