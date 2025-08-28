-- Table: public.user

-- DROP TABLE IF EXISTS public."user";

CREATE TABLE IF NOT EXISTS public."user"
(
    id integer NOT NULL DEFAULT nextval('user_id_seq'::regclass),
    username character varying(80) COLLATE pg_catalog."default" NOT NULL,
    email character varying(120) COLLATE pg_catalog."default" NOT NULL,
    password_hash character varying(256) COLLATE pg_catalog."default" NOT NULL,
    first_name character varying(50) COLLATE pg_catalog."default",
    last_name character varying(50) COLLATE pg_catalog."default",
    role character varying(20) COLLATE pg_catalog."default" NOT NULL,
    agency_id integer,
    is_active boolean,
    created_at timestamp without time zone,
    last_login timestamp without time zone,
    CONSTRAINT user_pkey PRIMARY KEY (id),
    CONSTRAINT user_email_key UNIQUE (email),
    CONSTRAINT user_username_key UNIQUE (username),
    CONSTRAINT user_agency_id_fkey FOREIGN KEY (agency_id)
        REFERENCES public.agency (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."user"
    OWNER to neondb_owner;

-- Table: public.product

-- DROP TABLE IF EXISTS public.product;

CREATE TABLE IF NOT EXISTS public.product
(
    id integer NOT NULL DEFAULT nextval('product_id_seq'::regclass),
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default",
    sku character varying(50) COLLATE pg_catalog."default" NOT NULL,
    price numeric(10,2) NOT NULL,
    cost numeric(10,2),
    stock_quantity integer,
    category character varying(50) COLLATE pg_catalog."default",
    agency_id integer NOT NULL,
    is_active boolean,
    created_at timestamp without time zone,
    CONSTRAINT product_pkey PRIMARY KEY (id),
    CONSTRAINT product_sku_key UNIQUE (sku),
    CONSTRAINT product_agency_id_fkey FOREIGN KEY (agency_id)
        REFERENCES public.agency (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.product
    OWNER to neondb_owner;


-- Table: public.order_item

-- DROP TABLE IF EXISTS public.order_item;

CREATE TABLE IF NOT EXISTS public.order_item
(
    id integer NOT NULL DEFAULT nextval('order_item_id_seq'::regclass),
    order_id integer NOT NULL,
    product_id integer NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(10,2) NOT NULL,
    total_price numeric(10,2) NOT NULL,
    CONSTRAINT order_item_pkey PRIMARY KEY (id),
    CONSTRAINT order_item_order_id_fkey FOREIGN KEY (order_id)
        REFERENCES public."order" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT order_item_product_id_fkey FOREIGN KEY (product_id)
        REFERENCES public.product (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.order_item
    OWNER to neondb_owner;


-- Table: public.order

-- DROP TABLE IF EXISTS public."order";

CREATE TABLE IF NOT EXISTS public."order"
(
    id integer NOT NULL DEFAULT nextval('order_id_seq'::regclass),
    order_number character varying(50) COLLATE pg_catalog."default" NOT NULL,
    customer_id integer NOT NULL,
    agency_id integer NOT NULL,
    salesperson_id integer NOT NULL,
    status character varying(20) COLLATE pg_catalog."default",
    total_amount numeric(10,2),
    discount numeric(10,2),
    tax numeric(10,2),
    notes text COLLATE pg_catalog."default",
    order_date timestamp without time zone,
    delivery_date timestamp without time zone,
    created_at timestamp without time zone,
    CONSTRAINT order_pkey PRIMARY KEY (id),
    CONSTRAINT order_order_number_key UNIQUE (order_number),
    CONSTRAINT order_agency_id_fkey FOREIGN KEY (agency_id)
        REFERENCES public.agency (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT order_customer_id_fkey FOREIGN KEY (customer_id)
        REFERENCES public.customer (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT order_salesperson_id_fkey FOREIGN KEY (salesperson_id)
        REFERENCES public."user" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public."order"
    OWNER to neondb_owner;

-- Table: public.location

-- DROP TABLE IF EXISTS public.location;

CREATE TABLE IF NOT EXISTS public.location
(
    id integer NOT NULL DEFAULT nextval('location_id_seq'::regclass),
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    address text COLLATE pg_catalog."default",
    city character varying(50) COLLATE pg_catalog."default",
    state character varying(50) COLLATE pg_catalog."default",
    zip_code character varying(10) COLLATE pg_catalog."default",
    phone character varying(20) COLLATE pg_catalog."default",
    agency_id integer NOT NULL,
    is_active boolean,
    created_at timestamp without time zone,
    CONSTRAINT location_pkey PRIMARY KEY (id),
    CONSTRAINT location_agency_id_fkey FOREIGN KEY (agency_id)
        REFERENCES public.agency (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.location
    OWNER to neondb_owner;


-- Table: public.customer

-- DROP TABLE IF EXISTS public.customer;

CREATE TABLE IF NOT EXISTS public.customer
(
    id integer NOT NULL DEFAULT nextval('customer_id_seq'::regclass),
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    email character varying(120) COLLATE pg_catalog."default",
    phone character varying(20) COLLATE pg_catalog."default",
    address text COLLATE pg_catalog."default",
    location_id integer NOT NULL,
    is_active boolean,
    created_at timestamp without time zone,
    CONSTRAINT customer_pkey PRIMARY KEY (id),
    CONSTRAINT customer_location_id_fkey FOREIGN KEY (location_id)
        REFERENCES public.location (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.customer
    OWNER to neondb_owner;


-- Table: public.agency

-- DROP TABLE IF EXISTS public.agency;

CREATE TABLE IF NOT EXISTS public.agency
(
    id integer NOT NULL DEFAULT nextval('agency_id_seq'::regclass),
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    code character varying(20) COLLATE pg_catalog."default" NOT NULL,
    address text COLLATE pg_catalog."default",
    phone character varying(20) COLLATE pg_catalog."default",
    email character varying(120) COLLATE pg_catalog."default",
    is_active boolean,
    created_at timestamp without time zone,
    CONSTRAINT agency_pkey PRIMARY KEY (id),
    CONSTRAINT agency_code_key UNIQUE (code)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.agency
    OWNER to neondb_owner;


-- Table: public.activity_log

-- DROP TABLE IF EXISTS public.activity_log;

CREATE TABLE IF NOT EXISTS public.activity_log
(
    id integer NOT NULL DEFAULT nextval('activity_log_id_seq'::regclass),
    user_id integer NOT NULL,
    action character varying(100) COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default",
    ip_address character varying(45) COLLATE pg_catalog."default",
    user_agent text COLLATE pg_catalog."default",
    created_at timestamp without time zone,
    CONSTRAINT activity_log_pkey PRIMARY KEY (id),
    CONSTRAINT activity_log_user_id_fkey FOREIGN KEY (user_id)
        REFERENCES public."user" (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.activity_log
    OWNER to neondb_owner;