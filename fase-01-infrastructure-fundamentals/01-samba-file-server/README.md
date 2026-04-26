# Mini-Proyecto 1: File Server Corporativo (Samba)

## Escenario
Servidor de archivos centralizado para la empresa **Logística Tandil**, con separación
estricta de acceso entre los sectores de **Contabilidad** y **Gerencia**.

**Requisitos principales:**
- Control de acceso por usuarios y grupos.
- Separación de permisos entre áreas.
- Registro de accesos y modificaciones (logging).

---

## Arquitectura de Usuarios y Permisos

- **Ruta base del share:** `/srv/samba`
- **Grupos de Linux:** `contadores`, `gerentes`
- **Política de permisos:** `2770` (SetGID) para asegurar herencia de grupo en archivos nuevos.
- **Modelo de seguridad:**  
  El control principal se delega al sistema de archivos (Linux), mientras que Samba
  actúa como capa de autenticación y compartición en red.

### Usuarios
- **pepe**
  - Lectura / Escritura en Contabilidad.
  - Sin acceso a Gerencia.
- **ana**
  - Lectura / Escritura en Gerencia.
  - **Solo lectura** en Contabilidad (restricción aplicada a nivel Samba mediante listas de acceso).

---

## Validación de Seguridad (Estado: OK)

- [x] Pepe puede leer y escribir en Contabilidad.
- [x] Pepe está bloqueado y no puede acceder a Gerencia.
- [x] Ana puede escribir en Gerencia.
- [x] Ana puede leer, pero **no crear ni modificar**, archivos en Contabilidad,
      aun perteneciendo al grupo Linux (restricción aplicada por Samba).

---

## Nota sobre Auditoría

Se utiliza **logging nativo de Samba (nivel 2)** para registrar accesos y eventos básicos.

El módulo de auditoría avanzada `vfs_full_audit` fue probado, pero provocaba el error
crítico `NT_STATUS_UNSUCCESSFUL`, impidiendo la conexión de los clientes.

Durante el troubleshooting se descartaron como causa:
- Bloqueos de AppArmor.
- Problemas de configuración de rsyslog.
- Falta de dependencias (`samba-vfs-modules` instalado).
- Errores evidentes en la configuración del módulo.

Al comentar o deshabilitar `vfs objects = full_audit`, el servicio funciona de forma
estable.

---

## Conclusión Técnica

Dado que el binario del módulo existe, los permisos son correctos y no se detectaron
bloqueos de seguridad externos, el problema apunta a un **bug de integración específico
de la versión de Samba empaquetada en Ubuntu Server (4.19.5-Ubuntu)** o a una
**incompatibilidad con el entorno de virtualización**, provocando un fallo silencioso
del módulo VFS.

**Acción tomada:** aplicar la *Regla de Bancarrota Técnica*.  
El costo de tiempo necesario para depurar el módulo supera el beneficio educativo de
esta fase del proyecto, priorizando la estabilidad del servicio y el cumplimiento de
los requisitos de seguridad.

---

## Estado del Proyecto

Servidor funcional y validado para el escenario propuesto.  
Proyecto cerrado a nivel práctico, con posibilidad de extender la auditoría en una
fase futura.
