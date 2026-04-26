# Prácticas y Laboratorios en Cisco Packet Tracer

Este directorio contiene las topologías y configuraciones de red simuladas como parte de la **Fase 1: Redes Fundamentales** del roadmap DevOps. 

El objetivo de estos laboratorios es validar de forma práctica los conceptos teóricos de enrutamiento, servicios de red (Capa 3 y 7) y seguridad perimetral.

---

## 🧩 Archivos y Topologías

### 1. Mini-Proyecto 2: Red de Oficina Virtual (`mini-project-2.pkt`)
Laboratorio integrador simulando una red corporativa segmentada y asegurada.
* **Equipos:** 1 Router (Cisco 2911), 2 Switches (Cisco 2960), 1 Servidor DNS, 6 PCs.
* **Segmentación de Red:**
  * LAN Izquierda (Ventas/Invitados): `192.168.10.0/24`
  * LAN Derecha (Operaciones): `192.168.20.0/24`
  * LAN Servidor (Servicios): `192.168.99.0/24`
* **Servicios Implementados:**
  * **DHCP:** Pools configurados directamente en el router para asignar IPs de forma dinámica a las LANs de usuarios.
  * **DNS:** Servidor estático (`192.168.99.10`) resolviendo el dominio interno `oficina.local`.
* **Seguridad y Filtrado (ACLs):**
  * Implementación de una **ACL Extendida (101)** aplicada en dirección *IN* sobre la interfaz de la LAN Izquierda.
  * **Regla estricta:** Bloquea la comunicación directa (inter-VLAN routing) hacia la LAN Derecha, pero cuenta con un `permit` explícito para garantizar el acceso al servidor DNS.

### 2. Práctica de Enrutamiento Dinámico y Seguridad (`OSPF.pkt`)
Laboratorio enfocado en protocolos de ruteo interno y control de acceso avanzado.
* **Enrutamiento:** Transición de redes estáticas a un entorno dinámico utilizando **OSPF (Open Shortest Path First)** de área única.
* **Seguridad:** Aplicación de **ACLs Extendidas** para el filtrado granular de tráfico entre los distintos segmentos de la topología.

---

> **Nota Técnica:** Los laboratorios fueron construidos desde cero, priorizando el uso de la CLI (Command Line Interface) de Cisco IOS sobre la interfaz gráfica del simulador para fomentar la memoria muscular en la configuración de equipos de red.
