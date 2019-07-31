#! groovy

pipeline {
   agent any

   stages {
      stage('Magento CI') {
         steps {
            sh 'chmod +x scripts/magento-ci.sh'
            sh 'scripts/magento-ci.sh'
         }
      }
   }
}
