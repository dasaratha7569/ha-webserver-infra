pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('terraform') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    script {
                        CHANGES = sh(
                            script: 'bash check_tf_replacements.sh',
                            returnStdout: true
                        ).trim()

                        echo CHANGES
                    }
                }
            }
        }

        stage('Approval') {
            when {
                expression {
                    return CHANGES?.trim()
                }
            }
            steps {
                script {
                    input(
                        message: """Terraform detected destructive changes:

${CHANGES}

Do you want to continue?"""
                    )
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }

        stage('Generate Inventory') {
            steps {
                sh '''
                cd terraform

                terraform output -json instance_public_ips | jq -r '.[]' > /tmp/ips.txt

                cat > ../ansible/inventory.ini <<EOF
[webservers]
EOF

                cat /tmp/ips.txt >> ../ansible/inventory.ini

                cat >> ../ansible/inventory.ini <<EOF

[webservers:vars]
ansible_user=ec2-user
ansible_ssh_private_key_file=/var/lib/jenkins/terraform-key.pem
EOF
                '''
            }
        }

        stage('Ansible Ping') {
            steps {
                dir('ansible') {
                    sh 'ansible webservers -m ping'
                }
            }
        }

        stage('Configure Nginx') {
            steps {
                dir('ansible') {
                    sh 'ansible-playbook nginx.yml'
                }
            }
        }

        stage('Display ALB DNS') {
            steps {
                dir('terraform') {
                    sh 'terraform output alb_dns_name'
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment Successful'
        }

        failure {
            echo 'Deployment Failed'
        }
    }
}
