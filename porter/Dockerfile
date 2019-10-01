FROM debian:stretch

ARG BUNDLE_DIR

RUN apt-get update -y \
  && apt-get install curl apt-transport-https lsb-release gnupg -y \
  && curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null \
  && AZ_REPO=$(lsb_release -cs) \
  && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list \
  && apt-get update \
  && apt-get install azure-cli
# exec mixin has no buildtime dependencies

RUN apt-get update && \
 apt-get install -y curl && \
 curl -o helm.tgz https://storage.googleapis.com/kubernetes-helm/helm-v2.12.3-linux-amd64.tar.gz && \
 tar -xzf helm.tgz && \
 mv linux-amd64/helm /usr/local/bin && \
 rm helm.tgz
RUN helm init --client-only
RUN apt-get update && \
apt-get install -y apt-transport-https curl && \
curl -o kubectl https://storage.googleapis.com/kubernetes-release/release/v1.13.0/bin/linux/amd64/kubectl && \
mv kubectl /usr/local/bin && \
chmod a+x /usr/local/bin/kubectl

COPY cnab/ /cnab/
COPY porter.yaml /cnab/app/porter.yaml
WORKDIR /cnab/app
CMD ["/cnab/app/run"]