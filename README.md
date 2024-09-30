## 1- Install local K8s instance using Minikub (with Ansible):
You can run the ansible playbook on your local machine or on a remote ec2 instance.

## 2- K8s instance will have two Namespaces: tools and dev (installed using Terraform)<br>
![image](https://github.com/aiishaa/ITI-grad-project/assets/57088227/f6d608c2-7cd5-46e9-9fc9-8bff93518927)

## 3- tools namespace will have pod for Jenkins and nexus(installed using Terraform
a. Jenkins:<br>
- Created a jenkins deployment and a service of the type nodeport 
- Created a Persistent Volume and a Persistent Volume Claim that is mounted inside the Jenkins pod, allowing it to store data outside the pod, ensuring persistence across updates or reboots.
- Made use of the Docker daemon on the host and mounted /var/run/docker.sock so that the jenkins server can interact with the Docker daemon using the Docker CLI
- Created a service account for the Jenkins manager and jenkins agent pods and assigned it a role, granting them permissions to create StatefulSets, Deployments, and Services on the Minikube cluster in the tools and dev namespaces respectively.

![image](https://github.com/aiishaa/ITI-Graduation-project/assets/57088227/b6714b18-4f0d-4371-bf7c-421e5655ab72)

<br>

- Now that the Jenkins pod is up and running, to log in to the Jenkins server, you need to sign in first using the username 'admin' and to retrieve the admin password:
  ```bash
  kubectl exec -n tools <jenkins-pod-name> -- cat /var/jenkins_home/secrets/initialAdminPassword
  ```

b- Nexus:<br>
- Created a nexus deployment and a service of nodeport type

![image](https://github.com/aiishaa/ITI-grad-project/assets/57088227/11f81876-6ca5-4c50-9028-31e66cc8a0b2)
<br>

- Now that the Nexus pod is up and running, to log in to the Nexus server, you need to sign in first using the username 'admin' and to retrieve the admin password:
  ```bash
  kubectl exec -n tools <nexus-pod-name> -- cat /nexus-data/admin.password
  ```
![image](https://github.com/aiishaa/ITI-grad-project/assets/57088227/10fe0c4e-5f9a-4c5a-b58f-113b713062a4)
<br>

- Created a new Docker-hosted repository and defined the port through which this repository is accessible

![image](https://github.com/aiishaa/ITI-grad-project/assets/57088227/a8773ed6-e59f-449c-ae5b-bbc549cd0324)
<br>

## 4- dev namespace will run two pods: one for nodejs application and another for MySQL DB 
- In the terraform folder, we created the terraform configuration files needed for MySQL to run as a statefulset, the headless service, and the secret resources.
- Created the manifests needed for the nodejs application, deployment (that uses the image created from running the build pipeline) and a service of nodeport type.

## 5- Create a Jenkins pipeline job to do the following:
#### o Checkout code from https://github.com/mahmoud254/jenkins_nodejs_example.git<br>
  - Build nodejs app usng dockerfile<br>
  - Create a Docker image<br>
  - Upload Docker image to nexus<br>

#### 5.1 Setting the Jenkins Kubernetes Pod Agent. This pod will be dynamically created and destroyed by Jenkins.<br>

Step 1: Install Jenkins Kubernetes Plugin <br>
Step 2: Create a Kubernetes Cloud Configuration<br>
![cloud-1](https://github.com/aiishaa/ITI-Graduation-project/assets/57088227/1532aafb-29af-46ed-b9ad-d0cef62dbca1)

<br>

![cloud-2](https://github.com/aiishaa/ITI-Graduation-project/assets/57088227/f2bfdaf2-d2f4-4924-b609-ece39e2a649e)

<br>

![image](https://github.com/aiishaa/ITI-Graduation-project/assets/57088227/afa6a21a-3d15-468a-8015-1f663c44d76f)

<br>

step 3: Define the credentials needed. For Jenkins to communicate with the Kubernetes cluster, we need a service account token with permission to deploy pods in the tools namespace<br>

![jenkins-secrets](https://github.com/aiishaa/ITI-Graduation-project/assets/57088227/b083f029-bcb2-4683-8c6f-554e1779a3f9)

<br>

#### 5.2 Create and run the build pipeline<br>

![image](https://github.com/aiishaa/ITI-grad-project/assets/57088227/c24d6588-79e0-469f-a0e7-990e2fc73a70)

<br>

o Now, as a result of the build pipeline, you can see the image pushed to the Docker-hosted repository we created 
<br>

![image](https://github.com/aiishaa/ITI-grad-project/assets/57088227/fc3e0b1b-f741-4bdd-b0f3-b4f1ef91c98f)


## 6- Create another Jenkins pipeline job that run the Docker container on the requested environment from nexus on minikube.<br>

![image](https://github.com/aiishaa/ITI-Graduation-project/assets/57088227/d6a4d693-8ac5-4224-b231-906936e06165)

<br> 

![image](https://github.com/aiishaa/ITI-grad-project/assets/57088227/b38a70e9-9969-464d-b147-dbcc515efd76)

<br>

![image](https://github.com/aiishaa/ITI-Graduation-project/assets/57088227/1798436f-eae7-4951-8b99-65e30d57f660)



