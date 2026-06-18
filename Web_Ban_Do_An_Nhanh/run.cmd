@echo off
set "MAVEN_DIR=%~dp0.maven"
set "MAVEN_ZIP=%~dp0maven.zip"
set "MAVEN_BIN=%MAVEN_DIR%\apache-maven-3.9.6\bin\mvn.cmd"

if not exist "%MAVEN_BIN%" (
    echo =========================================================
    echo [BiteSync] Local Maven not found.
    echo [BiteSync] Downloading Apache Maven 3.9.6...
    echo =========================================================
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip' -OutFile '%MAVEN_ZIP%'"
    
    echo =========================================================
    echo [BiteSync] Extracting Maven...
    echo =========================================================
    powershell -Command "Expand-Archive -Path '%MAVEN_ZIP%' -DestinationPath '%MAVEN_DIR%'"
    
    echo [BiteSync] Cleaning up...
    del "%MAVEN_ZIP%"
)

echo =========================================================
echo [BiteSync] Starting Jetty Server on http://localhost:8080/
echo =========================================================
"%MAVEN_BIN%" jetty:run
