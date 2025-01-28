FROM nginx:latest
ARG VERSION
ENV VERSION=$VERSION IMAGE_TAG=latest
COPY hostname.sh .
CMD ["/hostname.sh"]