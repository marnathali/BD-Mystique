---------TRIGGER--------------
CREATE OR REPLACE FUNCTION public.aud_delete_respuesta_comentario()
  RETURNS trigger AS
$BODY$
  DECLARE
    BEGIN
       INSERT INTO 
         auditoria(nombre_tabla, operacion, usuario, fecha_creacion, valor_viejo, valor_nuevo) VALUES(
          'respuesta_comentario', 'DELETE', session_user, now(), old, null);
            RETURN NULL;
            END
            $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.aud_delete_respuesta_comentario()
  OWNER TO postgres;




CREATE OR REPLACE FUNCTION public.aud_delete_respuesta_reclamo()
  RETURNS trigger AS
$BODY$
  DECLARE
    BEGIN
       INSERT INTO 
         auditoria(nombre_tabla, operacion, usuario, fecha_creacion, valor_viejo, valor_nuevo) VALUES(
          'respuesta_reclamo', 'DELETE', session_user, now(), old, null);
            RETURN NULL;
            END
            $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.aud_delete_respuesta_reclamo()
  OWNER TO postgres;



  CREATE OR REPLACE FUNCTION public.aud_delete_respuesta_solicitud()
  RETURNS trigger AS
$BODY$
  DECLARE
    BEGIN
       INSERT INTO 
         auditoria(nombre_tabla, operacion, usuario, fecha_creacion, valor_viejo, valor_nuevo) VALUES(
          'respuesta_solicitud', 'DELETE', session_user, now(), old, null);
            RETURN NULL;
            END
            $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.aud_delete_respuesta_solicitud()
  OWNER TO postgres;



CREATE OR REPLACE FUNCTION public.aud_insert_respuesta_comentario()
  RETURNS trigger AS
$BODY$
  DECLARE
    BEGIN
       INSERT INTO 
         auditoria(nombre_tabla, operacion, usuario, fecha_creacion, valor_viejo, valor_nuevo) VALUES(
          'respuesta_comentario', 'INSERT', session_user, now(), null, new);
            RETURN NULL;
            END
            $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.aud_insert_respuesta_comentario()
  OWNER TO postgres;


  CREATE OR REPLACE FUNCTION public.aud_update_respuesta_comentario()
  RETURNS trigger AS
$BODY$
  DECLARE
    BEGIN
       INSERT INTO 
         auditoria(nombre_tabla, operacion, usuario, fecha_creacion, valor_viejo, valor_nuevo) VALUES(
          'respuesta_comentario', 'UPDATE', session_user, now(), old, new);
            RETURN NULL;
            END
            $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.aud_update_respuesta_comentario()
  OWNER TO postgres;



CREATE OR REPLACE FUNCTION public.grabar_rango_edad()
  RETURNS trigger AS
$BODY$
DECLARE
BEGIN
IF date_part('years', age(NEW.fecha_nacimiento)) >= 18 AND date_part('years', age(NEW.fecha_nacimiento)) <=25 THEN
INSERT INTO perfil (id_valor_parametro,id_cliente) VALUES (15, NEW.id);
END IF;
IF date_part('years', age(NEW.fecha_nacimiento)) >= 26 AND date_part('years', age(NEW.fecha_nacimiento)) <= 35 THEN
INSERT INTO perfil (id_valor_parametro,id_cliente) VALUES (16, NEW.id);
END IF;
IF date_part('years', age(NEW.fecha_nacimiento)) >= 36 AND date_part('years', age(NEW.fecha_nacimiento)) <= 49 THEN
INSERT INTO perfil (id_valor_parametro,id_cliente) VALUES (17, NEW.id);
END IF;
IF date_part('years', age(NEW.fecha_nacimiento)) >= 50 AND date_part('years', age(NEW.fecha_nacimiento)) <= 80 THEN
INSERT INTO perfil (id_valor_parametro,id_cliente) VALUES (18, NEW.id);
END IF;


CREATE OR REPLACE FUNCTION public.horario_empleado()
  RETURNS trigger AS
$BODY$
  DECLARE
    BEGIN
       INSERT INTO horario_empleado(id_empleado, id_horario)
              SELECT new.id, b.id
              FROM   empleado a
              CROSS JOIN horario b
              WHERE a.id = new.id;      
             RETURN NULL;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.horario_empleado()
  OWNER TO postgres;


CREATE OR REPLACE FUNCTION public.notificacion_nueva_comentario()
  RETURNS trigger AS
$BODY$
  DECLARE
    BEGIN
       INSERT INTO
         notificacion(id_tipo_notificacion,
         id_usuario, id_registro) 
          SELECT 1, v.id, new.id
          FROM v_funcion_comentario v;         
             RETURN NULL;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.notificacion_nueva_comentario()
  OWNER TO postgres;


  CREATE OR REPLACE FUNCTION public.notificacion_nueva_incidencia()
  RETURNS trigger AS
