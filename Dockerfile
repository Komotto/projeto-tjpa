FROM registry.access.redhat.com/ubi9/ubi-minimal

WORKDIR  /app
COPY  . .

#Instalar tools
RUN  microdnf install -y unzip
RUN  microdnf install -y wget

#Instalar Java correto para o projeto
RUN  wget https://download.oracle.com/java/17/archive/jdk-17.0.12_linux-x64_bin.rpm
RUN  rpm -ivh jdk-17.0.12_linux-x64_bin.rpm

#Instalar Python
RUN  microdnf install python3 python3-pip -y

#Instalar SQLcl
WORKDIR  /opt
RUN  wget https://download.oracle.com/otn_software/java/sqldeveloper/sqlcl-latest.zip
RUN  unzip sqlcl-latest.zip -d /opt
RUN  chmod -R a+rX /opt/sqlcl
RUN  ln -s /opt/sqlcl/bin/sql /usr/local/bin/sql
RUN  chmod a+x /usr/local/bin/sql
RUN  rm sqlcl-latest.zip

#Dependencias do Python
WORKDIR  /app/datawarehouse/scripts/ia-qualificarpartes/classificador
RUN  pip3 install -r requirements.txt
RUN  pip3 install fastapi uvicorn

#Permissões do Openshift
RUN  chmod -R g+rwX /app /opt/sqlcl

RUN  microdnf clean all

EXPOSE  8080

CMD  ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]



