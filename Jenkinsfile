pipeline {
    agent any

    environment {
        RESOURCE_GROUP = "rg-react-movieapp"
        WEBAPP_NAME    = "react-movie-webapp-001"
        LOCATION       = "East US"
    }

    stages {
        stage('Clone Infra Repo') {
            steps {
                git url: 'https://github.com/AdityaNandan193/Terraform_moviesearch_deployment.git', branch: 'main'
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([azureServicePrincipal('jenkins-azure-sp')]) {
                    bat '''
                        set ARM_CLIENT_ID=%AZURE_CLIENT_ID%
                        set ARM_CLIENT_SECRET=%AZURE_CLIENT_SECRET%
                        set ARM_SUBSCRIPTION_ID=%AZURE_SUBSCRIPTION_ID%
                        set ARM_TENANT_ID=%AZURE_TENANT_ID%

                        terraform init
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: 'Apply Terraform to create infra?'
                withCredentials([azureServicePrincipal('jenkins-azure-sp')]) {
                    bat '''
                        set ARM_CLIENT_ID=%AZURE_CLIENT_ID%
                        set ARM_CLIENT_SECRET=%AZURE_CLIENT_SECRET%
                        set ARM_SUBSCRIPTION_ID=%AZURE_SUBSCRIPTION_ID%
                        set ARM_TENANT_ID=%AZURE_TENANT_ID%

                        terraform apply -auto-approve
                    '''
                }
            }
        }

        stage('Clone React App Repo & Build') {
            steps {
                dir('react-app') {
                    git url: 'https://github.com/YourName/react-movie-search', branch: 'main'
                    bat 'npm install'
                    bat 'npm run build'
                }
            }
        }

        stage('Zip React Build Folder') {
            steps {
                bat '''
                    powershell Compress-Archive -Path react-app\\build\\* -DestinationPath build.zip -Force
                '''
            }
        }

        stage('Deploy to Azure App Service') {
            steps {
                withCredentials([azureServicePrincipal('jenkins-azure-sp')]) {
                    bat '''
                        az login --service-principal -u %AZURE_CLIENT_ID% -p %AZURE_CLIENT_SECRET% --tenant %AZURE_TENANT_ID%
                        az webapp deployment source config-zip --resource-group %RESOURCE_GROUP% --name %WEBAPP_NAME% --src build.zip
                    '''
                }
            }
        }
    }
}
