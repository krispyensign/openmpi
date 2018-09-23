FROM centos:latest
RUN yum -y install wget\
                   curl\
                   yum-utils\
                   rpm-build\
                   gcc\
                   gcc-c++\
                   gcc-gfortran\ 
                   make
WORKDIR /tmp
RUN echo "%_topdir      %(echo $HOME)/rpmbuild" > ~/.rpmmacros
RUN wget https://download.open-mpi.org/release/open-mpi/v3.1/openmpi-3.1.1-1.src.rpm\
  && rpm -ivh ./openmpi-3.1.1-1.src.rpm\
  && cd ~/rpmbuild/SPECS/\
  && rpmbuild -ba --define 'configure_options --prefix=/opt/openmpi --enable-openib-rdmacm' openmpi-3.1.1.spec
RUN wget https://www.nas.nasa.gov/assets/npb/NPB3.3.1.tar.gz\
  && tar xvfz NPB3.3.1.tar.gz
