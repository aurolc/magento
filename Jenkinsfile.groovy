#! groovy

pipeline {
   agent any

   stages {
      stage('Magento CI') {
         steps {
            sh 'scripts/magento-ci.sh'
         }
      }
   }
}
