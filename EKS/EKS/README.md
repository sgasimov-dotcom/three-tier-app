# three-tier-app-demo
EKS Upgrade Process 



Planning 
Test on Your Own account 





Notification 
Maintenance announcement page 
3+ days 





Schedule 
Off Hours 



	1. kubectl version 
		a. 1.19+


	2. kubectl get nodes 
1.19


AMI  Build Process Packer
Base AMI  >> Third Party   Monthly 
Base AMI + 
  telnet 
  company tools 





Upgrade K8S Control plane with terraform 
Create PR, 
Get Approval 
Push/Merge 
terraform apply -auto-approve 







Upgrade Worker node
	3. Upgrade ASG  with new AMI 
		a. change AMI in tfvars
		b. New AMI 
		c. create PR 
		d. get approval 
		e. Push / Merge 

Taint
for i in `kubectl get nodes  | awk '{print $1}'
do 
  kubectl taint $i 
done 




Drain
for i in `kubectl get nodes  | awk '{print $1}'
do 
  kubectl drain $i 
done 





		a. terraform apply -auto-approve 
		



Verification Process
	1. Check all helm charts 
	2. Check all storage 
	3. Check all k8s APIs 
		a. Deprecated API 
	4. Check HPA 
	5. Check APP  logs 
	6. Check Events --all-namespaces 
	7. Check kube-system app logs 
	8. cluster-autoscaler 






	1. kubectl version 
		a. 1.120


	1. kubectl get nodes 
1.20



Announcement about completion 