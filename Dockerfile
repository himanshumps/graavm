# aikido-graalvm
FROM registry.access.redhat.com/rhel7/rhel

MAINTAINER Himanshu Gupta <himanshu_gupta01@infosys.com>

ENV BUILDER_VERSION 1.0

LABEL io.k8s.description="GraalVM" \
      io.k8s.display-name="GraalVM" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,graalvm" \
	  io.openshift.s2i.scripts-url=image:///usr/local/s2i

RUN yum install -y tar wget && yum clean all -y && rm -rf /var/cache/yum && mkdir /opt/app-root/ && cd /opt/app-root


# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/local/s2i
RUN wget https://github.com/himanshumps/graalvm/raw/master/graalvm-0.31-linux-amd64-jdk8.tar.gz http://www-eu.apache.org/dist/maven/maven-3/3.5.2/binaries/apache-maven-3.5.2-bin.tar.gz

RUN tar xvzf graalvm-0.31-linux-amd64-jdk8.tar.gz && tar xvzf apache-maven-3.5.2-bin.tar.gz && rm -rf graalvm-0.31-linux-amd64-jdk8.tar.gz apache-maven-3.5.2-bin.tar.gz

RUN export PATH=$(pwd)/apache-maven-3.5.2/bin:$(pwd)/graalvm-0.31/bin;$PATH:$(pwd)/apache-maven-3.5.2/bin

ENV JAVA_HOME $(pwd)/graalvm-0.31
# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root

USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 8080

# TODO: Set the default CMD for the image
# CMD ["/usr/libexec/s2i/usage"]
