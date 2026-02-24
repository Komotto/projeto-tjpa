FROM registry.access.redhat.com/ubi9/ubi-minimal

WORKDIR  /app
COPY . .

#variável de Ambiente
ENV  CREDENCIAIS_DW=user/password@//host:1521:service 

#Instalar Git
RUN  dnf install git -y

#Clonar Repositório
RUN  git clone https://gitlab.tjpa.jus.br/administracao-de-dados/datawarehouse.git .

#Instalar Java correto para o projeto
RUN  wget https://download.oracle.com/java/17/archive/jdk-17.0.12_linux-x64_bin.rpm
RUN  rpm -ivh jdk-17.0.12_linux-x64_bin.rpm

#Instalar Python
RUN  yum install python3 python3-pip -y

#Instalar SCLcl
WORKDIR  /opt
RUN  wget https://download.oracle.com/otn_software/java/sqldeveloper/sqlcl-latest.zip
RUN  unzip sqlcl-latest.zip -d /opt
RUN  chmod -R a+rX /opt/sqlcl
RUN  ln -s /opt/sqlcl/bin/sql /usr/local/bin/sql
RUN  chmod a+x /usr/local/bin/sql
RUN  rm sqlcl-latest.zip

#Dependencias do Python
WORKDIR  datawarehouse/scripts/ia-qualificarpartes/classificador
RUN  pip3 install -r requirements.txt
RUN  pip3 install fastapi uvicorn

EXPOSE  8080

CMD  ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8080"]



