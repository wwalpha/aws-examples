FROM amazonlinux:2023

RUN dnf update -y
RUN dnf groupinstall "Development Tools" -y
RUN dnf install openssl-libs -y
RUN dnf install python3.11 python3.11-devel -y


RUN mkdir -p /opt/ocpp-gateway
COPY ./ /opt/ocpp-gateway/

RUN python3.11 -m venv /opt/ocpp-gateway/
RUN . /opt/ocpp-gateway/bin/activate && pip install -r /opt/ocpp-gateway/requirements.txt

EXPOSE 80

ENTRYPOINT /opt/ocpp-gateway/run-server.sh
CMD /opt/ocpp-gateway/run-server.sh