$BODY$
  DECLARE
    BEGIN
       INSERT INTO
         notificacion(id_tipo_notificacion,
          id_usuario, id_registro) VALUES(
          7, (SELECT d.id_usuario FROM incidencia_orden a, orden_servicio b, solicitud c, cliente d 
          WHERE a.id_orden_servicio = b.id AND b.id_solicitud= c.id AND c.id_cliente = d.id AND a.id = NEW.id),
            NEW.id);
            RETURN NULL;
            END
            $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.notificacion_nueva_incidencia()
  OWNER TO postgres;


  CREATE OR REPLACE FUNCTION public.notificacion_nueva_reclamo()
  RETURNS trigger AS
$BODY$
  DECLARE
    BEGIN
       INSERT INTO
         notificacion(id_tipo_notificacion,
         id_usuario, id_registro) 
          SELECT 5, v.id, new.id
          FROM v_funcion_reclamo v;         
             RETURN NULL;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.notificacion_nueva_reclamo()
  OWNER TO postgres;



CREATE OR REPLACE FUNCTION public.notificacion_nueva_solicitud()
  RETURNS trigger AS
$BODY$
  DECLARE
    BEGIN
       INSERT INTO
         notificacion(id_tipo_notificacion,
         id_usuario, id_registro) 
          SELECT 3, v.id, new.id
          FROM v_funcion_solicitud v;         
             RETURN NULL;
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.notificacion_nueva_solicitud()
  OWNER TO postgres;


CREATE OR REPLACE FUNCTION public.notificacion_respuesta_comentario()
  RETURNS trigger AS
$BODY$
  DECLARE
    BEGIN
       INSERT INTO
         notificacion(id_tipo_notificacion,
          id_usuario, id_registro) VALUES(
          2, (SELECT c.id_usuario FROM respuesta_comentario a, comentario b, cliente c
          WHERE a.id_comentario = b.id AND b.id_cliente = c.id AND a.id = NEW.id),
            NEW.id);
            RETURN NULL;
            END
            $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.notificacion_respuesta_comentario()
  OWNER TO postgres;


  CREATE OR REPLACE FUNCTION public.notificacion_respuesta_reclamo()
  RETURNS trigger AS
$BODY$
  DECLARE
    BEGIN
       INSERT INTO
         notificacion(id_tipo_notificacion,
          id_usuario, id_registro) VALUES(
          6, (SELECT f.id_usuario FROM respuesta_reclamo a, reclamo b, detalle_servicio c, orden_servicio d, solicitud e, cliente f 
          WHERE a.id_reclamo = b.id AND b.id_detalle_servicio = c.id AND c.id_orden_servicio= d.id AND d.id_solicitud= e.id AND e.id_cliente = f.id AND a.id = NEW.id),
            NEW.id);
            RETURN NULL;
            END
            $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.notificacion_respuesta_reclamo()
  OWNER TO postgres;


CREATE OR REPLACE FUNCTION public.notificacion_respuesta_solicitud()
  RETURNS trigger AS
$BODY$
  DECLARE
    BEGIN
       INSERT INTO
         notificacion(id_tipo_notificacion,
          id_usuario, id_registro) VALUES(
          4, (SELECT c.id_usuario FROM respuesta_solicitud a, solicitud b, cliente c
          WHERE a.id_solicitud = b.id AND b.id_cliente = c.id AND a.id = NEW.id),
            NEW.id);
            RETURN NULL;
            END
            $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.notificacion_respuesta_solicitud()
  OWNER TO postgres;


  --Y PARA CADA TABLA ASOCIADA AL TRIGGER:---
  CREATE TRIGGER notificacion_nueva_comentario
  AFTER INSERT
  ON public.comentario
  FOR EACH ROW
  EXECUTE PROCEDURE public.notificacion_nueva_comentario();
--NOTA: AFTER INSERT o UPDATE, depende de lo que se desea hacer--

-------VISTAS---------

