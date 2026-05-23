FROM apache/airflow:2.10.0

USER root

RUN apt-get update && \
    apt-get install -y \
    gcc \
    g++ \
    default-libmysqlclient-dev && \
    apt-get clean

USER airflow

COPY requirements.txt /requirements.txt

RUN pip install --no-cache-dir -r /requirements.txt

COPY dags /opt/airflow/dags

COPY plugins /opt/airflow/plugins

EXPOSE 8080

CMD ["bash", "-c", "airflow db migrate && airflow webserver"]