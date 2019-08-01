#! groovy

pipeline {
   agent any

   stages {
      stage('Code analysis') {
         steps {
            sh '''
               /var/lib/jenkins/sonar-scanner-4.0.0.1744-linux/bin/sonar-scanner \
                  -Dsonar.projectKey=magento \
                  -Dsonar.sources=data \
                  -Dsonar.host.url=http://172.31.35.92:9000 \
                  -Dsonar.login=81a438b4dbb2e0ec4921641132c98209c7ae002e
            '''
         }
      }

      stage('Magento CI') {
         steps {
            sh 'chmod +x scripts/magento-ci.sh'
            sh 'scripts/magento-ci.sh'
         }
      }
   }

   post {
      // Borramos el workspace
      always {
         deleteDir()
      }
   }
}
