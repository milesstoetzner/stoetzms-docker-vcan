# Docker Virtual CAN

Simple demo that connects two applications running in different containers on different hosts via a virtual CAN.
In a nutshell, each container initializes a virtual CAN and starts a [can2udp](https://opensource.lely.com/canopen/docs/can2udp) process.
In our demo we start the containers on the same docker engine and use `candump` as dummy application inside the container.

![Docker Virtual CAN Demo](figure.png)

We assume that
- ports 6001 and 6002 are available
- that the docker engine is reachable under `host.docker.internal`, which `docker-compose.yaml` maps to the host gateway

Note, since we initialize the CAN inside the container the NET_ADMIN capability is required.

The virtual CAN is created inside the container, but `vcan` is a kernel module of the host, which the container cannot load.
Therefore, the host must run Linux and have the `vcan` module loaded, e.g., via `sudo modprobe vcan`.
On Ubuntu cloud images, the module is not installed by default but is part of the `linux-modules-extra-$(uname -r)` package.

To start the services and to attach to the logs run the following command.
```
docker-compose up
```

You can send a message on one of the local CANs as follows.
```
docker-compose exec one cansend vcan0 01a#11223344AABBCCDD
```

Note, this example does NOT WORK with Docker Desktop on macOS or on Windows using WSL backend since their kernels do not support SocketCAN, see https://github.com/microsoft/WSL/issues/5533.
Use a Linux host or a Linux VM instead.