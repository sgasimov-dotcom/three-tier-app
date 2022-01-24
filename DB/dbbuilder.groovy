node {
    properties([pipelineTriggers([cron('*/15 * * * * ')])])
	stage("Pull Repo"){
		checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/farrukh90/three-tier-app-demo.git']]])
}
	stage("Init"){
        
        dir("DB/") {
		    sh "terraform init"
    }
}
	stage("Apply"){
		dir("DB/") {
		    sh "terraform apply -auto-approve"
    }
}
	stage("Send Message"){
		echo "hello"
}
	stage("Send Email"){
		echo "hello"
	}
}