CREATE OR REPLACE VIEW public.v_calificacion_orden AS 
 SELECT a.id,
    a.id_criterio,
    a.id_orden_servicio,
    a.puntuacion,
    a.fecha_creacion,
    a.estatus,
    b.id AS criterio,
    b.nombre
   FROM calificacion_orden a
     JOIN criterio b ON b.id = a.id_criterio
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.v_calificacion_orden
  OWNER TO postgres;


  CREATE OR REPLACE VIEW public.v_citas_agenda AS 
 SELECT a.id,
    a.id_cliente,
    a.id_incidencia,
    a.estado,
    b.id AS cita,
    b.id_orden_servicio,
    b.id_agenda,
    b.estado AS estado_cita,
    b.fecha_creacion,
    c.id_cita,
    c.id_horario,
    d.id AS el_horario,
    d.id_bloque,
    d.id_dia_laborable,
    e.dia,
    f.hora_inicio,
    f.hora_fin,
    g.id AS orden_servicio,
    g.id_solicitud,
    g.id_orden_servicio AS otra_orden,
    g.estado AS estado_orden,
    h.id AS solicitud,
    h.id_promocion,
    h.id_cliente AS el_cliente,
    i.nombre,
    i.apellido,
    i.id_usuario,
    j.correo
   FROM agenda a
     JOIN cita b ON b.id_agenda = a.id
     JOIN horario_cita c ON c.id_cita = b.id
     JOIN horario d ON c.id_horario = d.id
     JOIN dia_laborable e ON e.id = d.id_dia_laborable
     JOIN bloque f ON f.id = d.id_bloque
     JOIN orden_servicio g ON g.id = b.id_orden_servicio
     JOIN solicitud h ON h.id = g.id_solicitud
     JOIN cliente i ON i.id = h.id_cliente
     JOIN usuario j ON j.id = i.id_usuario
  WHERE a.estatus = 'A'::bpchar AND h.estado = 'A'::bpchar;

ALTER TABLE public.v_citas_agenda
  OWNER TO postgres;



CREATE OR REPLACE VIEW public.v_cliente_consejo AS 
 SELECT a.id,
    a.titulo,
    a.descripcion,
    a.imagen,
    a.autor,
    a.fecha_creacion,
    a.estatus,
    b.id_consejo AS detalle_consejo,
    b.id_valor_parametro,
    c.id AS valor_parametro,
    c.nombre AS nombre_valor,
    d.id AS perfil,
    e.id AS cliente,
    e.nombre AS nombre_cliente,
    e.apellido
   FROM consejo a
     JOIN detalle_consejo b ON b.id_consejo = a.id
     JOIN valor_parametro c ON c.id = b.id_valor_parametro
     JOIN perfil d ON d.id_valor_parametro = b.id_valor_parametro
     JOIN cliente e ON e.id = d.id_cliente
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.v_cliente_consejo
  OWNER TO postgres;


CREATE OR REPLACE VIEW public.v_cliente_promocion AS 
 SELECT a.id AS promocion,
    a.id_servicio,
    a.nombre,
    a.descripcion,
    a.porcentaje_descuento,
    a.precio_promocion,
    a.imagen,
    a.fecha_inicio,
    a.fecha_fin,
    a.estatus,
    a.fecha_creacion,
    b.id_promocion AS detalle_promocion,
    b.id_valor_parametro,
    c.id AS valor_parametro,
    c.nombre AS nombre_valor,
    d.id AS perfil,
    e.id AS cliente,
    e.nombre AS nombre_cliente,
    e.apellido
   FROM promocion a
     JOIN detalle_promocion b ON b.id_promocion = a.id
     JOIN valor_parametro c ON c.id = b.id_valor_parametro
     JOIN perfil d ON d.id_valor_parametro = b.id_valor_parametro
     JOIN cliente e ON e.id = d.id_cliente
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.v_cliente_promocion
  OWNER TO postgres;


CREATE OR REPLACE VIEW public.v_cliente_servicio AS 
 SELECT a.id,
    a.imagen,
    a.nombre,
    a.descripcion,
    a.precio,
    a.duracion,
    a.fecha_creacion,
    a.estatus,
    b.id_servicio AS servicio_parametro,
    b.id_valor_parametro,
    c.id AS valor_parametro,
    c.nombre AS nombre_valor,
    d.id AS perfil,
    e.id AS cliente,
    e.nombre AS nombre_cliente,
    e.apellido
   FROM servicio a
     JOIN servicio_parametro b ON b.id_servicio = a.id
     JOIN valor_parametro c ON c.id = b.id_valor_parametro
     JOIN perfil d ON d.id_valor_parametro = b.id_valor_parametro
     JOIN cliente e ON e.id = d.id_cliente
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.v_cliente_servicio
  OWNER TO postgres;


  CREATE OR REPLACE VIEW public.v_comentarios AS 
 SELECT a.id,
    a.id_cliente,
    a.id_tipo_comentario,
    b.nombre,
    b.apellido,
    d.correo,
    c.nombre AS tipo_comentario,
    a.descripcion,
    a.fecha_creacion,
    a.estado
   FROM comentario a
     JOIN tipo_comentario c ON c.id = a.id_tipo_comentario
     JOIN cliente b ON b.id = a.id_cliente
     JOIN usuario d ON d.id = b.id_usuario
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.v_comentarios
  OWNER TO postgres;


  CREATE OR REPLACE VIEW public.v_detalle_consejo AS 
 SELECT a.id,
    a.id_consejo,
    a.id_valor_parametro,
    b.titulo AS promocion,
    c.nombre,
    d.nombre AS parametro,
    e.nombre AS tipo_parametro,
    e.clasificacion
   FROM detalle_consejo a
     JOIN consejo b ON b.id = a.id_consejo
     JOIN valor_parametro c ON c.id = a.id_valor_parametro
     JOIN parametro d ON d.id = c.id_parametro
     JOIN tipo_parametro e ON e.id = d.id_tipo_parametro
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.v_detalle_consejo
  OWNER TO postgres;



