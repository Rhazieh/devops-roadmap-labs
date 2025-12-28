# Mini-Proyecto 1: File Server Corporativo (Samba)
## Escenario
* Servidor centralizado para Logística Tandil.
* Requisito Seguridad: Separación Contabilidad/Gerencia.
* Requisito Auditoria: Logs de acceso y modificación.

## Arquitectura de Usuarios
* **Ruta Base:** `/srv/samba`
* **Grupos:** `contadores`, `gerentes`
* **Permisos:** 2770 (SetGID) para herencia de grupo.
* **Usuarios:** `pepe` (RW Contabilidad), `ana` (RW Gerencia, R Contabilidad).

## Validación de Seguridad (Estado: OK)
* [x] Pepe puede leer y escribir en Contabilidad.
* [x] Pepe bloqueado/sin acceso a Gerencia.
* [x] Ana escribe en Gerencia.
* [x] Ana puede leer pero NO crea/edita/modifica en Contabilidad aunque esté en el grupo.

## Nota
* Se utiliza loggin nativo (nivel 2) ya que debido a la inestabilidad del módulo vfs_full_audit en el entorno de virtualización recibíamos el error "NT_STATUS_UNSUCCESFUL".
# Si desactivamos o comentamos el módulo "vfs objects = full_audit" funciona perfecto, aunque igual probamos sus posibles causas del error:
* [x] Verificamos si podía ser AppArmor el causante con alguna instruccion estricta, al ponerle complain (modo queja) reportó profile not found, por lo cual podemos asumir que AppArmor ni siquiera estaba vigilando a Samba
* [x] Cambiamos la config en /etc/rsyslog.d/ agregando samba-audit.conf con el contenido "local7.* /var/log/samba/audit.log" sin éxito.
* [x] Verificamos con dpkg -l y find que el paquete samba-vfs-modules esté instalado
* [x] Quitamos "syslog = 0" del [global]
* [x] Comentamos algunos parametros del modulo y tampoco hizo nada. 

## Conclusión técnica
Dado que el binario existe, los permisos son correctos y no hay bloqueos de seguridad externos, estamos ante un bug de integración específico de la versión de Samba empaquetada en este Ubuntu Server (4.19.5-Ubuntu) o una incompatibilidad con el entorno de virtualización que causa un segfault silencioso en el módulo.
Acción a Tomar: Aplicar la Regla de Bancarrota Técnica. El costo de tiempo para depurar el código fuente del módulo supera el beneficio educativo de esta fase.
