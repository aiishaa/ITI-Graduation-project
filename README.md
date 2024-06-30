## 1- Install local K8s instance using Minikub (with Ansible):
You can run this playbook on your local machine or a remote ec2 instance(you'll need to use a solution like an nginx server to forward traffic to the Minikube private IP)

## 2- K8s instance will have two Namespaces: tools and dev (installed using Terraform)<br>
![image](https://github.com/aiishaa/ITI-grad-project/assets/57088227/f6d608c2-7cd5-46e9-9fc9-8bff93518927)

## 3- tools namespace will have pod for Jenkins and nexus(installed using Terraform
a. Jenkins:<br>
- Created Persistent Volume and Persistent Volume Claim that is mounted inside the Jenkins pod, allowing it to store data outside the pod, ensuring persistence across updates or reboots.
- Created a jenkins deployment and a service of the type nodeport 
- Made use of the Docker daemon on the host and mounted /var/run/docker.sock to interact with the Docker daemon using the Docker CLI
- Created a service account for the Jenkins pod and assigned it a role, granting it permissions to create StatefulSets, Deployments, and Services on the Minikube cluster.<br>

![image](https://github.com/aiishaa/ITI-grad-project/assets/57088227/029b904d-c788-4ca1-b411-6002c924656f)
<br>
- Now that the Jenkins pod is up and running, to log in to the Jenkins server, you need to sign in first using the username 'admin' and to retrieve the admin password:
  ```bash
  kubectl exec -n tools <jenkins-pod-name> -- cat /var/jenkins_home/secrets/initialAdminPassword
  ```

b- Nexus:<br>
- Created a nexus deployment and a service of nodeport type <br>
![image](https://github.com/aiishaa/ITI-grad-project/assets/57088227/11f81876-6ca5-4c50-9028-31e66cc8a0b2)
<br>
- Now that the Nexus pod is up and running, to log in to the Nexus server, you need to sign in first using the username 'admin' and to retrieve the admin password:
  ```bash
  kubectl exec -n tools <nexus-pod-name> -- cat /nexus-data/admin.password
  ```
<br>
![image](https://github.com/aiishaa/ITI-grad-project/assets/57088227/10fe0c4e-5f9a-4c5a-b58f-113b713062a4)
<br>

- Created a new Docker-hosted repository and defined the port through which this repository is accessible

<br>
![image](https://github.com/aiishaa/ITI-grad-project/assets/57088227/a8773ed6-e59f-449c-ae5b-bbc549cd0324)
<br>

## 4- dev namespace will run two pods: one for nodejs application and another for MySQL DB 
- In the manifests folder, we created the resources needed for MySQL to run as a statefulset, the headless service, and the secret resources.
- Created the manifests needed for the nodejs application, deployment (that uses the image created from running the build pipeline) and a service of nodeport type.

## 5- Create a Jenkins pipeline job to do the following:
o Checkout code from https://github.com/mahmoud254/jenkins_nodejs_example.git
    a- Build nodejs app usng dockerfile
    b- Create a Docker image
    c- Upload Docker image to nexus