CREATE OR REPLACE VIEW public.v_detalle_promocion AS 
 SELECT a.id,
    a.id_promocion,
    a.id_valor_parametro,
    b.nombre AS promocion,
    c.nombre,
    d.nombre AS parametro,
    e.nombre AS tipo_parametro,
    e.clasificacion
   FROM detalle_promocion a
     JOIN promocion b ON b.id = a.id_promocion
     JOIN valor_parametro c ON c.id = a.id_valor_parametro
     JOIN parametro d ON d.id = c.id_parametro
     JOIN tipo_parametro e ON e.id = d.id_tipo_parametro
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.v_detalle_promocion
  OWNER TO postgres;



CREATE OR REPLACE VIEW public.v_detalle_proveedor AS 
 SELECT a.id AS detalle_proveedor,
    a.id_proveedor,
    a.id_insumo,
    b.id,
    b.nombre AS tipo_insumo,
    c.nombre,
    c.id_tipo_insumo,
    c.cantidad,
    d.nombre AS unidad,
    c.id_unidad
   FROM detalle_proveedor a
     JOIN insumo c ON c.id = a.id_insumo
     JOIN tipo_insumo b ON b.id = c.id_tipo_insumo
     JOIN unidad d ON d.id = c.id_unidad
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.v_detalle_proveedor
  OWNER TO postgres;


  CREATE OR REPLACE VIEW public.v_detalle_servicios_true AS 
 SELECT a.id AS detalle_servicio,
    a.id_orden_servicio,
    a.id_servicio_solicitado,
    a.fecha_creacion AS fecha_detalle,
    a.estatus AS a_estatus,
    a.realizacion,
    b.id AS servicio_solicitado,
    b.id_solicitud AS ss_solicitud,
    b.id_servicio,
    b.fecha_creacion AS fecha_servicio_solicitado,
    b.estatus AS estatus_servicio_solicitado,
    c.id AS servicio,
    c.imagen,
    c.descripcion,
    c.id_tipo_servicio,
    d.nombre AS el_tipo,
    c.nombre AS nombre_servicio,
    d.id AS tipo_servicio,
    d.id_categoria_servicio,
    e.id AS categoria_servicio,
    e.nombre AS la_categoria,
    f.id AS orden_servicio,
    f.id_solicitud AS os_solicitud,
    f.estado AS estado_orden
   FROM detalle_servicio a
     JOIN servicio_solicitado b ON b.id = a.id_servicio_solicitado
     JOIN orden_servicio f ON f.id = a.id_orden_servicio
     JOIN servicio c ON c.id = b.id_servicio
     JOIN tipo_servicio d ON d.id = c.id_tipo_servicio
     JOIN categoria_servicio e ON e.id = d.id_categoria_servicio
  WHERE a.estatus = 'A'::bpchar AND a.realizacion = true AND f.estado = 'R'::bpchar OR f.estado = 'C'::bpchar;

ALTER TABLE public.v_detalle_servicios_true
  OWNER TO postgres;




CREATE OR REPLACE VIEW public.v_empleados_orden AS 
 SELECT a.id_empleado,
    a.id_orden_servicio,
    b.id,
    b.nombre,
    b.apellido,
    b.cedula,
    b.telefono,
    b.direccion,
    b.fecha_nacimiento
   FROM empleado_asignado a
     JOIN empleado b ON b.id = a.id_empleado
  WHERE b.estatus = 'A'::bpchar;

ALTER TABLE public.v_empleados_orden
  OWNER TO postgres;


CREATE OR REPLACE VIEW public.v_funcion_comentario AS 
 SELECT b.id,
    a.id_funcion,
    a.id_rol
   FROM usuario b
     JOIN rol_funcion a ON a.id_rol = b.id_rol
  WHERE a.id = 24 AND b.estatus = 'A'::bpchar;

ALTER TABLE public.v_funcion_comentario
  OWNER TO postgres;


  CREATE OR REPLACE VIEW public.v_funcion_reclamo AS 
 SELECT b.id,
    a.id_funcion,
    a.id_rol
   FROM usuario b
     JOIN rol_funcion a ON a.id_rol = b.id_rol
  WHERE a.id = 23 AND b.estatus = 'A'::bpchar;

ALTER TABLE public.v_funcion_reclamo
  OWNER TO postgres;



