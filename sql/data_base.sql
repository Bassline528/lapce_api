/*==============================================================*/
/* DBMS name:      PostgreSQL 8                                 */
/* Created on:     30/10/2022 18:39:30                          */
/*==============================================================*/


drop index CATEGORIA_PK;

drop table CATEGORIA;

drop index VENTAS_DETALLEVENTAS_FK;

drop index DETALLEVENTAS_PRODUCTOS_FK;

drop index DETALLEVENTAS_PK;

drop table DETALLEVENTAS;

drop index PRODUCTOS_CATEGORIA_FK;

drop index PRODUCTOS_PK;

drop table PRODUCTOS;

drop index SUCURSAL_PK;

drop table SUCURSAL;

drop index PRODUCTOS_SUCURSALPRODUCTOS_FK;

drop index SUCURSAL_SUCURSALPRODUCTOS_FK;

drop index SUCURSALPRODUCTOS_PK;

drop table SUCURSALPRODUCTOS;

drop index SUCURSAL_USUARIO_FK;

drop index USUARIO_PK;

drop table USUARIO;

drop index SUCURSAL_VENTAS_FK;

drop index VENTAS_PK;

drop table VENTAS;

/*==============================================================*/
/* Table: CATEGORIA                                             */
/*==============================================================*/
create table CATEGORIA (
   ID_CATEGORIA         SERIAL               not null,
   CATEGORIA            TEXT                 not null,
   SUB_CATEGORIA        TEXT                 null,
   DESCRIPCION          TEXT                 null,
   constraint PK_CATEGORIA primary key (ID_CATEGORIA)
);

/*==============================================================*/
/* Index: CATEGORIA_PK                                          */
/*==============================================================*/
create unique index CATEGORIA_PK on CATEGORIA (
ID_CATEGORIA
);

/*==============================================================*/
/* Table: DETALLEVENTAS                                         */
/*==============================================================*/
create table DETALLEVENTAS (
   ID_DETALLEVENTAS     SERIAL               not null,
   ID_PRODUCTO          INT4                 null,
   ID_VENTA             INT4                 null,
   CANTIDAD             INT4                 not null,
   constraint PK_DETALLEVENTAS primary key (ID_DETALLEVENTAS)
);

/*==============================================================*/
/* Index: DETALLEVENTAS_PK                                      */
/*==============================================================*/
create unique index DETALLEVENTAS_PK on DETALLEVENTAS (
ID_DETALLEVENTAS
);

/*==============================================================*/
/* Index: DETALLEVENTAS_PRODUCTOS_FK                            */
/*==============================================================*/
create  index DETALLEVENTAS_PRODUCTOS_FK on DETALLEVENTAS (
ID_PRODUCTO
);

/*==============================================================*/
/* Index: VENTAS_DETALLEVENTAS_FK                               */
/*==============================================================*/
create  index VENTAS_DETALLEVENTAS_FK on DETALLEVENTAS (
ID_VENTA
);

/*==============================================================*/
/* Table: PRODUCTOS                                             */
/*==============================================================*/
create table PRODUCTOS (
   ID_PRODUCTO          SERIAL               not null,
   ID_CATEGORIA         INT4                 null,
   NOMBRE               TEXT                 not null,
   DESCRIPCION          VARCHAR(1)           null,
   PRECIO               INT4                 not null,
   CATEGORIA            TEXT                 null,
   EXISTENCIA           INT4                 null,
   constraint PK_PRODUCTOS primary key (ID_PRODUCTO)
);

/*==============================================================*/
/* Index: PRODUCTOS_PK                                          */
/*==============================================================*/
create unique index PRODUCTOS_PK on PRODUCTOS (
ID_PRODUCTO
);

/*==============================================================*/
/* Index: PRODUCTOS_CATEGORIA_FK                                */
/*==============================================================*/
create  index PRODUCTOS_CATEGORIA_FK on PRODUCTOS (
ID_CATEGORIA
);

/*==============================================================*/
/* Table: SUCURSAL                                              */
/*==============================================================*/
create table SUCURSAL (
   ID_SUCURSAL          SERIAL               not null,
   NOMBRE               TEXT                 not null,
   DIRECCION            VARCHAR(1)           null,
   ACTIVO               BOOL                 not null,
   constraint PK_SUCURSAL primary key (ID_SUCURSAL)
);

/*==============================================================*/
/* Index: SUCURSAL_PK                                           */
/*==============================================================*/
create unique index SUCURSAL_PK on SUCURSAL (
ID_SUCURSAL
);

