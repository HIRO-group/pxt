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

RUN apt-get update && apt-get -y install npm git-core ros-noetic-rosbridge-server

USER ros
RUN mkdir -p ~/ros_ws/src
# Add cloning of any ROS packages here (as root) and run catkin_make
# 

USER root
COPY ./ros-entrypoint.sh /bin/
RUN ["chmod", "+x", "/bin/ros-entrypoint.sh"]

RUN mkdir ~/makecode && cd ~/makecode && mkdir pxt
WORKDIR /home/ros/makecode
RUN git clone https://github.com/HIRO-group/pxt.git && cd pxt && npm install && npm install roslib && npm run build && \
    npm install -g pxt
# COPY . /home/ros/makecode/pxt
RUN cd /home/ros/makecode/pxt && npm install && npm install roslib && npm run build && \
    npm install -g pxt
RUN git clone https://github.com/microsoft/pxt-common-packages.git && cd pxt-common-packages && npm install
RUN git clone https://github.com/microsoft/pxt-microbit.git && cd pxt-microbit && npm install && npm link ../pxt && \
    npm link ../pxt-common-packages

ENTRYPOINT ["/bin/ros-entrypoint.sh"]

EXPOSE 3232
EXPOSE 3233
EXPOSE 9090

COPY launch-rosbridge-pxt.sh launch-rosbridge-pxt.sh
RUN chmod +x launch-rosbridge-pxt.sh
CMD ["./launch-rosbridge-pxt.sh"]
