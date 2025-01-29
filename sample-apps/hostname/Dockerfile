FROM nginx:latest
ARG VERSION
ENV VERSION=$VERSION IMAGE_TAG=v0.0.1
COPY hostname.sh .
CMD ["/hostname.sh"]