pipeline {
    agent any

    environment {
        SONARQUBE_SERVER_URL = 'http://sonarqube:9000'
        SONARQUBE_CREDENTIALS = 'd0f89514-ca8f-4d5b-9403-a0244f83aa8c' 
    }

    stages {
        stage('Checkout') {
            steps {
                git 'https://github.com/s24582PJ/devops12.2.git' 
            }
        }

        stage('Setup Build Environment') {
            steps {
                sh 'sudo apt-get update'
                sh 'sudo apt-get install -y build-essential cmake g++'
                sh 'sudo apt-get install -y libgtest-dev'
                sh '''
                cd /usr/src/googletest
                sudo cmake .
                sudo make
                sudo cp googletest/lib/libgtest.a googletest/lib/libgtest_main.a /usr/lib
                '''
                sh 'sudo apt-get install -y gcovr'
                 sh 'sudo apt-get install -y cppcheck'
            script {
                    def scannerHome = tool name: 'SonarScanner'
                    env.PATH = "${scannerHome}/bin:${env.PATH}"
                }

            }
        }

        stage('Build') {
            steps {
                sh 'mkdir -p build'
                dir('build') {
                    sh 'cmake ..'
                    sh 'make'
                }
            }
        }

        stage('Run Unit Tests') {
            steps {
                sh 'cd build && make test'
            }
        }

        stage('Code Coverage') {
            steps {
                script {
                   sh 'cd build && cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS="-fprofile-arcs -ftest-coverage" ..'
                   sh 'cd build && make clean && make'

                    sh 'mkdir -p coverage_report'

                    sh '''
                    cd build
                    gcovr --root .. --html ../coverage_report/coverage.html
                    '''

                    publishHTML(target: [
                        reportName: 'Code Coverage',
                        reportDir: 'coverage_report',
                        reportFiles: 'coverage.html',
                        alwaysLinkToLastBuild: true,
                        keepAll: true
                    ])
                }
            }
        }
        
        stage('Static Code Analysis') {
            steps {
                sh 'cppcheck --version'
                sh 'cppcheck --enable=all --xml . 2> cppcheck.xml'
               // recordIssues tools: [cppCheck(pattern: 'cppcheck.xml')]
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('Local SonarQube') {
                   // sh '''
                  //  build-wrapper-linux-x86-64 --out-dir bw-output make clean all
                  //  '''
         
                        sh "sonar-scanner -Dsonar.projectKey=cpp-calculator -Dsonar.sources=. -Dsonar.host.url=${env.SONARQUBE_SERVER_URL} -Dsonar.login=admin -Dsonar.password=admin1"
                }
            }
        }
    }

    post {
        always {
            echo 'This will always run'
        }
    }
}
