PGDMP      !                  }            BDHUEVO2    17.0    17.0 �    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                           false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                           false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                           false            �           1262    16691    BDHUEVO2    DATABASE     }   CREATE DATABASE "BDHUEVO2" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Spanish_Spain.1252';
    DROP DATABASE "BDHUEVO2";
                     postgres    false                       1255    17025    calcular_edad(date)    FUNCTION     �   CREATE FUNCTION public.calcular_edad(fecha_nacimiento date) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    edad INTEGER;
BEGIN

    SELECT EXTRACT(YEAR FROM AGE(fecha_nacimiento)) INTO edad;
    
    RETURN edad;
END;
$$;
 ;   DROP FUNCTION public.calcular_edad(fecha_nacimiento date);
       public               postgres    false            �            1255    16993    cliente_antiguedad(integer)    FUNCTION     �  CREATE FUNCTION public.cliente_antiguedad(xci_cliente integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
  fecha_inicio DATE;
  anios INT;
BEGIN
  anios := 0;
  SELECT FECHAINICIO INTO fecha_inicio
  FROM CLIENTE
  WHERE CI_CLIENTE = xci_cliente; 
  IF NOT FOUND THEN
    RETURN 0;
  END IF;
  SELECT EXTRACT(YEAR FROM AGE(fecha_inicio)) INTO anios;
  RETURN anios;
EXCEPTION WHEN OTHERS THEN
  RETURN 0;
END;
$$;
 >   DROP FUNCTION public.cliente_antiguedad(xci_cliente integer);
       public               postgres    false                       1255    17004    maxpedidos()    FUNCTION     �   CREATE FUNCTION public.maxpedidos() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    total INTEGER;  
BEGIN
    select max(cantidad) into total
	from detalle_p;
    
    RETURN total;  
END;
$$;
 #   DROP FUNCTION public.maxpedidos();
       public               postgres    false                       1255    17029    mediadescuentos(integer)    FUNCTION     k  CREATE FUNCTION public.mediadescuentos(cix integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    suma INTEGER; 
    total INTEGER;
BEGIN
    -- Sumar los descuentos para el cliente dado
    SELECT sum(dp.descuentoP) INTO suma
    FROM pedido p
    JOIN detalle_p dp ON dp.id_pedido = p.id_pedido
    JOIN cliente c ON c.ci_cliente = p.ci_cliente
    WHERE c.ci_cliente = cix;

    -- Contar el número de pedidos para el cliente dado
    SELECT count(*) INTO total
    FROM pedido p
    JOIN detalle_p dp ON dp.id_pedido = p.id_pedido
    JOIN cliente c ON c.ci_cliente = p.ci_cliente
    WHERE c.ci_cliente = cix;

    -- Verificar que total no sea 0 para evitar división por cero
    IF total > 0 THEN
        RETURN suma / total;
    ELSE
        RETURN 0; -- Puedes devolver otro valor o manejar el caso de otra manera si es necesario
    END IF;
END;
$$;
 3   DROP FUNCTION public.mediadescuentos(cix integer);
       public               postgres    false            �            1255    16994    mi_funcion(integer)    FUNCTION     �  CREATE FUNCTION public.mi_funcion(idproducto integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    total INTEGER;  -- Usamos minúscula para la variable
BEGIN
    SELECT COUNT(*) INTO total
    FROM PEDIDO p
    JOIN DETALLE_p dp ON dp.id_pedido = p.id_pedido
    WHERE dp.id_producto = idproducto;
    
    RETURN total;  -- La variable 'total' debe ser en minúscula
END;
$$;
 5   DROP FUNCTION public.mi_funcion(idproducto integer);
       public               postgres    false            �            1255    16995    numclientes(integer)    FUNCTION     �  CREATE FUNCTION public.numclientes(idproducto integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    total INTEGER;  -- Usamos minúscula para la variable
BEGIN
    SELECT COUNT(DISTINCT p.ci_cliente) INTO total
    FROM PEDIDO p
    JOIN DETALLE_p dp ON dp.id_pedido = p.id_pedido
    WHERE dp.id_producto = idproducto;
    
    RETURN total;  -- La variable 'total' debe ser en minúscula
END;
$$;
 6   DROP FUNCTION public.numclientes(idproducto integer);
       public               postgres    false                       1255    17030    numerorepartidores(integer)    FUNCTION     �  CREATE FUNCTION public.numerorepartidores(cix integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    suma INTEGER; 
    total INTEGER;
BEGIN
    SELECT count(DISTINCT se.ci_repartidor) INTO total
    FROM cliente c
    JOIN pedido p ON p.ci_cliente = c.ci_cliente
    JOIN se_le_asigna se ON se.id_pedido = p.id_pedido
    WHERE c.ci_cliente = cix;

    IF total IS NOT NULL AND total > 0 THEN
        RETURN total;
    ELSE
        RETURN 0; 
    END IF;
END;
$$;
 6   DROP FUNCTION public.numerorepartidores(cix integer);
       public               postgres    false            �            1255    16998    numincidencias(integer)    FUNCTION     �  CREATE FUNCTION public.numincidencias(idproducto integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    prom INTEGER;  -- Usamos minúscula para la variable
BEGIN
	select COUNT(*) INTO prom
	from se_le_asigna se
	join pedido p on p.id_pedido= se.id_pedido
	join detalle_p dp on dp.id_pedido=p.id_pedido
    left join incidencia inci on inci.ci_repartidor=se.ci_repartidor
	where dp.id_producto=idproducto;
    
    RETURN prom;  -- La variable 'total' debe ser en minúscula
END;
$$;
 9   DROP FUNCTION public.numincidencias(idproducto integer);
       public               postgres    false                        1255    17003    numitiendas(integer)    FUNCTION     %  CREATE FUNCTION public.numitiendas(cix integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    total INTEGER;  
BEGIN
    select count(*) into total
	from cliente
	join tienda on tienda.ci_cliente=cliente.ci_cliente
	where cliente.ci_cliente=cix;
    
    RETURN total;  
END;
$$;
 /   DROP FUNCTION public.numitiendas(cix integer);
       public               postgres    false            �            1255    17002    numpedidos(integer)    FUNCTION       CREATE FUNCTION public.numpedidos(cix integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    total INTEGER;  
BEGIN
    SELECT count(*) into total
	FROM CLIENTE c
	JOIN PEDIDO p on p.ci_cliente=c.ci_cliente
	where c.ci_cliente=cix;
    
    RETURN total;  
END;
$$;
 .   DROP FUNCTION public.numpedidos(cix integer);
       public               postgres    false                       1255    17024    productomaspedido(integer)    FUNCTION     G  CREATE FUNCTION public.productomaspedido(cix integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
    producto varchar(20); 
    mayor integer; 
BEGIN
    -- Obtener el id_producto que más veces ha sido pedido
    SELECT dp.id_producto INTO mayor
    FROM pedido p
    JOIN detalle_p dp ON dp.id_pedido = p.id_pedido
    WHERE p.ci_cliente = cix
    GROUP BY dp.id_producto
    ORDER BY COUNT(dp.id_producto) DESC
    LIMIT 1; 

    SELECT prod.tamanio INTO producto
    FROM producto prod
    WHERE prod.id_producto = mayor;

   
    RETURN producto;
END;
$$;
 5   DROP FUNCTION public.productomaspedido(cix integer);
       public               postgres    false                       1255    17036    proveedorx(integer)    FUNCTION     �  CREATE FUNCTION public.proveedorx(cix integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
DECLARE
    proveedorx varchar(50); 
    mayor integer; 
BEGIN
    -- Obtener el id_producto que más veces ha sido pedido
    SELECT dp.id_producto INTO mayor
    FROM pedido p
    JOIN detalle_p dp ON dp.id_pedido = p.id_pedido
    WHERE p.ci_cliente = cix
    GROUP BY dp.id_producto
    ORDER BY COUNT(dp.id_producto) DESC
    LIMIT 1; 

    select concat(persona.nombre,' ',persona.paterno,' ',persona.materno) into proveedorx
	from proveedor p
	join persona on persona.ci=p.ci_proveedor
	join compra c on c.ci_proveedor=p.ci_proveedor
	where c.id_producto=1
	limit 1;
   
    RETURN proveedorx;
END;
$$;
 .   DROP FUNCTION public.proveedorx(cix integer);
       public               postgres    false            �            1259    16710    administrador    TABLE     �   CREATE TABLE public.administrador (
    ci_administrador integer NOT NULL,
    salario numeric(10,2) NOT NULL,
    CONSTRAINT administrador_salario_check CHECK ((salario >= (0)::numeric))
);
 !   DROP TABLE public.administrador;
       public         heap r       postgres    false            �            1259    16869 
   auth_group    TABLE     f   CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);
    DROP TABLE public.auth_group;
       public         heap r       postgres    false            �            1259    16868    auth_group_id_seq    SEQUENCE     �   ALTER TABLE public.auth_group ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    236            �            1259    16877    auth_group_permissions    TABLE     �   CREATE TABLE public.auth_group_permissions (
    id bigint NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);
 *   DROP TABLE public.auth_group_permissions;
       public         heap r       postgres    false            �            1259    16876    auth_group_permissions_id_seq    SEQUENCE     �   ALTER TABLE public.auth_group_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    238            �            1259    16863    auth_permission    TABLE     �   CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);
 #   DROP TABLE public.auth_permission;
       public         heap r       postgres    false            �            1259    16862    auth_permission_id_seq    SEQUENCE     �   ALTER TABLE public.auth_permission ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    234            �            1259    16883 	   auth_user    TABLE     �  CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);
    DROP TABLE public.auth_user;
       public         heap r       postgres    false            �            1259    16891    auth_user_groups    TABLE     ~   CREATE TABLE public.auth_user_groups (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);
 $   DROP TABLE public.auth_user_groups;
       public         heap r       postgres    false            �            1259    16890    auth_user_groups_id_seq    SEQUENCE     �   ALTER TABLE public.auth_user_groups ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    242            �            1259    16882    auth_user_id_seq    SEQUENCE     �   ALTER TABLE public.auth_user ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    240            �            1259    16897    auth_user_user_permissions    TABLE     �   CREATE TABLE public.auth_user_user_permissions (
    id bigint NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);
 .   DROP TABLE public.auth_user_user_permissions;
       public         heap r       postgres    false            �            1259    16896 !   auth_user_user_permissions_id_seq    SEQUENCE     �   ALTER TABLE public.auth_user_user_permissions ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    244            �            1259    16742    camion    TABLE       CREATE TABLE public.camion (
    placa character varying(10) NOT NULL,
    anio integer NOT NULL,
    marca character varying(50) NOT NULL,
    color character varying(50) NOT NULL,
    ci_repartidor integer NOT NULL,
    CONSTRAINT camion_anio_check CHECK ((anio > 0))
);
    DROP TABLE public.camion;
       public         heap r       postgres    false            �            1259    16700    cliente    TABLE     `   CREATE TABLE public.cliente (
    ci_cliente integer NOT NULL,
    fechainicio date NOT NULL
);
    DROP TABLE public.cliente;
       public         heap r       postgres    false            �            1259    16824    compra    TABLE     �  CREATE TABLE public.compra (
    id_compra integer NOT NULL,
    ci_administrador integer NOT NULL,
    ci_proveedor integer NOT NULL,
    id_producto integer NOT NULL,
    fechacompra date NOT NULL,
    fechallegada date NOT NULL,
    cantidad integer NOT NULL,
    p_unitario numeric(10,2) NOT NULL,
    CONSTRAINT compra_cantidad_check CHECK ((cantidad > 0)),
    CONSTRAINT compra_p_unitario_check CHECK ((p_unitario >= (0)::numeric))
);
    DROP TABLE public.compra;
       public         heap r       postgres    false            �            1259    17005 	   detalle_p    TABLE     �  CREATE TABLE public.detalle_p (
    id_pedido integer NOT NULL,
    id_producto integer NOT NULL,
    cantidad integer NOT NULL,
    p_unitario numeric(10,2) NOT NULL,
    descuentop numeric(5,2) DEFAULT 0,
    CONSTRAINT detalle_p_cantidad_check CHECK ((cantidad > 0)),
    CONSTRAINT detalle_p_descuentop_check CHECK ((descuentop >= (0)::numeric)),
    CONSTRAINT detalle_p_p_unitario_check CHECK ((p_unitario >= (0)::numeric))
);
    DROP TABLE public.detalle_p;
       public         heap r       postgres    false            �            1259    16955    django_admin_log    TABLE     �  CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);
 $   DROP TABLE public.django_admin_log;
       public         heap r       postgres    false            �            1259    16954    django_admin_log_id_seq    SEQUENCE     �   ALTER TABLE public.django_admin_log ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    246            �            1259    16855    django_content_type    TABLE     �   CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);
 '   DROP TABLE public.django_content_type;
       public         heap r       postgres    false            �            1259    16854    django_content_type_id_seq    SEQUENCE     �   ALTER TABLE public.django_content_type ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    232            �            1259    16847    django_migrations    TABLE     �   CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);
 %   DROP TABLE public.django_migrations;
       public         heap r       postgres    false            �            1259    16846    django_migrations_id_seq    SEQUENCE     �   ALTER TABLE public.django_migrations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public               postgres    false    230            �            1259    16983    django_session    TABLE     �   CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);
 "   DROP TABLE public.django_session;
       public         heap r       postgres    false            �            1259    16753 
   incidencia    TABLE     �   CREATE TABLE public.incidencia (
    id_incidencia integer NOT NULL,
    descripcion text NOT NULL,
    fecha date NOT NULL,
    ci_repartidor integer NOT NULL
);
    DROP TABLE public.incidencia;
       public         heap r       postgres    false            �            1259    16765    pedido    TABLE     {   CREATE TABLE public.pedido (
    id_pedido integer NOT NULL,
    fecha_p date NOT NULL,
    ci_cliente integer NOT NULL
);
    DROP TABLE public.pedido;
       public         heap r       postgres    false            �            1259    16692    persona    TABLE     �  CREATE TABLE public.persona (
    ci integer NOT NULL,
    nombre character varying(100) NOT NULL,
    paterno character varying(100) NOT NULL,
    materno character varying(100) NOT NULL,
    sexo character(1) NOT NULL,
    celular character varying(20),
    direccion character varying(255),
    fechanaci date,
    CONSTRAINT persona_sexo_check CHECK ((sexo = ANY (ARRAY['M'::bpchar, 'F'::bpchar])))
);
    DROP TABLE public.persona;
       public         heap r       postgres    false            �            1259    16790    producto    TABLE     o   CREATE TABLE public.producto (
    id_producto integer NOT NULL,
    tamanio character varying(50) NOT NULL
);
    DROP TABLE public.producto;
       public         heap r       postgres    false            �            1259    16732 	   proveedor    TABLE     �   CREATE TABLE public.proveedor (
    ci_proveedor integer NOT NULL,
    correo character varying(100) NOT NULL,
    telefono character varying(20)
);
    DROP TABLE public.proveedor;
       public         heap r       postgres    false            �            1259    17031 
   proveedorx    TABLE     4   CREATE TABLE public.proveedorx (
    concat text
);
    DROP TABLE public.proveedorx;
       public         heap r       postgres    false            �            1259    16721 
   repartidor    TABLE     �   CREATE TABLE public.repartidor (
    ci_repartidor integer NOT NULL,
    nrolicencia character varying(50) NOT NULL,
    salario numeric(10,2) NOT NULL,
    CONSTRAINT repartidor_salario_check CHECK ((salario >= (0)::numeric))
);
    DROP TABLE public.repartidor;
       public         heap r       postgres    false            �            1259    16775    se_le_asigna    TABLE     i   CREATE TABLE public.se_le_asigna (
    ci_repartidor integer NOT NULL,
    id_pedido integer NOT NULL
);
     DROP TABLE public.se_le_asigna;
       public         heap r       postgres    false            �            1259    16814    tienda    TABLE     �   CREATE TABLE public.tienda (
    id_tienda integer NOT NULL,
    direccion character varying(255) NOT NULL,
    ci_cliente integer NOT NULL
);
    DROP TABLE public.tienda;
       public         heap r       postgres    false            �            1259    16999    total    TABLE     0   CREATE TABLE public.total (
    count bigint
);
    DROP TABLE public.total;
       public         heap r       postgres    false            �          0    16710    administrador 
   TABLE DATA           B   COPY public.administrador (ci_administrador, salario) FROM stdin;
    public               postgres    false    219   ��       �          0    16869 
   auth_group 
   TABLE DATA           .   COPY public.auth_group (id, name) FROM stdin;
    public               postgres    false    236   ��       �          0    16877    auth_group_permissions 
   TABLE DATA           M   COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
    public               postgres    false    238   	�       �          0    16863    auth_permission 
   TABLE DATA           N   COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
    public               postgres    false    234   &�       �          0    16883 	   auth_user 
   TABLE DATA           �   COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
    public               postgres    false    240   C�       �          0    16891    auth_user_groups 
   TABLE DATA           A   COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
    public               postgres    false    242   �       �          0    16897    auth_user_user_permissions 
   TABLE DATA           P   COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
    public               postgres    false    244    �       �          0    16742    camion 
   TABLE DATA           J   COPY public.camion (placa, anio, marca, color, ci_repartidor) FROM stdin;
    public               postgres    false    222   =�       �          0    16700    cliente 
   TABLE DATA           :   COPY public.cliente (ci_cliente, fechainicio) FROM stdin;
    public               postgres    false    218   ��       �          0    16824    compra 
   TABLE DATA           �   COPY public.compra (id_compra, ci_administrador, ci_proveedor, id_producto, fechacompra, fechallegada, cantidad, p_unitario) FROM stdin;
    public               postgres    false    228   L�       �          0    17005 	   detalle_p 
   TABLE DATA           ]   COPY public.detalle_p (id_pedido, id_producto, cantidad, p_unitario, descuentop) FROM stdin;
    public               postgres    false    249   ��       �          0    16955    django_admin_log 
   TABLE DATA           �   COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
    public               postgres    false    246   ?�       �          0    16855    django_content_type 
   TABLE DATA           C   COPY public.django_content_type (id, app_label, model) FROM stdin;
    public               postgres    false    232   \�       �          0    16847    django_migrations 
   TABLE DATA           C   COPY public.django_migrations (id, app, name, applied) FROM stdin;
    public               postgres    false    230   ��       �          0    16983    django_session 
   TABLE DATA           P   COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
    public               postgres    false    247   r�       �          0    16753 
   incidencia 
   TABLE DATA           V   COPY public.incidencia (id_incidencia, descripcion, fecha, ci_repartidor) FROM stdin;
    public               postgres    false    223   ��       �          0    16765    pedido 
   TABLE DATA           @   COPY public.pedido (id_pedido, fecha_p, ci_cliente) FROM stdin;
    public               postgres    false    224   ;�       �          0    16692    persona 
   TABLE DATA           d   COPY public.persona (ci, nombre, paterno, materno, sexo, celular, direccion, fechanaci) FROM stdin;
    public               postgres    false    217   ��       �          0    16790    producto 
   TABLE DATA           8   COPY public.producto (id_producto, tamanio) FROM stdin;
    public               postgres    false    226   ��       �          0    16732 	   proveedor 
   TABLE DATA           C   COPY public.proveedor (ci_proveedor, correo, telefono) FROM stdin;
    public               postgres    false    221   7�       �          0    17031 
   proveedorx 
   TABLE DATA           ,   COPY public.proveedorx (concat) FROM stdin;
    public               postgres    false    250   ��       �          0    16721 
   repartidor 
   TABLE DATA           I   COPY public.repartidor (ci_repartidor, nrolicencia, salario) FROM stdin;
    public               postgres    false    220   ��       �          0    16775    se_le_asigna 
   TABLE DATA           @   COPY public.se_le_asigna (ci_repartidor, id_pedido) FROM stdin;
    public               postgres    false    225   S�       �          0    16814    tienda 
   TABLE DATA           B   COPY public.tienda (id_tienda, direccion, ci_cliente) FROM stdin;
    public               postgres    false    227   ��       �          0    16999    total 
   TABLE DATA           &   COPY public.total (count) FROM stdin;
    public               postgres    false    248   .�       �           0    0    auth_group_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);
          public               postgres    false    235            �           0    0    auth_group_permissions_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);
          public               postgres    false    237            �           0    0    auth_permission_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.auth_permission_id_seq', 24, true);
          public               postgres    false    233            �           0    0    auth_user_groups_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);
          public               postgres    false    241            �           0    0    auth_user_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.auth_user_id_seq', 1, true);
          public               postgres    false    239            �           0    0 !   auth_user_user_permissions_id_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);
          public               postgres    false    243            �           0    0    django_admin_log_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);
          public               postgres    false    245            �           0    0    django_content_type_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.django_content_type_id_seq', 6, true);
          public               postgres    false    231            �           0    0    django_migrations_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.django_migrations_id_seq', 18, true);
          public               postgres    false    229            �           2606    16715     administrador administrador_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.administrador
    ADD CONSTRAINT administrador_pkey PRIMARY KEY (ci_administrador);
 J   ALTER TABLE ONLY public.administrador DROP CONSTRAINT administrador_pkey;
       public                 postgres    false    219            �           2606    16981    auth_group auth_group_name_key 
   CONSTRAINT     Y   ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);
 H   ALTER TABLE ONLY public.auth_group DROP CONSTRAINT auth_group_name_key;
       public                 postgres    false    236            �           2606    16912 R   auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq 
   CONSTRAINT     �   ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);
 |   ALTER TABLE ONLY public.auth_group_permissions DROP CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq;
       public                 postgres    false    238    238            �           2606    16881 2   auth_group_permissions auth_group_permissions_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.auth_group_permissions DROP CONSTRAINT auth_group_permissions_pkey;
       public                 postgres    false    238            �           2606    16873    auth_group auth_group_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.auth_group DROP CONSTRAINT auth_group_pkey;
       public                 postgres    false    236            �           2606    16903 F   auth_permission auth_permission_content_type_id_codename_01ab375a_uniq 
   CONSTRAINT     �   ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);
 p   ALTER TABLE ONLY public.auth_permission DROP CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq;
       public                 postgres    false    234    234            �           2606    16867 $   auth_permission auth_permission_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.auth_permission DROP CONSTRAINT auth_permission_pkey;
       public                 postgres    false    234            �           2606    16895 &   auth_user_groups auth_user_groups_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.auth_user_groups DROP CONSTRAINT auth_user_groups_pkey;
       public                 postgres    false    242            �           2606    16927 @   auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq 
   CONSTRAINT     �   ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);
 j   ALTER TABLE ONLY public.auth_user_groups DROP CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq;
       public                 postgres    false    242    242            �           2606    16887    auth_user auth_user_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.auth_user DROP CONSTRAINT auth_user_pkey;
       public                 postgres    false    240            �           2606    16901 :   auth_user_user_permissions auth_user_user_permissions_pkey 
   CONSTRAINT     x   ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);
 d   ALTER TABLE ONLY public.auth_user_user_permissions DROP CONSTRAINT auth_user_user_permissions_pkey;
       public                 postgres    false    244            �           2606    16941 Y   auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq 
   CONSTRAINT     �   ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);
 �   ALTER TABLE ONLY public.auth_user_user_permissions DROP CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq;
       public                 postgres    false    244    244            �           2606    16976     auth_user auth_user_username_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);
 J   ALTER TABLE ONLY public.auth_user DROP CONSTRAINT auth_user_username_key;
       public                 postgres    false    240            �           2606    16747    camion camion_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.camion
    ADD CONSTRAINT camion_pkey PRIMARY KEY (placa);
 <   ALTER TABLE ONLY public.camion DROP CONSTRAINT camion_pkey;
       public                 postgres    false    222            �           2606    16962 &   django_admin_log django_admin_log_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.django_admin_log DROP CONSTRAINT django_admin_log_pkey;
       public                 postgres    false    246            �           2606    16861 E   django_content_type django_content_type_app_label_model_76bd3d3b_uniq 
   CONSTRAINT     �   ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);
 o   ALTER TABLE ONLY public.django_content_type DROP CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq;
       public                 postgres    false    232    232            �           2606    16859 ,   django_content_type django_content_type_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.django_content_type DROP CONSTRAINT django_content_type_pkey;
       public                 postgres    false    232            �           2606    16853 (   django_migrations django_migrations_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.django_migrations DROP CONSTRAINT django_migrations_pkey;
       public                 postgres    false    230            �           2606    16989 "   django_session django_session_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);
 L   ALTER TABLE ONLY public.django_session DROP CONSTRAINT django_session_pkey;
       public                 postgres    false    247            �           2606    16759    incidencia incidencia_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.incidencia
    ADD CONSTRAINT incidencia_pkey PRIMARY KEY (id_incidencia);
 D   ALTER TABLE ONLY public.incidencia DROP CONSTRAINT incidencia_pkey;
       public                 postgres    false    223            �           2606    16769    pedido pedido_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT pedido_pkey PRIMARY KEY (id_pedido);
 <   ALTER TABLE ONLY public.pedido DROP CONSTRAINT pedido_pkey;
       public                 postgres    false    224            �           2606    16699    persona persona_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.persona
    ADD CONSTRAINT persona_pkey PRIMARY KEY (ci);
 >   ALTER TABLE ONLY public.persona DROP CONSTRAINT persona_pkey;
       public                 postgres    false    217            �           2606    16704    cliente pk_cliente 
   CONSTRAINT     X   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT pk_cliente PRIMARY KEY (ci_cliente);
 <   ALTER TABLE ONLY public.cliente DROP CONSTRAINT pk_cliente;
       public                 postgres    false    218            �           2606    16830    compra pk_compra 
   CONSTRAINT     U   ALTER TABLE ONLY public.compra
    ADD CONSTRAINT pk_compra PRIMARY KEY (id_compra);
 :   ALTER TABLE ONLY public.compra DROP CONSTRAINT pk_compra;
       public                 postgres    false    228            �           2606    17013    detalle_p pk_detalle_p 
   CONSTRAINT     h   ALTER TABLE ONLY public.detalle_p
    ADD CONSTRAINT pk_detalle_p PRIMARY KEY (id_pedido, id_producto);
 @   ALTER TABLE ONLY public.detalle_p DROP CONSTRAINT pk_detalle_p;
       public                 postgres    false    249    249            �           2606    16779    se_le_asigna pk_se_le_asigna 
   CONSTRAINT     p   ALTER TABLE ONLY public.se_le_asigna
    ADD CONSTRAINT pk_se_le_asigna PRIMARY KEY (ci_repartidor, id_pedido);
 F   ALTER TABLE ONLY public.se_le_asigna DROP CONSTRAINT pk_se_le_asigna;
       public                 postgres    false    225    225            �           2606    16794    producto producto_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (id_producto);
 @   ALTER TABLE ONLY public.producto DROP CONSTRAINT producto_pkey;
       public                 postgres    false    226            �           2606    16736    proveedor proveedor_pkey 
   CONSTRAINT     `   ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_pkey PRIMARY KEY (ci_proveedor);
 B   ALTER TABLE ONLY public.proveedor DROP CONSTRAINT proveedor_pkey;
       public                 postgres    false    221            �           2606    16726    repartidor repartidor_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.repartidor
    ADD CONSTRAINT repartidor_pkey PRIMARY KEY (ci_repartidor);
 D   ALTER TABLE ONLY public.repartidor DROP CONSTRAINT repartidor_pkey;
       public                 postgres    false    220            �           2606    16818    tienda tienda_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.tienda
    ADD CONSTRAINT tienda_pkey PRIMARY KEY (id_tienda);
 <   ALTER TABLE ONLY public.tienda DROP CONSTRAINT tienda_pkey;
       public                 postgres    false    227            �           1259    16982    auth_group_name_a6ea08ec_like    INDEX     h   CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);
 1   DROP INDEX public.auth_group_name_a6ea08ec_like;
       public                 postgres    false    236            �           1259    16923 (   auth_group_permissions_group_id_b120cbf9    INDEX     o   CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);
 <   DROP INDEX public.auth_group_permissions_group_id_b120cbf9;
       public                 postgres    false    238            �           1259    16924 -   auth_group_permissions_permission_id_84c5c92e    INDEX     y   CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);
 A   DROP INDEX public.auth_group_permissions_permission_id_84c5c92e;
       public                 postgres    false    238            �           1259    16909 (   auth_permission_content_type_id_2f476e4b    INDEX     o   CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);
 <   DROP INDEX public.auth_permission_content_type_id_2f476e4b;
       public                 postgres    false    234            �           1259    16939 "   auth_user_groups_group_id_97559544    INDEX     c   CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);
 6   DROP INDEX public.auth_user_groups_group_id_97559544;
       public                 postgres    false    242            �           1259    16938 !   auth_user_groups_user_id_6a12ed8b    INDEX     a   CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);
 5   DROP INDEX public.auth_user_groups_user_id_6a12ed8b;
       public                 postgres    false    242            �           1259    16953 1   auth_user_user_permissions_permission_id_1fbb5f2c    INDEX     �   CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);
 E   DROP INDEX public.auth_user_user_permissions_permission_id_1fbb5f2c;
       public                 postgres    false    244            �           1259    16952 +   auth_user_user_permissions_user_id_a95ead1b    INDEX     u   CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);
 ?   DROP INDEX public.auth_user_user_permissions_user_id_a95ead1b;
       public                 postgres    false    244            �           1259    16977     auth_user_username_6821ab7c_like    INDEX     n   CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);
 4   DROP INDEX public.auth_user_username_6821ab7c_like;
       public                 postgres    false    240            �           1259    16973 )   django_admin_log_content_type_id_c4bce8eb    INDEX     q   CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);
 =   DROP INDEX public.django_admin_log_content_type_id_c4bce8eb;
       public                 postgres    false    246            �           1259    16974 !   django_admin_log_user_id_c564eba6    INDEX     a   CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);
 5   DROP INDEX public.django_admin_log_user_id_c564eba6;
       public                 postgres    false    246            �           1259    16991 #   django_session_expire_date_a5c62663    INDEX     e   CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);
 7   DROP INDEX public.django_session_expire_date_a5c62663;
       public                 postgres    false    247            �           1259    16990 (   django_session_session_key_c0390e0f_like    INDEX     ~   CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);
 <   DROP INDEX public.django_session_session_key_c0390e0f_like;
       public                 postgres    false    247            �           2606    16918 O   auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm    FK CONSTRAINT     �   ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;
 y   ALTER TABLE ONLY public.auth_group_permissions DROP CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm;
       public               postgres    false    234    4802    238            �           2606    16913 P   auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;
 z   ALTER TABLE ONLY public.auth_group_permissions DROP CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id;
       public               postgres    false    4807    236    238            �           2606    16904 E   auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co    FK CONSTRAINT     �   ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;
 o   ALTER TABLE ONLY public.auth_permission DROP CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co;
       public               postgres    false    232    234    4797            �           2606    16933 D   auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;
 n   ALTER TABLE ONLY public.auth_user_groups DROP CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id;
       public               postgres    false    242    236    4807            �           2606    16928 B   auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;
 l   ALTER TABLE ONLY public.auth_user_groups DROP CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id;
       public               postgres    false    4815    242    240            �           2606    16947 S   auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm    FK CONSTRAINT     �   ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;
 }   ALTER TABLE ONLY public.auth_user_user_permissions DROP CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm;
       public               postgres    false    244    4802    234            �           2606    16942 V   auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;
 �   ALTER TABLE ONLY public.auth_user_user_permissions DROP CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id;
       public               postgres    false    4815    244    240            �           2606    16963 G   django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co    FK CONSTRAINT     �   ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;
 q   ALTER TABLE ONLY public.django_admin_log DROP CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co;
       public               postgres    false    246    4797    232            �           2606    16968 B   django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;
 l   ALTER TABLE ONLY public.django_admin_log DROP CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id;
       public               postgres    false    4815    240    246            �           2606    16716 &   administrador fk_administrador_persona    FK CONSTRAINT     �   ALTER TABLE ONLY public.administrador
    ADD CONSTRAINT fk_administrador_persona FOREIGN KEY (ci_administrador) REFERENCES public.persona(ci) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.administrador DROP CONSTRAINT fk_administrador_persona;
       public               postgres    false    4769    217    219            �           2606    16748    camion fk_camion_repartidor    FK CONSTRAINT     �   ALTER TABLE ONLY public.camion
    ADD CONSTRAINT fk_camion_repartidor FOREIGN KEY (ci_repartidor) REFERENCES public.repartidor(ci_repartidor) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.camion DROP CONSTRAINT fk_camion_repartidor;
       public               postgres    false    220    222    4775            �           2606    16705    cliente fk_cliente_persona    FK CONSTRAINT     �   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT fk_cliente_persona FOREIGN KEY (ci_cliente) REFERENCES public.persona(ci) ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.cliente DROP CONSTRAINT fk_cliente_persona;
       public               postgres    false    217    218    4769            �           2606    16831    compra fk_compra_administrador    FK CONSTRAINT     �   ALTER TABLE ONLY public.compra
    ADD CONSTRAINT fk_compra_administrador FOREIGN KEY (ci_administrador) REFERENCES public.administrador(ci_administrador) ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.compra DROP CONSTRAINT fk_compra_administrador;
       public               postgres    false    4773    228    219            �           2606    16841    compra fk_compra_producto    FK CONSTRAINT     �   ALTER TABLE ONLY public.compra
    ADD CONSTRAINT fk_compra_producto FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto) ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.compra DROP CONSTRAINT fk_compra_producto;
       public               postgres    false    4787    228    226            �           2606    16836    compra fk_compra_proveedor    FK CONSTRAINT     �   ALTER TABLE ONLY public.compra
    ADD CONSTRAINT fk_compra_proveedor FOREIGN KEY (ci_proveedor) REFERENCES public.proveedor(ci_proveedor) ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.compra DROP CONSTRAINT fk_compra_proveedor;
       public               postgres    false    4777    228    221            �           2606    17014    detalle_p fk_detalle_p_pedido    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalle_p
    ADD CONSTRAINT fk_detalle_p_pedido FOREIGN KEY (id_pedido) REFERENCES public.pedido(id_pedido) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.detalle_p DROP CONSTRAINT fk_detalle_p_pedido;
       public               postgres    false    4783    224    249                        2606    17019    detalle_p fk_detalle_p_producto    FK CONSTRAINT     �   ALTER TABLE ONLY public.detalle_p
    ADD CONSTRAINT fk_detalle_p_producto FOREIGN KEY (id_producto) REFERENCES public.producto(id_producto) ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.detalle_p DROP CONSTRAINT fk_detalle_p_producto;
       public               postgres    false    249    4787    226            �           2606    16760 #   incidencia fk_incidencia_repartidor    FK CONSTRAINT     �   ALTER TABLE ONLY public.incidencia
    ADD CONSTRAINT fk_incidencia_repartidor FOREIGN KEY (ci_repartidor) REFERENCES public.repartidor(ci_repartidor) ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.incidencia DROP CONSTRAINT fk_incidencia_repartidor;
       public               postgres    false    220    4775    223            �           2606    16770    pedido fk_pedido_cliente    FK CONSTRAINT     �   ALTER TABLE ONLY public.pedido
    ADD CONSTRAINT fk_pedido_cliente FOREIGN KEY (ci_cliente) REFERENCES public.cliente(ci_cliente) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.pedido DROP CONSTRAINT fk_pedido_cliente;
       public               postgres    false    224    218    4771            �           2606    16737    proveedor fk_proveedor_persona    FK CONSTRAINT     �   ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT fk_proveedor_persona FOREIGN KEY (ci_proveedor) REFERENCES public.persona(ci) ON DELETE CASCADE;
 H   ALTER TABLE ONLY public.proveedor DROP CONSTRAINT fk_proveedor_persona;
       public               postgres    false    217    4769    221            �           2606    16727     repartidor fk_repartidor_persona    FK CONSTRAINT     �   ALTER TABLE ONLY public.repartidor
    ADD CONSTRAINT fk_repartidor_persona FOREIGN KEY (ci_repartidor) REFERENCES public.persona(ci) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.repartidor DROP CONSTRAINT fk_repartidor_persona;
       public               postgres    false    217    4769    220            �           2606    16785 #   se_le_asigna fk_se_le_asigna_pedido    FK CONSTRAINT     �   ALTER TABLE ONLY public.se_le_asigna
    ADD CONSTRAINT fk_se_le_asigna_pedido FOREIGN KEY (id_pedido) REFERENCES public.pedido(id_pedido) ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.se_le_asigna DROP CONSTRAINT fk_se_le_asigna_pedido;
       public               postgres    false    224    4783    225            �           2606    16780 '   se_le_asigna fk_se_le_asigna_repartidor    FK CONSTRAINT     �   ALTER TABLE ONLY public.se_le_asigna
    ADD CONSTRAINT fk_se_le_asigna_repartidor FOREIGN KEY (ci_repartidor) REFERENCES public.repartidor(ci_repartidor) ON DELETE CASCADE;
 Q   ALTER TABLE ONLY public.se_le_asigna DROP CONSTRAINT fk_se_le_asigna_repartidor;
       public               postgres    false    220    225    4775            �           2606    16819    tienda fk_tienda_cliente    FK CONSTRAINT     �   ALTER TABLE ONLY public.tienda
    ADD CONSTRAINT fk_tienda_cliente FOREIGN KEY (ci_cliente) REFERENCES public.cliente(ci_cliente) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.tienda DROP CONSTRAINT fk_tienda_cliente;
       public               postgres    false    227    4771    218            �   :   x�-̱  ����3!��sP��UhN)s-��A�Y����7�f7$������      �      x������ � �      �      x������ � �      �     x�]�K��0��ur
