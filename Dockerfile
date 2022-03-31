FROM ros:noetic

SHELL ["/bin/bash", "-c"]

RUN useradd ros
RUN mkdir /home/ros && chown -R ros: /home/ros
ENV HOME "/home/ros"
# This is useful when adding python stuff in user space
ENV PATH="/home/ros/.local/bin:${PATH}"
# This suppresses some python SSL warnings
ENV PYTHONWARNINGS="ignore:a true SSLContext object"
WORKDIR   /home/ros

RUN apt-get update && apt-get -y install npm
RUN apt-get -y install git-core

USER ros
RUN mkdir -p ~/ros_ws/src
# Add cloning of any ROS packages here (as root) and run catkin_make

EXPOSE 9090

USER root
COPY ./ros-entrypoint.sh /bin/
RUN ["chmod", "+x", "/bin/ros-entrypoint.sh"]
ENTRYPOINT ["/bin/ros-entrypoint.sh"]

USER ros
RUN mkdir ~/makecode && cd ~/makecode
RUN git clone https://github.com/HIRO-group/pxt.git && cd pxt && npm install && npm install roslib
RUN npm run build
RUN npm install -g @microsoft/pxt
RUN cd ../ && git clone https://github.com/microsoft/pxt-common-packages.git && cd pxt-common-packages && npm install
RUN cd ../ && git clone https://github.com/microsoft/pxt-microbit.git && cd pxt-microbit && npm install
RUN npm link ../pxt
RUN npm link ../pxt-common-packages

CMD ["/bin/bash", "pxt", "serve", "--rebundle"]