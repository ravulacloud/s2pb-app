FROM apache/airflow:2.10.0

##########################################################
# ROOT USER
##########################################################

USER root

##########################################################
# INSTALL SYSTEM PACKAGES
##########################################################

RUN apt-get update && \
    apt-get install -y \
    gcc \
    g++ \
    default-libmysqlclient-dev && \
    apt-get clean

##########################################################
# AIRFLOW USER
##########################################################

USER airflow

##########################################################
# PYTHON REQUIREMENTS
##########################################################

COPY requirements.txt /requirements.txt

RUN pip install --no-cache-dir -r /requirements.txt

##########################################################
# AIRFLOW DAGS
##########################################################

COPY dags /opt/airflow/dags

##########################################################
# AIRFLOW PLUGINS
##########################################################

COPY plugins /opt/airflow/plugins

##########################################################
# PORT
##########################################################

EXPOSE 8080

##########################################################
# REMOVE DEFAULT ENTRYPOINT
##########################################################

ENTRYPOINT []

##########################################################
# START AIRFLOW
##########################################################

CMD ["bash", "-c", "\
airflow db migrate && \
(airflow users create \
--username admin \
--password admin \
--firstname Airflow \
--lastname Admin \
--role Admin \
--email admin@example.com || true) && \
airflow standalone"]