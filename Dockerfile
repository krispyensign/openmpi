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
  && rpmbuild -ba --define 'configure_options --prefix=/opt/openmpi --enable-openib-rdmacm' openmpi-3.1.1.spec\
  && cd ~/rpmbuild/RPMS/\
  && yum -y install openmpi-3.1.1-1.el7.x86_64.rpm

RUN wget https://www.nas.nasa.gov/assets/npb/NPB3.3.1.tar.gz\
  && tar xvfz NPB3.3.1.tar.gz\
  && cd NPB3.3.1/NPB3.3-MPI\
  && cp config/make.def.template config/make.def\
  && sed -i 's/f77/mpif77/g' config/make.def\
  && sed -i 's/MPICC = cc/MPICC = mpicc/g' config/make.def\
  && make ep NPROCS=8 CLASS=A\
  && make ep NPROCS=8 CLASS=C