CREATE OR REPLACE VIEW public.v_funcion_solicitud AS 
 SELECT b.id,
    a.id_funcion,
    a.id_rol
   FROM usuario b
     JOIN rol_funcion a ON a.id_rol = b.id_rol
  WHERE a.id = 21 AND b.estatus = 'A'::bpchar;

ALTER TABLE public.v_funcion_solicitud
  OWNER TO postgres;



  CREATE OR REPLACE VIEW public.v_incidencia_de_orden AS 
 SELECT a.id,
    a.id_orden_servicio,
    a.id_tipo_incidencia,
    a.fecha_creacion,
    a.estatus,
    b.id AS el_tipo,
    b.nombre AS tipo_incidencia,
    c.id AS la_razon,
    c.nombre AS razon_incidencia,
    c.descripcion
   FROM incidencia_orden a
     JOIN tipo_incidencia b ON b.id = a.id_tipo_incidencia
     JOIN razon_incidencia c ON c.id = b.id_razon_incidencia
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.v_incidencia_de_orden
  OWNER TO postgres;



  CREATE OR REPLACE VIEW public.v_insumo_asociados AS 
 SELECT a.id AS insumo_asociado,
    a.id_insumo,
    a.id_servicio,
    b.id,
    c.nombre AS tipo_insumo,
    b.nombre,
    b.id_tipo_insumo,
    b.cantidad,
    d.nombre AS unidad,
    b.id_unidad
   FROM insumo_asociado a
     JOIN insumo b ON b.id = a.id_insumo
     JOIN tipo_insumo c ON c.id = b.id_tipo_insumo
     JOIN unidad d ON d.id = b.id_unidad
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.v_insumo_asociados
  OWNER TO postgres;


CREATE OR REPLACE VIEW public.v_insumos AS 
 SELECT a.id,
    b.nombre AS tipo_insumo,
    a.nombre,
    a.id_tipo_insumo,
    a.cantidad,
    c.nombre AS unidad,
    a.id_unidad
   FROM insumo a
     JOIN tipo_insumo b ON b.id = a.id_tipo_insumo
     JOIN unidad c ON c.id = a.id_unidad
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.v_insumos
  OWNER TO postgres;



CREATE OR REPLACE VIEW public.v_orden AS 
 SELECT a.id,
    a.id_solicitud,
    a.estado,
    a.estatus,
    b.id AS solicitud,
    b.id_cliente,
    b.estado AS estado_s,
    c.id AS cliente,
    c.nombre,
    c.apellido
   FROM orden_servicio a
     JOIN solicitud b ON a.id_solicitud = b.id
     JOIN cliente c ON c.id = b.id_cliente
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.v_orden
  OWNER TO postgres;


CREATE OR REPLACE VIEW public.v_perfil AS 
 SELECT a.id AS id_perfil,
    a.id_cliente,
    a.id_valor_parametro,
    a.estatus,
    a.fecha_creacion,
    b.nombre AS valor,
    b.descripcion,
    c.nombre AS parametro,
    d.nombre AS caracteristica,
    d.clasificacion
   FROM perfil a
     JOIN valor_parametro b ON b.id = a.id_valor_parametro
     JOIN parametro c ON c.id = b.id_parametro
     JOIN tipo_parametro d ON d.id = c.id_tipo_parametro
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.v_perfil
  OWNER TO postgres;


  CREATE OR REPLACE VIEW public.v_roles AS 
 SELECT a.id,
    a.nombre,
    ARRAY( SELECT b.id
           FROM funcion b
             JOIN rol_funcion c ON c.id_funcion = b.id
          WHERE a.id = c.id_rol AND b.estatus = 'A'::bpchar) AS funciones
   FROM rol a
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.v_roles
  OWNER TO postgres;



  CREATE OR REPLACE VIEW public.v_servicio_parametro AS 
 SELECT a.id,
    a.id_servicio,
    a.id_valor_parametro,
    b.nombre AS promocion,
    c.nombre,
    d.nombre AS parametro,
    e.nombre AS tipo_parametro,
    e.clasificacion
   FROM servicio_parametro a
     JOIN servicio b ON b.id = a.id_servicio
     JOIN valor_parametro c ON c.id = a.id_valor_parametro
     JOIN parametro d ON d.id = c.id_parametro
     JOIN tipo_parametro e ON e.id = d.id_tipo_parametro
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.v_servicio_parametro
  OWNER TO postgres;


  CREATE OR REPLACE VIEW public.v_servicion_con_incidencia AS 
 SELECT a.id AS detalle_servicio,
    a.id_orden_servicio,
    a.id_servicio_solicitado,
    a.fecha_creacion AS fecha_detalle,
    a.estatus AS a_estatus,
    a.realizacion,
    b.id AS servicio_solicitado,
    b.id_solicitud AS ss_solicitud,
    b.id_servicio,
    b.fecha_creacion AS fecha_servicio_solicitado,
    b.estatus AS estatus_servicio_solicitado,
    c.id AS servicio,
    c.imagen,
    c.descripcion,
    c.id_tipo_servicio,
    d.nombre AS el_tipo,
    c.nombre AS nombre_servicio,
    g.id AS incidencia_servicio,
    g.id_tipo_incidencia,
    g.descripcion AS desc_incidencia,
    h.nombre AS tipo_incidencia,
    i.nombre AS la_razon,
    i.descripcion AS razon_incidencia,
    d.id AS tipo_servicio,
    d.id_categoria_servicio,
    e.id AS categoria_servicio,
    e.nombre AS la_categoria,
    f.id AS orden_servicio,
    f.id_solicitud AS os_solicitud,
    f.estado AS estado_orden
   FROM detalle_servicio a
     JOIN servicio_solicitado b ON b.id = a.id_servicio_solicitado
     JOIN orden_servicio f ON f.id = a.id_orden_servicio
     JOIN servicio c ON c.id = b.id_servicio
     JOIN tipo_servicio d ON d.id = c.id_tipo_servicio
     JOIN categoria_servicio e ON e.id = d.id_categoria_servicio
     JOIN incidencia_servicio g ON g.id_detalle_servicio = a.id
     JOIN tipo_incidencia h ON h.id = g.id_tipo_incidencia
     JOIN razon_incidencia i ON i.id = h.id_razon_incidencia
  WHERE a.estatus = 'A'::bpchar AND a.realizacion = true AND f.estado = 'R'::bpchar;

