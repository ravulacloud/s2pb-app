FROM apache/airflow:2.10.0

##########################################################
# ROOT USER
##########################################################

USER root

##########################################################
# INSTALL PACKAGES
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
# REQUIREMENTS
##########################################################

COPY requirements.txt /requirements.txt

RUN pip install --no-cache-dir -r /requirements.txt

##########################################################
# DAGS
##########################################################

COPY dags /opt/airflow/dags

##########################################################
# PLUGINS
##########################################################

COPY plugins /opt/airflow/plugins

##########################################################
# PORT
##########################################################

EXPOSE 8080

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
airflow scheduler & \
exec airflow webserver"]