N0j£�z�Q�B�b�:�h�����I�%��o��i�g�f��c�Y����G�<��ЂRq�0G��f�a����[�m��Le���4u}0�x`+� �	{�}�R��NT����v�����֝d�~O]D�l�	�����<,�����ӺB�[ZA)���T���qu�<�͏>��_��� ��m�.2�)H���:x�ޟ8�1WY��'���`:Y��;�LL�vf���x댰j'�k�2�      �   �   x�=��
�@����-�*s��x� ����&�I�)M���U��_�@�{_J��F��uס�<;�[��ɪ�w����vt�,)U��=ߋt�$��|�\yI��J�_�MN�9[�htV����5KeD����j�i����z�`�H����+�>P�Y���\���4�ǚ33      �      x������ � �      �      x������ � �      �   �   x�%��
�0E��}�dN�l��t!"*n��>H��_����N^�\H�q{���aGO��jcO��pPQl!��:p�h%����.����ԅ���W!�TJk\֫L���0��p��`�7[�2�Jj�[�� �/3D���+�      �   V   x�-͹�0C�:�EE�0���q 6�5tEV�y����0GW�|����̪m2�9q�{[�T82�o�X���s���I�����xw      �   x   x�M�A!D�5�ER��z���9ZӺ{$��������qx��j8�b�%�j�®=�Si���k��繰�V������`�U�qa����.#K��e�s^�1���c)F�����761�      �   [   x�]�Q�0C��a�C�]��9f�3$��P
A�MM,%��Ĳ!���@G�%{=�3��uAGz~l�meg>��4�8j�1`�T��D�!��      �      x������ � �      �   W   x�M�K
�0�y����M�P�C�.z{E��LOn�!љ='���\��
K�!'�o�k��JU̴�d�f���)?�~��pM^%�      �   �  x���]n� �g�{�T_�=�J#�P	/હ�qI�:J^����?#Cw�s2sJ��Ďhg��v%T	A�!���w޿���#���5}>��RI��u�<������~+����f�_��=��y�����f����P���3~8=����SN`�b�*�Œ��?�lXNp֓٧`�R�o�Q�.���	����T�q����<�v)�%
��6j��a&m�S�	PCQ���{�<j;~I��y'�L@�!��c*��<���/���)���Ȝ�Նo�Kh����g���=��C��oB�'�]�$T�E�8��γ��l�ޤ�WF/Q
��(~( 5�./2�dWF6p]rD��/w� �A0~5�:���Æ��	R�T��է�
�u�������Y�      �   	  x���B@  ��y��̺�kU8.Q)͙1��E:�C����qI�����v]O���w
�ˬ)|�7���e�sWV��6����>��mIN.(Ny��YY�ARB���N6��s(�͛�� 6��@�sc����ֿ����w@��A�°�e�����5�A��Z�H���숮T���λ�$zZ.�j8 ��$�*�%��V%�M=QҼ���,0��x�]<Z����v����3X	@�,X���
U�� $�,��?�a�/S"\�      �   �   x�M�M�0����sL���u�ڸvS�$�����<�SC"��'_��!�O��'��Z=�$�HմZR�X�	��◌s.�|�:r��	:g�V�
�ǁ1�ԯK��;5@����ג�c�������xx�`��
s(N<��W$a3Ή�I�Id:�      �   [   x�mι� D�x�,��^�@^,9}��a�.ֺ��Ģ�R�42�TZ�$�j�+MZ/��,Q��g���sk4>�r���/ ��'�      �   1  x�mT�n�:]S_�P@R���䦰��.��fb���E���V��E�!?��v�(Y2H�9s��HU�Uݴ��{�^���3X�X3��;�_������k�3��d�V�(rYemSWe�$�`+w����o�~ݳ k5�;Gl��D.�\U��JEY�o�ȶ0����8���@���ȉ}r����2�ڟ���'RR���Y�*���o���V{�CZ���2��2��R��r%�Rר���Y��V��Vn佅#�������P�i���i=Lg���P��p���YUB�[R:b�X27j�vsٽ���H5�i�j�GmD.)�,Bt{�Yۏ��pp3 ���b���s ����q,#��(�lI�ٌ���W6D'�t,�����4n�\t�l� %[Z��y *��/D$��J�$~2�b�H-(�BdE)�1{��c��:b��L�cGb�P)�O0�H�FۨL�>>lg�g����LJ�`)�J�,[[Kv���\ T�n�vfk�2�ğ�Q�m6�=Ps}�;�<y3��	���[[�2K�*4�Z�	�Lo�F���Ź��
�+B;�L&#_k��f�or#�"��<��d�oxA���P�"���l&�ѿ4���<�*�J���x^֡�L&#��8P�����L��ni��O�w��P3䑌̶��kO��#�:���m�)uM��U���a�x�l3��!�T���(h=�G|ɖ��i���ag�a���uh&8�`� *��?Z~�g���_&��B3Ѱ�"�;[��Ǟ-��r���u��fCU���;fӑ��̾�eY�1�1      �   @   x�3�H-,M=�1�ˈ�75%31/�˘ӽ(1/%�˄ӵ��(Q�5�tK����L,����� bl�      �   j   x�U�;
�0E��Y�8�ع�t����|�)B��}��Yd����|���n�:��2 ��y�!�j���9��0!�3k�;����p�MJ'���		¥Ԥv���(�# |�&=�      �   %   x�sN,��/VN�K�H�RJ�=��(��+F��� �~
      �   ]   x�%���0D��b��G�9 �	��ßaQ�ȁ�raQ�u�62�T���qG����;���1[yi���ͧ�f���2��_�ﭵ��      �   C   x�E̹�@��,�8��{q�u8�@ق�<�Z�+�N���*ot#yCB��Z0��{f��C���      �   x   x�-�=
�0@��:�Nb��Y�@�n]���C@$�&9��>^�s���{3�8�!��<���+>̿��i�I�)���K1|.��v+�݉�ETA��ks�WN	4ܷ��i��v�r�� ���"o      �      x�3����� Z �     