ALTER TABLE public.v_servicion_con_incidencia
  OWNER TO postgres;


CREATE OR REPLACE VIEW public.v_servicios_calificados AS 
 SELECT a.id AS detalle_servicio,
    a.id_orden_servicio,
    a.id_servicio_solicitado,
    a.fecha_creacion AS fecha_detalle,
    a.estatus AS a_estatus,
    a.realizacion,
    b.id AS servicio_solicitado,
    b.id_solicitud AS ss_solicitud,
    b.id_servicio,
    b.fecha_creacion AS fecha_servicio_solicitado,
    b.estatus AS estatus_servicio_solicitado,
    c.id AS servicio,
    c.imagen,
    c.descripcion,
    c.id_tipo_servicio,
    d.nombre AS el_tipo,
    c.nombre AS nombre_servicio,
    g.id AS calificacion,
    g.puntuacion,
    d.id AS tipo_servicio,
    d.id_categoria_servicio,
    e.id AS categoria_servicio,
    e.nombre AS la_categoria,
    f.id AS orden_servicio,
    f.id_solicitud AS os_solicitud,
    f.estado AS estado_orden
   FROM detalle_servicio a
     JOIN servicio_solicitado b ON b.id = a.id_servicio_solicitado
     JOIN orden_servicio f ON f.id = a.id_orden_servicio
     JOIN servicio c ON c.id = b.id_servicio
     JOIN tipo_servicio d ON d.id = c.id_tipo_servicio
     JOIN categoria_servicio e ON e.id = d.id_categoria_servicio
     JOIN calificacion_servicio g ON g.id_detalle_servicio = a.id
  WHERE a.estatus = 'A'::bpchar AND a.realizacion = true AND f.estado = 'R'::bpchar;

ALTER TABLE public.v_servicios_calificados
  OWNER TO postgres;


CREATE OR REPLACE VIEW public.v_servicios_con_garantia AS 
 SELECT a.id AS detalle_servicio,
    a.id_orden_servicio,
    a.id_servicio_solicitado,
    a.fecha_creacion AS fecha_detalle,
    a.estatus AS a_estatus,
    a.realizacion,
    b.id AS servicio_solicitado,
    b.id_solicitud AS ss_solicitud,
    b.id_servicio,
    b.fecha_creacion AS fecha_servicio_solicitado,
    b.estatus AS estatus_servicio_solicitado,
    c.id AS servicio,
    c.imagen,
    c.descripcion,
    c.id_tipo_servicio,
    d.nombre AS el_tipo,
    c.nombre AS nombre_servicio,
    g.id AS id_garantia,
    g.cantidad_dias,
    g.descripcion AS garantia,
    d.id AS tipo_servicio,
    d.id_categoria_servicio,
    e.id AS categoria_servicio,
    e.nombre AS la_categoria,
    f.id AS orden_servicio,
    f.id_solicitud AS os_solicitud,
    f.estado AS estado_orden
   FROM detalle_servicio a
     JOIN servicio_solicitado b ON b.id = a.id_servicio_solicitado
     JOIN orden_servicio f ON f.id = a.id_orden_servicio
     JOIN servicio c ON c.id = b.id_servicio
     JOIN tipo_servicio d ON d.id = c.id_tipo_servicio
     JOIN categoria_servicio e ON e.id = d.id_categoria_servicio
     JOIN garantia g ON g.id_servicio = c.id
  WHERE a.estatus = 'A'::bpchar AND a.realizacion = true AND f.estado = 'R'::bpchar;

