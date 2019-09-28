UniFi
=====

Docker for UniFi 5.x (Ubiquiti Networks)

UniFi Controller is the software that manage Wireless Access Point, UniFi Switches, UniFi Gateway of the company Ubiquiti Networks (http://ubnt.com).

Forked from pducharme to switch to OpenJDK8 and newest version of controller.

This container is meant, or at least compatible, for unRAID. In order to persist this container between upgrades you should mount a persistent volume in /var/lib/unifi and /usr/lib/unifi/data.

Example

docker run -d -v ${PWD}/data:/usr/lib/unifi/data -v ${PWD}/lib:/var/lib/unifi -p 8080:8080 -p 8443:8443 -p 8880:8880 bmatticus/unifi_controller:latest