/*==============================================================*/
/* Table: SUCURSALPRODUCTOS                                     */
/*==============================================================*/
create table SUCURSALPRODUCTOS (
   ID_PRODUCTO          INT4                 not null,
   ID_SUCURSAL          INT4                 not null,
   EXISTENCIA           INT4                 not null,
   constraint PK_SUCURSALPRODUCTOS primary key (ID_PRODUCTO, ID_SUCURSAL)
);

/*==============================================================*/
/* Index: SUCURSALPRODUCTOS_PK                                  */
/*==============================================================*/
create unique index SUCURSALPRODUCTOS_PK on SUCURSALPRODUCTOS (
ID_PRODUCTO,
ID_SUCURSAL
);

/*==============================================================*/
/* Index: SUCURSAL_SUCURSALPRODUCTOS_FK                         */
/*==============================================================*/
create  index SUCURSAL_SUCURSALPRODUCTOS_FK on SUCURSALPRODUCTOS (
ID_SUCURSAL
);

/*==============================================================*/
/* Index: PRODUCTOS_SUCURSALPRODUCTOS_FK                        */
/*==============================================================*/
create  index PRODUCTOS_SUCURSALPRODUCTOS_FK on SUCURSALPRODUCTOS (
ID_PRODUCTO
);

/*==============================================================*/
/* Table: USUARIO                                               */
/*==============================================================*/
create table USUARIO (
   ID_USUARIO           SERIAL               not null,
   ID_SUCURSAL          INT4                 null,
   USUARIO              TEXT                 not null,
   NOMBRE               TEXT                 not null,
   CONTRASENA           VARCHAR(1)           not null,
   ROL                  TEXT                 not null,
   constraint PK_USUARIO primary key (ID_USUARIO)
);

/*==============================================================*/
/* Index: USUARIO_PK                                            */
/*==============================================================*/
create unique index USUARIO_PK on USUARIO (
ID_USUARIO
);

/*==============================================================*/
/* Index: SUCURSAL_USUARIO_FK                                   */
/*==============================================================*/
create  index SUCURSAL_USUARIO_FK on USUARIO (
ID_SUCURSAL
);

/*==============================================================*/
/* Table: VENTAS                                                */
/*==============================================================*/
create table VENTAS (
   ID_VENTA             SERIAL               not null,
   ID_SUCURSAL          INT4                 not null,
   RAZON                TEXT                 not null,
   FECHA_HORA           DATE                 not null,
   TOTAL                INT4                 not null,
   IVA_TOTAL5           INT4                 not null,
   IVA_TOTAL10          INT4                 not null,
   constraint PK_VENTAS primary key (ID_VENTA)
);

/*==============================================================*/
/* Index: VENTAS_PK                                             */
/*==============================================================*/
create unique index VENTAS_PK on VENTAS (
ID_VENTA
);

/*==============================================================*/
/* Index: SUCURSAL_VENTAS_FK                                    */
/*==============================================================*/
create  index SUCURSAL_VENTAS_FK on VENTAS (
ID_SUCURSAL
);

alter table DETALLEVENTAS
   add constraint FK_DETALLEV_DETALLEVE_PRODUCTO foreign key (ID_PRODUCTO)
      references PRODUCTOS (ID_PRODUCTO)
      on delete restrict on update restrict;

alter table DETALLEVENTAS
   add constraint FK_DETALLEV_VENTAS_DE_VENTAS foreign key (ID_VENTA)
      references VENTAS (ID_VENTA)
      on delete restrict on update restrict;

alter table PRODUCTOS
   add constraint FK_PRODUCTO_PRODUCTOS_CATEGORI foreign key (ID_CATEGORIA)
      references CATEGORIA (ID_CATEGORIA)
      on delete restrict on update restrict;

alter table SUCURSALPRODUCTOS
   add constraint FK_SUCURSAL_PRODUCTOS_PRODUCTO foreign key (ID_PRODUCTO)
      references PRODUCTOS (ID_PRODUCTO)
      on delete restrict on update restrict;

alter table SUCURSALPRODUCTOS
   add constraint FK_SUCURSAL_SUCURSAL__SUCURSAL foreign key (ID_SUCURSAL)
      references SUCURSAL (ID_SUCURSAL)
      on delete restrict on update restrict;

alter table USUARIO
   add constraint FK_USUARIO_SUCURSAL__SUCURSAL foreign key (ID_SUCURSAL)
      references SUCURSAL (ID_SUCURSAL)
      on delete restrict on update restrict;

alter table VENTAS
   add constraint FK_VENTAS_SUCURSAL__SUCURSAL foreign key (ID_SUCURSAL)
      references SUCURSAL (ID_SUCURSAL)
      on delete restrict on update restrict;