ALTER TABLE public.v_servicios_con_garantia
  OWNER TO postgres;


CREATE OR REPLACE VIEW public.v_solicitud_orden_espera AS 
 SELECT a.id,
    a.id_cliente,
    a.id_promocion,
    ( SELECT count(1) AS count
           FROM servicio_solicitado c_1
          WHERE c_1.id_solicitud = a.id) AS cantidad_servicios,
    a.sexo,
    a.empleado,
    a.estado,
    c.id AS presupuesto,
    c.id_solicitud AS s_presupuesto,
    c.monto_total,
    b.id AS orden_servicio,
    b.id_orden_servicio,
    b.id_solicitud
   FROM solicitud a
     JOIN orden_servicio b ON a.id = b.id_solicitud
     JOIN presupuesto c ON c.id_solicitud = a.id
  WHERE a.estatus = 'A'::bpchar AND b.estado = 'E'::bpchar;

ALTER TABLE public.v_solicitud_orden_espera
  OWNER TO postgres;


CREATE OR REPLACE VIEW public.v_todas_promociones AS 
 SELECT a.id,
    a.id_servicio,
    a.nombre,
    a.descripcion,
    a.porcentaje_descuento,
    a.precio_promocion,
    a.imagen,
    a.fecha_inicio,
    a.fecha_fin,
    a.estatus,
    a.fecha_creacion,
    a.estado,
    b.id AS el_id_servicio,
    (((c.nombre::text || ' '::text) || b.nombre::text) || ' '::text) || d.nombre::text AS servicios
   FROM promocion a
     JOIN servicio b ON b.id = a.id_servicio
     JOIN tipo_servicio c ON c.id = b.id_tipo_servicio
     JOIN categoria_servicio d ON d.id = c.id_categoria_servicio
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.v_todas_promociones
  OWNER TO postgres;


CREATE OR REPLACE VIEW public.v_todos_consejos AS 
 SELECT a.id,
    a.imagen,
    a.titulo,
    a.descripcion,
    a.autor,
    a.fecha_creacion
   FROM consejo a
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.v_todos_consejos
  OWNER TO postgres;



CREATE OR REPLACE VIEW public.v_todos_servicio_garantia AS 
 SELECT a.id,
    b.nombre AS tipo_servicio,
    a.nombre,
    a.imagen,
    a.precio,
    a.descripcion,
    c.nombre AS categoria_servicio,
    d.id AS garantia,
    d.cantidad_dias,
    d.descripcion AS desc_garantia,
    d.id_servicio
   FROM servicio a
     JOIN tipo_servicio b ON b.id = a.id_tipo_servicio
     JOIN categoria_servicio c ON c.id = b.id_categoria_servicio
     JOIN garantia d ON d.id_servicio = a.id
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.v_todos_servicio_garantia
  OWNER TO postgres;



CREATE OR REPLACE VIEW public.vista_empleado_asignado AS 
 SELECT a.id,
    a.id_empleado,
    a.id_orden_servicio,
    b.nombre,
    b.apellido,
    b.cedula,
    b.telefono,
    b.direccion,
    b.fecha_nacimiento,
    b.sexo
   FROM empleado_asignado a
     JOIN empleado b ON a.id_empleado = b.id
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.vista_empleado_asignado
  OWNER TO postgres;


CREATE OR REPLACE VIEW public.vista_especialidad AS 
 SELECT a.id,
    a.id_empleado,
    a.id_categoria_servicio,
    b.nombre,
    b.apellido,
    b.cedula,
    b.telefono,
    b.direccion,
    b.fecha_nacimiento,
    b.sexo
   FROM especialidad a
     JOIN empleado b ON a.id_empleado = b.id
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.vista_especialidad
  OWNER TO postgres;



CREATE OR REPLACE VIEW public.vista_horario_empleado AS 
 SELECT a.id,
    a.id_horario,
    a.id_empleado,
    a.id_cita,
    b.id_dia_laborable,
    b.id_bloque,
    c.dia,
    d.hora_inicio,
    d.hora_fin
   FROM horario_empleado a
     JOIN horario b ON b.id = a.id_horario
     JOIN dia_laborable c ON c.id = b.id_dia_laborable
     JOIN bloque d ON d.id = b.id_bloque
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.vista_horario_empleado
  OWNER TO postgres;



CREATE OR REPLACE VIEW public.vista_presupuesto AS 
 SELECT b.id,
    a.id_solicitud,
    a.monto_total
   FROM presupuesto a
     JOIN solicitud b ON b.id = a.id_solicitud
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.vista_presupuesto
  OWNER TO postgres;


CREATE OR REPLACE VIEW public.vista_reclamos_realizados AS 
 SELECT a.id,
    a.descripcion,
    a.fecha_creacion AS registro_reclamo,
    b.id_orden_servicio,
    b.id_servicio_solicitado,
    b.fecha_creacion AS dia_atendido,
    e.nombre AS tipo_servicio,
    c.nombre AS servicio_reclamado,
    d.cantidad_dias AS garantia,
    f.id_solicitud,
    g.id_cliente,
    h.nombre,
    h.apellido
   FROM reclamo a
     JOIN detalle_servicio b ON b.id = a.id_detalle_servicio
     JOIN servicio c ON c.id = b.id_servicio_solicitado
     JOIN tipo_servicio e ON e.id = c.id_tipo_servicio
     JOIN garantia d ON d.id_servicio = c.id
     JOIN orden_servicio f ON b.id_orden_servicio = f.id
     JOIN solicitud g ON f.id_solicitud = g.id
     JOIN cliente h ON g.id_cliente = h.id
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.vista_reclamos_realizados
  OWNER TO postgres;


CREATE OR REPLACE VIEW public.vista_respuesta_comentario AS 
 SELECT a.id,
    a.id_tipo_respuesta_comentario,
    a.id_comentario,
    a.descripcion,
    b.nombre AS tipo_respuesta_comentario
   FROM respuesta_comentario a
     JOIN tipo_respuesta_comentario b ON b.id = a.id_tipo_respuesta_comentario
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.vista_respuesta_comentario
  OWNER TO postgres;


CREATE OR REPLACE VIEW public.vista_respuesta_presupuesto AS 
 SELECT a.id,
    a.id_presupuesto,
    a.descripcion,
    b.nombre,
    a.fecha_creacion
   FROM respuesta_presupuesto a
     JOIN tipo_respuesta_presupuesto b ON b.id = a.id_tipo_respuesta_presupuesto
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.vista_respuesta_presupuesto
  OWNER TO postgres;


  CREATE OR REPLACE VIEW public.vista_respuesta_solicitud AS 
 SELECT a.id,
    a.id_solicitud,
    a.id_tipo_respuesta_solicitud,
    a.descripcion,
    a.fecha_creacion,
    b.nombre
   FROM respuesta_solicitud a
     JOIN tipo_respuesta_solicitud b ON b.id = a.id_tipo_respuesta_solicitud
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.vista_respuesta_solicitud
  OWNER TO postgres;


CREATE OR REPLACE VIEW public.vista_servicio_solicitado AS 
 SELECT a.id,
    a.id_servicio,
    d.id AS solicitud,
    b.nombre AS nombre_servicio,
    c.nombre AS tipo_servicio
   FROM servicio_solicitado a
     JOIN solicitud d ON d.id = a.id_solicitud
     JOIN servicio b ON b.id = a.id_servicio
     JOIN tipo_servicio c ON c.id = b.id_tipo_servicio
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.vista_servicio_solicitado
  OWNER TO postgres;



CREATE OR REPLACE VIEW public.vista_servicios_categoria AS 
 SELECT a.id,
    a.nombre,
    a.imagen,
    a.precio,
    a.descripcion,
    a.id_tipo_servicio,
    a.fecha_creacion,
    a.estatus,
    b.nombre AS tipo_servicio,
    b.id_categoria_servicio,
    c.nombre AS categoria_servicio
   FROM servicio a
     JOIN tipo_servicio b ON b.id = a.id_tipo_servicio
     JOIN categoria_servicio c ON c.id = b.id_categoria_servicio
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.vista_servicios_categoria
  OWNER TO postgres;



CREATE OR REPLACE VIEW public.vista_solicitud_presupuesto AS 
 SELECT a.id,
    a.id_solicitud,
    a.estado,
    a.monto_total,
    b.descripcion,
    b.id_tipo_respuesta_presupuesto,
    c.nombre
   FROM presupuesto a
     JOIN respuesta_presupuesto b ON a.id = b.id_presupuesto
     JOIN tipo_respuesta_presupuesto c ON c.id = b.id_tipo_respuesta_presupuesto
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.vista_solicitud_presupuesto
  OWNER TO postgres;



CREATE OR REPLACE VIEW public.vista_solicitudes AS 
 SELECT a.id,
    a.id_cliente,
    a.id_promocion,
    ( SELECT count(1) AS count
           FROM servicio_solicitado c
          WHERE c.id_solicitud = a.id) AS cantidad_servicios,
    a.sexo,
    a.empleado,
    a.estado,
    a.fecha_creacion,
    b.nombre,
    b.apellido
   FROM solicitud a
     JOIN cliente b ON a.id_cliente = b.id
  WHERE a.estatus = 'A'::bpchar;

ALTER TABLE public.vista_solicitudes
  OWNER TO postgres;

