--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5 (Postgres.app)
-- Dumped by pg_dump version 17.5 (Postgres.app)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: prodao_v2; Type: DATABASE; Schema: -; Owner: postgres
--

-- CREATE DATABASE prodao_v2 WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = icu LOCALE = 'en_US.UTF-8' ICU_LOCALE = 'en-US';


ALTER DATABASE prodao_v2 OWNER TO postgres;

\connect prodao_v2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: ad_attribute; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.ad_attribute AS ENUM (
    'art',
    'product',
    'service',
    'undefined'
);


ALTER TYPE public.ad_attribute OWNER TO postgres;

--
-- Name: business_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.business_type AS ENUM (
    'corporation',
    'individual',
    'freelancer',
    'non_profit'
);


ALTER TYPE public.business_type OWNER TO postgres;

--
-- Name: example_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.example_status AS ENUM (
    'pending',
    'approved',
    'rejected'
);


ALTER TYPE public.example_status OWNER TO postgres;

--
-- Name: member_role; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.member_role AS ENUM (
    'admin',
    'manager',
    'member'
);


ALTER TYPE public.member_role OWNER TO postgres;

--
-- Name: membership_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.membership_type AS ENUM (
    'free',
    'premium'
);


ALTER TYPE public.membership_type OWNER TO postgres;

--
-- Name: persona_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.persona_type AS ENUM (
    'personal',
    'organization'
);


ALTER TYPE public.persona_type OWNER TO postgres;

--
-- Name: registration_source; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.registration_source AS ENUM (
    'mobile_app',
    'web_browser',
    'partner_app'
);


ALTER TYPE public.registration_source OWNER TO postgres;

--
-- Name: subscription_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.subscription_status AS ENUM (
    'pending',
    'approved',
    'rejected',
    'cancelled',
    'expired'
);


ALTER TYPE public.subscription_status OWNER TO postgres;

--
-- Name: verified_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.verified_status AS ENUM (
    'pending',
    'approved',
    'rejected',
    'expired'
);


ALTER TYPE public.verified_status OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: admin; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.admin (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    username text NOT NULL,
    password text NOT NULL,
    token text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.admin OWNER TO postgres;

--
-- Name: business_individual_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.business_individual_info (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    persona_id text NOT NULL,
    personal_data jsonb,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.business_individual_info OWNER TO postgres;

--
-- Name: business_organization_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.business_organization_info (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    persona_id text NOT NULL,
    verified_status public.verified_status DEFAULT 'pending'::public.verified_status,
    registration_number text,
    name text,
    address text,
    legal_form text,
    registration_country text,
    industry text,
    founding_date timestamp(3) without time zone,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.business_organization_info OWNER TO postgres;

--
-- Name: business_organization_region_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.business_organization_region_info (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    organization_info_id text NOT NULL,
    country_code text NOT NULL,
    region_specific_data jsonb NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.business_organization_region_info OWNER TO postgres;

--
-- Name: comment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.comment (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    content text NOT NULL,
    author_id text NOT NULL,
    post_id text NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.comment OWNER TO postgres;

--
-- Name: persona; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persona (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    did text NOT NULL,
    persona_type public.persona_type DEFAULT 'personal'::public.persona_type NOT NULL,
    business_type public.business_type,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.persona OWNER TO postgres;

--
-- Name: persona_member; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persona_member (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    persona_id text NOT NULL,
    member_persona_id text NOT NULL,
    role public.member_role DEFAULT 'member'::public.member_role NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.persona_member OWNER TO postgres;

--
-- Name: persona_profile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persona_profile (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    persona_id text NOT NULL,
    display_name text NOT NULL,
    profile_image_url text,
    description text,
    email text,
    phone_number text,
    website text,
    tags text[] DEFAULT ARRAY[]::text[],
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    email_shown boolean DEFAULT true NOT NULL,
    phone_number_shown boolean DEFAULT true NOT NULL
);


ALTER TABLE public.persona_profile OWNER TO postgres;

--
-- Name: persona_subscriber; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.persona_subscriber (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    persona_id text NOT NULL,
    subscriber_id text NOT NULL,
    is_paid boolean,
    status public.subscription_status DEFAULT 'approved'::public.subscription_status NOT NULL,
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.persona_subscriber OWNER TO postgres;

--
-- Name: post; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.post (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    is_ad boolean DEFAULT false NOT NULL,
    ad_fee_balance double precision,
    ad_issuer_id text,
    ad_attribute public.ad_attribute DEFAULT 'undefined'::public.ad_attribute,
    ad_link text,
    author_id text NOT NULL,
    owner_id text,
    content text,
    value double precision DEFAULT 0,
    media_urls text[] DEFAULT ARRAY[]::text[],
    up_vote_ids text[] DEFAULT ARRAY[]::text[],
    down_vote_ids text[] DEFAULT ARRAY[]::text[],
    created_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.post OWNER TO postgres;

--
-- Name: wallet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wallet (
    did text NOT NULL,
    membership_type public.membership_type DEFAULT 'free'::public.membership_type NOT NULL,
    created_at timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP(3) NOT NULL,
    updated_at timestamp(3) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    registration_source public.registration_source DEFAULT 'mobile_app'::public.registration_source NOT NULL
);


ALTER TABLE public.wallet OWNER TO postgres;

--
-- Data for Name: admin; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.admin (id, username, password, token, is_active, created_at, updated_at) FROM stdin;
95ec10cc-a3f5-4aed-9ff5-480f9e2ca36d	admin	722ca13f4d3f61610fabb2025c597021018d18bafe7588f9669394daabbe42f6	0af6d35fb917354a7ddf5c67bba67436383a6dc1bf8c50f3ecab5a0f1f1fc5f6	t	2025-01-21 22:27:42.743	2025-01-21 22:27:42.743
3c945269-0405-46ae-9f68-2cfb50b9732d	kookdohyun	722ca13f4d3f61610fabb2025c597021018d18bafe7588f9669394daabbe42f6	b33684901478f13b9b9b1074a8fa64a45d04bdc4add9b5818a6f4fb49ed68746	t	2025-01-31 23:55:19.412	2025-01-31 23:55:19.412
5b4b42f1-59ff-4db2-85e4-0d7cb133f16e	gofiber	722ca13f4d3f61610fabb2025c597021018d18bafe7588f9669394daabbe42f6	d32a85af7f565063e2d0f31acf353f980466fe276b71d8b9839664fe7794a3c7	t	2025-02-04 08:57:24.069	2025-02-04 08:57:24.069
\.


--
-- Data for Name: business_individual_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.business_individual_info (id, persona_id, personal_data, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: business_organization_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.business_organization_info (id, persona_id, verified_status, registration_number, name, address, legal_form, registration_country, industry, founding_date, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: business_organization_region_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.business_organization_region_info (id, organization_info_id, country_code, region_specific_data, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: comment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.comment (id, content, author_id, post_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: persona; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.persona (id, did, persona_type, business_type, created_at, updated_at) FROM stdin;
94048e23-da65-4836-9be6-c127824300c4	REP2B3	organization	\N	2024-03-29 11:42:04	2024-03-29 11:42:04
be269914-8f65-4e4c-b3c5-b02313f8b4ac	T238X9	organization	\N	2024-01-10 10:56:14	2024-01-10 10:56:14
bd8c4a2c-6821-4d4e-b12e-466309ad9dad	TD38X9	organization	\N	2024-03-29 11:31:10	2024-03-29 11:31:10
12bd66e9-f9cd-4499-9fc0-41f25cb8b8c4	TEGRKB	organization	\N	2024-12-28 06:30:52	2024-12-28 06:30:52
835889ef-7e95-4dc9-9930-c517ec555496	U0P2B3	organization	\N	2023-11-22 02:32:35	2023-11-22 02:32:35
0e821cb6-49da-4347-84c9-327ea930cf79	UKQO98	organization	\N	2024-01-04 03:11:35	2024-01-04 03:11:35
b5413c8c-7247-4498-9c8a-044f4858c8bb	V538X9	organization	\N	2024-02-19 14:02:47	2024-02-19 14:02:47
d2aedf54-785c-4425-afa2-5b7d0ec3b96c	WVE5M6	organization	\N	2024-10-19 09:49:28	2024-10-19 09:49:28
0578fbdc-7527-4d57-a008-30a2078337cc	YKE5M6	organization	\N	2024-06-11 08:08:46	2024-06-11 08:08:46
1bc05a7f-1d0d-4b83-9604-a60579a3a2a7	002MY4	personal	\N	2024-04-16 14:04:51	2024-04-16 14:04:51
2d52f184-3c0c-400c-bf64-5a7f9d777394	00GRKB	personal	\N	2024-05-07 15:05:53	2024-05-07 15:05:53
012e0de3-ba65-4fd4-9a9a-f127d09672aa	00P2B3	personal	\N	2023-11-15 00:40:11	2023-11-15 00:40:11
28058267-5877-4bc2-a880-395176bd6b22	01P2B3	personal	\N	2023-11-23 08:15:32	2023-11-23 08:15:32
0c7eb249-08f8-4c51-9593-a767da6f91d1	022MY4	personal	\N	2024-05-17 10:30:57	2024-05-17 10:30:57
fa064d88-998d-4c55-be48-82ab58416db4	02RO98	personal	\N	2024-05-26 16:10:33	2024-05-26 16:10:33
68060645-8640-40ae-9c9e-3dfee802499c	032MY4	personal	\N	2024-06-08 11:40:22	2024-06-08 11:40:22
7e2a2c9f-ceee-43a9-8c22-b0e99af67bf0	04P2B3	personal	\N	2024-01-17 05:55:57	2024-01-17 05:55:57
72c05370-408a-4b24-b035-49d9957fa4bf	04RO98	personal	\N	2024-07-09 10:26:43	2024-07-09 10:26:43
a9ccf2a4-4f22-478d-97b9-b8296d74ada3	0538X9	personal	\N	2024-02-17 09:36:39	2024-02-17 09:36:39
0269f008-74dc-4e1a-8978-92de25c8f586	05GRKB	personal	\N	2024-07-11 08:48:51	2024-07-11 08:48:51
eba1380d-8516-4319-886e-903f811c6751	05RO98	personal	\N	2024-07-10 10:38:26	2024-07-10 10:38:26
eafc7f99-c36f-4653-9bb2-230114aa4c48	065UVE	personal	\N	2024-07-15 01:50:43	2024-07-15 01:50:43
8812812f-8bbf-4ae2-914a-b8cae24cdbcc	06E5M6	personal	\N	2024-02-19 07:02:01	2024-02-19 07:02:01
b1c3ad22-78a0-42a2-abc8-2bc0f3d8c24c	08RO98	personal	\N	2024-07-26 12:26:40	2024-07-26 12:26:40
583dcdbe-fbdd-4ecf-800d-831c7f7716f9	0CP2B3	personal	\N	2024-03-15 10:28:23	2024-03-15 10:28:23
080b5059-2b5b-42f9-8b18-443d06243138	0D2MY4	personal	\N	2024-08-30 02:43:12	2024-08-30 02:43:12
71e17c65-071a-4d64-a088-87926bfe0751	0I1MY4	personal	\N	2023-11-15 10:47:18	2023-11-15 10:47:18
30ef6f0f-9149-49a8-9761-36ce2fcf7e21	0I38X9	personal	\N	2024-04-30 21:27:47	2024-04-30 21:27:47
16fc1d80-fe27-4ba1-85c4-8f37959f145d	0KSA8D	personal	\N	2024-06-10 06:46:23	2024-06-10 06:46:23
54480456-85d1-42dd-8fb3-dc5265e5dea4	0N4UVE	personal	\N	2024-02-19 11:51:01	2024-02-19 11:51:01
dbef37eb-d458-4df7-8085-e1621c5c6e1f	0OFRKB	personal	\N	2024-02-19 19:22:02	2024-02-19 19:22:02
bc34840e-466d-4ce5-b98f-141437b9df7b	0QE5M6	personal	\N	2024-07-23 11:20:40	2024-07-23 11:20:40
aead667b-59bb-4feb-afac-26adbaf84454	0QFRKB	personal	\N	2024-02-26 22:59:27	2024-02-26 22:59:27
c823d629-1839-40cd-b697-4a46afc7e0d5	0S4UVE	personal	\N	2024-03-14 23:28:06	2024-03-14 23:28:06
ca0cdbdd-4d9e-4355-9804-381859c3d945	0WCJN1	personal	\N	2024-03-26 09:10:04	2024-03-26 09:10:04
3d04187a-9dea-431d-9bec-a4a262dc977b	0XFRKB	personal	\N	2024-04-04 15:23:50	2024-04-04 15:23:50
55003ec2-9c01-4edb-84a7-f86350a42154	0Y1MY4	personal	\N	2024-04-05 01:41:43	2024-04-05 01:41:43
ceee2a44-f9d5-47c8-a236-c2b810be38dd	0Z4UVE	personal	\N	2024-04-18 10:44:20	2024-04-18 10:44:20
8763bfc4-c0cc-45cf-b4d6-3437e2e2415f	10GRKB	personal	\N	2024-05-07 15:17:12	2024-05-07 15:17:12
5846ade9-c2a3-4042-b036-4a0e3e88a907	13E5M6	personal	\N	2024-01-04 01:49:03	2024-01-04 01:49:03
b9157f2d-642d-4b0f-8398-695f58c8e8bc	13GRKB	personal	\N	2024-06-27 08:22:30	2024-06-27 08:22:30
8c26dc0e-b249-4ad7-a217-344bb1711334	13RO98	personal	\N	2024-06-17 08:55:50	2024-06-17 08:55:50
a524752c-d860-44fd-b3b2-5cf6fdf75919	14DJN1	personal	\N	2024-06-19 15:25:21	2024-06-19 15:25:21
8e0f5e35-28db-4af3-94cb-d20c6085964d	1538X9	personal	\N	2024-02-17 11:47:19	2024-02-17 11:47:19
58ed4da8-415a-4333-aa80-0c32a7df552c	15GRKB	personal	\N	2024-07-11 16:48:02	2024-07-11 16:48:02
5e34d15c-b933-4228-8e65-d07c1603638a	195UVE	personal	\N	2024-08-09 07:07:34	2024-08-09 07:07:34
333384ff-45eb-42ce-9e37-4c32e85ad9b5	19DJN1	personal	\N	2024-07-27 10:17:47	2024-07-27 10:17:47
1f53a0b4-8d5a-44f3-9718-f88a9e21b804	19GRKB	personal	\N	2024-08-08 12:31:06	2024-08-08 12:31:06
d883e98c-2acf-4569-9e6b-8449e8a8d67c	1A2MY4	personal	\N	2024-08-08 14:34:52	2024-08-08 14:34:52
2bd9cad4-e12c-4949-9a91-33a8a4e3526a	1ADJN1	personal	\N	2024-08-03 19:22:57	2024-08-03 19:22:57
f4aefeb2-29ec-4a74-8b7d-0df5b71eb9b3	1ASA8D	personal	\N	2024-03-14 12:42:51	2024-03-14 12:42:51
2622d9e9-a235-40cc-ad43-d394b179c5db	1BE5M6	personal	\N	2024-03-14 15:26:21	2024-03-14 15:26:21
e9c970a7-cd3b-452e-b6f7-70b9d9d60148	1BSA8D	personal	\N	2024-03-21 01:23:57	2024-03-21 01:23:57
5b579c8a-f4e3-4470-b966-604f4e24dfb8	1C5UVE	personal	\N	2024-09-25 14:03:22	2024-09-25 14:03:22
a2a716af-7c8f-4903-a0c3-76a2c3f4850b	1ESA8D	personal	\N	2024-04-02 08:46:25	2024-04-02 08:46:25
3e969c04-e8bf-4376-a556-2a039627e19f	1HQO98	personal	\N	2023-11-13 01:19:33	2023-11-13 01:19:33
a9a5f83f-167c-4e62-b4f0-ed7a123d3990	1JQO98	personal	\N	2023-11-28 03:31:10	2023-11-28 03:31:10
890ee693-cc3f-4698-8d32-2f4be546fecc	1KE5M6	personal	\N	2024-05-24 14:57:06	2024-05-24 14:57:06
c1031e33-a294-4b1d-9d4f-94141379543d	1MCJN1	personal	\N	2024-01-14 06:29:07	2024-01-14 06:29:07
7f0443bc-3f54-407b-8b8f-35939c1bb8ee	1N38X9	personal	\N	2024-07-11 00:16:14	2024-07-11 00:16:14
a58a056b-ede7-4536-aaf8-fdecc2654857	1P1MY4	personal	\N	2024-02-20 05:57:49	2024-02-20 05:57:49
f3447f77-a323-4889-9561-6e207488001e	1P38X9	personal	\N	2024-07-16 02:00:43	2024-07-16 02:00:43
e23dd0b2-7699-4b27-9b31-7966d2d7376a	1PQO98	personal	\N	2024-02-20 09:26:29	2024-02-20 09:26:29
b9612053-c423-42f1-8129-a69d83a4227f	7BSA8D	organization	\N	2024-03-21 05:34:59	2024-03-21 05:34:59
69e01f2b-91dd-4f35-9830-4cc59ed58d57	A1E5M6	organization	\N	2023-11-28 07:02:25	2023-11-28 07:02:25
e6e68bd1-7618-4a50-95fb-904e3dc67a18	DLCJN1	organization	\N	2023-12-23 10:23:17	2023-12-23 10:23:17
535ea001-115c-46e7-9e7e-b8efaeda6e54	DMCJN1	organization	\N	2024-01-25 09:17:52	2024-01-25 09:17:52
76736e86-2aae-40c3-905f-c9991c527424	FD5UVE	organization	\N	2024-11-11 22:26:04	2024-11-11 22:26:04
e703bd05-a781-41ce-82b6-e0221018d631	FI1MY4	organization	\N	2023-11-19 09:10:00	2023-11-19 09:10:00
f023d294-7ee4-4022-9d71-92b6b8dc46b9	I7SA8D	organization	\N	2024-02-22 04:57:38	2024-02-22 04:57:38
cc00217b-f62e-45c5-a06b-16ab2da154b0	JJ1MY4	organization	\N	2023-11-28 07:11:10	2023-11-28 07:11:10
2eb093c8-035c-4de8-9ad8-2af4a4fe17d8	KVFRKB	organization	\N	2024-03-29 11:27:23	2024-03-29 11:27:23
e6c0d75d-3eb5-4f54-881c-3515c5eb6de7	L0P2B3	organization	\N	2023-11-17 09:35:09	2023-11-17 09:35:09
a105a530-0017-4c0f-9556-cc138081511c	1R38X9	personal	\N	2024-08-08 10:41:14	2024-08-08 10:41:14
28fa0891-a8ca-4d64-814f-9d6a777b3d73	1RCJN1	personal	\N	2024-02-21 16:31:07	2024-02-21 16:31:07
202e9593-8d08-449a-a703-92c39902daf2	1SFRKB	personal	\N	2024-03-14 10:14:19	2024-03-14 10:14:19
fb827194-17ea-4908-b52b-40602374db99	1SQO98	personal	\N	2024-03-13 20:23:15	2024-03-13 20:23:15
908fcac3-052f-4ef3-8ff6-4fee7cdb4234	1TE5M6	personal	\N	2024-08-13 11:32:01	2024-08-13 11:32:01
e5b526bd-4554-4b99-bf91-204c2583a5fa	1UCJN1	personal	\N	2024-03-15 05:08:39	2024-03-15 05:08:39
f71db5fd-aa50-4584-92bc-13ec64f7216b	1W1MY4	personal	\N	2024-03-26 20:10:02	2024-03-26 20:10:02
8a0aca32-4e3d-4dac-ad8b-4beac31d9494	1W4UVE	personal	\N	2024-04-03 06:08:10	2024-04-03 06:08:10
15469123-6318-4d2f-9c2d-8cce162c99ab	1WFRKB	personal	\N	2024-04-01 13:45:22	2024-04-01 13:45:22
3fc7b4ab-ab4a-40ad-9b0b-a2508465d80f	1XCJN1	personal	\N	2024-04-01 03:11:34	2024-04-01 03:11:34
07527f33-0d3b-41df-9fef-f9ec364f6d48	1XE5M6	personal	\N	2024-11-29 14:51:03	2024-11-29 14:51:03
c8c0fd33-6414-4b2c-a7fd-ce9ab0c5151f	1XFRKB	personal	\N	2024-04-04 22:17:19	2024-04-04 22:17:19
a3bb7a64-70ee-4f30-a73d-61faf1398188	1YCJN1	personal	\N	2024-04-03 23:37:21	2024-04-03 23:37:21
5431a241-78ce-4b21-b128-28dea9f8fae9	1ZRA8D	personal	\N	2023-11-16 02:31:07	2023-11-16 02:31:07
f483085f-ac29-4f81-b3b8-d89300345448	21DJN1	personal	\N	2024-04-26 07:00:01	2024-04-26 07:00:01
5e994f5b-b724-4f3f-89bf-6ed5f82ec4c8	22GRKB	personal	\N	2024-06-06 16:50:17	2024-06-06 16:50:17
48ee080c-fb26-4227-b492-e35396ccab2b	24SA8D	personal	\N	2024-02-14 07:09:45	2024-02-14 07:09:45
9fddd9be-9541-4519-a900-a4bde103a96c	265UVE	personal	\N	2024-07-15 03:33:51	2024-07-15 03:33:51
be7b620c-28e1-4e41-be15-cb80a0a2ea89	26DJN1	personal	\N	2024-07-10 22:54:14	2024-07-10 22:54:14
76d10db3-e4d8-4560-89bc-4454dd3ffd68	272MY4	personal	\N	2024-07-14 07:35:05	2024-07-14 07:35:05
325c4be4-3e35-450c-aba2-f66f774134e8	285UVE	personal	\N	2024-07-30 14:26:28	2024-07-30 14:26:28
d5d47433-2f55-4ef3-9802-acb7659ab33d	2AE5M6	personal	\N	2024-03-13 09:17:50	2024-03-13 09:17:50
f2478ee5-cf2e-4ec2-b312-24aaee25c6b5	2ASA8D	personal	\N	2024-03-14 13:27:51	2024-03-14 13:27:51
47e2ce69-9af9-4b6a-8c32-c1ef3bb659e1	2BP2B3	personal	\N	2024-03-14 09:06:30	2024-03-14 09:06:30
c53ce851-fa9d-41ad-a7e1-416cb7b166fe	2BSA8D	personal	\N	2024-03-21 04:40:35	2024-03-21 04:40:35
c9ef1120-2ef1-4a29-a58d-be66407eea6b	2D2MY4	personal	\N	2024-09-02 03:55:33	2024-09-02 03:55:33
db6df058-56ca-4a89-bc8e-ee5af30032c0	2D38X9	personal	\N	2024-03-26 11:12:08	2024-03-26 11:12:08
1d75df37-370e-462f-8992-a5ea79f9c574	2DDJN1	personal	\N	2024-08-16 03:18:45	2024-08-16 03:18:45
ddc66341-d059-4035-955b-337754470b86	2FP2B3	personal	\N	2024-04-01 08:46:40	2024-04-01 08:46:40
f3173f6b-71d2-47c1-9768-4ed28d2ee620	0CE5M6	organization	\N	2024-03-21 05:32:21	2024-03-21 05:32:21
89612df6-d726-4d5a-97f8-dee7b9fe2bfd	11E5M6	organization	\N	2023-11-24 03:34:41	2023-11-24 03:34:41
5dc09e11-8310-4e6b-a8fc-250aadd1e2b2	2LFRKB	organization	\N	2024-01-26 02:41:21	2024-01-26 02:41:21
ae7ec705-a261-4895-a223-3e6e0b0602b7	30E5M6	organization	\N	2023-11-16 23:24:55	2023-11-16 23:24:55
dab9453b-a30d-44ec-a414-132e953c2408	4HQO98	organization	\N	2023-11-13 01:49:29	2023-11-13 01:49:29
4d84444a-f4f9-42b7-a2ed-6821a490a904	2IP2B3	personal	\N	2024-04-16 11:42:52	2024-04-16 11:42:52
35c78fcd-a4ea-459c-9ee2-57cbf5b2e457	2KP2B3	personal	\N	2024-05-16 04:35:45	2024-05-16 04:35:45
eb75a743-3e63-4491-9c1e-1f433382498e	2KQO98	personal	\N	2023-12-12 11:21:47	2023-12-12 11:21:47
d45a09bd-7da6-4597-9bd6-64abcc507259	2L1MY4	personal	\N	2023-12-26 02:42:26	2023-12-26 02:42:26
ae0e8d7d-b836-4562-b344-a8eb5d208690	2L38X9	personal	\N	2024-06-24 05:33:15	2024-06-24 05:33:15
1e2957ac-522b-4d7a-bc6b-5c33ca78ecde	2OFRKB	personal	\N	2024-02-20 03:56:52	2024-02-20 03:56:52
9e6f4b0c-8151-4631-9030-b66d243d8301	2Q4UVE	personal	\N	2024-03-09 02:09:51	2024-03-09 02:09:51
602dd743-6287-46d7-a646-73bd88833927	2RSA8D	personal	\N	2024-08-09 01:41:58	2024-08-09 01:41:58
57c03fdb-ef6a-4bae-ab27-67a84b4c345c	2SFRKB	personal	\N	2024-03-14 10:27:17	2024-03-14 10:27:17
0094d8de-328c-4228-a067-272d7dffcc38	2WP2B3	personal	\N	2024-10-12 02:50:44	2024-10-12 02:50:44
16bc8b11-9047-4191-a3ea-4d79596a3eae	2Y4UVE	personal	\N	2024-04-15 05:38:38	2024-04-15 05:38:38
c98860ad-4d36-4b3d-9110-264a82401517	2Z4UVE	personal	\N	2024-04-18 10:44:30	2024-04-18 10:44:30
5874744e-0273-45f7-bf15-2a1eea3a3d9c	30P2B3	personal	\N	2023-11-15 04:38:36	2023-11-15 04:38:36
c91edd30-b1bc-4b24-a8ba-dd410062426c	312MY4	personal	\N	2024-05-09 15:32:48	2024-05-09 15:32:48
c1e73591-e3aa-4c35-842b-6e5ef3a4ac55	31E5M6	personal	\N	2023-11-27 03:29:02	2023-11-27 03:29:02
987aa07b-d3c9-4308-a239-857eeadec274	335UVE	personal	\N	2024-07-09 10:00:49	2024-07-09 10:00:49
b0edf305-d450-47c9-a021-ad76ce5ab057	35DJN1	personal	\N	2024-07-09 19:28:18	2024-07-09 19:28:18
a74d7363-3563-458f-bf53-513e83883f9f	39GRKB	personal	\N	2024-08-08 12:38:09	2024-08-08 12:38:09
1851f887-f6b6-4652-8210-9f4a8a316be6	39RO98	personal	\N	2024-07-31 08:05:09	2024-07-31 08:05:09
a6640a52-70f6-46fd-8d61-1c3dd8fee577	39SA8D	personal	\N	2024-03-13 06:58:02	2024-03-13 06:58:02
e4cf17de-c9e2-4665-b51f-9fa42141931f	3AGRKB	personal	\N	2024-08-12 08:34:39	2024-08-12 08:34:39
50d29d7c-59ad-4e31-a3d6-10dcba8aac51	3BE5M6	personal	\N	2024-03-14 18:06:49	2024-03-14 18:06:49
77b4ebfa-74e3-42b8-ad8d-d363edac853c	3C38X9	personal	\N	2024-03-25 05:58:41	2024-03-25 05:58:41
7a0a197e-423c-4095-b3c7-6ca58a16d1a2	3C5UVE	personal	\N	2024-09-28 04:14:47	2024-09-28 04:14:47
a7d213e7-d304-4dd2-8cc3-3fa811ef6036	3DP2B3	personal	\N	2024-03-25 11:35:11	2024-03-25 11:35:11
eab0bcf1-82f3-40db-82fb-ace10ee4a383	3EDJN1	personal	\N	2024-10-02 00:45:46	2024-10-02 00:45:46
c1fbb481-dd2c-4585-9b7c-06d180d77d2d	3EE5M6	personal	\N	2024-03-29 01:13:38	2024-03-29 01:13:38
d745dfe7-443b-4cee-9e17-e01f01880878	3EGRKB	personal	\N	2024-11-13 02:47:54	2024-11-13 02:47:54
bc27b7f0-3bff-47ca-8876-97151f97b2a7	3EP2B3	personal	\N	2024-03-26 12:52:01	2024-03-26 12:52:01
78b933d8-c426-4e7e-a50f-689ca3971b19	3FE5M6	personal	\N	2024-04-02 23:00:14	2024-04-02 23:00:14
c8bcb4ae-3a32-4ffc-a896-9f7221ae11d7	3FSA8D	personal	\N	2024-04-05 07:20:24	2024-04-05 07:20:24
490347b3-bb8b-44da-8981-4c57e846ce3a	3G38X9	personal	\N	2024-04-14 05:47:20	2024-04-14 05:47:20
4ca77b2f-5b11-4d04-af2a-d4a74adbd726	3JP2B3	personal	\N	2024-05-07 04:47:38	2024-05-07 04:47:38
5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	3K4UVE	personal	\N	2024-01-09 05:09:41	2024-01-09 05:09:41
60c80b7f-06ff-4c7c-963b-f9c4d0c62cb3	3KFRKB	personal	\N	2023-12-24 02:28:42	2023-12-24 02:28:42
1e9b90d7-3fee-4ba9-a642-917f086017c9	3LCJN1	personal	\N	2023-12-16 10:22:48	2023-12-16 10:22:48
6311a07e-9492-4ece-8578-5a4e02dc6535	3O38X9	personal	\N	2024-07-13 04:00:45	2024-07-13 04:00:45
0aca12c1-04f2-4cb3-9e75-987e79ca6f0c	3Q1MY4	personal	\N	2024-02-21 01:58:50	2024-02-21 01:58:50
93f559c3-0db5-4d3e-9463-57a5729ae794	3Q4UVE	personal	\N	2024-03-11 04:22:32	2024-03-11 04:22:32
d0104fdf-dc7c-451c-8f1f-3f9abb4de8e9	3QFRKB	personal	\N	2024-02-28 09:00:04	2024-02-28 09:00:04
bb3e8773-d839-4b28-ab2f-4891c0588c74	3TE5M6	personal	\N	2024-08-13 14:28:23	2024-08-13 14:28:23
3c10a153-3a55-4164-9729-5b7ada3ab60a	3TQO98	personal	\N	2024-03-15 04:54:55	2024-03-15 04:54:55
2024579d-2075-4417-afb4-9d83dd3d546c	3V1MY4	personal	\N	2024-03-25 13:23:39	2024-03-25 13:23:39
5fb9c23d-5236-4675-8c9b-537ea30e248f	3VCJN1	personal	\N	2024-03-23 23:16:08	2024-03-23 23:16:08
efaa39f8-49da-4aed-93e9-e2ea217fc9b8	3VE5M6	personal	\N	2024-09-25 05:32:44	2024-09-25 05:32:44
4c628453-6891-452c-ab9a-de85815a83eb	3X38X9	personal	\N	2025-01-06 05:10:57	2025-01-06 05:10:57
1aa37920-edce-42e7-98eb-4c32345cc71a	40E5M6	personal	\N	2023-11-17 03:38:16	2023-11-17 03:38:16
1d139ae7-6402-4ca1-bfbc-79635ba7a81f	43DJN1	personal	\N	2024-05-31 07:44:28	2024-05-31 07:44:28
69fc4171-6fad-4eaa-a382-8994f76b1f8a	442MY4	personal	\N	2024-07-02 10:52:27	2024-07-02 10:52:27
1666014e-afa9-4826-aeb6-9146cfd7e449	44GRKB	personal	\N	2024-07-09 20:57:58	2024-07-09 20:57:58
c662510d-a483-4da8-b9c4-96f2bb450a40	44P2B3	personal	\N	2024-01-25 07:19:23	2024-01-25 07:19:23
f5878b9c-e537-4e5d-a130-b5ff56be0fdc	45RO98	personal	\N	2024-07-10 21:19:23	2024-07-10 21:19:23
7672ded2-36c6-40e6-8d4a-9090ba8f8957	46P2B3	personal	\N	2024-02-17 15:56:00	2024-02-17 15:56:00
5ed8d23d-49b9-433a-9d52-6e24c50d3455	46RO98	personal	\N	2024-07-12 12:14:45	2024-07-12 12:14:45
c54cabc6-ac33-4868-8044-b5c44375b239	4738X9	personal	\N	2024-02-20 12:07:07	2024-02-20 12:07:07
7bd7d403-47e5-4459-8aef-43a51a83c747	48GRKB	personal	\N	2024-07-28 15:05:18	2024-07-28 15:05:18
8c0a9d96-360f-4395-8210-817488614318	48RO98	personal	\N	2024-07-27 04:35:15	2024-07-27 04:35:15
268b78d3-4ece-4520-b8eb-c1bda8574617	49E5M6	personal	\N	2024-03-09 00:02:15	2024-03-09 00:02:15
00a5de4e-b1eb-4cdf-ae78-2546e7d5935f	4AE5M6	personal	\N	2024-03-13 10:26:13	2024-03-13 10:26:13
c01b8fb5-23b9-4268-9cb5-c5213d2e6590	4BRO98	personal	\N	2024-08-14 12:10:11	2024-08-14 12:10:11
8094ca37-d204-44c2-9dca-8851ccd31e91	4CDJN1	personal	\N	2024-08-14 13:07:57	2024-08-14 13:07:57
71250fbc-ab27-4de9-940e-eadbeabbcdb4	4HP2B3	personal	\N	2024-04-14 12:45:29	2024-04-14 12:45:29
c97bb436-c55e-4222-a494-49af4ac02b31	4I38X9	personal	\N	2024-05-05 01:26:53	2024-05-05 01:26:53
728cb098-b1db-410e-94a4-d08a630d8076	4J1MY4	personal	\N	2023-11-23 08:26:02	2023-11-23 08:26:02
699de247-c0c8-4a8b-bae8-6ba24d9489c1	4KFRKB	personal	\N	2023-12-24 04:14:21	2023-12-24 04:14:21
5e27148a-c486-4282-9cc5-7ec352cd411b	4L1MY4	personal	\N	2023-12-27 04:48:24	2023-12-27 04:48:24
b5a54e7b-805c-4edd-bfc1-e0fa60a2f9cf	4LE5M6	personal	\N	2024-06-15 10:06:23	2024-06-15 10:06:23
4038ac51-b9c3-4cfc-b08a-7b591eca29f3	4ME5M6	personal	\N	2024-07-09 09:00:41	2024-07-09 09:00:41
1e739310-46d8-4ec7-b986-b2172bf66c83	4NE5M6	personal	\N	2024-07-10 03:18:36	2024-07-10 03:18:36
b108c58a-4722-4bb6-bf8e-d3486b06d900	4Q4UVE	personal	\N	2024-03-12 07:12:54	2024-03-12 07:12:54
d641f73a-5186-4fba-9ac7-50c5c79884d1	4WCJN1	personal	\N	2024-03-26 10:52:02	2024-03-26 10:52:02
407ae14a-060d-4d91-89d1-39535ab93b0a	4WP2B3	personal	\N	2024-10-14 21:48:37	2024-10-14 21:48:37
497df9f0-8a3f-4bb8-9f7c-17fdbacf1534	4X38X9	personal	\N	2025-01-08 05:44:08	2025-01-08 05:44:08
4073a968-4ef2-4b55-a05f-c01e5284cff6	4Y1MY4	personal	\N	2024-04-05 03:40:58	2024-04-05 03:40:58
3eeeb342-b160-4b77-b1a1-0ff90a31a07a	50GRKB	personal	\N	2024-05-09 02:52:47	2024-05-09 02:52:47
c9316baf-b03a-4f02-b9c9-772f7d18aa58	535UVE	personal	\N	2024-07-09 15:25:14	2024-07-09 15:25:14
260093ba-f172-402d-bd45-52a17588233f	53DJN1	personal	\N	2024-05-31 22:48:30	2024-05-31 22:48:30
35788f05-4029-4b19-a198-dcbeb95d3b83	5438X9	personal	\N	2024-02-06 03:28:20	2024-02-06 03:28:20
1b933f94-02d5-4aa9-b231-b2a07d99b765	54DJN1	personal	\N	2024-06-24 04:58:23	2024-06-24 04:58:23
07e5e67e-c5e8-4423-98c0-ec12c14cbdff	55DJN1	personal	\N	2024-07-09 19:32:57	2024-07-09 19:32:57
d95bf52d-d122-492b-aa98-fe1702ef0f31	55E5M6	personal	\N	2024-02-17 03:53:05	2024-02-17 03:53:05
ccd77641-e05b-4160-8b88-90f763fd56cd	5838X9	personal	\N	2024-02-26 11:29:52	2024-02-26 11:29:52
36218a8c-dfa9-4c66-8f79-2e283fefaf80	58P2B3	personal	\N	2024-02-20 12:54:22	2024-02-20 12:54:22
7543d9a5-e2c5-4a9e-a921-c8141bd898cc	592MY4	personal	\N	2024-07-29 03:34:43	2024-07-29 03:34:43
0493a2f5-d743-4dca-80b5-0710741c864d	595UVE	personal	\N	2024-08-09 16:54:56	2024-08-09 16:54:56
e3450cd8-98f2-4229-819c-8c3e8b832e11	5A2MY4	personal	\N	2024-08-08 18:35:37	2024-08-08 18:35:37
0f7ed2fe-27c8-476d-9576-e71b855033a6	5ARO98	personal	\N	2024-08-10 08:19:57	2024-08-10 08:19:57
63c50a8c-1928-4fe1-a614-7f82ab64ea88	5B2MY4	personal	\N	2024-08-13 01:59:22	2024-08-13 01:59:22
0c121d74-b2af-453f-8595-825c063cf601	5BDJN1	personal	\N	2024-08-10 17:40:09	2024-08-10 17:40:09
fdcb4e15-76f3-4a11-a3e8-564ea2bc4754	5BE5M6	personal	\N	2024-03-14 23:43:24	2024-03-14 23:43:24
c3e729df-b864-488f-950e-b828d01ab4e0	5DE5M6	personal	\N	2024-03-26 02:53:19	2024-03-26 02:53:19
f034f251-e39b-4d2c-922d-1cb8f488a36e	5DP2B3	personal	\N	2024-03-25 12:02:03	2024-03-25 12:02:03
539dd60d-44d6-4808-a75d-976f4ff14489	5ERO98	personal	\N	2024-11-05 23:36:29	2024-11-05 23:36:29
6e4f7030-cc14-4b88-b7b9-3fe0364d1411	5H38X9	personal	\N	2024-04-16 11:29:59	2024-04-16 11:29:59
4cdac558-f594-40ab-9bd7-2d3a30f344d8	5HSA8D	personal	\N	2024-04-18 10:40:57	2024-04-18 10:40:57
dd8426af-0b32-4037-a511-c1234f683a1d	5I38X9	personal	\N	2024-05-07 03:20:29	2024-05-07 03:20:29
48f65faa-3da4-4552-9a5b-2448cbbb01dd	5LSA8D	personal	\N	2024-07-09 08:26:08	2024-07-09 08:26:08
8670a7bc-79cd-4449-b097-240802aa15ee	5NP2B3	personal	\N	2024-07-09 20:34:55	2024-07-09 20:34:55
1984f081-73f8-4882-aabb-d48600cd802e	5O38X9	personal	\N	2024-07-13 14:38:10	2024-07-13 14:38:10
619e5340-946f-4ebc-a130-62af23582a69	5P38X9	personal	\N	2024-07-16 11:05:18	2024-07-16 11:05:18
c2d8d0d1-43dc-4d39-9170-071ff5bf0cb2	5P4UVE	personal	\N	2024-02-21 06:42:58	2024-02-21 06:42:58
19d96152-2e98-439e-bb2a-71f813fc7846	5PCJN1	personal	\N	2024-02-19 15:34:10	2024-02-19 15:34:10
2291bd25-243d-4010-95a1-3762317772f2	5PP2B3	personal	\N	2024-07-14 00:00:11	2024-07-14 00:00:11
969d10d5-2c1b-47c0-b79f-b2d5f2391cc9	5Q1MY4	personal	\N	2024-02-21 05:27:34	2024-02-21 05:27:34
f49526f8-676c-4971-8f40-65b5ebe614a5	5R38X9	personal	\N	2024-08-08 11:40:58	2024-08-08 11:40:58
d7e6076d-3597-4faa-b092-29f95a11dca7	5VQO98	personal	\N	2024-03-26 09:26:07	2024-03-26 09:26:07
f3bd997d-7b71-44a1-ae2a-51bc696ecfe4	5XCJN1	personal	\N	2024-04-01 07:27:19	2024-04-01 07:27:19
5ea1a22c-a5dd-409f-adca-32042c0af259	60DJN1	personal	\N	2024-04-16 05:37:00	2024-04-16 05:37:00
204d395b-19aa-483d-ace2-1fe096cf0c7a	60SA8D	personal	\N	2023-11-25 09:58:10	2023-11-25 09:58:10
f58db1a0-bd01-45b1-adbd-a44e34727972	625UVE	personal	\N	2024-06-17 10:21:21	2024-06-17 10:21:21
b73354ff-ae09-4ff6-881e-801f7702fd74	62GRKB	personal	\N	2024-06-10 03:05:07	2024-06-10 03:05:07
372a1edd-05f7-4df6-a156-acc36f8690bb	63SA8D	personal	\N	2024-02-03 19:56:12	2024-02-03 19:56:12
c1805abd-7775-4ff5-a06f-cb43b07f023a	64E5M6	personal	\N	2024-02-04 03:52:41	2024-02-04 03:52:41
9cd54584-17b2-4cc0-956f-df5ed34ffe56	66RO98	personal	\N	2024-07-12 16:55:27	2024-07-12 16:55:27
48101c5e-8026-4206-9b7e-bb3c01018b75	6838X9	personal	\N	2024-02-26 11:29:54	2024-02-26 11:29:54
79abd7eb-b131-4f1c-b03d-5462da497227	695UVE	personal	\N	2024-08-10 00:39:46	2024-08-10 00:39:46
bf0c880e-de71-403a-8309-b00019534fb2	6ARO98	personal	\N	2024-08-10 10:36:47	2024-08-10 10:36:47
40261e09-5752-408b-8626-1a5c37c8c471	6CDJN1	personal	\N	2024-08-14 14:11:20	2024-08-14 14:11:20
3f5d7d88-4e88-4702-b00b-882f8c113729	6D2MY4	personal	\N	2024-09-10 09:23:01	2024-09-10 09:23:01
870f1c96-feab-4030-a0eb-c7aaa005248f	6DGRKB	personal	\N	2024-10-15 23:44:58	2024-10-15 23:44:58
09c032d0-cae3-4508-a75f-f6fd9730c14b	6FE5M6	personal	\N	2024-04-03 06:08:11	2024-04-03 06:08:11
f9704227-3e08-4712-b610-1c6322be6c1f	6FP2B3	personal	\N	2024-04-02 00:12:46	2024-04-02 00:12:46
c009e9c3-812b-4298-ba20-7fc1172e42fa	6FSA8D	personal	\N	2024-04-05 11:44:14	2024-04-05 11:44:14
60695308-c9d9-4a9a-ad63-60370cc247ce	6G38X9	personal	\N	2024-04-14 12:33:01	2024-04-14 12:33:01
3e6671fd-015f-4c7b-a993-fea352101423	6K38X9	personal	\N	2024-06-05 03:17:11	2024-06-05 03:17:11
758d00ef-b613-494d-b755-7126564cd2e2	6KQO98	personal	\N	2023-12-14 10:11:16	2023-12-14 10:11:16
cf1e383e-42f9-4548-a737-ffa464a2a1e4	6LCJN1	personal	\N	2023-12-18 09:54:46	2023-12-18 09:54:46
12687c62-17d7-4653-a2ad-d9f91bb69992	6ME5M6	personal	\N	2024-07-09 10:00:19	2024-07-09 10:00:19
d3aead05-5719-4e8b-b40e-3850f87f4f13	6N38X9	personal	\N	2024-07-11 08:20:12	2024-07-11 08:20:12
5abe2855-da1a-4186-87b6-2196b6291e10	6QE5M6	personal	\N	2024-07-24 21:25:31	2024-07-24 21:25:31
d2b0fa1d-1b38-4c39-a72a-9918682b25b6	6QP2B3	personal	\N	2024-07-17 00:30:15	2024-07-17 00:30:15
ffe2e58a-8157-44db-b0ca-6113571ae3bb	6TE5M6	personal	\N	2024-08-14 02:55:44	2024-08-14 02:55:44
8dc9ae99-a83c-48c6-88c3-ffa6bca97ecd	6TP2B3	personal	\N	2024-08-12 03:57:06	2024-08-12 03:57:06
03486acc-4946-4fb4-8df7-ed3c4ab9716e	6TQO98	personal	\N	2024-03-15 09:15:24	2024-03-15 09:15:24
3690381c-9a4e-4089-bcb2-803eca72302b	6UE5M6	personal	\N	2024-08-15 04:35:27	2024-08-15 04:35:27
6a40739f-2cc4-4e8d-ac39-87e2c255e86f	6VQO98	personal	\N	2024-03-26 09:51:24	2024-03-26 09:51:24
7b962db5-8fc5-4b0f-82ea-4c3728add8a5	6YCJN1	personal	\N	2024-04-04 05:11:11	2024-04-04 05:11:11
33e4fe8e-974a-48cd-ab78-22dd2e3155ad	722MY4	personal	\N	2024-05-24 12:01:24	2024-05-24 12:01:24
e734c06e-ec1c-49bb-a28c-dce97b038aa5	73SA8D	personal	\N	2024-02-03 23:07:21	2024-02-03 23:07:21
0cf57fec-fb2a-4d9e-8b55-0a0dc460be2e	75GRKB	personal	\N	2024-07-11 17:49:58	2024-07-11 17:49:58
2d5013c7-9091-450a-847d-ed5108d415f6	7638X9	personal	\N	2024-02-19 16:42:25	2024-02-19 16:42:25
5b2edbec-d698-4ea8-8a27-d8bcc7e74ffa	76P2B3	personal	\N	2024-02-17 17:23:03	2024-02-17 17:23:03
45aa8b28-c678-4e4a-9352-27ab690df852	76SA8D	personal	\N	2024-02-20 09:25:57	2024-02-20 09:25:57
0450904b-3317-451f-86fd-9e606db4186f	77E5M6	personal	\N	2024-02-20 09:26:17	2024-02-20 09:26:17
437a268e-e28e-4d15-b50f-3190fff9acaf	77P2B3	personal	\N	2024-02-20 04:22:27	2024-02-20 04:22:27
9c43b826-e7e6-45af-b998-6a36c665dd66	782MY4	personal	\N	2024-07-22 02:51:12	2024-07-22 02:51:12
6ed9c1d5-d62c-44ac-b999-1ea238f6f7a4	79SA8D	personal	\N	2024-03-13 09:20:11	2024-03-13 09:20:11
4e8d66c7-a9be-4ce9-8871-688be508e47b	7ADJN1	personal	\N	2024-08-08 11:08:27	2024-08-08 11:08:27
ebceb499-ed99-497e-9f03-3be25d554fa5	7ARO98	personal	\N	2024-08-10 16:50:12	2024-08-10 16:50:12
64790acb-8a74-4cb4-8505-2152fdb18913	7BRO98	personal	\N	2024-08-14 12:59:18	2024-08-14 12:59:18
c17ad9e2-f932-4dd7-950a-2bb25a9b0772	7D5UVE	personal	\N	2024-11-01 00:10:41	2024-11-01 00:10:41
3d7a647b-d4d3-45fa-9d1b-cdf8e38bd747	7DE5M6	personal	\N	2024-03-26 04:18:31	2024-03-26 04:18:31
d43e69cd-1f95-4c78-852d-a87045535739	7E38X9	personal	\N	2024-04-01 08:53:48	2024-04-01 08:53:48
ea730390-e55a-4d93-bc97-4cf4ec5d1b28	7FP2B3	personal	\N	2024-04-02 01:32:23	2024-04-02 01:32:23
5efc6baa-40ff-406f-aab6-3cd7e48a7f26	7J1MY4	personal	\N	2023-11-23 08:37:08	2023-11-23 08:37:08
bd389783-9d15-4d6e-a184-5e5f04282628	7J38X9	personal	\N	2024-05-16 23:28:51	2024-05-16 23:28:51
9c4c3855-f8c8-4567-b5f9-db4c8d90b4e5	7J4UVE	personal	\N	2023-12-13 02:02:05	2023-12-13 02:02:05
9bdf6f88-144e-4836-9d28-a1e6715e47e6	7K38X9	personal	\N	2024-06-05 03:49:56	2024-06-05 03:49:56
a8af0e64-0ac6-46fb-99f1-6da08eeab725	7K4UVE	personal	\N	2024-01-12 05:41:00	2024-01-12 05:41:00
5b316a00-25b2-4fd7-8796-5dbb7f51f948	7KFRKB	personal	\N	2023-12-26 03:53:10	2023-12-26 03:53:10
2de42ebb-41bf-47a5-9e98-0bd9d83864b7	7MCJN1	personal	\N	2024-01-15 09:19:26	2024-01-15 09:19:26
11b69bd0-c362-482b-a2dc-9a42ca65b4ed	7MQO98	personal	\N	2024-02-05 03:32:21	2024-02-05 03:32:21
18f9303b-4bf3-412d-ba02-208b9ed493c8	7NE5M6	personal	\N	2024-07-10 08:05:04	2024-07-10 08:05:04
17cbb8b4-443f-4301-aac0-2179e2caa7e1	7OFRKB	personal	\N	2024-02-20 06:19:48	2024-02-20 06:19:48
0c52f7a4-4b0f-4a58-a5be-4b2e165cb879	7PSA8D	personal	\N	2024-07-24 09:16:11	2024-07-24 09:16:11
2fc63575-ed81-4633-9117-b8fcb774cf85	7R1MY4	personal	\N	2024-03-06 06:14:23	2024-03-06 06:14:23
70c7e4b1-61e3-4ea7-b254-f7a6477d7e1a	7RCJN1	personal	\N	2024-02-26 11:28:24	2024-02-26 11:28:24
22921271-6e10-4457-b991-57d5bf3c2b86	7TFRKB	personal	\N	2024-03-21 00:50:45	2024-03-21 00:50:45
22db4f8d-e65c-49b3-b961-4a2dc7aa717f	7X1MY4	personal	\N	2024-04-02 11:37:43	2024-04-02 11:37:43
b475c6de-61e8-4434-8e6c-5b7de040c4d0	7X4UVE	personal	\N	2024-04-08 05:39:56	2024-04-08 05:39:56
50b8684b-550d-49cb-a35b-afec75bf3aa9	7YCJN1	personal	\N	2024-04-04 06:43:55	2024-04-04 06:43:55
d1bb5ce8-5f7b-4f87-9003-a3bf15e45eb5	80DJN1	personal	\N	2024-04-16 11:13:42	2024-04-16 11:13:42
6850cb8f-da10-41ea-9859-c7dd9a5d7d41	815UVE	personal	\N	2024-05-28 16:22:40	2024-05-28 16:22:40
d15bfb61-8af0-49af-af82-24696cd922a9	8238X9	personal	\N	2023-12-22 03:51:46	2023-12-22 03:51:46
e5a95fef-9596-4e36-9751-32c42118cb96	8738X9	personal	\N	2024-02-20 12:41:11	2024-02-20 12:41:11
1543db57-9c36-4a03-b917-401ada53eb22	87E5M6	personal	\N	2024-02-20 09:26:26	2024-02-20 09:26:26
30ff9403-8e38-41f1-a1a6-df011dc762a9	885UVE	personal	\N	2024-07-31 15:02:13	2024-07-31 15:02:13
45b5772d-25aa-4cbf-b564-c3bd5fd55394	89GRKB	personal	\N	2024-08-08 18:29:25	2024-08-08 18:29:25
3d98c311-3ad2-4f4b-8a3c-9d1e9ddeb891	8A38X9	personal	\N	2024-03-14 09:38:44	2024-03-14 09:38:44
aef43db0-218c-4ac1-9b2a-4d8dddef9a5b	8ADJN1	personal	\N	2024-08-08 11:31:59	2024-08-08 11:31:59
3d328497-971a-4cca-b0e6-6d959503bac0	8BSA8D	personal	\N	2024-03-21 06:25:22	2024-03-21 06:25:22
2320d2eb-0465-4005-9f06-5d1975722fa0	8CRO98	personal	\N	2024-08-17 16:17:27	2024-08-17 16:17:27
d3295e14-3dfc-43d0-9f4c-5969722a684a	8D2MY4	personal	\N	2024-09-13 04:53:19	2024-09-13 04:53:19
18ec4073-a1b8-42e0-b1df-7364f5fb34b2	8DE5M6	personal	\N	2024-03-26 04:27:05	2024-03-26 04:27:05
d545b20a-1938-4112-a021-eeadd68c67f3	8DP2B3	personal	\N	2024-03-25 12:16:28	2024-03-25 12:16:28
e53c3d28-bad0-465a-9b49-e0209ff0793c	8EDJN1	personal	\N	2024-10-08 18:57:59	2024-10-08 18:57:59
a2b27317-a6a4-451c-80c1-d2d713ddce4f	8F2MY4	personal	\N	2024-11-28 23:54:21	2024-11-28 23:54:21
9a43cfea-d61d-411e-bff8-d6adb0ac6ac5	8FE5M6	personal	\N	2024-04-03 07:14:23	2024-04-03 07:14:23
0a6da93a-b562-4cb1-ae3c-3c03dff24ab5	8FP2B3	personal	\N	2024-04-02 03:22:46	2024-04-02 03:22:46
e1b17f1a-c270-4a08-8ad1-fa243d3fcb50	8IE5M6	personal	\N	2024-04-19 12:04:33	2024-04-19 12:04:33
2cce5b27-168f-4bc5-b6e9-397aa126e754	8JFRKB	personal	\N	2023-12-02 18:01:24	2023-12-02 18:01:24
e471db4b-ef29-4670-9730-3101f90741ab	8JQO98	personal	\N	2023-11-30 02:40:09	2023-11-30 02:40:09
9286bd31-585b-4648-ac31-7d3f2a180ea5	8KQO98	personal	\N	2023-12-17 11:00:57	2023-12-17 11:00:57
b1cb2c7c-53bc-4a77-9764-ced8ee32cc5a	8L1MY4	personal	\N	2024-01-03 07:06:36	2024-01-03 07:06:36
8b6bb28b-3a33-4499-8d67-2bb589dfb8d8	8L38X9	personal	\N	2024-06-27 08:22:05	2024-06-27 08:22:05
3211f61c-960e-40dc-932a-1f5241d808f2	8M38X9	personal	\N	2024-07-09 20:22:53	2024-07-09 20:22:53
6fc7cc75-200e-49fe-935e-79111fb8948e	8MP2B3	personal	\N	2024-06-28 05:19:40	2024-06-28 05:19:40
c94f9fae-1858-40a6-b6e9-45858f0943a8	8QP2B3	personal	\N	2024-07-17 10:06:29	2024-07-17 10:06:29
75bc0d40-b032-4ad8-92a7-1ecbcf1944d0	8R4UVE	personal	\N	2024-03-13 22:24:06	2024-03-13 22:24:06
3c7cd7ce-dcc5-439d-ae39-00f31f02030d	8TFRKB	personal	\N	2024-03-21 00:54:14	2024-03-21 00:54:14
2ab1fd33-9b04-482b-8c6f-365c9f03a94c	8V4UVE	personal	\N	2024-03-29 13:50:40	2024-03-29 13:50:40
caf289ec-c0fd-4bd3-99bb-66d1e96ad09d	8X1MY4	personal	\N	2024-04-02 15:36:17	2024-04-02 15:36:17
5d8560a9-139b-439f-8b13-487269dbb8f9	8X4UVE	personal	\N	2024-04-12 07:54:22	2024-04-12 07:54:22
118fb523-0789-47a7-9fdc-f53b93fdb406	8Y1MY4	personal	\N	2024-04-05 08:13:23	2024-04-05 08:13:23
1613845b-8a02-4600-b09c-ad5231e5129a	90GRKB	personal	\N	2024-05-09 22:25:07	2024-05-09 22:25:07
1f687104-91d9-4244-bafc-dc2df4bb4720	90P2B3	personal	\N	2023-11-15 12:07:03	2023-11-15 12:07:03
38735eef-62f6-418b-a02d-14bc0f491031	9138X9	personal	\N	2023-12-02 06:58:28	2023-12-02 06:58:28
c4a37833-a371-486c-9eec-2266bdb30b57	935UVE	personal	\N	2024-07-09 16:52:41	2024-07-09 16:52:41
22d3e392-2c46-474d-ba13-0017ca9e76e0	93GRKB	personal	\N	2024-07-03 01:45:47	2024-07-03 01:45:47
773ddace-2da7-4b9f-876c-eb57da439b7a	94E5M6	personal	\N	2024-02-04 10:27:58	2024-02-04 10:27:58
a12ae9da-e57f-47ac-a76c-2f86549e6ad7	95DJN1	personal	\N	2024-07-09 19:57:40	2024-07-09 19:57:40
88831590-c263-4a56-ae1e-f248bdcf7078	95GRKB	personal	\N	2024-07-11 22:18:10	2024-07-11 22:18:10
10e2734b-e7c8-49b4-a152-2f6782d2db0b	9BSA8D	personal	\N	2024-03-21 08:18:56	2024-03-21 08:18:56
60c1c053-6438-451b-9772-4525172235d0	9DDJN1	personal	\N	2024-08-25 08:02:30	2024-08-25 08:02:30
3cf14470-e612-407a-bd72-2a86c0e08560	9DP2B3	personal	\N	2024-03-25 12:25:28	2024-03-25 12:25:28
e90dd22c-e834-4dca-80cf-9a426326fb98	9DSA8D	personal	\N	2024-03-29 06:36:51	2024-03-29 06:36:51
cc88328b-fdad-4772-8461-3a6e76b1996e	9EGRKB	personal	\N	2024-11-21 23:00:14	2024-11-21 23:00:14
ee673763-a95f-43fa-a3bf-5efd8772ccdc	9GDJN1	personal	\N	2025-01-09 23:07:21	2025-01-09 23:07:21
4088dc01-b5cc-4127-98cd-93debca761df	9K38X9	personal	\N	2024-06-06 03:31:14	2024-06-06 03:31:14
80d50a82-65db-4ce9-bf3e-e679c14b6765	9O1MY4	personal	\N	2024-02-19 10:54:50	2024-02-19 10:54:50
e85eb3c1-6e64-461a-88c0-2260e4085d63	9PE5M6	personal	\N	2024-07-15 08:26:29	2024-07-15 08:26:29
a02aa3c1-7a73-40b9-a307-f639e10caebd	9PQO98	personal	\N	2024-02-20 10:33:13	2024-02-20 10:33:13
78bb8db7-6fdf-4ddf-b2ca-e495ecbd1fea	9QQO98	personal	\N	2024-02-24 11:52:11	2024-02-24 11:52:11
98e102da-d110-44fe-9df5-ccebc0fb6837	9S38X9	personal	\N	2024-08-11 16:28:16	2024-08-11 16:28:16
b0fa13b5-d8ff-49dc-ac96-f5e719147d67	9TSA8D	personal	\N	2024-08-15 04:34:28	2024-08-15 04:34:28
aed4eb23-b290-48dc-81f5-eb28d3487d29	9V1MY4	personal	\N	2024-03-26 00:21:21	2024-03-26 00:21:21
682b2001-13bd-4562-8bec-240532e430c8	9VFRKB	personal	\N	2024-03-27 19:40:48	2024-03-27 19:40:48
2ed9c9cb-0bd3-46a6-82cf-87e99d4e7ad7	9YCJN1	personal	\N	2024-04-04 10:26:56	2024-04-04 10:26:56
7355b691-53d9-4dc5-9d43-59f3b385df74	9Z28X9	personal	\N	2023-11-15 07:49:26	2023-11-15 07:49:26
dae9be5f-69f8-4aba-8707-3974bd4edf02	A038X9	personal	\N	2023-11-23 08:15:37	2023-11-23 08:15:37
b998f6fd-4ed6-46ac-a68a-cac842099b5a	A0RO98	personal	\N	2024-05-02 09:07:43	2024-05-02 09:07:43
82de6c86-64f8-4b2f-afb3-ad42f3064102	A0SA8D	personal	\N	2023-11-28 01:27:23	2023-11-28 01:27:23
bf4f88b0-08dd-4610-a308-ddae20ba3145	A22MY4	personal	\N	2024-05-24 16:33:32	2024-05-24 16:33:32
830c23fa-1016-476d-8347-b2b05cd6be87	A438X9	personal	\N	2024-02-07 02:03:14	2024-02-07 02:03:14
a3e95b73-8f3f-4c26-9329-0030b4d7e6ac	A5DJN1	personal	\N	2024-07-09 20:02:41	2024-07-09 20:02:41
7149cedf-42b3-431a-8fd2-6b8befe93ab8	A5RO98	personal	\N	2024-07-11 00:21:40	2024-07-11 00:21:40
9c92bc5d-6c5d-44b4-bccc-0777b53f8375	A6RO98	personal	\N	2024-07-13 00:56:34	2024-07-13 00:56:34
0be61f9f-48a0-4eb2-a29f-20570853f897	A72MY4	personal	\N	2024-07-15 00:18:16	2024-07-15 00:18:16
210a9901-8835-41bd-aadb-ed18e76d9d97	A9RO98	personal	\N	2024-08-08 10:52:17	2024-08-08 10:52:17
4fb8ef2e-0a55-4446-83bb-3f96c368ffc0	AASA8D	personal	\N	2024-03-15 01:01:16	2024-03-15 01:01:16
34fdef87-6228-4d2b-a960-4d5a5f83a95d	ACDJN1	personal	\N	2024-08-14 15:54:37	2024-08-14 15:54:37
8856e0ff-c7de-4041-96e8-eede99a277b9	ADP2B3	personal	\N	2024-03-25 13:17:02	2024-03-25 13:17:02
8afbe459-f864-4ad6-98b5-595ac422f0ef	AE2MY4	personal	\N	2024-10-23 23:41:09	2024-10-23 23:41:09
b2051624-b263-45a8-b36b-85db9da54ff0	AFP2B3	personal	\N	2024-04-02 05:08:19	2024-04-02 05:08:19
bf0d2a55-ea51-4de8-bdfb-0e13d2fee800	AFSA8D	personal	\N	2024-04-06 00:33:50	2024-04-06 00:33:50
946e0c57-e74d-4a77-85ce-b2ab9d74b6d2	AGE5M6	personal	\N	2024-04-06 06:46:59	2024-04-06 06:46:59
fe1ca68a-12fc-473f-a491-7696b62f7e9b	AGP2B3	personal	\N	2024-04-05 03:13:39	2024-04-05 03:13:39
13de37b2-470c-4277-8b22-b40bbb026a2a	AI4UVE	personal	\N	2023-11-30 01:47:33	2023-11-30 01:47:33
890364f4-9e20-4be5-b182-2ad4498aef48	AIP2B3	personal	\N	2024-04-17 12:46:48	2024-04-17 12:46:48
a3843ca1-aaea-4040-8614-027c758ccea4	AJ38X9	personal	\N	2024-05-17 01:31:02	2024-05-17 01:31:02
f7578885-4640-41c2-9831-c994c131ab57	AJQO98	personal	\N	2023-12-01 03:19:52	2023-12-01 03:19:52
fd456fdf-cc68-4051-be0f-dd1c23981917	AL38X9	personal	\N	2024-06-27 12:39:19	2024-06-27 12:39:19
ac2d044e-0c82-4e7c-bc7f-2781191a1148	AMCJN1	personal	\N	2024-01-25 07:19:00	2024-01-25 07:19:00
d614d130-f62e-4287-81a6-0ab916262663	AMQO98	personal	\N	2024-02-05 05:49:17	2024-02-05 05:49:17
7300c705-c2ec-4f87-89ed-734a49a40fe6	AN38X9	personal	\N	2024-07-11 17:02:30	2024-07-11 17:02:30
617a831e-8f9f-4527-bb02-6baf91314c3d	ANE5M6	personal	\N	2024-07-10 15:49:43	2024-07-10 15:49:43
4bb9ec3b-9a6c-4f55-bd4f-0b8940579b8c	ANFRKB	personal	\N	2024-02-18 04:37:32	2024-02-18 04:37:32
4515a665-4709-41be-a6dd-c4dd53adce8d	AOE5M6	personal	\N	2024-07-12 07:09:23	2024-07-12 07:09:23
727b3c2e-6079-4ed4-9cb7-adcd6d11437d	APCJN1	personal	\N	2024-02-19 16:23:16	2024-02-19 16:23:16
4fa50c02-239d-4274-b782-0286c6a1b05b	AQ1MY4	personal	\N	2024-02-21 06:10:18	2024-02-21 06:10:18
63d512ee-b850-4993-b486-e5494d188bfe	ARQO98	personal	\N	2024-03-12 12:20:43	2024-03-12 12:20:43
51b5e313-27c4-4de7-a47c-c55d12bd6026	ASQO98	personal	\N	2024-03-14 04:56:57	2024-03-14 04:56:57
dbc18365-0064-48a1-a511-f11f56929643	AT1MY4	personal	\N	2024-03-14 16:37:18	2024-03-14 16:37:18
0ff90b8d-2766-423f-aee7-0393dae688ea	ATQO98	personal	\N	2024-03-15 10:27:33	2024-03-15 10:27:33
246bd525-6ab8-4766-a444-5a12f32337a9	AWQO98	personal	\N	2024-04-01 07:46:35	2024-04-01 07:46:35
8fd92c37-ee30-48c5-9758-5b27c3768deb	B0E5M6	personal	\N	2023-11-21 03:18:56	2023-11-21 03:18:56
f0688a26-bcd7-4d47-9ac4-f9c05b47cdde	B0GRKB	personal	\N	2024-05-10 02:52:48	2024-05-10 02:52:48
1df4b9a3-7fec-4bdd-9317-f40c99cade8d	B15UVE	personal	\N	2024-05-30 16:41:05	2024-05-30 16:41:05
7c49b3b7-762b-44b4-a1b5-ffb7d085a3e5	B45UVE	personal	\N	2024-07-10 23:17:02	2024-07-10 23:17:02
e02e32d3-b777-4e0b-9c7e-fd4c35be9267	B52MY4	personal	\N	2024-07-10 02:37:52	2024-07-10 02:37:52
8e6f19f2-1010-40c2-8765-1d47a0aa9196	B55UVE	personal	\N	2024-07-12 17:46:00	2024-07-12 17:46:00
817bd3fb-eb92-4752-b9c9-780a66474368	B5GRKB	personal	\N	2024-07-12 00:41:20	2024-07-12 00:41:20
8f2abc6e-f4cf-4ce0-81fe-6a326079d556	B5P2B3	personal	\N	2024-02-08 01:01:03	2024-02-08 01:01:03
d19b3f0d-9201-4cbc-b486-ca3054e0b451	B7SA8D	personal	\N	2024-02-21 06:11:09	2024-02-21 06:11:09
7ca8a1c9-053c-4830-a060-862ff380a2f1	B8DJN1	personal	\N	2024-07-16 11:11:22	2024-07-16 11:11:22
3a4ff768-8762-4a98-9de0-7aaed0362ce8	B8GRKB	personal	\N	2024-07-29 06:26:35	2024-07-29 06:26:35
83230c8c-2343-49e8-ba3f-e588ffb60782	BAGRKB	personal	\N	2024-08-13 09:50:26	2024-08-13 09:50:26
ff67e398-623d-4a7e-aee6-719ac1bbf4bf	BCRO98	personal	\N	2024-08-22 15:45:18	2024-08-22 15:45:18
cd1edaaf-56a3-43c2-83cc-9510f24cf144	BE2MY4	personal	\N	2024-10-24 14:49:02	2024-10-24 14:49:02
9d4f15b4-86da-4f81-b58e-cab8c435585c	BEGRKB	personal	\N	2024-11-27 23:50:03	2024-11-27 23:50:03
0aacec3a-b800-4a9e-ac3d-fbf4545c0f61	BG38X9	personal	\N	2024-04-14 13:48:19	2024-04-14 13:48:19
16a4ccff-4739-402d-b675-67fafdda2151	BG4UVE	personal	\N	2023-11-14 05:18:47	2023-11-14 05:18:47
9895ba06-7ac4-44a6-987d-6595615801f3	BH38X9	personal	\N	2024-04-16 13:06:56	2024-04-16 13:06:56
0eef1f5e-5b27-4983-a01d-f0c19b49818b	BH4UVE	personal	\N	2023-11-22 04:26:41	2023-11-22 04:26:41
1349490b-955e-4a0b-b00b-c392d1cb71c1	BHSA8D	personal	\N	2024-04-18 10:45:09	2024-04-18 10:45:09
339b8bf1-7cb8-4726-9ccd-f76faf83482d	BI4UVE	personal	\N	2023-11-30 02:27:41	2023-11-30 02:27:41
acc124f7-2136-4576-a39c-42a22fbbbd06	BJFRKB	personal	\N	2023-12-04 08:27:32	2023-12-04 08:27:32
f28e22f0-069f-442c-9e3d-1ab5350a3027	BKCJN1	personal	\N	2023-12-02 05:56:23	2023-12-02 05:56:23
abfbdf7e-6cb4-4977-82ef-93211e950a6c	BKQO98	personal	\N	2023-12-20 10:59:01	2023-12-20 10:59:01
76437582-061c-4b94-9873-a4e3b6b8c787	BLCJN1	personal	\N	2023-12-21 13:36:12	2023-12-21 13:36:12
2c161160-a3de-4af8-b178-11700da1ed54	BNE5M6	personal	\N	2024-07-10 15:55:29	2024-07-10 15:55:29
8c0274e5-b377-42ed-929d-87871c50489d	BNP2B3	personal	\N	2024-07-09 21:21:47	2024-07-09 21:21:47
d99d51b7-3349-4bf6-8803-618705c95d2d	BPP2B3	personal	\N	2024-07-14 08:04:41	2024-07-14 08:04:41
1b1e779a-c471-4d50-a46d-8a5d67dd0bdb	BQSA8D	personal	\N	2024-07-30 14:32:34	2024-07-30 14:32:34
d5aff77a-b44b-4f61-99e5-be983adc7bb0	BR1MY4	personal	\N	2024-03-08 14:29:53	2024-03-08 14:29:53
0cab1976-8937-46ee-8a8d-9e3d831d258b	BRCJN1	personal	\N	2024-02-26 11:31:06	2024-02-26 11:31:06
cc0ae9ae-8913-4d10-84b7-c9694a226a23	BRSA8D	personal	\N	2024-08-09 16:20:25	2024-08-09 16:20:25
c886ab44-06fb-4910-a511-0f01b9ad22d2	BSP2B3	personal	\N	2024-08-08 18:19:54	2024-08-08 18:19:54
367bed25-7d4b-47fd-a06a-e2e52c7935d7	BTE5M6	personal	\N	2024-08-14 11:25:08	2024-08-14 11:25:08
5ddcc4e4-ee30-48b1-939a-09439b14e6dd	BV38X9	personal	\N	2024-10-15 19:24:15	2024-10-15 19:24:15
5ceefda3-21ca-41e9-8280-66b5b8805e4a	BVQO98	personal	\N	2024-03-26 11:25:40	2024-03-26 11:25:40
36fa3c27-a0c6-4407-a386-a0b57cbbd453	C038X9	personal	\N	2023-11-23 08:15:38	2023-11-23 08:15:38
b651ec49-f0b6-40b6-87b9-af90f919e1c0	C138X9	personal	\N	2023-12-02 10:25:21	2023-12-02 10:25:21
a9a3eae9-470b-4e07-ac58-37a0d62d0ada	C2E5M6	personal	\N	2023-12-13 07:44:09	2023-12-13 07:44:09
59466279-f98e-4421-b2b8-9c1d41fb2e2c	C3E5M6	personal	\N	2024-01-13 03:19:46	2024-01-13 03:19:46
1bd86dd9-872f-4a68-8602-a60813df56c8	C3RO98	personal	\N	2024-06-26 09:51:08	2024-06-26 09:51:08
704659f3-e212-472b-951d-80c1d942b506	C4E5M6	personal	\N	2024-02-05 02:42:04	2024-02-05 02:42:04
11268002-f611-4176-a889-ce915ecec81e	C4P2B3	personal	\N	2024-02-02 22:30:50	2024-02-02 22:30:50
eca91a2a-4cb5-4984-b0f8-f4c4b1393bd3	C5GRKB	personal	\N	2024-07-12 00:55:14	2024-07-12 00:55:14
1930e4d2-242f-4c7d-87aa-66db6371395b	C5SA8D	personal	\N	2024-02-19 13:16:48	2024-02-19 13:16:48
4bf3bdbe-77dd-4ba7-8428-ad1dc336341b	C6E5M6	personal	\N	2024-02-19 14:15:48	2024-02-19 14:15:48
39abb322-c9b3-4363-9d47-9d7f14f50069	C6GRKB	personal	\N	2024-07-14 18:19:24	2024-07-14 18:19:24
60aaec3d-f58b-40c4-8ecc-f12c307faf17	C6P2B3	personal	\N	2024-02-18 03:11:46	2024-02-18 03:11:46
96df6d8a-d5e1-44f8-8332-85d90241802c	C838X9	personal	\N	2024-02-28 11:42:30	2024-02-28 11:42:30
12f68791-85a0-41c8-8b5d-e80943e321da	C8P2B3	personal	\N	2024-02-21 02:15:22	2024-02-21 02:15:22
c7471f0d-87d3-4472-a445-71e388484616	C938X9	personal	\N	2024-03-12 23:21:07	2024-03-12 23:21:07
f87ac2f9-5d43-4888-ba23-3270703badb1	CA38X9	personal	\N	2024-03-14 11:39:54	2024-03-14 11:39:54
c9886487-7637-42c7-a3df-7d5d1d30b015	CARO98	personal	\N	2024-08-11 06:04:00	2024-08-11 06:04:00
240c21d8-d5d1-42d7-9b06-16552be15644	CASA8D	personal	\N	2024-03-15 02:20:13	2024-03-15 02:20:13
8b78b3ad-31c6-49d5-9cd1-a393f82c0614	CBE5M6	personal	\N	2024-03-15 05:08:14	2024-03-15 05:08:14
d76592e5-a0c2-4e04-bca6-34e3d9995fce	CBP2B3	personal	\N	2024-03-14 12:38:58	2024-03-14 12:38:58
52b4f42b-1bc5-4cb9-bde2-26605e554a76	CBRO98	personal	\N	2024-08-14 15:20:44	2024-08-14 15:20:44
e17b751b-e6d9-4d8e-a7ce-fda5ef0ff335	CCDJN1	personal	\N	2024-08-14 17:30:10	2024-08-14 17:30:10
ee975d9a-24ad-4738-820e-d2537dfa7cbb	CD38X9	personal	\N	2024-03-26 16:49:30	2024-03-26 16:49:30
9817164d-7f82-4ed9-9eed-a673787526f4	CE5UVE	personal	\N	2024-12-22 01:17:47	2024-12-22 01:17:47
c49b0596-f8b6-4749-9035-4cfe7084d1b1	CHP2B3	personal	\N	2024-04-14 19:59:10	2024-04-14 19:59:10
998a1f5c-0ce8-43d0-addb-c6861ab126d9	CKP2B3	personal	\N	2024-05-23 02:35:54	2024-05-23 02:35:54
78587ca2-7caf-4b23-a0b0-16abff115c30	CL1MY4	personal	\N	2024-01-06 01:18:48	2024-01-06 01:18:48
542bdd52-5eef-4759-886d-07722fa1a238	CLE5M6	personal	\N	2024-06-18 15:19:24	2024-06-18 15:19:24
66324a2e-a1aa-41ae-ad82-1e3edb50b082	CLFRKB	personal	\N	2024-02-03 16:15:08	2024-02-03 16:15:08
ed9ea43b-502e-48a1-9d78-a882438df6f1	CN1MY4	personal	\N	2024-02-17 03:36:06	2024-02-17 03:36:06
9b469951-6910-4583-a6c1-e7954bb8a5d4	CNQO98	personal	\N	2024-02-17 15:13:58	2024-02-17 15:13:58
e6038c5d-fa9f-4174-b01f-146a496ee2a8	CO4UVE	personal	\N	2024-02-20 10:03:44	2024-02-20 10:03:44
c75d3de2-68b2-41b1-ad03-687393e3eca1	COSA8D	personal	\N	2024-07-15 04:50:50	2024-07-15 04:50:50
60818018-80a8-4879-94cd-05672c26f7b6	CP4UVE	personal	\N	2024-02-22 05:44:03	2024-02-22 05:44:03
3ca31072-51c5-470e-9381-7578ad758c41	CQP2B3	personal	\N	2024-07-18 09:01:05	2024-07-18 09:01:05
e66b04bb-a3a2-47f8-8857-b3030aaf3285	CQSA8D	personal	\N	2024-07-30 14:36:46	2024-07-30 14:36:46
dd01f65c-2ba8-4827-8dc5-093986853500	CRFRKB	personal	\N	2024-03-13 07:25:32	2024-03-13 07:25:32
2e2f3722-f5cf-4187-8ef0-b5bcdf3c0e0a	CUCJN1	personal	\N	2024-03-16 03:02:32	2024-03-16 03:02:32
fdc0fa75-740c-47b1-b6ba-20addb267e43	CV1MY4	personal	\N	2024-03-26 01:37:38	2024-03-26 01:37:38
e9524a49-eda8-4d75-9863-9f6a1cf1c0dd	CVFRKB	personal	\N	2024-03-28 04:49:41	2024-03-28 04:49:41
14c41bb4-2aef-4491-b933-c4fb8ce2f4a5	CVP2B3	personal	\N	2024-09-07 02:11:12	2024-09-07 02:11:12
64c2f16b-2398-4102-a8db-bb61bd127f67	CXQO98	personal	\N	2024-04-04 09:46:25	2024-04-04 09:46:25
6895b079-41da-4c80-9b03-a13205bca38d	CY4UVE	personal	\N	2024-04-16 02:46:30	2024-04-16 02:46:30
537a94cd-158f-4aea-a4bb-83ff68cbde6c	D0DJN1	personal	\N	2024-04-16 12:37:46	2024-04-16 12:37:46
ea90f8aa-b2ea-4657-aa7a-f82f583a1980	D1SA8D	personal	\N	2023-12-12 03:49:50	2023-12-12 03:49:50
44a938f5-b9c0-4e10-aab1-bbabd979710e	D2E5M6	personal	\N	2023-12-13 23:59:44	2023-12-13 23:59:44
77b00ba8-03f1-4834-9821-f15d033951a1	D2GRKB	personal	\N	2024-06-13 03:22:43	2024-06-13 03:22:43
c6872d71-bd61-4a1a-bcdb-ba79f37b1283	D3P2B3	personal	\N	2023-12-30 01:40:33	2023-12-30 01:40:33
287c5e40-a285-4115-a559-f0f4d06b16fd	D5E5M6	personal	\N	2024-02-17 07:25:06	2024-02-17 07:25:06
688d0ae3-2734-46f8-94ba-26314aeec7c9	D6P2B3	personal	\N	2024-02-18 04:24:39	2024-02-18 04:24:39
39994d24-98f0-4705-a971-da939a806643	D82MY4	personal	\N	2024-07-24 14:00:40	2024-07-24 14:00:40
f15526e3-6f68-4ccc-9e5e-7bafdb1526c6	DAE5M6	personal	\N	2024-03-14 00:46:10	2024-03-14 00:46:10
04a73285-3f3c-433f-917d-15f913b0737a	DBSA8D	personal	\N	2024-03-22 06:50:53	2024-03-22 06:50:53
5aece801-aa7a-4248-8559-2e6c73eda3e3	DCSA8D	personal	\N	2024-03-26 05:18:50	2024-03-26 05:18:50
9ad52132-dccb-4d28-99f4-42741d965f04	DE38X9	personal	\N	2024-04-02 04:58:04	2024-04-02 04:58:04
22ac90d8-e3f8-48ac-b700-dff689d9d990	DFSA8D	personal	\N	2024-04-06 06:21:51	2024-04-06 06:21:51
253f99af-df47-4dac-a786-bee047c48dfe	DGE5M6	personal	\N	2024-04-12 12:31:11	2024-04-12 12:31:11
8aad06a4-5b48-41bf-8bff-e965cd620dc2	DIE5M6	personal	\N	2024-04-25 12:27:10	2024-04-25 12:27:10
bf567e86-edbc-46a9-9509-78e72000e29d	DIP2B3	personal	\N	2024-04-17 12:51:47	2024-04-17 12:51:47
33623ecd-ba1c-4a03-bae0-ea896db1c904	DJ38X9	personal	\N	2024-05-17 11:14:02	2024-05-17 11:14:02
fb06de97-b722-4281-99cf-482d421bd4b0	DJCJN1	personal	\N	2023-11-23 08:15:37	2023-11-23 08:15:37
4bd2dff5-6f63-4ad3-a9ee-61219df00045	DK1MY4	personal	\N	2023-12-07 09:16:11	2023-12-07 09:16:11
d105f237-9c73-48d7-916c-20a8e1171fb5	DL38X9	personal	\N	2024-06-28 09:43:11	2024-06-28 09:43:11
e0644fd2-b5df-49ef-a9b4-3a887f2d086e	DM1MY4	personal	\N	2024-02-04 01:55:06	2024-02-04 01:55:06
d0a3e885-59f6-435d-957e-512de31ecfbc	DOE5M6	personal	\N	2024-07-12 16:53:08	2024-07-12 16:53:08
6a02feec-a567-4aa4-b13d-31e30f98d102	DQ4UVE	personal	\N	2024-03-12 12:03:19	2024-03-12 12:03:19
47ca2d7a-cd70-4627-967b-88d22c0ef0bd	DQFRKB	personal	\N	2024-03-07 13:33:44	2024-03-07 13:33:44
8490695f-9b65-4b5a-b9ee-2a0987b921dd	DS1MY4	personal	\N	2024-03-13 10:59:35	2024-03-13 10:59:35
19b58357-a8f1-4f20-9b93-30581c8b43db	DSCJN1	personal	\N	2024-03-12 22:42:03	2024-03-12 22:42:03
548a7799-4a3e-4b13-862f-e89c8538f074	DUCJN1	personal	\N	2024-03-17 02:31:35	2024-03-17 02:31:35
4984de33-b164-4eba-82be-5383f76252c8	DVP2B3	personal	\N	2024-09-09 01:57:28	2024-09-09 01:57:28
62a97dc2-70c3-41bd-a031-eaf9613a0b7d	DY4UVE	personal	\N	2024-04-16 04:01:12	2024-04-16 04:01:12
c76b8982-13ee-4788-9bb6-e22eac0520cf	DYQO98	personal	\N	2024-04-14 08:59:31	2024-04-14 08:59:31
da858fc6-d2bd-43ca-99cc-671e825ad02b	E05UVE	personal	\N	2024-05-15 10:37:26	2024-05-15 10:37:26
75bc07bb-6b7a-4414-b064-9f0f7c086217	E0P2B3	personal	\N	2023-11-16 04:48:09	2023-11-16 04:48:09
45f81bc7-ff24-498d-9104-18da7e5643f8	E1P2B3	personal	\N	2023-11-23 08:26:34	2023-11-23 08:26:34
5a5671ae-271c-498e-8103-a7407d08f60c	E22MY4	personal	\N	2024-05-26 00:32:05	2024-05-26 00:32:05
4e2bc8e4-d7fa-4757-adec-22c5c62d9b69	E438X9	personal	\N	2024-02-08 00:06:36	2024-02-08 00:06:36
3d48d78c-ceec-4c0a-aab6-9fc35fdb8e4c	E5GRKB	personal	\N	2024-07-12 01:32:37	2024-07-12 01:32:37
b93cd121-1d2c-4c9f-9f1c-ea09efc255df	E6SA8D	personal	\N	2024-02-20 09:26:29	2024-02-20 09:26:29
fb0a3dad-09fa-4000-95c2-b3e6cc393443	E738X9	personal	\N	2024-02-21 00:26:39	2024-02-21 00:26:39
ff1e3517-5b3d-4801-bbea-3c868bf28838	E838X9	personal	\N	2024-03-02 07:51:53	2024-03-02 07:51:53
76658434-c22a-411a-94a7-102a7c292c5f	E8GRKB	personal	\N	2024-07-29 09:02:10	2024-07-29 09:02:10
daa364dc-ab58-4b1b-bc82-30a29144d0ee	E8RO98	personal	\N	2024-07-28 03:55:27	2024-07-28 03:55:27
51b50b3e-2e90-4281-8756-19f3d938bbe9	E9GRKB	personal	\N	2024-08-09 04:36:45	2024-08-09 04:36:45
8ddb0cc7-ad84-4aab-91dc-a0006a4af4d3	EADJN1	personal	\N	2024-08-08 12:33:47	2024-08-08 12:33:47
715c92b8-d680-4c85-910b-5b2ff965ead9	EBGRKB	personal	\N	2024-08-15 03:36:37	2024-08-15 03:36:37
838a9ef3-af3e-4655-99b5-a06134155c07	EC5UVE	personal	\N	2024-10-03 10:16:30	2024-10-03 10:16:30
aed87ec2-821a-4b30-9f4f-49bca8ff5f92	ECDJN1	personal	\N	2024-08-14 17:42:09	2024-08-14 17:42:09
3ca66b4a-ee1c-4acf-a29f-a1159457772a	ED2MY4	personal	\N	2024-09-26 08:16:32	2024-09-26 08:16:32
c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	EG4UVE	personal	\N	2023-11-14 12:39:54	2023-11-14 12:39:54
8b9c80e4-3072-4dab-85a6-36e310fae6ef	EH1MY4	personal	\N	2023-11-11 01:05:03	2023-11-11 01:05:03
706ae8d3-4398-4f3a-b0c4-d2476d6e9d97	EHSA8D	personal	\N	2024-04-21 09:41:24	2024-04-21 09:41:24
0da6fe92-db44-40da-854c-a84be86ab8d4	EIQO98	personal	\N	2023-11-23 08:15:33	2023-11-23 08:15:33
6c50a910-149e-4247-af57-91342ca69c26	EKQO98	personal	\N	2023-12-21 10:00:13	2023-12-21 10:00:13
0e34eecd-4f6c-47b9-8262-d2dfcf951591	ELE5M6	personal	\N	2024-06-20 09:07:25	2024-06-20 09:07:25
67c41f98-232b-4c1a-ba47-348bc540c17a	EO4UVE	personal	\N	2024-02-20 10:33:14	2024-02-20 10:33:14
6f1649d4-1831-4622-bcf9-871796d1d7a4	EOP2B3	personal	\N	2024-07-12 00:21:14	2024-07-12 00:21:14
aa86b50d-7530-4b11-a276-8f80f2a30a90	EOSA8D	personal	\N	2024-07-15 12:04:36	2024-07-15 12:04:36
9f220330-cbca-4a77-83da-46c86400d830	EPP2B3	personal	\N	2024-07-14 16:38:19	2024-07-14 16:38:19
d31ebfd1-5791-4738-b730-030aa46def6e	ET4UVE	personal	\N	2024-03-25 05:42:56	2024-03-25 05:42:56
5e837acd-dae2-4186-b57c-ae70ee945f8a	EU1MY4	personal	\N	2024-03-21 13:55:15	2024-03-21 13:55:15
19401818-3291-4aa4-b2d2-97d3b5f0e66f	EVFRKB	personal	\N	2024-03-28 08:34:23	2024-03-28 08:34:23
f404a098-91e6-4b18-a6c8-280913485d8b	EWCJN1	personal	\N	2024-03-26 14:38:42	2024-03-26 14:38:42
29a63532-c5b1-4ebb-bba4-9a22abdd986c	EYRA8D	personal	\N	2023-11-13 01:25:04	2023-11-13 01:25:04
1a25e573-3158-4107-bc5b-765cdd926261	F0GRKB	personal	\N	2024-05-10 08:00:44	2024-05-10 08:00:44
8394f0f8-6480-43c1-8c9f-754b85761d11	F2GRKB	personal	\N	2024-06-15 09:53:27	2024-06-15 09:53:27
4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	F3P2B3	personal	\N	2024-01-03 00:53:45	2024-01-03 00:53:45
7feeba3f-2de6-461e-822c-e5732fa9d2e6	F538X9	personal	\N	2024-02-18 01:14:19	2024-02-18 01:14:19
887a9751-922b-4b58-8e4e-80e1f069afbe	F6SA8D	personal	\N	2024-02-20 09:26:36	2024-02-20 09:26:36
ac8046ab-5699-4eda-bde8-056ccc1dcda0	F7SA8D	personal	\N	2024-02-21 12:18:24	2024-02-21 12:18:24
50ae2328-6330-4c0a-a72e-bd92ef0d2641	F9E5M6	personal	\N	2024-03-12 11:24:40	2024-03-12 11:24:40
5d5ec654-51a2-4f87-bd39-c56d358f6ea5	FF38X9	personal	\N	2024-04-05 03:40:34	2024-04-05 03:40:34
c91353ba-030d-4d42-a163-fa9ee189d917	FFE5M6	personal	\N	2024-04-04 01:37:58	2024-04-04 01:37:58
caaa99ed-82ec-4986-9a0d-f9de1306e0d5	FI4UVE	personal	\N	2023-12-01 07:57:50	2023-12-01 07:57:50
a6138b49-27ca-485f-ad57-12f6ed08e94b	FJCJN1	personal	\N	2023-11-23 08:15:37	2023-11-23 08:15:37
0cca947b-5a4f-4b4a-ac4e-8ecfae6589e0	FKCJN1	personal	\N	2023-12-02 08:51:37	2023-12-02 08:51:37
2ddcfb31-7ace-442b-9cf9-eb1966e09627	FLQO98	personal	\N	2024-01-25 07:19:22	2024-01-25 07:19:22
1435e589-852b-424c-afa4-31163a82a769	FN4UVE	personal	\N	2024-02-19 15:54:10	2024-02-19 15:54:10
a0d0d478-0dd1-412d-9903-820dc812be22	FNSA8D	personal	\N	2024-07-12 12:06:28	2024-07-12 12:06:28
aaad74f2-28d8-4410-b437-8c9c954a45bf	FO1MY4	personal	\N	2024-02-19 13:15:31	2024-02-19 13:15:31
44e02678-3c6c-4042-b9f8-d0738d1b9553	FPSA8D	personal	\N	2024-07-26 19:56:09	2024-07-26 19:56:09
ba315088-cb20-4a99-b6e2-162225ab4a35	FQCJN1	personal	\N	2024-02-20 13:20:13	2024-02-20 13:20:13
e07fb836-054b-44c4-8090-0710d44cc814	FSQO98	personal	\N	2024-03-14 09:31:21	2024-03-14 09:31:21
e1d0121d-7fc5-424b-860e-065f92776ca1	FT1MY4	personal	\N	2024-03-15 01:21:05	2024-03-15 01:21:05
9079e6fb-d198-4c34-a483-39df60af375b	FWE5M6	personal	\N	2024-11-06 09:14:33	2024-11-06 09:14:33
592bf59f-0513-4bb9-8818-ac48970b4b6e	FXE5M6	personal	\N	2024-12-20 09:24:21	2024-12-20 09:24:21
776d6525-d0bd-48e9-9995-f172fc49ec31	FYCJN1	personal	\N	2024-04-05 01:06:15	2024-04-05 01:06:15
8f774139-39cf-4e29-84ac-03932c25fa2a	FYFRKB	personal	\N	2024-04-15 02:06:58	2024-04-15 02:06:58
970b7537-600d-48b8-8399-61109c8f4bd9	G05UVE	personal	\N	2024-05-16 00:55:14	2024-05-16 00:55:14
0be157db-7f72-4e13-9c10-5b3a30bebd76	G0E5M6	personal	\N	2023-11-22 23:26:01	2023-11-22 23:26:01
08be9267-2a38-4ed5-ad50-cfae7445bcbd	G4E5M6	personal	\N	2024-02-05 04:55:53	2024-02-05 04:55:53
b0bfeeb8-82f2-4e3a-aaf6-5cc8522608b2	G4SA8D	personal	\N	2024-02-17 07:21:12	2024-02-17 07:21:12
06f0664f-6f2c-4ade-94b1-19082306bd91	G6RO98	personal	\N	2024-07-13 17:38:59	2024-07-13 17:38:59
d05bf38b-f898-4dfc-adcc-dce47a90a1c7	G938X9	personal	\N	2024-03-13 00:41:43	2024-03-13 00:41:43
c67c54ba-658d-4a1b-85de-9efedcd8177d	G9E5M6	personal	\N	2024-03-12 11:29:55	2024-03-12 11:29:55
a85cd4c1-6778-48f8-b5bf-ad552e883dea	G9RO98	personal	\N	2024-08-08 11:58:03	2024-08-08 11:58:03
cbb8fed9-d001-4cee-8109-bf79977e0b94	GARO98	personal	\N	2024-08-11 16:26:45	2024-08-11 16:26:45
dac79653-0b53-423e-bdbd-97d87cadddf0	GB2MY4	personal	\N	2024-08-14 08:24:21	2024-08-14 08:24:21
d4ba84a7-6215-4ccc-937b-95bdd1eb343f	GCRO98	personal	\N	2024-08-26 06:36:59	2024-08-26 06:36:59
1fc5df4c-5ca6-44aa-b3ab-fb93987f7b9b	GEDJN1	personal	\N	2024-10-15 20:13:57	2024-10-15 20:13:57
d20a6a07-b621-4dd3-a202-78ac56696c2c	GEE5M6	personal	\N	2024-04-01 07:04:13	2024-04-01 07:04:13
dce58864-805f-47bb-a513-11ba3bb8838a	GEGRKB	personal	\N	2024-12-05 05:34:56	2024-12-05 05:34:56
55ca4efa-c0ae-4e3a-acad-adc0c644a31b	GFE5M6	personal	\N	2024-04-04 04:37:18	2024-04-04 04:37:18
12f8683d-d1eb-4e71-b60f-75df4e0f8169	GH38X9	personal	\N	2024-04-17 12:50:50	2024-04-17 12:50:50
7b2f0abe-21ce-4e1a-8e33-477b2c27b5ce	GL4UVE	personal	\N	2024-02-06 02:10:49	2024-02-06 02:10:49
383d76af-4c95-4cb2-b6ee-fd0bb315bdb4	GN4UVE	personal	\N	2024-02-19 15:56:56	2024-02-19 15:56:56
6cd9336a-3ad9-4d46-bdd2-d52cdce84b86	GO38X9	personal	\N	2024-07-14 08:43:39	2024-07-14 08:43:39
b3d18ee7-428d-4c05-8795-c0fe0a3326be	GOSA8D	personal	\N	2024-07-15 14:35:33	2024-07-15 14:35:33
db049daa-59cb-425e-bdd9-c6dbbdff5b95	GPFRKB	personal	\N	2024-02-21 06:10:20	2024-02-21 06:10:20
4cfae84c-7149-411f-ac09-16c7f3b0b493	GQ38X9	personal	\N	2024-07-28 19:04:07	2024-07-28 19:04:07
4c86e0dc-5ca2-4327-a294-af62bed6e4c1	GQ4UVE	personal	\N	2024-03-12 15:34:18	2024-03-12 15:34:18
aeeed118-2388-4e70-b845-66f35dfc3256	GQE5M6	personal	\N	2024-07-27 21:59:04	2024-07-27 21:59:04
6cf02dfe-843d-4bb8-b393-e33f9eeff928	GRQO98	personal	\N	2024-03-12 21:27:09	2024-03-12 21:27:09
e67cf957-5c57-4a9c-bd51-fed02354ff82	GSE5M6	personal	\N	2024-08-10 16:56:13	2024-08-10 16:56:13
983918ad-2a80-4cd2-8614-3aaae25ad3a2	GTP2B3	personal	\N	2024-08-13 10:50:10	2024-08-13 10:50:10
b6122109-a6b7-4e62-a6b8-46db81b929c4	GU4UVE	personal	\N	2024-03-26 11:53:19	2024-03-26 11:53:19
0662c401-d3f6-4040-aec4-44a2466e67af	GUQO98	personal	\N	2024-03-25 11:38:07	2024-03-25 11:38:07
1595e4da-60d8-4646-8dcc-c761e435937e	GWE5M6	personal	\N	2024-11-07 01:25:31	2024-11-07 01:25:31
29e8608e-1d49-47ce-8468-a237811b9d24	GWFRKB	personal	\N	2024-04-03 02:54:45	2024-04-03 02:54:45
1961bd1d-af72-44a9-b760-15fcd9db7ab7	GWP2B3	personal	\N	2024-10-23 19:07:03	2024-10-23 19:07:03
f2c5ae55-0e05-4127-b286-efc6fb88b4a1	GZ28X9	personal	\N	2023-11-15 23:25:31	2023-11-15 23:25:31
fc57deea-20e3-4959-bb07-ce80c36b7a8c	H05UVE	personal	\N	2024-05-16 03:47:56	2024-05-16 03:47:56
608e2678-408c-4ad1-80fb-3a8e0e9a2c76	H1RO98	personal	\N	2024-05-17 01:05:05	2024-05-17 01:05:05
8fde015e-4210-4d98-b67e-2d5fcf03db53	H2E5M6	personal	\N	2023-12-17 13:25:14	2023-12-17 13:25:14
5001b2bc-0e2a-4026-b3d7-94e5d7bbdab8	H2GRKB	personal	\N	2024-06-15 10:35:43	2024-06-15 10:35:43
37957796-b647-47d8-a0c5-3b148d5d2f2b	H5SA8D	personal	\N	2024-02-19 14:49:29	2024-02-19 14:49:29
c37e1291-15d7-44e2-8c96-da670d4734cf	H638X9	personal	\N	2024-02-20 07:04:41	2024-02-20 07:04:41
7ea84eca-fec2-409b-953d-9e41efd78a40	H8RO98	personal	\N	2024-07-28 12:46:59	2024-07-28 12:46:59
af769d09-6810-4b34-97b3-286b06c86198	H92MY4	personal	\N	2024-07-30 15:51:45	2024-07-30 15:51:45
540da448-1569-464c-9aab-b1045fd15a51	H95UVE	personal	\N	2024-08-11 06:27:48	2024-08-11 06:27:48
bd0e6889-da47-4249-980e-7ed8c3587ac2	H9DJN1	personal	\N	2024-07-28 16:22:56	2024-07-28 16:22:56
92fc9796-8ad9-4dde-bd4f-6144f73ed060	HAE5M6	personal	\N	2024-03-14 04:27:29	2024-03-14 04:27:29
7ac0b7d7-3b98-4439-89e7-79026ae3b3ad	HDRO98	personal	\N	2024-10-14 22:17:30	2024-10-14 22:17:30
731e8f75-6cb8-478c-8515-afa21cf3f4ba	HEGRKB	personal	\N	2024-12-05 09:29:11	2024-12-05 09:29:11
103f67a3-8bcc-42a4-9241-55b4f9ce56e5	HFP2B3	personal	\N	2024-04-02 15:41:02	2024-04-02 15:41:02
24647c2b-e507-4493-be9c-1e2b2dc7ccb2	HG4UVE	personal	\N	2023-11-15 01:39:00	2023-11-15 01:39:00
8185e5d2-086f-46f9-ada8-41b30cf263ab	HJ38X9	personal	\N	2024-05-24 11:26:41	2024-05-24 11:26:41
2982d8a2-76cd-4ef3-a223-bf7259540959	HKFRKB	personal	\N	2024-01-06 12:32:53	2024-01-06 12:32:53
ff42b26e-122c-4b16-b896-f06c990c2c01	HMCJN1	personal	\N	2024-01-30 11:53:01	2024-01-30 11:53:01
ea94574f-9324-4d8c-ab1b-2ad8efb7e981	HO1MY4	personal	\N	2024-02-19 13:40:07	2024-02-19 13:40:07
1a88ebc2-fa9e-4566-9043-3904425b19ea	HO38X9	personal	\N	2024-07-14 11:02:55	2024-07-14 11:02:55
1f4dc833-071a-418a-a7f0-efb9312c5e89	HOCJN1	personal	\N	2024-02-17 22:30:56	2024-02-17 22:30:56
8afc5a81-b308-4b4e-ae07-29ea138338f8	HPFRKB	personal	\N	2024-02-21 06:10:48	2024-02-21 06:10:48
8942549f-b2e0-468b-b043-7e1fc34b9a5c	HPP2B3	personal	\N	2024-07-14 18:31:29	2024-07-14 18:31:29
d65827ec-a8ea-46b3-ae9b-1aef0fe261fc	HR1MY4	personal	\N	2024-03-12 07:49:04	2024-03-12 07:49:04
cf6d3ef6-631e-43f5-8ed7-2554c4bc570e	HS4UVE	personal	\N	2024-03-15 10:31:12	2024-03-15 10:31:12
bd9d47bf-0c6a-41ef-8fa7-9924e9cc868d	HT4UVE	personal	\N	2024-03-25 07:25:47	2024-03-25 07:25:47
2e6c2402-b2ca-45d2-9624-b203350cf0f0	HTSA8D	personal	\N	2024-08-16 03:00:23	2024-08-16 03:00:23
3e284f6f-181a-4fee-9eaa-89cc745094aa	HUE5M6	personal	\N	2024-08-18 02:51:20	2024-08-18 02:51:20
f270fd28-1c02-46bf-ac9c-8179ed1185bb	HUSA8D	personal	\N	2024-10-01 03:51:37	2024-10-01 03:51:37
f9f38bd4-064d-4da8-921f-4c8530b77005	HZCJN1	personal	\N	2024-04-14 15:10:14	2024-04-14 15:10:14
eb43e2ff-e06f-48cd-9099-ed4c093f41ae	HZFRKB	personal	\N	2024-04-18 10:44:21	2024-04-18 10:44:21
348e8cdb-38a0-4d22-84e1-9f7d902b3f81	I1DJN1	personal	\N	2024-05-09 03:32:06	2024-05-09 03:32:06
ba7cf405-2477-4369-97ef-ed720e0686b6	I338X9	personal	\N	2024-02-03 01:46:40	2024-02-03 01:46:40
db3a29f6-ba7b-40d7-8ccb-49877086aa45	I4GRKB	personal	\N	2024-07-10 08:04:56	2024-07-10 08:04:56
18828b4e-e4bf-428d-b366-aacb608610c4	I5DJN1	personal	\N	2024-07-09 21:00:24	2024-07-09 21:00:24
6088208f-1f95-4519-8804-6892380ced11	I5SA8D	personal	\N	2024-02-19 14:51:55	2024-02-19 14:51:55
61570aba-9772-4b60-bff4-737a82f4af6a	I6DJN1	personal	\N	2024-07-11 17:29:28	2024-07-11 17:29:28
e0161890-fc0a-40a7-b14c-0bf1d40cf3d5	I7P2B3	personal	\N	2024-02-20 09:25:57	2024-02-20 09:25:57
769c8536-492d-4536-9736-cf780c9c564b	I82MY4	personal	\N	2024-07-26 16:40:26	2024-07-26 16:40:26
7af983b5-0536-4fad-8f6f-74367e165ef7	I838X9	personal	\N	2024-03-06 00:34:49	2024-03-06 00:34:49
4e42dde6-48d8-4cac-b453-269e3f06dab1	I8DJN1	personal	\N	2024-07-18 03:44:18	2024-07-18 03:44:18
7ee66328-1a83-40d2-abdb-25698ec114bc	I9DJN1	personal	\N	2024-07-28 16:27:44	2024-07-28 16:27:44
25efd5ea-8662-47ea-aac5-0e6a302a3e26	I9GRKB	personal	\N	2024-08-09 15:35:43	2024-08-09 15:35:43
6382705f-42e1-4f9f-a1f7-8c8daa47b9a0	I9P2B3	personal	\N	2024-03-08 01:04:20	2024-03-08 01:04:20
fa2dcaca-97e2-4037-b23f-8f0b8acaed35	IB2MY4	personal	\N	2024-08-14 10:49:08	2024-08-14 10:49:08
1a566d70-ff49-4c3c-8d21-7fa7b21211fb	IC2MY4	personal	\N	2024-08-15 09:54:50	2024-08-15 09:54:50
22a1cb60-704a-4959-83c9-1109dea8a87a	IC38X9	personal	\N	2024-03-25 15:52:56	2024-03-25 15:52:56
30d8b69f-293d-4141-b14c-fb1778ed3183	ICRO98	personal	\N	2024-08-30 00:10:15	2024-08-30 00:10:15
61b3566e-f3e2-4116-824b-0be7e6d5f9b8	IE2MY4	personal	\N	2024-10-30 22:30:42	2024-10-30 22:30:42
deb8426c-e0ed-46de-81e5-90b4bfda7d39	IERO98	personal	\N	2024-11-12 17:04:11	2024-11-12 17:04:11
7ca334c9-4cef-49c2-a447-f7ab269d7047	IFDJN1	personal	\N	2024-11-19 07:06:33	2024-11-19 07:06:33
513cf638-5a30-4ab9-9752-b1c65236e65a	IJSA8D	personal	\N	2024-05-29 13:27:40	2024-05-29 13:27:40
b4984725-347b-4719-bf4c-095d764ab3ba	ILSA8D	personal	\N	2024-07-09 17:59:28	2024-07-09 17:59:28
5bfe0002-a6c2-4ed1-a9fc-5d84e99f6402	IM38X9	personal	\N	2024-07-09 21:34:58	2024-07-09 21:34:58
8d376618-ce43-42a3-aa6e-4a7a3cd11f36	IMCJN1	personal	\N	2024-02-02 01:06:49	2024-02-02 01:06:49
3a3e0676-66e8-487f-8eba-e64eefe2bf2f	IO1MY4	personal	\N	2024-02-19 13:47:06	2024-02-19 13:47:06
10ca26e0-be04-44ae-9532-a88a58668533	IOCJN1	personal	\N	2024-02-17 23:14:59	2024-02-17 23:14:59
6b0b5ee8-615a-43be-a403-cf30cf4c3c66	IP38X9	personal	\N	2024-07-19 21:07:55	2024-07-19 21:07:55
a5b38314-60e9-4ba3-a011-5567e227d322	IQ4UVE	personal	\N	2024-03-12 18:03:04	2024-03-12 18:03:04
0d5abcf4-e12a-4cbe-ba15-01ef7fd3ec5f	IQE5M6	personal	\N	2024-07-27 22:32:11	2024-07-27 22:32:11
776d5415-fd11-4be0-99a7-fd192b4804a2	IR1MY4	personal	\N	2024-03-12 09:00:03	2024-03-12 09:00:03
8fb7d099-716c-4b0b-ad91-4e94b0d00d63	IRQO98	personal	\N	2024-03-12 22:52:12	2024-03-12 22:52:12
63c0b18b-9d4b-4cb1-b3cc-3cbf8bda0362	IS1MY4	personal	\N	2024-03-13 21:09:40	2024-03-13 21:09:40
e36db7d9-966a-48e9-a337-3c7dd6ba69ce	IT4UVE	personal	\N	2024-03-25 09:15:14	2024-03-25 09:15:14
bec4ca37-50c4-46ea-9840-a0228ce9df38	IUCJN1	personal	\N	2024-03-21 00:50:41	2024-03-21 00:50:41
6ed085db-824f-4698-a99b-e2a4d9bd0fdb	IUSA8D	personal	\N	2024-10-01 18:41:17	2024-10-01 18:41:17
14ab6b3c-2c8d-4969-b722-fa3b6949569e	IV1MY4	personal	\N	2024-03-26 06:14:52	2024-03-26 06:14:52
d611a087-be26-4d78-b1c2-9c1329650ef1	IVSA8D	personal	\N	2024-11-06 00:05:21	2024-11-06 00:05:21
e8e2e120-539d-462f-983f-7b7c8b6ddfc2	IZ4UVE	personal	\N	2024-05-07 03:29:58	2024-05-07 03:29:58
4d6fb161-00ad-4b89-bfbb-dde9cedf2d2a	J0DJN1	personal	\N	2024-04-17 12:49:58	2024-04-17 12:49:58
b23294b4-28f3-4a8b-bc76-29377cd4a7f2	J45UVE	personal	\N	2024-07-11 08:40:35	2024-07-11 08:40:35
6faf415c-dd33-49ae-b64f-876b83cf20e5	J5SA8D	personal	\N	2024-02-19 14:56:01	2024-02-19 14:56:01
088dddf9-7d9c-46a5-adaf-b7a97f3bd7d4	J72MY4	personal	\N	2024-07-15 12:58:35	2024-07-15 12:58:35
73189583-b3ab-4954-a16f-94611eec7985	J85UVE	personal	\N	2024-08-08 11:45:23	2024-08-08 11:45:23
67c3e10b-948b-4b7d-9fff-3977e935b4d9	JA2MY4	personal	\N	2024-08-10 01:30:37	2024-08-10 01:30:37
871db774-f57e-4830-813c-76fc414d2d7b	JAGRKB	personal	\N	2024-08-14 07:42:33	2024-08-14 07:42:33
c2a418bd-aae3-479b-8d28-dc4a3fafb5e4	JB38X9	personal	\N	2024-03-21 05:27:23	2024-03-21 05:27:23
aa4b5af8-90ec-46b0-8cd5-0f6a42c135be	JFDJN1	personal	\N	2024-11-20 18:58:03	2024-11-20 18:58:03
41934832-9005-43bd-9682-542d32e9a9a9	JGP2B3	personal	\N	2024-04-05 12:34:45	2024-04-05 12:34:45
d6bbc439-3652-46f4-b243-417ac11a076a	JGSA8D	personal	\N	2024-04-15 23:26:57	2024-04-15 23:26:57
261c438f-fd04-4d78-84ca-76bab60ce047	JIE5M6	personal	\N	2024-05-03 16:56:19	2024-05-03 16:56:19
d66fa8c7-93c6-4904-9cf0-29121c1042d8	JKP2B3	personal	\N	2024-05-24 19:57:04	2024-05-24 19:57:04
b3ef18b4-2c14-4318-b4f2-9e67939b2189	JMQO98	personal	\N	2024-02-07 02:24:01	2024-02-07 02:24:01
2396a298-568e-4237-a8d5-faa1c3902182	JPSA8D	personal	\N	2024-07-27 17:52:14	2024-07-27 17:52:14
c180b2ed-216a-4667-8320-f25d7128f4e4	JR1MY4	personal	\N	2024-03-12 09:37:13	2024-03-12 09:37:13
9c6716e4-d8f2-4e84-831c-7fedddd70536	JRCJN1	personal	\N	2024-03-04 06:11:13	2024-03-04 06:11:13
ffac290e-e496-4704-b4b6-b6fd8886fd96	JRP2B3	personal	\N	2024-07-29 09:19:15	2024-07-29 09:19:15
27de209b-0424-46bc-83ca-5e7170f6d78c	JSE5M6	personal	\N	2024-08-11 05:05:55	2024-08-11 05:05:55
d751f28d-f47d-4486-8ff8-94358cdf53f7	JTSA8D	personal	\N	2024-08-16 08:10:22	2024-08-16 08:10:22
d8e42301-a8b5-4708-87c6-440ca9acd37e	JU1MY4	personal	\N	2024-03-22 08:30:41	2024-03-22 08:30:41
46bd2d13-8e86-4937-b150-4514a75e2cad	JXFRKB	personal	\N	2024-04-06 02:19:58	2024-04-06 02:19:58
06b9b48a-abaa-4d24-8ee9-d94d5ab0ec66	JXP2B3	personal	\N	2024-12-04 23:53:06	2024-12-04 23:53:06
7a19a677-5c7e-4efa-99aa-2d7a536f4ba9	K2E5M6	personal	\N	2023-12-21 00:46:01	2023-12-21 00:46:01
631da6d3-9081-4d4d-8f17-98f6f1e128c4	K2P2B3	personal	\N	2023-12-06 09:16:47	2023-12-06 09:16:47
1a550834-b834-45c1-a899-392a50b5ee7d	KASA8D	personal	\N	2024-03-15 10:26:12	2024-03-15 10:26:12
d2feda35-cf48-4d50-9db4-5d5cab9a96bd	KBSA8D	personal	\N	2024-03-24 04:44:05	2024-03-24 04:44:05
ca576d45-6769-4d6e-b2a5-a094c8f3f6af	KCE5M6	personal	\N	2024-03-25 07:24:39	2024-03-25 07:24:39
29539f8f-498d-4c53-b24b-3ea006f39832	KEGRKB	personal	\N	2024-12-09 19:33:04	2024-12-09 19:33:04
d34dd110-ef1b-430d-8a36-23e872209145	KFDJN1	personal	\N	2024-11-20 23:08:34	2024-11-20 23:08:34
b537d55e-b6cd-407a-b2d0-cae4f74b101a	KGE5M6	personal	\N	2024-04-14 08:10:15	2024-04-14 08:10:15
3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	KH4UVE	personal	\N	2023-11-23 08:15:36	2023-11-23 08:15:36
6656caaa-62fb-401b-94d5-a41d4be05549	KIFRKB	personal	\N	2023-11-28 03:21:41	2023-11-28 03:21:41
a1b33428-b453-4d43-bc3b-dd39be193266	KKE5M6	personal	\N	2024-06-03 05:33:37	2024-06-03 05:33:37
3ddc1b80-da70-4135-b286-745586144bfe	KME5M6	personal	\N	2024-07-09 19:55:55	2024-07-09 19:55:55
68a2b2a2-34f9-4738-9f09-7611fc4248ae	KMFRKB	personal	\N	2024-02-17 04:15:57	2024-02-17 04:15:57
f4a8510a-c11a-4ba5-8915-b30e6e53f9e8	KMSA8D	personal	\N	2024-07-10 23:45:03	2024-07-10 23:45:03
7969cb1e-67db-442c-8fc3-452f6841162b	KNE5M6	personal	\N	2024-07-11 04:24:26	2024-07-11 04:24:26
999795bc-d3e9-4a2f-91df-871907151e35	KNQO98	personal	\N	2024-02-17 20:11:28	2024-02-17 20:11:28
47566cba-815a-4691-a5ef-d0c6165c9ef1	KOE5M6	personal	\N	2024-07-13 06:06:55	2024-07-13 06:06:55
19cd3169-bef1-4250-a499-6f53588e82a6	KOP2B3	personal	\N	2024-07-12 03:51:48	2024-07-12 03:51:48
939fa2b7-9ca4-4ab9-a8c9-2e9f51034571	KPFRKB	personal	\N	2024-02-21 06:12:55	2024-02-21 06:12:55
7ac95e8d-1416-428e-8ad9-6d6b49a9b499	KQE5M6	personal	\N	2024-07-28 00:00:35	2024-07-28 00:00:35
8ecd4380-5e50-4e97-ba2a-255ce4c2c4e1	KRFRKB	personal	\N	2024-03-13 17:33:24	2024-03-13 17:33:24
76b7ca6b-ccd6-4c2f-a95f-efa65a02b1e9	KV4UVE	personal	\N	2024-04-01 09:11:13	2024-04-01 09:11:13
2252e79e-2e85-4a47-b142-639edcdefef0	KVP2B3	personal	\N	2024-09-25 10:08:22	2024-09-25 10:08:22
acce3330-b31a-45f2-9425-00ae8eee7af8	KY4UVE	personal	\N	2024-04-16 12:01:36	2024-04-16 12:01:36
ee06526f-4879-4f1e-b2c9-49699a1ea132	KYQO98	personal	\N	2024-04-14 14:21:41	2024-04-14 14:21:41
fedc407f-9689-4a01-a4ec-e125fd58523a	KZ28X9	personal	\N	2023-11-16 05:20:28	2023-11-16 05:20:28
39144bf1-9a12-4d6d-a814-b769473d158f	L1E5M6	personal	\N	2023-12-02 04:29:37	2023-12-02 04:29:37
9c575b13-2b96-4e73-8ae6-21267b4cf871	L2SA8D	personal	\N	2024-01-15 07:22:21	2024-01-15 07:22:21
e93e5575-697d-4814-bc66-66b6d5d08f2d	L3E5M6	personal	\N	2024-01-18 00:23:43	2024-01-18 00:23:43
0dc571a3-f6d3-41db-af52-b872a0408842	L8DJN1	personal	\N	2024-07-18 11:48:16	2024-07-18 11:48:16
0e1f6b90-ab29-4df0-9cb5-f253a096d6ca	LBSA8D	personal	\N	2024-03-24 05:33:47	2024-03-24 05:33:47
af93ece9-2f33-42d2-953d-e039b1a1e64d	LCRO98	personal	\N	2024-08-30 02:43:31	2024-08-30 02:43:31
e066dc7a-8c29-40b7-8d05-92c16814cec2	LDE5M6	personal	\N	2024-03-26 12:01:13	2024-03-26 12:01:13
7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	LDRO98	personal	\N	2024-10-15 23:28:45	2024-10-15 23:28:45
8c13c974-9502-4adb-ac4e-13ac5958ab29	LEGRKB	personal	\N	2024-12-10 09:30:00	2024-12-10 09:30:00
a24ba74b-2435-4643-8d23-16de8749558c	LESA8D	personal	\N	2024-04-04 04:39:10	2024-04-04 04:39:10
1dc2d7b6-2e00-4398-b913-905ba4cf938a	LF2MY4	personal	\N	2024-12-19 06:30:59	2024-12-19 06:30:59
504bdffa-a684-41ef-ad70-cbb46ed7e965	LF38X9	personal	\N	2024-04-05 09:16:33	2024-04-05 09:16:33
88256607-f7da-41b0-8845-f75c3ec47282	LG38X9	personal	\N	2024-04-14 23:55:19	2024-04-14 23:55:19
686f2a83-9d79-44e9-a91b-0fee2ac6d8b2	LHSA8D	personal	\N	2024-04-30 23:08:59	2024-04-30 23:08:59
56369354-3edf-40b6-b77b-78eb14f3ee23	LJ1MY4	personal	\N	2023-11-29 06:28:44	2023-11-29 06:28:44
634683f2-de5d-42ca-b2eb-d0d70904e47a	LJP2B3	personal	\N	2024-05-10 15:03:50	2024-05-10 15:03:50
7b53dfec-3fda-4700-9b0c-a15c39e196d0	LKCJN1	personal	\N	2023-12-03 03:07:22	2023-12-03 03:07:22
ef156cb0-6ced-4764-a69d-737d1e30fe40	LM1MY4	personal	\N	2024-02-05 03:15:21	2024-02-05 03:15:21
8e7e993f-54f9-40d5-8bea-ae16768cbe27	LM4UVE	personal	\N	2024-02-17 16:00:59	2024-02-17 16:00:59
c63344c6-cc3c-483e-880e-3fdd280852b7	LN4UVE	personal	\N	2024-02-19 21:00:59	2024-02-19 21:00:59
337fe698-7a7b-4205-8a69-ed79dca59076	LNCJN1	personal	\N	2024-02-14 03:22:04	2024-02-14 03:22:04
f85174e6-7a0b-4534-97af-70757872b5a9	LNSA8D	personal	\N	2024-07-13 00:35:07	2024-07-13 00:35:07
21e2d8b2-c109-4493-bacd-dc87e364c17a	LOP2B3	personal	\N	2024-07-12 04:17:23	2024-07-12 04:17:23
5f88048e-9a4e-4720-a833-cbb9d1b22350	LQQO98	personal	\N	2024-02-29 03:08:30	2024-02-29 03:08:30
c972aafc-9e3e-4d71-844a-e75e99f4092f	LR1MY4	personal	\N	2024-03-12 10:38:31	2024-03-12 10:38:31
6fcf0c16-8f65-4b11-8d5d-5fe2b83f9cd0	LSQO98	personal	\N	2024-03-14 11:57:30	2024-03-14 11:57:30
b0f320d1-cdfa-4593-9fd9-9000d07f5fd8	LUSA8D	personal	\N	2024-10-03 08:36:28	2024-10-03 08:36:28
2ef8f12b-1fdc-4a87-a61a-5a278f557ade	LV38X9	personal	\N	2024-10-23 19:31:05	2024-10-23 19:31:05
d1ed20a2-81de-4ba6-80e6-38635c8e1295	LWFRKB	personal	\N	2024-04-03 10:49:20	2024-04-03 10:49:20
3f38e9c6-d34f-48df-a6b8-06ee322e9c91	LYCJN1	personal	\N	2024-04-05 05:44:07	2024-04-05 05:44:07
50aa5202-9186-4f05-9317-66210b195e17	LYFRKB	personal	\N	2024-04-15 14:39:51	2024-04-15 14:39:51
3ffbd728-c91d-40c5-8bb2-b45e93c1ff6f	M0P2B3	personal	\N	2023-11-18 05:12:20	2023-11-18 05:12:20
8e2970f7-1a8c-4264-bc0a-e827758e4ee3	M12MY4	personal	\N	2024-05-13 21:51:35	2024-05-13 21:51:35
87ca839c-a249-48e4-a9e3-f4e1f844e94e	M1RO98	personal	\N	2024-05-18 15:24:05	2024-05-18 15:24:05
420f5e1d-bd4e-4de7-827f-8386846edd85	M2DJN1	personal	\N	2024-05-24 11:50:22	2024-05-24 11:50:22
0134d7aa-9f38-4e9c-a172-f94415e1beb2	M2SA8D	personal	\N	2024-01-15 07:48:04	2024-01-15 07:48:04
ae27bc19-8b2c-4bb0-ba9e-6835c6b236c8	M3GRKB	personal	\N	2024-07-09 15:35:28	2024-07-09 15:35:28
6265f1a4-b2ff-4401-b2ce-26f57fa234c9	M438X9	personal	\N	2024-02-16 11:10:58	2024-02-16 11:10:58
cdfe543c-a78e-4dbc-ba5b-f3a8e6aaf43a	M4DJN1	personal	\N	2024-07-04 12:25:17	2024-07-04 12:25:17
ae7be8a0-0ca9-42fc-a03e-8844277b9c7b	M4SA8D	personal	\N	2024-02-17 14:33:17	2024-02-17 14:33:17
0a06065b-8318-4070-9fab-a7c2eb12a1b3	M6P2B3	personal	\N	2024-02-19 12:57:47	2024-02-19 12:57:47
d8fe116d-5c6f-4a39-bdd0-cc6dcfdcdbc1	M8GRKB	personal	\N	2024-07-30 17:26:11	2024-07-30 17:26:11
a09353dd-52b0-4575-be49-2e5610517a71	M9DJN1	personal	\N	2024-07-29 06:10:57	2024-07-29 06:10:57
75289381-d857-43a9-847f-680f0cc6fa37	MARO98	personal	\N	2024-08-12 15:15:07	2024-08-12 15:15:07
15a46aed-a65c-4f5a-b06c-7c95230e043b	MBDJN1	personal	\N	2024-08-13 06:53:19	2024-08-13 06:53:19
a5375a3b-6bcf-4d38-ad41-d0f132461966	MBE5M6	personal	\N	2024-03-15 13:06:49	2024-03-15 13:06:49
6ffb9390-3177-4546-993c-4b4b225bad8e	MEP2B3	personal	\N	2024-03-29 11:17:46	2024-03-29 11:17:46
f8756742-6ed3-4e97-97de-3eed8f1d8453	MG38X9	personal	\N	2024-04-15 00:30:42	2024-04-15 00:30:42
94bf3906-765a-4d6b-906e-1bd0fae60947	MI38X9	personal	\N	2024-05-10 05:28:10	2024-05-10 05:28:10
c2a554a7-8f5e-4f75-a4cb-115cb59a4f75	MI4UVE	personal	\N	2023-12-02 07:14:23	2023-12-02 07:14:23
26884176-fd17-486f-bfda-4a77a0dc36d7	MLP2B3	personal	\N	2024-06-15 15:40:28	2024-06-15 15:40:28
386e2034-6ec7-4992-ba76-8ef1ab10013d	MMFRKB	personal	\N	2024-02-17 05:57:45	2024-02-17 05:57:45
41a900d3-a78d-49dd-aa73-85166a70e671	MOQO98	personal	\N	2024-02-20 06:09:56	2024-02-20 06:09:56
ceb2e076-e8e4-4f5e-a944-e1d423c62834	MQCJN1	personal	\N	2024-02-21 06:09:52	2024-02-21 06:09:52
030e1b49-ca9d-4a06-a915-3ea616a68c6b	MRE5M6	personal	\N	2024-08-08 11:43:02	2024-08-08 11:43:02
117ee2d1-53be-4598-8193-4e54566b351e	MRQO98	personal	\N	2024-03-13 00:24:04	2024-03-13 00:24:04
791a51d5-9ab3-48e0-a91b-94cbf1995686	MRSA8D	personal	\N	2024-08-11 00:25:02	2024-08-11 00:25:02
2981927e-7f71-4285-8713-396bc05c8555	MS38X9	personal	\N	2024-08-13 12:39:11	2024-08-13 12:39:11
712fe4b5-f3cf-40f2-aadc-c867df55ab3b	MTSA8D	personal	\N	2024-08-19 16:08:30	2024-08-19 16:08:30
4c850cce-3170-46ea-9669-f891b4bad0da	MU38X9	personal	\N	2024-09-22 06:23:51	2024-09-22 06:23:51
9f07517c-89f5-42d3-b792-c3ee0908b63d	MXP2B3	personal	\N	2024-12-08 11:13:15	2024-12-08 11:13:15
d9918fe1-6201-45aa-b1b6-9da4a6189aaa	MYCJN1	personal	\N	2024-04-05 06:17:47	2024-04-05 06:17:47
2852678a-44c2-4e6d-99d5-c2610148b78c	MYFRKB	personal	\N	2024-04-15 15:00:02	2024-04-15 15:00:02
6b384c05-52a4-4d79-970e-f0022375a358	MZD5M6	personal	\N	2023-11-15 01:39:13	2023-11-15 01:39:13
5ed7695e-c900-4690-ab29-d4ecbc00d945	MZRA8D	personal	\N	2023-11-23 08:15:10	2023-11-23 08:15:10
d98e1f37-38da-41b7-9ad1-9301b0fc0b50	N02MY4	personal	\N	2024-04-30 03:22:18	2024-04-30 03:22:18
ceaab4d5-cd27-4f2f-8dcd-c33c685a606a	N0GRKB	personal	\N	2024-05-13 00:17:26	2024-05-13 00:17:26
0ae6059c-68b6-43d1-b239-e260d05649ab	N2GRKB	personal	\N	2024-06-17 16:52:46	2024-06-17 16:52:46
e5b14590-cac0-4c92-a158-8a423c258ca0	N32MY4	personal	\N	2024-06-21 03:40:20	2024-06-21 03:40:20
712feb0a-52e5-44a6-8d15-5979243c7b15	N4DJN1	personal	\N	2024-07-08 11:48:16	2024-07-08 11:48:16
620c74cc-c8e1-4137-aba2-18a740515388	N4E5M6	personal	\N	2024-02-06 15:04:10	2024-02-06 15:04:10
0307030c-8cd8-46c2-8fdb-2fc21939cf7b	N5DJN1	personal	\N	2024-07-09 21:36:08	2024-07-09 21:36:08
39daebfd-cd2c-4002-a0fe-c28559d8a9e4	N5E5M6	personal	\N	2024-02-17 15:28:19	2024-02-17 15:28:19
e4eb82c8-6b26-4f7f-8641-549baf202c92	N75UVE	personal	\N	2024-07-28 14:50:33	2024-07-28 14:50:33
f61be07d-fd05-4106-b173-2c1975e711ea	N8RO98	personal	\N	2024-07-28 16:47:59	2024-07-28 16:47:59
790960d0-819b-4db6-ac72-32a90174887f	NARO98	personal	\N	2024-08-12 16:24:13	2024-08-12 16:24:13
83feae83-7c02-4985-b9ad-31b4e670d18f	NC38X9	personal	\N	2024-03-26 00:33:44	2024-03-26 00:33:44
fd00865e-2f22-4e24-90da-b778a4b6cc1a	NCGRKB	personal	\N	2024-09-30 02:06:40	2024-09-30 02:06:40
520ad20c-3c32-4b03-8cc0-8635430639f6	NGE5M6	personal	\N	2024-04-14 12:34:36	2024-04-14 12:34:36
e5146647-cb36-4fbd-a898-c8a13436564a	NHQO98	personal	\N	2023-11-15 15:02:31	2023-11-15 15:02:31
b6fefa89-914a-4a89-bda8-e03a77dfbba2	NL1MY4	personal	\N	2024-01-15 04:41:44	2024-01-15 04:41:44
b8993ce5-8254-4051-8545-ab8b4bba3bcd	NLFRKB	personal	\N	2024-02-05 01:19:24	2024-02-05 01:19:24
7d469a31-f327-4656-8f0e-d9906a26a8e3	NMFRKB	personal	\N	2024-02-17 06:37:52	2024-02-17 06:37:52
e076e1f1-390c-4152-bf95-edb2a4a81ab8	NN1MY4	personal	\N	2024-02-17 08:20:14	2024-02-17 08:20:14
c49f28e5-2660-4f0e-ac38-b5c687cbf228	NOCJN1	personal	\N	2024-02-19 04:40:13	2024-02-19 04:40:13
888ab27d-3dda-4ca7-a17a-d421d2855de5	NPCJN1	personal	\N	2024-02-20 09:13:04	2024-02-20 09:13:04
c62fb45e-50a0-4fb1-ba03-81aac65ad8ae	NPSA8D	personal	\N	2024-07-27 23:21:00	2024-07-27 23:21:00
9cf6a883-9dfb-419e-8413-0f56f19439a6	NQE5M6	personal	\N	2024-07-28 04:51:14	2024-07-28 04:51:14
0438f7d9-5b86-4cf9-bd88-d66f1b1fd35e	NR38X9	personal	\N	2024-08-09 04:38:47	2024-08-09 04:38:47
93e0b9ca-6160-4919-80c9-dadd33027b40	NRQO98	personal	\N	2024-03-13 00:31:52	2024-03-13 00:31:52
62ee5b22-cd13-4cb1-bdcf-f2976f9328fd	NT1MY4	personal	\N	2024-03-15 10:22:55	2024-03-15 10:22:55
3695b3f8-be43-431b-b2a1-267332e11615	NUSA8D	personal	\N	2024-10-06 09:46:51	2024-10-06 09:46:51
b24c3bc8-5bce-4606-8b3a-2f3b3a0261d1	NV1MY4	personal	\N	2024-03-26 10:00:59	2024-03-26 10:00:59
bdc0c353-4bb0-42dc-aa6c-a00669fa03dc	NVE5M6	personal	\N	2024-10-12 19:29:29	2024-10-12 19:29:29
53117328-58fe-45e6-af2c-54d9968ec3a9	O0DJN1	personal	\N	2024-04-17 23:05:20	2024-04-17 23:05:20
c0b5a519-6803-4bbd-9a55-333e7c054589	O0GRKB	personal	\N	2024-05-13 02:16:03	2024-05-13 02:16:03
a1d9d15d-9674-4992-a112-44dbb8d0dff4	O0P2B3	personal	\N	2023-11-19 09:43:07	2023-11-19 09:43:07
b390af94-8e44-4c3f-991e-8505ff2ffc8c	O338X9	personal	\N	2024-02-04 00:20:23	2024-02-04 00:20:23
f34bc6b2-5dae-46b7-b44e-ce40e9606741	O3GRKB	personal	\N	2024-07-09 16:15:45	2024-07-09 16:15:45
b3d111ed-f31c-4300-9157-5268ef6acb68	O42MY4	personal	\N	2024-07-09 19:29:15	2024-07-09 19:29:15
73eb3aaa-f817-4c95-bfdf-2c4c91d1a9e4	O4E5M6	personal	\N	2024-02-06 18:57:25	2024-02-06 18:57:25
b7c71dec-b765-4ab4-845a-042585452059	O4P2B3	personal	\N	2024-02-04 08:16:26	2024-02-04 08:16:26
cb2eba6c-4cf4-4b8f-a171-d01bd2c09e75	O4RO98	personal	\N	2024-07-09 21:26:24	2024-07-09 21:26:24
c1dbe57f-98a3-4a7a-b19e-73086799fcdd	O638X9	personal	\N	2024-02-20 09:25:59	2024-02-20 09:25:59
52ae3ad4-91ed-4f8f-870a-a981147a3698	OCDJN1	personal	\N	2024-08-15 02:12:58	2024-08-15 02:12:58
fcf287b3-077c-40fd-8f4f-50ddf266fd4a	OD2MY4	personal	\N	2024-10-03 07:45:10	2024-10-03 07:45:10
36829335-1ae2-4400-86b9-84fd4bf2de32	OD38X9	personal	\N	2024-03-29 05:34:11	2024-03-29 05:34:11
06cd90d8-0225-4179-addd-f6447a77fbd7	OD5UVE	personal	\N	2024-11-15 01:41:44	2024-11-15 01:41:44
6ce5645e-7a52-4c0c-b263-abee0d8748da	ODE5M6	personal	\N	2024-03-26 14:09:45	2024-03-26 14:09:45
80dcef08-7842-4c2e-b0eb-e0f96db6d1f0	ODSA8D	personal	\N	2024-04-01 08:18:30	2024-04-01 08:18:30
f571656f-ddc6-4d43-b758-72c003dc61d6	OG38X9	personal	\N	2024-04-15 04:39:05	2024-04-15 04:39:05
7258a2ce-894f-4ce1-a260-84a7452f4d22	OHFRKB	personal	\N	2023-11-21 05:24:57	2023-11-21 05:24:57
d91da0fc-fe05-43d1-b18e-c5a98286291f	OI38X9	personal	\N	2024-05-10 09:18:41	2024-05-10 09:18:41
691ca433-0a88-4a91-929a-60daa51ec4a3	OJE5M6	personal	\N	2024-05-17 00:02:46	2024-05-17 00:02:46
bc5390b7-6585-41c9-826e-032818c4cefa	OKE5M6	personal	\N	2024-06-05 06:08:24	2024-06-05 06:08:24
7945b1e3-a196-4cbb-894a-c0d6b3956697	OL4UVE	personal	\N	2024-02-07 04:31:27	2024-02-07 04:31:27
b0d44e87-401c-4f92-b966-e7a74ca669cd	OLP2B3	personal	\N	2024-06-16 07:21:51	2024-06-16 07:21:51
91efd81a-0dde-4423-8f35-a287d107e07a	OMQO98	personal	\N	2024-02-13 07:23:00	2024-02-13 07:23:00
06c58c86-ea01-4f33-9600-cf0b988e0bce	ONCJN1	personal	\N	2024-02-14 12:05:17	2024-02-14 12:05:17
04ed257c-7497-4592-8157-d7526ebdbfcb	OOFRKB	personal	\N	2024-02-20 09:26:42	2024-02-20 09:26:42
d52e4b53-9a6d-40b4-8810-ed27f6aa166e	OOSA8D	personal	\N	2024-07-16 09:29:51	2024-07-16 09:29:51
481f84ac-0826-476a-8bf5-7ebf33a13fc5	OQCJN1	personal	\N	2024-02-21 06:10:06	2024-02-21 06:10:06
3483cb93-d518-4bd5-aabd-35f959946b25	OS1MY4	personal	\N	2024-03-14 04:05:16	2024-03-14 04:05:16
bb8665d1-3763-44fe-b2e9-bd111d6ff725	OT38X9	personal	\N	2024-08-15 04:19:05	2024-08-15 04:19:05
1ce7f618-ad5a-4831-8ab7-941266b34f24	OVP2B3	personal	\N	2024-09-29 02:39:48	2024-09-29 02:39:48
0afaaf27-ddec-4fa1-81f5-59c0c392ce16	OVQO98	personal	\N	2024-03-27 09:09:17	2024-03-27 09:09:17
506a0d86-2822-491c-b4a3-c4261ffff1fe	OWP2B3	personal	\N	2024-10-27 14:01:07	2024-10-27 14:01:07
a3135e59-6d69-4b85-aba6-44192a01ccbc	P038X9	personal	\N	2023-11-27 10:06:19	2023-11-27 10:06:19
6928567c-2b25-4834-8ebf-27800deb240e	P15UVE	personal	\N	2024-06-09 11:10:47	2024-06-09 11:10:47
71ce6255-8c70-4d98-8f03-17b1f88d5f10	P1SA8D	personal	\N	2023-12-21 02:22:50	2023-12-21 02:22:50
5a40810c-8627-482b-b4e3-9d17c760d0b1	P35UVE	personal	\N	2024-07-09 20:58:46	2024-07-09 20:58:46
1818e14a-1df6-489d-9f75-b920e5cbaf1f	P45UVE	personal	\N	2024-07-11 17:21:24	2024-07-11 17:21:24
ab199fd8-c72a-4d17-97e5-d2706748b609	P4SA8D	personal	\N	2024-02-17 15:14:55	2024-02-17 15:14:55
c747109f-9e85-406a-b30d-e3aaacf6eb18	P538X9	personal	\N	2024-02-19 12:50:55	2024-02-19 12:50:55
c77022ad-11a2-470a-8d40-ff04b29996cf	P8DJN1	personal	\N	2024-07-23 19:24:45	2024-07-23 19:24:45
5822a715-e353-4632-bb97-3108d665d860	P95UVE	personal	\N	2024-08-12 12:47:50	2024-08-12 12:47:50
069ae628-63f5-4df6-8723-5dca29b4c9ee	PADJN1	personal	\N	2024-08-09 04:27:07	2024-08-09 04:27:07
ed31a40b-2844-4eef-8921-073c5ac6c240	PB2MY4	personal	\N	2024-08-14 14:06:33	2024-08-14 14:06:33
e68fac0f-bb28-4376-a3fc-f06313da4c62	PBP2B3	personal	\N	2024-03-15 04:01:51	2024-03-15 04:01:51
56b1df68-77bb-46d7-a77c-a22d4ce5286f	PF38X9	personal	\N	2024-04-05 23:01:30	2024-04-05 23:01:30
b0457fb7-5638-4a0f-bbc2-688005ef2ae5	PG38X9	personal	\N	2024-04-15 05:36:09	2024-04-15 05:36:09
42475f00-1325-44b4-9c9f-6dac3fb16f55	PGE5M6	personal	\N	2024-04-14 13:01:29	2024-04-14 13:01:29
66ca42ad-580f-43b6-ba57-47dc780f6382	PGFRKB	personal	\N	2023-11-14 02:34:30	2023-11-14 02:34:30
ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	PH4UVE	personal	\N	2023-11-23 08:15:39	2023-11-23 08:15:39
8a8dda28-6a27-4912-9459-cf5708f1df9f	PHFRKB	personal	\N	2023-11-21 14:04:01	2023-11-21 14:04:01
99627122-0c21-47bf-842f-9c3eed490f97	PICJN1	personal	\N	2023-11-16 07:34:48	2023-11-16 07:34:48
7f8c3e37-ae1a-40b2-a3b9-69d22d672845	PKCJN1	personal	\N	2023-12-04 09:28:27	2023-12-04 09:28:27
1826c895-ee02-44f1-a11d-9261f76e75bc	PKP2B3	personal	\N	2024-05-26 17:15:26	2024-05-26 17:15:26
5d85dfae-323f-4674-9539-21c749a8951a	PKSA8D	personal	\N	2024-06-27 03:39:56	2024-06-27 03:39:56
9f77e3a7-a1bc-4cdf-a1ca-11bc8a2e99aa	PL4UVE	personal	\N	2024-02-07 17:56:11	2024-02-07 17:56:11
691f6647-65e9-43fd-991c-3915b47e9fd9	POP2B3	personal	\N	2024-07-12 06:41:51	2024-07-12 06:41:51
a2e32bac-cab2-4eb8-a43e-9dfda0f1ca48	PPCJN1	personal	\N	2024-02-20 09:25:52	2024-02-20 09:25:52
728cd7f7-cf49-4842-ac69-6de867096162	PPE5M6	personal	\N	2024-07-16 17:34:58	2024-07-16 17:34:58
238f4b6a-f2f2-42af-84eb-d159df121120	PPSA8D	personal	\N	2024-07-28 03:33:24	2024-07-28 03:33:24
780cd261-4746-4bc4-90c6-9457ad08308f	PQ4UVE	personal	\N	2024-03-13 00:09:21	2024-03-13 00:09:21
3970a38d-c005-44fe-9b79-e89b7b8a5ea5	PQCJN1	personal	\N	2024-02-21 06:10:16	2024-02-21 06:10:16
0ef561c5-7784-45bb-93bf-72e11452acb9	PRQO98	personal	\N	2024-03-13 00:46:25	2024-03-13 00:46:25
39425afd-6266-40d6-acaf-8770396d50cb	PS38X9	personal	\N	2024-08-14 02:00:35	2024-08-14 02:00:35
9ccd0c33-482b-4e0a-b55d-05c16eb70da6	PT1MY4	personal	\N	2024-03-15 10:26:22	2024-03-15 10:26:22
e1c6977c-1a2f-442f-970c-c46d0505dc09	PTE5M6	personal	\N	2024-08-14 17:40:17	2024-08-14 17:40:17
7807671a-d14a-4cd7-9524-dcc2c6febfeb	PTFRKB	personal	\N	2024-03-23 10:15:46	2024-03-23 10:15:46
e617cb11-6363-43d1-8754-b0aa2d004810	PUP2B3	personal	\N	2024-08-15 07:21:18	2024-08-15 07:21:18
45ea8462-c7ca-4dad-9132-59f623757bea	PUQO98	personal	\N	2024-03-25 15:11:08	2024-03-25 15:11:08
36c36fc0-7299-445d-81df-89dee356921b	PVP2B3	personal	\N	2024-09-29 03:16:18	2024-09-29 03:16:18
cf7b377c-4e4b-42f1-b1d5-250dee6461a4	PYFRKB	personal	\N	2024-04-15 22:25:47	2024-04-15 22:25:47
e48f3417-8cf4-42c9-8776-afaa56752f6e	Q0DJN1	personal	\N	2024-04-18 10:43:47	2024-04-18 10:43:47
4ce4447c-d891-4274-be6c-e8245b989b5e	Q138X9	personal	\N	2023-12-08 06:23:57	2023-12-08 06:23:57
d59ca0c1-244b-4604-893f-aeb7ebcde1e5	Q238X9	personal	\N	2024-01-06 12:37:20	2024-01-06 12:37:20
5b277fc8-1da0-4867-beae-f6a8e72f490e	Q2E5M6	personal	\N	2023-12-23 12:27:12	2023-12-23 12:27:12
f344e33c-7816-40ac-94b7-840f6bbc4f76	Q438X9	personal	\N	2024-02-17 04:09:52	2024-02-17 04:09:52
67dd0bda-ef9b-480b-b365-024472500876	Q5E5M6	personal	\N	2024-02-17 17:17:28	2024-02-17 17:17:28
bdd944e1-3a2f-4f51-8db8-8bad2e0215f1	Q6GRKB	personal	\N	2024-07-15 15:38:37	2024-07-15 15:38:37
4a176e6a-66cc-4626-b167-b1a7507d637a	Q6SA8D	personal	\N	2024-02-20 12:27:02	2024-02-20 12:27:02
640c9afd-9ed2-4225-b2e5-7458c9fc7e4b	Q8E5M6	personal	\N	2024-02-27 00:09:21	2024-02-27 00:09:21
0eb99839-f4b8-4afa-b9af-045cc270429e	Q8GRKB	personal	\N	2024-08-05 16:14:44	2024-08-05 16:14:44
b720f98f-9a0c-43e7-958b-9855a27a7c71	Q8P2B3	personal	\N	2024-02-21 07:05:00	2024-02-21 07:05:00
280c4e9a-fcb7-432d-ab32-a4dc432c94f4	Q938X9	personal	\N	2024-03-13 15:29:49	2024-03-13 15:29:49
be316477-478d-47bb-80d4-ad05aea1d35d	QCE5M6	personal	\N	2024-03-25 12:13:53	2024-03-25 12:13:53
82897173-7157-4508-9557-9e6700c0dc4d	QCP2B3	personal	\N	2024-03-22 08:28:55	2024-03-22 08:28:55
f67ed19a-19eb-4b90-a362-f73669aa84be	QCSA8D	personal	\N	2024-03-26 12:48:45	2024-03-26 12:48:45
b9f6838a-5754-43ef-a5aa-11d291dda390	QE2MY4	personal	\N	2024-11-08 01:09:06	2024-11-08 01:09:06
f636fd79-dd5d-4c59-9f96-9f72e5a64dbe	QERO98	personal	\N	2024-11-25 13:18:52	2024-11-25 13:18:52
2e669ab1-26da-4903-9427-c4f13bf92a1f	QESA8D	personal	\N	2024-04-04 11:24:35	2024-04-04 11:24:35
451add23-f1e8-42be-bd7d-b558e2ed31be	QFE5M6	personal	\N	2024-04-05 00:44:20	2024-04-05 00:44:20
380b8ae6-1198-4205-aaee-682d865ccfd2	QFP2B3	personal	\N	2024-04-03 11:32:18	2024-04-03 11:32:18
343b7204-610f-4785-ac35-e78401ed11d2	QGFRKB	personal	\N	2023-11-14 04:31:51	2023-11-14 04:31:51
df70ca0d-8dd3-4c3f-9dcc-212b00dc542c	QHE5M6	personal	\N	2024-04-16 12:57:34	2024-04-16 12:57:34
a1468102-4c03-47f4-a390-cc625f636017	QI4UVE	personal	\N	2023-12-02 12:10:57	2023-12-02 12:10:57
c2fa9a14-616c-472c-bd5a-d542361b679b	QJP2B3	personal	\N	2024-05-12 16:09:12	2024-05-12 16:09:12
97839cd4-0327-4209-b3a0-09744b78c944	QJQO98	personal	\N	2023-12-04 06:12:30	2023-12-04 06:12:30
3bce0bf7-793c-4e2f-ad9e-fe11bf085ee0	QKP2B3	personal	\N	2024-05-26 17:20:19	2024-05-26 17:20:19
16c03ecc-7936-4614-b272-58cfb2288da8	QKQO98	personal	\N	2023-12-30 14:54:55	2023-12-30 14:54:55
66b771c6-9028-44eb-83e5-1ae8d757688d	QKSA8D	personal	\N	2024-06-27 08:20:01	2024-06-27 08:20:01
b8ab0745-81c4-415a-9466-64c277657b1e	QLFRKB	personal	\N	2024-02-05 03:19:03	2024-02-05 03:19:03
a0a2dd68-6292-4771-939e-d7ebc2482cf0	QN38X9	personal	\N	2024-07-12 04:21:46	2024-07-12 04:21:46
fa2f92af-7995-4b05-9890-c2eb0f83a7c9	QOE5M6	personal	\N	2024-07-14 01:53:48	2024-07-14 01:53:48
376225dd-5419-4aab-862c-25bd9e67f5df	QR4UVE	personal	\N	2024-03-14 12:11:29	2024-03-14 12:11:29
b7068e6f-0513-47a6-82d5-a67333d69e31	QTSA8D	personal	\N	2024-08-25 08:02:34	2024-08-25 08:02:34
dbdb7d10-daea-429c-bd06-6b247f91451e	QVCJN1	personal	\N	2024-03-26 00:28:26	2024-03-26 00:28:26
1959193a-0762-4ea6-973f-390f702cd72e	QVQO98	personal	\N	2024-03-28 01:06:36	2024-03-28 01:06:36
f7edb844-845e-432f-9a55-1547a9f16972	QWFRKB	personal	\N	2024-04-04 01:20:36	2024-04-04 01:20:36
9db4313a-2911-4a85-9a43-416ea622bef9	QX4UVE	personal	\N	2024-04-14 15:15:23	2024-04-14 15:15:23
05dff67f-5742-496e-b28c-fa2e75e2a073	QXP2B3	personal	\N	2024-12-12 23:02:57	2024-12-12 23:02:57
aa78814f-f5de-4ba0-bbf6-99aa29fb63dc	QYQO98	personal	\N	2024-04-14 21:25:31	2024-04-14 21:25:31
7a2ca438-8b6c-492c-8fbb-797c9e4e7e1b	R0DJN1	personal	\N	2024-04-18 10:43:56	2024-04-18 10:43:56
b95206de-7a1a-49db-ab02-cf00dcd9504c	R0GRKB	personal	\N	2024-05-14 05:08:43	2024-05-14 05:08:43
8b4f4e5f-3cf7-4790-ad3b-90f52d6c381b	R138X9	personal	\N	2023-12-09 10:01:55	2023-12-09 10:01:55
26714e45-c467-4ca3-9075-e205a203fe52	R22MY4	personal	\N	2024-06-02 08:09:16	2024-06-02 08:09:16
1b4707dd-eaff-4276-8e8e-2c25fccd068d	R32MY4	personal	\N	2024-06-26 03:45:18	2024-06-26 03:45:18
b05aecdd-2bd8-4678-9781-954be6179012	R3E5M6	personal	\N	2024-01-29 01:29:48	2024-01-29 01:29:48
01646a03-f544-4787-ba90-627eda7ff131	R42MY4	personal	\N	2024-07-09 19:47:07	2024-07-09 19:47:07
3dc254ea-f533-4375-a717-3b6aba7771e8	R4DJN1	personal	\N	2024-07-09 08:44:31	2024-07-09 08:44:31
40e2c1e5-3242-4b84-822d-0ec95bd3345c	R6GRKB	personal	\N	2024-07-16 00:21:58	2024-07-16 00:21:58
98258a4d-b15d-45a5-b565-5d3f22b98f4a	R6RO98	personal	\N	2024-07-14 17:24:12	2024-07-14 17:24:12
87c92b14-a027-4ba2-9699-76e2096ec9ae	R6SA8D	personal	\N	2024-02-20 12:27:07	2024-02-20 12:27:07
ce43c158-5cbd-48df-8172-cd702ff0700c	R72MY4	personal	\N	2024-07-16 04:02:49	2024-07-16 04:02:49
791a7f26-d8a6-4a22-a414-8e2311a773d3	R7DJN1	personal	\N	2024-07-15 00:42:55	2024-07-15 00:42:55
b710859f-6403-4825-bc9a-3f125caeccb6	R9E5M6	personal	\N	2024-03-12 23:04:37	2024-03-12 23:04:37
24b51865-5001-43e3-8b06-f791014a9954	RASA8D	personal	\N	2024-03-15 19:19:31	2024-03-15 19:19:31
d2caadf6-f315-44cb-ac30-1b39d2efc95e	RB5UVE	personal	\N	2024-09-05 16:35:51	2024-09-05 16:35:51
ec0b3178-ffd4-405c-a15e-aeb71b66560c	RG38X9	personal	\N	2024-04-15 07:31:40	2024-04-15 07:31:40
42e3166f-a80a-4120-b00f-22224f3248b1	RH4UVE	personal	\N	2023-11-23 08:15:50	2023-11-23 08:15:50
ad927edf-b643-49c7-bb35-ce93c40e25f9	RHQO98	personal	\N	2023-11-16 04:57:19	2023-11-16 04:57:19
f2f96776-dd63-4a72-b6dd-7335be117587	RLQO98	personal	\N	2024-02-03 10:24:37	2024-02-03 10:24:37
0e2608ff-48d6-4d63-b998-d4e92ade87dd	RM1MY4	personal	\N	2024-02-05 17:08:45	2024-02-05 17:08:45
27e50322-ae9c-4a99-8f7f-91a3c4401c25	RMP2B3	personal	\N	2024-07-09 15:45:09	2024-07-09 15:45:09
5a4baf14-568d-4ec9-ac7e-2f901337f970	RN1MY4	personal	\N	2024-02-17 15:13:39	2024-02-17 15:13:39
d1269d1c-5e2b-4784-9745-eed1cd1f41ea	RNCJN1	personal	\N	2024-02-17 00:50:56	2024-02-17 00:50:56
e3c47f80-79e9-4480-80c0-ab6c6238b264	ROCJN1	personal	\N	2024-02-19 11:35:44	2024-02-19 11:35:44
7f5dc557-d70c-48b7-b510-b3dce4f306a6	ROE5M6	personal	\N	2024-07-14 02:57:49	2024-07-14 02:57:49
62cd660d-f79a-414d-b7a9-ddba6338048d	ROFRKB	personal	\N	2024-02-20 09:32:03	2024-02-20 09:32:03
b55332a0-8a10-42aa-be20-5105eb6445e9	RPE5M6	personal	\N	2024-07-17 05:28:38	2024-07-17 05:28:38
eccfca5a-fe79-422a-86a9-00514d1a84f9	RQCJN1	personal	\N	2024-02-21 06:10:20	2024-02-21 06:10:20
dfdcb6d0-9a2f-4b9f-842c-732be3903b2c	RR1MY4	personal	\N	2024-03-12 13:17:59	2024-03-12 13:17:59
3e33926e-1a86-46ec-b46b-d7715d8f7f4c	RR4UVE	personal	\N	2024-03-14 12:13:03	2024-03-14 12:13:03
031dd7a3-c7ca-4427-b32d-ed85c18dad9d	RRFRKB	personal	\N	2024-03-14 03:01:17	2024-03-14 03:01:17
a4b4f9c4-eebf-4d1a-b388-44fba74fceb4	RS1MY4	personal	\N	2024-03-14 06:08:47	2024-03-14 06:08:47
ab93dfc3-181a-4c61-9aa7-b8dfdfa8c7c8	RUQO98	personal	\N	2024-03-25 16:39:56	2024-03-25 16:39:56
0e691109-aac1-47b0-9727-c9078860a89f	RV38X9	personal	\N	2024-10-26 20:16:16	2024-10-26 20:16:16
39e2db19-b3b0-459a-869c-7a9fcc8e2b0d	RV4UVE	personal	\N	2024-04-02 05:41:57	2024-04-02 05:41:57
8f57a9b6-7314-4547-8b92-4ab2ada57fff	RVQO98	personal	\N	2024-03-28 04:38:15	2024-03-28 04:38:15
80df838d-a19c-4611-a85e-3f5406c5eb18	RX4UVE	personal	\N	2024-04-14 16:33:21	2024-04-14 16:33:21
4272901f-df44-4eec-973b-06cc7835befb	RXP2B3	personal	\N	2024-12-13 22:54:04	2024-12-13 22:54:04
5075eee3-f309-40c0-b170-ca8ce3126bb9	RZQO98	personal	\N	2024-04-17 18:23:44	2024-04-17 18:23:44
87b40694-4414-4841-925a-176a00c7826a	RZRA8D	personal	\N	2023-11-23 08:15:35	2023-11-23 08:15:35
d821b851-e24e-4fc9-8fda-a4b743eeb8a0	S0GRKB	personal	\N	2024-05-14 18:58:45	2024-05-14 18:58:45
a7d7d2b7-8389-4a67-91e3-7aaf6940bf49	S138X9	personal	\N	2023-12-09 10:02:20	2023-12-09 10:02:20
8579e15f-8fbd-491a-93ba-222c366baca7	S1RO98	personal	\N	2024-05-24 12:20:46	2024-05-24 12:20:46
b3aa0f67-975e-4e8e-a7e5-8f82817802cd	S238X9	personal	\N	2024-01-10 04:07:54	2024-01-10 04:07:54
44ec729f-0a2c-4ce4-88c5-093b6c243551	S2GRKB	personal	\N	2024-06-21 06:01:28	2024-06-21 06:01:28
6e81c472-ec39-4fe1-a89d-6c9118e85c29	S2RO98	personal	\N	2024-06-12 05:17:20	2024-06-12 05:17:20
deac7b24-f15d-43e1-bd46-538dcef50ba9	S3RO98	personal	\N	2024-07-09 08:23:43	2024-07-09 08:23:43
347835cc-2cb7-4709-92db-a9b53826369c	S45UVE	personal	\N	2024-07-11 20:36:03	2024-07-11 20:36:03
fa8846c4-970d-4a13-a162-d2c843bea408	S5GRKB	personal	\N	2024-07-12 18:45:16	2024-07-12 18:45:16
44a34830-90ab-46f2-ab8d-5a78f3bf5601	S6GRKB	personal	\N	2024-07-16 00:29:06	2024-07-16 00:29:06
6d8fbce9-72cd-46ca-bc0f-a796585e9070	S7E5M6	personal	\N	2024-02-20 13:33:53	2024-02-20 13:33:53
8e65ed71-f8c4-4607-af41-48e60a5105ba	S8GRKB	personal	\N	2024-08-08 07:46:35	2024-08-08 07:46:35
6781d49e-0a52-407a-bbd9-57152fa52741	S8P2B3	personal	\N	2024-02-21 12:54:13	2024-02-21 12:54:13
7e9f1dff-a9c7-40e2-8534-419d6f68b74f	S9P2B3	personal	\N	2024-03-12 09:38:44	2024-03-12 09:38:44
9a30e43f-e39b-4090-b44f-5cbbc0f979a7	SADJN1	personal	\N	2024-08-09 05:30:08	2024-08-09 05:30:08
de1fd787-fb20-4c37-8ded-04cda93180b9	SBE5M6	personal	\N	2024-03-20 11:16:43	2024-03-20 11:16:43
4ce1780a-4d4a-4e34-889b-650f4686daef	SC2MY4	personal	\N	2024-08-24 17:22:08	2024-08-24 17:22:08
40532bb5-0d37-4b72-a2bb-2805d8d1d929	SEDJN1	personal	\N	2024-10-24 17:16:39	2024-10-24 17:16:39
c7f888ba-e078-44b7-8c3e-963834cb91df	SFP2B3	personal	\N	2024-04-03 21:51:46	2024-04-03 21:51:46
454adf69-97d6-4f23-86b9-c94be1405768	SHP2B3	personal	\N	2024-04-15 17:30:34	2024-04-15 17:30:34
e941901e-e1d2-4b37-b1cf-b72f575ba239	SI38X9	personal	\N	2024-05-11 02:41:23	2024-05-11 02:41:23
2c7d8641-3658-4ad8-b61d-590c1ccb544a	SIE5M6	personal	\N	2024-05-08 15:21:37	2024-05-08 15:21:37
d242cbd6-c766-48b3-9131-9b1f051eba28	SIP2B3	personal	\N	2024-04-25 06:28:46	2024-04-25 06:28:46
411ed816-4703-4a0c-ac7a-a18715165349	SN38X9	personal	\N	2024-07-12 05:29:32	2024-07-12 05:29:32
ceaa27da-282e-460b-8cd1-ed95f9c7d1ff	SN4UVE	personal	\N	2024-02-20 06:37:13	2024-02-20 06:37:13
56823086-7980-41e1-97c8-c3fc5b3202ad	SNE5M6	personal	\N	2024-07-11 17:15:23	2024-07-11 17:15:23
f7cf4dc8-05a8-473d-8530-9d085e7e69f7	SPSA8D	personal	\N	2024-07-28 09:52:49	2024-07-28 09:52:49
fba57e05-190d-4d7b-a02b-86e985def82c	ST38X9	personal	\N	2024-08-15 07:12:44	2024-08-15 07:12:44
7887fb5a-1d5a-4690-acfa-ed25f6058297	SUQO98	personal	\N	2024-03-25 22:20:24	2024-03-25 22:20:24
c860a1d9-7e60-4953-8d51-855e59dd9bca	SV4UVE	personal	\N	2024-04-02 07:02:13	2024-04-02 07:02:13
05f1ea88-de99-48ad-b7cc-38ed173ba5f6	SWP2B3	personal	\N	2024-11-02 18:15:54	2024-11-02 18:15:54
e23735cf-2421-4dcc-bd8f-46ac18fe5a49	SXFRKB	personal	\N	2024-04-13 16:24:43	2024-04-13 16:24:43
4100eb65-7e5b-4496-9bb1-17df3e3225b8	QWSA8D	personal	\N	2025-01-14 17:10:35	2025-02-25 05:55:35.636
f578ba4f-f883-4dd2-b920-6614af947bd4	SXP2B3	personal	\N	2024-12-19 04:36:09	2024-12-19 04:36:09
b7008772-c853-4fc6-b754-a40aad794448	SYCJN1	personal	\N	2024-04-05 15:26:15	2024-04-05 15:26:15
4d9532f1-02e5-41a6-b85c-46611bfb5161	T0GRKB	personal	\N	2024-05-15 10:12:33	2024-05-15 10:12:33
3624c599-29c8-42d7-948e-2190de565b4a	T0RO98	personal	\N	2024-05-10 05:07:25	2024-05-10 05:07:25
c73ee408-0103-407a-81fb-5ed57db9069f	T22MY4	personal	\N	2024-06-03 15:41:13	2024-06-03 15:41:13
efd0d314-965b-4406-a44a-0b7d1526ce1c	T4DJN1	personal	\N	2024-07-09 09:06:16	2024-07-09 09:06:16
b4e864f4-a2ff-45af-a7f5-5fcc8602404e	T52MY4	personal	\N	2024-07-11 07:45:15	2024-07-11 07:45:15
5c9931fa-1971-4347-a080-d97608cb2eb2	T5RO98	personal	\N	2024-07-12 01:19:04	2024-07-12 01:19:04
99f06db1-4600-48c4-a87a-adc90ae08317	T7DJN1	personal	\N	2024-07-15 01:56:34	2024-07-15 01:56:34
66f00c2f-1152-4591-a614-994ed7dcad5d	T7GRKB	personal	\N	2024-07-27 22:21:47	2024-07-27 22:21:47
37b46c47-9a8c-43c0-8b88-b3b035d8e4e6	T7P2B3	personal	\N	2024-02-20 09:27:17	2024-02-20 09:27:17
c5e234dd-25c0-434f-8071-3aa09c2bc10d	T7SA8D	personal	\N	2024-02-26 23:04:43	2024-02-26 23:04:43
e2a40848-b8d9-46bd-89aa-1ca155f8ff46	TB2MY4	personal	\N	2024-08-14 15:39:14	2024-08-14 15:39:14
11d876a2-a93d-49e1-8117-2b75b1d2678a	TBRO98	personal	\N	2024-08-15 03:25:03	2024-08-15 03:25:03
bba7012e-a97a-49d1-b280-3f0a1fff916f	TCSA8D	personal	\N	2024-03-26 14:18:10	2024-03-26 14:18:10
17eb1c1d-7c3d-487a-8fea-baff32b2937c	TDGRKB	personal	\N	2024-11-07 21:02:07	2024-11-07 21:02:07
b31dac20-7f9e-4e04-997a-2223439a5029	TFE5M6	personal	\N	2024-04-05 02:13:01	2024-04-05 02:13:01
20115650-29ba-44fa-9861-99c990caa5b1	TGFRKB	personal	\N	2023-11-14 06:03:45	2023-11-14 06:03:45
04383a3e-b5cf-4875-99a7-fdd746e9cab0	TH4UVE	personal	\N	2023-11-23 08:26:06	2023-11-23 08:26:06
c0da8057-0c8e-42c7-99b2-14fbb9d38d6d	TKP2B3	personal	\N	2024-05-29 12:15:40	2024-05-29 12:15:40
704a1e06-b82b-4cbc-88ca-e3214eb21b7e	TM38X9	personal	\N	2024-07-10 12:08:29	2024-07-10 12:08:29
5f064136-3e90-496a-a1ff-12e2e7f79d01	TMQO98	personal	\N	2024-02-16 09:11:01	2024-02-16 09:11:01
f04f3f76-bb72-42c4-bc50-eaebbe67b788	TP4UVE	personal	\N	2024-03-05 13:44:30	2024-03-05 13:44:30
c839a2e4-d1d3-48b8-a47d-730abb5a786f	TPE5M6	personal	\N	2024-07-17 18:13:54	2024-07-17 18:13:54
b890b8ab-aebf-49db-914d-cc1b2d367c6b	TPP2B3	personal	\N	2024-07-15 15:21:07	2024-07-15 15:21:07
c5fb4a52-8afc-4111-81fc-ae6ad78a4dee	TR1MY4	personal	\N	2024-03-12 16:02:22	2024-03-12 16:02:22
fbbbe6f6-1220-4fdf-b12f-fa37353ce314	TRCJN1	personal	\N	2024-03-09 00:46:39	2024-03-09 00:46:39
31269e10-de77-4387-80a6-ec0f0730eb85	TUFRKB	personal	\N	2024-03-26 11:10:56	2024-03-26 11:10:56
f6326bb7-5905-40bf-bee0-a6ca1931f6a9	TV38X9	personal	\N	2024-10-28 03:56:08	2024-10-28 03:56:08
dc41b55f-a5ff-46a6-b2ca-8222e205c8fe	TX4UVE	personal	\N	2024-04-14 20:26:54	2024-04-14 20:26:54
6ffda751-1faf-4560-a259-464048611cb1	TXFRKB	personal	\N	2024-04-13 19:40:51	2024-04-13 19:40:51
8ba6efe3-26f4-46a2-ad35-ac3b5e33efae	TZ28X9	personal	\N	2023-11-20 00:26:55	2023-11-20 00:26:55
04c83856-9ff0-475a-b2cd-db05406b84a3	U0E5M6	personal	\N	2023-11-23 08:15:49	2023-11-23 08:15:49
c5df2d20-188e-4fa5-af91-95c1d762bf6f	U1GRKB	personal	\N	2024-06-02 05:00:22	2024-06-02 05:00:22
248e7e00-611c-412c-87ab-65f5dbe6aa25	U3GRKB	personal	\N	2024-07-09 19:41:30	2024-07-09 19:41:30
f56907f8-a7fe-4cb2-baac-2c0b91291fb0	U3RO98	personal	\N	2024-07-09 08:43:06	2024-07-09 08:43:06
82cbf27e-c81c-4d10-ac41-3f472a4fcdeb	U6GRKB	personal	\N	2024-07-16 03:22:51	2024-07-16 03:22:51
63b91840-aeb7-4558-a952-9e23e7217c1c	UASA8D	personal	\N	2024-03-17 23:48:02	2024-03-17 23:48:02
ee038087-bdd5-40b7-ba3f-e67c2265a463	UEDJN1	personal	\N	2024-10-26 16:48:33	2024-10-26 16:48:33
957a5d6a-ec47-45b9-a047-7316dc47ef3f	UEGRKB	personal	\N	2024-12-29 04:43:10	2024-12-29 04:43:10
33069dfb-50d4-4123-832f-781d406ab98e	UEP2B3	personal	\N	2024-04-01 04:58:53	2024-04-01 04:58:53
fe0152fd-e1f6-4894-862f-f9a0e2f8826b	UFSA8D	personal	\N	2024-04-14 13:36:46	2024-04-14 13:36:46
05ed794e-f094-4a48-91b8-211b37ab3d4f	UJ1MY4	personal	\N	2023-12-02 05:50:40	2023-12-02 05:50:40
48d1c50e-0ed4-4355-8b30-37ed358badcc	UJQO98	personal	\N	2023-12-04 11:08:05	2023-12-04 11:08:05
378c8be0-0116-432e-b9b0-a16f0885b638	UM1MY4	personal	\N	2024-02-06 15:03:43	2024-02-06 15:03:43
cfb0a68c-2135-4df7-ba69-3421c2a01173	UN4UVE	personal	\N	2024-02-20 08:07:48	2024-02-20 08:07:48
6a50df75-f142-4980-8192-b6c512143c86	UNFRKB	personal	\N	2024-02-19 15:53:55	2024-02-19 15:53:55
52f901cc-df50-47d6-9635-4f6297931f20	UNQO98	personal	\N	2024-02-19 11:14:29	2024-02-19 11:14:29
1a613180-d253-411c-b05e-9087bb2537a2	UPCJN1	personal	\N	2024-02-20 09:26:09	2024-02-20 09:26:09
bea16890-5a2b-4c0c-9727-1295ac8c73ba	UPFRKB	personal	\N	2024-02-24 21:50:22	2024-02-24 21:50:22
072c2418-239b-4944-93f8-da9eb88be608	UUSA8D	personal	\N	2024-10-14 22:17:43	2024-10-14 22:17:43
5eb07e97-1af7-41c2-903e-62eef51f9f4c	UXFRKB	personal	\N	2024-04-14 02:33:33	2024-04-14 02:33:33
61bd4e48-a8d7-48f3-90e6-ef8279186360	UZ4UVE	personal	\N	2024-05-10 01:45:48	2024-05-10 01:45:48
c463f8c0-0d2b-4c26-8e60-0c7abee82534	UZD5M6	personal	\N	2023-11-15 13:54:26	2023-11-15 13:54:26
e68e8ed7-f0d4-4352-b67a-ab5ce4424e42	V1E5M6	personal	\N	2023-12-02 14:46:37	2023-12-02 14:46:37
7cb55b4e-309e-48c6-bb08-9c5a99908e4f	V2DJN1	personal	\N	2024-05-26 01:27:50	2024-05-26 01:27:50
dabc2e08-c580-44c1-b164-a5c2ca7d9422	V3DJN1	personal	\N	2024-06-15 18:17:58	2024-06-15 18:17:58
53ce0e6e-78f6-4da4-ae9a-a74911cada49	V6DJN1	personal	\N	2024-07-12 04:26:43	2024-07-12 04:26:43
e0bde437-b425-423b-bdac-018135d2e937	V8DJN1	personal	\N	2024-07-26 06:16:40	2024-07-26 06:16:40
2bf763d8-4198-46e7-9366-d7bce0e5ebc0	V938X9	personal	\N	2024-03-13 21:28:01	2024-03-13 21:28:01
dc4aae5e-4487-4a2f-bdc8-ecd88e9abd8b	V9SA8D	personal	\N	2024-03-14 11:11:53	2024-03-14 11:11:53
779946ef-1373-475e-819a-b1a6cab68291	VAGRKB	personal	\N	2024-08-14 15:05:17	2024-08-14 15:05:17
b3a9ed31-32b4-4ea7-855e-cf739b08b6e9	VASA8D	personal	\N	2024-03-19 10:39:07	2024-03-19 10:39:07
1b2ba876-3b8e-4a3e-84f0-e8868d391c42	VB2MY4	personal	\N	2024-08-14 16:58:53	2024-08-14 16:58:53
a64f60ba-f8a1-4b1c-9d8f-c02410ca14b4	VB5UVE	personal	\N	2024-09-11 23:45:30	2024-09-11 23:45:30
bdaeb520-58bd-438e-8852-66677a8efa2a	VC38X9	personal	\N	2024-03-26 08:16:14	2024-03-26 08:16:14
4208a284-2c0b-421d-9b04-9d76bf795306	VCDJN1	personal	\N	2024-08-15 04:44:57	2024-08-15 04:44:57
f7213fa1-f246-404d-9288-9feefb8323f0	VCSA8D	personal	\N	2024-03-26 16:01:05	2024-03-26 16:01:05
64377fa2-2a24-4a19-863b-f4a7690aa2d7	VDE5M6	personal	\N	2024-03-27 06:53:37	2024-03-27 06:53:37
4075f3b5-a340-4c96-ae18-9444e5b2f242	VEP2B3	personal	\N	2024-04-01 06:59:23	2024-04-01 06:59:23
a2205905-286c-4041-8e6d-3ab4b9db0634	VGP2B3	personal	\N	2024-04-13 14:16:33	2024-04-13 14:16:33
518b423a-d607-4840-b825-8beab11ad8df	VH38X9	personal	\N	2024-04-22 05:47:15	2024-04-22 05:47:15
ff514411-50c3-48fc-87e8-3c151c6c9c13	VHCJN1	personal	\N	2023-11-13 00:02:44	2023-11-13 00:02:44
abedc5ad-cf70-4df3-b8e8-1a1448a8546c	VHFRKB	personal	\N	2023-11-23 08:15:29	2023-11-23 08:15:29
a72a361d-77df-45d8-8b8d-d7889ec73582	VJQO98	personal	\N	2023-12-06 01:14:49	2023-12-06 01:14:49
aca0f31b-c1da-441e-8568-e7c13b498797	VKSA8D	personal	\N	2024-06-28 01:36:31	2024-06-28 01:36:31
69bcf8fa-2087-44ac-8b8c-6e2c9b5909a5	VL4UVE	personal	\N	2024-02-14 07:12:18	2024-02-14 07:12:18
918fa26e-6980-4868-9323-cb956fbf48c9	VLE5M6	personal	\N	2024-06-30 10:28:25	2024-06-30 10:28:25
943a1435-f58f-4f64-b981-48424a2499f0	VLSA8D	personal	\N	2024-07-09 20:57:52	2024-07-09 20:57:52
62191ca8-e257-4dc8-8e6c-015f8d228746	VMCJN1	personal	\N	2024-02-04 05:43:34	2024-02-04 05:43:34
717ec418-16b9-457b-9eaf-376171b552c7	VNCJN1	personal	\N	2024-02-17 04:11:41	2024-02-17 04:11:41
9085ce2c-626a-4d96-9548-1b6fd9535fdc	VO4UVE	personal	\N	2024-02-21 06:10:04	2024-02-21 06:10:04
29a9a5a0-e3bb-41f0-90d0-d8c698b019f1	VOFRKB	personal	\N	2024-02-20 12:00:02	2024-02-20 12:00:02
595eebca-c1ae-4121-9b0d-84774d8c7054	VPE5M6	personal	\N	2024-07-18 08:46:15	2024-07-18 08:46:15
69a923ff-3a36-4a9b-ba1e-1551a059f290	VR4UVE	personal	\N	2024-03-14 13:29:17	2024-03-14 13:29:17
6b4e15e1-8bb3-4b5d-aff1-ac3e8ea44356	VSFRKB	personal	\N	2024-03-15 10:27:51	2024-03-15 10:27:51
21661d2a-883d-4966-8575-aa315b1d2e04	VSSA8D	personal	\N	2024-08-14 17:45:20	2024-08-14 17:45:20
de67562f-d715-420e-b366-9a56e55ee6f0	VTSA8D	personal	\N	2024-08-30 01:32:23	2024-08-30 01:32:23
01082e94-ab8f-4cf0-838f-f4f81fccf773	VUCJN1	personal	\N	2024-03-22 00:06:40	2024-03-22 00:06:40
6fda73f9-57fd-48c4-b204-d70493028542	VVFRKB	personal	\N	2024-04-01 08:18:16	2024-04-01 08:18:16
83375518-3402-451b-bf72-afd825f44fe8	VX1MY4	personal	\N	2024-04-04 12:28:52	2024-04-04 12:28:52
8a111176-2536-4dcf-b486-baa15ebeae76	VXCJN1	personal	\N	2024-04-03 06:56:42	2024-04-03 06:56:42
897f04d0-bc86-4454-83fc-fa1bc70b2a86	VYRA8D	personal	\N	2023-11-15 10:00:49	2023-11-15 10:00:49
0b752a7f-91c8-438b-b556-6b8d052b38b8	VZ1MY4	personal	\N	2024-04-16 11:47:25	2024-04-16 11:47:25
a2e3eb4f-c4e3-4f3c-bfdd-2ca2c6f4b9ed	W038X9	personal	\N	2023-11-29 05:32:36	2023-11-29 05:32:36
836c0c42-bc2e-4373-8db8-a1b3e62333bb	W1RO98	personal	\N	2024-05-25 02:33:53	2024-05-25 02:33:53
55343256-1601-423a-b1a4-3d467d2b64c6	W2SA8D	personal	\N	2024-01-30 11:16:20	2024-01-30 11:16:20
cba74671-d266-47e7-a682-6439f6096e4b	W35UVE	personal	\N	2024-07-09 21:53:58	2024-07-09 21:53:58
bca8c025-d84f-4c89-b383-b46e050f6c76	W3P2B3	personal	\N	2024-01-15 06:38:05	2024-01-15 06:38:05
4f5a91b8-5ae2-4451-8595-e30b2f37474e	W5SA8D	personal	\N	2024-02-20 04:36:55	2024-02-20 04:36:55
03a39be5-7849-45e6-82d5-2631f805bca9	W6P2B3	personal	\N	2024-02-19 15:16:07	2024-02-19 15:16:07
2296613e-7b3c-4921-b44d-6d329c509f24	W72MY4	personal	\N	2024-07-16 11:45:18	2024-07-16 11:45:18
3047c6f8-9727-4b5a-82fe-c4336f868c9c	W75UVE	personal	\N	2024-07-29 06:34:27	2024-07-29 06:34:27
369ea585-21af-4bc2-8a99-0b371999139d	W7RO98	personal	\N	2024-07-24 10:13:06	2024-07-24 10:13:06
847edda8-344a-41bd-8008-bbdda2126a9d	W8E5M6	personal	\N	2024-03-04 16:26:45	2024-03-04 16:26:45
b372c112-df80-497c-80af-6adc1ac7e6f4	W8RO98	personal	\N	2024-07-29 12:27:08	2024-07-29 12:27:08
83d6c867-feae-4868-8718-e3832caa8651	WADJN1	personal	\N	2024-08-09 16:27:30	2024-08-09 16:27:30
3975bbbd-b9bd-4cda-ab7c-82c6f33d0052	WARO98	personal	\N	2024-08-13 14:44:13	2024-08-13 14:44:13
b248fe7b-2402-4a4c-b7b3-00b9a07d4589	WB38X9	personal	\N	2024-03-22 11:41:11	2024-03-22 11:41:11
6d449597-c2f2-475e-8c94-65ccd3988c13	WCE5M6	personal	\N	2024-03-25 13:38:19	2024-03-25 13:38:19
0e243923-c4e6-4bf0-ae19-c0a5545f33c4	WH1MY4	personal	\N	2023-11-15 06:46:04	2023-11-15 06:46:04
691a7808-92eb-4fce-a618-d51867429491	WH4UVE	personal	\N	2023-11-24 02:22:00	2023-11-24 02:22:00
a38b5915-0abf-4faf-9807-79a55151dab3	WI4UVE	personal	\N	2023-12-04 08:51:51	2023-12-04 08:51:51
ebde1970-98f4-4268-9ffe-010967ef454f	WIE5M6	personal	\N	2024-05-09 20:27:43	2024-05-09 20:27:43
6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	WIFRKB	personal	\N	2023-12-01 09:49:34	2023-12-01 09:49:34
48a7ded3-0e70-425b-b587-8139188fb234	WIQO98	personal	\N	2023-11-27 08:31:21	2023-11-27 08:31:21
14eb0aad-c413-413c-8abc-549650c33224	WJ1MY4	personal	\N	2023-12-02 06:12:27	2023-12-02 06:12:27
9533dac5-4510-48db-9cb7-3ae25c3c7ad4	WN4UVE	personal	\N	2024-02-20 09:25:51	2024-02-20 09:25:51
ca843ba0-d096-4e88-90aa-af627b50077a	WP4UVE	personal	\N	2024-03-06 21:20:14	2024-03-06 21:20:14
b370e760-5bed-4ade-8488-fe7c4c972e04	WPFRKB	personal	\N	2024-02-26 11:28:42	2024-02-26 11:28:42
45f96262-590a-4355-b186-9a358c2e6a33	WQSA8D	personal	\N	2024-08-08 12:48:05	2024-08-08 12:48:05
b25c075c-2083-4388-ab72-59394bc00546	WR38X9	personal	\N	2024-08-10 06:33:03	2024-08-10 06:33:03
42ad3425-e79f-4766-a252-2731a5d74930	WR4UVE	personal	\N	2024-03-14 13:31:21	2024-03-14 13:31:21
05e184ec-fe58-4bbe-9e38-1bb0400a43a9	WRFRKB	personal	\N	2024-03-14 06:45:11	2024-03-14 06:45:11
759c5d73-b9f1-47ba-b04f-0d1688fbd782	WRSA8D	personal	\N	2024-08-12 10:21:28	2024-08-12 10:21:28
17ba34ab-a47b-492f-ad8c-f1cddd9f1866	WSE5M6	personal	\N	2024-08-12 17:21:06	2024-08-12 17:21:06
616bde55-ea5a-487b-9959-0dcd5526111d	WSSA8D	personal	\N	2024-08-14 18:16:54	2024-08-14 18:16:54
5372dacd-f854-497b-9435-5b9ceb3ed7ea	WT38X9	personal	\N	2024-08-15 14:22:39	2024-08-15 14:22:39
c88e824b-4488-4d90-a69c-cfb61fbe4791	WU38X9	personal	\N	2024-09-30 04:00:45	2024-09-30 04:00:45
07ee028a-1e71-400d-a185-39dc4299803c	WUCJN1	personal	\N	2024-03-22 05:00:27	2024-03-22 05:00:27
8ec8fcf9-6d6f-41af-a2bc-27c6e38d876b	WX4UVE	personal	\N	2024-04-14 23:42:48	2024-04-14 23:42:48
d335e76f-f4dd-4979-b976-39a61f5b9bef	WYCJN1	personal	\N	2024-04-06 04:17:38	2024-04-06 04:17:38
50d7763f-3b95-4adb-917f-04fdaf9d88c3	WZ4UVE	personal	\N	2024-05-10 04:14:59	2024-05-10 04:14:59
62d39c18-1b82-4922-90eb-2ad5caf6e8e1	WZCJN1	personal	\N	2024-04-15 09:13:57	2024-04-15 09:13:57
936a6f95-6e7c-4d54-a877-be67d6d7948d	WZO2B3	personal	\N	2023-11-14 05:27:34	2023-11-14 05:27:34
e51162de-3aaf-4dfe-acb0-579ee821099c	X0DJN1	personal	\N	2024-04-20 13:06:36	2024-04-20 13:06:36
1c0b7660-f78c-48c9-a2c3-7407d58db1c7	X0P2B3	personal	\N	2023-11-23 07:21:41	2023-11-23 07:21:41
8ad50119-e6b0-4780-b640-150f0a52be5a	X0SA8D	personal	\N	2023-12-02 11:11:42	2023-12-02 11:11:42
218089ad-da0d-488f-b9cc-f599337f5011	X1DJN1	personal	\N	2024-05-11 08:13:27	2024-05-11 08:13:27
4ba48bd4-ff77-4c37-98a4-dd0d748cd535	X1RO98	personal	\N	2024-05-25 15:58:42	2024-05-25 15:58:42
7957760c-02b6-4ab3-9314-4aa6f3633ddd	X1SA8D	personal	\N	2023-12-26 01:45:59	2023-12-26 01:45:59
35f8b814-edcc-4d11-9cae-df98b3db5747	X35UVE	personal	\N	2024-07-09 22:04:45	2024-07-09 22:04:45
98db0db2-e73a-4e94-bb43-33f62d7ae82f	X3E5M6	personal	\N	2024-02-02 23:16:28	2024-02-02 23:16:28
925f7f5f-47ff-4739-a52f-09ad5886fd82	X4P2B3	personal	\N	2024-02-05 05:21:22	2024-02-05 05:21:22
d8101f08-60be-4339-9a5d-f0fb6c996846	X4RO98	personal	\N	2024-07-10 06:20:00	2024-07-10 06:20:00
340b95fa-a327-426d-9a05-9363741dd311	X6SA8D	personal	\N	2024-02-20 19:10:27	2024-02-20 19:10:27
1fec0a2c-8574-4d7c-a528-ac663ae96221	X75UVE	personal	\N	2024-07-29 07:14:02	2024-07-29 07:14:02
39efb61c-534f-4185-a046-457cb05c612a	X8DJN1	personal	\N	2024-07-26 16:22:33	2024-07-26 16:22:33
98f93901-9ae1-4fb8-919b-d9b975af2e10	X8RO98	personal	\N	2024-07-30 14:00:07	2024-07-30 14:00:07
b9325221-963e-4909-8a81-6d00f3b1e7e6	XASA8D	personal	\N	2024-03-20 12:10:06	2024-03-20 12:10:06
317cf77d-0e89-49b2-82f0-b20073914c0c	XB5UVE	personal	\N	2024-09-20 05:16:32	2024-09-20 05:16:32
25da7595-9d60-404e-86a5-2abe95f81715	XBDJN1	personal	\N	2024-08-14 08:24:46	2024-08-14 08:24:46
6c98251c-b1f6-4af0-96f7-37b08b66a067	XC2MY4	personal	\N	2024-08-29 23:53:53	2024-08-29 23:53:53
40d1650f-71c3-4fa9-8a82-91ed16652237	XCGRKB	personal	\N	2024-10-12 01:40:11	2024-10-12 01:40:11
22a19d97-f398-405a-bee6-02fdc86e87b5	XGSA8D	personal	\N	2024-04-16 14:13:04	2024-04-16 14:13:04
4742c248-e7ae-4e74-b513-a66f6f86a66f	XHFRKB	personal	\N	2023-11-23 08:15:33	2023-11-23 08:15:33
f7ae0e39-3b48-404b-9f80-15bfd98d30a6	XI38X9	personal	\N	2024-05-13 04:11:58	2024-05-13 04:11:58
35cd5eac-895c-4bd5-b627-925d292e7108	XK4UVE	personal	\N	2024-02-03 17:52:54	2024-02-03 17:52:54
32f18e4a-73ed-407a-9b84-596ad126573f	XKE5M6	personal	\N	2024-06-11 04:33:52	2024-06-11 04:33:52
8af9f0f2-2af6-47f0-9665-653f6d55857c	XM38X9	personal	\N	2024-07-10 22:17:03	2024-07-10 22:17:03
f29c6bbd-cbd3-415f-9993-3e77db34a416	XME5M6	personal	\N	2024-07-09 21:26:49	2024-07-09 21:26:49
a6f5d443-9bc4-40ed-b156-0bba4139c2fc	XNCJN1	personal	\N	2024-02-17 05:17:15	2024-02-17 05:17:15
0070634d-1758-41ae-bda2-1e046f41109e	XNFRKB	personal	\N	2024-02-19 16:20:38	2024-02-19 16:20:38
7250b935-b2f7-492c-b0dd-74d621c6533c	XNSA8D	personal	\N	2024-07-14 05:58:39	2024-07-14 05:58:39
4a8de4c0-a5a1-4d5f-be82-bdb68dd65a7c	XOQO98	personal	\N	2024-02-20 09:26:07	2024-02-20 09:26:07
9ee0077d-59a9-4c4e-b137-f8d5ff11bed5	XQ4UVE	personal	\N	2024-03-13 08:20:44	2024-03-13 08:20:44
2ebea118-1ae0-4f6b-a5a7-14f84fe8152a	XRFRKB	personal	\N	2024-03-14 07:54:32	2024-03-14 07:54:32
71e23749-819d-4072-8836-74814b93d6a9	XS38X9	personal	\N	2024-08-14 12:16:59	2024-08-14 12:16:59
70a8fc0d-f31e-43a9-b701-ea223205e0df	XU4UVE	personal	\N	2024-03-28 06:21:23	2024-03-28 06:21:23
e745e5c8-cfa0-4e97-8f9f-808652f0a513	XVFRKB	personal	\N	2024-04-01 08:25:18	2024-04-01 08:25:18
ce38d7f1-a5bf-4dd0-a26f-d01ac5fc6f43	XVSA8D	personal	\N	2024-11-16 18:11:15	2024-11-16 18:11:15
a10a15e9-4a0c-422d-8dc2-4fd8df9e7daf	Y02MY4	personal	\N	2024-05-08 03:37:56	2024-05-08 03:37:56
e667a7c4-c9a8-4e66-9401-ac2577b19aec	Y238X9	personal	\N	2024-01-15 01:02:33	2024-01-15 01:02:33
8bafeafd-8521-4b77-b661-bfda57a9f843	Y35UVE	personal	\N	2024-07-09 23:29:02	2024-07-09 23:29:02
740b6735-ea83-49a6-8f31-cf332979afec	Y42MY4	personal	\N	2024-07-09 20:53:47	2024-07-09 20:53:47
5825fa78-3da2-45b3-8541-27b485254728	Y438X9	personal	\N	2024-02-17 07:47:14	2024-02-17 07:47:14
b571720c-8b29-42b6-9d69-b87005f16551	Y5GRKB	personal	\N	2024-07-13 15:31:11	2024-07-13 15:31:11
da338792-0065-494a-960b-662d367ec669	Y638X9	personal	\N	2024-02-20 09:27:31	2024-02-20 09:27:31
b0df8acb-406f-44fe-a769-a311c3462518	Y65UVE	personal	\N	2024-07-24 05:38:50	2024-07-24 05:38:50
80b28ffb-1928-41c2-9147-24969dde86fa	Y838X9	personal	\N	2024-03-12 10:54:32	2024-03-12 10:54:32
07c7285d-8b28-4925-8e73-e8bc866d0d85	Y938X9	personal	\N	2024-03-14 01:18:24	2024-03-14 01:18:24
2fb5aad7-cd52-4250-a25b-4d6ede9dd572	Y9E5M6	personal	\N	2024-03-13 05:29:31	2024-03-13 05:29:31
535a6c64-fa88-48a4-855c-937ab45c8519	Y9GRKB	personal	\N	2024-08-11 08:30:12	2024-08-11 08:30:12
86304602-3f40-481d-9a36-9a61a6289bf6	YB38X9	personal	\N	2024-03-23 13:06:56	2024-03-23 13:06:56
7d87e1d3-b8e2-4e65-99a5-4e77c667bfc4	YCSA8D	personal	\N	2024-03-26 22:30:55	2024-03-26 22:30:55
66dc59c3-b910-4c49-90f5-426e5d16fb85	YD5UVE	personal	\N	2024-12-03 22:21:55	2024-12-03 22:21:55
149c6610-9ba7-49ed-9b4f-5b87eb855e09	YDDJN1	personal	\N	2024-09-29 03:16:32	2024-09-29 03:16:32
51f4d1e7-77e1-44b3-b508-2e2513bd3ce0	YEE5M6	personal	\N	2024-04-02 11:11:59	2024-04-02 11:11:59
9511cd07-4d74-4a65-b1bd-bf9b55dcb0ba	YF38X9	personal	\N	2024-04-13 13:19:20	2024-04-13 13:19:20
e9c13abb-7649-43ec-8700-882edad4129d	YG38X9	personal	\N	2024-04-15 22:46:55	2024-04-15 22:46:55
c1667389-c459-4ecc-a759-cd2b0d69d687	YH1MY4	personal	\N	2023-11-15 08:38:04	2023-11-15 08:38:04
6f40fdb4-0278-4a3f-b662-f7f7b13cf962	YHE5M6	personal	\N	2024-04-17 12:52:20	2024-04-17 12:52:20
7de32a97-e650-4e19-87e8-0040927e6844	YICJN1	personal	\N	2023-11-20 05:00:16	2023-11-20 05:00:16
3090db20-3fb2-4331-b5c6-fde9e7bc998c	YKSA8D	personal	\N	2024-06-29 05:52:34	2024-06-29 05:52:34
19ab8ef6-2d97-43c6-9b8d-d8763bab7242	YLCJN1	personal	\N	2024-01-11 05:23:48	2024-01-11 05:23:48
952b31f8-45a1-4ae1-833c-ec1686448510	YMCJN1	personal	\N	2024-02-04 23:23:35	2024-02-04 23:23:35
38bc0ed2-b6f8-43ab-8c00-4881911d0a64	YMFRKB	personal	\N	2024-02-17 15:24:27	2024-02-17 15:24:27
82a7f6aa-3305-48fb-8b85-430710381179	YP1MY4	personal	\N	2024-02-20 13:10:03	2024-02-20 13:10:03
3a9bc5f0-a584-4335-85d5-0e78b73f6c94	YP38X9	personal	\N	2024-07-27 15:57:43	2024-07-27 15:57:43
77d688de-9a29-4e5f-a453-9479a9fd7f8d	YPQO98	personal	\N	2024-02-21 06:11:03	2024-02-21 06:11:03
daf0d1da-1ba5-4ddf-adf6-bd9d1a3a3a62	YQSA8D	personal	\N	2024-08-08 16:11:15	2024-08-08 16:11:15
724c9b02-38fd-4cdc-868a-74fdebaed45f	YS38X9	personal	\N	2024-08-14 12:55:43	2024-08-14 12:55:43
7287f43c-dcaf-4683-95ef-9b3577d26aec	YTCJN1	personal	\N	2024-03-15 04:09:00	2024-03-15 04:09:00
f5d213b8-d2e6-4f52-8787-7f38c16585ca	YUQO98	personal	\N	2024-03-26 03:25:39	2024-03-26 03:25:39
25233d34-897b-4a45-bb69-c143b66e4ed6	YV4UVE	personal	\N	2024-04-02 15:47:33	2024-04-02 15:47:33
5938ef7a-7576-452e-83c8-e04c046f9db9	YVE5M6	personal	\N	2024-10-21 13:39:16	2024-10-21 13:39:16
8a5b931e-b073-4af9-a916-4b214183a825	YW38X9	personal	\N	2024-12-19 08:38:50	2024-12-19 08:38:50
fcb97d2c-aabd-4e2f-81ae-038d23f31be2	Z02MY4	personal	\N	2024-05-08 07:23:03	2024-05-08 07:23:03
2eba665b-39d7-41a9-bb0a-f6b5e9d8063f	Z0RO98	personal	\N	2024-05-10 20:31:48	2024-05-10 20:31:48
93e9305e-91de-486d-91c8-54a8699c408d	Z12MY4	personal	\N	2024-05-17 02:14:31	2024-05-17 02:14:31
a938faa5-db9f-477d-9b51-211ffc7b4f5a	Z22MY4	personal	\N	2024-06-07 06:49:37	2024-06-07 06:49:37
52aa362f-7d49-4cf1-8b2a-90d1b6bdf2bc	Z2DJN1	personal	\N	2024-05-28 16:21:52	2024-05-28 16:21:52
b558d227-6709-4505-8753-991479735966	Z2GRKB	personal	\N	2024-06-27 08:20:36	2024-06-27 08:20:36
9691721e-0e79-4308-be25-84232fcb1c4d	Z2SA8D	personal	\N	2024-02-02 22:24:13	2024-02-02 22:24:13
094f2915-f8f1-4a09-a0e3-03393c51c717	Z3GRKB	personal	\N	2024-07-09 20:08:06	2024-07-09 20:08:06
170b7474-d2c6-459a-bb12-e3ff4e331254	Z52MY4	personal	\N	2024-07-11 17:10:00	2024-07-11 17:10:00
5f784385-e38c-4019-bdf8-cfca878eef0f	Z5GRKB	personal	\N	2024-07-13 16:58:18	2024-07-13 16:58:18
8d1150b1-2214-403e-8591-1f8cd4a88ce8	Z6RO98	personal	\N	2024-07-15 03:37:07	2024-07-15 03:37:07
e1e9a4b7-c8df-4a14-9c32-6c43fa8049ea	Z9GRKB	personal	\N	2024-08-11 12:16:37	2024-08-11 12:16:37
0b5e9729-9dae-458a-a994-e8c726ceecdf	ZA5UVE	personal	\N	2024-08-15 04:06:39	2024-08-15 04:06:39
ecb030df-f0f6-4c94-a344-5f4cc01f3df6	ZCDJN1	personal	\N	2024-08-15 11:06:18	2024-08-15 11:06:18
11eb06e2-4ace-4f5a-b615-e7f45991fac8	ZERO98	personal	\N	2024-12-08 15:00:30	2024-12-08 15:00:30
07f71045-e499-4b88-b3bc-4b035815ef71	ZGE5M6	personal	\N	2024-04-14 23:02:35	2024-04-14 23:02:35
e489a5af-6a15-467b-97e8-f144421961bc	ZHP2B3	personal	\N	2024-04-16 10:26:53	2024-04-16 10:26:53
f1dff1d3-1665-4c45-a529-c28ab6052030	ZISA8D	personal	\N	2024-05-21 09:24:24	2024-05-21 09:24:24
62d12e53-6e0a-4b0b-bfe1-0ea7f359b356	ZJP2B3	personal	\N	2024-05-16 00:29:53	2024-05-16 00:29:53
341ade64-a857-460d-bc81-dd5f5b0c49b7	ZKE5M6	personal	\N	2024-06-12 01:10:19	2024-06-12 01:10:19
aad3bd25-9a47-403a-8f67-6ee04a2f5a63	ZNP2B3	personal	\N	2024-07-11 02:03:36	2024-07-11 02:03:36
976a45f1-5861-4b49-9931-c99f6030cd49	ZQ38X9	personal	\N	2024-08-07 23:23:48	2024-08-07 23:23:48
17a01594-43f0-4036-adf7-629a37190762	ZQFRKB	personal	\N	2024-03-12 18:05:40	2024-03-12 18:05:40
c2287965-d317-40b0-8cf7-3501d4052a53	ZRQO98	personal	\N	2024-03-13 16:19:09	2024-03-13 16:19:09
0b169a70-d8c9-4ee6-a095-2edfaa6698d3	ZU1MY4	personal	\N	2024-03-25 12:16:14	2024-03-25 12:16:14
f3a78141-9a77-4b27-998d-d2b4d366e088	ZVE5M6	personal	\N	2024-10-22 20:08:39	2024-10-22 20:08:39
679443db-8000-4a0b-9fda-92d3e021a062	ZXCJN1	personal	\N	2024-04-03 12:28:58	2024-04-03 12:28:58
2e0268a2-fdf9-42f2-b671-d5a888b2ba83	ZZCJN1	personal	\N	2024-04-15 15:32:35	2024-04-15 15:32:35
f131f85a-9758-4807-b033-a460023f7800	ZZO2B3	personal	\N	2023-11-14 14:40:57	2023-11-14 14:40:57
d7ed2ac2-6770-4e1c-8472-63ec2d556286	LB38X9	organization	\N	2024-03-21 05:33:22	2024-03-21 05:33:22
31f1e27a-5b94-4662-b0b5-5298f4603a80	MVFRKB	organization	\N	2024-03-29 11:35:48	2024-03-29 11:35:48
33a50f77-7fe1-4243-b2ca-94779146a5a9	MZ28X9	organization	\N	2023-11-16 23:24:44	2023-11-16 23:24:44
c583a589-c6c8-4cfd-9470-d0a445109ef9	N1P2B3	organization	\N	2023-11-28 01:36:10	2023-11-28 01:36:10
3c871199-87bf-4ccf-9787-39a8dbdfde92	NQ1MY4	organization	\N	2024-02-22 05:06:24	2024-02-22 05:06:24
454a1603-bd8c-4a65-a89f-b8cedd28dd76	PDRO98	organization	\N	2024-10-19 09:50:31	2024-10-19 09:50:31
a1980849-8063-40f4-93e8-4de3842911b0	PJ1MY4	organization	\N	2023-12-01 03:18:33	2023-12-01 03:18:33
9620b6f1-f75c-48e0-bf40-8283b740a9f3	QUCJN1	organization	\N	2024-03-21 05:33:28	2024-03-21 05:33:28
6533729f-c065-45df-a881-072c03bcff47	RC5UVE	organization	\N	2024-10-19 09:48:11	2024-10-19 09:48:11
109a4ba1-3456-4dcc-bc80-8f2bdd904da1	RD38X9	organization	\N	2024-03-29 11:23:26	2024-03-29 11:23:26
f13bf802-836f-4886-95c6-99078cf1a1a0	XM1MY4	personal	\N	2024-02-06 23:17:43	2024-02-06 23:17:43
d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	8ZD5M6	personal	\N	2023-11-13 00:03:17	2025-02-10 15:01:55.108
\.


--
-- Data for Name: persona_member; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.persona_member (id, persona_id, member_persona_id, role, created_at, updated_at) FROM stdin;
d1a651b2-5a01-4d05-9300-9a897eb11240	e6c0d75d-3eb5-4f54-881c-3515c5eb6de7	e6c0d75d-3eb5-4f54-881c-3515c5eb6de7	admin	2023-11-17 09:35:09	2023-11-17 09:35:09
bb3990c7-7591-4041-aa77-d571e8d463c4	33a50f77-7fe1-4243-b2ca-94779146a5a9	33a50f77-7fe1-4243-b2ca-94779146a5a9	admin	2023-11-16 23:24:44	2023-11-16 23:24:44
e82624b8-13a0-4609-ae01-4eeabffc5f0a	c583a589-c6c8-4cfd-9470-d0a445109ef9	c583a589-c6c8-4cfd-9470-d0a445109ef9	admin	2023-11-28 01:36:10	2023-11-30 07:53:10
c18c3bda-19ef-42e3-b94d-9ce67cd299e7	454a1603-bd8c-4a65-a89f-b8cedd28dd76	454a1603-bd8c-4a65-a89f-b8cedd28dd76	admin	2024-10-19 09:50:31	2024-10-29 01:04:48
31e5ebcf-3604-4bf2-b69d-bb8db4e9761d	a1980849-8063-40f4-93e8-4de3842911b0	a1980849-8063-40f4-93e8-4de3842911b0	admin	2023-12-01 03:18:33	2023-12-01 03:18:33
42216d49-4878-4a2e-9d65-6dd6591fb131	be269914-8f65-4e4c-b3c5-b02313f8b4ac	be269914-8f65-4e4c-b3c5-b02313f8b4ac	admin	2024-01-10 10:56:14	2024-01-14 00:58:14
dafe670c-10cc-47d6-a80e-718c3f6b330b	835889ef-7e95-4dc9-9930-c517ec555496	835889ef-7e95-4dc9-9930-c517ec555496	admin	2023-11-22 02:32:35	2024-01-15 01:01:17
8290fe69-2c9b-43eb-b199-f90099a51ffe	f3173f6b-71d2-47c1-9768-4ed28d2ee620	a2e3eb4f-c4e3-4f3c-bfdd-2ca2c6f4b9ed	member	2024-03-25 08:04:10	2024-03-29 04:00:52
c73d31be-8b78-4cf8-9ecd-03f50e28afcc	f3173f6b-71d2-47c1-9768-4ed28d2ee620	b3aa0f67-975e-4e8e-a7e5-8f82817802cd	member	2024-03-29 08:31:53	2024-03-29 14:48:09
2376137c-38c3-4530-9b60-942a427fc990	f3173f6b-71d2-47c1-9768-4ed28d2ee620	36829335-1ae2-4400-86b9-84fd4bf2de32	member	2024-03-29 05:46:57	2024-03-29 14:48:04
7e1f179b-11ab-4da3-b719-561d9a543125	f3173f6b-71d2-47c1-9768-4ed28d2ee620	5e837acd-dae2-4186-b57c-ae70ee945f8a	member	2024-03-21 14:02:41	2024-03-29 04:00:46
1662b8d8-a0fc-4583-ac36-649017743d9a	f3173f6b-71d2-47c1-9768-4ed28d2ee620	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	member	2024-03-21 07:19:26	2024-03-21 09:34:15
ed3a5df5-d1db-4289-924d-6349ea9db586	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	c1667389-c459-4ecc-a759-cd2b0d69d687	member	2023-11-27 03:13:39	2023-11-27 04:14:04
ad140b58-8d05-436f-862e-52edcf233558	5dc09e11-8310-4e6b-a8fc-250aadd1e2b2	b558d227-6709-4505-8753-991479735966	member	2024-06-28 01:25:45	2024-06-28 01:27:59
b88b9db8-f41b-4d5c-a310-ef25d197cb92	5dc09e11-8310-4e6b-a8fc-250aadd1e2b2	aca0f31b-c1da-441e-8568-e7c13b498797	member	2024-06-28 01:40:36	2024-06-28 01:47:06
869c5984-bc13-4bd6-9e36-2984a5825509	5dc09e11-8310-4e6b-a8fc-250aadd1e2b2	66b771c6-9028-44eb-83e5-1ae8d757688d	member	2024-06-28 02:56:39	2024-06-28 05:25:47
5ac60d4b-dadc-4732-aace-ed603c411792	5dc09e11-8310-4e6b-a8fc-250aadd1e2b2	e93e5575-697d-4814-bc66-66b6d5d08f2d	member	2024-02-27 00:14:24	2024-06-27 03:40:37
2c8051b5-5e21-4895-ba0a-7545c600dac7	5dc09e11-8310-4e6b-a8fc-250aadd1e2b2	39144bf1-9a12-4d6d-a814-b769473d158f	member	2024-02-19 14:07:17	2024-02-19 14:09:11
3a47a8a0-bb17-4f2b-adbe-6c7b3a4db073	5dc09e11-8310-4e6b-a8fc-250aadd1e2b2	3a3e0676-66e8-487f-8eba-e64eefe2bf2f	member	2024-02-19 13:50:31	2024-02-19 13:57:56
79beef47-eda1-4c97-8a94-b1214466d820	5dc09e11-8310-4e6b-a8fc-250aadd1e2b2	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	member	2024-01-26 03:38:55	2024-01-26 08:21:56
5fa86d12-2b3a-46fb-b5a0-c371cbbf6050	5dc09e11-8310-4e6b-a8fc-250aadd1e2b2	6fc7cc75-200e-49fe-935e-79111fb8948e	member	2024-06-28 05:24:29	2024-06-28 05:25:50
7f78a5cb-4e7a-44e9-a763-81ba3da31e7f	5dc09e11-8310-4e6b-a8fc-250aadd1e2b2	8b6bb28b-3a33-4499-8d67-2bb589dfb8d8	member	2024-06-28 05:51:01	2024-07-08 10:56:13
0f0525c6-0a8e-4569-82ce-f0d8bb488a8f	5dc09e11-8310-4e6b-a8fc-250aadd1e2b2	b9157f2d-642d-4b0f-8398-695f58c8e8bc	member	2024-06-27 08:25:13	2024-06-27 23:42:03
184c4550-d6c4-4096-a0cc-ee163c703457	ae7ec705-a261-4895-a223-3e6e0b0602b7	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	member	2023-11-17 00:22:03	2023-12-06 00:01:24
be8c26d4-7511-446e-b489-7a2389901e12	dab9453b-a30d-44ec-a414-132e953c2408	bca8c025-d84f-4c89-b383-b46e050f6c76	member	2024-01-16 04:28:44	2024-03-05 00:57:04
fe4f0ad4-b562-45f0-9081-fab5ddad2e76	dab9453b-a30d-44ec-a414-132e953c2408	20115650-29ba-44fa-9861-99c990caa5b1	member	2023-11-28 04:49:35	2023-11-28 04:49:45
d84b0dac-41bd-41bf-a030-eeb6ee49828d	dab9453b-a30d-44ec-a414-132e953c2408	7258a2ce-894f-4ce1-a260-84a7452f4d22	member	2024-06-05 00:50:05	2024-06-19 05:44:03
087b632b-1beb-40da-946c-ab24dd55794d	dab9453b-a30d-44ec-a414-132e953c2408	0134d7aa-9f38-4e9c-a172-f94415e1beb2	member	2024-03-05 00:56:04	2024-03-05 00:56:54
106a2d62-6008-488a-9890-2f809bd02967	dab9453b-a30d-44ec-a414-132e953c2408	7a19a677-5c7e-4efa-99aa-2d7a536f4ba9	member	2023-12-21 04:10:52	2023-12-21 04:11:43
ac65e106-de75-47c5-9118-1fd6829195f1	dab9453b-a30d-44ec-a414-132e953c2408	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	member	2024-01-04 02:23:46	2024-01-04 02:25:39
6888229c-5ac8-46a0-8928-8d28698201a2	dab9453b-a30d-44ec-a414-132e953c2408	29a63532-c5b1-4ebb-bba4-9a22abdd986c	member	2023-11-27 06:30:33	2023-11-27 06:32:17
206c6d7e-fe75-4921-8a77-850c4c9a268f	dab9453b-a30d-44ec-a414-132e953c2408	8b9c80e4-3072-4dab-85a6-36e310fae6ef	member	2023-11-14 09:49:54	2023-12-05 00:22:29
8e4c3898-cd37-48ba-941c-2f6c6216194d	dab9453b-a30d-44ec-a414-132e953c2408	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	member	2023-11-19 08:15:34	2023-12-05 00:22:26
8ec6c2af-aa77-4edc-88f9-beeeac44f439	dab9453b-a30d-44ec-a414-132e953c2408	16a4ccff-4739-402d-b675-67fafdda2151	member	2023-11-28 05:36:08	2023-11-28 05:37:19
8c5e1686-ee9b-47f5-9fe6-55ac8b68d66e	dab9453b-a30d-44ec-a414-132e953c2408	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	member	2023-12-05 00:21:10	2023-12-05 00:22:23
8ec01a35-073d-4b38-9023-a46dc5697262	dab9453b-a30d-44ec-a414-132e953c2408	3d328497-971a-4cca-b0e6-6d959503bac0	member	2024-09-10 07:44:02	2024-09-10 07:44:12
a93be54d-518e-444e-b328-96384f6bb557	dab9453b-a30d-44ec-a414-132e953c2408	eab0bcf1-82f3-40db-82fb-ace10ee4a383	member	2024-10-02 01:36:15	2024-10-02 01:36:56
d44cd4ca-6699-4d7b-99cd-d5c2b74be7f7	dab9453b-a30d-44ec-a414-132e953c2408	3e969c04-e8bf-4376-a556-2a039627e19f	member	2023-11-13 02:00:30	2023-11-13 02:02:25
4f7c8d2b-889c-46f6-97d8-c5c4ef6008fe	dab9453b-a30d-44ec-a414-132e953c2408	7e2a2c9f-ceee-43a9-8c22-b0e99af67bf0	member	2024-01-19 08:49:42	2024-01-19 08:50:16
a99a9872-59b8-4aec-ad46-9120c277e2c1	dab9453b-a30d-44ec-a414-132e953c2408	012e0de3-ba65-4fd4-9a9a-f127d09672aa	member	2023-11-15 02:49:07	2023-11-15 04:00:02
bd92c8e8-93bb-4fad-aad2-784ee5004256	69e01f2b-91dd-4f35-9830-4cc59ed58d57	b9325221-963e-4909-8a81-6d00f3b1e7e6	member	2024-03-20 12:18:34	2024-03-22 07:28:37
ceed416c-c1f2-4831-8959-724e1e16372e	69e01f2b-91dd-4f35-9830-4cc59ed58d57	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	member	2023-12-06 23:24:11	2023-12-21 03:50:05
9b048a36-5692-478f-a738-d5542f20770e	69e01f2b-91dd-4f35-9830-4cc59ed58d57	b370e760-5bed-4ade-8488-fe7c4c972e04	member	2024-02-26 11:32:46	2024-02-26 11:33:29
9caa5e1a-4583-4f7a-81c4-85a5edd7ae11	69e01f2b-91dd-4f35-9830-4cc59ed58d57	9533dac5-4510-48db-9cb7-3ae25c3c7ad4	member	2024-02-20 09:31:03	2024-02-20 09:37:08
ebc87116-ef36-433e-8fc6-3f009891b01e	69e01f2b-91dd-4f35-9830-4cc59ed58d57	4f5a91b8-5ae2-4451-8595-e30b2f37474e	member	2024-02-20 04:44:27	2024-02-20 09:37:23
44abd309-7952-4dc5-b8ca-853c5b761e5f	69e01f2b-91dd-4f35-9830-4cc59ed58d57	6b4e15e1-8bb3-4b5d-aff1-ac3e8ea44356	member	2024-03-25 07:24:38	2024-03-25 08:19:13
4d4f2a9e-595b-4291-8965-97e675fd9f64	69e01f2b-91dd-4f35-9830-4cc59ed58d57	9085ce2c-626a-4d96-9548-1b6fd9535fdc	member	2024-02-21 06:15:05	2024-02-21 07:09:28
3f17c2f5-1b29-498e-a106-aed791a76304	69e01f2b-91dd-4f35-9830-4cc59ed58d57	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	member	2024-02-19 08:27:03	2024-02-19 08:27:13
148c138d-4593-47a6-9311-e2d41db1e55b	69e01f2b-91dd-4f35-9830-4cc59ed58d57	1a613180-d253-411c-b05e-9087bb2537a2	member	2024-02-20 09:33:56	2024-02-20 09:36:51
7b826041-637b-4138-84cc-6f59025fc041	69e01f2b-91dd-4f35-9830-4cc59ed58d57	04383a3e-b5cf-4875-99a7-fdd746e9cab0	member	2024-02-19 08:20:52	2024-02-19 08:21:02
47b429f3-5d12-46d0-a00e-0b7ab347eb16	69e01f2b-91dd-4f35-9830-4cc59ed58d57	37b46c47-9a8c-43c0-8b88-b3b035d8e4e6	member	2024-02-20 09:32:28	2024-02-20 09:36:58
f92c4066-33a9-4b78-a478-33a72aa72734	69e01f2b-91dd-4f35-9830-4cc59ed58d57	6781d49e-0a52-407a-bbd9-57152fa52741	member	2024-02-21 13:27:18	2024-02-22 07:48:45
51891889-5ac7-4f2d-ab17-62fee4285a75	69e01f2b-91dd-4f35-9830-4cc59ed58d57	87b40694-4414-4841-925a-176a00c7826a	member	2024-02-21 06:15:06	2024-02-21 07:09:26
dafe95b4-7b6b-407c-b34e-83a8cff06326	69e01f2b-91dd-4f35-9830-4cc59ed58d57	eccfca5a-fe79-422a-86a9-00514d1a84f9	member	2024-02-21 06:15:14	2024-02-21 07:09:24
927ad6e3-cd24-414d-bf98-1c5fd31fceac	69e01f2b-91dd-4f35-9830-4cc59ed58d57	62cd660d-f79a-414d-b7a9-ddba6338048d	member	2024-02-20 09:36:36	2024-02-20 09:36:49
3dd97201-1a0c-441f-8b9d-29b304e3cb63	69e01f2b-91dd-4f35-9830-4cc59ed58d57	82897173-7157-4508-9557-9e6700c0dc4d	member	2024-03-31 20:12:48	2024-04-02 05:18:37
fc5f2317-7e6f-4211-8f44-4849e8296926	69e01f2b-91dd-4f35-9830-4cc59ed58d57	b720f98f-9a0c-43e7-958b-9855a27a7c71	member	2024-02-21 07:17:24	2024-02-22 07:49:02
59315072-b9a8-45bc-8b6f-cfff5625e99f	69e01f2b-91dd-4f35-9830-4cc59ed58d57	3970a38d-c005-44fe-9b79-e89b7b8a5ea5	member	2024-02-21 06:15:14	2024-02-21 07:09:21
15469a09-6c89-41fb-8df9-afcd46db7247	69e01f2b-91dd-4f35-9830-4cc59ed58d57	a2e32bac-cab2-4eb8-a43e-9dfda0f1ca48	member	2024-02-20 09:29:16	2024-02-20 09:37:20
7c9fb72f-8ea6-40c7-917b-94e57d20c526	69e01f2b-91dd-4f35-9830-4cc59ed58d57	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	member	2024-02-19 08:16:21	2024-02-19 08:16:48
6bdee5da-db56-42d8-a9cb-d69a1b01f281	69e01f2b-91dd-4f35-9830-4cc59ed58d57	481f84ac-0826-476a-8bf5-7ebf33a13fc5	member	2024-02-21 06:15:18	2024-02-21 07:09:19
56f47dde-bc82-4f9e-a799-aa79f4b4af2a	69e01f2b-91dd-4f35-9830-4cc59ed58d57	04ed257c-7497-4592-8157-d7526ebdbfcb	member	2024-02-20 09:32:12	2024-02-20 09:37:01
ad8b4ec6-8544-4d8b-9dbe-a9e2e94ea901	69e01f2b-91dd-4f35-9830-4cc59ed58d57	c1dbe57f-98a3-4a7a-b19e-73086799fcdd	member	2024-02-20 09:32:50	2024-02-20 09:36:56
2c18835c-992f-4642-9c58-a44cf8fb2dea	69e01f2b-91dd-4f35-9830-4cc59ed58d57	c49f28e5-2660-4f0e-ac38-b5c687cbf228	member	2024-02-19 04:47:56	2024-02-19 05:08:19
e9b8d67d-2608-4c51-ab04-46e43dd38413	69e01f2b-91dd-4f35-9830-4cc59ed58d57	ceb2e076-e8e4-4f5e-a944-e1d423c62834	member	2024-02-21 06:13:32	2024-02-21 07:09:33
f24063e7-191b-446b-9f9a-5b9266deaaad	69e01f2b-91dd-4f35-9830-4cc59ed58d57	a5375a3b-6bcf-4d38-ad41-d0f132461966	member	2024-03-23 05:10:13	2024-03-23 18:43:31
95eef4ba-b7de-495c-88b2-66d561aa9141	69e01f2b-91dd-4f35-9830-4cc59ed58d57	5f88048e-9a4e-4720-a833-cbb9d1b22350	member	2024-02-29 03:14:19	2024-03-04 11:06:55
986e8d29-acc8-4a32-aa8b-06c29775512d	69e01f2b-91dd-4f35-9830-4cc59ed58d57	939fa2b7-9ca4-4ab9-a8c9-2e9f51034571	member	2024-02-21 06:17:06	2024-02-21 07:09:17
f4cd5400-34a3-4573-9118-9e1d9807c396	69e01f2b-91dd-4f35-9830-4cc59ed58d57	d8e42301-a8b5-4708-87c6-440ca9acd37e	member	2024-03-22 08:45:55	2024-03-23 18:43:40
8868a9bd-cada-43cb-894a-0b06d7b99a22	69e01f2b-91dd-4f35-9830-4cc59ed58d57	9c6716e4-d8f2-4e84-831c-7fedddd70536	member	2024-03-18 06:02:35	2024-03-22 07:28:34
50498f99-9cf0-4404-b71c-fc01096a7710	69e01f2b-91dd-4f35-9830-4cc59ed58d57	e0161890-fc0a-40a7-b14c-0bf1d40cf3d5	member	2024-02-20 09:31:18	2024-02-20 09:37:03
2d0a02eb-ed14-42db-928f-31448992d1a8	69e01f2b-91dd-4f35-9830-4cc59ed58d57	db049daa-59cb-425e-bdd9-c6dbbdff5b95	member	2024-02-21 06:14:57	2024-02-21 07:09:31
c20774f2-2bd9-4aa1-9100-711769876117	69e01f2b-91dd-4f35-9830-4cc59ed58d57	e1d0121d-7fc5-424b-860e-065f92776ca1	member	2024-03-15 01:29:16	2024-03-22 07:28:44
e8059790-3ff8-4fa3-9c96-d5ff92d4e041	69e01f2b-91dd-4f35-9830-4cc59ed58d57	2ddcfb31-7ace-442b-9cf9-eb1966e09627	member	2024-01-25 07:28:32	2024-02-19 05:08:22
f7a2aa90-702b-4575-9932-9624f445a9f0	69e01f2b-91dd-4f35-9830-4cc59ed58d57	ac8046ab-5699-4eda-bde8-056ccc1dcda0	member	2024-02-21 12:31:06	2024-02-22 07:48:57
cb6c7af5-672c-4d4b-8ad4-d77cba0f138e	69e01f2b-91dd-4f35-9830-4cc59ed58d57	887a9751-922b-4b58-8e4e-80e1f069afbe	member	2024-02-20 09:31:00	2024-02-20 09:37:10
2bfbed90-98b0-4aea-870d-1f7743073729	69e01f2b-91dd-4f35-9830-4cc59ed58d57	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	member	2023-12-01 12:03:37	2023-12-21 03:50:14
19d7b8f3-8db4-438c-94e3-7bbb24f8b21d	69e01f2b-91dd-4f35-9830-4cc59ed58d57	b93cd121-1d2c-4c9f-9f1c-ea09efc255df	member	2024-02-20 09:33:20	2024-02-20 09:36:54
9d0dce5e-332f-41ea-b9b0-a30f33396ae4	69e01f2b-91dd-4f35-9830-4cc59ed58d57	45f81bc7-ff24-498d-9104-18da7e5643f8	member	2024-02-19 08:26:37	2024-02-19 08:27:10
4fe155ff-fedc-4612-a808-f5cba4e1e1b7	69e01f2b-91dd-4f35-9830-4cc59ed58d57	75bc07bb-6b7a-4414-b064-9f0f7c086217	member	2024-02-20 09:31:13	2024-02-20 09:37:05
b4e45306-3049-429a-a2c3-32f978ed87b0	69e01f2b-91dd-4f35-9830-4cc59ed58d57	04a73285-3f3c-433f-917d-15f913b0737a	member	2024-03-22 06:54:26	2024-03-22 07:28:32
6f2c7e4c-701f-4882-bfc5-e016409efd19	69e01f2b-91dd-4f35-9830-4cc59ed58d57	ac2d044e-0c82-4e7c-bc7f-2781191a1148	member	2024-01-25 07:25:58	2024-02-19 05:08:27
fb1ef507-d3b9-4947-80ba-8fb65e1866e4	69e01f2b-91dd-4f35-9830-4cc59ed58d57	dae9be5f-69f8-4aba-8707-3974bd4edf02	member	2024-01-15 07:10:18	2024-01-15 07:10:56
c1e12f7f-1e8b-4d9d-8ded-aa145d959707	69e01f2b-91dd-4f35-9830-4cc59ed58d57	aed4eb23-b290-48dc-81f5-eb28d3487d29	member	2024-03-26 00:25:00	2024-03-26 19:47:02
b5358be0-b4d7-488d-8ffc-9e320e543696	69e01f2b-91dd-4f35-9830-4cc59ed58d57	1543db57-9c36-4a03-b917-401ada53eb22	member	2024-02-20 09:30:57	2024-02-20 09:37:16
e0627d9a-73d8-41bd-ab3a-768f05af55f2	69e01f2b-91dd-4f35-9830-4cc59ed58d57	70c7e4b1-61e3-4ea7-b254-f7a6477d7e1a	member	2024-02-26 11:32:52	2024-02-26 11:33:14
9df140c4-7959-4eaa-b81b-26013b56914d	69e01f2b-91dd-4f35-9830-4cc59ed58d57	2fc63575-ed81-4633-9117-b8fcb774cf85	member	2024-03-06 06:19:52	2024-03-12 13:08:00
4f6870f3-4fdc-41b4-a6d4-cce9acce5876	69e01f2b-91dd-4f35-9830-4cc59ed58d57	5efc6baa-40ff-406f-aab6-3cd7e48a7f26	member	2024-03-22 14:08:02	2024-03-23 18:43:34
260b7d8e-0849-4ac6-ba21-df091d439b8b	69e01f2b-91dd-4f35-9830-4cc59ed58d57	437a268e-e28e-4d15-b50f-3190fff9acaf	member	2024-02-20 04:34:33	2024-02-20 09:37:28
5ff5f8ef-01df-4682-acc9-361571d67a80	69e01f2b-91dd-4f35-9830-4cc59ed58d57	0450904b-3317-451f-86fd-9e606db4186f	member	2024-02-20 09:30:52	2024-02-20 09:37:18
620d6969-3929-4101-9310-854a30696455	69e01f2b-91dd-4f35-9830-4cc59ed58d57	45aa8b28-c678-4e4a-9352-27ab690df852	member	2024-02-20 09:30:58	2024-02-20 09:37:12
10a800c0-6dbc-4f90-88fc-12e81f272121	69e01f2b-91dd-4f35-9830-4cc59ed58d57	48101c5e-8026-4206-9b7e-bb3c01018b75	member	2024-02-26 11:35:26	2024-02-27 06:26:29
9c99fff5-6624-4d9c-b3e7-d64e03e071ab	69e01f2b-91dd-4f35-9830-4cc59ed58d57	c2d8d0d1-43dc-4d39-9170-071ff5bf0cb2	member	2024-02-21 07:07:48	2024-02-21 07:09:14
831e3f02-e37d-471d-b881-e894dd7e0a16	69e01f2b-91dd-4f35-9830-4cc59ed58d57	ccd77641-e05b-4160-8b88-90f763fd56cd	member	2024-02-26 11:34:15	2024-02-26 11:34:51
e9669773-dc16-4ba2-b04c-93e4e9ad6ed2	69e01f2b-91dd-4f35-9830-4cc59ed58d57	b108c58a-4722-4bb6-bf8e-d3486b06d900	member	2024-03-12 07:17:32	2024-03-12 13:07:57
94573c8f-d31c-4931-848b-0d4ca913cf35	69e01f2b-91dd-4f35-9830-4cc59ed58d57	728cb098-b1db-410e-94a4-d08a630d8076	member	2024-03-22 09:01:59	2024-03-23 18:43:37
6b7612ff-17b2-4252-bf18-7faabd0ecdcb	69e01f2b-91dd-4f35-9830-4cc59ed58d57	c662510d-a483-4da8-b9c4-96f2bb450a40	member	2024-01-25 07:27:22	2024-02-19 05:08:25
040c0c0a-c29b-420f-949d-c0b3032ba2f6	69e01f2b-91dd-4f35-9830-4cc59ed58d57	1e2957ac-522b-4d7a-bc6b-5c33ca78ecde	member	2024-02-20 04:16:53	2024-02-20 09:37:30
bf467630-7d6e-4050-9b29-e1557f42be6d	69e01f2b-91dd-4f35-9830-4cc59ed58d57	47e2ce69-9af9-4b6a-8c32-c1ef3bb659e1	member	2024-03-14 09:11:24	2024-03-22 07:28:46
91dea64c-d6e8-4805-a630-bc44c115b1f1	69e01f2b-91dd-4f35-9830-4cc59ed58d57	e5b526bd-4554-4b99-bf91-204c2583a5fa	member	2024-03-15 05:15:35	2024-03-22 07:28:42
b5ee9a74-2f90-4aad-80f6-a0d3c5493d4b	69e01f2b-91dd-4f35-9830-4cc59ed58d57	e23dd0b2-7699-4b27-9b31-7966d2d7376a	member	2024-02-20 09:30:57	2024-02-20 09:37:14
fcf90f74-e9f9-4d67-b9c6-aa11f8e7b355	69e01f2b-91dd-4f35-9830-4cc59ed58d57	e9c970a7-cd3b-452e-b6f7-70b9d9d60148	member	2024-04-02 12:39:37	2024-04-04 02:45:00
a55ec9a7-89f7-486d-a008-48ed59acc613	69e01f2b-91dd-4f35-9830-4cc59ed58d57	dbef37eb-d458-4df7-8085-e1621c5c6e1f	member	2024-02-19 19:27:59	2024-02-19 22:41:39
3fd499eb-1299-4351-8267-e51cbcb3c2a4	69e01f2b-91dd-4f35-9830-4cc59ed58d57	583dcdbe-fbdd-4ecf-800d-831c7f7716f9	member	2024-03-15 10:31:01	2024-03-22 07:28:39
632e96ba-d710-4950-834a-c617be8d37e2	e703bd05-a781-41ce-82b6-e0221018d631	4742c248-e7ae-4e74-b513-a66f6f86a66f	member	2023-11-23 08:51:19	2023-11-23 08:53:05
dcbc7d66-2c68-4ed6-9860-ffd4dfd731f6	e703bd05-a781-41ce-82b6-e0221018d631	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	member	2023-11-23 08:51:10	2023-11-23 08:53:13
10297058-a0bd-4eb8-8165-9d07bcabbad1	e703bd05-a781-41ce-82b6-e0221018d631	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	member	2023-11-23 08:51:07	2023-11-23 08:53:15
5414fdd4-e428-47b0-ac00-2bebcbb45fc3	e703bd05-a781-41ce-82b6-e0221018d631	87b40694-4414-4841-925a-176a00c7826a	member	2023-11-23 08:50:57	2023-11-23 08:53:18
b47c7911-4586-45c1-ae0b-adb3a93424ef	e703bd05-a781-41ce-82b6-e0221018d631	42e3166f-a80a-4120-b00f-22224f3248b1	member	2023-11-23 08:51:32	2023-11-23 08:52:58
c2c49c80-f9ac-4ad6-9dbd-6b4f7e0c5692	e703bd05-a781-41ce-82b6-e0221018d631	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	member	2023-11-23 08:52:48	2023-11-23 08:52:52
917aa502-47dc-41ef-ab9a-8f0a9140c1d1	e703bd05-a781-41ce-82b6-e0221018d631	5ed7695e-c900-4690-ab29-d4ecbc00d945	member	2023-11-23 08:51:49	2023-11-23 08:52:47
31764d66-035c-4f90-a4c0-efd9f91b39f9	e703bd05-a781-41ce-82b6-e0221018d631	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	member	2023-11-23 08:52:16	2023-11-23 08:52:44
35b65571-3bba-41f8-80a8-0154f469791b	e703bd05-a781-41ce-82b6-e0221018d631	7a19a677-5c7e-4efa-99aa-2d7a536f4ba9	member	2024-01-16 00:59:45	2024-01-16 01:02:20
6608cedb-f3e9-44b2-bf8a-8aaca120abf8	e703bd05-a781-41ce-82b6-e0221018d631	a6138b49-27ca-485f-ad57-12f6ed08e94b	member	2023-11-23 08:51:44	2023-11-23 08:52:50
53b2eefd-61b8-4e2c-975a-4d5c4ece082c	e703bd05-a781-41ce-82b6-e0221018d631	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	member	2023-11-19 09:14:11	2023-11-19 09:16:09
072ff04f-2ff9-4be2-8338-09863d65da27	e703bd05-a781-41ce-82b6-e0221018d631	75bc07bb-6b7a-4414-b064-9f0f7c086217	member	2023-11-23 08:51:14	2023-11-23 08:53:08
85e76cb3-9684-45d2-ba1b-ef3bdb0bd447	e703bd05-a781-41ce-82b6-e0221018d631	fb06de97-b722-4281-99cf-482d421bd4b0	member	2023-11-23 08:58:31	2023-11-23 23:27:12
f655d142-52f0-48d1-8e7e-5a8a39146b71	e703bd05-a781-41ce-82b6-e0221018d631	36fa3c27-a0c6-4407-a386-a0b57cbbd453	member	2023-11-23 08:51:10	2023-11-23 08:53:10
fc3d2c81-33ae-4b26-8827-1e28f2d64810	e703bd05-a781-41ce-82b6-e0221018d631	dae9be5f-69f8-4aba-8707-3974bd4edf02	member	2023-11-23 08:51:25	2023-11-23 08:53:03
cfe6e343-6609-4197-8eaa-488426c1bc41	e703bd05-a781-41ce-82b6-e0221018d631	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	member	2023-12-15 00:16:59	2023-12-15 00:21:02
be9451fb-bd06-4b97-849b-b643c2f3cb82	e703bd05-a781-41ce-82b6-e0221018d631	d15bfb61-8af0-49af-af82-24696cd922a9	member	2023-12-22 04:24:36	2023-12-22 04:26:34
be30372d-7701-40fc-8f75-198aa89f9bbd	e703bd05-a781-41ce-82b6-e0221018d631	5b316a00-25b2-4fd7-8796-5dbb7f51f948	member	2023-12-26 03:59:39	2023-12-26 04:00:15
a15f505e-e9d1-4c01-a936-5df31c4abbf5	e703bd05-a781-41ce-82b6-e0221018d631	5efc6baa-40ff-406f-aab6-3cd7e48a7f26	member	2023-11-23 08:51:30	2023-11-23 08:53:00
f7b0f626-afa8-467b-9805-bbf5e6ed19be	e703bd05-a781-41ce-82b6-e0221018d631	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	member	2024-01-09 05:23:32	2024-01-09 05:24:04
eccd3e1a-c9e1-4a73-b952-b89699a38b3f	f3173f6b-71d2-47c1-9768-4ed28d2ee620	f3173f6b-71d2-47c1-9768-4ed28d2ee620	admin	2024-03-21 05:32:21	2024-03-21 05:58:56
58fcb82c-901e-4b9d-9be3-c6c91da6dae3	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	admin	2023-11-24 03:34:41	2023-11-27 04:13:30
572ee874-870a-4f16-af3f-d983486761d6	5dc09e11-8310-4e6b-a8fc-250aadd1e2b2	5dc09e11-8310-4e6b-a8fc-250aadd1e2b2	admin	2024-01-26 02:41:21	2024-02-18 23:48:33
58682517-b5d5-43a7-ae34-ee6b59a4e307	ae7ec705-a261-4895-a223-3e6e0b0602b7	ae7ec705-a261-4895-a223-3e6e0b0602b7	admin	2023-11-16 23:24:55	2023-11-16 23:24:55
0cb774f2-41fe-4a02-a592-3294480fec44	dab9453b-a30d-44ec-a414-132e953c2408	dab9453b-a30d-44ec-a414-132e953c2408	admin	2023-11-13 01:49:29	2024-08-07 01:05:00
c778e290-9ff1-446f-9f30-44467b3f632b	69e01f2b-91dd-4f35-9830-4cc59ed58d57	69e01f2b-91dd-4f35-9830-4cc59ed58d57	admin	2023-11-28 07:02:25	2024-03-26 19:48:06
72f72b6e-f296-4f95-8e30-82f211f0d175	e6e68bd1-7618-4a50-95fb-904e3dc67a18	e6e68bd1-7618-4a50-95fb-904e3dc67a18	admin	2023-12-23 10:23:17	2023-12-23 10:23:17
cc0b9d08-eceb-4372-b4c8-adb97279ba8c	76736e86-2aae-40c3-905f-c9991c527424	76736e86-2aae-40c3-905f-c9991c527424	admin	2024-11-11 22:26:04	2024-11-11 22:26:04
1c0a5e16-fafb-4ac0-9a00-348ed3211364	e703bd05-a781-41ce-82b6-e0221018d631	e703bd05-a781-41ce-82b6-e0221018d631	admin	2023-11-19 09:10:00	2024-09-28 00:26:11
5a13c9b1-4783-4cb6-9929-428d8f2af649	cc00217b-f62e-45c5-a06b-16ab2da154b0	cc00217b-f62e-45c5-a06b-16ab2da154b0	admin	2023-11-28 07:11:10	2023-11-28 07:11:10
111c001b-f0fb-44be-a15b-092b946df2d3	e703bd05-a781-41ce-82b6-e0221018d631	28058267-5877-4bc2-a880-395176bd6b22	member	2023-11-23 08:51:42	2023-11-23 08:52:55
80301e21-4130-4c70-8864-4920fa74a7b4	c583a589-c6c8-4cfd-9470-d0a445109ef9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	member	2023-11-28 01:40:13	2023-11-28 01:40:52
f9b37f6e-2296-4fcb-9654-6ffc6c0a6695	454a1603-bd8c-4a65-a89f-b8cedd28dd76	f3a78141-9a77-4b27-998d-d2b4d366e088	member	2024-10-22 20:17:01	2024-10-27 15:31:24
cb85b612-eb7f-489a-9052-c0941d4eb0c1	454a1603-bd8c-4a65-a89f-b8cedd28dd76	072c2418-239b-4944-93f8-da9eb88be608	member	2024-11-05 23:28:59	2024-11-05 23:32:16
63280417-91a9-4220-86f5-b6b5c6e40277	454a1603-bd8c-4a65-a89f-b8cedd28dd76	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	member	2024-11-08 00:52:58	2024-11-08 00:54:44
50e36965-3b93-41c5-9ee5-4798a07321b5	454a1603-bd8c-4a65-a89f-b8cedd28dd76	06b9b48a-abaa-4d24-8ee9-d94d5ab0ec66	member	2024-12-05 00:03:00	2024-12-05 00:05:45
e116c817-8665-4426-a042-f01e8d50e45a	454a1603-bd8c-4a65-a89f-b8cedd28dd76	61b3566e-f3e2-4116-824b-0be7e6d5f9b8	member	2024-11-06 19:51:02	2024-11-06 19:52:34
0eb8daca-f488-4ff0-a78e-f208ac4e7bb2	454a1603-bd8c-4a65-a89f-b8cedd28dd76	f270fd28-1c02-46bf-ac9c-8179ed1185bb	member	2024-10-22 19:44:36	2024-10-27 15:32:02
18b5bf0d-7f76-4841-93b8-2cc6901c0f3b	454a1603-bd8c-4a65-a89f-b8cedd28dd76	1595e4da-60d8-4646-8dcc-c761e435937e	member	2024-11-07 01:37:01	2024-11-07 01:41:13
e68124f6-5c2d-4441-8767-623e562280a3	454a1603-bd8c-4a65-a89f-b8cedd28dd76	9079e6fb-d198-4c34-a483-39df60af375b	member	2024-11-06 22:46:30	2024-11-06 22:48:31
da2bfa90-7695-44e1-b6ce-2ca076fe8c82	454a1603-bd8c-4a65-a89f-b8cedd28dd76	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	member	2024-10-25 10:28:19	2024-10-27 15:31:30
ad02753f-81a4-4f50-8c4b-34dcfa9539fc	454a1603-bd8c-4a65-a89f-b8cedd28dd76	8afbe459-f864-4ad6-98b5-595ac422f0ef	member	2024-11-02 00:42:01	2024-11-05 23:08:05
dbe68909-b8f8-443c-9f10-19c7b4691bd6	454a1603-bd8c-4a65-a89f-b8cedd28dd76	c17ad9e2-f932-4dd7-950a-2bb25a9b0772	member	2024-11-01 00:22:40	2024-11-05 23:08:25
2ec01831-ecea-4687-8681-ab6036d93cf0	454a1603-bd8c-4a65-a89f-b8cedd28dd76	539dd60d-44d6-4808-a75d-976f4ff14489	member	2024-11-05 23:45:33	2024-11-05 23:53:49
712daaac-497e-498d-8c83-7dc63edb4150	454a1603-bd8c-4a65-a89f-b8cedd28dd76	407ae14a-060d-4d91-89d1-39535ab93b0a	member	2024-10-22 20:04:49	2024-10-27 15:31:39
79e0270f-aec5-40f6-a2e2-1ae230d92f9d	454a1603-bd8c-4a65-a89f-b8cedd28dd76	7e2a2c9f-ceee-43a9-8c22-b0e99af67bf0	member	2024-11-22 07:42:34	2024-11-22 23:20:35
8da36c4b-5159-4514-b3dd-623c8a2d4037	a1980849-8063-40f4-93e8-4de3842911b0	f7578885-4640-41c2-9831-c994c131ab57	member	2023-12-01 03:38:21	2023-12-01 03:43:25
715a7e87-fc61-4d6d-8e7b-285091ab6e76	be269914-8f65-4e4c-b3c5-b02313f8b4ac	e667a7c4-c9a8-4e66-9401-ac2577b19aec	member	2024-01-15 07:51:04	2024-01-18 01:39:55
17648c38-56b3-402f-b1ef-fafa788874cf	835889ef-7e95-4dc9-9930-c517ec555496	c1667389-c459-4ecc-a759-cd2b0d69d687	member	2024-01-15 03:04:44	2024-01-15 03:23:03
255d361b-1547-46d3-b510-fc81b3f8e353	835889ef-7e95-4dc9-9930-c517ec555496	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	member	2023-11-22 02:40:43	2023-11-22 02:41:32
\.


--
-- Data for Name: persona_profile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.persona_profile (id, persona_id, display_name, profile_image_url, description, email, phone_number, website, tags, created_at, updated_at, email_shown, phone_number_shown) FROM stdin;
747f2195-e1da-4fea-99b6-2fce036b0413	1bc05a7f-1d0d-4b83-9604-a60579a3a2a7		\N		aromarjaimes@gmail.com	\N	\N	{}	2024-04-16 14:04:51	2024-04-16 14:04:51	t	t
59afbc04-de57-43ee-ac0c-0e6142dac092	2d52f184-3c0c-400c-bf64-5a7f9d777394		\N		reyesjrruperto81@gmail.com	\N	\N	{}	2024-05-07 15:05:53	2024-05-07 15:05:53	t	t
ee9e4eb2-ce4c-4200-8af1-4c8d4ec861d2	0c7eb249-08f8-4c51-9593-a767da6f91d1		\N		gkarunakarkarunakar7@gmail.com	\N	\N	{}	2024-05-17 10:30:57	2024-05-17 10:30:57	t	t
8b8bfd71-2389-4173-98ef-7f1bf5f06477	4c628453-6891-452c-ab9a-de85815a83eb	구모세	\N	감정과 이야기를 시각적 언어로 표현하는 전문 예술가입니다. 다양한 매체와 스타일을 실험하며, 창의력과 예술적 통찰력을 공유합니다.	3866193517	01056065774	\N	{}	2025-01-06 05:10:57	2025-01-06 05:10:57	t	t
c8590088-8cfe-4a2d-b77e-8085e722fafa	1666014e-afa9-4826-aeb6-9146cfd7e449	UTTAM SARKAR	\N		sarkaru979@gmail.com	8335825187	\N	{}	2024-07-09 20:57:58	2024-07-09 20:57:58	t	t
33f43a3c-de10-4c21-bb64-5b1932caace6	f5878b9c-e537-4e5d-a130-b5ff56be0fdc	Ram line ke sath mein hi	\N		layankeram@gmail.com	7698807726	\N	{}	2024-07-10 21:19:23	2024-07-10 21:19:23	t	t
9546298c-2ecd-432b-8921-ddd54a40282e	5ed8d23d-49b9-433a-9d52-6e24c50d3455	Rohir	\N	I am a businessperson with an exceptional ability to turn visions into reality. I pioneer new markets with innovative ideas and strong business strategies.	rhoit9965@gmail.com	8146525023	\N	{}	2024-07-12 12:14:45	2024-07-12 12:14:45	t	t
ae68fc5c-c1cf-43e9-8e9e-8faaed501106	7bd7d403-47e5-4459-8aef-43a51a83c747	dayaram	\N		mdayaram717@gmail.com	9799635592	\N	{}	2024-07-28 15:05:18	2024-07-28 15:05:18	t	t
7c70a9a7-52ea-4cdc-8112-db469f9b88e5	07e5e67e-c5e8-4423-98c0-ec12c14cbdff	Emraan Hashmi	\N	मैं एक विपणन विशेषज्ञ हूं जो ब्रांडों के मूल्य को रचनात्मक और रणनीतिक सोच के माध्यम से बढ़ाता है। मैंने सोशल मीडिया, कंटेंट मार्केटिंग, और बाजार विश्लेषण में अनुभव प्राप्त किया है।	sultan.amethi433@gmail.com	9125037433	\N	{}	2024-07-09 19:32:57	2024-07-09 19:32:57	t	t
9ba3dbb3-e5f7-4cf9-b585-cfdbc8be949e	fa064d88-998d-4c55-be48-82ab58416db4		\N		pd651194@gmail.com	\N	\N	{}	2024-05-26 16:10:33	2024-05-26 16:10:33	t	t
ba589588-b347-487b-adca-4813b1ad0e00	68060645-8640-40ae-9c9e-3dfee802499c		\N		krrcollegework@gmail.com	\N	\N	{}	2024-06-08 11:40:22	2024-06-08 11:40:22	t	t
72bd9072-9c2a-4165-975f-096c4023d4ec	72c05370-408a-4b24-b035-49d9957fa4bf		\N		dsingh1919@gmail.com	\N	\N	{}	2024-07-09 10:26:43	2024-07-09 10:26:43	t	t
3354fc5e-8514-48be-a164-4dc2a8b968ca	0f7ed2fe-27c8-476d-9576-e71b855033a6	nihaluddin	\N		nihaluddin229@gmail.com	9927828581	\N	{}	2024-08-10 08:19:57	2024-08-10 08:19:57	t	t
17b3ddc2-bb3c-410b-9529-3d4f6cadfa53	a9ccf2a4-4f22-478d-97b9-b8296d74ada3		\N		d13198696@gmail.com	\N	\N	{}	2024-02-17 09:36:39	2024-02-17 09:36:39	t	t
910d625a-1796-439c-8bdc-98bffcd42ad0	48f65faa-3da4-4552-9a5b-2448cbbb01dd	Devendra upadhyay 	\N		rampurkala2017@gmail.com	9436223544	\N	{}	2024-07-09 08:26:08	2024-07-09 08:26:08	t	t
b9cb83f4-b6c1-4c5f-abce-ae24584f0471	619e5340-946f-4ebc-a130-62af23582a69	ompqkash	\N		kushvahomprakash845@gmail.com	8502021283	\N	{}	2024-07-16 11:05:18	2024-07-16 11:05:18	t	t
b89c1663-6b93-4ab1-9757-d0d242d1a45a	2291bd25-243d-4010-95a1-3762317772f2	सुधाकर मारोती राठोड 	\N		sudakarrathod417@gmail.com	8767277073	\N	{}	2024-07-14 00:00:11	2024-07-14 00:00:11	t	t
b9776af3-cfd3-4f1b-80bd-b2cef8bae2b1	969d10d5-2c1b-47c0-b79f-b2d5f2391cc9	arlyn	\N		gabrielarlyn383@gmail.com	9614332017	\N	{}	2024-02-21 05:27:34	2024-02-21 05:27:34	t	t
3afe52c5-697a-40ba-909b-3d7eb86a786b	f58db1a0-bd01-45b1-adbd-a44e34727972	Gkrishna 	\N	I am a professional chef who captures hearts with cuisine that combines tradition and innovation. I pursue cooking that balances taste, health, and aesthetics.	gkrishna8889@gmail.com	7997567586	\N	{}	2024-06-17 10:21:21	2024-06-17 10:21:21	t	t
b813289e-c712-4795-9d01-033962d3ed97	22db4f8d-e65c-49b3-b961-4a2dc7aa717f	tinnnn	\N	I am a professional chef who captures hearts with cuisine that combines tradition and innovation. I pursue cooking that balances taste, health, and aesthetics.	christinsalvador@gmail.com	9093792003	\N	{}	2024-04-02 11:37:43	2024-04-02 11:37:43	t	t
72d46329-14d2-4d70-869c-c055e3a31bb7	0269f008-74dc-4e1a-8978-92de25c8f586		\N		gajendrayadavaabhisekakumara@gmail.com	\N	\N	{}	2024-07-11 08:48:51	2024-07-11 08:48:51	t	t
44df1900-e07d-452f-827e-bef14643722a	eba1380d-8516-4319-886e-903f811c6751		\N		sameerali875534@gmail.com	\N	\N	{}	2024-07-10 10:38:26	2024-07-10 10:38:26	t	t
5cf96760-094b-4348-ad40-30364e45d222	eafc7f99-c36f-4653-9bb2-230114aa4c48		\N		vs1212308@gmail.com	\N	\N	{}	2024-07-15 01:50:43	2024-07-15 01:50:43	t	t
ad2765a9-85bf-4f48-9bd6-341b620703d4	3211f61c-960e-40dc-932a-1f5241d808f2	surajit	\N	I am an experienced internist with over 10 years in the medical field. I prioritize patients health and always stay informed about the latest medical research and treatments. I look forward to sharing knowledge for a healthy life.	surajitmajhi22663@gmail.com	9265984359	\N	{}	2024-07-09 20:22:53	2024-07-09 20:22:53	t	t
6c942ad2-4cfa-4ee3-9d5e-0ad308af5d3b	75bc0d40-b032-4ad8-92a7-1ecbcf1944d0	NGUYỄN THANH 	\N		nguyenvanthanh1951hphp@gmail.com	0862527258	\N	{}	2024-03-13 22:24:06	2024-03-13 22:24:06	t	t
23697713-b2d3-4dd0-b64a-e79128b56533	2ab1fd33-9b04-482b-8c6f-365c9f03a94c	nguyentuanmanh	\N		nguyentuanmanh456@gmail.com	396055178	\N	{}	2024-03-29 13:50:40	2024-03-29 13:50:40	t	t
4634cace-8eef-4a1b-9b12-5e93fbccceb7	b1c3ad22-78a0-42a2-abc8-2bc0f3d8c24c		\N		abhamaid4@gmail.com	\N	\N	{}	2024-07-26 12:26:40	2024-07-26 12:26:40	t	t
0517526c-0dd6-4544-a275-724143236dbd	80d50a82-65db-4ce9-bf3e-e679c14b6765	남선혜	\N	전통과 혁신을 결합한 요리로 사람들의 마음을 사로잡는 프로페셔널 셰프입니다. 맛과 건강, 미학이 조화를 이루는 요리를 추구합니다.	nsh704@hanmail.net	01089941879	\N	{}	2024-02-19 10:54:50	2024-02-19 10:54:50	t	t
1dbb6db3-d7fe-486b-96e5-8e82eb42e9d5	682b2001-13bd-4562-8bec-240532e430c8	richelle	\N		floreschelle67@gmail.com	9637195892	\N	{}	2024-03-27 19:40:48	2024-03-27 19:40:48	t	t
6fbeaa67-75b9-4977-a473-44e383920c69	c54cabc6-ac33-4868-8044-b5c44375b239	Anton 	\N	I am a professional chef who captures hearts with cuisine that combines tradition and innovation. I pursue cooking that balances taste, health, and aesthetics.	antonieto@gmail.com	9610349365	\N	{Aj}	2024-02-20 12:07:07	2024-02-20 12:07:07	t	t
ef665cdf-8a4f-4c8b-9f03-3b8bc93b56b4	8812812f-8bbf-4ae2-914a-b8cae24cdbcc	곽현혁	\N	전문가 소개	khhkhh@gmail.com	1064774123	\N	{블록체인,프로그래머}	2024-02-19 07:02:01	2024-02-19 07:02:01	t	t
2fd15d2f-d95c-4287-83e8-d25efd0c8598	080b5059-2b5b-42f9-8b18-443d06243138		\N		goodhart01004@gmail.com	\N	\N	{}	2024-08-30 02:43:12	2024-08-30 02:43:12	t	t
6dfacf49-d43a-47f5-9aa6-7e3ebb02f2d8	30ef6f0f-9149-49a8-9761-36ce2fcf7e21	lưu hiệp anh	\N		vanhiepluu543@gmail.com	0343127675	\N	{}	2024-04-30 21:27:47	2024-04-30 21:27:47	t	t
21269f41-3675-431a-a782-d5ef40da0d1f	71e17c65-071a-4d64-a088-87926bfe0751		\N		3164317172	\N	\N	{}	2023-11-15 10:47:18	2023-11-15 10:47:18	t	t
e0423cc1-bfc9-4975-a114-9e9d317ae03e	16fc1d80-fe27-4ba1-85c4-8f37959f145d		\N		sohosua@gmail.com	\N	\N	{}	2024-06-10 06:46:23	2024-06-10 06:46:23	t	t
4dde8235-b91e-4bb5-b12a-b51c6893c318	dbc18365-0064-48a1-a511-f11f56929643	nhung	\N	Tôi là một kiến trúc sư sáng tạo tập trung vào thiết kế kiến trúc hiện đại và bền vững. Tôi nỗ lực thực hiện ước mơ của khách hàng bằng cách kết hợp vẻ đẹp và tính năng của không gian.	tandothi476@gmail.com	0913721482	\N	{}	2024-03-14 16:37:18	2024-03-14 16:37:18	t	t
2870b910-f162-4f76-a7c5-d4510701f5ae	16a4ccff-4739-402d-b675-67fafdda2151	신은식	\N		sin1234@naver.com	01012345678	\N	{}	2023-11-14 05:18:47	2023-11-14 05:18:47	t	t
f50d368f-f216-43e2-b4b6-5b8d3ef45c67	268b78d3-4ece-4520-b8eb-c1bda8574617	민성욱	\N	최신 IT 기술과 트렌드에 정통한 IT 전문가입니다. 클라우드 컴퓨팅, 사이버 보안, 데이터 분석 분야에서 두각을 나타내며, 디지털 혁신을 추구합니다.	chungyoun@gmail.com	01022643338	\N	{딥러닝,빅데이터,스타트업,인공지능}	2024-03-09 00:02:15	2024-03-09 00:02:15	t	t
9fdf8927-b3e3-4848-8aee-5cb7d716ec8c	54480456-85d1-42dd-8fb3-dc5265e5dea4		\N		3351196884	\N	\N	{}	2024-02-19 11:51:01	2024-02-19 11:51:01	t	t
b824d69b-4179-4891-be37-297815ca504e	bc34840e-466d-4ce5-b98f-141437b9df7b		\N		xmartomkarprajapati@gmail.com	\N	\N	{}	2024-07-23 11:20:40	2024-07-23 11:20:40	t	t
e2d98fbe-c627-4e58-8134-ac27b1b9c82a	d76592e5-a0c2-4e04-bca6-34e3d9995fce	정세연	\N		natural7009@gmail.com	1039517006	\N	{}	2024-03-14 12:38:58	2024-03-14 12:38:58	t	t
9ccc53d2-96cf-461b-a7e8-8548fbd98bb9	fdc0fa75-740c-47b1-b6ba-20addb267e43	lê thị thúy	\N	Tôi là một bác sĩ nội trú giàu kinh nghiệm với hơn 10 năm trong lĩnh vực y tế. Tôi ưu tiên sức khỏe của bệnh nhân và luôn cập nhật các nghiên cứu và điều trị y khoa mới nhất. Tôi mong chờ được chia sẻ kiến thức cho một cuộc sống khỏe mạnh.	lethithuy71188@gmail.com	0358681444	\N	{}	2024-03-26 01:37:38	2024-03-26 01:37:38	t	t
f672951c-db1e-496d-abe6-a0b465d096f1	c01b8fb5-23b9-4268-9cb5-c5213d2e6590	virender2652@gmail.com 9170857639	\N	I am a passionate mechanical engineer who develops innovative technological solutions. I focus on sustainable design and efficient process improvement, and enjoy new technological challenges.	v82165980@gmail.com	9170857639	\N	{1234}	2024-08-14 12:10:11	2024-08-14 12:10:11	t	t
572f8e19-50a5-4f31-bdc7-d2a6954ddad2	c49b0596-f8b6-4749-9035-4cfe7084d1b1	이혜숙	\N		3437058975	01043231174	\N	{1}	2024-04-14 19:59:10	2024-04-14 19:59:10	t	t
e553f21d-8ca4-4f06-975f-b419af92991e	c823d629-1839-40cd-b697-4a46afc7e0d5		\N		pedireaquilino4@gmail.com	\N	\N	{}	2024-03-14 23:28:06	2024-03-14 23:28:06	t	t
92491b52-283c-483e-b906-0a0b4422f2e5	55003ec2-9c01-4edb-84a7-f86350a42154	pham thi hien	\N	Tôi là một giáo viên nhiệt huyết giúp học sinh phát huy tối đa tiềm năng của mình. Tôi nhằm nâng cao trải nghiệm học tập thông qua phương pháp giáo dục đổi mới và công nghệ.	hienndh12@gmail.com	905662711	\N	{}	2024-04-05 01:41:43	2024-04-05 01:41:43	t	t
f9af3ddd-b304-424c-808d-b39049a083f4	e0644fd2-b5df-49ef-a9b4-3a887f2d086e	박진용 Jinyongpark 	\N		3328314674	94153390	\N	{}	2024-02-04 01:55:06	2024-02-04 01:55:06	t	t
f35ae4b3-2b8b-49b4-8aa7-d3b0050a466a	d0a3e885-59f6-435d-957e-512de31ecfbc	Zim v indea	\N	I am a marketing expert who enhances the value of brands through creative and strategic thinking. I have gained experience in social media, content marketing, and market analysis.	rajeshbadjayta@gmail.com	9805232957	\N	{}	2024-07-12 16:53:08	2024-07-12 16:53:08	t	t
c7a9368e-1498-4b83-8451-6f19e8794b4b	47ca2d7a-cd70-4627-967b-88d22c0ef0bd	AppleJohn	\N			0101111222222	\N	{}	2024-03-07 13:33:44	2024-03-07 13:33:44	t	t
b6b8575c-4831-458d-9957-9f80ea8ef224	3d04187a-9dea-431d-9bec-a4a262dc977b		\N		3421824175	\N	\N	{}	2024-04-04 15:23:50	2024-04-04 15:23:50	t	t
c6744af2-cfda-4528-aa36-0e4d53b8350f	4e2bc8e4-d7fa-4757-adec-22c5c62d9b69	김광평	\N		pyeong9246@naver.com	01023549246	\N	{}	2024-02-08 00:06:36	2024-02-08 00:06:36	t	t
b587c1f1-7a1e-4b31-9518-7d242ebcc71c	c97bb436-c55e-4222-a494-49af4ac02b31	이주형	\N	Trend Reader. 샘표식품을 거쳐 AI, 빅데이터 전문기업 ‘바이브컴퍼니’(구 다음소프트)에서 소셜빅데이터 분석 및 활용법을 공유하고 있다. 현재 마케팅 뉴스레터 ‘위픽레터’, 글로벌 미디어 ‘모바인사이드’ 등에서 초빙 필진으로 활동하고 있다	ejuhyle@gmail.com	01037626954	\N	{trend,마케팅,작가,트렌드}	2024-05-05 01:26:53	2024-05-05 01:26:53	t	t
4ae8b6ea-2a60-47f2-a037-931183fbd9cc	728cb098-b1db-410e-94a4-d08a630d8076	이은령 	\N	골프의류 시보리전문	eun9218@naver.com	01062789218	\N	{제조}	2023-11-23 08:26:02	2023-11-23 08:26:02	t	t
9a52acf7-da9d-4ef6-95f6-f821b415f992	699de247-c0c8-4a8b-bae8-6ba24d9489c1	강민수	\N		buddyhi@naver.com	01084817351	\N	{비스포킷}	2023-12-24 04:14:21	2023-12-24 04:14:21	t	t
2a40019b-6191-44e7-8bb4-09b8d8b84e92	8763bfc4-c0cc-45cf-b4d6-3437e2e2415f		\N		3471747606	\N	\N	{}	2024-05-07 15:17:12	2024-05-07 15:17:12	t	t
b155f73e-4afc-4e71-ad82-574e4b695b9c	f404a098-91e6-4b18-a6c8-280913485d8b	김주환	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	3408775662	8587548,	\N	{}	2024-03-26 14:38:42	2024-03-26 14:38:42	t	t
466a610c-491c-41b9-9643-e72d6c8cc597	b108c58a-4722-4bb6-bf8e-d3486b06d900	오건선	\N	주얼리 세공, 종로 주얼리 공장 운영 - (제조업, 도매업, 소매업)	theredstone@naver.com	1088926137	\N	{귀금속,금,악세사리,주얼리}	2024-03-12 07:12:54	2024-03-12 07:12:54	t	t
8b5a7659-e892-4037-a10b-c666fcd54e11	497df9f0-8a3f-4bb8-9f7c-17fdbacf1534	강인철	\N	법률 분야에서의 깊은 지식과 15년의 실무 경험을 바탕으로, 복잡한 법적 문제에 대한 명확하고 실용적인 해결책을 제공합니다. 상업 법률, 지적 재산권, 민사 소송에 특화되어 있습니다.	kangprose@gmail.com	01028905616	\N	{변호사,하동}	2025-01-08 05:44:08	2025-01-08 05:44:08	t	t
85ca0652-f1b8-41e9-9c3b-d44e76ad9cdf	5846ade9-c2a3-4042-b036-4a0e3e88a907		\N		3255855457	\N	\N	{}	2024-01-04 01:49:03	2024-01-04 01:49:03	t	t
9895b08a-476b-4a19-a5ea-855698b40091	8c26dc0e-b249-4ad7-a217-344bb1711334		\N		vyasseema606@gmail.com	\N	\N	{}	2024-06-17 08:55:50	2024-06-17 08:55:50	t	t
e9979ca1-573f-4e40-9a68-94fb632d7a75	ba315088-cb20-4a99-b6e2-162225ab4a35	dingdolosa	\N		dingpintodolosa@gmail.com	09925849800	\N	{}	2024-02-20 13:20:13	2024-02-20 13:20:13	t	t
95469176-a13e-4b01-8245-d60f34a37dba	cbb8fed9-d001-4cee-8109-bf79977e0b94	shailendraind883966477924may	\N	I am a passionate mechanical engineer who develops innovative technological solutions. I focus on sustainable design and efficient process improvement, and enjoy new technological challenges.	shailendrabundela65@gmail.com	8839664779	\N	{}	2024-08-11 16:26:45	2024-08-11 16:26:45	t	t
9bbdcedc-fc2d-4025-89e8-8479e909e839	a524752c-d860-44fd-b3b2-5cf6fdf75919		\N		vipulberam5@gmail.com	\N	\N	{}	2024-06-19 15:25:21	2024-06-19 15:25:21	t	t
f8752764-524f-49a4-82a4-dab455a55a91	12f8683d-d1eb-4e71-b60f-75df4e0f8169	최윤정	\N		sunone65@nate.com	01062037527	\N	{}	2024-04-17 12:50:50	2024-04-17 12:50:50	t	t
6985a8f0-b08c-4a74-9898-f9c0a69cdc79	b3d18ee7-428d-4c05-8795-c0fe0a3326be	mansingh	\N	I am a businessperson with an exceptional ability to turn visions into reality. I pioneer new markets with innovative ideas and strong business strategies.	singhman49861@gmail.com	9805085856	\N	{}	2024-07-15 14:35:33	2024-07-15 14:35:33	t	t
e43e186a-d1ee-44fc-9f20-0c98ffd2ab94	983918ad-2a80-4cd2-8614-3aaae25ad3a2	mohd yunus	\N	I am an experienced internist with over 10 years in the medical field. I prioritize patients health and always stay informed about the latest medical research and treatments. I look forward to sharing knowledge for a healthy life.	ia8021455@gmail.com	9927075147	\N	{}	2024-08-13 10:50:10	2024-08-13 10:50:10	t	t
e90029d4-dbaf-4e6d-b4fa-f8501801198b	5001b2bc-0e2a-4026-b3d7-94e5d7bbdab8	Natty	\N	I am a marketing expert who enhances the value of brands through creative and strategic thinking. I have gained experience in social media, content marketing, and market analysis.	indaynaty082057@gmail.com	094790869*	\N	{}	2024-06-15 10:35:43	2024-06-15 10:35:43	t	t
e1841bcb-7156-4f1b-a53e-082dac733aa9	8e0f5e35-28db-4af3-94cb-d20c6085964d		\N		ksatish23102@gmail.com	\N	\N	{}	2024-02-17 11:47:19	2024-02-17 11:47:19	t	t
be02749e-0e43-49e9-9cc7-64898e1524cd	58ed4da8-415a-4333-aa80-0c32a7df552c		\N		rajabahi74216@gmail.com	\N	\N	{}	2024-07-11 16:48:02	2024-07-11 16:48:02	t	t
30049938-537e-409f-bac8-1d2c98ef861f	5e34d15c-b933-4228-8e65-d07c1603638a		\N		purihappy351@gmail.com	\N	\N	{}	2024-08-09 07:07:34	2024-08-09 07:07:34	t	t
3091d302-518b-4e74-9240-7616f293c625	731e8f75-6cb8-478c-8515-afa21cf3f4ba	천혁진	\N		muvichum@hanmail.net	1090749851	\N	{}	2024-12-05 09:29:11	2024-12-05 09:29:11	t	t
d9e267cc-7f18-454d-9d80-805fefd91249	30d8b69f-293d-4141-b14c-fb1778ed3183	이재일	\N	최신 IT 기술과 트렌드에 정통한 IT 전문가입니다. 사이버 보안 분야에서 활동해 왔으며, 디지털 혁신을 추구합니다.	jilee0218@naver.com	01065652413	\N	{}	2024-08-30 00:10:15	2024-08-30 00:10:15	t	t
6c51e068-da39-489c-842e-6434f812ecff	8d376618-ce43-42a3-aa6e-4a7a3cd11f36	이창환	\N		seoulm37@gmail.com	01020703702	\N	{}	2024-02-02 01:06:49	2024-02-02 01:06:49	t	t
dfd7dbd4-c922-404c-a468-25d1c4447bc8	6ed085db-824f-4698-a99b-e2a4d9bd0fdb	Mayar	\N		mayarmiral26@gmail.com	0658800379	\N	{}	2024-10-01 18:41:17	2024-10-01 18:41:17	t	t
b8881518-4b62-45ff-bf20-a50bd16f04a5	871db774-f57e-4830-813c-76fc414d2d7b	रवि	\N	I am an experienced internist with over 10 years in the medical field. I prioritize patients health and always stay informed about the latest medical research and treatments. I look forward to sharing knowledge for a healthy life.	rajaputapavana14@gmail.com	7241155364	\N	{}	2024-08-14 07:42:33	2024-08-14 07:42:33	t	t
f9553247-2027-4b94-851d-a9bc763a8c04	11268002-f611-4176-a889-ce915ecec81e		\N		3326775265	\N	\N	{}	2024-02-02 22:30:50	2024-02-02 22:30:50	t	t
3942d437-617c-4467-af4b-0ef64497df6c	d883e98c-2acf-4569-9e6b-8449e8a8d67c	 संतोष। गरवाल	\N		santosgarwal20@gmail.com	9303296997	\N	{}	2024-08-08 14:34:52	2024-08-08 14:34:52	t	t
ad74cf61-9dae-4992-93c1-4e5cfc5558ff	333384ff-45eb-42ce-9e37-4c32e85ad9b5		\N		maniramakrsnakumara@gmail.com	\N	\N	{}	2024-07-27 10:17:47	2024-07-27 10:17:47	t	t
c0e54e3a-f031-4625-9a43-274f631e2e3c	ca576d45-6769-4d6e-b2a5-a094c8f3f6af	반재봉 	\N	철강재 유통전문가, 중장비부품 제조 수출 전문가	ban767622@naver.com	01052247676	\N	{}	2024-03-25 07:24:39	2024-03-25 07:24:39	t	t
91057f53-07ed-4357-b753-5a268602a129	47566cba-815a-4691-a5ef-d0c6165c9ef1	गोपाल 	\N	मैं एक पेशेवर शेफ हूं जो परंपरा और नवाचार को संयोजित करके व्यंजनों के माध्यम से दिलों को जीतता हूं। मैं स्वाद, स्वास्थ्य, और सौंदर्य के संतुलन वाली खाना पकाने का पीछा करता हूं।	gopalparmargl1977@gmail.com	9981793807	\N	{}	2024-07-13 06:06:55	2024-07-13 06:06:55	t	t
c9f2709f-fd01-428c-abb0-5667e6178d9b	76b7ca6b-ccd6-4c2f-a95f-efa65a02b1e9	Phước 	\N	Tôi là một đầu bếp chuyên nghiệp chinh phục trái tim mọi người với ẩm thực kết hợp truyền thống và đổi mới. Tôi theo đuổi việc nấu ăn cân bằng giữa hương vị, sức khỏe và thẩm mỹ.	55huynhthanhphuoc@gmail.com	905307792	\N	{}	2024-04-01 09:11:13	2024-04-01 09:11:13	t	t
24de6d91-09d9-43b6-b6d1-378e0e6e5937	ccd77641-e05b-4160-8b88-90f763fd56cd	한기철	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	bbosu199@naver.com	1082401009	\N	{미성E&C}	2024-02-26 11:29:52	2024-02-26 11:29:52	t	t
a0f7f2d1-c14b-4a9a-a5e1-34bdaf9c1438	1f53a0b4-8d5a-44f3-9718-f88a9e21b804	umesh	\N		umeshpatel1361@gmail.com	771073079080228	\N	{%}	2024-08-08 12:31:06	2024-08-08 12:31:06	t	t
273a4554-e4d3-4a7e-815f-f3c1993c4abb	eca91a2a-4cb5-4984-b0f8-f4c4b1393bd3		\N		nantusk0924@gmail.com	\N	\N	{}	2024-07-12 00:55:14	2024-07-12 00:55:14	t	t
c58514ae-0d12-4d45-a1bb-16084baf3eec	2bd9cad4-e12c-4949-9a91-33a8a4e3526a	नरसाराम	\N	मैं एक पेशेवर कलाकार हूं जो भावनाओं और कहानियों को दृश्य भाषा के माध्यम से व्यक्त करता है। मैं विभिन्न माध्यमों और शैलियों के साथ प्रयोग करता हूं, रचनात्मकता और कलात्मक अंतर्दृष्टि साझा करता हूं।	narshiramjat0538@gmail.com	8107652684	\N	{}	2024-08-03 19:22:57	2024-08-03 19:22:57	t	t
b1517426-842a-4640-af0f-d2625124b91a	f4aefeb2-29ec-4a74-8b7d-0df5b71eb9b3	GinaR Hinanay	\N		ginahinanay60@gmail.com	9151286205	\N	{}	2024-03-14 12:42:51	2024-03-14 12:42:51	t	t
3cfd3199-0795-495a-8dc5-b2a465893a94	88256607-f7da-41b0-8845-f75c3ec47282	vũ thị lợi	\N		vuloi4636@gmail.com	033589339	\N	{}	2024-04-14 23:55:19	2024-04-14 23:55:19	t	t
b515851d-3a03-4997-b47a-82ec024b873e	ef156cb0-6ced-4764-a69d-737d1e30fe40	강공희	\N		3329886032	01036990801	\N	{}	2024-02-05 03:15:21	2024-02-05 03:15:21	t	t
7fa70c18-2104-430a-9b37-bea0386114c9	2622d9e9-a235-40cc-ad43-d394b179c5db		\N		bbhd535@gmail.com	\N	\N	{}	2024-03-14 15:26:21	2024-03-14 15:26:21	t	t
2d430c44-f141-4cf9-9ecf-fb455d5d9c0a	d8fe116d-5c6f-4a39-bdd0-cc6dcfdcdbc1	पायलट मीणा रामगढ़ पचवारा	\N		payaletamina6@gmail.com	9001664265	\N	{}	2024-07-30 17:26:11	2024-07-30 17:26:11	t	t
592b0ad1-be4b-41e2-ba18-97261ac8ec75	75289381-d857-43a9-847f-680f0cc6fa37	Ramlumar	\N	I am an experienced accountant who provides accurate and reliable financial management. I have expertise in financial analysis, tax planning, and auditing across various accounting areas.	ramk2160139@gmail.com	7986948553	\N	{}	2024-08-12 15:15:07	2024-08-12 15:15:07	t	t
bce0ad69-89e5-4c94-98d2-c9b1923bc7b8	0493a2f5-d743-4dca-80b5-0710741c864d	raghav david 	\N	मैं एक पेशेवर कलाकार हूं जो भावनाओं और कहानियों को दृश्य भाषा के माध्यम से व्यक्त करता है। मैं विभिन्न माध्यमों और शैलियों के साथ प्रयोग करता हूं, रचनात्मकता और कलात्मक अंतर्दृष्टि साझा करता हूं।	sssskbaba2324@gmail.com	9131445387	\N	{maksi,"maksi ","yass "}	2024-08-09 16:54:56	2024-08-09 16:54:56	t	t
b42d6fed-4c69-408c-9f03-6f72d1c90d42	e93e5575-697d-4814-bc66-66b6d5d08f2d	김기환	\N		itconsult@hanmail.net	01043191422	\N	{보안컨설팅,연구,정보보안,정보보호}	2024-01-18 00:23:43	2024-01-18 00:23:43	t	t
1ce77de2-f0f2-48a9-89f5-9a337099e52d	d31ebfd1-5791-4738-b730-030aa46def6e		\N		riverohenri812@gmail.com	\N	\N	{}	2024-03-25 05:42:56	2024-03-25 05:42:56	t	t
6fc50893-15b9-4851-aa48-6053c15581b0	791a51d5-9ab3-48e0-a91b-94cbf1995686	anil Rathod	\N		kiranrahodrathod@gmail.com	9265120963	\N	{}	2024-08-11 00:25:02	2024-08-11 00:25:02	t	t
8d242903-4447-481e-944b-b22dac6713b8	0ae6059c-68b6-43d1-b239-e260d05649ab	Pritam Rana 	\N		pritamrana2020@gmail.com	9805063593116	\N	{}	2024-06-17 16:52:46	2024-06-17 16:52:46	t	t
e8e4fdfb-d68c-4e50-bd83-3a4c14436cda	e5b14590-cac0-4c92-a158-8a423c258ca0	ഗോപാലകൃഷ്ണൻ. a	\N	I am a businessperson with an exceptional ability to turn visions into reality. I pioneer new markets with innovative ideas and strong business strategies.	agopalakrishnan492@gmail.com	8086685142	\N	{}	2024-06-21 03:40:20	2024-06-21 03:40:20	t	t
bb4fc815-41aa-4e10-8e36-fe8362b793a3	f61be07d-fd05-4106-b173-2c1975e711ea	मेहन्त उगमा राम जी महाराज 	\N	मैं एक व्यवसायी हूं जिसकी असाधारण क्षमता है दृष्टिकोणों को वास्तविकता में बदलने की। मैं नवीन विचारों और मजबूत व्यवसाय रणनीतियों के साथ नए बाजारों का पथ प्रदर्शक हूं।	ugmarammaharaj@gmail.com	9784585568	\N	{}	2024-07-28 16:47:59	2024-07-28 16:47:59	t	t
06e6a396-d190-4e4e-980c-462f99c28a98	e076e1f1-390c-4152-bf95-edb2a4a81ab8	Pramod	\N	I am a marketing expert who enhances the value of brands through creative and strategic thinking. I have gained experience in social media, content marketing, and market analysis.	pramodkumarsharma23129@gmail.com	993527172813121312	\N	{}	2024-02-17 08:20:14	2024-02-17 08:20:14	t	t
7a20ef8d-21a5-4b66-a163-0ac99a776dc3	712fe4b5-f3cf-40f2-aadc-c867df55ab3b	nisarta  pinal	\N		nisartananjibhai@gmail.com	9727600425	\N	{1}	2024-08-19 16:08:30	2024-08-19 16:08:30	t	t
c60ff13e-864a-44db-9c16-7eac58232081	383d76af-4c95-4cb2-b6ee-fd0bb315bdb4		\N		3351518584	\N	\N	{}	2024-02-19 15:56:56	2024-02-19 15:56:56	t	t
587bef6c-e23e-4e83-ad4e-b59145a9588d	6cd9336a-3ad9-4d46-bdd2-d52cdce84b86		\N		pc074110@gmail.com	\N	\N	{}	2024-07-14 08:43:39	2024-07-14 08:43:39	t	t
c25a77e8-3304-44e8-bfe6-28ae66e198b8	cb2eba6c-4cf4-4b8f-a171-d01bd2c09e75	everland 	\N		paliareverland@gmail.com	2	\N	{}	2024-07-09 21:26:24	2024-07-09 21:26:24	t	t
b7e76f4d-64d6-4284-b9e4-3dc3279948e1	3483cb93-d518-4bd5-aabd-35f959946b25	bogs penaso 	\N	I am a professional chef who captures hearts with cuisine that combines tradition and innovation. I pursue cooking that balances taste, health, and aesthetics.	bogsvillanuevapenaso@gmail.com	9129177494	\N	{}	2024-03-14 04:05:16	2024-03-14 04:05:16	t	t
d4c55ba5-f1c4-4bd3-b253-8a51994d0d9f	71ce6255-8c70-4d98-8f03-17b1f88d5f10	seung park	\N		seungpark0504@gmail.com	2137054888	\N	{}	2023-12-21 02:22:50	2023-12-21 02:22:50	t	t
44772f57-6ea2-4627-be5a-d0b303cf711c	5a40810c-8627-482b-b4e3-9d17c760d0b1	nathutam	\N		nathurampateriya3@gmail.com	9198076706	\N	{}	2024-07-09 20:58:46	2024-07-09 20:58:46	t	t
deb9e3fe-ae6b-4b69-9198-32452e286f57	238f4b6a-f2f2-42af-84eb-d159df121120	darasighn	\N		darashinghparmar@gmail.com	6264348994	\N	{}	2024-07-28 03:33:24	2024-07-28 03:33:24	t	t
6f4428d9-7439-438c-857c-0726c3cc5101	39425afd-6266-40d6-acaf-8770396d50cb	भगवान लिबाजी वाई मारे	\N		bhagavanavaghamare08@gmail.com	9021233254	\N	{}	2024-08-14 02:00:35	2024-08-14 02:00:35	t	t
1af038f3-ade9-4eeb-a57a-79373aeb0d96	e1c6977c-1a2f-442f-970c-c46d0505dc09	RoshanvaishyaGodbihari	\N	I am a passionate mechanical engineer who develops innovative technological solutions. I focus on sustainable design and efficient process improvement, and enjoy new technological challenges.	roshnabhai57@gmail.com	8799319456	\N	{}	2024-08-14 17:40:17	2024-08-14 17:40:17	t	t
e827d846-f9aa-4afa-8b0d-25b3f22e8b24	b7c71dec-b765-4ab4-845a-042585452059	안부영	\N	최신 IT 기술과 트렌드에 정통한 IT 전문가입니다. 클라우드 컴퓨팅, 사이버 보안, 데이터 분석 분야에서 두각을 나타내며, 디지털 혁신을 추구합니다.	byahn61@hanmail.net	01040205868	\N	{컨설팅}	2024-02-04 08:16:26	2024-02-04 08:16:26	t	t
1ff5d456-a729-4e19-93da-a2d3424fd4b7	5b579c8a-f4e3-4470-b966-604f4e24dfb8		\N		sangtarathod1@gmail.com	\N	\N	{}	2024-09-25 14:03:22	2024-09-25 14:03:22	t	t
181d7d0c-4ffd-4646-9bc9-0b385a1872e8	a2a716af-7c8f-4903-a0c3-76a2c3f4850b		\N		3418667129	\N	\N	{}	2024-04-02 08:46:25	2024-04-02 08:46:25	t	t
9493c2d8-73d6-463d-8c85-adc5fb4062d7	451add23-f1e8-42be-bd7d-b558e2ed31be	thanh hậu 	\N		anhnhonbinhdai@gmail.com	0389620434	\N	{}	2024-04-05 00:44:20	2024-04-05 00:44:20	t	t
5234d49a-de83-4fc2-8505-ec3bfe05f54c	f7edb844-845e-432f-9a55-1547a9f16972	박승호	\N		3421192014	1067738020	\N	{}	2024-04-04 01:20:36	2024-04-04 01:20:36	t	t
e3f7ac1b-6430-4965-8f25-4ca6166c507d	890ee693-cc3f-4698-8d32-2f4be546fecc		\N		kanakchakrabarty112@gmail.com	\N	\N	{}	2024-05-24 14:57:06	2024-05-24 14:57:06	t	t
0d613da6-40c1-4395-bb19-50dacbd4f77b	c1031e33-a294-4b1d-9d4f-94141379543d		\N		3285581018	\N	\N	{}	2024-01-14 06:29:07	2024-01-14 06:29:07	t	t
4d88d73d-3585-4b49-895f-114ca3575129	b55332a0-8a10-42aa-be20-5105eb6445e9	सुरेश चौहा	\N		sureshrao7535@gmail.com	7018600257	\N	{}	2024-07-17 05:28:38	2024-07-17 05:28:38	t	t
8105b816-3cd4-4c17-ba7d-a30591016d2d	dfdcb6d0-9a2f-4b9f-842c-732be3903b2c	죤	\N		3386125120	109514679101095146791	\N	{}	2024-03-12 13:17:59	2024-03-12 13:17:59	t	t
01271cf5-9c76-4fb0-9760-ffafa0ffcba9	ab93dfc3-181a-4c61-9aa7-b8dfdfa8c7c8	hoàng cu 	\N		hgh374156@gmail.com	0359898262	\N	{}	2024-03-25 16:39:56	2024-03-25 16:39:56	t	t
2ab4c585-1c91-4aab-9147-0b11e48075d1	7f0443bc-3f54-407b-8b8f-35939c1bb8ee		\N		deepaksaarsar271@gmail.com	\N	\N	{}	2024-07-11 00:16:14	2024-07-11 00:16:14	t	t
91781aba-8323-4125-8244-5fba79089957	a58a056b-ede7-4536-aaf8-fdecc2654857		\N		charlottekayejavelosa19@gmail.com	\N	\N	{}	2024-02-20 05:57:49	2024-02-20 05:57:49	t	t
3f817f6f-b3c7-4ed9-9d79-02518bd0aebb	9a30e43f-e39b-4090-b44f-5cbbc0f979a7	rama	\N		rk3445391@gmail.com	8847304826	\N	{}	2024-08-09 05:30:08	2024-08-09 05:30:08	t	t
98eec9c9-5836-4906-a00d-62abd9f99420	24b51865-5001-43e3-8b06-f791014a9954	최규하	\N	축산물(소고기 돼지고기) 수입및 도.소매 업체이며 식당 배송및 납품 전문 업체입니다	chkh1026@daum.net	01038995383	\N	{갈비선물세트,돼지고기,소고기,축산물}	2024-03-15 19:19:31	2024-03-15 19:19:31	t	t
53600138-9de1-4778-a49a-1273e0c6f36c	e941901e-e1d2-4b37-b1cf-b72f575ba239	허문수 	\N	혁신적인 기술 솔루션을 개발하는 데 열정적인 기계 엔지니어입니다. 지속 가능한 설계와 효율적인 프로세스 개선에 중점을 두고 있으며, 새로운 기술 도전을 즐깁니다.	Hms9973@nate.com	01077395438	\N	{}	2024-05-11 02:41:23	2024-05-11 02:41:23	t	t
d08a390b-8945-4a87-8b14-1f8667cd66ce	a105a530-0017-4c0f-9556-cc138081511c		\N		kraichada412@gmail.com	\N	\N	{}	2024-08-08 10:41:14	2024-08-08 10:41:14	t	t
f8f6ba6e-b261-47b1-89a1-44f35a771bca	28fa0891-a8ca-4d64-814f-9d6a777b3d73		\N		julaidamadsam@gmail.com	\N	\N	{}	2024-02-21 16:31:07	2024-02-21 16:31:07	t	t
367acebf-0116-4d94-b0af-c7d8ef01b2da	66f00c2f-1152-4591-a614-994ed7dcad5d	bmg98964121889	\N		brijmohangosaingosain64012@gmail.com	9896412188	\N	{}	2024-07-27 22:21:47	2024-07-27 22:21:47	t	t
ae2b2da8-c0f5-423b-9165-2ed63cc3a22b	11d876a2-a93d-49e1-8117-2b75b1d2678a	madan mishra	\N	I am a professional artist who expresses emotions and stories through visual language. I experiment with various mediums and styles, sharing creativity and artistic insight.	madan9693959672@gmail.com	9693959672	\N	{}	2024-08-15 03:25:03	2024-08-15 03:25:03	t	t
0be66bcd-3e59-403c-b81c-e516cd0eb031	c839a2e4-d1d3-48b8-a47d-730abb5a786f	Vijay, singh 	\N	I am a scientist who conducts innovative research based on deep curiosity about the world. I have made significant discoveries in the fields of life sciences and environmental science.	vijaykumarsingh0324@gmail.com	7839723036	\N	{}	2024-07-17 18:13:54	2024-07-17 18:13:54	t	t
aea925af-ff1c-4354-ad0f-99ef05857c96	fe0152fd-e1f6-4894-862f-f9a0e2f8826b	gaveen marcqus cuevas 	\N		cuevasgaveenmarcqus@gmail.com	123456789-6	\N	{}	2024-04-14 13:36:46	2024-04-14 13:36:46	t	t
703c1cbe-ae7d-4d3d-870e-dff0cd720afc	05ed794e-f094-4a48-91b8-211b37ab3d4f	이욱현	\N		ukhyun7@gmail.com	1038975348	\N	{}	2023-12-02 05:50:40	2023-12-02 05:50:40	t	t
1a8a2b41-1004-4a76-90f6-b8217777d425	e3450cd8-98f2-4229-819c-8c3e8b832e11	प्रकाश सिंह 	\N	मैं एक आईटी पेशेवर हूं जो नवीनतम आईटी तकनीकों और रुझानों में निपुण है। मैं क्लाउड कंप्यूटिंग, साइबर सुरक्षा, और डेटा विश्लेषण में बाहर खड़ा हूं, और डिजिटल नवाचार का पीछा करता हूं।	prakasasinh0382@gmail.com	8058427362	\N	{"प्रकाश सिंह "}	2024-08-08 18:35:37	2024-08-08 18:35:37	t	t
8a4cdb50-90b6-42bd-9b88-28df909eca20	fb827194-17ea-4908-b52b-40602374db99		\N		bjarma731@gmail.com	\N	\N	{}	2024-03-13 20:23:15	2024-03-13 20:23:15	t	t
3e449a58-4e52-4f46-b4db-611a6929c745	f71db5fd-aa50-4584-92bc-13ec64f7216b		\N		rofusawadan11@gmail.com	\N	\N	{}	2024-03-26 20:10:02	2024-03-26 20:10:02	t	t
224bc60a-3d51-445e-8916-19edba351904	836c0c42-bc2e-4373-8db8-a1b3e62333bb	Rajendra Roat 	\N		rrajendraroat67@gmail.com	9265591574.	\N	{}	2024-05-25 02:33:53	2024-05-25 02:33:53	t	t
0450421d-8a82-4d16-8c91-841e64661319	8a0aca32-4e3d-4dac-ad8b-4beac31d9494		\N		3420050022	\N	\N	{}	2024-04-03 06:08:10	2024-04-03 06:08:10	t	t
a3ffce16-7371-427d-8357-d3a7e84c401b	fdcb4e15-76f3-4a11-a3e8-564ea2bc4754	Thành 	\N	Tôi là một chuyên gia tiếp thị tăng cường giá trị thương hiệu thông qua tư duy sáng tạo và chiến lược. Tôi đã tích lũy kinh nghiệm trong lĩnh vực truyền thông xã hội, tiếp thị nội dung và phân tích thị trường.	dinhchiduyen2231983@gmail.com	0368094122	\N	{"hoà bình "}	2024-03-14 23:43:24	2024-03-14 23:43:24	t	t
9506d9d9-aca2-4209-97f6-aefa6e670a39	539dd60d-44d6-4808-a75d-976f4ff14489	Jenny lee	\N	창의적이고 전략적인 사고를 바탕으로 브랜드의 가치를 높이는 마케팅 전문가입니다. 소셜 미디어, 콘텐츠 마케팅, 시장 분석 분야에서 경험을 쌓았습니다.	mssuncorp@gmail..com	8189875144	\N	{"tetloyouth  ","건강 식품 "}	2024-11-05 23:36:29	2024-11-05 23:36:29	t	t
5fe29f43-2ac7-4e8e-a672-bf7ba263fe8c	15469123-6318-4d2f-9c2d-8cce162c99ab		\N		chiencuuchienbinh525@gmail.com	\N	\N	{}	2024-04-01 13:45:22	2024-04-01 13:45:22	t	t
101e3c8b-50aa-40b9-8d4d-5e4181eb71d5	17ba34ab-a47b-492f-ad8c-f1cddd9f1866	Rakesh Bansal	\N		rk1023228@gmail.com	9896401976	\N	{}	2024-08-12 17:21:06	2024-08-12 17:21:06	t	t
b9bfca6e-77bb-40e0-b352-3b1673632e9b	d335e76f-f4dd-4979-b976-39a61f5b9bef	이규목	\N		kmlee0373@gmail.com	37900373	\N	{}	2024-04-06 04:17:38	2024-04-06 04:17:38	t	t
e96c9b3c-7dd0-42ef-9852-ae1552955495	9ccd0c33-482b-4e0a-b55d-05c16eb70da6		\N		3390196677	\N	\N	{}	2024-03-15 10:26:22	2024-03-15 10:26:22	t	t
fc3a2729-b4ff-4831-b2f1-85acef76254c	8af9f0f2-2af6-47f0-9665-653f6d55857c	vikash 	\N	I am an enthusiastic teacher who helps students realize their full potential. I aim to enhance learning experiences through innovative educational methods and technology.	vikashkumar2192004@gmail.com	8051021164	\N	{}	2024-07-10 22:17:03	2024-07-10 22:17:03	t	t
87338eba-66fd-449f-9052-4d93f4bb7b85	daf0d1da-1ba5-4ddf-adf6-bd9d1a3a3a62	Roshan Lal 	\N		rl865929@gmail.com	7876264087	\N	{}	2024-08-08 16:11:15	2024-08-08 16:11:15	t	t
7ede3b67-2bfc-4d4d-a452-0541a301420e	7250b935-b2f7-492c-b0dd-74d621c6533c	जगदीश चदृराठोर९४२४८०५५६२	\N		rathodrajagdishchandra8@gmail.com	9424805562	\N	{}	2024-07-14 05:58:39	2024-07-14 05:58:39	t	t
14f88204-9688-4ea5-a6f1-fd75d08aa6f7	6e4f7030-cc14-4b88-b7b9-3fe0364d1411	phap	\N		phapn0457@gmail.com	0365658402	\N	{p}	2024-04-16 11:29:59	2024-04-16 11:29:59	t	t
7423d714-58da-4038-af92-1176b84a8168	5e994f5b-b724-4f3f-89bf-6ed5f82ec4c8	snigdharani Panigrahi 	\N		udaykarpanigrahi@gmail.com	7978377016	\N	{}	2024-06-06 16:50:17	2024-06-06 16:50:17	t	t
5d40b93c-7fae-403c-bca9-02bff4f49977	8bafeafd-8521-4b77-b661-bfda57a9f843	vijay	\N	With deep knowledge in the legal field and 15 years of practical experience, I provide clear and practical solutions to complex legal issues. I specialize in commercial law, intellectual property, and civil litigation.	vijaysinh2767@gmail.com	9924048190	\N	{}	2024-07-09 23:29:02	2024-07-09 23:29:02	t	t
8d50bd9e-feda-4c59-8e98-0c6e61ea0a43	c8c0fd33-6414-4b2c-a7fd-ce9ab0c5151f		\N		huuhuong6600@gmail.com	\N	\N	{}	2024-04-04 22:17:19	2024-04-04 22:17:19	t	t
60351c7d-1274-4681-afd2-b7d712031209	a3bb7a64-70ee-4f30-a73d-61faf1398188		\N		danemartindale63@gmail.com	\N	\N	{}	2024-04-03 23:37:21	2024-04-03 23:37:21	t	t
0e5d9626-b002-438d-bfd8-0967c4a51b3e	38bc0ed2-b6f8-43ab-8c00-4881911d0a64	dayasheel 	\N	I am an experienced internist with over 10 years in the medical field. I prioritize patients health and always stay informed about the latest medical research and treatments. I look forward to sharing knowledge for a healthy life.	dayasheelk@gmail.com	8586943293	\N	{}	2024-02-17 15:24:27	2024-02-17 15:24:27	t	t
1dff1005-82b3-4b46-aa0d-82f82a17785d	012e0de3-ba65-4fd4-9a9a-f127d09672aa	Shin E.S.			mydata@prodao.com	1074597076	\N	{}	2023-11-15 00:40:11	2023-11-15 00:40:11	t	t
21513d1c-4532-4a9a-a321-08bb7ec5fe1f	2eba665b-39d7-41a9-bb0a-f6b5e9d8063f	sayed Mahaboob basha 	\N	I am a professional artist who expresses emotions and stories through visual language. I experiment with various mediums and styles, sharing creativity and artistic insight.	aliloveishq123@gmail.com	9704074513	\N	{}	2024-05-10 20:31:48	2024-05-10 20:31:48	t	t
546b2a6f-ee30-42b6-8ece-7d3c70c7a61f	93e9305e-91de-486d-91c8-54a8699c408d	석용호	\N		yhsug@jeonghsn.kr	01085522421	\N	{}	2024-05-17 02:14:31	2024-05-17 02:14:31	t	t
7bcac019-46c4-4c04-b423-cb649d0c0155	170b7474-d2c6-459a-bb12-e3ff4e331254	Ashutosh Srivastava 	\N	I am a professional artist who expresses emotions and stories through visual language. I experiment with various mediums and styles, sharing creativity and artistic insight.	ashutoshsrivastava148@gmail.com	8114089645	\N	{}	2024-07-11 17:10:00	2024-07-11 17:10:00	t	t
5459a189-96f7-49eb-a3fa-55a24b1c908e	0b5e9729-9dae-458a-a994-e8c726ceecdf	sanjeet singh	\N		singhsanjit8737@gmail.com	7261860242	\N	{}	2024-08-15 04:06:39	2024-08-15 04:06:39	t	t
a274e149-b41e-4ef4-b56d-5330fdc8370a	4cdac558-f594-40ab-9bd7-2d3a30f344d8	전홍관	\N		sslaw@kakao.com	1077515401	\N	{변호사,소송,형사전문}	2024-04-18 10:40:57	2024-04-18 10:40:57	t	t
e4bf460a-d868-48a0-8a0c-9130d58503fc	f49526f8-676c-4971-8f40-65b5ebe614a5	Kavita	\N	hi I'm Kavita a simple House wife 	kharekavita562@gmail.com	8929168653	\N	{hwf}	2024-08-08 11:40:58	2024-08-08 11:40:58	t	t
f9017371-4ff5-4d92-8cf2-0588bf1a874a	9fddd9be-9541-4519-a900-a4bde103a96c		\N		samantasuman75@gmail.com	\N	\N	{}	2024-07-15 03:33:51	2024-07-15 03:33:51	t	t
06b33d22-d476-421f-8432-e84c9a3de38d	c2287965-d317-40b0-8cf7-3501d4052a53	Linh	\N		seunghoi922@gmail.com	0357577326	\N	{}	2024-03-13 16:19:09	2024-03-13 16:19:09	t	t
1b5488a5-21f7-4f5f-9b69-4d3916d79e48	be7b620c-28e1-4e41-be15-cb80a0a2ea89		\N		gr8425249@gmail.com	\N	\N	{}	2024-07-10 22:54:14	2024-07-10 22:54:14	t	t
fce5252a-6498-4323-bb7a-1079be9b33de	76d10db3-e4d8-4560-89bc-4454dd3ffd68		\N		vivekanandrai312@gmail.com	\N	\N	{}	2024-07-14 07:35:05	2024-07-14 07:35:05	t	t
1f35133b-32c5-4095-b244-9f79bcd6ef5e	325c4be4-3e35-450c-aba2-f66f774134e8		\N		mouryapradeep326@gmail.com	\N	\N	{}	2024-07-30 14:26:28	2024-07-30 14:26:28	t	t
aae28862-8d74-47eb-a746-d9b288bc61f1	d5d47433-2f55-4ef3-9802-acb7659ab33d		\N		magun01@naver.com	\N	\N	{}	2024-03-13 09:17:50	2024-03-13 09:17:50	t	t
25c06b25-eb55-4248-b222-89e7d53f53e4	c9ef1120-2ef1-4a29-a58d-be66407eea6b	सुरेन्द्र 	\N		surenderghai1963@gmail.com	9417591019	\N	{}	2024-09-02 03:55:33	2024-09-02 03:55:33	t	t
ebd8dc96-e0e4-41a2-b541-2894b96f3b68	42e3166f-a80a-4120-b00f-22224f3248b1	전상우	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/5292febd-b544-4f96-a4e5-0267d89f433f.jpg		jtech9633@gmail.com	01052477290	\N	{}	2023-11-23 08:15:50	2023-11-23 08:15:50	t	t
f0ea5101-036d-4d69-9a41-67600fcda748	a7d7d2b7-8389-4a67-91e3-7aaf6940bf49	윤형철	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/552f6003-1213-4e85-9f31-6c01d7c0aeaf.jpg		3216712735	01062823331	\N	{}	2023-12-09 10:02:20	2023-12-09 10:02:20	t	t
557cb298-05e1-46c3-91d9-109321141687	d7e6076d-3597-4faa-b092-29f95a11dca7	전지현	\N	창의적이고 전략적인 사고를 바탕으로 브랜드의 가치를 높이는 마케팅 전문가입니다. 소셜 미디어, 콘텐츠 마케팅, 시장 분석 분야에서 경험을 쌓았습니다.	wjswlgus03@gmail.com	01089221554	\N	{굿,기아,야구,좋아요}	2024-03-26 09:26:07	2024-03-26 09:26:07	t	t
8853b93f-80cd-4985-9dd2-28f5495c3875	9bdf6f88-144e-4836-9d28-a1e6715e47e6	김지효	\N	인공지능과 블록체인을 깊게 이해하는 자본가	katarina810418@gmail.com	01047817323	\N	{블록체인,"인공지능 ",자본가,투자자}	2024-06-05 03:49:56	2024-06-05 03:49:56	t	t
33fc90ab-c82c-4e7c-9017-c9d3e527c795	f578ba4f-f883-4dd2-b920-6614af947bd4	원종학			3841129233	13844313852	\N	{it,아사달,연길시}	2024-12-19 04:36:09	2024-12-19 04:36:09	t	t
19d5e3bd-3e68-4a16-aafb-a7ee73cf3f4d	db6df058-56ca-4a89-bc8e-ee5af30032c0		\N		elidalumbay09@gmail.com	\N	\N	{}	2024-03-26 11:12:08	2024-03-26 11:12:08	t	t
f79add7d-6797-4f3d-b69d-cf1635c6e0b0	a2e3eb4f-c4e3-4f3c-bfdd-2ca2c6f4b9ed	안인선	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/e9a4055e-2dc5-4313-8997-c7e51c622be6.jpg		insunan@hanmail.net	01058384089	\N	{유통}	2023-11-29 05:32:36	2023-11-29 05:32:36	t	t
114568db-7f9a-4021-972b-97d7fb51f549	1d75df37-370e-462f-8992-a5ea79f9c574		\N		ahmadsabbir5098@gmail.com	\N	\N	{}	2024-08-16 03:18:45	2024-08-16 03:18:45	t	t
d1dfdc74-3258-47c7-9cf5-7e672df0d47b	ddc66341-d059-4035-955b-337754470b86		\N		ltybanez1985@gmail.com	\N	\N	{}	2024-04-01 08:46:40	2024-04-01 08:46:40	t	t
e521a2b3-446d-4087-a5e1-9a1e17083173	0da6fe92-db44-40da-854c-a84be86ab8d4	김선정	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/392487d2-8676-4a74-b734-ed4a7ea44126.jpg		00tjswjd@naver.com	01045148465	\N	{}	2023-11-23 08:15:33	2023-11-23 08:15:33	t	t
88d21828-0f6e-4ead-914d-da057f8b3c39	4d84444a-f4f9-42b7-a2ed-6821a490a904		\N		williamsronly@gmail.com	\N	\N	{}	2024-04-16 11:42:52	2024-04-16 11:42:52	t	t
6dc8b363-ed60-443e-97ae-7319ef5e472c	35c78fcd-a4ea-459c-9ee2-57cbf5b2e457		\N		jeetraz38@gmail.com	\N	\N	{}	2024-05-16 04:35:45	2024-05-16 04:35:45	t	t
2ce64e14-aa71-4a8c-b6d8-5dcdaa5c1b25	eb75a743-3e63-4491-9c1e-1f433382498e		\N		3221140030	\N	\N	{}	2023-12-12 11:21:47	2023-12-12 11:21:47	t	t
10161499-946a-4124-86ad-87ba7a41db19	d45a09bd-7da6-4597-9bd6-64abcc507259		\N		3241800915	\N	\N	{}	2023-12-26 02:42:26	2023-12-26 02:42:26	t	t
70a01b3c-30ec-402f-b0f3-4303729fc040	ae0e8d7d-b836-4562-b344-a8eb5d208690		\N		packiyamohd@gmail.com	\N	\N	{}	2024-06-24 05:33:15	2024-06-24 05:33:15	t	t
648e6cbb-ea07-4c92-9d00-3c3ca72fa717	631da6d3-9081-4d4d-8f17-98f6f1e128c4	김상우	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/dc9aedbc-9bdc-490c-a1b9-fbbd57cd791b.jpg		swkim@kisti.re.kr	1052519485	\N	{Consulting}	2023-12-06 09:16:47	2023-12-06 09:16:47	t	t
c2c73d06-5f1a-4f79-b3c1-24cc91a802ae	b0edf305-d450-47c9-a021-ad76ce5ab057	prakash	\N	I am a professional chef who captures hearts with cuisine that combines tradition and innovation. I pursue cooking that balances taste, health, and aesthetics.	prakashchekhliya2@gmail.com	7990843368	\N	{}	2024-07-09 19:28:18	2024-07-09 19:28:18	t	t
cf3a9b4f-f8dd-44eb-81b1-6b34926636c0	a8af0e64-0ac6-46fb-99f1-6da08eeab725	우윤우	\N	디지털전환사업-창의미술관련 애니메이션 제작 플랫폼 개발, 모바일디지털명함 플랫폼 개발, 그래픽 디자인, UX UI 디자인	meerowoo@nate.com	85992409	\N	{"UX UI 디자인",디자인,디지털전환,"플랫폼 개발"}	2024-01-12 05:41:00	2024-01-12 05:41:00	t	t
7e5668b6-bfff-4886-94cb-d17e0a8af053	2de42ebb-41bf-47a5-9e98-0bd9d83864b7	changwoo	\N		3287274581	01022225555	\N	{kakao}	2024-01-15 09:19:26	2024-01-15 09:19:26	t	t
71a1dc2d-510a-4b08-8a59-369ed3a66ae5	18f9303b-4bf3-412d-ba02-208b9ed493c8	Raju mujhalda 	\N	I am an experienced internist with over 10 years in the medical field. I prioritize patients health and always stay informed about the latest medical research and treatments. I look forward to sharing knowledge for a healthy life.	mujhalderaju@gmail.com	7470366804	\N	{magan,"mujhalda ",Raju}	2024-07-10 08:05:04	2024-07-10 08:05:04	t	t
58a8e033-f88b-4b71-a24f-76c69a3c2b08	2fc63575-ed81-4633-9117-b8fcb774cf85	김예성	\N	건강한 보건의료인재 양성을 통해 더 건강한 미래를 만드는 한국보건의료상담협회 김예성입니다.  Mission Make a Better World.                               Core Value: People First.	3376877201	01027732835	\N	{면역세포,의료상담,줄기세포,"항암 항노화 "}	2024-03-06 06:14:23	2024-03-06 06:14:23	t	t
1afbc2c1-7f2f-4c6d-a67f-03b73f40554a	602dd743-6287-46d7-a646-73bd88833927	Awadhesh 	\N		pappupandit95075@gmail.com	7448949046	\N	{A.k,pu}	2024-08-09 01:41:58	2024-08-09 01:41:58	t	t
1cf0f797-c800-4d93-a87e-514250744db5	9e6f4b0c-8151-4631-9030-b66d243d8301		\N		hmkimpop@gmail.com	\N	\N	{}	2024-03-09 02:09:51	2024-03-09 02:09:51	t	t
55175ed9-1d75-43a0-a7de-3360ab55ae2f	57c03fdb-ef6a-4bae-ab27-67a84b4c345c		\N		nguyenthithuyt221@gmail.com	\N	\N	{}	2024-03-14 10:27:17	2024-03-14 10:27:17	t	t
39d66d88-f032-4af0-addf-760059055323	16bc8b11-9047-4191-a3ea-4d79596a3eae		\N		phungquangnghia12@gmail.com	\N	\N	{}	2024-04-15 05:38:38	2024-04-15 05:38:38	t	t
c6bd3a44-4efd-4f45-b826-b9d5dd92836e	5874744e-0273-45f7-bf15-2a1eea3a3d9c		\N		3163750329	\N	\N	{}	2023-11-15 04:38:36	2023-11-15 04:38:36	t	t
80a9c089-5034-4492-90ec-2cbe9fddb812	c91edd30-b1bc-4b24-a8ba-dd410062426c		\N		syngocnguyen79@gmail.com	\N	\N	{}	2024-05-09 15:32:48	2024-05-09 15:32:48	t	t
415549b8-add7-4fc3-a2c2-41232c24f219	c1e73591-e3aa-4c35-842b-6e5ef3a4ac55		\N		3186879116	\N	\N	{}	2023-11-27 03:29:02	2023-11-27 03:29:02	t	t
32b50b4c-5ae6-42c6-993d-84c735b42681	987aa07b-d3c9-4308-a239-857eeadec274		\N		ashishghosh324@gmail.com	\N	\N	{}	2024-07-09 10:00:49	2024-07-09 10:00:49	t	t
d819853a-746f-4ac1-ba19-8831f7a572ec	a74d7363-3563-458f-bf53-513e83883f9f		\N		inayatali1819@gmail.com	\N	\N	{}	2024-08-08 12:38:09	2024-08-08 12:38:09	t	t
d689310c-b75d-4201-a5de-5d809e576b42	a6640a52-70f6-46fd-8d61-1c3dd8fee577		\N		bhabyjuday63@gmail.com	\N	\N	{}	2024-03-13 06:58:02	2024-03-13 06:58:02	t	t
2e13f850-cbbc-4bcf-b4bd-76e0a5e88d77	e4cf17de-c9e2-4665-b51f-9fa42141931f		\N		amaldas.ad20@gmail.com	\N	\N	{}	2024-08-12 08:34:39	2024-08-12 08:34:39	t	t
bd741584-99af-48ff-8813-49b7587359cf	7a0a197e-423c-4095-b3c7-6ca58a16d1a2		\N		rajuporwal5313@gmail.com	\N	\N	{}	2024-09-28 04:14:47	2024-09-28 04:14:47	t	t
dba86028-9696-46ba-b59d-fa351cb9869d	78b933d8-c426-4e7e-a50f-689ca3971b19		\N		binh02092018@gmail.com	\N	\N	{}	2024-04-02 23:00:14	2024-04-02 23:00:14	t	t
8facaf88-c9fa-47eb-b3b7-ca1a3d1bb3b5	490347b3-bb8b-44da-8981-4c57e846ce3a		\N		taythienk36@gmail.com	\N	\N	{}	2024-04-14 05:47:20	2024-04-14 05:47:20	t	t
3df03fcd-a7ed-4c3b-a750-4b3a25f89ae4	1e9b90d7-3fee-4ba9-a642-917f086017c9		\N		3226910420	\N	\N	{}	2023-12-16 10:22:48	2023-12-16 10:22:48	t	t
bea88fa9-6e3c-4776-9f66-5dd1a6ddbbae	6311a07e-9492-4ece-8578-5a4e02dc6535		\N		sarbjeetdadiala@gmail.com	\N	\N	{}	2024-07-13 04:00:45	2024-07-13 04:00:45	t	t
75088081-fedf-4c6d-8d6b-5e8d3dd1f0b9	0aca12c1-04f2-4cb3-9e75-987e79ca6f0c		\N		vircanoy1@gmail.com	\N	\N	{}	2024-02-21 01:58:50	2024-02-21 01:58:50	t	t
7db3a5ac-9686-41f9-ac1b-b4135a6eda03	73189583-b3ab-4954-a16f-94611eec7985		\N		ka9131947@gmail.com	\N	\N	{}	2024-08-08 11:45:23	2024-08-08 11:45:23	t	t
60fbd48e-c45e-42b7-93af-d2f0892d64cf	1851f887-f6b6-4652-8210-9f4a8a316be6	kismat khan 	\N	I am a marketing expert who enhances the value of brands through creative and strategic thinking. I have gained experience in social media, content marketing, and market analysis.	kismatkhan1984@gmail.com	7990637201	\N	{}	2024-07-31 08:05:09	2024-07-31 08:05:09	t	t
320eaf78-9516-4f0e-a1a4-e27e1deaf10d	70c7e4b1-61e3-4ea7-b254-f7a6477d7e1a	김유리	\N	창의적이고 전략적인 사고를 바탕으로 브랜드의 가치를 높이는 마케팅 전문가입니다. 소셜 미디어, 콘텐츠 마케팅, 시장 분석 분야에서 경험을 쌓았습니다.	urigo@naver.com	01062386266	\N	{이벤트}	2024-02-26 11:28:24	2024-02-26 11:28:24	t	t
ab53b527-fe5e-4692-8ac5-f2a0a4b83a99	583dcdbe-fbdd-4ecf-800d-831c7f7716f9	박선영	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	3390199179	01062452455	\N	{답례떡,떡집,이바지,잔치떡}	2024-03-15 10:28:23	2024-03-15 10:28:23	t	t
7a4b9f4f-f168-4135-8282-b690229d10a1	b475c6de-61e8-4434-8e6c-5b7de040c4d0	손충현	\N	최신 IT 기술과 트렌드에 정통한 IT 전문가입니다. 클라우드 컴퓨팅, 사이버 보안, 데이터 분석 분야에서 두각을 나타내며, 디지털 혁신을 추구합니다.	controls@daum.net	01090334523	\N	{IT}	2024-04-08 05:39:56	2024-04-08 05:39:56	t	t
f95a031f-909b-461c-9ab4-b8823258b41a	50b8684b-550d-49cb-a35b-afec75bf3aa9	이말년	\N		dlfchdmldudb@gmail.com	01046464646	\N	{1}	2024-04-04 06:43:55	2024-04-04 06:43:55	t	t
a2eec146-0960-4c77-929e-dbc8796b9712	d1bb5ce8-5f7b-4f87-9003-a3bf15e45eb5	nazazin	\N		pugahanjanice72@gmail.com	09065141217	\N	{nazazin}	2024-04-16 11:13:42	2024-04-16 11:13:42	t	t
4ea50192-260e-4f9e-9a80-372b0a74bca3	1543db57-9c36-4a03-b917-401ada53eb22	김동운	\N	특허 실용신안 디자인 상표 출원 및 분쟁 대리	ipdwkim@gmail.com	01091243731	\N	{디자인,상표,지적재산,특허}	2024-02-20 09:26:26	2024-02-20 09:26:26	t	t
b4a5f4cc-7f43-413f-b29d-e924ce29cc7b	3d98c311-3ad2-4f4b-8a3c-9d1e9ddeb891	Nguyễn Văn Trắng 	\N		nguyenvantrang31082021@gmail.com	0947232702	\N	{aa}	2024-03-14 09:38:44	2024-03-14 09:38:44	t	t
2ee921b4-10ae-4f43-9639-bf42de8f6a21	d3295e14-3dfc-43d0-9f4c-5969722a684a	Amadou	\N	I am a businessperson with an exceptional ability to turn visions into reality. I pioneer new markets with innovative ideas and strong business strategies.	3703878556	1074260060	\N	{ado}	2024-09-13 04:53:19	2024-09-13 04:53:19	t	t
9013cc9e-e5df-457c-a94c-273dd2efa013	18ec4073-a1b8-42e0-b1df-7364f5fb34b2	길수항	\N		3407814030	01052721859	\N	{다이어리,스티커}	2024-03-26 04:27:05	2024-03-26 04:27:05	t	t
5b19c66d-9610-4b30-9559-d303e1e914e1	9a43cfea-d61d-411e-bff8-d6adb0ac6ac5	xuancat2009@gmail.com	\N	Tôi là một nhà khoa học thực hiện nghiên cứu đổi mới dựa trên sự tò mò sâu sắc về thế giới. Tôi đã có những phát hiện quan trọng trong lĩnh vực khoa học sự sống và khoa học môi trường.	xuancat2009@gmail.com	0960630081	\N	{p,q}	2024-04-03 07:14:23	2024-04-03 07:14:23	t	t
78953c46-ee3b-4073-b822-6b8867160245	e1b17f1a-c270-4a08-8ad1-fa243d3fcb50	노승현	\N		3444743101	01044484752	\N	{키워드}	2024-04-19 12:04:33	2024-04-19 12:04:33	t	t
4cbad0ad-65fd-4692-ad26-7389436d0181	8b6bb28b-3a33-4499-8d67-2bb589dfb8d8	정순채	\N	최신 IT 기술과 트렌드에 정통한 IT 전문가입니다. 클라우드 컴퓨팅, 사이버 보안, 데이터 분석 분야에서 두각을 나타내며, 디지털 혁신을 추구합니다.	polinam@hanmail.net	01021123977	\N	{정보보호}	2024-06-27 08:22:05	2024-06-27 08:22:05	t	t
317add80-05e9-4c7a-8eec-a7d9323933af	bb3e8773-d839-4b28-ab2f-4891c0588c74		\N		tojomonal33@gmail.com	\N	\N	{}	2024-08-13 14:28:23	2024-08-13 14:28:23	t	t
b950f177-9f3d-4b3e-9813-52a5d632c5a9	c94f9fae-1858-40a6-b6e9-45858f0943a8	Laxmi Kant Dubey 	\N		laxmikantd882@gmail.com	8750214369-	\N	{280924}	2024-07-17 10:06:29	2024-07-17 10:06:29	t	t
7c6491c0-551a-49b7-8d86-09d91556b7b1	2024579d-2075-4417-afb4-9d83dd3d546c		\N		taewonkim933@gmail.com	\N	\N	{}	2024-03-25 13:23:39	2024-03-25 13:23:39	t	t
6f05561e-f82f-4312-9b6c-9c45364cede8	3c7cd7ce-dcc5-439d-ae39-00f31f02030d	노명섭 	\N		myongsub@naver.com	01026426399	\N	{영광}	2024-03-21 00:54:14	2024-03-21 00:54:14	t	t
fa927f55-b848-440a-bb45-16fd070467d2	5d8560a9-139b-439f-8b13-487269dbb8f9	김태식	\N	돈을 많이 벌고 싶어요. 도와주세요.	3433657053	01079429717	\N	{생산직}	2024-04-12 07:54:22	2024-04-12 07:54:22	t	t
5fd66ce7-f0da-4eb0-a0df-cc076744916b	118fb523-0789-47a7-9fdc-f53b93fdb406	장진석	\N	이태리에서 의료용품을 수입하는회사입니다	3423399087	1032887540	\N	{지혈제}	2024-04-05 08:13:23	2024-04-05 08:13:23	t	t
5645a68c-83fb-4b0d-bb65-93d2a66a2576	60c1c053-6438-451b-9772-4525172235d0	조인구	\N		3678572552	01077672958	\N	{.}	2024-08-25 08:02:30	2024-08-25 08:02:30	t	t
21f226ea-0127-4e52-aa6e-c781a42944fb	e90dd22c-e834-4dca-80cf-9a426326fb98	박건우	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	parkgw57@hanmail.net	0105496504819571221	\N	{hs973822}	2024-03-29 06:36:51	2024-03-29 06:36:51	t	t
b8a6ec3f-37ff-45fe-ad82-3170a4b020f6	4088dc01-b5cc-4127-98cd-93debca761df	Dnyandev	\N	I am an enthusiastic teacher who helps students realize their full potential. I aim to enhance learning experiences through innovative educational methods and technology.	dnyandevbhargavshinde@gmail.com	9763160367	\N	{Tracker}	2024-06-06 03:31:14	2024-06-06 03:31:14	t	t
c391e051-a7dd-42ac-b49c-0ce61279a321	aed4eb23-b290-48dc-81f5-eb28d3487d29	김주극 	\N		3407412011	01053411579	\N	{"서울경제인협회강남지회 "}	2024-03-26 00:21:21	2024-03-26 00:21:21	t	t
48634ac6-b4ba-47b6-9890-e8bdc4f885bd	b998f6fd-4ed6-46ac-a68a-cac842099b5a	송영열 	\N	학생들의 가능성을 최대한 발휘할 수 있도록 돕는 열정적인 교사입니다. 혁신적인 교육 방법과 기술을 통해 학습 경험을 향상시키고자 합니다.	autobull60@gmail.com	01059153140	\N	{미래예측}	2024-05-02 09:07:43	2024-05-02 09:07:43	t	t
90c2516b-b40e-451f-8ff4-6b6178432a5b	dbef37eb-d458-4df7-8085-e1621c5c6e1f	문선영	\N	신용보증업무	hope0906@naver.com	01062942653	\N	{신용보증}	2024-02-19 19:22:02	2024-02-19 19:22:02	t	t
9d873e74-ec67-4b2c-9591-903313eb5f5f	bf4f88b0-08dd-4610-a308-ddae20ba3145	safu	\N	nurse 	ramlathm45@gmail.com	7593063494	\N	{camera}	2024-05-24 16:33:32	2024-05-24 16:33:32	t	t
25e62256-a2e2-48c8-bc3d-20d6e2cff019	8c0a9d96-360f-4395-8210-817488614318		\N		sekhjiyarul557@gmail.com	\N	\N	{}	2024-07-27 04:35:15	2024-07-27 04:35:15	t	t
3f9112c6-8026-406d-a1e4-08d3d464f110	8afbe459-f864-4ad6-98b5-595ac422f0ef	이영호	\N		younhchow8080@gmail.com	2132661409	\N	{개임,기겨ㅣ,전기}	2024-10-23 23:41:09	2024-10-23 23:41:09	t	t
e3c6df7c-c3eb-4c5c-a5a0-e2145d33f628	00a5de4e-b1eb-4cdf-ae78-2546e7d5935f		\N		josephmatthewlatorre8@gmail.com	\N	\N	{}	2024-03-13 10:26:13	2024-03-13 10:26:13	t	t
82fd1266-7c39-4982-9919-2a5cb577a466	0134d7aa-9f38-4e9c-a172-f94415e1beb2	parkchangwoo	\N		icncastcw2@gmail.com	01040967820	\N	{cw2,flutter}	2024-01-15 07:48:04	2024-01-15 07:48:04	t	t
66420cd2-b4dd-4c9f-a6f4-02c76bd11998	8094ca37-d204-44c2-9dca-8851ccd31e91		\N		lalr15078@gmail.com	\N	\N	{}	2024-08-14 13:07:57	2024-08-14 13:07:57	t	t
aca81bc9-07be-4746-aca8-31eb4e6bbb77	71250fbc-ab27-4de9-940e-eadbeabbcdb4		\N		bao9922tb@gmail.com	\N	\N	{}	2024-04-14 12:45:29	2024-04-14 12:45:29	t	t
5ebaf52f-02f3-4d48-ab4e-49d77b73231b	bf0d2a55-ea51-4de8-bdfb-0e13d2fee800	김인규 	\N	최신 IT 기술과 트렌드에 정통한 IT 전문가입니다. 클라우드 컴퓨팅, 사이버 보안, 데이터 분석 분야에서 두각을 나타내며, 디지털 혁신을 추구합니다.	kova5111@naver.com	01022301004	\N	{베트남}	2024-04-06 00:33:50	2024-04-06 00:33:50	t	t
b17b1d3f-23ca-415c-b914-aad8434e4a50	fe1ca68a-12fc-473f-a491-7696b62f7e9b	James jung 	\N	학생들의 가능성을 최대한 역량 발휘할 수 있도록 돕는 열정적인 교사입니다. 혁신적이고 풍부한 경험을 접목한 기술을 통해 학습 경험을 향상시키고자 합니다.	dnagps2019@gmail.com	837624433	\N	{"골프 ","당구 ","여행 ","테니스 "}	2024-04-05 03:13:39	2024-04-05 03:13:39	t	t
c75df91f-a4a2-4aa4-ad8d-a0e542f93b82	890364f4-9e20-4be5-b182-2ad4498aef48	이상섭	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	lssho@naver.com	1054413822	\N	{다이마루원단,"원단설계 개발","환편원단 컨버터"}	2024-04-17 12:46:48	2024-04-17 12:46:48	t	t
953b2111-f4ad-4896-b8ef-bbfaf90fb9c3	b5a54e7b-805c-4edd-bfc1-e0fa60a2f9cf		\N		rajindergupta795@gmail.com	\N	\N	{}	2024-06-15 10:06:23	2024-06-15 10:06:23	t	t
480d94fa-77d6-4f59-887e-1fd157718712	4038ac51-b9c3-4cfc-b08a-7b591eca29f3		\N		kritesh8762@gmail.com	\N	\N	{}	2024-07-09 09:00:41	2024-07-09 09:00:41	t	t
546b8b5b-ac13-4305-b84b-f0899ae62374	1e739310-46d8-4ec7-b986-b2172bf66c83		\N		chandrashekharckumar2@gmail.com	\N	\N	{}	2024-07-10 03:18:36	2024-07-10 03:18:36	t	t
ec1dbbb4-b158-404d-99ee-ac8dc09562d3	d614d130-f62e-4287-81a6-0ab916262663	도봉순	\N		elel9223@maver.com	01072434561	\N	{요양보호사}	2024-02-05 05:49:17	2024-02-05 05:49:17	t	t
bd8e5313-da2d-4aee-8f22-43cf27c909a8	d641f73a-5186-4fba-9ac7-50c5c79884d1		\N		3408428392	\N	\N	{}	2024-03-26 10:52:02	2024-03-26 10:52:02	t	t
e3c1c253-551d-47a2-be69-53e26b0cb2c7	4073a968-4ef2-4b55-a05f-c01e5284cff6		\N		3423000371	\N	\N	{}	2024-04-05 03:40:58	2024-04-05 03:40:58	t	t
87e6ebd1-fc08-42f2-8cbd-9e6c2c8c935a	3eeeb342-b160-4b77-b1a1-0ff90a31a07a		\N		tranthinhan050291@gmail.com	\N	\N	{}	2024-05-09 02:52:47	2024-05-09 02:52:47	t	t
50e92c2a-9b3a-44dc-bc8f-8c6cd6c39f8c	c9316baf-b03a-4f02-b9c9-772f7d18aa58		\N		shyamradhe58435@gmail.com	\N	\N	{}	2024-07-09 15:25:14	2024-07-09 15:25:14	t	t
fd7955d9-a9c1-4c99-9a5d-a0f01522b86a	260093ba-f172-402d-bd45-52a17588233f		\N		hmokchom@gmail.com	\N	\N	{}	2024-05-31 22:48:30	2024-05-31 22:48:30	t	t
90140376-0b5c-45cc-a6a2-8a1041d451e0	35788f05-4029-4b19-a198-dcbeb95d3b83		\N		3331372607	\N	\N	{}	2024-02-06 03:28:20	2024-02-06 03:28:20	t	t
4b9b5474-22b9-436a-b6fa-f09ea7e987a7	1b933f94-02d5-4aa9-b231-b2a07d99b765		\N		thakurbaldev903@gmail.com	\N	\N	{}	2024-06-24 04:58:23	2024-06-24 04:58:23	t	t
4d0aebb5-c0f0-488d-b7dd-884bbeb1507a	7300c705-c2ec-4f87-89ed-734a49a40fe6	upajit	\N	I am an experienced internist with over 10 years in the medical field. I prioritize patients health and always stay informed about the latest medical research and treatments. I look forward to sharing knowledge for a healthy life.	upajitroy21@gmail.com	7865939553	\N	{upajit}	2024-07-11 17:02:30	2024-07-11 17:02:30	t	t
d9fec9ec-9618-413a-a179-075d5a82f6fc	d95bf52d-d122-492b-aa98-fe1702ef0f31		\N		atkuriveerababu@gmail.com	\N	\N	{}	2024-02-17 03:53:05	2024-02-17 03:53:05	t	t
0f1472c9-24e8-4a2a-9d27-46c034962bf9	617a831e-8f9f-4527-bb02-6baf91314c3d	कांतिलाल निनामा गांव सैरा	\N	मैं विभिन्न खेल क्षेत्रों में 12 वर्षों के पेशेवर अनुभव के साथ एक खेल विशेषज्ञ हूं। मैं एथलीटों की शारीरिक कंडीशनिंग और कौशल में सुधार करने के लिए निरंतर अनुसंधान करता हूं, और समाज के लिए खेल के मूल्य और महत्व को बढ़ावा देने के अग्रणी हूं।	kantilalaninama49@gmail.com	8269525451	\N	{"कांतिलाल निनामा"}	2024-07-10 15:49:43	2024-07-10 15:49:43	t	t
a14b0147-2f6f-4755-922e-a03107f548ea	36218a8c-dfa9-4c66-8f79-2e283fefaf80		\N		rollinaklingel@gmail.com	\N	\N	{}	2024-02-20 12:54:22	2024-02-20 12:54:22	t	t
a4776877-6fc9-4228-90a2-ef7176460716	7543d9a5-e2c5-4a9e-a921-c8141bd898cc		\N		hadalp882@gmail.com	\N	\N	{}	2024-07-29 03:34:43	2024-07-29 03:34:43	t	t
5ca9b392-4197-4e6c-8fd9-bdd6b5e1785c	4fa50c02-239d-4274-b782-0286c6a1b05b	김천숙 	\N		taekyung2006ss@hanmail.net	010765022451600	\N	{카드단말기,키오스크,포스}	2024-02-21 06:10:18	2024-02-21 06:10:18	t	t
3d7ed23d-d83f-491b-b3e1-34cd4f8e728b	63d512ee-b850-4993-b486-e5494d188bfe	강경한	\N	사무직	rokafkasu@hanmail.net	01050713178	\N	{테너강}	2024-03-12 12:20:43	2024-03-12 12:20:43	t	t
d91a3110-1f8f-4439-82c3-ba7fde8387d4	51b5e313-27c4-4de7-a47c-c55d12bd6026	Luciel	\N	I am a businessperson with an exceptional ability to turn visions into reality. I pioneer new markets with innovative ideas and strong business strategies.	lucielculentas@gmail.com	9305623695	\N	{Ci,El,LC,Lu}	2024-03-14 04:56:57	2024-03-14 04:56:57	t	t
e37bfcdc-1d14-4b0a-ae1f-b4e2e573addf	63c50a8c-1928-4fe1-a614-7f82ab64ea88		\N		sangalmahesh09@gmail.com	\N	\N	{}	2024-08-13 01:59:22	2024-08-13 01:59:22	t	t
1b6d9a27-c39e-4925-90c0-25ab432d33de	0c121d74-b2af-453f-8595-825c063cf601		\N		malkeetsingh3737377@gmail.com	\N	\N	{}	2024-08-10 17:40:09	2024-08-10 17:40:09	t	t
dfd99947-9e85-44c3-b5b9-f95957ffeecd	7c49b3b7-762b-44b4-a1b5-ffb7d085a3e5	ramji'paswan 	\N	With deep knowledge in the legal field and 15 years of practical experience, I provide clear and practical solutions to complex legal issues. I specialize in commercial law, intellectual property, and civil litigation.	ramjipaswan8271489052@gmail.com	71489052	\N	{2244}	2024-07-10 23:17:02	2024-07-10 23:17:02	t	t
5dadb24e-2fa4-467f-a3fa-0f18f3e8ecdd	f034f251-e39b-4d2c-922d-1cb8f488a36e		\N		romelsg0@gmail.com	\N	\N	{}	2024-03-25 12:02:03	2024-03-25 12:02:03	t	t
21814c41-e5ff-4357-90e3-4b0febd90a0a	8e6f19f2-1010-40c2-8765-1d47a0aa9196	chandan.ram	\N		chandanc04362@gmail.com	7041586215	\N	{7041586215,chandan.ram}	2024-07-12 17:46:00	2024-07-12 17:46:00	t	t
5d8d18db-31a7-4f5f-af97-5f6cc3127fc2	8f2abc6e-f4cf-4ce0-81fe-6a326079d556	박창우	\N	최신 IT 기술과 트렌드에 정통한 IT 전문가입니다. 클라우드 컴퓨팅, 사이버 보안, 데이터 분석 분야에서 두각을 나타내며, 디지털 혁신을 추구합니다.		01040967820	\N	{flutter,ios,애플,앱}	2024-02-08 01:01:03	2024-02-08 01:01:03	t	t
faa74b9b-ac5d-4f1a-b2fc-0c7075f6ee15	d19b3f0d-9201-4cbc-b486-ca3054e0b451	박재영	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	jypark1206@empal.com	1045657722	\N	{NC강서점1층,"남여캐주얼과 핸드백 등 악세사리 일체","아울렛으로 30%이상 할인","헤지스종합관 "}	2024-02-21 06:11:09	2024-02-21 06:11:09	t	t
ae8515a5-409c-41f4-b6d2-1b291471622a	dd8426af-0b32-4037-a511-c1234f683a1d		\N		policarpiovictor73@gmail.com	\N	\N	{}	2024-05-07 03:20:29	2024-05-07 03:20:29	t	t
df1804b3-3b85-42f5-81d7-bb40f0015b1e	ff67e398-623d-4a7e-aee6-719ac1bbf4bf	sona	\N		sonabivesharma@gmail.com	8948772793	\N	{123}	2024-08-22 15:45:18	2024-08-22 15:45:18	t	t
5f04ad94-d71e-4b37-a020-d3c3e565fede	8670a7bc-79cd-4449-b097-240802aa15ee		\N		pankajsaikia39965@gmail.com	\N	\N	{}	2024-07-09 20:34:55	2024-07-09 20:34:55	t	t
aefc1595-3db3-4072-a982-8fd87fa358c9	1984f081-73f8-4882-aabb-d48600cd802e		\N		dhillonvikram91@gmail.com	\N	\N	{}	2024-07-13 14:38:10	2024-07-13 14:38:10	t	t
f7d99a46-04b4-47c1-8452-0fba529b5ab5	9d4f15b4-86da-4f81-b58e-cab8c435585c	Kdao	\N	Kdao	3810629734	01036822936	\N	{BSC,"Performance Management",SDGs}	2024-11-27 23:50:03	2024-11-27 23:50:03	t	t
915d3dd6-4556-40ff-b81b-114b6afb01be	19d96152-2e98-439e-bb2a-71f813fc7846		\N		truongnguyenthanhdat67@gmail.com	\N	\N	{}	2024-02-19 15:34:10	2024-02-19 15:34:10	t	t
596b484a-420f-4011-af2f-6906758a4902	b651ec49-f0b6-40b6-87b9-af90f919e1c0	석동호	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	dhsuk21@gmail.com	1082345955	\N	{Consulting}	2023-12-02 10:25:21	2023-12-02 10:25:21	t	t
9bd5207f-bdf7-4c33-8c85-9e94f1124b58	aead667b-59bb-4feb-afac-26adbaf84454	류문형	\N	동서울대학교 컴퓨터소프트웨어학과 겸임교수와 주식회사온나라 정보보호사업부 사업을 하고 있습니다	alexand3@onnara.pro	01086116355	\N	{류문형,정보보호}	2024-02-26 22:59:27	2024-02-26 22:59:27	t	t
9d67f7ce-b77d-4541-bc38-2aa0d3c0ab95	f3bd997d-7b71-44a1-ae2a-51bc696ecfe4		\N		3416922681	\N	\N	{}	2024-04-01 07:27:19	2024-04-01 07:27:19	t	t
054647c9-ad7a-425e-9071-cdc730e3c288	5ea1a22c-a5dd-409f-adca-32042c0af259		\N		voanhkiet117722@gmail.com	\N	\N	{}	2024-04-16 05:37:00	2024-04-16 05:37:00	t	t
8c260f4d-979a-4b32-998a-287d8be52596	b73354ff-ae09-4ff6-881e-801f7702fd74		\N		moolsingh78772@gmail.com	\N	\N	{}	2024-06-10 03:05:07	2024-06-10 03:05:07	t	t
dbedb255-3284-4ebc-be9a-af7b90e6328e	372a1edd-05f7-4df6-a156-acc36f8690bb		\N		3328117115	\N	\N	{}	2024-02-03 19:56:12	2024-02-03 19:56:12	t	t
6b53c323-e18c-4f54-bdae-ba2d8bc39430	3690381c-9a4e-4089-bcb2-803eca72302b	jawed	\N	I am a passionate mechanical engineer who develops innovative technological solutions. I focus on sustainable design and efficient process improvement, and enjoy new technological challenges.	jawef6139@gmail.comx	9420667460	\N	{}	2024-08-15 04:35:27	2024-08-15 04:35:27	t	t
640f9275-c0b0-484f-9cb2-75a989bee218	59466279-f98e-4421-b2b8-9c1d41fb2e2c	好好	\N	我是一名精通最新IT技术和趋势的IT专业人员。我在云计算、网络安全和数据分析方面表现出色，并追求数字化创新。	leeahn605@gmail.com	13204330786	\N	{咨询}	2024-01-13 03:19:46	2024-01-13 03:19:46	t	t
92ae90dd-fdd1-4dad-b3b4-3ec32319ad81	704659f3-e212-472b-951d-80c1d942b506	정의섭	\N	세상을 이해하고자 하는 깊은 호기심을 바탕으로 혁신적인 연구를 수행하는 연구자입니다.\n기계공학 전공을 바탕으로 공학적인 배경을 마련하였며,\n특허정보 분석을 통하여 개방혁신에 대한 연구성과를 이루었습니다.\n지금까지 연구한 결과를 기업, 대학, 연구소에 있는 연구자 및 기업가들과 개방 혁신을 이루면 좋겠습니다.	esjng@kisti.re.kr	01093559190	\N	{"analyze ",consulting,engineering,"information analysis"}	2024-02-05 02:42:04	2024-02-05 02:42:04	t	t
ce381e41-c72c-45de-b82a-a20b875b76ac	1930e4d2-242f-4c7d-87aa-66db6371395b	Carot18	\N	công việc tự do và phát triển nó theo những gi mình thấy đúng😁(cá nhân hóa mọi việc theo hướng tích cực... hợp pháp ) 	suong0907687828@gmail.com	932868488	\N	{"HONG SUONG","NGOC THACH","PHU THIEN","THIEN THANH"}	2024-02-19 13:16:48	2024-02-19 13:16:48	t	t
a8e0188f-2476-4fc0-b5a0-fab650ec6cda	c1805abd-7775-4ff5-a06f-cb43b07f023a		\N		noeyes.hama@gmail.com	\N	\N	{}	2024-02-04 03:52:41	2024-02-04 03:52:41	t	t
7f7f90b3-3c7f-4fe1-bc81-8b4e8d6a2eee	39abb322-c9b3-4363-9d47-9d7f14f50069	tp	\N	farmer	phuntshotsherings43@gmail.com	17300300	\N	{"bd word ",Cpu,Mouse,"small letter"}	2024-07-14 18:19:24	2024-07-14 18:19:24	t	t
ce02302b-2115-4918-93d4-66ba2b5fdf29	60aaec3d-f58b-40c4-8ecc-f12c307faf17	Jaspreet	\N	I am a businessperson with an exceptional ability to turn visions into reality. I pioneer new markets with innovative ideas and strong business strategies.	bausingh379@gmail.com	991559825899155	\N	{Jaspreet,"Jaspreet "}	2024-02-18 03:11:46	2024-02-18 03:11:46	t	t
d65822df-256e-44e5-b977-af6b829c863b	96df6d8a-d5e1-44f8-8332-85d90241802c	진정호	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	3366650490	01056671010	\N	{"전국꽃배달유통 "}	2024-02-28 11:42:30	2024-02-28 11:42:30	t	t
d2901d39-652e-40e8-803f-be1586b79074	9cd54584-17b2-4cc0-956f-df5ed34ffe56		\N		gohilajitsinh385@gmail.com	\N	\N	{}	2024-07-12 16:55:27	2024-07-12 16:55:27	t	t
152fa456-cf62-4b7b-8283-34f56702ac14	79abd7eb-b131-4f1c-b03d-5462da497227		\N		prasadmahaveer934@gmail.com	\N	\N	{}	2024-08-10 00:39:46	2024-08-10 00:39:46	t	t
abc84fa1-ff78-44ae-b22b-73ccd7a6b34e	bf0c880e-de71-403a-8309-b00019534fb2		\N		ashokchoube79@gmail.com	\N	\N	{}	2024-08-10 10:36:47	2024-08-10 10:36:47	t	t
f774734f-f0ff-4652-bf75-9988126b84a5	40261e09-5752-408b-8626-1a5c37c8c471		\N		gopalsiyapuregopalsiyapure9@gmail.com	\N	\N	{}	2024-08-14 14:11:20	2024-08-14 14:11:20	t	t
8ecdaf8b-c477-4129-a090-dfbcafa5da98	f9704227-3e08-4712-b610-1c6322be6c1f		\N		3417933608	\N	\N	{}	2024-04-02 00:12:46	2024-04-02 00:12:46	t	t
4d862d6b-afed-4c91-80c0-12c03a2aa023	c009e9c3-812b-4298-ba20-7fc1172e42fa		\N		hatienhtkg12344@gmail.com	\N	\N	{}	2024-04-05 11:44:14	2024-04-05 11:44:14	t	t
4b9229b0-2c27-4175-9f3f-9bf43e224bd6	60695308-c9d9-4a9a-ad63-60370cc247ce		\N		ziangocampo@gmail.com	\N	\N	{}	2024-04-14 12:33:01	2024-04-14 12:33:01	t	t
d501ce7b-8ed2-44e5-a7a3-79cf5be7295b	3e6671fd-015f-4c7b-a993-fea352101423		\N		lalchadsk442@gmail.com	\N	\N	{}	2024-06-05 03:17:11	2024-06-05 03:17:11	t	t
9ba286db-d6b3-471a-98fd-cd0a06207d77	758d00ef-b613-494d-b755-7126564cd2e2		\N		4sqtfrmdkzmd4wfuhj3sp5k7dm-00@cloudtestlabaccounts.com	\N	\N	{}	2023-12-14 10:11:16	2023-12-14 10:11:16	t	t
fd1c925e-aeef-4cff-8aa9-de2728ebad5b	12687c62-17d7-4653-a2ad-d9f91bb69992		\N		janm11447@gmail.com	\N	\N	{}	2024-07-09 10:00:19	2024-07-09 10:00:19	t	t
4bc31b7a-bb4b-4f23-ab67-47e7935ff093	5abe2855-da1a-4186-87b6-2196b6291e10		\N		shivajiaher314@gmail.com	\N	\N	{}	2024-07-24 21:25:31	2024-07-24 21:25:31	t	t
f26a68e4-08d0-44f2-a6fc-dff443fa113c	d2b0fa1d-1b38-4c39-a72a-9918682b25b6		\N		virendrpalsingh9@gmail.com	\N	\N	{}	2024-07-17 00:30:15	2024-07-17 00:30:15	t	t
b53ad4ba-8b86-4cb5-8f2c-5426f3b47e0f	ffe2e58a-8157-44db-b0ca-6113571ae3bb		\N		sajidkhan03932@gmail.com	\N	\N	{}	2024-08-14 02:55:44	2024-08-14 02:55:44	t	t
a2ce4556-e1a5-4154-bb43-f3096c234426	8dc9ae99-a83c-48c6-88c3-ffa6bca97ecd		\N		sangmagisimia@gmail.com	\N	\N	{}	2024-08-12 03:57:06	2024-08-12 03:57:06	t	t
f85efc63-e6c6-4dcd-a45f-29851d9f9070	6a40739f-2cc4-4e8d-ac39-87e2c255e86f		\N		6kob630413@gmail.com	\N	\N	{}	2024-03-26 09:51:24	2024-03-26 09:51:24	t	t
4211090f-652f-41c1-880a-30a7b7b298ef	67c3e10b-948b-4b7d-9fff-3977e935b4d9		\N		mundisaharsahar@gmail.com	\N	\N	{}	2024-08-10 01:30:37	2024-08-10 01:30:37	t	t
bd5837e4-21d9-4cf1-8d86-6359d51f4ed4	4e8d66c7-a9be-4ce9-8871-688be508e47b	Virendra Kumar	\N		vk4861872@gmail.com	9079143384	\N	{}	2024-08-08 11:08:27	2024-08-08 11:08:27	t	t
ba01db86-6e3f-47a8-bacf-656a0951762d	12f68791-85a0-41c8-8b5d-e80943e321da	정재윤	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	ywtour777@naver.com	01089006060	\N	{결혼정보,여행,외식업,한복렌탈}	2024-02-21 02:15:22	2024-02-21 02:15:22	t	t
78df1f41-1eb6-4a58-9995-38153458d19e	c7471f0d-87d3-4472-a445-71e388484616	badjailo	\N	I am a scientist who conducts innovative research based on deep curiosity about the world. I have made significant discoveries in the fields of life sciences and environmental science.	meljustin.Andales@yahoo.com	09355737182	\N	{buan,wet}	2024-03-12 23:21:07	2024-03-12 23:21:07	t	t
8ef06b28-5c4c-4641-b438-edec46185de8	8b78b3ad-31c6-49d5-9cd1-a393f82c0614	jonhraiven	\N	I am an IT professional well-versed in the latest IT technologies and trends. I stand out in cloud computing, cybersecurity, and data analysis, and pursue digital innovation.	edniegarcia13@gmail.com	693451	\N	{"Jonhraiven@071925.com ",marinasummer@20978,"marlyn@251907. com","moanajoy@192007. com"}	2024-03-15 05:08:14	2024-03-15 05:08:14	t	t
d86b8cee-9d64-44be-84b7-1ca93cd3dba0	ee975d9a-24ad-4738-820e-d2537dfa7cbb	Đàm Văn Huy	\N	Tôi là một bác sĩ nội trú giàu kinh nghiệm với hơn 10 năm trong lĩnh vực y tế. Tôi ưu tiên sức khỏe của bệnh nhân và luôn cập nhật các nghiên cứu và điều trị y khoa mới nhất. Tôi mong chờ được chia sẻ kiến thức cho một cuộc sống khỏe mạnh.	nhathuy110290@gmail.com	0368473162	\N	{huy}	2024-03-26 16:49:30	2024-03-26 16:49:30	t	t
0f111356-33ac-4acd-ad34-fca2cadaf94c	998a1f5c-0ce8-43d0-addb-c6861ab126d9	장원철	\N	학생들의 가능성을 최대한 발휘할 수 있도록 돕는 열정적인 교사입니다. 혁신적인 교육 방법과 기술을 통해 학습 경험을 향상시키고자 합니다.	wcjang@dankook.sc.kr	01088140059	\N	{"교육 및 비즈니스 컨설팅",교육자,"분자진단 전문가","산학연 컨컬팅"}	2024-05-23 02:35:54	2024-05-23 02:35:54	t	t
a1f3b4f2-bb9c-4b08-927f-900777fcb431	78587ca2-7caf-4b23-a0b0-16abff115c30	김윤경	\N		kimyungyeong@gmail.com	01028608050	\N	{반도체,사회적기업,컨설팅,컴퓨터공학}	2024-01-06 01:18:48	2024-01-06 01:18:48	t	t
1d93a232-3d7b-4cae-8924-b208a536ec65	66324a2e-a1aa-41ae-ad82-1e3edb50b082	김형근	\N		ksesa77@gmail.com	01027360697	\N	{"HR Consulting"}	2024-02-03 16:15:08	2024-02-03 16:15:08	t	t
023b423e-054d-46f8-a9a0-745b1e648274	e6038c5d-fa9f-4174-b01f-146a496ee2a8	신경원	\N	창의적이고 전략적인 사고를 바탕으로 브랜드의 가치를 높이는 마케팅 전문가입니다. 소셜 미디어, 콘텐츠 마케팅, 시장 분석 분야에서 경험을 쌓았습니다.	3352570824	01043088053	\N	{나}	2024-02-20 10:03:44	2024-02-20 10:03:44	t	t
8c7cce07-5a9e-4f57-ba70-6284ea6c1407	c75d3de2-68b2-41b1-ad03-687393e3eca1	이수민	\N	관리부입니다.	sumini522@naver.com	01048518805	\N	{사무용가구,인테리어}	2024-07-15 04:50:50	2024-07-15 04:50:50	t	t
d31d0240-7b7d-44ef-a0ce-4357bfb8732f	e734c06e-ec1c-49bb-a28c-dce97b038aa5		\N		3328168258	\N	\N	{}	2024-02-03 23:07:21	2024-02-03 23:07:21	t	t
3de8c41f-ad05-45c0-9ad2-079d467e8e43	0cf57fec-fb2a-4d9e-8b55-0a0dc460be2e		\N		rawatrathore02@gmail.com	\N	\N	{}	2024-07-11 17:49:58	2024-07-11 17:49:58	t	t
e84648cc-96ab-40fd-8cbb-b04d570e569f	2d5013c7-9091-450a-847d-ed5108d415f6		\N		nguyennnguyen514@gmail.com	\N	\N	{}	2024-02-19 16:42:25	2024-02-19 16:42:25	t	t
f1861069-fe81-474d-b10c-0307c3e7dbf0	5b2edbec-d698-4ea8-8a27-d8bcc7e74ffa		\N		drajuverma2@gmail.com	\N	\N	{}	2024-02-17 17:23:03	2024-02-17 17:23:03	t	t
752c6109-9861-49cf-ba27-a35d4f4f5276	9c43b826-e7e6-45af-b998-6a36c665dd66		\N			\N	\N	{}	2024-07-22 02:51:12	2024-07-22 02:51:12	t	t
6f0343f7-2409-4551-84f0-3707785ecf86	ebceb499-ed99-497e-9f03-3be25d554fa5		\N		afzalmalik8019@gmail.com	\N	\N	{}	2024-08-10 16:50:12	2024-08-10 16:50:12	t	t
b152329f-9200-49cb-be1c-db970a5a17db	64790acb-8a74-4cb4-8505-2152fdb18913		\N		nileshzawar441@gmail.com	\N	\N	{}	2024-08-14 12:59:18	2024-08-14 12:59:18	t	t
994ab550-6481-44ec-b996-6fffdb5d7780	b9612053-c423-42f1-8129-a69d83a4227f	주식회사 에스엠비젼솔루션	\N	주식회사 에스엠비젼솔루션	vision8259@naver.com	\N	\N	{}	2024-03-21 05:34:59	2024-03-21 05:34:59	t	t
70e7e45e-49b2-459c-abec-29b8db470b6a	3d7a647b-d4d3-45fa-9d1b-cdf8e38bd747		\N		dinhvanthat1953@gmail.com	\N	\N	{}	2024-03-26 04:18:31	2024-03-26 04:18:31	t	t
99cb6b31-3c72-43dd-8d61-9d0d4b2e01fa	d43e69cd-1f95-4c78-852d-a87045535739		\N		3417065553	\N	\N	{}	2024-04-01 08:53:48	2024-04-01 08:53:48	t	t
57a8cc55-e535-4a98-a26f-2d22158aef3e	ea730390-e55a-4d93-bc97-4cf4ec5d1b28		\N		3418041632	\N	\N	{}	2024-04-02 01:32:23	2024-04-02 01:32:23	t	t
c2b56bdb-1134-4473-9804-4f80d7114df3	9c4c3855-f8c8-4567-b5f9-db4c8d90b4e5		\N		3221848571	\N	\N	{}	2023-12-13 02:02:05	2023-12-13 02:02:05	t	t
74f2dd17-bc34-4b79-9f07-b81302260995	420f5e1d-bd4e-4de7-827f-8386846edd85		\N		naravdemohan@gmail.com	\N	\N	{}	2024-05-24 11:50:22	2024-05-24 11:50:22	t	t
b414966e-4fb5-45be-abf6-2be320b7a015	93f559c3-0db5-4d3e-9463-57a5729ae794	양영국	\N	세상을 이해하고자 하는 깊은 호기심을 바탕으로 혁신적인 연구를 수행하는 과학자입니다. 생명 과학과 환경 과학 분야에서 중요한 발견을 해왔습니다.	eewoo67@naver.com	01056118289	\N	{미생물,버섯,조직배양,줄기세포}	2024-03-11 04:22:32	2024-03-11 04:22:32	t	t
3acc9dd7-d294-4c99-91ec-9f3ff3794e2a	d0104fdf-dc7c-451c-8f1f-3f9abb4de8e9	박인엽	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	orgapark@naver.com	1051813680	\N	{"무역 수입 수출",설탕,"식품 및 식품첨가물",유기농설탕}	2024-02-28 09:00:04	2024-02-28 09:00:04	t	t
1eac6531-738f-4034-a11a-7607bd33a866	3c10a153-3a55-4164-9729-5b7ada3ab60a	Roger Tismo	\N		tismoroger038@gmail.com	9993947310	\N	{r}	2024-03-15 04:54:55	2024-03-15 04:54:55	t	t
050f05cb-e0a6-4eb1-826b-4aa8934240f1	1aa37920-edce-42e7-98eb-4c32345cc71a	박영택	\N	블록체인 핀테크	mypoktan@naver.com	1057758989	\N	{#ai,#블록체인,#핀테크}	2023-11-17 03:38:16	2023-11-17 03:38:16	t	t
6a5bb302-fcab-4da9-aa9e-c4cb542a2f69	1d139ae7-6402-4ca1-bfbc-79635ba7a81f	양창수	\N	최신 IT 기술과 트렌드에 정통한 IT 전문가입니다. 클라우드 컴퓨팅, 사이버 보안, 데이터 분석 분야에서 두각을 나타내며, 디지털 혁신을 추구합니다.	unicellbio@gmail.com	01024836890	\N	{ai,futures,marketing,"network marketing "}	2024-05-31 07:44:28	2024-05-31 07:44:28	t	t
0767ac52-9b83-45d5-a7e5-830cd56f7e08	69fc4171-6fad-4eaa-a382-8994f76b1f8a	김경덕	\N	창의적이고 전략적인 사고를 바탕으로 브랜드의 가치를 높이는 마케팅 전문가입니다. 소셜 미디어, 콘텐츠 마케팅, 시장 분석 분야에서 경험을 쌓았습니다.	bobos1973@gmail.com	01034734004	\N	{vape}	2024-07-02 10:52:27	2024-07-02 10:52:27	t	t
61680f8b-c930-4218-b5bc-2919ec65a579	7672ded2-36c6-40e6-8d4a-9090ba8f8957	shri kant 	\N	I am an experienced internist with over 10 years in the medical field. I prioritize patients health and always stay informed about the latest medical research and treatments. I look forward to sharing knowledge for a healthy life.	skt6229@gmail.com	9149225496	\N	{hindi}	2024-02-17 15:56:00	2024-02-17 15:56:00	t	t
e2ef565a-0b8f-4922-8314-4254c61de143	dd01f65c-2ba8-4827-8dc5-093986853500	신미연	\N		dior1234@hanmail.net	01099915486	\N	{약}	2024-03-13 07:25:32	2024-03-13 07:25:32	t	t
e9498e46-914f-436f-ba4a-124ec6e5fee5	2e2f3722-f5cf-4187-8ef0-b5bcdf3c0e0a	강윤애	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	kya600613@gmail.com	01057554720	\N	{코인검색}	2024-03-16 03:02:32	2024-03-16 03:02:32	t	t
f41ef171-cd86-46c1-b293-c852e51a2eae	14c41bb4-2aef-4491-b933-c4fb8ce2f4a5	Binoy Murmu 	\N		bm2801072@gmail.com	7864954483	\N	{12345,123456,1234567,12345678}	2024-09-07 02:11:12	2024-09-07 02:11:12	t	t
5c5ea2f3-906a-44bb-b2ab-faf07cf89709	ca0cdbdd-4d9e-4355-9804-381859c3d945	김치민	\N	최신 IT 기술과 트렌드에 정통한 IT 전문가입니다. 클라우드 컴퓨팅, 사이버 보안, 데이터 분석 분야에서 두각을 나타내며, 디지털 혁신을 추구합니다.	chiminkim46@gmail.com	51703073	\N	{chi,"general ",kim,min}	2024-03-26 09:10:04	2024-03-26 09:10:04	t	t
5f606cef-810d-403a-98a6-d90e4ed60dd1	6895b079-41da-4c80-9b03-a13205bca38d	Jun Bong Woo	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	ocvina.ec@gmail.com	966900018	\N	{jinggiskan}	2024-04-16 02:46:30	2024-04-16 02:46:30	t	t
ad3e02c3-dc52-4e31-8cb7-4f6ab2db89cb	537a94cd-158f-4aea-a4bb-83ff68cbde6c	gilbert cerda	\N	try and try until you succeed	gilbertcerda2126@gmail.com	9614440751	\N	{consulting}	2024-04-16 12:37:46	2024-04-16 12:37:46	t	t
c2c14f4d-d626-4909-8d44-d4a9d2d6cf32	287c5e40-a285-4115-a559-f0f4d06b16fd	Lê Hoàng Tú	\N	Tôi là một đầu bếp chuyên nghiệp chinh phục trái tim mọi người với ẩm thực kết hợp truyền thống và đổi mới. Tôi theo đuổi việc nấu ăn cân bằng giữa hương vị, sức khỏe và thẩm mỹ.	hoangtu021012@gmail.com	07739507769	\N	{1,6}	2024-02-17 07:25:06	2024-02-17 07:25:06	t	t
174cb079-2d38-46ee-b5fe-894c34fba301	688d0ae3-2734-46f8-94ba-26314aeec7c9	Minh 	\N	Tôi là một chuyên gia tiếp thị tăng cường giá trị thương hiệu thông qua tư duy sáng tạo và chiến lược. Tôi đã tích lũy kinh nghiệm trong lĩnh vực truyền thông xã hội, tiếp thị nội dung và phân tích thị trường.	minhtran020987@gmail.com	918910936	\N	{"Tư  vấn ","Tư vấn "}	2024-02-18 04:24:39	2024-02-18 04:24:39	t	t
cadeeb77-3948-49df-9560-63b322b05c61	39994d24-98f0-4705-a971-da939a806643	Trần suol 	\N	Tôi là một chuyên gia tiếp thị tăng cường giá trị thương hiệu thông qua tư duy sáng tạo và chiến lược. Tôi đã tích lũy kinh nghiệm trong lĩnh vực truyền thông xã hội, tiếp thị nội dung và phân tích thị trường.	banhuotthutam@gmail.com	0389233842	\N	{an,binh,"có ","lộc "}	2024-07-24 14:00:40	2024-07-24 14:00:40	t	t
19202bce-3506-4f98-bf97-174c678fba82	f15526e3-6f68-4ccc-9e5e-7bafdb1526c6	Aaron	\N	I am a creative architect focusing on modern and sustainable architectural design. I strive to realize clients dreams by combining the beauty and functionality of space.	aaronbruce859@gmail.com	9515002984	\N	{"be happy","chill life","good person","respectful "}	2024-03-14 00:46:10	2024-03-14 00:46:10	t	t
aacbdf05-6bd0-476c-8080-2866ecb5b38d	9ad52132-dccb-4d28-99f4-42741d965f04	leonardo o felecio	\N	I am a businessperson with an exceptional ability to turn visions into reality. I pioneer new markets with innovative ideas and strong business strategies.	leonardo.felecio@gmail.com	095053*75061	\N	{along93060a}	2024-04-02 04:58:04	2024-04-02 04:58:04	t	t
17c0b780-f2af-4a3d-a5cf-8078460529b1	253f99af-df47-4dac-a786-bee047c48dfe	최석하 	\N		3434017726	1049563553	\N	{석하}	2024-04-12 12:31:11	2024-04-12 12:31:11	t	t
7c682464-37c4-4a90-bef6-9fe30ba6d859	8aad06a4-5b48-41bf-8bff-e965cd620dc2	이기은	\N	8년 경력의 출판 마케터 입니다. 서점 채널 관리/sns인플루언서 마케팅등을 진행해본 경험이 있습니다.	inalove2@gmail.com	01080584387	\N	{book,marketing,publishing}	2024-04-25 12:27:10	2024-04-25 12:27:10	t	t
dfa59ba6-39a6-4227-899c-79ed3d755a09	33623ecd-ba1c-4a03-bae0-ea896db1c904	이재호	\N	기업 품질심사원 ISO 9001 assessor 	jhlee8255@hanmail.net	1036346917	\N	{"consultation ",iso9001:2015,"quality system assurance "}	2024-05-17 11:14:02	2024-05-17 11:14:02	t	t
6ac3aa24-0718-4d21-a43d-acfc4a66cdd3	6a02feec-a567-4aa4-b13d-31e30f98d102	rirang	\N		kimthibaclan17@gmail.com	0694280	\N	{135478,154879,47270,5773/8}	2024-03-12 12:03:19	2024-03-12 12:03:19	t	t
3d40940b-c8c7-485e-88ce-4dee67e3463c	8490695f-9b65-4b5a-b9ee-2a0987b921dd	Hoàng 	\N		hoangbm80@gmail.com	978324331	\N	{"Hoàng "}	2024-03-13 10:59:35	2024-03-13 10:59:35	t	t
8b946e15-4517-46e6-957d-eb82653e1589	4984de33-b164-4eba-82be-5383f76252c8	이일섭 	\N		isleeis@naver.com	1022952115	\N	{"세무 "}	2024-09-09 01:57:28	2024-09-09 01:57:28	t	t
224116f2-d9de-4ed0-9aa6-8df58732f635	da858fc6-d2bd-43ca-99cc-671e825ad02b	최순천	\N	혁신적인 기술 솔루션을 개발하는 데 열정적인 기계 엔지니어입니다. 지속 가능한 설계와 효율적인 프로세스 개선에 중점을 두고 있으며, 새로운 기술 도전을 즐깁니다.	csc5001@hanmail.net	1056705002	\N	{계시록,기능장,"석사학위 ",성경}	2024-05-15 10:37:26	2024-05-15 10:37:26	t	t
1e64f41c-6065-4dee-8ebf-0e1b5d0f1efb	5a5671ae-271c-498e-8103-a7407d08f60c	satish 	\N	I am an experienced internist with over 10 years in the medical field. I prioritize patients health and always stay informed about the latest medical research and treatments. I look forward to sharing knowledge for a healthy life.	satishraju677@gmail.com	9344567999	\N	{660066}	2024-05-26 00:32:05	2024-05-26 00:32:05	t	t
3feb8f9c-dbd2-4f38-94f6-a8ad5155ed2a	b93cd121-1d2c-4c9f-9f1c-ea09efc255df	김경희(더엘라)	\N	핸드백 가방 굿즈상품 디즈니라이센스가방제작 ODM가능 미키가방제작 	jolie-123@hanmail.net	01087651088	\N	{"굿즈상품  주문제작 가능","디즈니 가방주문 제작 가능","여성핸드백 주문제작 가능","인플루언서 가방주문 제작 가능"}	2024-02-20 09:26:29	2024-02-20 09:26:29	t	t
b866c977-d86c-4583-9695-b355ec86da0e	efaa39f8-49da-4aed-93e9-e2ea217fc9b8	이종우		최신 IT 기술과 트렌드에 정통한 IT 전문가입니다. 클라우드 컴퓨팅, 사이버 보안, 데이터 분석 분야에서 두각을 나타내며, 디지털 혁신을 추구합니다.	rain3834@naver.com	1099114011	\N	{보안,시큐리티,정보보호,컨설팅}	2024-09-25 05:32:44	2024-09-25 05:32:44	t	t
174fdcad-ae75-4310-a098-c094faab82e6	b9157f2d-642d-4b0f-8398-695f58c8e8bc	하영재	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	espana01@hanmail.net	1050720668	\N	{NGO}	2024-06-27 08:22:30	2024-06-27 08:22:30	t	t
205485c7-c846-4ec4-9071-80ed321aa070	ff1e3517-5b3d-4801-bbea-3c868bf28838	Tess Yoon 	\N	세상을 이해하고자 하는 깊은 호기심을 바탕으로 혁신적인 연구를 수행하는 과학자입니다. 생명 과학과 환경 과학 분야에서 중요한 발견을 해왔습니다.	3370830845	01021066626	\N	{"TSID 인증 엔진 "}	2024-03-02 07:51:53	2024-03-02 07:51:53	t	t
924fd21b-f115-4d41-a158-caa8f156932d	838a9ef3-af3e-4655-99b5-a06134155c07	Joel	\N	Soy un empresario con una habilidad excepcional para convertir visiones en realidad. Pionero nuevos mercados con ideas innovadoras y estrategias comerciales sólidas.	joel.domenech@gmail.com	620456600	\N	{ingeniero}	2024-10-03 10:16:30	2024-10-03 10:16:30	t	t
5a2325df-ae73-4bfd-b382-d3078a8ce517	aed87ec2-821a-4b30-9f4f-49bca8ff5f92	बबलू	\N	मैं एक पेशेवर शेफ हूं जो परंपरा और नवाचार को संयोजित करके व्यंजनों के माध्यम से दिलों को जीतता हूं। मैं स्वाद, स्वास्थ्य, और सौंदर्य के संतुलन वाली खाना पकाने का पीछा करता हूं।	kbablu1345@gmail.com	9783848154	\N	{4444}	2024-08-14 17:42:09	2024-08-14 17:42:09	t	t
2e72c614-7d53-4f35-aaa8-f7a30482b830	11b69bd0-c362-482b-a2dc-9a42ca65b4ed		\N		3329909925	\N	\N	{}	2024-02-05 03:32:21	2024-02-05 03:32:21	t	t
aef7b623-1e98-4ffa-86f8-e1e43a49e4f6	0ff90b8d-2766-423f-aee7-0393dae688ea	이헌준		법률 분야에서의 깊은 지식과 실무 경험을 바탕으로, 복잡한 법적 문제에 대한 명확하고 실용적인 해결책을 제공합니다. 상업 법률, 지적 재산권, 민사 소송에 특화되어 있습니다.	lawjeongnheon@gmail.com	01040369368	\N	{법률,변호사,소송,자문}	2024-03-15 10:27:33	2024-03-15 10:27:33	t	t
2f6c1fcd-4525-4f2f-82d0-a5697f755ad4	17cbb8b4-443f-4301-aac0-2179e2caa7e1		\N		3352242485	\N	\N	{}	2024-02-20 06:19:48	2024-02-20 06:19:48	t	t
1ec358be-a05a-45cd-8fef-8b20913f1aa5	0c52f7a4-4b0f-4a58-a5be-4b2e165cb879		\N		kaushlyakumari505@gmail.com	\N	\N	{}	2024-07-24 09:16:11	2024-07-24 09:16:11	t	t
38c42d76-44bd-400e-a327-154d9b9875eb	706ae8d3-4398-4f3a-b0c4-d2476d6e9d97	김신정	\N	창의적이고 전략적인 사고를 바탕으로 브랜드의 가치를 높이는 마케팅 전문가입니다. 소셜 미디어, 콘텐츠 마케팅, 시장 분석 분야에서 경험을 쌓았습니다.	3447348729	01097253988	\N	{1월1일}	2024-04-21 09:41:24	2024-04-21 09:41:24	t	t
0bbcdac1-5f72-4ed8-9bb9-af13508be329	9f220330-cbca-4a77-83da-46c86400d830	Shakti tripathi 	\N	I am a passionate mechanical engineer who develops innovative technological solutions. I focus on sustainable design and efficient process improvement, and enjoy new technological challenges.	salestechnik@gmail.com	9793981818	\N	{"Shakti "}	2024-07-14 16:38:19	2024-07-14 16:38:19	t	t
89974411-7b8f-4c9d-b304-bd92d6539840	22921271-6e10-4457-b991-57d5bf3c2b86		\N		3399769628	\N	\N	{}	2024-03-21 00:50:45	2024-03-21 00:50:45	t	t
4dbd4e4b-9cbd-4a44-a1e2-93624fab7a5f	5e837acd-dae2-4186-b57c-ae70ee945f8a	김태영	\N	디자인 컨설팅, 해외시장 개척, 마케팅	heyou99@naver.com	1096806536	\N	{anti-aging,beauty,health,"health supplement"}	2024-03-21 13:55:15	2024-03-21 13:55:15	t	t
bf493672-a68c-43c5-8308-ac3736968fc0	29a63532-c5b1-4ebb-bba4-9a22abdd986c	박창우	\N		changwoo1208@naver.com	01040967820	\N	{flutter}	2023-11-13 01:25:04	2023-11-13 01:25:04	t	t
51c7d964-4ecc-4d5c-99f3-d19d6c34c6d7	1a25e573-3158-4107-bc5b-765cdd926261	pavani	\N		pavani@Nagaraju..com	7337433772	\N	{pavani}	2024-05-10 08:00:44	2024-05-10 08:00:44	t	t
46737bdc-5647-4fcd-bd36-d0592b893c6c	887a9751-922b-4b58-8e4e-80e1f069afbe	백옥현	\N	사무용가구 전문점 (주)비엔비퍼니처를 운영하고있는 가구쟁이 백옥현 입니다 	3352519420	01042324003	\N	{사무용가구,시디즈,중고가구,퍼시스}	2024-02-20 09:26:36	2024-02-20 09:26:36	t	t
2274f66b-d9a4-44ed-9d17-82c16429fd38	6850cb8f-da10-41ea-9859-c7dd9a5d7d41		\N		ddzcffdd@gmail.com	\N	\N	{}	2024-05-28 16:22:40	2024-05-28 16:22:40	t	t
4a182035-f5b6-4c2e-a1fa-86c45e2387f3	e5a95fef-9596-4e36-9751-32c42118cb96		\N		tt6587280@gmail.com	\N	\N	{}	2024-02-20 12:41:11	2024-02-20 12:41:11	t	t
be125c9d-8524-49cf-82fc-ba3cab84087d	ac8046ab-5699-4eda-bde8-056ccc1dcda0	김욱	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	bosungca@naver.com	01052221729	\N	{무역,부동산개발,사업컨설팅,중국불산시한국대표소}	2024-02-21 12:18:24	2024-02-21 12:18:24	t	t
38e0f515-38e0-4ea9-8c71-676a9d7898fb	30ff9403-8e38-41f1-a1a6-df011dc762a9		\N		tulumonisaikia289@gmail.com	\N	\N	{}	2024-07-31 15:02:13	2024-07-31 15:02:13	t	t
677abb65-d47e-471e-82ac-1573fa0928d6	45b5772d-25aa-4cbf-b564-c3bd5fd55394		\N		md.abdulalim00007@gmail.com	\N	\N	{}	2024-08-08 18:29:25	2024-08-08 18:29:25	t	t
56df288d-e8ae-4946-8f07-6a41fb43d62c	5d5ec654-51a2-4f87-bd39-c56d358f6ea5	신아인	\N		ain991204@gmail.com	01062605020	\N	{key}	2024-04-05 03:40:34	2024-04-05 03:40:34	t	t
65e75f27-7793-4c79-9271-04243baf8ad8	aef43db0-218c-4ac1-9b2a-4d8dddef9a5b		\N		sp923960@gmail.com	\N	\N	{}	2024-08-08 11:31:59	2024-08-08 11:31:59	t	t
13871407-a644-4018-a57d-8fb828be21fd	2320d2eb-0465-4005-9f06-5d1975722fa0		\N		izzatqoldoshev10@gmail.com	\N	\N	{}	2024-08-17 16:17:27	2024-08-17 16:17:27	t	t
86c65a05-063f-4c16-998e-acda997a022b	c91353ba-030d-4d42-a163-fa9ee189d917	Michael Magtoto	\N	I am a professional artist who expresses emotions and stories through visual language. I experiment with various mediums and styles, sharing creativity and artistic insight.	michaelmagtoto501@gmail.com	9078926671	\N	{1,5,7,9}	2024-04-04 01:37:58	2024-04-04 01:37:58	t	t
b7ee4d20-4d61-4fd1-b72a-e66803322cce	1435e589-852b-424c-afa4-31163a82a769	Jan reiner	\N	I am a professional artist who expresses emotions and stories through visual language. I experiment with various mediums and styles, sharing creativity and artistic insight.	mairalyn.belarma1997@gmail.com	1111	\N	{Bree,Hello}	2024-02-19 15:54:10	2024-02-19 15:54:10	t	t
a72908aa-7ee2-4e65-bcf8-44b432c57ab0	d545b20a-1938-4112-a021-eeadd68c67f3		\N		t01039076063@gmail.com	\N	\N	{}	2024-03-25 12:16:28	2024-03-25 12:16:28	t	t
6314d1fc-f0fa-4688-b092-17bbf4a481f8	a2b27317-a6a4-451c-80c1-d2d713ddce4f		\N		3812005330	\N	\N	{}	2024-11-28 23:54:21	2024-11-28 23:54:21	t	t
cff8a713-f3d0-48cc-9e80-c79d46a2cf58	0a6da93a-b562-4cb1-ae3c-3c03dff24ab5		\N		3418195601	\N	\N	{}	2024-04-02 03:22:46	2024-04-02 03:22:46	t	t
5dcb9fe7-1087-461b-881b-466f99e23730	2cce5b27-168f-4bc5-b6e9-397aa126e754		\N		3207007431	\N	\N	{}	2023-12-02 18:01:24	2023-12-02 18:01:24	t	t
2b5f8aac-edc3-4297-b669-226beb42c04c	9286bd31-585b-4648-ac31-7d3f2a180ea5		\N		3228369533	\N	\N	{}	2023-12-17 11:00:57	2023-12-17 11:00:57	t	t
54eb9dfb-dbb8-45c6-b9d2-9ede5e0d4d05	b1cb2c7c-53bc-4a77-9764-ced8ee32cc5a		\N		3254824812	\N	\N	{}	2024-01-03 07:06:36	2024-01-03 07:06:36	t	t
be4eb02e-2450-48b9-86a0-821575dffca6	a0d0d478-0dd1-412d-9903-820dc812be22	मांगी लाल 	\N	मैं एक पेशेवर शेफ हूं जो परंपरा और नवाचार को संयोजित करके व्यंजनों के माध्यम से दिलों को जीतता हूं। मैं स्वाद, स्वास्थ्य, और सौंदर्य के संतुलन वाली खाना पकाने का पीछा करता हूं।	manguchandrawanshi73@gmail.com	7805884790	\N	{ok}	2024-07-12 12:06:28	2024-07-12 12:06:28	t	t
db29d391-b138-432a-9fc4-e4acaec6a715	aaad74f2-28d8-4410-b437-8c9c954a45bf	Thu Nguyễn	\N	Tôi là một giáo viên nhiệt huyết giúp học sinh phát huy tối đa tiềm năng của mình. Tôi nhằm nâng cao trải nghiệm học tập thông qua phương pháp giáo dục đổi mới và công nghệ.	nguyenhoaithu358@gmail.com	394088109	\N	{b}	2024-02-19 13:15:31	2024-02-19 13:15:31	t	t
9e47fc60-db02-4b7d-affc-35d5fe64191d	caf289ec-c0fd-4bd3-99bb-66d1e96ad09d		\N		nguyenxuantienvp06121982@gmail.com	\N	\N	{}	2024-04-02 15:36:17	2024-04-02 15:36:17	t	t
b327111d-aa5c-49e0-b184-d46e9d4cdb8d	44e02678-3c6c-4042-b9f8-d0738d1b9553	हरिष्कुमार	\N	मैं एक विपणन विशेषज्ञ हूं जो ब्रांडों के मूल्य को रचनात्मक और रणनीतिक सोच के माध्यम से बढ़ाता है। मैंने सोशल मीडिया, कंटेंट मार्केटिंग, और बाजार विश्लेषण में अनुभव प्राप्त किया है।	kumarharishkumar310@gmail.com	9235985204	\N	{हरी}	2024-07-26 19:56:09	2024-07-26 19:56:09	t	t
2d4037f0-8902-4869-ac1b-685a0828289f	592bf59f-0513-4bb9-8818-ac48970b4b6e	윤홍필	\N	현대적이고 지속 가능한 건축 디자인에 중점을 두는 창의적인 건축가입니다. 공간의 아름다움과 기능성을 결합하여 고객의 꿈을 실현시키고자 합니다.	herberthp@naver.com	01065909001	\N	{나눔,사랑,신뢰,진실된생각}	2024-12-20 09:24:21	2024-12-20 09:24:21	t	t
2d83d3d7-701e-482b-bd44-2f64a65c9328	1f687104-91d9-4244-bafc-dc2df4bb4720		\N		5prvteirmvbwbvzyvyztlwwexy-00@cloudtestlabaccounts.com	\N	\N	{}	2023-11-15 12:07:03	2023-11-15 12:07:03	t	t
7e2bcd81-034e-4096-8b8c-d9bde0caeca6	38735eef-62f6-418b-a02d-14bc0f491031		\N		3206239006	\N	\N	{}	2023-12-02 06:58:28	2023-12-02 06:58:28	t	t
52e86712-bce7-47fd-bb30-6432f8edc6c2	c4a37833-a371-486c-9eec-2266bdb30b57		\N		nanakaramananakaramajandu4@gmail.com	\N	\N	{}	2024-07-09 16:52:41	2024-07-09 16:52:41	t	t
5a10f208-b702-48ff-a534-ec78deac6a26	22d3e392-2c46-474d-ba13-0017ca9e76e0		\N		3606113873	\N	\N	{}	2024-07-03 01:45:47	2024-07-03 01:45:47	t	t
ea04fe1c-2707-4fb4-884a-f435853eefe2	773ddace-2da7-4b9f-876c-eb57da439b7a		\N		3329017571	\N	\N	{}	2024-02-04 10:27:58	2024-02-04 10:27:58	t	t
c35c3ffc-3896-4831-bf64-647ad09bc16f	a12ae9da-e57f-47ac-a76c-2f86549e6ad7		\N		mollarakibul995@gmail.com	\N	\N	{}	2024-07-09 19:57:40	2024-07-09 19:57:40	t	t
81625bec-ace7-4b4e-bde8-d36640c1ee1c	88831590-c263-4a56-ae1e-f248bdcf7078		\N		majidali79970@gmail.com	\N	\N	{}	2024-07-11 22:18:10	2024-07-11 22:18:10	t	t
c8b18845-0eb9-4956-832f-ce2317421311	10e2734b-e7c8-49b4-a152-2f6782d2db0b		\N		3400581798	\N	\N	{}	2024-03-21 08:18:56	2024-03-21 08:18:56	t	t
14631cf3-85fc-4c1c-9919-95491423f1a3	8f774139-39cf-4e29-84ac-03932c25fa2a	chiênn	\N	Tôi là một bác sĩ nội trú giàu kinh nghiệm với hơn 10 năm trong lĩnh vực y tế. Tôi ưu tiên sức khỏe của bệnh nhân và luôn cập nhật các nghiên cứu và điều trị y khoa mới nhất. Tôi mong chờ được chia sẻ kiến thức cho một cuộc sống khỏe mạnh.	giovudangbuon@gmail.com	0868478736	\N	{0868478736}	2024-04-15 02:06:58	2024-04-15 02:06:58	t	t
3a889652-3a5a-4f40-9ff1-fdf363ae734c	3cf14470-e612-407a-bd72-2a86c0e08560		\N		ellainejoyceagustin@gmail.com	\N	\N	{}	2024-03-25 12:25:28	2024-03-25 12:25:28	t	t
a9a9002a-b828-4065-b867-9249f589cda0	cc88328b-fdad-4772-8461-3a6e76b1996e		\N		zoukakrayem@gmail.com	\N	\N	{}	2024-11-21 23:00:14	2024-11-21 23:00:14	t	t
af86f21f-5d40-4eda-9c5c-a9c5fa6f2569	ee673763-a95f-43fa-a3bf-5efd8772ccdc		\N		3871494252	\N	\N	{}	2025-01-09 23:07:21	2025-01-09 23:07:21	t	t
994024bd-2077-43ec-89f2-4b3268197754	1613845b-8a02-4600-b09c-ad5231e5129a		\N		aador7813@gmail.com	\N	\N	{}	2024-05-09 22:25:07	2024-05-09 22:25:07	t	t
74617c25-fdea-45d6-893f-676b5da1524f	e85eb3c1-6e64-461a-88c0-2260e4085d63		\N		thapatanka344@gmail.com	\N	\N	{}	2024-07-15 08:26:29	2024-07-15 08:26:29	t	t
18bf2303-b384-4aaf-96ff-e9eda56e92e8	a02aa3c1-7a73-40b9-a307-f639e10caebd		\N		3352611570	\N	\N	{}	2024-02-20 10:33:13	2024-02-20 10:33:13	t	t
fd5e99a2-8a89-48e3-b3ef-ba94f030d47d	78bb8db7-6fdf-4ddf-b2ca-e495ecbd1fea		\N		3359984372	\N	\N	{}	2024-02-24 11:52:11	2024-02-24 11:52:11	t	t
d9d71654-8bb0-4812-a3de-f03cda8eee6e	98e102da-d110-44fe-9df5-ccebc0fb6837		\N		rajeshwarrajeshwar405@gmail.com	\N	\N	{}	2024-08-11 16:28:16	2024-08-11 16:28:16	t	t
17bd7d58-e592-429c-baf2-b92058a4aab6	b0fa13b5-d8ff-49dc-ac96-f5e719147d67		\N		rakeshtalawariya@gmail.com	\N	\N	{}	2024-08-15 04:34:28	2024-08-15 04:34:28	t	t
4bf8af5e-508c-4052-ae0d-2d49faa7e8de	2ed9c9cb-0bd3-46a6-82cf-87e99d4e7ad7		\N		vovand539@gmail.com	\N	\N	{}	2024-04-04 10:26:56	2024-04-04 10:26:56	t	t
61e1cdac-6057-42ad-a1c0-d16d13876604	7355b691-53d9-4dc5-9d43-59f3b385df74		\N		3164056818	\N	\N	{}	2023-11-15 07:49:26	2023-11-15 07:49:26	t	t
6ba644cd-0ff4-4848-a69b-85aebe8242f9	830c23fa-1016-476d-8347-b2b05cd6be87		\N		3332652157	\N	\N	{}	2024-02-07 02:03:14	2024-02-07 02:03:14	t	t
7cacb4b1-021d-4014-a370-5656f609cb2c	a3e95b73-8f3f-4c26-9329-0030b4d7e6ac		\N		poulimgaidangmei552@gmail.com	\N	\N	{}	2024-07-09 20:02:41	2024-07-09 20:02:41	t	t
e45b637f-0264-4eb6-a75a-cb4e1ec4962b	7149cedf-42b3-431a-8fd2-6b8befe93ab8		\N		pautombing18@gmail.com	\N	\N	{}	2024-07-11 00:21:40	2024-07-11 00:21:40	t	t
3fc8337c-1b56-4510-a80b-2be681221631	9c92bc5d-6c5d-44b4-bccc-0777b53f8375		\N		pankajk29184@gmail.com	\N	\N	{}	2024-07-13 00:56:34	2024-07-13 00:56:34	t	t
3c275b5f-79df-4adf-8e56-72109f12b86f	0be61f9f-48a0-4eb2-a29f-20570853f897		\N		sahadbarbhuiya349@gmail.com	\N	\N	{}	2024-07-15 00:18:16	2024-07-15 00:18:16	t	t
bae17e3e-6a8e-4add-bec3-02a4172d677c	210a9901-8835-41bd-aadb-ed18e76d9d97		\N		vijayravrab2310@gmail.com	\N	\N	{}	2024-08-08 10:52:17	2024-08-08 10:52:17	t	t
9f76be9d-6875-47ea-8114-73fa356f16f9	4fb8ef2e-0a55-4446-83bb-3f96c368ffc0		\N		wf.ubi.wu@gmail.com	\N	\N	{}	2024-03-15 01:01:16	2024-03-15 01:01:16	t	t
93489300-a94a-4e55-be00-6979325ac85a	34fdef87-6228-4d2b-a960-4d5a5f83a95d		\N		rlatika348@gmail.com	\N	\N	{}	2024-08-14 15:54:37	2024-08-14 15:54:37	t	t
09119e88-b9e0-44c9-aff8-9638de483bc0	8856e0ff-c7de-4041-96e8-eede99a277b9		\N		3407011318	\N	\N	{}	2024-03-25 13:17:02	2024-03-25 13:17:02	t	t
9b17c103-6db9-4e24-82ff-d13303107bed	b2051624-b263-45a8-b36b-85db9da54ff0		\N		tatayalbertoruiz08@gmail.com	\N	\N	{}	2024-04-02 05:08:19	2024-04-02 05:08:19	t	t
e88653d9-d3a7-4040-aac9-7c8b5e4e31d1	a9a3eae9-470b-4e07-ac58-37a0d62d0ada	박경준		저희 씨앤알코리아는 제품 포장용 박스 및 부자재를 디자인 및 생산을 전문으로 하고 있습니다	kjpark69@naver.com	01054455617	\N	{쇼핑백,싸바리박스,칼라박스,"포장용 박스"}	2023-12-13 07:44:09	2023-12-13 07:44:09	t	t
1179bba3-1afb-4815-bc45-e790126b39d1	946e0c57-e74d-4a77-85ce-b2ab9d74b6d2		\N			\N	\N	{}	2024-04-06 06:46:59	2024-04-06 06:46:59	t	t
418b1f74-0ba5-43b9-834b-9740f599539e	a85cd4c1-6778-48f8-b5bf-ad552e883dea	बाली चौहान 	\N		balicauhana66@gmail.com	9860681033	\N	{हढ}	2024-08-08 11:58:03	2024-08-08 11:58:03	t	t
1a4840c1-11a6-43a0-b55a-02d6553c9021	1fc5df4c-5ca6-44aa-b3ab-fb93987f7b9b	Erdenebayar Tumurbat	\N		t.erdenebayar87@gmail.com	3239756959	\N	{#Eddy_Tumurbat}	2024-10-15 20:13:57	2024-10-15 20:13:57	t	t
d1cdedeb-f7e7-4398-b261-f44b01b1098e	a3843ca1-aaea-4040-8614-027c758ccea4		\N		dharmendra22436kj@gmail.com	\N	\N	{}	2024-05-17 01:31:02	2024-05-17 01:31:02	t	t
576e2168-3b43-41b1-9813-330248d35534	fd456fdf-cc68-4051-be0f-dd1c23981917		\N		bongsanhouse@gmail.com	\N	\N	{}	2024-06-27 12:39:19	2024-06-27 12:39:19	t	t
a92f39c4-feed-441a-abac-92085c492d6b	d20a6a07-b621-4dd3-a202-78ac56696c2c	함대훈	\N	스마트헬스케어 인공지능에 사업여역확장	dhhaam@tpkorea.kr	1022800596	\N	{"5G Network",Computing,스마트헬스케어,인공지능}	2024-04-01 07:04:13	2024-04-01 07:04:13	t	t
f7c84ec6-96cf-4621-9ac7-e17c25ccef06	dce58864-805f-47bb-a513-11ba3bb8838a	개인용	\N	의학의 세계에서 10년 이상을 보낸 경험 많은 내과 전문의입니다. 환자의 건강을 최우선으로 생각하며, 최신 의학 연구와 치료법에 항상 관심을 갖고 있습니다. 건강한 삶을 위한 지식을 나누기를 기대합니다.	prodao@gmail.com	1014579510	\N	{Doctor,Korean,의사,한국인}	2024-12-05 05:34:56	2024-12-05 05:34:56	t	t
bab85444-01d7-429e-af57-ea0e321870b1	db049daa-59cb-425e-bdd9-c6dbbdff5b95	김병섭	\N	최신 IT 기술과 트렌드에 정통한 IT 전문가입니다. 클라우드 컴퓨팅, 사이버 보안, 데이터 분석 분야에서 두각을 나타내며, 디지털 혁신을 추구합니다.	byungseop@uplexsoft.com	01087936420	\N	{SW,"스마트공장 ","클라우드 "}	2024-02-21 06:10:20	2024-02-21 06:10:20	t	t
c209d41a-0edf-48e6-a33a-028e3a095120	4bb9ec3b-9a6c-4f55-bd4f-0b8940579b8c		\N		dnongrum528@gmail.com	\N	\N	{}	2024-02-18 04:37:32	2024-02-18 04:37:32	t	t
16134dff-4766-4f39-a028-20e8948a6393	4515a665-4709-41be-a6dd-c4dd53adce8d		\N		kalisgula46@gmail.com	\N	\N	{}	2024-07-12 07:09:23	2024-07-12 07:09:23	t	t
7de6535a-5adb-4389-a4d5-369c69cb1479	727b3c2e-6079-4ed4-9cb7-adcd6d11437d		\N		cartagenarowy@gmail.com	\N	\N	{}	2024-02-19 16:23:16	2024-02-19 16:23:16	t	t
ec9caf74-7c4b-4577-a808-1d3a67eac834	4cfae84c-7149-411f-ac09-16c7f3b0b493	Sushil 	\N	good morning 	sushilkumar01@gmail.com	87876658780	\N	{"published "}	2024-07-28 19:04:07	2024-07-28 19:04:07	t	t
7413a038-fac1-4b34-a935-e46ac7c4777e	4c86e0dc-5ca2-4327-a294-af62bed6e4c1	Đỗ Hữu Phước 	\N		phuochuudo93@gmail.com	0377413480	\N	{"về hưu "}	2024-03-12 15:34:18	2024-03-12 15:34:18	t	t
160c5494-7cb2-4252-8f65-71f5d4c83591	aeeed118-2388-4e70-b845-66f35dfc3256	FAISHAL	\N		khanfashal250@gmail.com	7417268925	\N	{FAISHAL}	2024-07-27 21:59:04	2024-07-27 21:59:04	t	t
4991b937-aa61-4d99-9037-4a7b3e2bab4f	0662c401-d3f6-4040-aec4-44a2466e67af	강현선	\N		kang0921@gmail.com	1094689772	\N	{656565}	2024-03-25 11:38:07	2024-03-25 11:38:07	t	t
b22811af-9399-45dc-b413-c9e23de699c0	246bd525-6ab8-4766-a444-5a12f32337a9		\N		hathihong139@gmail.com	\N	\N	{}	2024-04-01 07:46:35	2024-04-01 07:46:35	t	t
0c9a2699-a417-4f18-bf33-a27240f12a1a	8fd92c37-ee30-48c5-9758-5b27c3768deb		\N		3173540245	\N	\N	{}	2023-11-21 03:18:56	2023-11-21 03:18:56	t	t
37758842-8d6a-4f05-89dc-356df7abe510	f0688a26-bcd7-4d47-9ac4-f9c05b47cdde		\N		xuyenlai682@gmail.com	\N	\N	{}	2024-05-10 02:52:48	2024-05-10 02:52:48	t	t
4f80d97e-4e79-43d4-811a-0fcfd1e77c71	1df4b9a3-7fec-4bdd-9317-f40c99cade8d		\N		lakshmiroad3@gmail.com	\N	\N	{}	2024-05-30 16:41:05	2024-05-30 16:41:05	t	t
f70face7-8677-4271-82c7-06d0ee6d632d	1595e4da-60d8-4646-8dcc-c761e435937e	jihyunkwak	\N	I am a marketing expert who enhances the value of brands through creative and strategic thinking. I have gained experience in social media, content marketing, and market analysis.	jihyunkwak1952@gmail.com	2138344871	\N	{doctor,marketing}	2024-11-07 01:25:31	2024-11-07 01:25:31	t	t
d73eecae-0bdc-43c2-a4f4-4448403a0d21	e02e32d3-b777-4e0b-9c7e-fd4c35be9267		\N		rajendralodha606727@gmail.com	\N	\N	{}	2024-07-10 02:37:52	2024-07-10 02:37:52	t	t
59ef382e-1f36-45d9-8a37-3f6d048242e0	1961bd1d-af72-44a9-b760-15fcd9db7ab7	Kyong S Lee	\N	현대적이고 지속 가능한 건축 디자인에 중점을 두는 창의적인 건축가입니다. 공간의 아름다움과 기능성을 결합하여 고객의 꿈을 실현시키고자 합니다.	kyongusa77@hotmail.com	2132844111	\N	{"24 hour care,","architecture drawing, 건축 설계사 ","senior care","인테리어 디자이너 interior design "}	2024-10-23 19:07:03	2024-10-23 19:07:03	t	t
a1133e87-132a-4ae9-9b9a-accf672c1ccd	817bd3fb-eb92-4752-b9c9-780a66474368		\N		kk9581495@gmail.com	\N	\N	{}	2024-07-12 00:41:20	2024-07-12 00:41:20	t	t
668125e8-f418-455d-828c-586d80ddd36e	fc57deea-20e3-4959-bb07-ce80c36b7a8c	최지양	\N	대형 증권회사, 법무법인에서의 오랜 실무 경험을 바탕으로, 각종 법률 문제에 대한 명확하고 실용적인 해결책을 제공합니다. 금융, 투자계약 분쟁, 상속 등에 특화되어있으며 관련 민형사 사건을 두루 수행해왔습니다.	3484230897	1064137114	\N	{계약,금융,상속,서울대}	2024-05-16 03:47:56	2024-05-16 03:47:56	t	t
837e0da6-1c67-4af6-9559-b6ee7d6a549a	608e2678-408c-4ad1-80fb-3a8e0e9a2c76	이선미	\N		3485477584	01029514418	\N	{산이빈이}	2024-05-17 01:05:05	2024-05-17 01:05:05	t	t
739c773b-2a71-4c00-89e4-3b0e253502e3	7ca8a1c9-053c-4830-a060-862ff380a2f1		\N		dayanamdram9794328324@gmail.com	\N	\N	{}	2024-07-16 11:11:22	2024-07-16 11:11:22	t	t
671b2bfb-3e55-4e63-b77c-7be5ac24fe0f	3a4ff768-8762-4a98-9de0-7aaed0362ce8		\N		shivsagarshukla585@gmail.com	\N	\N	{}	2024-07-29 06:26:35	2024-07-29 06:26:35	t	t
549c70e3-bfb1-4869-9d0f-c18d586e29d1	83230c8c-2343-49e8-ba3f-e588ffb60782		\N		devisingh.chouhan153@gmail.com	\N	\N	{}	2024-08-13 09:50:26	2024-08-13 09:50:26	t	t
d06f8bba-6e22-4437-9149-d53c6e77f1d3	af769d09-6810-4b34-97b3-286b06c86198	Md Akbar Ali 	\N	With deep knowledge in the legal field and 15 years of practical experience, I provide clear and practical solutions to complex legal issues. I specialize in commercial law, intellectual property, and civil litigation.	mdakbarali139@gmail.com	9430043225	\N	{"Urdu "}	2024-07-30 15:51:45	2024-07-30 15:51:45	t	t
e31776a0-4776-414a-b642-f68a7cea8208	cd1edaaf-56a3-43c2-83cc-9510f24cf144		\N		kennethroney.07358@gmail.com	\N	\N	{}	2024-10-24 14:49:02	2024-10-24 14:49:02	t	t
761b225e-20b5-4250-8bd4-41d8daea5b59	0aacec3a-b800-4a9e-ac3d-fbf4545c0f61		\N		3436849021	\N	\N	{}	2024-04-14 13:48:19	2024-04-14 13:48:19	t	t
3f26bbee-f637-496b-95e1-46de36b528bc	1349490b-955e-4a0b-b00b-c392d1cb71c1	채세근	\N	사무실 정보기기및집기 임대	zeekokorea@nate.com	0102767041101027670411	\N	{}	2024-04-18 10:45:09	2024-04-18 10:45:09	t	t
285facbd-85e5-4d6e-bb7a-c71c8018220f	c886ab44-06fb-4910-a511-0f01b9ad22d2	AjayTiwari 	\N		ajyaajaytiwari@gmail.com	9198462376	\N	{}	2024-08-08 18:19:54	2024-08-08 18:19:54	t	t
8eb440bb-81c8-463b-b9b1-fe5f40de0cab	7ac0b7d7-3b98-4439-89e7-79026ae3b3ad	SINIL KIM	\N	I am a marketing expert who enhances the value of brands through creative and strategic thinking. I have gained experience in social media, content marketing, and market analysis.	trustedenergy365@gmail.com	2133004747	\N	{solar,솔라,전기세,태양광}	2024-10-14 22:17:30	2024-10-14 22:17:30	t	t
be64e29e-8dc2-40ca-87bc-533d24e724ea	103f67a3-8bcc-42a4-9241-55b4f9ce56e5	phuong la	\N		tamlmag59@gmail.com	849859649	\N	{la}	2024-04-02 15:41:02	2024-04-02 15:41:02	t	t
af6b9c8e-3f89-4ed9-af3f-74da1bea18bc	8185e5d2-086f-46f9-ada8-41b30cf263ab	johncrepritic	\N	I am retired Senior Section Engineer, Southern Railway  Trivandrum Division.	jcrepritic@gmail.co	+919447139904	\N	{kesarirajamma}	2024-05-24 11:26:41	2024-05-24 11:26:41	t	t
20ec8866-12a7-4f2a-9979-b1a497019199	ff42b26e-122c-4b16-b896-f06c990c2c01	노승호	\N	I am an IT professional well-versed in the latest IT technologies and trends. I stand out in cloud computing, cybersecurity, and data analysis, and pursue digital innovation.	shroh0320@naver.com	1056537001	\N	{Development,IT}	2024-01-30 11:53:01	2024-01-30 11:53:01	t	t
1de93cc0-7025-4be6-95e2-84f771a781d2	d65827ec-a8ea-46b3-ae9b-1aef0fe261fc	김성자	\N		jesus4319@naver.com	01034578279	\N	{주부}	2024-03-12 07:49:04	2024-03-12 07:49:04	t	t
fd7e2fd6-023b-4765-9dab-798df97ea74c	cf6d3ef6-631e-43f5-8ed7-2554c4bc570e	장영규	\N	창의적이고 전략적인 사고를 바탕으로 렌탈 브랜드의 가치를 높이는 렌탈쇼핑몰 분양 마케팅 전문.	vision8259@naver.com	01044568259	\N	{렌탈쇼핑몰,렌탈쇼핑몰분양,렌탈제품,종합가전렌탈}	2024-03-15 10:31:12	2024-03-15 10:31:12	t	t
5db8db4b-511c-417e-9409-579c0ed9d420	bd9d47bf-0c6a-41ef-8fa7-9924e9cc868d	김영기	\N	최신 IT 기술과 트렌드에 정통한 IT 전문가입니다. 클라우드 컴퓨팅, 사이버 보안, 데이터 분석 분야에서 두각을 나타내며, 디지털 혁신을 추구합니다.	3003369020	01037859887	\N	{기획,데이터,모바일,제안}	2024-03-25 07:25:47	2024-03-25 07:25:47	t	t
7889a486-025e-4ac1-990d-4117b9754fe5	3e284f6f-181a-4fee-9eaa-89cc745094aa	rajesh	\N	Rajesh chaurasiya chachauda binaganj se Bhartiya Janata party mandal mantri purv Parshad chachauda Vinay Nagar Parishad se	rc5061184@gmail.com	9893636436	\N	{1,2,4}	2024-08-18 02:51:20	2024-08-18 02:51:20	t	t
ea9d8d43-cd19-4683-af9c-ad1309af8ae1	eb43e2ff-e06f-48cd-9099-ed4c093f41ae	김진이	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	jini-8971@hanmail.net	0103670897101	\N	{"은  ᆢ 금 소매","음료 ","쥬얼리  보석 ᆢ금",커피}	2024-04-18 10:44:21	2024-04-18 10:44:21	t	t
1c9be4b1-a7bf-4ff6-b8db-6fc69224dfe7	7af983b5-0536-4fad-8f6f-74367e165ef7	parkchangwoo	\N			01064644545	\N	{123}	2024-03-06 00:34:49	2024-03-06 00:34:49	t	t
aafc3dcf-4a5a-473f-94a9-7a69021b0ae5	4e42dde6-48d8-4cac-b453-269e3f06dab1	asha sharma 	\N		gautamashasharma@gmail.com	8894103142	\N	{123,456}	2024-07-18 03:44:18	2024-07-18 03:44:18	t	t
3472768f-03d0-45c3-980e-0b1feabecce6	d99d51b7-3349-4bf6-8803-618705c95d2d	Amit 	\N		kadirshaikh242424@gmail.com	9028958677	\N	{1}	2024-07-14 08:04:41	2024-07-14 08:04:41	t	t
7b642e74-5de8-4ca4-93e9-acec5ed9122d	0eef1f5e-5b27-4983-a01d-f0c19b49818b		\N		seoulm37@gmail.com	\N	\N	{}	2023-11-22 04:26:41	2023-11-22 04:26:41	t	t
8ebe25f7-60b9-4ffe-a0af-4b00d28d831c	339b8bf1-7cb8-4726-9ccd-f76faf83482d		\N		3202855008	\N	\N	{}	2023-11-30 02:27:41	2023-11-30 02:27:41	t	t
dc62473d-a5f2-493e-9cf8-876a99d2ed18	acc124f7-2136-4576-a39c-42a22fbbbd06		\N		3209341250	\N	\N	{}	2023-12-04 08:27:32	2023-12-04 08:27:32	t	t
bb7540b5-f142-452a-81a2-ca658215d5a6	f28e22f0-069f-442c-9e3d-1ab5350a3027		\N		3206150850	\N	\N	{}	2023-12-02 05:56:23	2023-12-02 05:56:23	t	t
e2b272a9-df67-46b1-b745-2929a3f03f56	76437582-061c-4b94-9873-a4e3b6b8c787		\N		3235444091	\N	\N	{}	2023-12-21 13:36:12	2023-12-21 13:36:12	t	t
ff6b4819-0dd9-4581-95f2-4af85768a50d	8c0274e5-b377-42ed-929d-87871c50489d		\N		deelipkumar28656@gmail.com	\N	\N	{}	2024-07-09 21:21:47	2024-07-09 21:21:47	t	t
0b50abe7-d0c9-4ec2-bbb5-763daf0ff914	1b1e779a-c471-4d50-a46d-8a5d67dd0bdb		\N		kkekekhare@gmail.com	\N	\N	{}	2024-07-30 14:32:34	2024-07-30 14:32:34	t	t
34573ad1-c6df-4bb0-8252-d53e654a54a5	d5aff77a-b44b-4f61-99e5-be983adc7bb0		\N		willwhiteapple@gmail.com	\N	\N	{}	2024-03-08 14:29:53	2024-03-08 14:29:53	t	t
fb8fbc15-3565-44d3-a2b9-eb1973e229db	cc0ae9ae-8913-4d10-84b7-c9694a226a23		\N		shashisood3664@gmail.com	\N	\N	{}	2024-08-09 16:20:25	2024-08-09 16:20:25	t	t
7b920c39-ba97-4370-ac2e-9cfe99a6b351	367bed25-7d4b-47fd-a06a-e2e52c7935d7		\N		sarwatullahbeg2014@gmail.com	\N	\N	{}	2024-08-14 11:25:08	2024-08-14 11:25:08	t	t
39ef00c2-de67-46cb-bb93-6293e7979034	61b3566e-f3e2-4116-824b-0be7e6d5f9b8	신뎡숙	\N	학생들의 가능성을 최대한 발휘할 수 있도록 돕는 열정적인 교사입니다. 혁신적인 교육 방법과 기술을 통해 학습 경험을 향상시키고자 합니다.	myungshin1331@gmail.com	2139991331	\N	{가정}	2024-10-30 22:30:42	2024-10-30 22:30:42	t	t
274d59f4-95a0-4868-8d86-2a684a89cf58	4bf3bdbe-77dd-4ba7-8428-ad1dc336341b		\N		3351410064	\N	\N	{}	2024-02-19 14:15:48	2024-02-19 14:15:48	t	t
4e8f3245-b3c0-4b8c-b5e7-76224e2c377a	7ca334c9-4cef-49c2-a447-f7ab269d7047	jiwan	\N		singhbapu041@gmail.com	9872310997	\N	{151504}	2024-11-19 07:06:33	2024-11-19 07:06:33	t	t
916a8878-1e49-4ada-9a00-ee1d1c41df0d	b4984725-347b-4719-bf4c-095d764ab3ba	mukesh	\N		mk7822433@gmail.com	32	\N	{mukesh}	2024-07-09 17:59:28	2024-07-09 17:59:28	t	t
05c84258-f378-43a9-929e-06dbf710205b	14ab6b3c-2c8d-4969-b722-fa3b6949569e	강한수 	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	3407987457	88817152	\N	{"개인 사업"}	2024-03-26 06:14:52	2024-03-26 06:14:52	t	t
1c32405f-8ec9-4855-aa23-ff558bf2eada	4d6fb161-00ad-4b89-bfbb-dde9cedf2d2a	이명자	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	wsj1221@hanmail.net	01052356398	\N	{보험,종합보험}	2024-04-17 12:49:58	2024-04-17 12:49:58	t	t
963716f1-c54a-404e-a624-175991f5ad3b	6faf415c-dd33-49ae-b64f-876b83cf20e5	고윤흠 	\N		kohyoun2@gmail.com	01023130534	\N	{"고윤흠 "}	2024-02-19 14:56:01	2024-02-19 14:56:01	t	t
05170c36-0bd0-43ce-a5cf-1193fce1341e	f87ac2f9-5d43-4888-ba23-3270703badb1		\N		johnmarkmarinias@gmail.com	\N	\N	{}	2024-03-14 11:39:54	2024-03-14 11:39:54	t	t
a789c570-8d1b-4640-9f34-2852b831027b	c9886487-7637-42c7-a3df-7d5d1d30b015		\N		sbprasad5111@gmail.com	\N	\N	{}	2024-08-11 06:04:00	2024-08-11 06:04:00	t	t
02780e27-c653-4592-90f3-106c309c8e00	240c21d8-d5d1-42d7-9b06-16552be15644		\N		laxomks@gmail.com	\N	\N	{}	2024-03-15 02:20:13	2024-03-15 02:20:13	t	t
74de990c-d8a6-4573-af62-83dbef4d5230	088dddf9-7d9c-46a5-adaf-b7a97f3bd7d4	satish Kumar Singh 	\N	I am a businessperson with an exceptional ability to turn visions into reality. I pioneer new markets with innovative ideas and strong business strategies.	srajput21109@gmail.com	9023932675	\N	{799,jio}	2024-07-15 12:58:35	2024-07-15 12:58:35	t	t
bba519db-31c6-4cab-b7a3-b34e920f2cee	41934832-9005-43bd-9682-542d32e9a9a9	김현자	\N		sk7125@hanmail.net	1062625045	\N	{가정주부}	2024-04-05 12:34:45	2024-04-05 12:34:45	t	t
5c62ad9b-be86-4860-a617-b626d43576b6	52b4f42b-1bc5-4cb9-bde2-26605e554a76		\N		rapathakurramkaran@gmail.com	\N	\N	{}	2024-08-14 15:20:44	2024-08-14 15:20:44	t	t
218cf190-47b6-4508-8d1f-8d3847a7813d	e17b751b-e6d9-4d8e-a7ce-fda5ef0ff335		\N		jhaashu00@gmail.com	\N	\N	{}	2024-08-14 17:30:10	2024-08-14 17:30:10	t	t
6684fd37-31d9-469d-8bd4-70f61f70824d	d6bbc439-3652-46f4-b243-417ac11a076a	Junar	\N	I am an enthusiastic teacher who helps students realize their full potential. I aim to enhance learning experiences through innovative educational methods and technology.	sjunar238@gmail.com	9216335196	\N	{"knowledge "}	2024-04-15 23:26:57	2024-04-15 23:26:57	t	t
c25e6fa7-17aa-458f-9f3c-b908f2873960	9817164d-7f82-4ed9-9eed-a673787526f4		\N		3845054228	\N	\N	{}	2024-12-22 01:17:47	2024-12-22 01:17:47	t	t
449d9a86-ee1e-4d8a-bb15-045848ddb563	261c438f-fd04-4d78-84ca-76bab60ce047	유준형	\N	IT, 마케팅	jhyou1955@naver.com	01088643160	\N	{오픈마켓,온라인마케팅,창업,챗GPT}	2024-05-03 16:56:19	2024-05-03 16:56:19	t	t
e4d6526e-ed0c-4ad4-a8a5-9e4714a44fa1	04a73285-3f3c-433f-917d-15f913b0737a	배지현	\N	이벤트 사업을 열심히 하고 있습니다	bjy746@naver.com	01064509183	\N	{이벤트}	2024-03-22 06:50:53	2024-03-22 06:50:53	t	t
074e32c9-a600-4345-936e-dbcae6a87afa	b3ef18b4-2c14-4318-b4f2-9e67939b2189	이건수	\N		3332677385	01087496342	\N	{카리스마}	2024-02-07 02:24:01	2024-02-07 02:24:01	t	t
1e8b56fb-a705-4856-860f-593d8460317b	542bdd52-5eef-4759-886d-07722fa1a238		\N		mandalsaraswati16779@gmail.com	\N	\N	{}	2024-06-18 15:19:24	2024-06-18 15:19:24	t	t
e584226d-103c-4433-9b17-390737f2a4bb	9c6716e4-d8f2-4e84-831c-7fedddd70536	김은숙	\N	학생들의 가능성을 최대한 발휘할 수 있도록 돕는 열정적인 교사입니다. 혁신적인 교육 방법과 기술을 통해 학습 경험을 향상시키고자 합니다.	rarara4886@hanmail.net	01087644886	\N	{동작하라}	2024-03-04 06:11:13	2024-03-04 06:11:13	t	t
f781e07f-ae6a-45cd-ba37-f40eff1e9d12	ed9ea43b-502e-48a1-9d78-a882438df6f1		\N		3347570718	\N	\N	{}	2024-02-17 03:36:06	2024-02-17 03:36:06	t	t
2a175fad-05e8-45ae-95e3-e89526375b66	9b469951-6910-4583-a6c1-e7954bb8a5d4		\N		3348505439	\N	\N	{}	2024-02-17 15:13:58	2024-02-17 15:13:58	t	t
921f1364-7f41-42ed-80ac-e3b3d7473ace	ffac290e-e496-4704-b4b6-b6fd8886fd96	hhgiii	\N		r7683945@gmail.com	6387477#*7	\N	{i,o,t,y}	2024-07-29 09:19:15	2024-07-29 09:19:15	t	t
252b9a82-bc18-42d5-85e5-203f886b9628	d8e42301-a8b5-4708-87c6-440ca9acd37e	이석우	\N	인테리어 디자인 설계시공 .경관조명. 금속디자인.광고디자인설계시공.전광판.	ty3585@naver.com	1036668562	\N	{경관조명,광고디자인,인테리어,조형물}	2024-03-22 08:30:41	2024-03-22 08:30:41	t	t
e47f0a10-3095-4c5a-ade3-7206d51a1543	60818018-80a8-4879-94cd-05672c26f7b6		\N		dennise7102005@gmail.com	\N	\N	{}	2024-02-22 05:44:03	2024-02-22 05:44:03	t	t
e571d440-9f35-490a-b963-44e90de588bd	3ca31072-51c5-470e-9381-7578ad758c41		\N		muskansingh121258@gmail.com	\N	\N	{}	2024-07-18 09:01:05	2024-07-18 09:01:05	t	t
031d2749-3672-4bdb-b450-4b4f4d7e0253	e66b04bb-a3a2-47f8-8857-b3030aaf3285		\N		ahemad8007@gmail.com	\N	\N	{}	2024-07-30 14:36:46	2024-07-30 14:36:46	t	t
294f4542-a726-4422-9b55-c3b5dc9bbfff	46bd2d13-8e86-4937-b150-4514a75e2cad	신영훈	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	spoiler0909@naver.com	1085455777	\N	{녹음,녹음2}	2024-04-06 02:19:58	2024-04-06 02:19:58	t	t
13ca622d-9f5d-4222-a8a0-5c50e3022f0b	06b9b48a-abaa-4d24-8ee9-d94d5ab0ec66	peter 	\N	창의적이고 전략적인 사고를 바탕으로 브랜드의 가치를 높이는 마케팅 전문가입니다. 소셜 미디어, 콘텐츠 마케팅, 시장 분석 분야에서 경험을 쌓았습니다.	3118peter@gmail.com	8085908788	\N	{"marketing ","usable seller"}	2024-12-04 23:53:06	2024-12-04 23:53:06	t	t
2a216f91-12be-4ff1-8517-3964151cc3ad	e9524a49-eda8-4d75-9863-9f6a1cf1c0dd		\N		3411094409	\N	\N	{}	2024-03-28 04:49:41	2024-03-28 04:49:41	t	t
bbf50e86-2f29-4ab1-985c-8e409bb03a2f	64c2f16b-2398-4102-a8db-bb61bd127f67		\N		ggilsu232@gmail.com	\N	\N	{}	2024-04-04 09:46:25	2024-04-04 09:46:25	t	t
43854580-5d4f-4be5-81cc-48fa2d74d1e4	39daebfd-cd2c-4002-a0fe-c28559d8a9e4		\N		kumarram412hdj@gmail.com	\N	\N	{}	2024-02-17 15:28:19	2024-02-17 15:28:19	t	t
ed97862f-30dd-4978-a202-3bcae83f8d74	1a550834-b834-45c1-a899-392a50b5ee7d	김진목	\N	법무사 	ki1714@hanmail.net	01037378457	\N	{김진목법무사,장로,"정치학박사 ",형사전문}	2024-03-15 10:26:12	2024-03-15 10:26:12	t	t
e3db9ba1-27c5-43dc-a87f-4bb29fea760c	d2feda35-cf48-4d50-9db4-5d5cab9a96bd	이욱현	\N	학생들의 가능성을 최대한 발휘할 수 있도록 돕는 열정적인 소프트웨어융합학과 교수입니다. 혁신적인 교육 방법과 기술을 통해 학습 경험을 향상시키고자 합니다.	3404700188	01036205348	\N	{IT,SW,교수,인공지능}	2024-03-24 04:44:05	2024-03-24 04:44:05	t	t
5d6ec7e5-bbc0-4aa0-8972-84e09fa48c09	ea90f8aa-b2ea-4657-aa7a-f82f583a1980		\N		3220506720	\N	\N	{}	2023-12-12 03:49:50	2023-12-12 03:49:50	t	t
d20a1cc9-46de-4011-b30a-8ed88bc448f0	44a938f5-b9c0-4e10-aab1-bbabd979710e		\N		3223197332	\N	\N	{}	2023-12-13 23:59:44	2023-12-13 23:59:44	t	t
a6a9d2aa-0f11-47b6-8faa-97784d86731b	77b00ba8-03f1-4834-9821-f15d033951a1		\N		gillr9664@gmail.com	\N	\N	{}	2024-06-13 03:22:43	2024-06-13 03:22:43	t	t
4ba7333f-cc53-4f9a-ad05-026fa79b37de	29539f8f-498d-4c53-b24b-3ea006f39832	Ayowumi 	\N	I am a businessperson with an exceptional ability to turn visions into reality. I pioneer new markets with innovative ideas and strong business strategies.	olabisiayowumi84@gmail.com	8066618888	\N	{" I ",ayo,ok,wumi}	2024-12-09 19:33:04	2024-12-09 19:33:04	t	t
48009904-ba57-484a-9cbd-ae02000c7c23	d34dd110-ef1b-430d-8a36-23e872209145	Kevin Yoo	\N		kevinjyoo@gmail.com	2137619990	\N	{"Auto Insurance ","Insurance "}	2024-11-20 23:08:34	2024-11-20 23:08:34	t	t
350149b3-c722-4c08-92f5-94c6bb0a5b3f	b537d55e-b6cd-407a-b2d0-cae4f74b101a	jhon beros pomarin	\N	I am a marketing expert who enhances the value of brands through creative and strategic thinking. I have gained experience in social media, content marketing, and market analysis.	jhonberospomarin@gmail.com	9851652274	\N	{kalboo}	2024-04-14 08:10:15	2024-04-14 08:10:15	t	t
aff6d46f-5706-425e-a111-0bf0d5abf8f6	3ddc1b80-da70-4135-b286-745586144bfe	chotan verma 	\N		chhotanverma53@gmail.com	7999972389	\N	{495112}	2024-07-09 19:55:55	2024-07-09 19:55:55	t	t
038db016-cf5f-4cfd-ae8c-f4d6b3db5b41	5aece801-aa7a-4248-8559-2e6c73eda3e3		\N		cruznicasio263@gmail.com	\N	\N	{}	2024-03-26 05:18:50	2024-03-26 05:18:50	t	t
5e5feb17-a227-42e3-ac06-b99ab006a5c5	7969cb1e-67db-442c-8fc3-452f6841162b	9027051396	\N		saleemsaifi9027051@gmail.com	9027051396	\N	{9027051396}	2024-07-11 04:24:26	2024-07-11 04:24:26	t	t
408e1401-94ab-4138-8e9e-101cc8fd4ca2	22ac90d8-e3f8-48ac-b700-dff689d9d990		\N		3424655084	\N	\N	{}	2024-04-06 06:21:51	2024-04-06 06:21:51	t	t
694c7c44-3dd1-45c7-97a7-ba0e4bc2bec4	999795bc-d3e9-4a2f-91df-871907151e35	ashu	\N		ashuchouhan2023@gmail.com	9521383696	\N	{ashu}	2024-02-17 20:11:28	2024-02-17 20:11:28	t	t
c1faf6dd-64fd-4584-9218-1adc108d8f64	939fa2b7-9ca4-4ab9-a8c9-2e9f51034571	박춘근	\N	세무사	pck1029@hanmail.net	01087078469	\N	{세무사}	2024-02-21 06:12:55	2024-02-21 06:12:55	t	t
688da8e6-f108-4bb9-9da7-483c4b3bc1ef	bf567e86-edbc-46a9-9509-78e72000e29d		\N		3441294478	\N	\N	{}	2024-04-17 12:51:47	2024-04-17 12:51:47	t	t
77d01c5e-5b40-4a8b-a864-c82214727cb8	8ecd4380-5e50-4e97-ba2a-255ce4c2c4e1	소민	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	sgeo891@gmail.com	01084835812	\N	{응디}	2024-03-13 17:33:24	2024-03-13 17:33:24	t	t
465d5770-e189-403a-bbd5-ee4dd16c41d5	d105f237-9c73-48d7-916c-20a8e1171fb5		\N			\N	\N	{}	2024-06-28 09:43:11	2024-06-28 09:43:11	t	t
9b87891f-c4e5-4475-a6f9-3f9975c37490	e6e68bd1-7618-4a50-95fb-904e3dc67a18	비긴어게인	\N	비긴어게인	sim5289@hanmail.net	\N	\N	{}	2023-12-23 10:23:17	2023-12-23 10:23:17	t	t
812121f6-838b-4f08-b5bc-e37e7a508b00	2252e79e-2e85-4a47-b142-639edcdefef0	Oluwaseyi Augustus samuel	\N	am working in poultry 	augustussamuel0@gmail.com	8063423012	\N	{"birds ",good,"market ",shop}	2024-09-25 10:08:22	2024-09-25 10:08:22	t	t
5cce7621-29ac-4cc0-9b11-cebc477dbd3e	535ea001-115c-46e7-9e7e-b8efaeda6e54	(주)세이브인슈	\N	(주)세이브인슈	saveinsu@nate.com	\N	\N	{}	2024-01-25 09:17:52	2024-01-25 09:17:52	t	t
31f6332f-b0ee-4865-ba6d-16ad265aa2c7	acce3330-b31a-45f2-9425-00ae8eee7af8	Phạm Công Dông	\N	Thầy thuốc đa khoa YHCT	dongphamcong@gmail.com	961437362	\N	{"Bác sĩ"}	2024-04-16 12:01:36	2024-04-16 12:01:36	t	t
f358975e-fe7b-4cef-afd9-8c1dfc44253f	ee06526f-4879-4f1e-b2c9-49699a1ea132	rodolfo	\N		rodolfomercado271@gmail.com	09164635772	\N	{nice}	2024-04-14 14:21:41	2024-04-14 14:21:41	t	t
55d8f46f-c67d-4dbe-85a2-24878c2d64ea	0dc571a3-f6d3-41db-af52-b872a0408842	sandeep Kumar 	\N	I am a marketing expert who enhances the value of brands through creative and strategic thinking. I have gained experience in social media, content marketing, and market analysis.	spt773@gmail.com	9596492069	\N	{sandeep}	2024-07-18 11:48:16	2024-07-18 11:48:16	t	t
ec7dde44-0c4d-44d4-b7ec-cfdc362116fd	0e1f6b90-ab29-4df0-9cb5-f253a096d6ca	최종수	\N	혁신적인 기술 솔루션을 개발하는 데 열정적인 기계 엔지니어입니다. 지속 가능한 설계와 효율적인 프로세스 개선에 중점을 두고 있으며, 새로운 기술 도전을 즐깁니다.	cjsolution@kakao.com	86363180	\N	{"Candle filter ",Enzymes,"Pilot Vacuum evaporator "}	2024-03-24 05:33:47	2024-03-24 05:33:47	t	t
3d608b0d-a735-4085-9bc6-c0b73533231f	19b58357-a8f1-4f20-9b93-30581c8b43db		\N		euniceeesv@gmail.com	\N	\N	{}	2024-03-12 22:42:03	2024-03-12 22:42:03	t	t
d0f3dfd8-e4f1-4f81-94e9-8ca83a93d2bf	548a7799-4a3e-4b13-862f-e89c8538f074		\N		3392224223	\N	\N	{}	2024-03-17 02:31:35	2024-03-17 02:31:35	t	t
14a23922-0b8b-4e65-bb5d-b1f5b7cf582b	af93ece9-2f33-42d2-953d-e039b1a1e64d	이대호	\N		dhlee@f1security.co.kr	01052855832	\N	{정보보안}	2024-08-30 02:43:31	2024-08-30 02:43:31	t	t
872d7ce5-9db8-4a60-bed7-696b80abdaa0	62a97dc2-70c3-41bd-a031-eaf9613a0b7d		\N		fritzcapayle4@gmail.com	\N	\N	{}	2024-04-16 04:01:12	2024-04-16 04:01:12	t	t
0e325868-e9d2-483f-ac13-9fbff221f3f1	c76b8982-13ee-4788-9bb6-e22eac0520cf		\N		3436452123	\N	\N	{}	2024-04-14 08:59:31	2024-04-14 08:59:31	t	t
3d4baa99-f95b-4e7e-b855-45df5e90f40e	8c13c974-9502-4adb-ac4e-13ac5958ab29	Adaeze Nwabueze 	\N	I am a professional chef who captures hearts with cuisine that combines tradition and innovation. I pursue cooking that balances taste, health, and aesthetics.	aadaezeadaeze@gmail.com	08147553541	\N	{081475}	2024-12-10 09:30:00	2024-12-10 09:30:00	t	t
eed0449f-47c2-4fb2-80c0-b698f93e4c75	1dc2d7b6-2e00-4398-b913-905ba4cf938a	이동혁	\N	전통과 혁신을 결합한 요리로 사람들의 마음을 사로잡는 프로페셔널 셰프입니다. 맛과 건강, 미학이 조화를 이루는 요리를 추구합니다.	wisldh@naver.comw	1099113393	\N	{dapping,picona,댑핑,비트코인트}	2024-12-19 06:30:59	2024-12-19 06:30:59	t	t
109a4d6f-aa0b-4265-9628-0b98a528f0d1	3d48d78c-ceec-4c0a-aab6-9fc35fdb8e4c		\N		rohitkumarpartapu1996@gmail.com	\N	\N	{}	2024-07-12 01:32:37	2024-07-12 01:32:37	t	t
653b73d8-df98-458a-b16d-c39cd36e181c	fb0a3dad-09fa-4000-95c2-b3e6cc393443		\N		3353261627	\N	\N	{}	2024-02-21 00:26:39	2024-02-21 00:26:39	t	t
77c3a836-9bcd-4013-8468-7945790cc12b	8e7e993f-54f9-40d5-8bea-ae16768cbe27	tinh	\N	Tôi là một doanh nhân có khả năng xuất sắc biến tầm nhìn thành hiện thực. Tôi mở rộng thị trường mới với ý tưởng đổi mới và chiến lược kinh doanh mạnh mẽ.	fsf13315@gmail.com	0362665937	\N	{tinh}	2024-02-17 16:00:59	2024-02-17 16:00:59	t	t
8bfba13f-994a-433e-b863-f395ab8810b3	76658434-c22a-411a-94a7-102a7c292c5f		\N		nilratanbiswas11@gmail.com	\N	\N	{}	2024-07-29 09:02:10	2024-07-29 09:02:10	t	t
88a90f33-9ed3-4ae6-a294-84531e691ea6	daa364dc-ab58-4b1b-bc82-30a29144d0ee		\N		kumarsinghmukesh956@gmail.com	\N	\N	{}	2024-07-28 03:55:27	2024-07-28 03:55:27	t	t
160924b3-2ac9-47af-97a2-dab474e02b1e	51b50b3e-2e90-4281-8756-19f3d938bbe9		\N		sudhirkumarmahakurm@gmail.com	\N	\N	{}	2024-08-09 04:36:45	2024-08-09 04:36:45	t	t
95d028a9-a140-401c-be39-0829ae9d2c32	8ddb0cc7-ad84-4aab-91dc-a0006a4af4d3		\N		krishna813101878787@gmail.com	\N	\N	{}	2024-08-08 12:33:47	2024-08-08 12:33:47	t	t
c8de8d6e-8cb3-4dfe-882e-7c5b328f7937	715c92b8-d680-4c85-910b-5b2ff965ead9		\N		sonawaneuttam153@gmail.com	\N	\N	{}	2024-08-15 03:36:37	2024-08-15 03:36:37	t	t
e0e3bc82-dba1-407d-b117-1a57e18203ef	5f88048e-9a4e-4720-a833-cbb9d1b22350	김권일	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	gonil2da@hanmail.net	01052574541	\N	{모니터,서버,워크스테이션,컴퓨터}	2024-02-29 03:08:30	2024-02-29 03:08:30	t	t
70accfe5-8a00-408f-9a72-977fe6558a3f	2ef8f12b-1fdc-4a87-a61a-5a278f557ade	이시율	\N	창의적이고 전략적인 사고를 바탕으로 브랜드의 가치를 높이는 마케팅 전문가입니다. 소셜 미디어, 콘텐츠 마케팅, 시장 분석 분야에서 경험을 쌓았습니다.	siyul8818@gmail.com	2139103336	\N	{광고디자인,마케터,세일즈,홍보세일즈}	2024-10-23 19:31:05	2024-10-23 19:31:05	t	t
4ae51ae2-cc5a-4d28-bd11-82beb5f4410d	3ca66b4a-ee1c-4acf-a29f-a1159457772a		\N		3721190773	\N	\N	{}	2024-09-26 08:16:32	2024-09-26 08:16:32	t	t
b1f74b12-3349-4371-ba43-d9d27083253a	3f38e9c6-d34f-48df-a6b8-06ee322e9c91	홍순화	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	snqhong@naver.com	1029968899	\N	{sm043721}	2024-04-05 05:44:07	2024-04-05 05:44:07	t	t
636b7b29-c666-4445-941f-aca8ecbd7e1c	8e2970f7-1a8c-4264-bc0a-e827758e4ee3	서정익 	\N		3480889495	01023095439	\N	{"서정익 "}	2024-05-13 21:51:35	2024-05-13 21:51:35	t	t
3bf329a2-1505-4c90-92cf-0b389d9dfd9d	6c50a910-149e-4247-af57-91342ca69c26		\N		3235139338	\N	\N	{}	2023-12-21 10:00:13	2023-12-21 10:00:13	t	t
df315744-486a-45c2-8a66-f54d8575b3f2	0e34eecd-4f6c-47b9-8262-d2dfcf951591		\N		ag5321867@gmail.com	\N	\N	{}	2024-06-20 09:07:25	2024-06-20 09:07:25	t	t
5cf1c4dc-bc03-4814-b0d3-c01e2a6b1225	67c41f98-232b-4c1a-ba47-348bc540c17a		\N		nagaripa11@gmail.com	\N	\N	{}	2024-02-20 10:33:14	2024-02-20 10:33:14	t	t
aaafbde8-0664-4e98-b85b-aebb8849af8d	6f1649d4-1831-4622-bcf9-871796d1d7a4		\N		sunildar197@gmail.com	\N	\N	{}	2024-07-12 00:21:14	2024-07-12 00:21:14	t	t
b325dd78-6450-435f-b169-5084224a05e7	aa86b50d-7530-4b11-a276-8f80f2a30a90		\N		irshadalisayyed1234@gmail.com	\N	\N	{}	2024-07-15 12:04:36	2024-07-15 12:04:36	t	t
a2fa473c-90ab-4fa7-b5ae-80ff66da5684	ae27bc19-8b2c-4bb0-ba9e-6835c6b236c8	Nasim	\N	I am an experienced accountant who provides accurate and reliable financial management. I have expertise in financial analysis, tax planning, and auditing across various accounting areas.	nasimshaikh8969@gmail.com	8969152390	\N	{ggghhhhhhhh,Nasim,Nasimhhhh,qggvv}	2024-07-09 15:35:28	2024-07-09 15:35:28	t	t
d1742bd1-b003-481d-8532-67b494c0438b	cdfe543c-a78e-4dbc-ba5b-f3a8e6aaf43a	오정환	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	hwan2oj@naver.com	01047266968	\N	{건설업,사무용가구,실내인테리어}	2024-07-04 12:25:17	2024-07-04 12:25:17	t	t
3df55165-c493-42fc-a554-f33de6e02dde	19401818-3291-4aa4-b2d2-97d3b5f0e66f		\N		astesiotaglinao1016@gmail.com	\N	\N	{}	2024-03-28 08:34:23	2024-03-28 08:34:23	t	t
fc932600-5057-4b51-882b-ab1f289f8574	a5375a3b-6bcf-4d38-ad41-d0f132461966	김한주	\N	경영학박사. 한양대학교 융합전자공학부 수석연구원	djcc@naver.com	01073635757	\N	{"성동지회 파이팅"}	2024-03-15 13:06:49	2024-03-15 13:06:49	t	t
2734c0fd-4d11-4df4-9ffa-8006192fd55d	6ffb9390-3177-4546-993c-4b4b225bad8e	홍정화	\N	플로리스트	florosa@hanmail.net	01042781110	\N	{꽃,꽃책,식물}	2024-03-29 11:17:46	2024-03-29 11:17:46	t	t
f53181f7-0c2e-4bae-b2de-e4ff0001a4cc	94bf3906-765a-4d6b-906e-1bd0fae60947	송하종	\N	학생들의 가능성을 최대한 발휘할 수 있도록 돕는 열정적인 교사입니다. 혁신적인 교육 방법과 기술을 통해 학습 경험을 향상시키고자 합니다.	jesuslove-song@hanmail.net	9182718466	\N	{"missions "}	2024-05-10 05:28:10	2024-05-10 05:28:10	t	t
8ef8ce6b-f4d4-409a-bfde-6f9fe6a4d717	8394f0f8-6480-43c1-8c9f-754b85761d11		\N		mondalbuddhadeb387@gmail.com	\N	\N	{}	2024-06-15 09:53:27	2024-06-15 09:53:27	t	t
eb465db7-53e2-40e4-8772-2e1c698514a4	7feeba3f-2de6-461e-822c-e5732fa9d2e6		\N		catherineacacho@gmail.com	\N	\N	{}	2024-02-18 01:14:19	2024-02-18 01:14:19	t	t
566b040f-e1d9-46e7-89f4-73f97636e7eb	386e2034-6ec7-4992-ba76-8ef1ab10013d	bảo 	\N	법률 분야에서의 깊은 지식과 15년의 실무 경험을 바탕으로, 복잡한 법적 문제에 대한 명확하고 실용적인 해결책을 제공합니다. 상업 법률, 지적 재산권, 민사 소송에 특화되어 있습니다.	13102019ht@gmail.com	8038750910	\N	{9}	2024-02-17 05:57:45	2024-02-17 05:57:45	t	t
864e3db3-c7f0-4e1b-95db-fa66996694fd	ceb2e076-e8e4-4f5e-a944-e1d423c62834	조형식	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	3355218200	01037028589	\N	{납품,도소매,돼지갈비,양념갈비}	2024-02-21 06:09:52	2024-02-21 06:09:52	t	t
7e3f8912-5469-454c-a8c8-a0bebf56d950	50ae2328-6330-4c0a-a72e-bd92ef0d2641		\N		3385960488	\N	\N	{}	2024-03-12 11:24:40	2024-03-12 11:24:40	t	t
205fb83b-be78-41b3-abfd-4981a33d0d43	76736e86-2aae-40c3-905f-c9991c527424	US & Korea Alliance Association 	\N	US & Korea Alliance Association 	WeGoToGether@koreausa.org	\N	\N	{}	2024-11-11 22:26:04	2024-11-11 22:26:04	t	t
38f8661c-a953-46b5-aad9-356f1feda246	caaa99ed-82ec-4986-9a0d-f9de1306e0d5		\N		3204858159	\N	\N	{}	2023-12-01 07:57:50	2023-12-01 07:57:50	t	t
06a809b7-4d7a-4c75-a9d4-ef7832c21fdc	0cca947b-5a4f-4b4a-ac4e-8ecfae6589e0		\N		3206407451	\N	\N	{}	2023-12-02 08:51:37	2023-12-02 08:51:37	t	t
3aec5c92-a1a8-44b7-87a6-74cf7c04e675	e4eb82c8-6b26-4f7f-8641-549baf202c92		\N		gsabudin8@gmail.com	\N	\N	{}	2024-07-28 14:50:33	2024-07-28 14:50:33	t	t
265e0d47-acb2-4563-9967-f76a4c56df21	117ee2d1-53be-4598-8193-4e54566b351e	최종오	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	3386508909	01071858890	\N	{알랑드롱}	2024-03-13 00:24:04	2024-03-13 00:24:04	t	t
482c54b3-e3b0-4fa6-b4ad-30ff819319ae	9f07517c-89f5-42d3-b792-c3ee0908b63d	조성현 	\N	현대적이고 지속 가능한 건축 디자인에 중점을 두는 창의적인 건축가입니다. 공간의 아름다움과 기능성을 결합하여 고객의 꿈을 실현시키고자 합니다.	Hyun670303@naver.com	0108255765720241208	\N	{운수업}	2024-12-08 11:13:15	2024-12-08 11:13:15	t	t
28c100d5-7611-43d7-94a5-fe7163b5ff22	2852678a-44c2-4e6d-99d5-c2610148b78c	이춘영 	\N	학생들의 가능성을 최대한 발휘할 수 있도록 돕는 열정적인 교사입니다. 혁신적인 교육 방법과 기술을 통해 학습 경험을 향상시키고자 합니다.	williamlee4545@gmail.com	1094811417	\N	{교육자}	2024-04-15 15:00:02	2024-04-15 15:00:02	t	t
b41322d8-c10d-4e90-a35d-3ff05d7ee060	d98e1f37-38da-41b7-9ad1-9301b0fc0b50	김영석	\N		3459856199	01094953723	\N	{기술}	2024-04-30 03:22:18	2024-04-30 03:22:18	t	t
614cc11b-86a3-491e-b716-07c35c067fee	e07fb836-054b-44c4-8090-0710d44cc814		\N		3388716451	\N	\N	{}	2024-03-14 09:31:21	2024-03-14 09:31:21	t	t
8632b1bd-54f5-4687-8441-686c0864e8c0	790960d0-819b-4db6-ac72-32a90174887f	वरदीचद जांगिड़ विश्वकर्मा 	\N		vishwkarmavardichand@gmail.com	8435004801	\N	{"राम "}	2024-08-12 16:24:13	2024-08-12 16:24:13	t	t
400e5d72-2616-46dd-b1e1-1e0afdba28cf	776d6525-d0bd-48e9-9995-f172fc49ec31		\N		dangquanglinh010171@gmail.com	\N	\N	{}	2024-04-05 01:06:15	2024-04-05 01:06:15	t	t
b5b727c5-ab1b-4ff8-a6f1-4d1dd0e9da60	7d469a31-f327-4656-8f0e-d9906a26a8e3	damorshashikant40@gmail.com	\N	I am a professional chef who captures hearts with cuisine that combines tradition and innovation. I pursue cooking that balances taste, health, and aesthetics.	damorshashikant40@gmail.com	9638990720	\N	{1234}	2024-02-17 06:37:52	2024-02-17 06:37:52	t	t
049a92d4-548c-4b7c-b269-c6886426adaf	970b7537-600d-48b8-8399-61109c8f4bd9		\N		3483990289	\N	\N	{}	2024-05-16 00:55:14	2024-05-16 00:55:14	t	t
33039775-102f-4502-9599-fb289758a015	c49f28e5-2660-4f0e-ac38-b5c687cbf228	배복동	\N	보조금컨설팅 6년, 행정사	bbd2@naver.com	01054371045	\N	{보조금컨설팅}	2024-02-19 04:40:13	2024-02-19 04:40:13	t	t
ecb3b602-6231-41da-9d1f-ad77c2418567	08be9267-2a38-4ed5-ad50-cfae7445bcbd		\N		3330030441	\N	\N	{}	2024-02-05 04:55:53	2024-02-05 04:55:53	t	t
fbe258a7-7c0d-4e17-8708-2d6bfdfb4c83	b0bfeeb8-82f2-4e3a-aaf6-5cc8522608b2		\N		vuonganh251989@gmail.com	\N	\N	{}	2024-02-17 07:21:12	2024-02-17 07:21:12	t	t
4e339403-1e8a-477b-b534-143503bbeae7	06f0664f-6f2c-4ade-94b1-19082306bd91		\N		bhimsinghthakur66@gmail.com	\N	\N	{}	2024-07-13 17:38:59	2024-07-13 17:38:59	t	t
3c5a0efb-ea59-42ee-84e2-7d42ee2071bd	c67c54ba-658d-4a1b-85de-9efedcd8177d		\N		3385967848	\N	\N	{}	2024-03-12 11:29:55	2024-03-12 11:29:55	t	t
37ae1107-0fc8-47ff-a989-c9c01023b668	c62fb45e-50a0-4fb1-ba03-81aac65ad8ae	hk GODWANI 	\N	मैं एक विपणन विशेषज्ञ हूं जो ब्रांडों के मूल्य को रचनात्मक और रणनीतिक सोच के माध्यम से बढ़ाता है। मैंने सोशल मीडिया, कंटेंट मार्केटिंग, और बाजार विश्लेषण में अनुभव प्राप्त किया है।	hkgodwani3005@gmail.com	917011283584	\N	{1}	2024-07-27 23:21:00	2024-07-27 23:21:00	t	t
8edc438c-db9c-447e-af79-c3144240ea61	9cf6a883-9dfb-419e-8413-0f56f19439a6	이태철	\N	최신 IT 기술과 트렌드에 정통한 IT 전문가입니다. 클라우드 컴퓨팅, 사이버 보안, 데이터 분석 분야에서 두각을 나타내며, 디지털 혁신을 추구합니다.	whoytc@naver.com	01030704393	\N	{컨설턴트,행정사}	2024-07-28 04:51:14	2024-07-28 04:51:14	t	t
8d1ac94d-9aeb-40ce-9f40-626435b4f639	dac79653-0b53-423e-bdbd-97d87cadddf0		\N		bhuiyanbigan892@gmail.com	\N	\N	{}	2024-08-14 08:24:21	2024-08-14 08:24:21	t	t
0854a2b7-8bd2-4153-bf4c-712d0de11ddd	d4ba84a7-6215-4ccc-937b-95bdd1eb343f		\N		minhu.cui@gmail.com	\N	\N	{}	2024-08-26 06:36:59	2024-08-26 06:36:59	t	t
305f0bed-0766-498c-9184-e7031cf4dcac	bdc0c353-4bb0-42dc-aa6c-a00669fa03dc	Bart Cho	\N	I am a marketing expert who enhances the value of brands through creative and strategic thinking. I have gained experience in social media, content marketing, and market analysis.	bartcho@bartchoins.com	2134790066	\N	{"Applied General Agency ","Medicare Insurance ","Retirement Plans ","Tax "}	2024-10-12 19:29:29	2024-10-12 19:29:29	t	t
82a934b4-a381-4bab-87b2-293d5ea4a851	53117328-58fe-45e6-af2c-54d9968ec3a9	Nguyễn Quốc Bảo 	\N		qn245442@gmail.com	0387401739	\N	{"đo đạt "}	2024-04-17 23:05:20	2024-04-17 23:05:20	t	t
ccb91684-89ca-4adf-bb2c-bad0b886d8c4	b3d111ed-f31c-4300-9157-5268ef6acb68	shrimanta Besra 	\N	I am an experienced accountant who provides accurate and reliable financial management. I have expertise in financial analysis, tax planning, and auditing across various accounting areas.	besrashrimanta8@gmail.com	9332624043	\N	{1}	2024-07-09 19:29:15	2024-07-09 19:29:15	t	t
70df149f-2e19-49c5-9ed3-da001a9aa03a	55ca4efa-c0ae-4e3a-acad-adc0c644a31b		\N		3421471119	\N	\N	{}	2024-04-04 04:37:18	2024-04-04 04:37:18	t	t
ff683535-22d6-47ba-be01-1d54121f93b8	e9c970a7-cd3b-452e-b6f7-70b9d9d60148	박재범	\N	포토그래퍼. 사진가. 프로필사진. 음식사진. 제품사진. 인테리어사진. 푸드스타일리스트. 리빙스타일리스트. 스타일리스트. 영상감독. 영상제작. 쇼츠영상 숏폼영상 링스영상. 라이브방송. 유튜브콘텐츠 제작. 라이브커머스	neo355@naver.com	01073988598	\N	{사진,스튜디오,영상,유튜브}	2024-03-21 01:23:57	2024-03-21 01:23:57	t	t
ddf4da9f-0cc6-491c-92df-4e07cb7d535a	7b2f0abe-21ce-4e1a-8e33-477b2c27b5ce		\N		3331270133	\N	\N	{}	2024-02-06 02:10:49	2024-02-06 02:10:49	t	t
a69f5c46-25ed-474d-a948-2324c69da7d8	c1dbe57f-98a3-4a7a-b19e-73086799fcdd	황	\N	고퀄리티 색조화장품 ODM. OBM 제조회사, 메이크업 브랜드 passioncat 유통	hehh21@empas.com	1032291792	\N	{색조,스킨케어,아이라이너,화장품}	2024-02-20 09:25:59	2024-02-20 09:25:59	t	t
69ffa6e1-2688-4085-8318-00cb0938b06d	36829335-1ae2-4400-86b9-84fd4bf2de32	이동신	\N	의류	dhqjaos99@gmail..com	01096318431	\N	{상의,의류,하의}	2024-03-29 05:34:11	2024-03-29 05:34:11	t	t
d58eecf7-e2ef-474a-a23e-81a2ef3d8364	06cd90d8-0225-4179-addd-f6447a77fbd7	jenny	\N		jslee9939@gmail.com	1077449710	\N	{coin}	2024-11-15 01:41:44	2024-11-15 01:41:44	t	t
d2eb9143-ba70-4593-842d-311c7d59da79	6cf02dfe-843d-4bb8-b393-e33f9eeff928		\N		3386385815	\N	\N	{}	2024-03-12 21:27:09	2024-03-12 21:27:09	t	t
5e0af28c-f3cf-48e2-886b-62cb1c762399	e67cf957-5c57-4a9c-bd51-fed02354ff82		\N		balvansangada32@gmail.com	\N	\N	{}	2024-08-10 16:56:13	2024-08-10 16:56:13	t	t
9a03a2d5-cb9a-4f41-87c9-7f6dedb685bc	691ca433-0a88-4a91-929a-60daa51ec4a3		\N		sckang79505@gmail.com	\N	\N	{}	2024-05-17 00:02:46	2024-05-17 00:02:46	t	t
02762c9c-3d20-4d84-b3fa-1a233ad73eb1	d91da0fc-fe05-43d1-b18e-c5a98286291f	cương 	\N	Tôi là một đầu bếp chuyên nghiệp chinh phục trái tim mọi người với ẩm thực kết hợp truyền thống và đổi mới. Tôi theo đuổi việc nấu ăn cân bằng giữa hương vị, sức khỏe và thẩm mỹ.	maitenem@gmail.com	965338114	\N	{1}	2024-05-10 09:18:41	2024-05-10 09:18:41	t	t
035f1ff8-9ef7-4f9a-8200-79fc981f938c	b6122109-a6b7-4e62-a6b8-46db81b929c4		\N		3408526852	\N	\N	{}	2024-03-26 11:53:19	2024-03-26 11:53:19	t	t
2000f891-ec9e-4928-ad7c-5087d43dd58a	04ed257c-7497-4592-8157-d7526ebdbfcb	오숙경	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	damccot@naver.com	1087325983	\N	{식품제조}	2024-02-20 09:26:42	2024-02-20 09:26:42	t	t
73885ffd-9b57-4879-ae81-12289b97b1ec	bb8665d1-3763-44fe-b2e9-bd111d6ff725	Alal Uddin 	\N		alaluddin1367@gmail.com	8638511083	\N	{123456}	2024-08-15 04:19:05	2024-08-15 04:19:05	t	t
7994a2b4-a7d8-4454-a84b-073a9fdc5440	29e8608e-1d49-47ce-8468-a237811b9d24		\N		tranvannhhoan123bg@gmail.com	\N	\N	{}	2024-04-03 02:54:45	2024-04-03 02:54:45	t	t
df3ac9ca-6c7c-47dd-9d3b-5396e82b5d95	1ce7f618-ad5a-4831-8ab7-941266b34f24	김점구	\N	컴퓨터소프트웨어 정보보호 전공하고 대학교수로 30여년 근무함 인공지능을 활용한 사업기획 기술개발 기획 지원가능	jgoo@nsu.ac.kr	1052557386	\N	{골프,교수,기술기획,정보통신}	2024-09-29 02:39:48	2024-09-29 02:39:48	t	t
3f2aadc9-8078-4919-9214-135f3a02380c	f2c5ae55-0e05-4127-b286-efc6fb88b4a1		\N		3164881560	\N	\N	{}	2023-11-15 23:25:31	2023-11-15 23:25:31	t	t
6bbab33e-a735-4568-9480-b2ce80004f53	0afaaf27-ddec-4fa1-81f5-59c0c392ce16	Jerry lacsina 	\N	I am an experienced internist with over 10 years in the medical field. I prioritize patients health and always stay informed about the latest medical research and treatments. I look forward to sharing knowledge for a healthy life.	jerrylacsina9@gmail.com	09949030612	\N	{4}	2024-03-27 09:09:17	2024-03-27 09:09:17	t	t
af02043a-f74c-47f6-a58d-99fa1f97eb25	506a0d86-2822-491c-b4a3-c4261ffff1fe	संजू	\N		sanjubhil608@gmail.com	8769631080	\N	{संजू}	2024-10-27 14:01:07	2024-10-27 14:01:07	t	t
7224857a-7a73-4aca-90c9-4eb62be127d4	8fde015e-4210-4d98-b67e-2d5fcf03db53		\N		iikrudiat20@gmail.com	\N	\N	{}	2023-12-17 13:25:14	2023-12-17 13:25:14	t	t
6f1b24c4-3b2f-4eb5-969f-f66b8d530541	6928567c-2b25-4834-8ebf-27800deb240e	이태철	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	whoytc@naver.com	01030704393	\N	{경영컨설팅,"블록체인 "}	2024-06-09 11:10:47	2024-06-09 11:10:47	t	t
2b1bca30-867a-499c-ad2f-ac5b35e4b0ff	37957796-b647-47d8-a0c5-3b148d5d2f2b		\N		3351451154	\N	\N	{}	2024-02-19 14:49:29	2024-02-19 14:49:29	t	t
d3f0ec7c-0555-4b4f-8f3f-ea43e9e56bda	c37e1291-15d7-44e2-8c96-da670d4734cf		\N		jrenriquimejia17@gmail.com	\N	\N	{}	2024-02-20 07:04:41	2024-02-20 07:04:41	t	t
ac753dcf-a3d7-4932-bbc8-aa2519137ed6	7ea84eca-fec2-409b-953d-9e41efd78a40		\N		gyanchand1121@gmail.com	\N	\N	{}	2024-07-28 12:46:59	2024-07-28 12:46:59	t	t
692e8330-5f1e-43a6-9df5-c2d4f0c00c31	c77022ad-11a2-470a-8d40-ff04b29996cf	rajsharma 	\N	With deep knowledge in the legal field and 15 years of practical experience, I provide clear and practical solutions to complex legal issues. I specialize in commercial law, intellectual property, and civil litigation.	rs3659528@gmail.com	9380019459	\N	{y}	2024-07-23 19:24:45	2024-07-23 19:24:45	t	t
7eb2b040-e5ee-4d2f-b550-e6ea322075de	540da448-1569-464c-9aab-b1045fd15a51		\N		ansharialauddin131@gmail.com	\N	\N	{}	2024-08-11 06:27:48	2024-08-11 06:27:48	t	t
764e72e1-111c-4954-a9a8-acfbd8662bef	bd0e6889-da47-4249-980e-7ed8c3587ac2		\N		charanjeet.lamba1709@gmail.com	\N	\N	{}	2024-07-28 16:22:56	2024-07-28 16:22:56	t	t
5f85c97d-4a38-42e2-a6cb-110680358ec3	92fc9796-8ad9-4dde-bd4f-6144f73ed060		\N		trinidadvirgilio887@gmail.com	\N	\N	{}	2024-03-14 04:27:29	2024-03-14 04:27:29	t	t
81551e5f-99e2-4247-8dc9-123e769ab417	e68fac0f-bb28-4376-a3fc-f06313da4c62	jao	\N	I am a passionate mechanical engineer who develops innovative technological solutions. I focus on sustainable design and efficient process improvement, and enjoy new technological challenges.	jaoshenc@gmail.com	123456	\N	{123}	2024-03-15 04:01:51	2024-03-15 04:01:51	t	t
21d12a08-c7b0-4433-8c7f-95d84f455046	b0457fb7-5638-4a0f-bbc2-688005ef2ae5	phantai	\N	Tôi là một nghệ sĩ chuyên nghiệp biểu đạt cảm xúc và câu chuyện qua ngôn ngữ hình ảnh. Tôi thử nghiệm với nhiều phương tiện và phong cách, chia sẻ sự sáng tạo và cái nhìn nghệ thuật.	phanvantai344@gmail.com	0965658786	\N	{a}	2024-04-15 05:36:09	2024-04-15 05:36:09	t	t
05baacc4-66e3-4539-a784-594ec2d909bb	a2e32bac-cab2-4eb8-a43e-9dfda0f1ca48	전준형	\N	보건복지부 장관상, 굿닥터100인	gsmost@naver.com	01065097645	\N	{"노안 백내장","라식 라섹 스마일라식",안과}	2024-02-20 09:25:52	2024-02-20 09:25:52	t	t
411c396e-4118-4d00-b928-1cdc7c4e9e15	24647c2b-e507-4493-be9c-1e2b2dc7ccb2		\N		3163473827	\N	\N	{}	2023-11-15 01:39:00	2023-11-15 01:39:00	t	t
2d0b2fee-afe7-43f5-a74f-0927f3f8dd76	780cd261-4746-4bc4-90c6-9457ad08308f	권태희	\N	일자리정책 전문가, 일자리사업 컨설팅, 노동시장분석 	taeheekwon@naver.com	01028062533	\N	{"기업CEO 컨설팅",노동시장분석,"사업평가 컨설팅",일자리정책}	2024-03-13 00:09:21	2024-03-13 00:09:21	t	t
eaf2d6bf-fb45-43ae-bb06-9ec16200ccf8	2982d8a2-76cd-4ef3-a223-bf7259540959		\N		3259478324	\N	\N	{}	2024-01-06 12:32:53	2024-01-06 12:32:53	t	t
5c2910bc-8b61-49e7-a401-ad49265f98c3	7807671a-d14a-4cd7-9524-dcc2c6febfeb	김태환	\N	혁신적인 기술 솔루션을 개발하는 데 열정적인 기계 엔지니어입니다. 지속 가능한 설계와 효율적인 프로세스 개선에 중점을 두고 있으며, 새로운 기술 도전을 즐깁니다.	taehwankim6900@gmail.com	01063666900	\N	{스마트팩토리,펌웨어}	2024-03-23 10:15:46	2024-03-23 10:15:46	t	t
7a1a8f37-4db7-43df-a6ec-abebebfc809c	ea94574f-9324-4d8c-ab1b-2ad8efb7e981		\N		ernestomaliksimaliksi@gmail.com	\N	\N	{}	2024-02-19 13:40:07	2024-02-19 13:40:07	t	t
039081b6-5174-466f-a6cc-2a19c63dfd47	1f4dc833-071a-418a-a7f0-efb9312c5e89		\N		3348677168	\N	\N	{}	2024-02-17 22:30:56	2024-02-17 22:30:56	t	t
38a58249-c35e-4faf-ad00-30ccc16f9e67	8afc5a81-b308-4b4e-ae07-29ea138338f8		\N		3355219712	\N	\N	{}	2024-02-21 06:10:48	2024-02-21 06:10:48	t	t
00d69189-13d5-4d21-a4a2-4801962549a9	8942549f-b2e0-468b-b043-7e1fc34b9a5c		\N		ia1547215@gmail.com	\N	\N	{}	2024-07-14 18:31:29	2024-07-14 18:31:29	t	t
ce1b149d-0f1e-4d12-84e2-75f35190c244	2e6c2402-b2ca-45d2-9624-b203350cf0f0		\N		sonianandajammu@gmail.com	\N	\N	{}	2024-08-16 03:00:23	2024-08-16 03:00:23	t	t
42cfeac2-5106-46fe-bd7d-d3643cb53c28	f9f38bd4-064d-4da8-921f-4c8530b77005		\N		kimphuong091070@gmail.com	\N	\N	{}	2024-04-14 15:10:14	2024-04-14 15:10:14	t	t
9474c933-c377-4ba8-8af3-aedb3d733a6b	bc5390b7-6585-41c9-826e-032818c4cefa		\N		ersinghumesh@gmail.com	\N	\N	{}	2024-06-05 06:08:24	2024-06-05 06:08:24	t	t
2ca747ec-5419-447f-8c9b-bb72a9a005e5	a9a5f83f-167c-4e62-b4f0-ed7a123d3990	유용환	\N		qroad@naver.com	01041803388	\N	{남서울대}	2023-11-28 03:31:10	2023-11-28 03:31:10	t	t
d2134a1f-34a8-4634-bc4b-a204c03f2393	348e8cdb-38a0-4d22-84e1-9f7d902b3f81		\N		laoangpeter2@gmail.com	\N	\N	{}	2024-05-09 03:32:06	2024-05-09 03:32:06	t	t
83b09a9e-86a1-49ba-a393-475580fd0a94	ba7cf405-2477-4369-97ef-ed720e0686b6		\N		3326928411	\N	\N	{}	2024-02-03 01:46:40	2024-02-03 01:46:40	t	t
3440173c-4495-41bd-ab82-bed6a87af213	db3a29f6-ba7b-40d7-8ccb-49877086aa45		\N		maheshsuthar27469@gmail.com	\N	\N	{}	2024-07-10 08:04:56	2024-07-10 08:04:56	t	t
af2d0b7a-781a-42eb-ac33-e011cd5e1f14	18828b4e-e4bf-428d-b366-aacb608610c4		\N		lalitmohanbhatt143@gmail.com	\N	\N	{}	2024-07-09 21:00:24	2024-07-09 21:00:24	t	t
6b6829cd-221e-418a-946a-b2ac74cfefee	6088208f-1f95-4519-8804-6892380ced11		\N		nguyenlamgiakiet2024ct@gmail.com	\N	\N	{}	2024-02-19 14:51:55	2024-02-19 14:51:55	t	t
5b0f5b82-993b-448a-a488-bc9c98175768	61570aba-9772-4b60-bff4-737a82f4af6a		\N		qamarsikandarkhan@gmail.com	\N	\N	{}	2024-07-11 17:29:28	2024-07-11 17:29:28	t	t
3cb50f4d-19f8-441c-9189-f86cc0b040c7	f023d294-7ee4-4022-9d71-92b6b8dc46b9	테스트2	\N	테스트2	icncastcw2@gmail.com	\N	\N	{}	2024-02-22 04:57:38	2024-02-22 04:57:38	t	t
c3ebcd21-5916-4de1-b055-2db07aecb80f	769c8536-492d-4536-9736-cf780c9c564b		\N		nandininayak7958@gmail.com	\N	\N	{}	2024-07-26 16:40:26	2024-07-26 16:40:26	t	t
f1bf233a-8bb3-4b6b-8983-f799243fd4d2	e617cb11-6363-43d1-8754-b0aa2d004810	s chourasia	\N	I am an experienced internist with over 10 years in the medical field. I prioritize patients health and always stay informed about the latest medical research and treatments. I look forward to sharing knowledge for a healthy life.	krmail101@gmail.com	8434039700	\N	{1,2,3,4}	2024-08-15 07:21:18	2024-08-15 07:21:18	t	t
571f698a-f88c-4f01-859f-90dcc0485018	cf7b377c-4e4b-42f1-b1d5-250dee6461a4	최태용	\N		13ty.choi@gmail.com	1091998898	\N	{사이버보안}	2024-04-15 22:25:47	2024-04-15 22:25:47	t	t
a02afd89-c49b-47d9-babe-8d96a6565292	7ee66328-1a83-40d2-abdb-25698ec114bc		\N		mondalsnajit38@gmail.com	\N	\N	{}	2024-07-28 16:27:44	2024-07-28 16:27:44	t	t
d781aa8b-176a-4c2b-9f70-555dd2260fde	25efd5ea-8662-47ea-aac5-0e6a302a3e26		\N		dangevaseem897@gmail.com	\N	\N	{}	2024-08-09 15:35:43	2024-08-09 15:35:43	t	t
e8fdf8c1-4bcd-4ac3-ae01-3c9d54baa53e	6382705f-42e1-4f9f-a1f7-8c8daa47b9a0		\N			\N	\N	{}	2024-03-08 01:04:20	2024-03-08 01:04:20	t	t
72e8b539-390d-429a-b631-a3d6cddb88eb	fa2dcaca-97e2-4037-b23f-8f0b8acaed35		\N		panthsantosh02@gmail.com	\N	\N	{}	2024-08-14 10:49:08	2024-08-14 10:49:08	t	t
2c8c6755-117b-45c7-903d-67677871bc99	1a566d70-ff49-4c3c-8d21-7fa7b21211fb		\N		teerathvishvakarma1969@gmail.com	\N	\N	{}	2024-08-15 09:54:50	2024-08-15 09:54:50	t	t
bce1aaee-491b-4ccd-bc82-a79a94472998	22a1cb60-704a-4959-83c9-1109dea8a87a		\N		nliem0563@gmail.com	\N	\N	{}	2024-03-25 15:52:56	2024-03-25 15:52:56	t	t
676cbd4e-3f73-4975-8d80-4845a96197a7	e48f3417-8cf4-42c9-8776-afaa56752f6e	채기수	\N	비전문가임	hxhxh@naver.com	01049224838	\N	{동작지점}	2024-04-18 10:43:47	2024-04-18 10:43:47	t	t
b68ac1e7-5794-416d-bf9b-55ae6583b273	bdd944e1-3a2f-4f51-8db8-8bad2e0215f1	munishkumar 	\N	I am a marketing expert who enhances the value of brands through creative and strategic thinking. I have gained experience in social media, content marketing, and market analysis.	kumarmunish28390@gmail.com	7033462055	\N	{maried}	2024-07-15 15:38:37	2024-07-15 15:38:37	t	t
acf9e5de-7521-46c6-a65e-00801d4284a0	deb8426c-e0ed-46de-81e5-90b4bfda7d39		\N		rahul8275637459@gmail.com	\N	\N	{}	2024-11-12 17:04:11	2024-11-12 17:04:11	t	t
eb994cf4-86d5-4eb7-aabb-5b52c48a277d	640c9afd-9ed2-4225-b2e5-7458c9fc7e4b	김기환	\N	정보보호컨설팅 에서 솔루션 까지! ISMS-P,ISO27001 인증심사원 	itconsult@hanmail.net	01043191422	\N	{정보보호}	2024-02-27 00:09:21	2024-02-27 00:09:21	t	t
55caf976-749b-4c33-848d-317df0234569	513cf638-5a30-4ab9-9752-b1c65236e65a		\N		kanaiyat48@gmail.com	\N	\N	{}	2024-05-29 13:27:40	2024-05-29 13:27:40	t	t
35b60a81-b5c7-4fa1-a0bc-afa836d039e3	280c4e9a-fcb7-432d-ab32-a4dc432c94f4	김경헌	\N		kimkyungheonm@gmail.com	0966590372	\N	{빈홈오션파크}	2024-03-13 15:29:49	2024-03-13 15:29:49	t	t
00f0e3c4-7098-4d56-962f-3c516cbd2919	5bfe0002-a6c2-4ed1-a9fc-5d84e99f6402		\N		cuong20761@gmail.com	\N	\N	{}	2024-07-09 21:34:58	2024-07-09 21:34:58	t	t
0b6e81f4-f6fe-49da-b2ee-0c8d4209746d	82897173-7157-4508-9557-9e6700c0dc4d	윤준성	\N		3402172721	01094722723	\N	{보험}	2024-03-22 08:28:55	2024-03-22 08:28:55	t	t
1203c544-d82e-4dbe-9a76-0d009acec159	10ca26e0-be04-44ae-9532-a88a58668533		\N		sunnyandscramble.ruiz@gmail.com	\N	\N	{}	2024-02-17 23:14:59	2024-02-17 23:14:59	t	t
5a0d4114-8750-4585-8a00-f9ab821bb139	6b0b5ee8-615a-43be-a403-cf30cf4c3c66		\N		sittuyadav7508@gmail.com	\N	\N	{}	2024-07-19 21:07:55	2024-07-19 21:07:55	t	t
9476780c-ed12-4ea1-a39a-8d20ac929d41	a5b38314-60e9-4ba3-a011-5567e227d322		\N		3386347692	\N	\N	{}	2024-03-12 18:03:04	2024-03-12 18:03:04	t	t
f9f0188f-e0cd-4d77-a254-6f558fb0b096	0d5abcf4-e12a-4cbe-ba15-01ef7fd3ec5f		\N		shambhubiwasshambhubiwas@gmail.com	\N	\N	{}	2024-07-27 22:32:11	2024-07-27 22:32:11	t	t
08a5d286-1c00-4df3-81bb-6daff59756b2	776d5415-fd11-4be0-99a7-fd192b4804a2		\N		renatoabille@gmail.com	\N	\N	{}	2024-03-12 09:00:03	2024-03-12 09:00:03	t	t
ab44fb1b-f96a-4f1d-ade5-4882210a9062	8fb7d099-716c-4b0b-ad91-4e94b0d00d63		\N		tnamphutungoto@gmail.com	\N	\N	{}	2024-03-12 22:52:12	2024-03-12 22:52:12	t	t
606bbe75-1aaf-41f2-bc96-f0f022d493e5	63c0b18b-9d4b-4cb1-b3cc-3cbf8bda0362		\N		mrcdtpsndjmn@gmail.com	\N	\N	{}	2024-03-13 21:09:40	2024-03-13 21:09:40	t	t
4926f4f4-0959-4d1f-bc85-a9bd50f3081a	e36db7d9-966a-48e9-a337-3c7dd6ba69ce		\N		3406637665	\N	\N	{}	2024-03-25 09:15:14	2024-03-25 09:15:14	t	t
a2621dbd-c97d-4626-b9e4-a8a1e828a56a	bec4ca37-50c4-46ea-9840-a0228ce9df38		\N		a01036595618@gmail.com	\N	\N	{}	2024-03-21 00:50:41	2024-03-21 00:50:41	t	t
1c31c53e-70e4-4ba5-9121-35973e5fe927	b9f6838a-5754-43ef-a5aa-11d291dda390	kim.sung	\N	I am a professional artist who expresses emotions and stories through visual language. I experiment with various mediums and styles, sharing creativity and artistic insight.	ksungkap@gmail.com	7147468880	\N	{13,business,music}	2024-11-08 01:09:06	2024-11-08 01:09:06	t	t
a40a53b7-8c2e-4052-9d11-178278fd04fe	2e669ab1-26da-4903-9427-c4f13bf92a1f	phuong	\N	Tôi là một chuyên gia tiếp thị tăng cường giá trị thương hiệu thông qua tư duy sáng tạo và chiến lược. Tôi đã tích lũy kinh nghiệm trong lĩnh vực truyền thông xã hội, tiếp thị nội dung và phân tích thị trường.	vuphuongly25121988@gmai.com	0352030289	\N	{1234}	2024-04-04 11:24:35	2024-04-04 11:24:35	t	t
042ad716-7bb2-4cc1-8031-3a9f5fe37bcf	d611a087-be26-4d78-b1c2-9c1329650ef1		\N		withindopaul@gmail.com	\N	\N	{}	2024-11-06 00:05:21	2024-11-06 00:05:21	t	t
f0ed191e-acb4-4357-8e0e-5cf8f68cb6cc	e8e2e120-539d-462f-983f-7b7c8b6ddfc2		\N		chungtuyen40@gmail.com	\N	\N	{}	2024-05-07 03:29:58	2024-05-07 03:29:58	t	t
83309235-c831-40e1-adfb-f981179acced	b23294b4-28f3-4a8b-bc76-29377cd4a7f2		\N		r8494651@gmail.com	\N	\N	{}	2024-07-11 08:40:35	2024-07-11 08:40:35	t	t
d711e85e-972f-4409-a15f-ad3a59e4a349	df70ca0d-8dd3-4c3f-9dcc-212b00dc542c	Đông	\N	Khác	nguyenvandongvp1985@gmail.com	0975846794	\N	{Đ}	2024-04-16 12:57:34	2024-04-16 12:57:34	t	t
a4ad69ab-58b6-49c9-8397-857b4d1166dd	aa4b5af8-90ec-46b0-8cd5-0f6a42c135be		\N		vklheprincefacoly@gmail.com	\N	\N	{}	2024-11-20 18:58:03	2024-11-20 18:58:03	t	t
eaee1ee3-fe4b-4c51-8ec2-0555ab1b2319	16c03ecc-7936-4614-b272-58cfb2288da8	최	\N		3248631902	01092119852	\N	{.,ㅇ,ㅡ,ㅣ}	2023-12-30 14:54:55	2023-12-30 14:54:55	t	t
05e20e13-fd90-4e11-8b5e-aad00e6115e5	66b771c6-9028-44eb-83e5-1ae8d757688d	홍순좌	\N		dleam85@daum.net	01066453957	\N	{사이버보안}	2024-06-27 08:20:01	2024-06-27 08:20:01	t	t
b00c58e8-974f-4cf2-91e8-1717f02c24a8	a0a2dd68-6292-4771-939e-d7ebc2482cf0	Rakesh 	\N	I am a professional chef who captures hearts with cuisine that combines tradition and innovation. I pursue cooking that balances taste, health, and aesthetics.	ry5292851@gmail.com	8264965889	\N	{2}	2024-07-12 04:21:46	2024-07-12 04:21:46	t	t
5ae79095-a413-43a2-8e22-a93de3569a42	cc00217b-f62e-45c5-a06b-16ab2da154b0	이언컨설팅그룹	\N	이언컨설팅그룹	jspark@eoncg.com	\N	\N	{}	2023-11-28 07:11:10	2023-11-28 07:11:10	t	t
23331c69-ae9a-4d23-a1ec-f02f429d90e7	d66fa8c7-93c6-4904-9cf0-29121c1042d8		\N		nutansinha7373@gmail.com	\N	\N	{}	2024-05-24 19:57:04	2024-05-24 19:57:04	t	t
f681b19d-b320-49b1-a126-1b5892686558	376225dd-5419-4aab-862c-25bd9e67f5df	Vũ Văn Anh	\N	Tôi là một chuyên gia CNTT thông thạo công nghệ và xu hướng IT mới nhất. Tôi nổi bật trong lĩnh vực điện toán đám mây, an ninh mạng và phân tích dữ liệu, và theo đuổi sự đổi mới số.	tuyetva2001@gmail.com	0395508535	\N	{"hoàn thành"}	2024-03-14 12:11:29	2024-03-14 12:11:29	t	t
89575417-8bca-4a46-9dbe-a088d5d5cd62	2396a298-568e-4237-a8d5-faa1c3902182		\N		vishnupatel62578@gmail.com	\N	\N	{}	2024-07-27 17:52:14	2024-07-27 17:52:14	t	t
673f3106-fec2-4c8a-925a-f1b88a738f0d	c180b2ed-216a-4667-8320-f25d7128f4e4		\N		3385813779	\N	\N	{}	2024-03-12 09:37:13	2024-03-12 09:37:13	t	t
08346362-1b2a-4680-95f4-270b9c4842ad	b7068e6f-0513-47a6-82d5-a67333d69e31	장정희	\N		3678572681	01076870772	\N	{사회복지사}	2024-08-25 08:02:34	2024-08-25 08:02:34	t	t
ca2db963-1649-48dd-a0f0-5cbc396d578e	1959193a-0762-4ea6-973f-390f702cd72e	이정우	\N		leews135@gmail.com	1012345321	\N	{ㄹ}	2024-03-28 01:06:36	2024-03-28 01:06:36	t	t
8cad27ba-d42a-4ea3-b418-4b3297c2691d	27de209b-0424-46bc-83ca-5e7170f6d78c		\N		spremsingh3083@gmail.com	\N	\N	{}	2024-08-11 05:05:55	2024-08-11 05:05:55	t	t
ce7f3c83-315b-428d-a25a-ff3ae2c19251	4100eb65-7e5b-4496-9bb1-17df3e3225b8	Bilkent 	\N	I am an enthusiastic teacher who helps students realize their full potential. I aim to enhance learning experiences through innovative educational methods and technology.	incirtuba38@gmail.com	5536967201	\N	{"English ","occupational ","test "}	2025-01-14 17:10:35	2025-01-14 17:10:35	t	t
5d74ce11-6e01-43cd-85e4-850d8226a3fd	05dff67f-5742-496e-b28c-fa2e75e2a073	Jang	\N	I am an experienced accountant who provides accurate and reliable financial management. I have expertise in financial analysis, tax planning, and auditing across various accounting areas.	sangbin94@gmail.com	2136862001	\N	{tax}	2024-12-12 23:02:57	2024-12-12 23:02:57	t	t
7b9a01eb-ed16-44d8-94a9-923f63343a77	7a2ca438-8b6c-492c-8fbb-797c9e4e7e1b	이병호	\N	방송협찬광고 	advision@hanmail.net	01032932678	\N	{광고,"협찬광고대행 "}	2024-04-18 10:43:56	2024-04-18 10:43:56	t	t
97ae43f4-bb0a-4932-8408-f0404410a1b2	b95206de-7a1a-49db-ab02-cf00dcd9504c	원광연	\N		aa63133776@gmail.com	01063133776	\N	{!@*}	2024-05-14 05:08:43	2024-05-14 05:08:43	t	t
95257fcf-0752-42ed-8042-1d7553ad39b6	26714e45-c467-4ca3-9075-e205a203fe52	praveen	\N	I am an IT professional well-versed in the latest IT technologies and trends. I stand out in cloud computing, cybersecurity, and data analysis, and pursue digital innovation.	hgddshhcajjh9636@gmail.com	9931082234	\N	{t}	2024-06-02 08:09:16	2024-06-02 08:09:16	t	t
efc8b928-ef2d-4e2d-a504-27ff64dc5aaf	01646a03-f544-4787-ba90-627eda7ff131	Sanjit Mandol 	\N	I am an experienced internist with over 10 years in the medical field. I prioritize patients health and always stay informed about the latest medical research and treatments. I look forward to sharing knowledge for a healthy life.	sanjit.mithipur@gmail.com	9091295645	\N	{"Sanjit Mandol "}	2024-07-09 19:47:07	2024-07-09 19:47:07	t	t
a5191d53-860b-4163-992e-dae612ac2cd3	ce43c158-5cbd-48df-8172-cd702ff0700c	Devendra Sen 	\N	मैं एक उत्साही शिक्षक हूं जो छात्रों को उनकी पूरी क्षमता महसूस करने में मदद करता है। मैं नवीन शैक्षिक तरीकों और प्रौद्योगिकी के माध्यम से सीखने के अनुभवों को बढ़ाने का लक्ष्य रखता हूं।	devendarsendevendarsen8@gmail.com	7568961993	\N	{1}	2024-07-16 04:02:49	2024-07-16 04:02:49	t	t
4fde01f3-b278-42cf-9a8d-8471b2c99260	d2caadf6-f315-44cb-ac30-1b39d2efc95e	sukuri	\N	I am a passionate mechanical engineer who develops innovative technological solutions. I focus on sustainable design and efficient process improvement, and enjoy new technological challenges.	sukrubhatra1234xyz@gmail.com	8144369470	\N	{fvcbjj}	2024-09-05 16:35:51	2024-09-05 16:35:51	t	t
c9c64d37-9f74-494f-8bb6-8c15f34d2d08	ec0b3178-ffd4-405c-a15e-aeb71b66560c	Nhơn 	\N	Tôi là một chuyên gia tiếp thị tăng cường giá trị thương hiệu thông qua tư duy sáng tạo và chiến lược. Tôi đã tích lũy kinh nghiệm trong lĩnh vực truyền thông xã hội, tiếp thị nội dung và phân tích thị trường.	nhon4346@gmail.com	0868707935	\N	{tuhanh}	2024-04-15 07:31:40	2024-04-15 07:31:40	t	t
2ebbff59-7391-4147-8740-0414a0cc77ac	6656caaa-62fb-401b-94d5-a41d4be05549		\N		3196428615	\N	\N	{}	2023-11-28 03:21:41	2023-11-28 03:21:41	t	t
cdeaa11d-b76e-4011-ba77-ddc6891d2ad8	a1b33428-b453-4d43-bc3b-dd39be193266		\N		gurupadatiwari32@gmail.com	\N	\N	{}	2024-06-03 05:33:37	2024-06-03 05:33:37	t	t
f7b28948-30e4-4c42-9014-4c50df511495	f2f96776-dd63-4a72-b6dd-7335be117587	변태진 	\N		BTJ620913@GMAIL.COM	01089843233	\N	{키워드4}	2024-02-03 10:24:37	2024-02-03 10:24:37	t	t
a74a8a67-8d4b-4711-8651-e3deed98f60d	68a2b2a2-34f9-4738-9f09-7611fc4248ae		\N		hoaduong.159655@gmail.com	\N	\N	{}	2024-02-17 04:15:57	2024-02-17 04:15:57	t	t
ddda315b-360b-409a-a54c-5a6218efa963	f4a8510a-c11a-4ba5-8915-b30e6e53f9e8		\N		tdhananjay445@gmail.com	\N	\N	{}	2024-07-10 23:45:03	2024-07-10 23:45:03	t	t
97320d7d-44eb-461b-a03b-367267435458	62cd660d-f79a-414d-b7a9-ddba6338048d	정진석	\N	행정사/행정사법인리더스	jsok3253@naver.com	01099003253	\N	{대관업무,벤처기업,인허가,행정사}	2024-02-20 09:32:03	2024-02-20 09:32:03	t	t
9b7f0f9b-b33f-40a5-bc92-5d693d1f075e	19cd3169-bef1-4250-a499-6f53588e82a6		\N		bachchababukushwaha719@gmail.com	\N	\N	{}	2024-07-12 03:51:48	2024-07-12 03:51:48	t	t
6e4fb4e7-dd36-44a2-9cbb-2cfbeb158af4	7ac95e8d-1416-428e-8ad9-6d6b49a9b499		\N		janakg067@gmail.com	\N	\N	{}	2024-07-28 00:00:35	2024-07-28 00:00:35	t	t
8563c196-6e4b-40b9-8812-434ff0833977	eccfca5a-fe79-422a-86a9-00514d1a84f9	김환용	\N	40년 이상의 경력을 가진 물류 전문가로서, 복잡한 공급망 관리와 효율적인 물류 시스템 운영에 깊은 전문 지식을 가지고 있습니다. 혁신적인 물류 솔루션 개발과 실행을 통해 비용 절감과 배송 시간 단축에 기여하며, 지속 가능한 물류 관리를 추구합니다.	hykim@royalgls.kr	01095820921	\N	{(주)로얄지엘에스,국제물류,통관,항공화물}	2024-02-21 06:10:20	2024-02-21 06:10:20	t	t
b37ff1fc-a1b7-4998-8b49-9ff62af25c01	2eb093c8-035c-4de8-9ad8-2af4a4fe17d8	(주)덕성기업	\N	(주)덕성기업	ds6031@naver.com	\N	\N	{}	2024-03-29 11:27:23	2024-03-29 11:27:23	t	t
e4ce49dd-b1c4-43af-ad8f-54ce6f2ec718	3e33926e-1a86-46ec-b46b-d7715d8f7f4c	G gerald manlapas	\N	I am a businessperson with an exceptional ability to turn visions into reality. I pioneer new markets with innovative ideas and strong business strategies.	gmanlapaz2023@gmail.com	0822	\N	{"dad malabas","gerald malapas","gerald manlabas","iyan at malabas"}	2024-03-14 12:13:03	2024-03-14 12:13:03	t	t
786eef02-867c-4c9e-9665-83bbd18af6af	0e691109-aac1-47b0-9727-c9078860a89f	LucyLee	\N	창의적이고 전략적인 사고를 바탕으로 브랜드의 가치를 높이는 마케팅 전문가입니다. 소셜 미디어, 콘텐츠 마케팅, 시장 분석 분야에서 경험을 쌓았습니다.	lucyli779@gmail.com	7185980168	\N	{홍보}	2024-10-26 20:16:16	2024-10-26 20:16:16	t	t
c07bf526-76f6-443c-be66-a4cf422ec81e	fedc407f-9689-4a01-a4ec-e125fd58523a		\N		paulcedricbie@gmail.com	\N	\N	{}	2023-11-16 05:20:28	2023-11-16 05:20:28	t	t
72562b3b-2dd1-4271-ab13-5e72bbfa70c2	e6c0d75d-3eb5-4f54-881c-3515c5eb6de7	(주)영웅투어	\N	(주)영웅투어	ywtour777@naver.com	\N	\N	{}	2023-11-17 09:35:09	2023-11-17 09:35:09	t	t
175392f5-7e46-4422-bcc9-3585a737063b	4272901f-df44-4eec-973b-06cc7835befb	sunglee	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	sunglee0424@gmail.com	21321384193808419380	\N	{financing}	2024-12-13 22:54:04	2024-12-13 22:54:04	t	t
e7f68c6f-373b-46df-b8c1-09dd8c49522a	5075eee3-f309-40c0-b170-ca8ce3126bb9	Nguyễn Văn phòng 0977596126	\N		nguyenvanphong15071958@gmail.com	0977596126	\N	{khoa4}	2024-04-17 18:23:44	2024-04-17 18:23:44	t	t
87e74b17-f8c2-4aac-9cf8-8e70935748be	d7ed2ac2-6770-4e1c-8472-63ec2d556286	법률사무소 정앤헌	\N	법률사무소 정앤헌	lawjeongnheon@gmail.com	\N	\N	{}	2024-03-21 05:33:22	2024-03-21 05:33:22	t	t
c5cf4f1a-d8fe-46d6-bcd2-639a94f505e8	d821b851-e24e-4fc9-8fda-a4b743eeb8a0	송우진	\N		3482316124	01044300234	\N	{","}	2024-05-14 18:58:45	2024-05-14 18:58:45	t	t
5dfd13c3-24e9-4ed3-8dca-59feb800a550	8579e15f-8fbd-491a-93ba-222c366baca7	nar Bahadur 	\N		basnetnb413@gmail.com	6200597433	\N	{Nar}	2024-05-24 12:20:46	2024-05-24 12:20:46	t	t
b08650aa-1213-40f1-b389-ef7cb28dfc66	e066dc7a-8c29-40b7-8d05-92c16814cec2		\N		phanthanhvanmeomeo@gmail.com	\N	\N	{}	2024-03-26 12:01:13	2024-03-26 12:01:13	t	t
dc18a20f-364c-4156-a15e-5990176bdf24	b3aa0f67-975e-4e8e-a7e5-8f82817802cd	박영수 	\N	창의적이고 전략적인 사고를 바탕으로 브랜드의 가치를 높이는 마케팅 전문가입니다. 소셜 미디어, 콘텐츠 마케팅, 시장 분석 분야에서 경험을 쌓았습니다.	Pys610412@gmail.com	01024290074	\N	{ChatGPT,온라인마케팅,온라인쇼핑몰,장점연결}	2024-01-10 04:07:54	2024-01-10 04:07:54	t	t
cd38f9cc-4c7f-4fd6-89a1-cbcba59926bc	a24ba74b-2435-4643-8d23-16de8749558c		\N		haphuong78hp@gmail.com	\N	\N	{}	2024-04-04 04:39:10	2024-04-04 04:39:10	t	t
b74d7164-ffb4-40a2-b4d7-3941effb7122	44ec729f-0a2c-4ce4-88c5-093b6c243551	김상복 	\N	최신 IT 기술과 트렌드에 정통한 IT 전문가입니다. 클라우드 컴퓨팅, 사이버 보안, 데이터 분석 분야에서 두각을 나타내며, 디지털 혁신을 추구합니다.	Sbkim@sbsystems.co.kr	1090428772	\N	{AI,"스마트워치 ","스마트팜 ",헬스}	2024-06-21 06:01:28	2024-06-21 06:01:28	t	t
7056fc26-8249-4140-b064-c908353d5251	504bdffa-a684-41ef-ad70-cbb46ed7e965		\N		rharabebs22@gmail.com	\N	\N	{}	2024-04-05 09:16:33	2024-04-05 09:16:33	t	t
b1133051-5c80-4e90-8814-634fd7d2e37a	7e9f1dff-a9c7-40e2-8534-419d6f68b74f	안성현	\N		3385815900	01028009232	\N	{안녕}	2024-03-12 09:38:44	2024-03-12 09:38:44	t	t
3b492f08-bfd9-4368-bb12-6144cc37e252	686f2a83-9d79-44e9-a91b-0fee2ac6d8b2		\N		3461028137	\N	\N	{}	2024-04-30 23:08:59	2024-04-30 23:08:59	t	t
259dc252-d7a1-4118-895a-13c20d6d47a7	56369354-3edf-40b6-b77b-78eb14f3ee23		\N		3201689333	\N	\N	{}	2023-11-29 06:28:44	2023-11-29 06:28:44	t	t
eabf7236-696e-4d21-be82-b3afa1feafc1	634683f2-de5d-42ca-b2eb-d0d70904e47a		\N		maatrica9@gmail.com	\N	\N	{}	2024-05-10 15:03:50	2024-05-10 15:03:50	t	t
5bee552f-0ef4-45d8-b67c-15cf1411b68e	7b53dfec-3fda-4700-9b0c-a15c39e196d0		\N		3207330828	\N	\N	{}	2023-12-03 03:07:22	2023-12-03 03:07:22	t	t
d68d950d-d9f3-44e7-bdea-bad71d512493	de1fd787-fb20-4c37-8ded-04cda93180b9	AppleJohn	\N	I am an experienced internist with over 10 years in the medical field. I prioritize patients health and always stay informed about the latest medical research and treatments. I look forward to sharing knowledge for a healthy life.		01011112222	\N	{ㅎㅎ}	2024-03-20 11:16:43	2024-03-20 11:16:43	t	t
a52b77df-e788-4ad0-9167-fac1719bdd30	f3447f77-a323-4889-9561-6e207488001e	राजू भूरिया	\N		rb666022@gmail.com	7828233655	\N	{"राजू ओरिया"}	2024-07-16 02:00:43	2024-07-16 02:00:43	t	t
107f40b8-e911-40c8-bfe6-c3f0409aeed2	c63344c6-cc3c-483e-880e-3fdd280852b7		\N		nlvillarta@yahoo.com	\N	\N	{}	2024-02-19 21:00:59	2024-02-19 21:00:59	t	t
4e45fb5e-dd24-45d0-a028-1c832f8e540b	337fe698-7a7b-4205-8a69-ed79dca59076		\N			\N	\N	{}	2024-02-14 03:22:04	2024-02-14 03:22:04	t	t
2af3f8ad-5bfa-4df0-99d0-1bac75daee3b	f85174e6-7a0b-4534-97af-70757872b5a9		\N		ratneshkumar3u2000@gmail.com	\N	\N	{}	2024-07-13 00:35:07	2024-07-13 00:35:07	t	t
4480155e-c948-496d-99c8-2fbb3f423db9	21e2d8b2-c109-4493-bacd-dc87e364c17a		\N		sujenkishan7@gmail.com	\N	\N	{}	2024-07-12 04:17:23	2024-07-12 04:17:23	t	t
f8aead07-dee2-4402-84f9-44bd25b4c6da	c972aafc-9e3e-4d71-844a-e75e99f4092f		\N		3385896067	\N	\N	{}	2024-03-12 10:38:31	2024-03-12 10:38:31	t	t
b114cea9-65df-4101-aaec-da6bf780c09e	6fcf0c16-8f65-4b11-8d5d-5fe2b83f9cd0		\N		3388920375	\N	\N	{}	2024-03-14 11:57:30	2024-03-14 11:57:30	t	t
76d8c35e-1b3b-44a9-bc26-24d3434c8567	d1ed20a2-81de-4ba6-80e6-38635c8e1295		\N		bositorommel1975@gmail.com	\N	\N	{}	2024-04-03 10:49:20	2024-04-03 10:49:20	t	t
667027bd-450e-4ff4-b2a4-f57d91219dcc	50aa5202-9186-4f05-9317-66210b195e17		\N		angelamirandaboaquina@gmail.com	\N	\N	{}	2024-04-15 14:39:51	2024-04-15 14:39:51	t	t
8ee46a7b-1bcf-4715-9df4-12d9ecd28b10	87ca839c-a249-48e4-a9e3-f4e1f844e94e		\N		ganeshantpganeshan@gmail.com	\N	\N	{}	2024-05-18 15:24:05	2024-05-18 15:24:05	t	t
9faec9bc-3333-4984-aac8-82f4652f3d93	202e9593-8d08-449a-a703-92c39902daf2	CLEAR ANN 	\N	I am a marketing expert who enhances the value of brands through creative and strategic thinking. I have gained experience in social media, content marketing, and market analysis.	clear096amore@gmail.com	9945995695	\N	{MOVENPICK}	2024-03-14 10:14:19	2024-03-14 10:14:19	t	t
0d17d6b6-b61d-49be-be2c-81b5737ce514	6265f1a4-b2ff-4401-b2ce-26f57fa234c9		\N		3346781619	\N	\N	{}	2024-02-16 11:10:58	2024-02-16 11:10:58	t	t
3a462bba-4254-4ecf-ab7b-12c74707e1a8	40532bb5-0d37-4b72-a2bb-2805d8d1d929	Angela Lee	\N	저는 비지니스하시는 사장님들의 크레딧카드서비스를 도와드리는 일을 하고있습니다.모든카드의 Rate을 최소의 %로 해드릴것을 약속드립니다. 신뢰와 정직!! 부담없이 언제든지 연락주세요. 전화 못받으면 메세지 남겨주시면 바로 연락드리겠습니다.감사합니다. 돈 많이 버세요~	he.angelalee@gmail.com	2139847111	\N	{"ALLIANCE MERCHANT SERVICES"}	2024-10-24 17:16:39	2024-10-24 17:16:39	t	t
981751c8-1ed4-47df-baea-3c26f8b42cc1	ae7be8a0-0ca9-42fc-a03e-8844277b9c7b		\N		a60129152@gmail.com	\N	\N	{}	2024-02-17 14:33:17	2024-02-17 14:33:17	t	t
d0e8821a-beba-490b-9220-b8ba73d881a3	0a06065b-8318-4070-9fab-a7c2eb12a1b3		\N		3351295591	\N	\N	{}	2024-02-19 12:57:47	2024-02-19 12:57:47	t	t
73b33780-2e5c-4065-aa73-d96dfdd4d3e5	d242cbd6-c766-48b3-9131-9b1f051eba28	강승연	\N	창의적이고 전략적인 사고를 바탕으로 브랜드의 가치를 높이는 마케팅 전문가입니다. 소셜 미디어, 콘텐츠 마케팅, 시장 분석 분야에서 경험을 쌓았습니다.	pandol91@gmail.com	1087432094	\N	{광고,미디어,미디어플래너}	2024-04-25 06:28:46	2024-04-25 06:28:46	t	t
4b3734f1-4550-4a63-86ba-4f343f49b59d	a09353dd-52b0-4575-be49-2e5610517a71		\N		gopalnigamnigam31@gmail.com	\N	\N	{}	2024-07-29 06:10:57	2024-07-29 06:10:57	t	t
2febe048-425a-4813-8c94-57a545a8a07b	ceaa27da-282e-460b-8cd1-ed95f9c7d1ff	khánh 	\N	m.khánh 	hoangsonct3@gmail.com	355515442	\N	{"khánh ",m.}	2024-02-20 06:37:13	2024-02-20 06:37:13	t	t
561d5ecc-38f1-4fb9-9ccf-18483ae58370	15a46aed-a65c-4f5a-b06c-7c95230e043b		\N		akhileshkusvaha310@gmail.com	\N	\N	{}	2024-08-13 06:53:19	2024-08-13 06:53:19	t	t
bf57b206-ee28-4528-b5ad-d429a031249c	b7008772-c853-4fc6-b754-a40aad794448	hằng	\N	Tôi là một kế toán viên giàu kinh nghiệm cung cấp quản lý tài chính chính xác và đáng tin cậy. Tôi có chuyên môn trong lĩnh vực phân tích tài chính, kế hoạch thuế và kiểm toán ở nhiều lĩnh vực kế toán.	donhuamayhang@gmail.com	0977581568	\N	{2,4,h,m}	2024-04-05 15:26:15	2024-04-05 15:26:15	t	t
e1431694-b30e-4ef1-b78c-4088e46f3bd3	b4e864f4-a2ff-45af-a7f5-5fcc8602404e	हरलाल झां	\N		jhadhaniram88@gmail.com	9118704776	\N	{छडड}	2024-07-11 07:45:15	2024-07-11 07:45:15	t	t
265a36c8-c10c-4d3d-8800-84f38a139593	f8756742-6ed3-4e97-97de-3eed8f1d8453		\N		kitingm@gmail.com	\N	\N	{}	2024-04-15 00:30:42	2024-04-15 00:30:42	t	t
d070732b-6d3b-4510-b6ce-542700383d3b	37b46c47-9a8c-43c0-8b88-b3b035d8e4e6	최새롬	\N	라이브방송, 제품촬영,음식촬영,프로필촬영 전문. 포토그래퍼와 스타일리스트,영상전문감독 원팀	stylingho@naver.com	01071422521	\N	{라이브방송,사진촬영,스튜디오,영상촬영}	2024-02-20 09:27:17	2024-02-20 09:27:17	t	t
25a9353d-d95b-4b34-9125-c193e499794d	c2a554a7-8f5e-4f75-a4cb-115cb59a4f75		\N		worker1440@gmail.com	\N	\N	{}	2023-12-02 07:14:23	2023-12-02 07:14:23	t	t
2cbaf898-f47d-4c4b-8c8c-2b96fed9db29	26884176-fd17-486f-bfda-4a77a0dc36d7		\N		rampalbarkhade36@gmail.com	\N	\N	{}	2024-06-15 15:40:28	2024-06-15 15:40:28	t	t
6d7f2866-d3d6-4934-a064-de07437151ea	b31dac20-7f9e-4e04-997a-2223439a5029	서연송	\N		ys0727cookie6@gmail.com	01037999137	\N	{대학생}	2024-04-05 02:13:01	2024-04-05 02:13:01	t	t
c45a3472-0689-4466-b8ad-aae264af7046	41a900d3-a78d-49dd-aa73-85166a70e671		\N		sumingcanjade14345@gmail.com	\N	\N	{}	2024-02-20 06:09:56	2024-02-20 06:09:56	t	t
53351932-94f0-446a-a637-94463dbfcc97	20115650-29ba-44fa-9861-99c990caa5b1	박창우	\N		ckddn1208@naver.com	01036528993	\N	{플러터}	2023-11-14 06:03:45	2023-11-14 06:03:45	t	t
c2272872-ecdc-4250-a5ea-03d9ccae7e8c	030e1b49-ca9d-4a06-a915-3ea616a68c6b		\N		arjunkumar458868@gmail.com	\N	\N	{}	2024-08-08 11:43:02	2024-08-08 11:43:02	t	t
9224288b-6d2d-4656-8a9e-d54019053243	f04f3f76-bb72-42c4-bc50-eaebbe67b788	gjhb	\N			01000000000	\N	{" hgg"}	2024-03-05 13:44:30	2024-03-05 13:44:30	t	t
8cd2ba3f-1216-46fe-a1b6-4be478f42bfe	fbbbe6f6-1220-4fdf-b12f-fa37353ce314	조용현	\N		yhcho75@gmail.com	1056125769	\N	{it}	2024-03-09 00:46:39	2024-03-09 00:46:39	t	t
5895874f-ee29-4948-8b5c-ff9a1cef6b73	2981927e-7f71-4285-8713-396bc05c8555		\N		gopalbhavsar.2902@gmail.com	\N	\N	{}	2024-08-13 12:39:11	2024-08-13 12:39:11	t	t
990a7dad-0be0-4cad-862a-96798f8f4c9b	f6326bb7-5905-40bf-bee0-a6ca1931f6a9	John Park	\N	I am a professional chef who captures hearts with cuisine that combines tradition and innovation. I pursue cooking that balances taste, health, and aesthetics.	jongpark321@hotmail.com	7143361514	\N	{church,"Restaurant "}	2024-10-28 03:56:08	2024-10-28 03:56:08	t	t
977f33d8-84b8-476d-bb88-5d930faaa56f	31f1e27a-5b94-4662-b0b5-5298f4603a80	가온세무회계	\N	가온세무회계	kbscta@naver.com	\N	\N	{}	2024-03-29 11:35:48	2024-03-29 11:35:48	t	t
506f908a-a677-4217-8429-e9fba4979ea4	6ffda751-1faf-4560-a259-464048611cb1	이상종	\N		3435666327	01035953512	\N	{영어공부}	2024-04-13 19:40:51	2024-04-13 19:40:51	t	t
e257595c-1303-491b-b8a1-0532d2503f10	d9918fe1-6201-45aa-b1b6-9da4a6189aaa		\N		nguyenthanhtan8797@gmail.com	\N	\N	{}	2024-04-05 06:17:47	2024-04-05 06:17:47	t	t
e9d78c1c-8330-4a30-aff7-eb0f3e7977a2	63b91840-aeb7-4558-a952-9e23e7217c1c	박대전	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	pdj69@hanmail.net	01032265435	\N	{ESS,신재생,집광채광루버,태양광}	2024-03-17 23:48:02	2024-03-17 23:48:02	t	t
b5eea32d-669e-4489-8c18-234fa15460ca	33a50f77-7fe1-4243-b2ca-94779146a5a9	대한민국가족지킴이	\N	대한민국가족지킴이	grace7181@naver.com	\N	\N	{}	2023-11-16 23:24:44	2023-11-16 23:24:44	t	t
f08fa329-5e4b-4fb0-87c8-52ac221c1b46	6b384c05-52a4-4d79-970e-f0022375a358		\N		3163474121	\N	\N	{}	2023-11-15 01:39:13	2023-11-15 01:39:13	t	t
e2c69186-a347-4f09-88c6-62a226bd4f42	ee038087-bdd5-40b7-ba3f-e67c2265a463	Shinki Kang	\N		arirangny@gmail.com	6462588778	\N	{3157,4935}	2024-10-26 16:48:33	2024-10-26 16:48:33	t	t
d2f7e4d9-090c-46a3-9269-c84dd013e0f5	ceaab4d5-cd27-4f2f-8dcd-c33c685a606a		\N		mdrah121234@gmail.com	\N	\N	{}	2024-05-13 00:17:26	2024-05-13 00:17:26	t	t
4a8f619e-0972-4b60-a811-431175360f7c	712feb0a-52e5-44a6-8d15-5979243c7b15		\N			\N	\N	{}	2024-07-08 11:48:16	2024-07-08 11:48:16	t	t
44529c70-9a24-4906-9f35-c26a2f0723c3	620c74cc-c8e1-4137-aba2-18a740515388		\N		3332291676	\N	\N	{}	2024-02-06 15:04:10	2024-02-06 15:04:10	t	t
13d12460-11a7-4d02-855a-697d31bc9d34	0307030c-8cd8-46c2-8fdb-2fc21939cf7b		\N		sharmadevvrat033@gmail.com	\N	\N	{}	2024-07-09 21:36:08	2024-07-09 21:36:08	t	t
fc677f47-30ea-4ccf-b44f-f0f1e2a9ab20	48d1c50e-0ed4-4355-8b30-37ed358badcc	오동욱	\N		neokit@naver.com	01037702370	\N	{보험,자산관리,재태크}	2023-12-04 11:08:05	2023-12-04 11:08:05	t	t
392e467c-396e-476f-8456-b58d20992fad	cfb0a68c-2135-4df7-ba69-3421c2a01173	김남수	\N	학생들의 가능성을 최대한 발휘할 수 있도록 돕는 열정적인 교사입니다. 혁신적인 교육 방법과 기술을 통해 학습 경험을 향상시키고자 합니다.	3352404730	9603029909	\N	{김남수}	2024-02-20 08:07:48	2024-02-20 08:07:48	t	t
3a7298f0-e8a3-4f9d-9eaa-3cea1f87b036	83feae83-7c02-4985-b9ad-31b4e670d18f		\N		toduyte@gmail.com	\N	\N	{}	2024-03-26 00:33:44	2024-03-26 00:33:44	t	t
c2dfe76e-2857-4824-a473-fc508d8abdfa	fd00865e-2f22-4e24-90da-b778a4b6cc1a		\N		playstorefinance70@gmail.com	\N	\N	{}	2024-09-30 02:06:40	2024-09-30 02:06:40	t	t
79586adc-9cf6-4f07-bda4-7c7675b1f906	520ad20c-3c32-4b03-8cc0-8635430639f6		\N		sawa2677sawa@gmail.com	\N	\N	{}	2024-04-14 12:34:36	2024-04-14 12:34:36	t	t
063fd172-029d-4c59-9275-e51e463508f4	e5146647-cb36-4fbd-a898-c8a13436564a		\N		3164673831	\N	\N	{}	2023-11-15 15:02:31	2023-11-15 15:02:31	t	t
13e5b7c7-8e19-44c0-8f0d-72f875a29dca	b8993ce5-8254-4051-8545-ab8b4bba3bcd		\N		3329722713	\N	\N	{}	2024-02-05 01:19:24	2024-02-05 01:19:24	t	t
946d754a-b7e7-4b02-82b6-667afca915a9	908fcac3-052f-4ef3-8ff6-4fee7cdb4234	januka Rai 7797891734	\N		raijanuka739@gmail.com	779789173477	\N	{snggal}	2024-08-13 11:32:01	2024-08-13 11:32:01	t	t
9ec848a9-94d3-49b7-bbd6-bdfeaded9e0b	e5b526bd-4554-4b99-bf91-204c2583a5fa	강명국	\N	브랜딩&마케팅 에이전시 WSR컴퍼니 강명국 입니다. 브랜딩 서비스로는 브랜드개발,BI/CI,톤앤무드,스토리, 웹사이트 구축 등이 있으며, 마케팅 서비스로는 컨설팅을 동반한 전반적인 온&오프라인 마케팅 서비스를 제공하고 있습니다 감사합니다.	wsrceo@gmail.com	01055527261	\N	{디자인,마케팅,브랜딩,홈페이지}	2024-03-15 05:08:39	2024-03-15 05:08:39	t	t
a5a6f453-9cac-4817-aa12-360223c8b96d	52f901cc-df50-47d6-9635-4f6297931f20	김기성	\N	혁신적인 기술 솔루션을 개발하는 데 열정적인 기계 엔지니어입니다. 지속 가능한 설계와 효율적인 프로세스 개선에 중점을 두고 있으며, 새로운 기술 도전을 즐깁니다.	55kksung@hanmail.net	01036523184	\N	{전기}	2024-02-19 11:14:29	2024-02-19 11:14:29	t	t
ac058a74-c5b1-4cc3-966c-5c1d2c702700	888ab27d-3dda-4ca7-a17a-d421d2855de5		\N		delacruzgun256@gmail.com	\N	\N	{}	2024-02-20 09:13:04	2024-02-20 09:13:04	t	t
e162a55b-e538-46bb-9a8f-a3a90bfaaa1c	1a613180-d253-411c-b05e-9087bb2537a2	양영복	\N	전통과 혁신을 결합한 요리로 사람들의 마음을 사로잡는 프로페셔널 셰프입니다. 맛과 건강, 미학이 조화를 이루는 요리를 추구합니다.한식디저트 제조 담꽃	damccot@naver.com	1087296825	\N	{"OEM ODM","떡 명장, 팥 전문 제조업","인사동카페, 파미에스테이션 카페",한식디저트}	2024-02-20 09:26:09	2024-02-20 09:26:09	t	t
3c6f0815-9844-455f-a89d-716015a222d2	3c871199-87bf-4ccf-9787-39a8dbdfde92	(주)애리조	\N	(주)애리조	aeryjo8822@gmail.com	\N	\N	{}	2024-02-22 05:06:24	2024-02-22 05:06:24	t	t
7df9d6bd-3f54-4139-b244-6d57ce34675f	bea16890-5a2b-4c0c-9727-1295ac8c73ba	변형식	\N	혁신적인 기술 솔루션을 개발하는 데 열정적인 기계 엔지니어입니다. 지속 가능한 설계와 효율적인 프로세스 개선에 중점을 두고 있으며, 새로운 기술 도전을 즐깁니다.	byu.5403@daum.net	01038929171	\N	{냉난방기.냉동기}	2024-02-24 21:50:22	2024-02-24 21:50:22	t	t
ca01354f-d241-457e-abb9-6787b8c32fce	0438f7d9-5b86-4cf9-bd88-d66f1b1fd35e		\N		rahulkumar9006554517@gmail.com	\N	\N	{}	2024-08-09 04:38:47	2024-08-09 04:38:47	t	t
8e491b5a-7cc1-4b68-9781-0ca85db1ab18	93e0b9ca-6160-4919-80c9-dadd33027b40		\N		3386517432	\N	\N	{}	2024-03-13 00:31:52	2024-03-13 00:31:52	t	t
25d8c81d-34ef-49cf-b312-242c5b15d82d	3695b3f8-be43-431b-b2a1-267332e11615		\N		suvrojit.gsll@gmail.com	\N	\N	{}	2024-10-06 09:46:51	2024-10-06 09:46:51	t	t
fd8b6af1-4712-4386-aba3-989f7a48c367	b24c3bc8-5bce-4606-8b3a-2f3b3a0261d1		\N		eddennapawit@gmail.com	\N	\N	{}	2024-03-26 10:00:59	2024-03-26 10:00:59	t	t
4b4059d7-110a-49a2-9cc1-26d63a509a2e	61bd4e48-a8d7-48f3-90e6-ef8279186360	Duyên	\N	Tôi là một chuyên gia tiếp thị tăng cường giá trị thương hiệu thông qua tư duy sáng tạo và chiến lược. Tôi đã tích lũy kinh nghiệm trong lĩnh vực truyền thông xã hội, tiếp thị nội dung và phân tích thị trường.	nguyenduyen3006@gmail.com	0974383526	\N	{Tâm}	2024-05-10 01:45:48	2024-05-10 01:45:48	t	t
6009e79d-af5f-4a94-a38a-b7c92458aa84	c463f8c0-0d2b-4c26-8e60-0c7abee82534	최봉결	\N		hanbtap@gmail.com	01083459855	\N	{동형암호}	2023-11-15 13:54:26	2023-11-15 13:54:26	t	t
6a8245e6-5504-418e-b730-3b92e1fd0845	c0b5a519-6803-4bbd-9a55-333e7c054589		\N		omsohw2118@gmail.com	\N	\N	{}	2024-05-13 02:16:03	2024-05-13 02:16:03	t	t
e602ac05-2740-48d0-aa4f-f24e815f68cd	b390af94-8e44-4c3f-991e-8505ff2ffc8c		\N		3328218234	\N	\N	{}	2024-02-04 00:20:23	2024-02-04 00:20:23	t	t
01fec118-25fe-45c7-be0a-e171ea692dda	f34bc6b2-5dae-46b7-b44e-ce40e9606741		\N		arvind63434@gmail.com	\N	\N	{}	2024-07-09 16:15:45	2024-07-09 16:15:45	t	t
cc48644b-3d0e-4b5b-b99a-4c37fbf92f75	2bf763d8-4198-46e7-9366-d7bce0e5ebc0	malvin mambantayao	\N		malvinmambantayao@gmail.com	09264654539	\N	{"malvin "}	2024-03-13 21:28:01	2024-03-13 21:28:01	t	t
a48e9333-4273-4c37-aede-8e45abd565af	73eb3aaa-f817-4c95-bfdf-2c4c91d1a9e4		\N		3332425120	\N	\N	{}	2024-02-06 18:57:25	2024-02-06 18:57:25	t	t
b67a60ef-9e67-4427-a379-b285ab314b68	a2205905-286c-4041-8e6d-3ab4b9db0634	조규웅	\N		3435500288	01029060007	\N	{베트남}	2024-04-13 14:16:33	2024-04-13 14:16:33	t	t
eb143c04-72da-4572-ad2f-9c9db6c7b0db	518b423a-d607-4840-b825-8beab11ad8df	이왕수	\N			1091541590	\N	{프로다오}	2024-04-22 05:47:15	2024-04-22 05:47:15	t	t
1eef8014-b2f8-461d-aff3-c567bd4a5e56	aca0f31b-c1da-441e-8568-e7c13b498797	조성직	\N	최신 IT 기술과 트렌드에 정통한 IT 전문가입니다. 클라우드 컴퓨팅, 사이버 보안, 데이터 분석 분야에서 두각을 나타내며, 디지털 혁신을 추구합니다.	sjcho7896@naver.com	1038789136	\N	{미카엘}	2024-06-28 01:36:31	2024-06-28 01:36:31	t	t
034e8764-6155-4c0d-b2ae-115285fb4c15	52ae3ad4-91ed-4f8f-870a-a981147a3698		\N		rmshrjadhav@gmail.com	\N	\N	{}	2024-08-15 02:12:58	2024-08-15 02:12:58	t	t
ff540156-d565-47f4-87cf-233492181aaa	943a1435-f58f-4f64-b981-48424a2499f0	than singh 	\N	With deep knowledge in the legal field and 15 years of practical experience, I provide clear and practical solutions to complex legal issues. I specialize in commercial law, intellectual property, and civil litigation.	thansingh95946@gmail.com	7906384996	\N	{2ddghb,dtgcb,edgy,etthuu}	2024-07-09 20:57:52	2024-07-09 20:57:52	t	t
437bf196-9c35-4a68-9742-ea2cfb8dcc5e	6ce5645e-7a52-4c0c-b263-abee0d8748da		\N		3408740603	\N	\N	{}	2024-03-26 14:09:45	2024-03-26 14:09:45	t	t
ce34171a-4635-47d6-a5b8-de4c657d2260	80dcef08-7842-4c2e-b0eb-e0f96db6d1f0		\N		3417004238	\N	\N	{}	2024-04-01 08:18:30	2024-04-01 08:18:30	t	t
66f97b4c-dd7e-4b5e-a515-e5a2d4f763f6	f571656f-ddc6-4d43-b758-72c003dc61d6		\N		3437570221	\N	\N	{}	2024-04-15 04:39:05	2024-04-15 04:39:05	t	t
1ca0da3f-ebff-4b71-9398-b0c54536983c	7945b1e3-a196-4cbb-894a-c0d6b3956697		\N		3332831080	\N	\N	{}	2024-02-07 04:31:27	2024-02-07 04:31:27	t	t
93c4ba3b-987a-480b-be5f-c79235a47785	b0d44e87-401c-4f92-b966-e7a74ca669cd		\N		manabeswarroy@gmail.com	\N	\N	{}	2024-06-16 07:21:51	2024-06-16 07:21:51	t	t
e5b45542-bf86-45e9-b169-3da20d16db82	91efd81a-0dde-4423-8f35-a287d107e07a		\N			\N	\N	{}	2024-02-13 07:23:00	2024-02-13 07:23:00	t	t
aaa494b3-7dfb-4981-bb5b-4dd2c7cbb0fc	06c58c86-ea01-4f33-9600-cf0b988e0bce		\N		3342974073	\N	\N	{}	2024-02-14 12:05:17	2024-02-14 12:05:17	t	t
770f0d08-1536-43b0-8bc4-ce19d61542d4	717ec418-16b9-457b-9eaf-376171b552c7	황선주 	\N		alskha1005@naver.com	01049657588	\N	{"제라늄 "}	2024-02-17 04:11:41	2024-02-17 04:11:41	t	t
3b466deb-a3da-45f5-b7cb-de3c5ff91367	d52e4b53-9a6d-40b4-8810-ed27f6aa166e		\N		shivyansh3116@gmail.com	\N	\N	{}	2024-07-16 09:29:51	2024-07-16 09:29:51	t	t
6aeba6e5-7106-46dc-bcd4-86e4d127c622	9085ce2c-626a-4d96-9548-1b6fd9535fdc	유승현	\N	네트워크 보안,문서 보안 전문 기업입니다	3355218547	01024955712	\N	{DRM,네트워크,문서,보안}	2024-02-21 06:10:04	2024-02-21 06:10:04	t	t
07acfc15-d03d-4d39-96db-f55128098e80	29a9a5a0-e3bb-41f0-90d0-d8c698b019f1	박영수 	\N	창의적이고 전략적인 사고를 바탕으로 브랜드의 가치를 높이는 마케팅 전문가입니다. 소셜 미디어, 콘텐츠 마케팅, 시장 분석 분야에서 경험을 쌓았습니다.	vppys7@nate.com	01024290074	\N	{교육,마케팅,비즈니스,협업}	2024-02-20 12:00:02	2024-02-20 12:00:02	t	t
61194d02-c633-4e61-a2d3-b5944a587085	6b4e15e1-8bb3-4b5d-aff1-ac3e8ea44356	김자영	\N	색소폰연주자 드럼 	Kjy2488@daum.net	37832488	\N	{드럼,액소폰}	2024-03-15 10:27:51	2024-03-15 10:27:51	t	t
31d3a65b-9805-4e3a-8cd5-96741b882503	01082e94-ab8f-4cf0-838f-f4f81fccf773	천준우9179138782	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	choonwu1958@gmail.com	9179138782	\N	{"business man"}	2024-03-22 00:06:40	2024-03-22 00:06:40	t	t
201784ca-8ae8-4ae8-9f16-4647f23bd490	83375518-3402-451b-bf72-afd825f44fe8	kimboly	\N	I am a marketing expert who enhances the value of brands through creative and strategic thinking. I have gained experience in social media, content marketing, and market analysis.	lhandsmeer_21@yahoo.com	9166486902	\N	{"allan "}	2024-04-04 12:28:52	2024-04-04 12:28:52	t	t
75d584e3-b8bf-4a3c-9715-d561ea4503ec	55343256-1601-423a-b1a4-3d467d2b64c6	고흥	\N	법률 분야에서의 깊은 지식과 오랜 실무 경험을 바탕으로, 복잡한 법적 문제에 대한 명확하고 실용적인 해결책을 제공합니다.	3321662950	01020696372	\N	{변호사}	2024-01-30 11:16:20	2024-01-30 11:16:20	t	t
3f236043-5145-412b-bcf2-6a7fb3c94592	bca8c025-d84f-4c89-b383-b46e050f6c76	박창우	\N		ckd0dn12@gmail.com	01040967820	\N	{개발,앱,코딩,플러터}	2024-01-15 06:38:05	2024-01-15 06:38:05	t	t
028e7b61-f5c8-424a-8519-ce608124c457	4f5a91b8-5ae2-4451-8595-e30b2f37474e	김수홍	\N		peace011@naver.com	01054404039	\N	{IT}	2024-02-20 04:36:55	2024-02-20 04:36:55	t	t
a0c41bc2-161f-4f38-9bae-515842e408c4	1818e14a-1df6-489d-9f75-b920e5cbaf1f		\N		biswasrabindranath034@gmail.com	\N	\N	{}	2024-07-11 17:21:24	2024-07-11 17:21:24	t	t
8994baec-7e77-4c63-80ec-469708820b28	ab199fd8-c72a-4d17-97e5-d2706748b609		\N		uttamkhati1974@gmail.com	\N	\N	{}	2024-02-17 15:14:55	2024-02-17 15:14:55	t	t
67c3e0db-b990-4e1d-ace3-4ea419fc7d15	c747109f-9e85-406a-b30d-e3aaacf6eb18		\N		emailninilo@gmail.com	\N	\N	{}	2024-02-19 12:50:55	2024-02-19 12:50:55	t	t
1be28684-2b25-4e6a-9660-b2fa26f519a7	07527f33-0d3b-41df-9fef-f9ec364f6d48	Akindunbi	\N		timsonyoung@gmail.com	9123977517	\N	{"Timson ",young}	2024-11-29 14:51:03	2024-11-29 14:51:03	t	t
f78118aa-8103-4ee4-9315-c0491ad4fbaa	5822a715-e353-4632-bb97-3108d665d860		\N		salumkesonal@gmail.com	\N	\N	{}	2024-08-12 12:47:50	2024-08-12 12:47:50	t	t
cc81bccb-db74-4bac-9045-21c9c92dd057	069ae628-63f5-4df6-8723-5dca29b4c9ee		\N		rajeshkumar97216@gmail.com	\N	\N	{}	2024-08-09 04:27:07	2024-08-09 04:27:07	t	t
53882057-7adb-4886-ada5-3719078cc140	ed31a40b-2844-4eef-8921-073c5ac6c240		\N		farakatali672@gmail.com	\N	\N	{}	2024-08-14 14:06:33	2024-08-14 14:06:33	t	t
ba45e596-59a1-4d42-b6db-e81496b0b660	b372c112-df80-497c-80af-6adc1ac7e6f4	जिंदगियां जी 	\N	मैं एक जुनूनी मैकेनिकल इंजीनियर हूं जो इनोवेटिव तकनीकी समाधान विकसित करता है। मैं सतत डिजाइन और कुशल प्रक्रिया सुधार पर ध्यान केंद्रित करता हूं, और नई तकनीकी चुनौतियों का आनंद लेता हूं।	jlal62856@gmail.com	9509625523	\N	{ठज,णध,तझ}	2024-07-29 12:27:08	2024-07-29 12:27:08	t	t
6f040bd0-ec7f-459a-9947-1d145f595625	56b1df68-77bb-46d7-a77c-a22d4ce5286f		\N		okhack2k8@gmail.com	\N	\N	{}	2024-04-05 23:01:30	2024-04-05 23:01:30	t	t
1ec35dad-d531-4389-94ab-1a2863e0dbcc	3975bbbd-b9bd-4cda-ab7c-82c6f33d0052	olubi Henry Samuel	\N	I am a passionate mechanical engineer who develops innovative technological solutions. I focus on sustainable design and efficient process improvement, and enjoy new technological challenges.	makindeyinkajumoke@gmail.com	08023404657	\N	{"Henry "}	2024-08-13 14:44:13	2024-08-13 14:44:13	t	t
1fd698a9-a104-41a5-b115-c02580ee4c62	42475f00-1325-44b4-9c9f-6dac3fb16f55		\N		roseeee2122@gmail.com	\N	\N	{}	2024-04-14 13:01:29	2024-04-14 13:01:29	t	t
60c8d02a-afb2-4591-80e6-67833b096f60	66ca42ad-580f-43b6-ba57-47dc780f6382		\N		deepfinder.ceo@gmail.com	\N	\N	{}	2023-11-14 02:34:30	2023-11-14 02:34:30	t	t
b0584a47-bd69-4fda-822f-e52b303de9ce	8a8dda28-6a27-4912-9459-cf5708f1df9f		\N		shsun27@gmail.com	\N	\N	{}	2023-11-21 14:04:01	2023-11-21 14:04:01	t	t
5395eed8-1087-4cb6-a45c-2b0fdb665e85	99627122-0c21-47bf-842f-9c3eed490f97		\N		sungadull12@gmail.com	\N	\N	{}	2023-11-16 07:34:48	2023-11-16 07:34:48	t	t
ff38ef38-866d-4a2a-bbb8-5903b4e38696	7f8c3e37-ae1a-40b2-a3b9-69d22d672845		\N		3209429160	\N	\N	{}	2023-12-04 09:28:27	2023-12-04 09:28:27	t	t
7f7a05fc-40d4-4eab-a646-4e6fb706e33e	1826c895-ee02-44f1-a11d-9261f76e75bc		\N		kodapakamm123@gmail.com	\N	\N	{}	2024-05-26 17:15:26	2024-05-26 17:15:26	t	t
584a2aa2-2873-4d28-ae68-23d29b4f59b1	5d85dfae-323f-4674-9539-21c749a8951a		\N		zualteizualtei520@gmail.com	\N	\N	{}	2024-06-27 03:39:56	2024-06-27 03:39:56	t	t
c48fa56c-2745-4d6e-b66b-934d55b20011	9f77e3a7-a1bc-4cdf-a1ca-11bc8a2e99aa		\N		3333675689	\N	\N	{}	2024-02-07 17:56:11	2024-02-07 17:56:11	t	t
a83beceb-8ec9-41ca-b77c-580aa3594711	691f6647-65e9-43fd-991c-3915b47e9fd9		\N		laxmanadhikari970@gmail.com	\N	\N	{}	2024-07-12 06:41:51	2024-07-12 06:41:51	t	t
74ade4f4-bca5-4302-a878-6ec6cdf359f7	728cd7f7-cf49-4842-ac69-6de867096162		\N		shahidabegum7812@gmail.com	\N	\N	{}	2024-07-16 17:34:58	2024-07-16 17:34:58	t	t
b94d0f0a-5253-4d4a-90cf-601ecd7fc396	0ef561c5-7784-45bb-93bf-72e11452acb9		\N		maryannrequinala18@gmail.com	\N	\N	{}	2024-03-13 00:46:25	2024-03-13 00:46:25	t	t
58b99995-0536-41e3-8c5f-93f6b3c033f8	ebde1970-98f4-4268-9ffe-010967ef454f	윤재희	\N		yun0266@naver.com	01064660266	\N	{주부}	2024-05-09 20:27:43	2024-05-09 20:27:43	t	t
80412dae-31ed-4536-b46b-0e01d7eb9430	9533dac5-4510-48db-9cb7-3ae25c3c7ad4	조영기	\N	기업 생존 전략 (시장, 관리, 재무), 베트남 진출, 	ok777ok@daum.net	1029311631	\N	{베트남,생존,재무,전략}	2024-02-20 09:25:51	2024-02-20 09:25:51	t	t
72152ae4-5d7a-4cc9-9ef2-6da23545e81b	ca843ba0-d096-4e88-90aa-af627b50077a	AppleJohn	\N			01012345678	\N	{123,test}	2024-03-06 21:20:14	2024-03-06 21:20:14	t	t
60785385-46d4-4cde-a4e7-c40b82fe412a	b370e760-5bed-4ade-8488-fe7c4c972e04	서동광	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	seven@ondelab.com	01071237722	\N	{O2O,디지털전환,플랫폼}	2024-02-26 11:28:42	2024-02-26 11:28:42	t	t
acac873e-c31b-43ef-a8d5-cc5c281257fb	45ea8462-c7ca-4dad-9132-59f623757bea		\N		luongvansu06061987@gmail.com	\N	\N	{}	2024-03-25 15:11:08	2024-03-25 15:11:08	t	t
5b273574-48ae-4394-941a-3eff224b10ec	36c36fc0-7299-445d-81df-89dee356921b		\N		3724767387	\N	\N	{}	2024-09-29 03:16:18	2024-09-29 03:16:18	t	t
0af1d024-34ae-42a2-b8ba-c14ba0e8550f	759c5d73-b9f1-47ba-b04f-0d1688fbd782	बाबूलाल मालविय	\N		babulalmalviya873@gmail.com	9752050614	\N	{कि}	2024-08-12 10:21:28	2024-08-12 10:21:28	t	t
ac3efe5b-a9a8-4749-b90d-f432074d4784	616bde55-ea5a-487b-9959-0dcd5526111d	indirarani	\N		Indira.1531965@gmail.com	6280129557	\N	{"I like it."}	2024-08-14 18:16:54	2024-08-14 18:16:54	t	t
9600346f-471a-4563-b6ea-5144109c8289	4ce4447c-d891-4274-be6c-e8245b989b5e		\N		3215079795	\N	\N	{}	2023-12-08 06:23:57	2023-12-08 06:23:57	t	t
ec8a6a78-294c-4885-80fd-d85ca4c16eab	d59ca0c1-244b-4604-893f-aeb7ebcde1e5		\N		3259483821	\N	\N	{}	2024-01-06 12:37:20	2024-01-06 12:37:20	t	t
6fd1c482-417e-4c7f-a517-30141d66c216	f344e33c-7816-40ac-94b7-840f6bbc4f76		\N		quangvinh26042014@gmail.com	\N	\N	{}	2024-02-17 04:09:52	2024-02-17 04:09:52	t	t
761f4aaf-941e-415d-bc97-d5f9b24b2733	67dd0bda-ef9b-480b-b365-024472500876		\N		3348599445	\N	\N	{}	2024-02-17 17:17:28	2024-02-17 17:17:28	t	t
10105b6e-bea2-4543-96cf-73b732c55138	07ee028a-1e71-400d-a185-39dc4299803c	최태문	\N	기업컨설팅  경영컨설팅 스마트팩토리 IT솔루션 AI구현설계 디지털트원	noniway@hanmail.net	01085858234	\N	{경영,기업교육,스마트팩토리,컨설팅}	2024-03-22 05:00:27	2024-03-22 05:00:27	t	t
48cf27e0-6a71-4702-81c5-6c336192c337	4a176e6a-66cc-4626-b167-b1a7507d637a		\N		pandankim@gmail.com	\N	\N	{}	2024-02-20 12:27:02	2024-02-20 12:27:02	t	t
a45a0136-9a8e-4ada-823b-62ee83769bd2	8ec8fcf9-6d6f-41af-a2bc-27c6e38d876b	Zen Balderama	\N	I am a creative architect focusing on modern and sustainable architectural design. I strive to realize clients dreams by combining the beauty and functionality of space.	maryprincessjoy19@gmail.com	09092290433	\N	{oke,u,"u k",y}	2024-04-14 23:42:48	2024-04-14 23:42:48	t	t
5c81e4ca-56bf-4508-82d4-7a1c4ca7ca9d	0eb99839-f4b8-4afa-b9af-045cc270429e		\N			\N	\N	{}	2024-08-05 16:14:44	2024-08-05 16:14:44	t	t
17d4c00f-b14c-4f0a-9728-5aff736a57aa	50d7763f-3b95-4adb-917f-04fdaf9d88c3	이선국	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	hanaro9123@hanmail.net	01075323456	\N	{이불,침구류}	2024-05-10 04:14:59	2024-05-10 04:14:59	t	t
e894ff9e-e069-42d4-918c-3cd46ee0d577	be316477-478d-47bb-80d4-ad05aea1d35d		\N		degenionnica@gmail.com	\N	\N	{}	2024-03-25 12:13:53	2024-03-25 12:13:53	t	t
1202c423-629a-498f-8f59-32f496d58d1f	35f8b814-edcc-4d11-9cae-df98b3db5747	sama	\N	I am an experienced internist with over 10 years in the medical field. I prioritize patients health and always stay informed about the latest medical research and treatments. I look forward to sharing knowledge for a healthy life.	samadalukkal7348@gmail.com	9995347348	\N	{samaf}	2024-07-09 22:04:45	2024-07-09 22:04:45	t	t
05ad34d2-200e-496f-a4e2-b0f321738e19	f67ed19a-19eb-4b90-a362-f73669aa84be		\N		3408616304	\N	\N	{}	2024-03-26 12:48:45	2024-03-26 12:48:45	t	t
743e5828-6b64-48b9-945f-992a58af3971	1fec0a2c-8574-4d7c-a528-ac663ae96221	Ajay Singh 	\N		as0728241@gmail.com	8127425208	\N	{1122}	2024-07-29 07:14:02	2024-07-29 07:14:02	t	t
5ba4c20b-282c-4582-937b-632d81b8f185	f636fd79-dd5d-4c59-9f96-9f72e5a64dbe		\N		kjalim621@gmail.com	\N	\N	{}	2024-11-25 13:18:52	2024-11-25 13:18:52	t	t
fe47deba-fed5-4a64-8dd3-bfcbfe3fb488	98f93901-9ae1-4fb8-919b-d9b975af2e10	Jai Shree	\N		F@hotmail.com	8279366102	\N	{a,d,t}	2024-07-30 14:00:07	2024-07-30 14:00:07	t	t
2e5a9e7b-78e1-474e-a27e-9238810969b2	6c98251c-b1f6-4af0-96f7-37b08b66a067	변재선	\N	학생들의 가능성을 최대한 발휘할 수 있도록 돕는 열정적인 교사입니다. 혁신적인 교육 방법과 기술을 통해 학습 경험을 향상시키고자 합니다.	bjs58087@hanmail.net	01094777083	\N	{강의,사이버안보,정보보호}	2024-08-29 23:53:53	2024-08-29 23:53:53	t	t
efac2204-ed9f-4bc7-a55f-4b49c7aac689	380b8ae6-1198-4205-aaee-682d865ccfd2		\N		hanhvu23563@gmail.com	\N	\N	{}	2024-04-03 11:32:18	2024-04-03 11:32:18	t	t
004b767e-0ec4-4c51-9de9-0089e78430b0	343b7204-610f-4785-ac35-e78401ed11d2		\N		eva310191@gmail.com	\N	\N	{}	2023-11-14 04:31:51	2023-11-14 04:31:51	t	t
8f6f58e1-9e4a-4afd-ac73-e75b8a0fd71d	22a19d97-f398-405a-bee6-02fdc86e87b5	Evangeline Manrique lanorias 	\N	I am an IT professional well-versed in the latest IT technologies and trends. I stand out in cloud computing, cybersecurity, and data analysis, and pursue digital innovation.	evangelinelanorias823@gmail.com	9624401884	\N	{"trusted "}	2024-04-16 14:13:04	2024-04-16 14:13:04	t	t
73fa84a0-446f-4def-8a09-7fced4cd2aa7	c2fa9a14-616c-472c-bd5a-d542361b679b		\N		p2587846@gmail.com	\N	\N	{}	2024-05-12 16:09:12	2024-05-12 16:09:12	t	t
b8e37b74-a666-4dda-b753-765e683ecdac	97839cd4-0327-4209-b3a0-09744b78c944		\N		3209119825	\N	\N	{}	2023-12-04 06:12:30	2023-12-04 06:12:30	t	t
feaa75fb-5072-4eb2-b1d4-06784c963dbd	3bce0bf7-793c-4e2f-ad9e-fe11bf085ee0		\N		manerfirozkhan@gmail.com	\N	\N	{}	2024-05-26 17:20:19	2024-05-26 17:20:19	t	t
48aa8013-1f41-4514-9933-716372680cb1	f7ae0e39-3b48-404b-9f80-15bfd98d30a6	강한기 	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	gasoga2000@naver.com	1040028994	\N	{"개인사업자 "}	2024-05-13 04:11:58	2024-05-13 04:11:58	t	t
69669dc6-3aef-46fc-91d8-7e3bcf043fad	b8ab0745-81c4-415a-9466-64c277657b1e		\N		3329891203	\N	\N	{}	2024-02-05 03:19:03	2024-02-05 03:19:03	t	t
f47e8021-d6b3-417e-8a24-12e1c5893672	fa2f92af-7995-4b05-9890-c2eb0f83a7c9		\N		mhabuba303@gmail.com	\N	\N	{}	2024-07-14 01:53:48	2024-07-14 01:53:48	t	t
8db168ec-0668-4ed1-a5be-e187a4146750	69bcf8fa-2087-44ac-8b8c-6e2c9b5909a5		\N			\N	\N	{}	2024-02-14 07:12:18	2024-02-14 07:12:18	t	t
2a9be7f9-a1de-41fe-b9ca-b26a1a834b62	9620b6f1-f75c-48e0-bf40-8283b740a9f3	(주)호성산업 	\N	(주)호성산업 	mary@hoseongind.com	\N	\N	{}	2024-03-21 05:33:28	2024-03-21 05:33:28	t	t
9ae875f2-97a8-408e-9871-bf209b601ab9	dbdb7d10-daea-429c-bd06-6b247f91451e		\N		quyenlethikim328@gmail.com	\N	\N	{}	2024-03-26 00:28:26	2024-03-26 00:28:26	t	t
6739cc67-3dd3-4d62-82f7-89e6a1ca827f	f29c6bbd-cbd3-415f-9993-3e77db34a416	Uttam Deokar	\N	I am a passionate mechanical engineer who develops innovative technological solutions. I focus on sustainable design and efficient process improvement, and enjoy new technological challenges.	uttamdeokar.ud@gmail.com	9370676722	\N	{Ar}	2024-07-09 21:26:49	2024-07-09 21:26:49	t	t
eab48a4f-668c-47e1-b351-0a2af90fe43f	9ee0077d-59a9-4c4e-b137-f8d5ff11bed5	Nimrod jancey A Manalo 	\N		gloryefria69@gmail.com	10	\N	{"1v1 "}	2024-03-13 08:20:44	2024-03-13 08:20:44	t	t
dc6c7b9c-6f4f-49eb-ad8d-1345ecbd76e4	ce38d7f1-a5bf-4dd0-a26f-d01ac5fc6f43	Hojae Yong	\N		masteryong@me.com	2132358183	\N	{"alliance ","Korea ","taekwondo ","USA "}	2024-11-16 18:11:15	2024-11-16 18:11:15	t	t
42a34954-e4bf-41bb-9c60-b7a1ee4aed49	9db4313a-2911-4a85-9a43-416ea622bef9		\N		duyhaozingn9@gmail.com	\N	\N	{}	2024-04-14 15:15:23	2024-04-14 15:15:23	t	t
7fd5a635-7d15-49e2-933c-a2fdb4d2cd60	f483085f-ac29-4f81-b3b8-d89300345448	임성수	\N		thegad2003@gmail.com	01073214135	\N	{luen}	2024-04-26 07:00:01	2024-04-26 07:00:01	t	t
6c06ed7f-01b6-4667-b799-456cbedd713e	aa78814f-f5de-4ba0-bbf6-99aa29fb63dc		\N		reyfederio0511@gmail.com	\N	\N	{}	2024-04-14 21:25:31	2024-04-14 21:25:31	t	t
282d0ed7-8d13-4379-b923-579de29266c2	740b6735-ea83-49a6-8f31-cf332979afec	Manish kumar 	\N		sumankumar86230@gmail.com	7307357403	\N	{"Manish kumar "}	2024-07-09 20:53:47	2024-07-09 20:53:47	t	t
596eac46-272a-40c4-8bbe-4b65b3d3957f	da338792-0065-494a-960b-662d367ec669	조윤호 	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	joyoon8@gmail.com	01087709915	\N	{aeryjo}	2024-02-20 09:27:31	2024-02-20 09:27:31	t	t
d73f92bd-810a-489f-9d51-b3504599f33d	07c7285d-8b28-4925-8e73-e8bc866d0d85	조성호	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	shcho9770@naver.com	01037289770	\N	{사람}	2024-03-14 01:18:24	2024-03-14 01:18:24	t	t
f0428c32-6c6d-440c-8b21-fe7a75602528	b05aecdd-2bd8-4678-9781-954be6179012		\N		3306564510	\N	\N	{}	2024-01-29 01:29:48	2024-01-29 01:29:48	t	t
0b55756b-4c6a-4dd6-9c22-91901b999445	86304602-3f40-481d-9a36-9a61a6289bf6	박분희	\N		3404002866	01097828082	\N	{직장인}	2024-03-23 13:06:56	2024-03-23 13:06:56	t	t
104176d2-3d36-41cf-bee9-cbfed9bade28	3dc254ea-f533-4375-a717-3b6aba7771e8		\N		mnojk4842@gmail.com	\N	\N	{}	2024-07-09 08:44:31	2024-07-09 08:44:31	t	t
5ff116e8-7826-4de1-8f48-9f45ed910e7f	40e2c1e5-3242-4b84-822d-0ec95bd3345c		\N		naresh11115455@gmail.com	\N	\N	{}	2024-07-16 00:21:58	2024-07-16 00:21:58	t	t
fd41df69-650e-4568-a3e2-88d6a93140cc	98258a4d-b15d-45a5-b565-5d3f22b98f4a		\N		jatashankartiwari56@gmail.com	\N	\N	{}	2024-07-14 17:24:12	2024-07-14 17:24:12	t	t
5b3d8e8f-4c1a-490e-8835-9bab75da95f3	87c92b14-a027-4ba2-9699-76e2096ec9ae		\N		3352775866	\N	\N	{}	2024-02-20 12:27:07	2024-02-20 12:27:07	t	t
f161fbdf-2c89-4a2c-bae1-faac39a93a7e	7d87e1d3-b8e2-4e65-99a5-4e77c667bfc4	안현주	\N	업무대행 아옷소싱, 홍보대행,  교육컨설팅을 대행하는 사업가입니다. 세미나, 워크샵, 전시 대행등 기획 진행 업무 총괄댜행과 강사, MC, 의전요원, 공연팀 파견도 가능합니다. 	hyunjuan70@kakao.com	47080319	\N	{"강사파견 교육컨설팅","시상식 대행","워크샵 컨설팅","홍보대행 "}	2024-03-26 22:30:55	2024-03-26 22:30:55	t	t
a99b0a35-9598-4b97-8300-eb7a7cbd3b7a	791a7f26-d8a6-4a22-a414-8e2311a773d3		\N		balatindrachandra@gmail.com	\N	\N	{}	2024-07-15 00:42:55	2024-07-15 00:42:55	t	t
b7306ca1-9d43-48a7-abcd-eed556e262fc	b710859f-6403-4825-bc9a-3f125caeccb6		\N		3386434123	\N	\N	{}	2024-03-12 23:04:37	2024-03-12 23:04:37	t	t
2fa17eaf-4223-4794-ad6a-2ae0eca37047	149c6610-9ba7-49ed-9b4f-5b87eb855e09	김대유	\N	안녕하세요. 남서울대학교 컴퓨터소프트웨어학과 김대유교수입니다.	dy.kim@nsu.ac.kr	1075675457	\N	{남서울대학교}	2024-09-29 03:16:32	2024-09-29 03:16:32	t	t
a9211f44-a796-45ce-a6d4-f96b65908117	51f4d1e7-77e1-44b3-b508-2e2513bd3ce0	thientrieuminh	\N		thientrieuminh66@gmail.com	037399622	\N	{"thông "}	2024-04-02 11:11:59	2024-04-02 11:11:59	t	t
afd3d9c5-8fad-497f-8bdf-8577704207a7	6533729f-c065-45df-a881-072c03bcff47	할랄코리아 주	\N	할랄코리아 주	halalkim@gmail.com	\N	\N	{}	2024-10-19 09:48:11	2024-10-19 09:48:11	t	t
fb599b72-6300-4fe5-a5e6-55452f6bf535	109a4ba1-3456-4dcc-bc80-8f2bdd904da1	(주)야나트립	\N	(주)야나트립	service@yanatrip.com	\N	\N	{}	2024-03-29 11:23:26	2024-03-29 11:23:26	t	t
32c61ad3-11f1-4238-b517-14dbd07603ce	94048e23-da65-4836-9be6-c127824300c4	거성부동산 	\N	거성부동산 	umiwon@nate.com	\N	\N	{}	2024-03-29 11:42:04	2024-03-29 11:42:04	t	t
7b92ad18-a6b8-4b87-8cad-6d4eeef040bd	9511cd07-4d74-4a65-b1bd-bf9b55dcb0ba	chapper	\N	I am an IT professional well-versed in the latest IT technologies and trends. I stand out in cloud computing, cybersecurity, and data analysis, and pursue digital innovation.	chapperezekiel@gmail.com	9163722105	\N	{jamper30,jamper31,jamper32,jamper33}	2024-04-13 13:19:20	2024-04-13 13:19:20	t	t
0940e755-c2e7-4e79-8b32-2d8179e57ee6	ad927edf-b643-49c7-bb35-ce93c40e25f9		\N		3165338499	\N	\N	{}	2023-11-16 04:57:19	2023-11-16 04:57:19	t	t
7745c9d1-fcb0-423d-aac6-92e74b5b6dfb	952b31f8-45a1-4ae1-833c-ec1686448510	고건영	\N		rhdudtnr721@naver.com	1029206288	\N	{클래식}	2024-02-04 23:23:35	2024-02-04 23:23:35	t	t
d4d46f0a-640c-49fd-afa4-8eaec1069b0f	0e2608ff-48d6-4d63-b998-d4e92ade87dd		\N		3330974479	\N	\N	{}	2024-02-05 17:08:45	2024-02-05 17:08:45	t	t
30815115-8722-4f05-b76b-1aa7872d7e9e	27e50322-ae9c-4a99-8f7f-91a3c4401c25		\N		dalveersingh11143@gmail.com	\N	\N	{}	2024-07-09 15:45:09	2024-07-09 15:45:09	t	t
5e17d6d7-41de-480b-bcdb-e50fad311337	5a4baf14-568d-4ec9-ac7e-2f901337f970		\N		nguyenvannguyenvanquynh5@gmail.com	\N	\N	{}	2024-02-17 15:13:39	2024-02-17 15:13:39	t	t
a4d2ee9f-b54f-4f44-9dbe-89733d0623d1	d1269d1c-5e2b-4784-9745-eed1cd1f41ea		\N		3347367261	\N	\N	{}	2024-02-17 00:50:56	2024-02-17 00:50:56	t	t
681197a0-d81c-4ede-ae32-5627b99ab69c	e3c47f80-79e9-4480-80c0-ab6c6238b264		\N		dennisborongpascual1975@gmail.com	\N	\N	{}	2024-02-19 11:35:44	2024-02-19 11:35:44	t	t
e29a6843-116d-4037-8b77-b4b0e8c06022	7f5dc557-d70c-48b7-b510-b3dce4f306a6		\N		pk7674606@gmail.com	\N	\N	{}	2024-07-14 02:57:49	2024-07-14 02:57:49	t	t
40fdc351-f751-4dd0-9c58-73f6b289973c	82a7f6aa-3305-48fb-8b85-430710381179	Benjamin isaga	\N		benjaminisaga12@gmail.com	09457220387	\N	{"B I","B I P",BDIP}	2024-02-20 13:10:03	2024-02-20 13:10:03	t	t
28991a6b-91b1-4bec-ac73-bfaf844c5686	918fa26e-6980-4868-9323-cb956fbf48c9		\N		ramajamre23@gmail.com	\N	\N	{}	2024-06-30 10:28:25	2024-06-30 10:28:25	t	t
894af9d7-e577-409b-a7b8-4a34993be21f	3a9bc5f0-a584-4335-85d5-0e78b73f6c94	lưu 	\N	Tôi là một nhà khoa học thực hiện nghiên cứu đổi mới dựa trên sự tò mò sâu sắc về thế giới. Tôi đã có những phát hiện quan trọng trong lĩnh vực khoa học sự sống và khoa học môi trường.	luu30750@gmail.com	0814811617	\N	{l,u}	2024-07-27 15:57:43	2024-07-27 15:57:43	t	t
7ad6e57f-1c4a-4a76-ada1-9e2b48f89913	77d688de-9a29-4e5f-a453-9479a9fd7f8d	박채성	\N	언론 잡지 홍보 물류	good@cargopress.co.kr	01029424176	\N	{국제물류,홍보}	2024-02-21 06:11:03	2024-02-21 06:11:03	t	t
f82d8d48-0ca6-46ef-9286-3d6805d14f2f	a938faa5-db9f-477d-9b51-211ffc7b4f5a	shishram 	\N	I am an experienced internist with over 10 years in the medical field. I prioritize patients health and always stay informed about the latest medical research and treatments. I look forward to sharing knowledge for a healthy life.	shishramrathore2@gmail.com	8423137486	\N	{c,d,f,h}	2024-06-07 06:49:37	2024-06-07 06:49:37	t	t
93577cac-76cb-4305-a85f-8d438bd28488	031dd7a3-c7ca-4427-b32d-ed85c18dad9d		\N		marvindepina0@gmail.com	\N	\N	{}	2024-03-14 03:01:17	2024-03-14 03:01:17	t	t
1b5be039-fbd6-41e1-a290-1c0bdcffbdbf	a4b4f9c4-eebf-4d1a-b388-44fba74fceb4		\N		rodeliovillacero@gmail.com	\N	\N	{}	2024-03-14 06:08:47	2024-03-14 06:08:47	t	t
d1a16180-a76e-4b32-b394-b8e128d7d2ad	b558d227-6709-4505-8753-991479735966	류원호 	\N	학생들의 가능성을 최대한 발휘할 수 있도록 돕는 열정적인 교사입니다. 혁신적인 교육 방법과 기술을 통해 학습 경험을 향상시키고자 합니다.	ywh6075@hanmail.net	36682669	\N	{"정보보호 "}	2024-06-27 08:20:36	2024-06-27 08:20:36	t	t
61e3051d-f0f9-4f7f-94f5-15f5e85dfe75	5f784385-e38c-4019-bdf8-cfca878eef0f	samar adhya	\N		samaradhya54@gmail.com	9436120811	\N	{4,5}	2024-07-13 16:58:18	2024-07-13 16:58:18	t	t
36132b59-9509-40d1-9290-3de12ca818c6	8d1150b1-2214-403e-8591-1f8cd4a88ce8	anu naskar 	\N	I am a marketing expert who enhances the value of brands through creative and strategic thinking. I have gained experience in social media, content marketing, and market analysis.	anunasksr201@gmail.com	9831025185	\N	{ok}	2024-07-15 03:37:07	2024-07-15 03:37:07	t	t
d6d6e09c-c980-4abf-a093-434b02a2a9ca	39e2db19-b3b0-459a-869c-7a9fcc8e2b0d		\N		xialourine19@gmail.com	\N	\N	{}	2024-04-02 05:41:57	2024-04-02 05:41:57	t	t
5df4cd6c-bfc9-4274-b30e-077b2d8b9909	8f57a9b6-7314-4547-8b92-4ab2ada57fff		\N		opanzo59@gmail.com	\N	\N	{}	2024-03-28 04:38:15	2024-03-28 04:38:15	t	t
500d2e1f-9722-4b06-966b-c8b3dda05fc0	80df838d-a19c-4611-a85e-3f5406c5eb18		\N		nguyenhuuhieu190188@gmail.com	\N	\N	{}	2024-04-14 16:33:21	2024-04-14 16:33:21	t	t
9930f838-c4bd-47c4-aaa1-d169cadb52c3	48ee080c-fb26-4227-b492-e35396ccab2b	김미	\N			0123123123	\N	{test}	2024-02-14 07:09:45	2024-02-14 07:09:45	t	t
1c08e7db-0f12-45b0-906d-a31aba4d56de	e489a5af-6a15-467b-97e8-f144421961bc	차도혁	\N	현대적이고 지속 가능한 건축 디자인에 중점을 두는 창의적인 건축가입니다. 공간의 아름다움과 기능성을 결합하여 고객의 꿈을 실현시키고자 합니다.	cdh7502@naver.com	01073716430	\N	{"꼼꼼한 인테리어","만족한 인테리어","책임감있는 인테리어","추천받는 인테리어"}	2024-04-16 10:26:53	2024-04-16 10:26:53	t	t
fd391959-29d8-4026-9d7a-46612690a11d	62d12e53-6e0a-4b0b-bfe1-0ea7f359b356	김미순	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	misoonangel@hanmail.net	01094599715	\N	{제주천사맘}	2024-05-16 00:29:53	2024-05-16 00:29:53	t	t
96505a97-893a-455e-99a2-18452afc8bf7	976a45f1-5861-4b49-9931-c99f6030cd49	hffhhj	\N		tommymohammed9191@gmail.com	914571	\N	{1320}	2024-08-07 23:23:48	2024-08-07 23:23:48	t	t
859cef87-9741-490c-9e0d-ad15b2ed0869	17a01594-43f0-4036-adf7-629a37190762	최정식	\N		3386348290	01065654020	\N	{choiviet}	2024-03-12 18:05:40	2024-03-12 18:05:40	t	t
74c87e39-8415-46b8-9910-405a66023da9	28058267-5877-4bc2-a880-395176bd6b22	이기순	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/ddeba9ad-9598-466d-86d3-b6cee073d922.jpg	자연과함께하는 \n일박이일카라반파크	caravan123@naver.com	48061031	\N	{국내여행,글램핑,카라반,캠핑}	2023-11-23 08:15:32	2023-11-23 08:15:32	t	t
7ba4e370-952b-40a1-90b0-1d739d71a6a0	6e81c472-ec39-4fe1-a89d-6c9118e85c29		\N		khanshapeek3@gmail.com	\N	\N	{}	2024-06-12 05:17:20	2024-06-12 05:17:20	t	t
8f088d73-0dea-4544-8a12-403c2c813667	deac7b24-f15d-43e1-bd46-538dcef50ba9		\N		sushilkumargond9@gmail.com	\N	\N	{}	2024-07-09 08:23:43	2024-07-09 08:23:43	t	t
69e9bb4d-d07e-4fb8-a1f1-febd85cf2a58	347835cc-2cb7-4709-92db-a9b53826369c		\N		ydilipsingh1976@gmail.com	\N	\N	{}	2024-07-11 20:36:03	2024-07-11 20:36:03	t	t
a6a87050-743f-49a9-8906-f57280e3c41f	fa8846c4-970d-4a13-a162-d2c843bea408		\N		deepaksandesh2004@gmail.com	\N	\N	{}	2024-07-12 18:45:16	2024-07-12 18:45:16	t	t
8af91f9d-f5fc-4d0e-8560-0f6c489d9ceb	44a34830-90ab-46f2-ab8d-5a78f3bf5601		\N		maravibhavani570@gmail.com	\N	\N	{}	2024-07-16 00:29:06	2024-07-16 00:29:06	t	t
d0ede875-aa88-48d3-bc32-63ee61b1a02a	6d8fbce9-72cd-46ca-bc0f-a796585e9070		\N		tp051283@gmail.com	\N	\N	{}	2024-02-20 13:33:53	2024-02-20 13:33:53	t	t
ed9239d3-3705-469b-ade9-ac4467e87155	8e65ed71-f8c4-4607-af41-48e60a5105ba		\N		dkyoon00@gmail.com	\N	\N	{}	2024-08-08 07:46:35	2024-08-08 07:46:35	t	t
ec3d7b51-9f45-49c3-8367-736424946ee1	fcf287b3-077c-40fd-8f4f-50ddf266fd4a	한서정		학생들의 가능성을 최대한 발휘할 수 있도록 돕는 열정적인 교사입니다. 혁신적인 교육 방법과 기술을 통해 학습 경험을 향상시키고자 합니다.	sjhv98@gmail.com	600867104	\N	{스페인어}	2024-10-03 07:45:10	2024-10-03 07:45:10	t	t
707366cc-310d-490d-9fcd-02ada1a1631b	c1fbb481-dd2c-4585-9b7c-06d180d77d2d	이주혁	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/bed0ef9f-4b55-4c81-96e2-015cf5c2b99f.jpg	대중문화의 아이콘으로서, 연기와 음악 분야에서 다방면으로 활동하며 팬들의 사랑을 받고 있는 연예인입니다. 새로운 도전을 두려워하지 않으며, 예술을 통해 사람들에게 긍정적인 영향을 끼치기 위해 노력합니다.	nuguservice123@gmail.com	15703590,*	\N	{ent,가수,배우,연예인}	2024-03-29 01:13:38	2024-03-29 01:13:38	t	t
bf3c4c5e-efbf-4770-9266-cc786ed2f3cd	4ce1780a-4d4a-4e34-889b-650f4686daef		\N		islamsohidul30495@gmail.com	\N	\N	{}	2024-08-24 17:22:08	2024-08-24 17:22:08	t	t
53469b98-7ebd-4d45-b26a-f922c472dbdd	c7f888ba-e078-44b7-8c3e-963834cb91df		\N		zhenratolentino656@gmail.com	\N	\N	{}	2024-04-03 21:51:46	2024-04-03 21:51:46	t	t
f49db5bb-eda2-4a38-9a25-91ac671f4751	454adf69-97d6-4f23-86b9-c94be1405768		\N		phucthuhong1410@gmail.com	\N	\N	{}	2024-04-15 17:30:34	2024-04-15 17:30:34	t	t
9aadc945-10ea-4b76-8d85-224d67c5daea	2c7d8641-3658-4ad8-b61d-590c1ccb544a		\N		onyook123@gmail.com	\N	\N	{}	2024-05-08 15:21:37	2024-05-08 15:21:37	t	t
db9fb26f-7bea-4d57-b2a9-8c75e444431c	411ed816-4703-4a0c-ac7a-a18715165349		\N		avadheshkumarpanditji21@gmail.com	\N	\N	{}	2024-07-12 05:29:32	2024-07-12 05:29:32	t	t
78580ed8-9659-44f0-b451-6ec96dbd2ae6	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	이범재	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/6606dc63-ea84-4ff4-bcab-d30057bb03bf.jpg	교수,마케팅 전문가,대한민국 과학기술기업인총연합회 회장,기업대표	wtbjlee5@hanmail.net	1022796350	\N	{ROTC,경영컨설팅,마케팅,의료.바이오}	2024-01-09 05:09:41	2024-01-09 05:09:41	t	t
f0aa6d74-5731-4ea2-8a7f-9c4e0b67c836	56823086-7980-41e1-97c8-c3fc5b3202ad		\N		hadeesali8466786479@gmail.com	\N	\N	{}	2024-07-11 17:15:23	2024-07-11 17:15:23	t	t
bf7a19d6-a14b-4a87-9021-82312ef61375	f7cf4dc8-05a8-473d-8530-9d085e7e69f7		\N		gyanendraprakash438449@gmail.com	\N	\N	{}	2024-07-28 09:52:49	2024-07-28 09:52:49	t	t
50b2eb23-fc82-4252-ba9b-09609ed2e0d8	fba57e05-190d-4d7b-a02b-86e985def82c		\N		shuklasatendra515@gmail.com	\N	\N	{}	2024-08-15 07:12:44	2024-08-15 07:12:44	t	t
f4473c93-f8a0-4705-8c76-687e3bfe3dfb	7887fb5a-1d5a-4690-acfa-ed25f6058297		\N		trieuvantuanladuong@gmail.com	\N	\N	{}	2024-03-25 22:20:24	2024-03-25 22:20:24	t	t
5bef466e-ac50-497b-993a-21ed2c71de29	c860a1d9-7e60-4953-8d51-855e59dd9bca		\N		ltttuyet1956@gmail.com	\N	\N	{}	2024-04-02 07:02:13	2024-04-02 07:02:13	t	t
ac4a8426-e42a-4738-ad2c-04e5a179e33e	e23735cf-2421-4dcc-bd8f-46ac18fe5a49		\N		3435606856	\N	\N	{}	2024-04-13 16:24:43	2024-04-13 16:24:43	t	t
8006cc44-ae4f-43d9-bfeb-f6dad84f6589	5fb9c23d-5236-4675-8c9b-537ea30e248f	장은경	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/d41ca479-3137-4a95-9ce7-fb9599f94bf9.jpg	법인설립 및 관리	manishma@hanmail.net	01030212938	\N	{법인설립,생명존중강의,어려운청소년꿈지원,"장학재단 관리"}	2024-03-23 23:16:08	2024-03-23 23:16:08	t	t
9ca8a11f-f4ba-42a1-b884-01bfa0412d84	4d9532f1-02e5-41a6-b85c-46611bfb5161		\N		vseetharam.1953@gmail.com	\N	\N	{}	2024-05-15 10:12:33	2024-05-15 10:12:33	t	t
444576f0-8a33-44c7-9dce-3a9a3f186d78	3624c599-29c8-42d7-948e-2190de565b4a		\N		tranquang20066@gmail.com	\N	\N	{}	2024-05-10 05:07:25	2024-05-10 05:07:25	t	t
23ddc472-163b-48a1-869a-cb4a6082891f	c73ee408-0103-407a-81fb-5ed57db9069f		\N		barmaupen@gmail.com	\N	\N	{}	2024-06-03 15:41:13	2024-06-03 15:41:13	t	t
334b39d4-0a8c-401f-ab11-b727b0a8889a	efd0d314-965b-4406-a44a-0b7d1526ce1c		\N		bhupenhaldar4@gmail.com	\N	\N	{}	2024-07-09 09:06:16	2024-07-09 09:06:16	t	t
89f73bb5-203f-401d-a047-de40d802920e	c662510d-a483-4da8-b9c4-96f2bb450a40	돋움 강승범	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/fb8c9552-8fb7-4cf2-8746-7f747e04629b.jpg		winbumk@hanmail.net	01038346209	\N	{LX,샷시,인테리어,창호}	2024-01-25 07:19:23	2024-01-25 07:19:23	t	t
edc81e9a-f115-46e0-9c2c-7248ee4fe0d1	5c9931fa-1971-4347-a080-d97608cb2eb2		\N		ganpatsingh3478@gmail.com	\N	\N	{}	2024-07-12 01:19:04	2024-07-12 01:19:04	t	t
2f697331-a41c-4a3f-9a94-39730f22b701	99f06db1-4600-48c4-a87a-adc90ae08317		\N		harvinderchauhan51956@gmail.com	\N	\N	{}	2024-07-15 01:56:34	2024-07-15 01:56:34	t	t
f52039f3-6148-4660-90aa-0dd1d59ff011	407ae14a-060d-4d91-89d1-39535ab93b0a	CLIFF LEE2138001169	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/0b23a9b1-ef99-44e6-afd0-9ccfb64f6b52.jpg	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	point5311@gmail.com	2138001169	\N	{golf}	2024-10-14 21:48:37	2024-10-14 21:48:37	t	t
fad8fa70-0fe5-4254-acf9-e42368e7f0f9	c3e729df-b864-488f-950e-b828d01ab4e0	윤종석	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/7f1f7ecd-4188-442e-937e-4cbb4f9c34b6.jpg		dadasafer@naver.com	01040327780	\N	{"발키리 ",소형가전,"컴퓨터 주변기기",필립스}	2024-03-26 02:53:19	2024-03-26 02:53:19	t	t
2a24d023-e06b-4037-a45a-8a3bbf03b290	c5e234dd-25c0-434f-8071-3aa09c2bc10d		\N		3363593445	\N	\N	{}	2024-02-26 23:04:43	2024-02-26 23:04:43	t	t
0415ecc7-e94b-462c-ae30-2da171c038ae	e2a40848-b8d9-46bd-89aa-1ca155f8ff46		\N		sajidansaritzf102@gmail.com	\N	\N	{}	2024-08-14 15:39:14	2024-08-14 15:39:14	t	t
ed530ab3-90be-41cd-a0fd-689742328b13	c2d8d0d1-43dc-4d39-9170-071ff5bf0cb2	신현석	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/40772ba1-0234-4545-bb07-d07e12d9f94e.jpg	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	shinhs151028@naver.com	01052831249	\N	{"건설부문일반토목,건축토목",기초파일공사,천공항타항발기임대,트리콘비트무진동천공}	2024-02-21 06:42:58	2024-02-21 06:42:58	t	t
4f211787-d587-487a-8c4e-2b78b1cc7abb	bba7012e-a97a-49d1-b280-3f0a1fff916f		\N		3408751279	\N	\N	{}	2024-03-26 14:18:10	2024-03-26 14:18:10	t	t
a74e9334-5d1b-48fa-af9f-783fada1378f	bd8c4a2c-6821-4d4e-b12e-466309ad9dad	명지플라워 	\N	명지플라워 	lily-404@nate.com	\N	\N	{}	2024-03-29 11:31:10	2024-03-29 11:31:10	t	t
b534bb10-51d1-4daf-9409-70694626338f	12bd66e9-f9cd-4499-9fc0-41f25cb8b8c4	창의과학융합연구소 	\N	창의과학융합연구소 	rebio@naver.com	\N	\N	{}	2024-12-28 06:30:52	2024-12-28 06:30:52	t	t
f5d10d95-01aa-42b7-9fda-74f1ac08856d	c0da8057-0c8e-42c7-99b2-14fbb9d38d6d		\N		goswamitorangiri@gmail.com	\N	\N	{}	2024-05-29 12:15:40	2024-05-29 12:15:40	t	t
39814834-2beb-4c89-bf23-81bbd8c896f8	704a1e06-b82b-4cbc-88ca-e3214eb21b7e		\N		nkamat974@gmail.com	\N	\N	{}	2024-07-10 12:08:29	2024-07-10 12:08:29	t	t
1df11f7a-4c97-45ce-9d64-d464e4ff87df	5f064136-3e90-496a-a1ff-12e2e7f79d01		\N		3346619889	\N	\N	{}	2024-02-16 09:11:01	2024-02-16 09:11:01	t	t
5053fa62-7c61-466d-a741-bdd6ff29eb02	b890b8ab-aebf-49db-914d-cc1b2d367c6b		\N		kanhaiyalalmeena782@gmail.com	\N	\N	{}	2024-07-15 15:21:07	2024-07-15 15:21:07	t	t
13662bd3-a51d-4a03-97f6-c7285a0f9bb6	c5fb4a52-8afc-4111-81fc-ae6ad78a4dee		\N		nonzucac@gmail.com	\N	\N	{}	2024-03-12 16:02:22	2024-03-12 16:02:22	t	t
23234488-e53e-437e-ba41-1ee0a52aab1e	31269e10-de77-4387-80a6-ec0f0730eb85		\N		3408458563	\N	\N	{}	2024-03-26 11:10:56	2024-03-26 11:10:56	t	t
11c6fa20-b932-416c-ad6e-ecae8b098730	dc41b55f-a5ff-46a6-b2ca-8222e205c8fe		\N		mavanluongtn@gmail.com	\N	\N	{}	2024-04-14 20:26:54	2024-04-14 20:26:54	t	t
d95d8c39-71c5-4761-9380-97c8f8c50265	8ba6efe3-26f4-46a2-ad35-ac3b5e33efae		\N		3171078737	\N	\N	{}	2023-11-20 00:26:55	2023-11-20 00:26:55	t	t
f2a9d334-8401-4b31-8bd7-c7f86357148b	c5df2d20-188e-4fa5-af91-95c1d762bf6f		\N		tingutingu945@gmail.com	\N	\N	{}	2024-06-02 05:00:22	2024-06-02 05:00:22	t	t
bb3afbbf-eda1-4ff2-8898-285d22a62e37	248e7e00-611c-412c-87ab-65f5dbe6aa25		\N		miyashahjad8@gmail.com	\N	\N	{}	2024-07-09 19:41:30	2024-07-09 19:41:30	t	t
61de3bfd-33df-4a6a-8664-ec73b1697b5c	f56907f8-a7fe-4cb2-baac-2c0b91291fb0		\N		deshrasingh90@gmail.com	\N	\N	{}	2024-07-09 08:43:06	2024-07-09 08:43:06	t	t
d9776b2a-b9ba-4423-810c-c76a928b8b55	82cbf27e-c81c-4d10-ac41-3f472a4fcdeb		\N		rupalitalreja76@gmail.com	\N	\N	{}	2024-07-16 03:22:51	2024-07-16 03:22:51	t	t
b53dc35e-02b4-4e27-8a8a-e5fda1ebfaed	204d395b-19aa-483d-ace2-1fe096cf0c7a	YongGi Kim	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/44c50614-efe6-4fec-a41c-e913a9e33f31.jpg	My role is to support Korean, Israeli, Japanese, Chinese, and Singaporean companies in expanding their businesses globally, as well as assisting foreign companies in entering these markets and promoting their business	yonggik@gmail.com	01087042530	\N	{"consulting ","finance ","global marketing ","investment "}	2023-11-25 09:58:10	2023-11-25 09:58:10	t	t
b7e2beeb-c2b7-458a-bf79-b35c52eb5ca5	cf1e383e-42f9-4548-a737-ffa464a2a1e4	이용삼	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/f7dac9f7-931a-460e-98df-733785b2e705.jpg		lysbusan@hanmail.net	01047758999	\N	{ESG,ISO,스마트공방,스마트공장}	2023-12-18 09:54:46	2023-12-18 09:54:46	t	t
508c6ea6-8148-4a0b-af4c-c867536247e7	957a5d6a-ec47-45b9-a047-7316dc47ef3f		\N		paulparksca@gmail.com	\N	\N	{}	2024-12-29 04:43:10	2024-12-29 04:43:10	t	t
ff114a5f-78eb-4bf1-b5f9-767b88d9b11e	33069dfb-50d4-4123-832f-781d406ab98e		\N		zeyzeyperez@gmail.com	\N	\N	{}	2024-04-01 04:58:53	2024-04-01 04:58:53	t	t
9bd1fea1-5f69-42e3-8343-7e4c648ac78d	45aa8b28-c678-4e4a-9352-27ab690df852	오현희	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/1e3ca1a9-7d9f-4146-aa2a-7f3a2716b485.jpg	법률 분야에서의 깊은 지식과 15년의 실무 경험을 바탕으로, 복잡한 법적 문제에 대한 명확하고 실용적인 해결책을 제공합니다. 기업자문, 부동산, 민사소송에 특화되어 있습니다.	miro1023@hanmail.net	01088667537	\N	{"법무법인 (유한)민",변호사,부동산,지역주택조합}	2024-02-20 09:25:57	2024-02-20 09:25:57	t	t
e936e2d8-76d6-4a87-885a-20de92e4fb60	437a268e-e28e-4d15-b50f-3190fff9acaf	김문주	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/54e99823-0122-4a91-902c-bcfbf6c46aa8.jpg	정확하고 신뢰할 수 있는 재무 관리를 제공하는 경험 많은 회계사입니다. 재무 분석, 세무 계획, 감사 등 다양한 회계 분야에서 전문성을 보유하고 있습니다.	mooon61@naver.com	01075066319	\N	{공인중개사,렌탈,부동산,지식산업센터}	2024-02-20 04:22:27	2024-02-20 04:22:27	t	t
8cb8f02c-a285-4e7e-9206-00ba9007370b	5b316a00-25b2-4fd7-8796-5dbb7f51f948	강길주	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/aa08fd94-33f6-4f64-b9d5-1db6f25b9e42.jpg		gjkang@kgsecurity.co.kr	01043428742	\N	{강길주,보안,인증,전자지갑}	2023-12-26 03:53:10	2023-12-26 03:53:10	t	t
7ca5e2e5-8295-42f7-aafa-f600ce1390a9	0e821cb6-49da-4347-84c9-327ea930cf79	표준엔지니어링 	\N	표준엔지니어링 	seseo@stdeng.com	\N	\N	{}	2024-01-04 03:11:35	2024-01-04 03:11:35	t	t
20f9ab49-c95b-4f5c-bcf3-2a4e0aa68402	378c8be0-0116-432e-b9b0-a16f0885b638		\N		b01071112356@gmail.com	\N	\N	{}	2024-02-06 15:03:43	2024-02-06 15:03:43	t	t
ae45e929-46f2-46d1-b195-4a1b462baacd	f2478ee5-cf2e-4ec2-b312-24aaee25c6b5	khang	\N	Tôi là một bác sĩ nội trú giàu kinh nghiệm với hơn 10 năm trong lĩnh vực y tế. Tôi ưu tiên sức khỏe của bệnh nhân và luôn cập nhật các nghiên cứu và điều trị y khoa mới nhất. Tôi mong chờ được chia sẻ kiến thức cho một cuộc sống khỏe mạnh.	vikhang965@gmail.com	84	\N	{ccucuud,tcududuuuu,tuuuu,tyyuu}	2024-03-14 13:27:51	2024-03-14 13:27:51	t	t
aaf2fae5-c767-476f-8ca3-072e2894f813	6a50df75-f142-4980-8192-b6c512143c86		\N		jimboyceno319@gmail.com	\N	\N	{}	2024-02-19 15:53:55	2024-02-19 15:53:55	t	t
1f6861b0-0af2-4e95-b7da-4c4bd6e7e972	47e2ce69-9af9-4b6a-8c32-c1ef3bb659e1	박준형	\N	원목 제품(가구 및 소품 등)을 제조 하고 판매합니다. 온 오프라인 판매 및 가구 구독 플랫폼을 운영하고있습니다.	kahn201130@gmail.com	01067870063	\N	{가구,목공,캠핑용품,플랫폼}	2024-03-14 09:06:30	2024-03-14 09:06:30	t	t
e0abbc17-3f7f-4177-b3cd-4e68ad59c9e9	d15bfb61-8af0-49af-af82-24696cd922a9	최상봉	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/81290e70-90c3-4152-a637-7e067f03a6da.jpg	1.더불어 민주당 한반도 평화경제 특위 부위원장\n2.고양시 민생경제 연구소 대표\n3.중소업체 경영 컨설턴트	sungadull2@gmail..com	01023176753	\N	{고양시,민생,민주당,평화경제}	2023-12-22 03:51:46	2023-12-22 03:51:46	t	t
fd466b48-cfd4-4d2b-bfdf-99b3595b627b	5eb07e97-1af7-41c2-903e-62eef51f9f4c		\N		3435923117	\N	\N	{}	2024-04-14 02:33:33	2024-04-14 02:33:33	t	t
471b1306-2efb-48c3-9487-d19c0ceca857	7cb55b4e-309e-48c6-bb08-9c5a99908e4f		\N		sankarsingh3588@gmail.com	\N	\N	{}	2024-05-26 01:27:50	2024-05-26 01:27:50	t	t
74d6d51c-a88b-4442-9811-6d9f11f3c98a	dabc2e08-c580-44c1-b164-a5c2ca7d9422		\N		audi99944@gmail.com	\N	\N	{}	2024-06-15 18:17:58	2024-06-15 18:17:58	t	t
c4699ed5-5891-4efc-b4da-c9d6001cf0b7	b5413c8c-7247-4498-9c8a-044f4858c8bb	한국사이버국군발전협회	\N	한국사이버국군발전협회	pbhn1004@naver.com	\N	\N	{}	2024-02-19 14:02:47	2024-02-19 14:02:47	t	t
69233d4d-c7ef-4dfd-beb3-2ecf0a4bd623	53ce0e6e-78f6-4da4-ae9a-a74911cada49		\N		bairwahansraj242@gmail.com	\N	\N	{}	2024-07-12 04:26:43	2024-07-12 04:26:43	t	t
cc2a6a81-e739-4f89-826f-07555310c8f0	e0bde437-b425-423b-bdac-018135d2e937		\N		geetapramod.sinha@gmail.com	\N	\N	{}	2024-07-26 06:16:40	2024-07-26 06:16:40	t	t
cb77c757-13a0-439e-9c7f-9f9f583c3f03	dc4aae5e-4487-4a2f-bdc8-ecd88e9abd8b		\N			\N	\N	{}	2024-03-14 11:11:53	2024-03-14 11:11:53	t	t
6ba2de70-ddf7-42ab-9c7a-7f4625200d19	779946ef-1373-475e-819a-b1a6cab68291		\N		paramjeetsinghromi@gmail.com	\N	\N	{}	2024-08-14 15:05:17	2024-08-14 15:05:17	t	t
9b7ea109-3097-4cab-9b7b-310111aa4d7f	b3a9ed31-32b4-4ea7-855e-cf739b08b6e9		\N		sangsang668mla@gmail.com	\N	\N	{}	2024-03-19 10:39:07	2024-03-19 10:39:07	t	t
48588fe9-f447-4772-927c-1977bb018794	1b2ba876-3b8e-4a3e-84f0-e8868d391c42		\N		sabluvarma168@gmail.com	\N	\N	{}	2024-08-14 16:58:53	2024-08-14 16:58:53	t	t
ff3540c1-736d-4187-b129-766975cd4d55	a64f60ba-f8a1-4b1c-9d8f-c02410ca14b4		\N		justin@mzspc.com	\N	\N	{}	2024-09-11 23:45:30	2024-09-11 23:45:30	t	t
fc5906b3-88ac-4a35-9e6a-b2712b0eb06f	bdaeb520-58bd-438e-8852-66677a8efa2a		\N		tranduytrung682@gmail.com	\N	\N	{}	2024-03-26 08:16:14	2024-03-26 08:16:14	t	t
979bd3ae-9931-49bc-8fc2-86a382e32e95	4208a284-2c0b-421d-9b04-9d76bf795306		\N		akhileshpharm987@gmail.com	\N	\N	{}	2024-08-15 04:44:57	2024-08-15 04:44:57	t	t
7e83ae0b-9cf4-4619-aa2a-2b725540757a	f7213fa1-f246-404d-9288-9feefb8323f0		\N		lengocphong183@gmail.com	\N	\N	{}	2024-03-26 16:01:05	2024-03-26 16:01:05	t	t
e6d07f19-96f7-4870-9b96-f2b1eba187ea	64377fa2-2a24-4a19-863b-f4a7690aa2d7		\N		3409711822	\N	\N	{}	2024-03-27 06:53:37	2024-03-27 06:53:37	t	t
d8f64844-122b-4dc2-b5ed-827856bf3631	4075f3b5-a340-4c96-ae18-9444e5b2f242		\N		oliviaevangelista52@gmail.com	\N	\N	{}	2024-04-01 06:59:23	2024-04-01 06:59:23	t	t
7f9b6540-6f2b-4682-a558-68b05b7df1dd	ff514411-50c3-48fc-87e8-3c151c6c9c13		\N		test@naver.com	\N	\N	{}	2023-11-13 00:02:44	2023-11-13 00:02:44	t	t
381fca68-2266-444c-833c-071b7f8eeac1	a72a361d-77df-45d8-8b8d-d7889ec73582		\N		3211694438	\N	\N	{}	2023-12-06 01:14:49	2023-12-06 01:14:49	t	t
130f19fc-8dbd-42c0-8dc6-401a43965218	7e2a2c9f-ceee-43a9-8c22-b0e99af67bf0	Dunkin	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/7aa8f57d-72fd-477e-afc6-1ae28be33ebf.jpg	I am expert to Marketing based on Block-chain. Get me a thing that you want. Thank you.	prodaoguide@gmail.com	1012345678	\N	{Blockchain,MyData,W3C,Web3}	2024-01-17 05:55:57	2024-01-17 05:55:57	t	t
f8bb3450-2c7b-4b3b-b2af-70c778bdcbe9	62191ca8-e257-4dc8-8e6c-015f8d228746		\N		3328615398	\N	\N	{}	2024-02-04 05:43:34	2024-02-04 05:43:34	t	t
91f5dfe7-d4f3-48c2-9856-09ce13405e43	ceee2a44-f9d5-47c8-a236-c2b810be38dd	박종희	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/62467a7a-6f58-4874-8399-03bd3001b0f7.jpg	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	vvvaid@hanmail.net	01037508046	\N	{꽃집,플라워}	2024-04-18 10:44:20	2024-04-18 10:44:20	t	t
ecc79ec1-46b8-4df8-bd55-926a6eadb21b	3e969c04-e8bf-4376-a556-2a039627e19f	우창	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/c4440631-ad93-469c-92bb-5548d9ad37a9.jpg	플러터 앱개발자 입니다.	woochang@naver.com	01022223333	\N	{flutter,개발,코딩,플러터}	2023-11-13 01:19:33	2023-11-13 01:19:33	t	t
d3b75d38-1d03-4bac-8541-7afde46ce5cc	e23dd0b2-7699-4b27-9b31-7966d2d7376a	김현상	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/104df8b8-8dd5-4344-bae5-ce9d0919e670.jpg	간판 디자인 및 제작 설치업을 하고 있습니다 20년의 노하우로 개인별 간판 디자이너를 배치하여 가장 효율적인 간판과 사이니지를 제작해 드리겠습니다.	wecando@naver.com	01090047775	\N	{간판,디자인}	2024-02-20 09:26:29	2024-02-20 09:26:29	t	t
c4ce3be8-b336-481b-a4ae-5a18af87b9d5	595eebca-c1ae-4121-9b0d-84774d8c7054		\N		mohannegi889@gmail.com	\N	\N	{}	2024-07-18 08:46:15	2024-07-18 08:46:15	t	t
75cd71a6-ee6b-41dd-998d-d8d90ef71fb9	69a923ff-3a36-4a9b-ba1e-1551a059f290		\N		utvan711@gmail.com	\N	\N	{}	2024-03-14 13:29:17	2024-03-14 13:29:17	t	t
338abe76-a06f-4282-94e4-622ddc714203	5431a241-78ce-4b21-b128-28dea9f8fae9	심현규	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/66945c67-99f3-47fa-8225-57238583dfcb.jpg	기업, 단체, 프로젝트 소유자, 플랫폼 오너 또는 회윈\n에게 평생 성장 에너지 함께 발생 인프라구축 	vpark365@naver.com	01054179861	\N	{MK303,그래핀,퀸텀}	2023-11-16 02:31:07	2023-11-16 02:31:07	t	t
78b6e78b-a29b-4492-aff1-6b766ccce965	21661d2a-883d-4966-8575-aa315b1d2e04		\N		sisodiaarchna15@gmail.com	\N	\N	{}	2024-08-14 17:45:20	2024-08-14 17:45:20	t	t
e8d6c370-b969-4cb0-970e-901eec742cd5	de67562f-d715-420e-b366-9a56e55ee6f0		\N		3684793913	\N	\N	{}	2024-08-30 01:32:23	2024-08-30 01:32:23	t	t
72cd7ff2-8f6a-44c8-a419-86f0871c4d98	c53ce851-fa9d-41ad-a7e1-416cb7b166fe	서민오	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/d6a6e65b-cf4a-42f3-ab90-1e210ee95caf.jpg	창의적이고 전략적인 사고를 바탕으로 브랜드의 가치를 높이는 마케팅 전문가입니다. 소셜 미디어, 콘텐츠 마케팅, 시장 분석 분야에서 경험을 쌓았습니다.	smo7589@gmail.com	01083390233	\N	{기업자문,기업컨설팅,법인대출,보험}	2024-03-21 04:40:35	2024-03-21 04:40:35	t	t
003c1c01-abef-4470-abdb-1c0bff850843	6fda73f9-57fd-48c4-b204-d70493028542		\N		tmdrl5095@gmail.com	\N	\N	{}	2024-04-01 08:18:16	2024-04-01 08:18:16	t	t
f7707754-f583-4be9-9aa1-9aa2de246bea	87b40694-4414-4841-925a-176a00c7826a	서우승	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/6527fb08-3083-488d-902b-fe9ed82364f1.jpg	XR AI 기반의 에듀테크 기업 베스트텍 입니다.\n	liger@bestts.co.kr	01052223997	\N	{AI,XR,교육,에듀테크}	2023-11-23 08:15:35	2023-11-23 08:15:35	t	t
10168cb9-e4f7-41cf-a0c2-7e4d16ef0a6a	8a111176-2536-4dcf-b486-baa15ebeae76		\N		vovanmuoi62@gmail.com	\N	\N	{}	2024-04-03 06:56:42	2024-04-03 06:56:42	t	t
58b75298-0d6a-4d3a-a2b9-acc730e53c8a	897f04d0-bc86-4454-83fc-fa1bc70b2a86		\N		3164251324	\N	\N	{}	2023-11-15 10:00:49	2023-11-15 10:00:49	t	t
60c2074d-7b9b-4d61-9b03-4a8dd39c80fc	0b752a7f-91c8-438b-b556-6b8d052b38b8		\N		analymagallano1996@gmail.com	\N	\N	{}	2024-04-16 11:47:25	2024-04-16 11:47:25	t	t
06c664c4-ece2-4249-84fd-d15507a5764f	6781d49e-0a52-407a-bbd9-57152fa52741	김용순	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/6fcf41a9-0eaf-41de-b3e4-b2e2c09d6a1a.jpg	재생토너 직접생산 및 판매, LG 전자  B2B전문점으로 IT및 가전 제품등을 제안하여 기업이 필요한  솔루션을 제공하고 있습니다. 	kysmg@boramits.co.kr	01095100567	\N	{LG가전,노트북,엘지전자,재생토너}	2024-02-21 12:54:13	2024-02-21 12:54:13	t	t
eb35c895-5f13-45e9-9df8-98493f58204e	05f1ea88-de99-48ad-b7cc-38ed173ba5f6	윤향란	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/6b07dad1-0779-4835-b598-7b9c9fddd2a5.jpg	감정과 이야기를 시각적 언어로 표현하는 전문 예술가입니다. 다양한 매체와 스타일을 실험하며, 창의력과 예술적 통찰력을 공유합니다.	3776190294	6468723838	\N	{설치작가}	2024-11-02 18:15:54	2024-11-02 18:15:54	t	t
a02fb862-2bcc-4c36-9256-39a40d7cb6ca	cba74671-d266-47e7-a682-6439f6096e4b		\N		sonkarsarves75@gmail.com	\N	\N	{}	2024-07-09 21:53:58	2024-07-09 21:53:58	t	t
79c3163f-7483-4076-9f8f-7a8b06c1bda3	03a39be5-7849-45e6-82d5-2631f805bca9		\N		tranhoangphuong19091996@gmail.com	\N	\N	{}	2024-02-19 15:16:07	2024-02-19 15:16:07	t	t
4143670b-b652-440e-a6f3-27f9070ea333	2296613e-7b3c-4921-b44d-6d329c509f24		\N		baberiyakailasababeriya@gmail.com	\N	\N	{}	2024-07-16 11:45:18	2024-07-16 11:45:18	t	t
ec22989b-a397-47d4-ad74-b18144fd4a4c	3047c6f8-9727-4b5a-82fe-c4336f868c9c		\N		dsurinder281@gmail.com	\N	\N	{}	2024-07-29 06:34:27	2024-07-29 06:34:27	t	t
2db8aa41-b376-4c0b-9969-0d6c841344c5	369ea585-21af-4bc2-8a99-0b371999139d		\N		mukeshtripathimukku@gmail.com	\N	\N	{}	2024-07-24 10:13:06	2024-07-24 10:13:06	t	t
3c23339f-36cc-4c32-b2cd-35e4f0c9a150	847edda8-344a-41bd-8008-bbdda2126a9d		\N		ad652203@gmail.com	\N	\N	{}	2024-03-04 16:26:45	2024-03-04 16:26:45	t	t
687bc90a-75ea-41b4-91eb-c4831a3eb9c7	83d6c867-feae-4868-8718-e3832caa8651		\N		ravikantkumar74178@gmail.com	\N	\N	{}	2024-08-09 16:27:30	2024-08-09 16:27:30	t	t
01b82ce8-ab0b-4429-80a5-41652d312987	b248fe7b-2402-4a4c-b7b3-00b9a07d4589		\N		3402448308	\N	\N	{}	2024-03-22 11:41:11	2024-03-22 11:41:11	t	t
897f080e-4e70-4415-a781-8f5a5a60be04	6d449597-c2f2-475e-8c94-65ccd3988c13		\N		canoyjessmar14@gmail.com	\N	\N	{}	2024-03-25 13:38:19	2024-03-25 13:38:19	t	t
c56fb746-310a-406a-b1c6-8568808b79b4	0e243923-c4e6-4bf0-ae19-c0a5545f33c4		\N		3163954740	\N	\N	{}	2023-11-15 06:46:04	2023-11-15 06:46:04	t	t
49800265-bc34-4449-83bc-a2b1c27999f2	a38b5915-0abf-4faf-9807-79a55151dab3		\N		3209377108	\N	\N	{}	2023-12-04 08:51:51	2023-12-04 08:51:51	t	t
0c855944-f57e-4246-853c-077fed24e5a8	48a7ded3-0e70-425b-b587-8139188fb234		\N		ygosanja2@gmail.com	\N	\N	{}	2023-11-27 08:31:21	2023-11-27 08:31:21	t	t
79c21507-c042-4543-8419-f22f8e6a3276	14eb0aad-c413-413c-8abc-549650c33224		\N		3206173537	\N	\N	{}	2023-12-02 06:12:27	2023-12-02 06:12:27	t	t
363d0356-fee8-4d2f-a67e-416d7f750b56	17eb1c1d-7c3d-487a-8fea-baff32b2937c	Robert Hyunsik Cho		I am an experienced Tax Advisor and Real Estate Broker in CA, NV, & GA who provides accurate and reliable business solution. I have expertise in financial analysis, tax planning, and business solutions in investment across various business areas.	rcho@growallrealty.com	2133690822	\N	{"real estate 부동산 상업용 집 호텔","tax 세금 절세 회계 엘에이 미국 한인","믿을만한 한미동맹","신용 정직 실력"}	2024-11-07 21:02:07	2024-11-07 21:02:07	t	t
4c0b9199-3a83-42c3-bf9d-b6040de6a1fa	45f96262-590a-4355-b186-9a358c2e6a33		\N		banwarikushwahgirvar@gmail.com	\N	\N	{}	2024-08-08 12:48:05	2024-08-08 12:48:05	t	t
9b4f4cd6-3172-4c37-bea7-516015d52f01	b25c075c-2083-4388-ab72-59394bc00546		\N		mohammadsalimkhannagour@gmail.com	\N	\N	{}	2024-08-10 06:33:03	2024-08-10 06:33:03	t	t
c3cd1b92-0614-4e8c-9017-dbc5d8838caf	42ad3425-e79f-4766-a252-2731a5d74930		\N		vocuong6770@gmail.com	\N	\N	{}	2024-03-14 13:31:21	2024-03-14 13:31:21	t	t
b34d0e01-b23e-4575-88b1-48ac9d567a60	05e184ec-fe58-4bbe-9e38-1bb0400a43a9		\N		unisik@gmail.com	\N	\N	{}	2024-03-14 06:45:11	2024-03-14 06:45:11	t	t
1b8d56a3-f8cc-4bd3-b7ed-806bfcce258f	04383a3e-b5cf-4875-99a7-fdd746e9cab0	이은숙			jinusli@naver.com	01029648660	\N	{영상촬영,영상편집,편집디자인}	2023-11-23 08:26:06	2023-11-23 08:26:06	t	t
7c2991aa-81cb-41b8-a32b-afe0e2f9ed87	04c83856-9ff0-475a-b2cd-db05406b84a3	박채성		에어컨설팅은 국내 최초 항공화물 국제물류전문잡지사로 무역운송 국제물류 관련 모든 내용을 다루고 있습니다	good@cargopress.co.kr	01029424176	\N	{국제물류,기사작성,"보도자료 작성",항공화물}	2023-11-23 08:15:49	2023-11-23 08:15:49	t	t
e0e612d3-8910-4030-b0bc-9fe1e3481ad4	072c2418-239b-4944-93f8-da9eb88be608	Michael Lee		I am a marketing expert who enhances the value of brands through creative and strategic thinking. I have gained experience in social media, content marketing, and market analysis.	light4you2@yahoo.com	9096453559	\N	{Beauty,"Business Consultanting",Health,"Los Angeles "}	2024-10-14 22:17:43	2024-10-14 22:17:43	t	t
b069a929-f86d-4747-a9b1-b78510c15fd1	5372dacd-f854-497b-9435-5b9ceb3ed7ea		\N		thakursatya2232@gmail.com	\N	\N	{}	2024-08-15 14:22:39	2024-08-15 14:22:39	t	t
2f8e18b3-0f0b-4e5a-bd3b-0e3ddb123073	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	정호진	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/ae9f9bd0-7757-49bd-9948-29af28c3fb8b.jpg	시보리전문업체\n컴퓨터제작\n원단제작	kyungdotex@naver.com	01026786107	\N	{시보리,"애리,소매",원단,"컴퓨터 시보리"}	2023-11-23 08:15:29	2023-11-23 08:15:29	t	t
bb6db700-1d89-4470-be36-45585f109de2	d2aedf54-785c-4425-afa2-5b7d0ec3b96c	주식회사 시연디자인건축 	\N	주식회사 시연디자인건축 	ifursys@empas.com	\N	\N	{}	2024-10-19 09:49:28	2024-10-19 09:49:28	t	t
2aecb45d-4033-42f5-b67e-6987cd928ad1	691a7808-92eb-4fce-a618-d51867429491	강미영		학생들의 가능성을 최대한 발휘할 수 있도록 돕는 열정적인 교사입니다. 혁신적인 교육 방법과 생활학습 지도를 통해 경험을 향상시키고자 합니다.	3182172866	1056891114	\N	{교육}	2023-11-24 02:22:00	2023-11-24 02:22:00	t	t
90d3d675-8c30-4832-ac6d-9d1342976aa8	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	An,Kyu-sun	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/a4cfc9ad-0309-4cc9-addb-b3662d6b62b2.jpg	전세계Prodao/DAO그릅Biz센터관계자로 비지니스운영.수출지원.글로벌제휴확대 및미국 나스닥상장추진등	smqi9000@daum.net	01090067000	\N	{"국내,해외Dao그릅/Prodao센터입주자모집",글로벌수출.자금투자유치.마케팅지원,월드Dao그릅센터설립.제휴처모집,"전세계 각분야전문가.창업자.마케팅,수출,컨설턴트전문가초빙"}	2023-12-01 09:49:34	2023-12-01 09:49:34	t	t
2b41b958-d79b-4b18-84a6-8f4361544076	3d328497-971a-4cca-b0e6-6d959503bac0	YONGGI KIM	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/d8a406a7-d386-4d6a-a07e-773bf44a34b9.jpg	국제 무역 분야에서 15년 이상을 보낸 경험 많은 무역 전문가입니다. 세계 각국의 시장과 문화를 이해하며, 글로벌 경제의 흐름 속에서 효율적인 무역 전략을 수립하는 데 전문가로 활약하고 있습니다.	yonggik@gmail.com	01057042530	\N	{"global finance ","global marketing ",investment,trading}	2024-03-21 06:25:22	2024-03-21 06:25:22	t	t
f7ecfb8f-2918-44b4-b610-305129276067	62d39c18-1b82-4922-90eb-2ad5caf6e8e1		\N		3437989681	\N	\N	{}	2024-04-15 09:13:57	2024-04-15 09:13:57	t	t
cfdaf8c5-da23-4544-a070-993a25a1f3e8	936a6f95-6e7c-4d54-a877-be67d6d7948d		\N		applezrock@gmail.com	\N	\N	{}	2023-11-14 05:27:34	2023-11-14 05:27:34	t	t
9de9039e-efc7-4f6f-96db-f5f24ddf32bd	e51162de-3aaf-4dfe-acb0-579ee821099c		\N		mariceldella181999@gmail.com	\N	\N	{}	2024-04-20 13:06:36	2024-04-20 13:06:36	t	t
2bc37ec4-ab27-4638-a676-0b8ccedac5b9	8ad50119-e6b0-4780-b640-150f0a52be5a		\N		3206603343	\N	\N	{}	2023-12-02 11:11:42	2023-12-02 11:11:42	t	t
177bd472-d53d-4953-a539-287e11ee05ec	218089ad-da0d-488f-b9cc-f599337f5011		\N		salahuddinusmani09@gmail.com	\N	\N	{}	2024-05-11 08:13:27	2024-05-11 08:13:27	t	t
b3887b4c-125a-4ebb-9deb-6936673bc3b9	4ba48bd4-ff77-4c37-98a4-dd0d748cd535		\N		basilnarzary353@gmail.com	\N	\N	{}	2024-05-25 15:58:42	2024-05-25 15:58:42	t	t
e75ea6a7-0793-4df6-b9e4-ba78f4598d29	7957760c-02b6-4ab3-9314-4aa6f3633ddd		\N		3241722518	\N	\N	{}	2023-12-26 01:45:59	2023-12-26 01:45:59	t	t
3dea4d3d-20da-48ca-992b-490862954d24	98db0db2-e73a-4e94-bb43-33f62d7ae82f		\N		3326794193	\N	\N	{}	2024-02-02 23:16:28	2024-02-02 23:16:28	t	t
dfd8cae4-ffb8-430c-987a-5585e12ccccd	925f7f5f-47ff-4739-a52f-09ad5886fd82		\N		3330067066	\N	\N	{}	2024-02-05 05:21:22	2024-02-05 05:21:22	t	t
98b588e3-9e62-4f05-94b0-5b125e5b4c30	d8101f08-60be-4339-9a5d-f0fb6c996846		\N		amitroy9830917791@gmail.com	\N	\N	{}	2024-07-10 06:20:00	2024-07-10 06:20:00	t	t
9e46afed-8beb-43c3-a8f6-cbbdef4ccf7a	340b95fa-a327-426d-9a05-9363741dd311		\N		3353122175	\N	\N	{}	2024-02-20 19:10:27	2024-02-20 19:10:27	t	t
20247acb-6452-416c-bc2f-d95d2fd54808	39efb61c-534f-4185-a046-457cb05c612a		\N		urai97369@gmail.com	\N	\N	{}	2024-07-26 16:22:33	2024-07-26 16:22:33	t	t
d2138e77-c260-43c8-aca8-48913585b48a	25da7595-9d60-404e-86a5-2abe95f81715		\N		purushottam15sharma@gmail.com	\N	\N	{}	2024-08-14 08:24:46	2024-08-14 08:24:46	t	t
c2334f8a-5c6b-4e0b-a45f-1953d2e45919	40d1650f-71c3-4fa9-8a82-91ed16652237		\N		3745197246	\N	\N	{}	2024-10-12 01:40:11	2024-10-12 01:40:11	t	t
f9a154e7-a089-46f8-92e8-f4901fc3591e	35cd5eac-895c-4bd5-b627-925d292e7108		\N		3328087585	\N	\N	{}	2024-02-03 17:52:54	2024-02-03 17:52:54	t	t
aedc823d-ed0d-4cec-a1dd-c14e55256d38	32f18e4a-73ed-407a-9b84-596ad126573f		\N		2698180216	\N	\N	{}	2024-06-11 04:33:52	2024-06-11 04:33:52	t	t
ce622527-3473-4942-ad2f-faaf61a0e3f4	f13bf802-836f-4886-95c6-99078cf1a1a0		\N		cmaok03@gmail.com	\N	\N	{}	2024-02-06 23:17:43	2024-02-06 23:17:43	t	t
33daa8f7-a2d5-47a3-a446-df62e78b4b68	45f81bc7-ff24-498d-9104-18da7e5643f8	이직	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/c45765d7-cfc5-4de5-83aa-d7b30e522bf1.jpg	언론사 베타뉴스 운영. 서울경제인협회 부수석부회장, 중앙지회장, 용산지회, 홍보본부. 모닥불. 아카데미 3기,5기	leejik@betanews.net	1042470334	\N	{"기사 작성",기자,사진동영상,언론사}	2023-11-23 08:26:34	2023-11-23 08:26:34	t	t
f7571184-c991-4d4a-b5d2-5dd4b204ce54	a6f5d443-9bc4-40ed-b156-0bba4139c2fc		\N		vivekchoudhry350@gmail.com	\N	\N	{}	2024-02-17 05:17:15	2024-02-17 05:17:15	t	t
cf9c345b-7ae1-47ed-a6a1-c161507cdadb	0070634d-1758-41ae-bda2-1e046f41109e		\N		delacruzelson4@gmail.com	\N	\N	{}	2024-02-19 16:20:38	2024-02-19 16:20:38	t	t
7687da67-d9cf-4b15-9d9c-bf8f73d51bf7	e53c3d28-bad0-465a-9b49-e0209ff0793c	Marcos Giménez	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/eda409d5-3294-47af-b745-a6f4b14949b5.jpg	Soy un profesional de TI versado en las últimas tecnologías y tendencias de TI. Destaco en automatización de Telegram y WhatsApp, Blockchain, integración de IA, y tengo una gran pasión por buscar soluciones creativas a problemas.	tstcmusic@gmail.com	600074612	\N	{Blockchain,Bots,Crypto,Telegram}	2024-10-08 18:57:59	2024-10-08 18:57:59	t	t
a66e0f55-081e-4443-a189-b1e66824e69e	4a8de4c0-a5a1-4d5f-be82-bdb68dd65a7c		\N		3352518795	\N	\N	{}	2024-02-20 09:26:07	2024-02-20 09:26:07	t	t
172e1c20-e89d-4d09-a9bc-baac5c2b1068	e471db4b-ef29-4670-9730-3101f90741ab	양희동 	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/2028fb0a-3bc9-4add-978f-c5b0299492a3.jpg	한국경영학회 회장\n한국경영정보학회 회장\n이화여자대학교 경영전문대학원 원장\n이화여자대학교 경영대학 교수	hdyang@ewha.ac.kr	01071630483	\N	{기업가정신,블록체인,"인플루언서 마케팅",클라우드}	2023-11-30 02:40:09	2023-11-30 02:40:09	t	t
88c030f1-9852-4283-8d55-c860ca1fa7fd	2ebea118-1ae0-4f6b-a5a7-14f84fe8152a		\N		tisejaehong@gmail.com	\N	\N	{}	2024-03-14 07:54:32	2024-03-14 07:54:32	t	t
9a1bffcf-332e-4538-a63f-53e40a557815	71e23749-819d-4072-8836-74814b93d6a9		\N		sofimohd1995@gmail.com	\N	\N	{}	2024-08-14 12:16:59	2024-08-14 12:16:59	t	t
3d50cfa8-ced5-4d5b-945c-28611b1055b0	70a8fc0d-f31e-43a9-b701-ea223205e0df		\N		bethalbaran62@gmail.com	\N	\N	{}	2024-03-28 06:21:23	2024-03-28 06:21:23	t	t
a831bddb-17dd-4875-a5c7-7f5a584ec92e	e745e5c8-cfa0-4e97-8f9f-808652f0a513		\N		nguyenvanbien10111985@gmail.com	\N	\N	{}	2024-04-01 08:25:18	2024-04-01 08:25:18	t	t
261825da-b667-47e2-9e5d-e31eaf499e42	6fc7cc75-200e-49fe-935e-79111fb8948e	강명수	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/c6873c0a-4897-4864-bfb7-d13a10f55880.jpg	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	vision4iou@naver.com	01072841770	\N	{건물종합관리,"교육 컨설팅 ",비상재난안전,정보보안}	2024-06-28 05:19:40	2024-06-28 05:19:40	t	t
68660eae-8e99-41f1-b8af-f0ddba7fa584	a10a15e9-4a0c-422d-8dc2-4fd8df9e7daf		\N		3472267944	\N	\N	{}	2024-05-08 03:37:56	2024-05-08 03:37:56	t	t
3a81d192-a57f-45cc-867b-4021a92f07c4	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	박창우	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/56cf7816-4eb7-4aa4-ac23-3c14224c1248.jpg	I am a Flutter developer who develops apps for Android and iOS.	changwoo1208@icncast.co.kr	01012345678	\N	{App,Coding,Dev,Flutter}	2023-11-13 00:03:17	2023-11-13 00:03:17	t	t
d3d80324-e4e3-43c5-b230-66a101f2d19e	dae9be5f-69f8-4aba-8707-3974bd4edf02	오창원	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/d7f954d0-f9e9-4cbe-b0f3-918044f639bd.jpg		cwhd@hanmail.net	1089661700	\N	{"건강기능식품,비트젠포르테",주유소,"주유소. 광고",주유소위치}	2023-11-23 08:15:37	2023-11-23 08:15:37	t	t
902ddd32-1e07-4cd6-9213-f9a40edeb2e0	5825fa78-3da2-45b3-8541-27b485254728		\N		vivaskumar53@gmail.com	\N	\N	{}	2024-02-17 07:47:14	2024-02-17 07:47:14	t	t
84c6bd8f-6ed4-40ad-bc05-bc8433f91254	b571720c-8b29-42b6-9d69-b87005f16551		\N		chandreshbhola007@gmail.com	\N	\N	{}	2024-07-13 15:31:11	2024-07-13 15:31:11	t	t
1e9ae731-061b-4b56-8ddc-149e0be48d93	82de6c86-64f8-4b2f-afb3-ad42f3064102	강덕구	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/3b1053ab-815e-4f5f-a7b3-c1970409f199.jpg		dgkang@techcode.co.kr	01053626713	\N	{이차전지}	2023-11-28 01:27:23	2023-11-28 01:27:23	t	t
a101b498-2363-415a-a168-61f71fc0614e	b0df8acb-406f-44fe-a769-a311c3462518		\N		ra2868186@gmail.com	\N	\N	{}	2024-07-24 05:38:50	2024-07-24 05:38:50	t	t
01634782-f526-4123-97a2-b8d87533970d	80b28ffb-1928-41c2-9147-24969dde86fa		\N		3385918172	\N	\N	{}	2024-03-12 10:54:32	2024-03-12 10:54:32	t	t
638d14ce-9354-489d-b685-ae66a4321870	69e01f2b-91dd-4f35-9830-4cc59ed58d57	(사)서울경제인협회	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/94f8b4df-477e-4b6f-a29b-9bd25e5fe880.jpg	(사)서울경제인협회는 서울시 소기업 소상공인 간 정보교류 및 공동연구, 협력적 기업환경조성을 위한 대내외 활동은 물론 지역사회 공헌 및 회원사 권익 증진에 기여 하기위해 설립되었습니다.	seoulbizorg@gmail.com	\N	\N	{기업교류,서울시,소상공인,정책지원}	2023-11-28 07:02:25	2023-11-28 07:02:25	t	t
00a66260-c611-4927-9737-7b2992e9daf2	2fb5aad7-cd52-4250-a25b-4d6ede9dd572		\N		kimr0048@gmail.com	\N	\N	{}	2024-03-13 05:29:31	2024-03-13 05:29:31	t	t
9aaea26b-205f-44d7-8686-3064eeee0540	535a6c64-fa88-48a4-855c-937ab45c8519		\N		dikshanagpure481@gmail.com	\N	\N	{}	2024-08-11 08:30:12	2024-08-11 08:30:12	t	t
7f68b097-2ade-4ff2-9734-4b479645f6b1	e703bd05-a781-41ce-82b6-e0221018d631	test	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/b2be91ed-0114-4137-b297-7e4e22f00e4c.jpg	세계글로벌리더연합회는 test 리더들의 역량 강화와 네트워킹을 지원합니다. test 리더로서의 여정에서 영감과 지원을 얻으세요. 우리의 프로그램은 리더십 스킬 향상, 멘토링, 그리고 다양한 분야의 test 리더들과의 교류를 위한 플랫폼을 제공합니다.	acchoi@icncast.co.kr	\N	\N	{t}	2023-11-19 09:10:00	2023-11-19 09:10:00	t	t
933c5a67-3713-4862-8472-c49f737efa27	66dc59c3-b910-4c49-90f5-426e5d16fb85		\N		printleeny@gmail.com	\N	\N	{}	2024-12-03 22:21:55	2024-12-03 22:21:55	t	t
3562e93a-96fc-487f-99c4-b73e973403a0	e9c13abb-7649-43ec-8700-882edad4129d		\N		maysua67@gmail.com	\N	\N	{}	2024-04-15 22:46:55	2024-04-15 22:46:55	t	t
7a17cc0a-e378-4558-bcd5-86755039a4a8	6f40fdb4-0278-4a3f-b662-f7f7b13cf962		\N		3441295312	\N	\N	{}	2024-04-17 12:52:20	2024-04-17 12:52:20	t	t
a0bb4e76-c1b4-4457-81df-3bff7bf288e9	7de32a97-e650-4e19-87e8-0040927e6844		\N		3001458575	\N	\N	{}	2023-11-20 05:00:16	2023-11-20 05:00:16	t	t
83d36bed-307b-4bbf-a39b-18e11911e502	0578fbdc-7527-4d57-a008-30a2078337cc	앨리박스주식회사	\N	앨리박스주식회사	alley3160@naver.com	\N	\N	{}	2024-06-11 08:08:46	2024-06-11 08:08:46	t	t
336f4ee2-d32a-4083-9bda-6fcb9638b75e	3090db20-3fb2-4331-b5c6-fde9e7bc998c		\N			\N	\N	{}	2024-06-29 05:52:34	2024-06-29 05:52:34	t	t
a70ee04b-493f-4a47-ab57-a4231afd98d2	724c9b02-38fd-4cdc-868a-74fdebaed45f		\N		subhashchand87773@gmail.com	\N	\N	{}	2024-08-14 12:55:43	2024-08-14 12:55:43	t	t
06630396-a04b-49df-b66c-542eb8c3c587	7287f43c-dcaf-4683-95ef-9b3577d26aec		\N		morenatpond@gmail.com	\N	\N	{}	2024-03-15 04:09:00	2024-03-15 04:09:00	t	t
f3b77f82-7e88-460f-a165-d532adcad008	f5d213b8-d2e6-4f52-8787-7f38c16585ca		\N		3407715749	\N	\N	{}	2024-03-26 03:25:39	2024-03-26 03:25:39	t	t
acee4017-982f-41a0-83e3-e6913faf5fb6	25233d34-897b-4a45-bb69-c143b66e4ed6		\N		cymonpaiz@gmail.com	\N	\N	{}	2024-04-02 15:47:33	2024-04-02 15:47:33	t	t
bfd9f859-6f44-4948-861e-5eeae0e5da12	5938ef7a-7576-452e-83c8-e04c046f9db9		\N		riyaprabinsen@gmail.com	\N	\N	{}	2024-10-21 13:39:16	2024-10-21 13:39:16	t	t
2eee2d5d-812f-41e4-a91f-371006370ec2	fcb97d2c-aabd-4e2f-81ae-038d23f31be2		\N		luzsiosan@gmail.com	\N	\N	{}	2024-05-08 07:23:03	2024-05-08 07:23:03	t	t
6ead434f-6a3f-46f5-bcf1-577d84e31950	f7578885-4640-41c2-9831-c994c131ab57	조영관 	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/6e79a33e-f5a0-4d6f-920b-eb776765421b.jpg		choyk4340@daum.net	01022294340	\N	{기록,꿈,도전,희망}	2023-12-01 03:19:52	2023-12-01 03:19:52	t	t
0613a3f3-5118-40bd-973e-caf558006c52	ac2d044e-0c82-4e7c-bc7f-2781191a1148	(주)명경푸드 최재식	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/a2504e9a-e3cf-466a-9665-a338dca2bb41.jpg		neulpeum@hanmail.net	01068865553	\N	{고기,돼지고기,소고기,육유}	2024-01-25 07:19:00	2024-01-25 07:19:00	t	t
27217ba9-d135-46e8-bf61-0856e7463b6b	abfbdf7e-6cb4-4977-82ef-93211e950a6c	Dongkwon Yoon	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/5fa830ea-5e23-44e3-9b9d-faa0ecfc8e8e.jpg	Person who changes the world\nInvestor\nEntrepreneurship\nPlatform developer\nArtificial intelligence creator	3233748019	1022380123	\N	{"Artificial intelligence creator",Entrepreneurship,Investor,"Platform developer"}	2023-12-20 10:59:01	2023-12-20 10:59:01	t	t
32874422-f3af-439e-bc17-b128d390720c	52aa362f-7d49-4cf1-8b2a-90d1b6bdf2bc		\N		sivaji.anupoju@gmail.com	\N	\N	{}	2024-05-28 16:21:52	2024-05-28 16:21:52	t	t
dceacf15-2541-4a08-b5b1-bd66fe5a16a0	36fa3c27-a0c6-4407-a386-a0b57cbbd453	이진수	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/91740fba-38aa-4607-9d12-5016111d0366.jpg	이불압축팩제조 구강용품, 기타생활용품유통	anacaptain@hanmail.net	01055716984	\N	{"발열깔창 ",발열조끼,이불압축팩,치약}	2023-11-23 08:15:38	2023-11-23 08:15:38	t	t
2c7a2d36-45d6-4538-8381-968d63c46e65	9691721e-0e79-4308-be25-84232fcb1c4d		\N		3326773189	\N	\N	{}	2024-02-02 22:24:13	2024-02-02 22:24:13	t	t
d473796c-176b-4ba8-af85-5c34346a5b21	094f2915-f8f1-4a09-a0e3-03393c51c717		\N		kedarsharma695@gmail.com	\N	\N	{}	2024-07-09 20:08:06	2024-07-09 20:08:06	t	t
f69c60a5-3515-461d-9a7d-668d0e031b02	1bd86dd9-872f-4a68-8602-a60813df56c8	신훈희	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/bc138a1b-a3a5-4fa4-9516-61d92c0fe59c.jpg	주어진 배역을 충분히 연구 분석하여 작품에 충실하고자 최선을 다합니다.	mytomato2@naver.com	01021145258	\N	{모델,배우}	2024-06-26 09:51:08	2024-06-26 09:51:08	t	t
a48bdbe2-9eb1-4230-b2e8-f53702a37ba2	fb06de97-b722-4281-99cf-482d421bd4b0	김성하	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/1153a4ef-be54-4e52-a6d1-cbac164f8678.jpg	의약품 의료장비\n진단시약 의료소모품	taemen96@hanmail.net	01052564182	\N	{마스크,의료기기,의료소모품,진단검사시약}	2023-11-23 08:15:37	2023-11-23 08:15:37	t	t
cbee0e35-56cf-4722-b87b-6d439627f58f	4bd2dff5-6f63-4ad3-a9ee-61219df00045	김형모	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/ae7ba334-ff38-4b2c-9a55-ee688e8c97d5.jpg	대한상공회의소 베트남사무소\n베트남 진출 한국기업 경영애로 대정부 건의\n양국 기업간 네트워킹 지원 및 비즈니스 기회 마련	3213883331	01073064278	\N	{"KCCI ","Viet Nam",대한상공회의소,베트남}	2023-12-07 09:16:11	2023-12-07 09:16:11	t	t
1081695f-42f3-47c9-a93a-14e349fabe3c	e1e9a4b7-c8df-4a14-9c32-6c43fa8049ea		\N		rambalaknishad1023@gmail.com	\N	\N	{}	2024-08-11 12:16:37	2024-08-11 12:16:37	t	t
924ab3c6-6cc1-43b6-bac2-697ab7b91d49	ecb030df-f0f6-4c94-a344-5f4cc01f3df6		\N		sadhanmalisadhanali@gmail.com	\N	\N	{}	2024-08-15 11:06:18	2024-08-15 11:06:18	t	t
1614d707-3d27-4273-a3a6-84efdb8df848	11eb06e2-4ace-4f5a-b615-e7f45991fac8		\N		tarouisyou@gmail.com	\N	\N	{}	2024-12-08 15:00:30	2024-12-08 15:00:30	t	t
abeadfec-4abe-43d1-a247-1b13f7223e7e	07f71045-e499-4b88-b3bc-4b035815ef71		\N		vothanhthienvu26011980@gmail.com	\N	\N	{}	2024-04-14 23:02:35	2024-04-14 23:02:35	t	t
ba23ff34-d025-4838-a976-9975afe4507f	f1dff1d3-1665-4c45-a529-c28ab6052030		\N			\N	\N	{}	2024-05-21 09:24:24	2024-05-21 09:24:24	t	t
c3e24fbd-d3ee-49a2-947d-25f7cdd24122	341ade64-a857-460d-bc81-dd5f5b0c49b7		\N		jagdeepsinghsinghjagdeep52@gmail.com	\N	\N	{}	2024-06-12 01:10:19	2024-06-12 01:10:19	t	t
2e12f086-9e9a-4271-b9ed-183326a0cbeb	aad3bd25-9a47-403a-8f67-6ee04a2f5a63		\N		hsdm4228@gmail.com	\N	\N	{}	2024-07-11 02:03:36	2024-07-11 02:03:36	t	t
52ad7358-06e7-42e4-a6f6-d0fcd642c35f	0b169a70-d8c9-4ee6-a095-2edfaa6698d3		\N		lamthienhoangtnct@gmail.com	\N	\N	{}	2024-03-25 12:16:14	2024-03-25 12:16:14	t	t
9155752d-a520-43e1-9c22-76665438fdcf	2e0268a2-fdf9-42f2-b671-d5a888b2ba83		\N		rickycapunpon67@gmail.com	\N	\N	{}	2024-04-15 15:32:35	2024-04-15 15:32:35	t	t
f3251d39-918d-4209-832a-3d50a9863057	f131f85a-9758-4807-b033-a460023f7800		\N		3163081954	\N	\N	{}	2023-11-14 14:40:57	2023-11-14 14:40:57	t	t
0cae0b2b-0bbe-4553-818b-687158331f0b	75bc07bb-6b7a-4414-b064-9f0f7c086217	정은희	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/8bd359cf-f30a-470a-85e0-5aebc670d011.jpg	위례한라비발디 공인중개사\n요리하는중개사\n지식산업센터분양\n공장.창고 전문\n사옥마련전문\n부동산\n공인중개사	ju0824@hanmail.net	01033997779	\N	{공장,상가,지식산업센터,창고}	2023-11-16 04:48:09	2023-11-16 04:48:09	t	t
2a277148-a60e-4fad-92e6-3b3e48b8fcde	5b277fc8-1da0-4867-beae-f6a8e72f490e	조문환	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/bff8f101-b534-428f-9981-7d333481d8f9.jpg		choe912@naver.com	01043499119	\N	{"medical waste",온실가스,인허가,환경}	2023-12-23 12:27:12	2023-12-23 12:27:12	t	t
372dcb1f-397d-424d-87a0-7a89501411e5	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	최봉결	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/16401b46-08e2-4bb6-a587-bbfbdafe124e.jpg	1. PRODAO 전세계 이용자 3억명 목표.\n2. PRODAO = [페이스북 + 링크딘 + 블록체인 DID + 전자신분 회원증 + 전자지갑 + AI챗봇].\n3. PRODAO 글로벌 센터 100개국 목표.	hanbtap@gmail.com	01083459855	\N	{AI,Blockchain,Dapp,NFT}	2023-11-14 12:39:54	2023-11-14 12:39:54	t	t
b5017c23-b6ad-4ff4-b308-c14d1c92f5d8	8b9c80e4-3072-4dab-85a6-36e310fae6ef	코더스	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/e1c9346e-86f7-4480-bcde-21bb10829e7a.jpg	최신 IT 기술과 트렌드에 정통한 IT 전문가입니다. 클라우드 컴퓨팅, 사이버 보안, 데이터 분석 분야에서 두각을 나타내며, 디지털 혁신을 추구합니다.	coders.ceo@gmail.com	01027276040	\N	{블록체인,코더스}	2023-11-11 01:05:03	2023-11-11 01:05:03	t	t
fe7cb400-af09-48ee-8e08-1a7475d953f4	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	prodao	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/646ef6e3-b3ec-4564-8587-b8b1fa20880c.jpg		wefon@naver.com	10-12341234	\N	{Keyword,PRODAO,Tag}	2024-01-03 00:53:45	2024-01-03 00:53:45	t	t
0778ca7a-a344-417d-9adc-4bf607d74593	a6138b49-27ca-485f-ad57-12f6ed08e94b	박주선	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/b0cccdec-7e70-4310-9662-b0131a7e54d6.jpg	노인복지전문입니다.\n요양보호사교육원운영\n재가복지센터운영\n호원대겸임교수\n	jsp2001p@hanmail.net	01082534348	\N	{밤길걷기,방문요양,요양교육원,요양보호사}	2023-11-23 08:15:37	2023-11-23 08:15:37	t	t
a1370707-54aa-4fff-a1d2-9766ba5ec8f7	2ddcfb31-7ace-442b-9cf9-eb1966e09627	이송재	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/c179addb-dd74-48e7-9e85-bbf44f42ef88.jpg		1glass@hanmail.net	01042284274	\N	{시공,유리,인테리어,특수유리}	2024-01-25 07:19:22	2024-01-25 07:19:22	t	t
c9bbdcac-a3fe-4f17-a1ad-eedf02bd9ade	e1d0121d-7fc5-424b-860e-065f92776ca1	한순기	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/25b19a54-6ec5-4acf-ade7-648734bd3fab.jpg	감정과 이야기를 시각적 언어로 표현하는 전문 예술가입니다. 다양한 매체와 스타일을 실험하며, 창의력과 예술적 통찰력을 공유합니다.	3389476825	01062792024	\N	{노리개,머리꽃이,비녀,한복장신구}	2024-03-15 01:21:05	2024-03-15 01:21:05	t	t
0b904e48-36a1-4799-bfea-41664bb38422	9079e6fb-d198-4c34-a483-39df60af375b	Lee Tony-Kun	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/f6fd1c5c-4821-4db1-81c9-c099482fe9e5.jpg	국제 무역 분야에서 15년 이상을 보낸 경험 많은 무역 전문가입니다. 세계 각국의 시장과 문화를 이해하며, 글로벌 경제의 흐름 속에서 효율적인 무역 전략을 수립하는 데 전문가로 활약하고 있습니다.	3781170351	939117056	\N	{"방글라데시 봉제","베트남 봉제.침향","베트남 침향 오일.","중국 봉제"}	2024-11-06 09:14:33	2024-11-06 09:14:33	t	t
3c9dcb37-c4d7-4703-b05b-26f8fbe2b692	0be157db-7f72-4e13-9c10-5b3a30bebd76	권영태	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/1c074f04-e737-4907-b394-95fb3ca01694.jpg		kyt8713@naver.com	01054836651	\N	{"복사기 렌탈/리스","솔루션 보안/출력",캐논/충북/세종,프린터/프로젝터/복합기}	2023-11-22 23:26:01	2023-11-22 23:26:01	t	t
a843473b-479b-4e84-b372-34176b1dd827	d05bf38b-f898-4dfc-adcc-dce47a90a1c7	신훈희	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/cad54054-2197-436f-8a1d-ed8e427f46f0.jpg	상하수도 도로 공항 등 기반시설 자산관리 시스템구축 전문 ISO-55000, ISO-55001,	sinsia@nate.com	01021145258	\N	{iso-55000,기반시설자산관리,설비자산관리}	2024-03-13 00:41:43	2024-03-13 00:41:43	t	t
2bca4168-2eda-426c-be92-6af4717f969e	1a88ebc2-fa9e-4566-9043-3904425b19ea	안현상	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/cb86c1cc-4935-49ac-943c-e5716e7452ec.jpg	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	gx3308@naver.com	01064395484	\N	{공간디자인,돌잔치,디스플레이,스몰웨딩}	2024-07-14 11:02:55	2024-07-14 11:02:55	t	t
904a3d0e-abd6-4af1-9145-0e6158b14f25	5e27148a-c486-4282-9cc5-7ec352cd411b	김동길		수출 전략수립\n수출국 현지법인설립\n수출 크레임해법\n해외전시회(일본)참가기획밎 현지동반 상담추진\n일본 바이어발굴\n일본 통변역	jfskim@naver.com	01033394130394130	\N	{바이어발굴,수출.해외마케팅,수출전략수립,해외광고홍보}	2023-12-27 04:48:24	2023-12-27 04:48:24	t	t
07bdd76c-cef0-49f1-aceb-a02699c7214e	f270fd28-1c02-46bf-ac9c-8179ed1185bb	paul	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/78a63648-9e53-42a9-bc28-6d5a65e05313.jpg	I am a marketing expert who enhances the value of brands through creative and strategic thinking. I have gained experience in social media, content marketing, and market analysis.	withindopaul@gmail.com	2135701746	\N	{consulting,"los angeles"}	2024-10-01 03:51:37	2024-10-01 03:51:37	t	t
df5651e7-ab4d-4b35-80eb-d6b6340b24fc	5dc09e11-8310-4e6b-a8fc-250aadd1e2b2	국제정보보안과학기술인협동조합	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/2bf25184-2b25-41f2-8fb8-9b8d975016dd.jpg	국제정보보안과학기술인협동조합은 정보보안산업체와 연구단체 및 산학연 전문가들이 자주적 자립적 자치적인 협동조합 활동을 통하여 구성원의 복리증진과 상부상조 및 국민경제의 균형 있는 건전한 창조발전을 도모하는 조합입니다.	act2_ljk@naver.com	\N	\N	{}	2024-01-26 02:41:21	2024-01-26 02:41:21	t	t
9550955e-1df7-4b91-9625-9a17e8f14535	ae7ec705-a261-4895-a223-3e6e0b0602b7	주식회사 스카이라이언	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/2c0cad5b-e0e7-43a2-a416-651c8c4d09be.jpg	주식회사 스카이라이언	baekhosadan@gmail.com	\N	\N	{}	2023-11-16 23:24:55	2023-11-16 23:24:55	t	t
1329c18f-2f5e-41c6-9637-5bb3c5563559	e0161890-fc0a-40a7-b14c-0bf1d40cf3d5	송지향	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/f9297ba8-84bb-40da-803b-654543f8d413.jpg	커피숍운영 공인중개사	coollove1999@hanmail.net	1042363545	\N	{비엔공인중개사사무소,옵션스페셜티커피삼성타운점}	2024-02-20 09:25:57	2024-02-20 09:25:57	t	t
024efbe6-b863-4e1d-abbb-38d30fba7e99	3a3e0676-66e8-487f-8eba-e64eefe2bf2f	이정규	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/c9f47034-2c8e-4d3e-9804-bc423cc1038a.jpg	최신 IT 기술과 트렌드에 정통한 IT 전문가입니다. 디지털포렌식, 사이버 보안 분야에서 두각을 나타내며, 디지털 혁신을 추구합니다.	act2ljk@dongguk.edu	01098541730	\N	{개인정보보호,정보보호,포렌식}	2024-02-19 13:47:06	2024-02-19 13:47:06	t	t
c2191a60-6132-4015-80cd-ec1eca5796fa	c2a418bd-aae3-479b-8d28-dc4a3fafb5e4	신철용	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/34c6a4ac-1a19-4584-9a85-9c4606a5e805.jpg	주식회사 마이스소프트 대표이사 입니다. 모바일 서비스에 필요한 솔루션을 개발하여 시장에 공급하고 있습니다.	scrdragon@gmail.com	1097072397	\N	{AI,IT}	2024-03-21 05:27:23	2024-03-21 05:27:23	t	t
09d50faa-f9d2-4b6d-9e98-f19f3c77dc9e	d751f28d-f47d-4486-8ff8-94358cdf53f7	이한섭	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/dfe5fa4e-856c-4df3-b8f4-56fd13664a92.jpg	현대적이고 지속 가능한 건축 디자인에 중점을 두는 창의적인 건축가입니다. 공간의 아름다움과 기능성을 결합하여 고객의 꿈을 실현시키고자 합니다.	3666829644	01037428953	\N	{건축사}	2024-08-16 08:10:22	2024-08-16 08:10:22	t	t
9b5546c9-1bd6-4dfd-8cad-7a6d6cf46f48	7a19a677-5c7e-4efa-99aa-2d7a536f4ba9	User	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/bffa91ab-d1db-4534-b568-28860cedd00c.jpg	I have skills that are useful to the country as an expert. I became a person respected by many people, so I found the convenience of everyday life.	wangsu2566@icncast.co.kr	10-1234-9876	\N	{CSUSB,SCIENCE,과학기술}	2023-12-21 00:46:01	2023-12-21 00:46:01	t	t
028507da-527d-42f6-aab2-3afca77a2673	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	류재길	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/702853fb-7fdb-4e64-a2f6-e8295e52b53e.jpg	잘살아보세	lyoo114@naver.com	01052142273	\N	{네트웍공사,"사무기기(복합기외) 렌탈",전산기기,컴퓨터외}	2023-11-23 08:15:36	2023-11-23 08:15:36	t	t
67722c38-af35-411d-be01-d3f39348c9c6	be269914-8f65-4e4c-b3c5-b02313f8b4ac	영농조합법인 알토팜 	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/82bb2fcd-b5e3-4baa-8cf3-82849b99888b.jpg	이 법인은 속해있는 산촌의 특산물인 사과를 착즙ㆍ포장하는 작은 일을 하고 있으며, 이를 통해 지역 사과생산 농가들의 수익을 증가시킬 수 있는 기회를 제공하고, 소비자들에게는 천연과즙을 제공하므로 건강에 도움을 주고 있다.\n체험프로그램으로 운영되는 김장체험으로 도시민들에게 산촌 삶의 일부를 체험하고, 김장을 쉽게 준비할 기회를 제공한다.	altofarm@naver.com	\N	\N	{}	2024-01-10 10:56:14	2024-01-10 10:56:14	t	t
12c67d93-13cf-4b24-aa80-a4d5b04b39d2	b720f98f-9a0c-43e7-958b-9855a27a7c71	이인호	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/ea8c20a1-d43c-4daf-a3b4-6666af83f664.jpg	전세계의 전자부품을 수출입하여 고객사에 공급하는 전자부품 전문 공급업체입니다.  특히 통신용 부품에 특화되어 있습니다.	21cdcom@gmail.com	01063562041	\N	{"IC,TR,INDUCTOR","Probe Pin","Test Socket",전자부품}	2024-02-21 07:05:00	2024-02-21 07:05:00	t	t
39fb8fb7-b003-47b3-b173-5d77dae94bde	39144bf1-9a12-4d6d-a814-b769473d158f	손상일	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/121ea0dc-f751-4de7-94f5-53cfae760358.jpg	육군 대령  출신으로 정보통신 및 정보보호 분야에서 30여년 이상 근무 / 이학박사 학위를 취득하고, 국민대, 동국대, 세종대, 수원대에서 정보보호 및 IT보안법무를 강의 / 협회, 조합, 연구소, 기업 등에서 임원급 활동	ssidsc@nate.com	1050800007	\N	{"사이버보안 ",정보보호,정보전,정보통신}	2023-12-02 04:29:37	2023-12-02 04:29:37	t	t
9f4c2422-7376-40e9-aff3-3aa3675361e5	9c575b13-2b96-4e73-8ae6-21267b4cf871	김동진	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/6078da68-fb93-4462-b6f9-56b07a3eda6e.jpg	맑은고을 청주를 더욱 맑고 밝게 만드는 시민공유형 사업을 기획하고 추진하는 시민사업가입니다.	3287103065	01044447270	\N	{맑은고을시민행동,삼겹살거리,소통민생특보,"청주 맑은고을"}	2024-01-15 07:22:21	2024-01-15 07:22:21	t	t
b4182813-0bd8-4a09-b2b8-2a1cd096a763	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	youngho lee	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/7b9a62b4-4367-4ce9-83e4-aae73b635ec4.jpg	최신 IT 기술과 트렌드에 정통한 IT 전문가입니다. 클라우드 컴퓨팅, 사이버 보안, 데이터 분석 분야에서 두각을 나타내며, 디지털 혁신을 추구합니다.	youngchow8080@gmail.com	12132661409	\N	{eletric,information,IT,machine}	2024-10-15 23:28:45	2024-10-15 23:28:45	t	t
1c95ce46-6934-4fe3-b66d-4b58744138d8	e68e8ed7-f0d4-4352-b67a-ab5ce4424e42		https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/73d92e29-aed1-4351-ad0c-4c30ab393216.jpg		3206882514	\N	\N	{}	2023-12-02 14:46:37	2023-12-02 14:46:37	t	t
66ac15c4-71f5-48f9-8e19-91efea87a08e	b0f320d1-cdfa-4593-9fd9-9000d07f5fd8	강부열	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/a971c610-f501-4c32-82c0-ed429d08105e.jpg	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	bykang1129@naver.com	1036986697	\N	{상장자문,언론홍보,투자유치,판로개척}	2024-10-03 08:36:28	2024-10-03 08:36:28	t	t
47fe034c-db81-470e-bcf4-5f1f0eed64d0	3ffbd728-c91d-40c5-8bb2-b45e93c1ff6f	이영은	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/fd800180-92a0-400c-ae48-54f9bfd5dc90.jpg	자동화 머신  칩\n센서\nFan	powcom44@naver.com	01052650774	\N	{무역,반도체,수출입,칩}	2023-11-18 05:12:20	2023-11-18 05:12:20	t	t
408894fd-68ed-4086-9f46-b8f281c8924c	4c850cce-3170-46ea-9669-f891b4bad0da	최용국	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/432c31b9-1c60-49e3-9cb1-3d4697494600.jpg	한국언론인총연대 상임회장을 역임 하며, 세계한인언론인협회 취재본부장과 뉴욕일보 한국지사장으로 언론계에 종사 하면서 전공을 살려 창의적이고 전략적인 사고를 바탕으로 브랜드의 가치를 높이는 마케팅 전문가입니다. 션재 한류전문기업인 로드스타코리아의 회장을 역임 하면서 소셜 미디어, 콘텐츠 마케팅, 시장 분석 분야에서 경험을 바탕으로 한국기업의 우수상품을 세계에 알리고 수출하고 있으며, 해외투자 유치에도 좋은실적을 이루고 있으며 국내 지자체와 협력하여 지자체 인구감소로 인한 문제 해결에 최선을 다 하고 있습니다..	3715487782	1040056245	\N	{언론인}	2024-09-22 06:23:51	2024-09-22 06:23:51	t	t
e2711bbe-7c17-40a0-9d70-3f4c816f8737	5ed7695e-c900-4690-ab29-d4ecbc00d945	오건선	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/74967b27-fa44-4f3e-aecf-5781fcc48d82.jpg	주얼리 제조	gstyle2014@nate.com	01088926137	\N	{반지,보석,제천,종로지회}	2023-11-23 08:15:10	2023-11-23 08:15:10	t	t
4ad7fc08-2e08-4841-aadf-c49b4a1adbb0	1e2957ac-522b-4d7a-bc6b-5c33ca78ecde	임장재	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	huaco2019@gmail.com	01041410093	\N	{기전제품,판촉물,휴빅}	2024-02-20 03:56:52	2024-02-20 03:56:52	t	t
7d01dd5d-18fe-442c-b64e-1fa4d2539424	0094d8de-328c-4228-a067-272d7dffcc38	김덕룡 	\N	창의적이고 전략적인 사고를 바탕으로 브랜드의 가치를 높이는 마케팅 전문가입니다. 소셜 미디어, 콘텐츠 마케팅, 시장 분석 분야에서 경험을 쌓았습니다.	3745309369	01086554255810	\N	{"진솔바 "}	2024-10-12 02:50:44	2024-10-12 02:50:44	t	t
0490430f-51c1-4840-b6b3-49dfb243c823	c98860ad-4d36-4b3d-9110-264a82401517	김길수	\N	케이티 핸드폰 대리점 22년      취급품목 핸드폰 패드  인터넷 iot 등 유무선통신기기  전문입니다	3443225545	1030023579	\N	{iot,인터넷,패드,핸드폰}	2024-04-18 10:44:30	2024-04-18 10:44:30	t	t
3408c9f8-1b47-4abe-b3af-0f0fd2565b2f	13de37b2-470c-4277-8b22-b40bbb026a2a		https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/5624c30f-8d6a-4d8a-ba4e-84de10c0b574.jpg		3202797635	\N	\N	{}	2023-11-30 01:47:33	2023-11-30 01:47:33	t	t
bfe96a6d-345d-4093-924d-84c10fca6123	b6fefa89-914a-4a89-bda8-e03a77dfbba2	윤갑근	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/4e677dee-de58-4f0c-b338-881ecf496c75.jpg	윤갑근청주시상당구\n국회의원예비후보 \n국민의힘 전 충북도당 위원장\n법률 분야에서의 깊은 지식과  실무 경험을 바탕으로, 복잡한 법적 문제에 대한 명확하고 실용적인 해결책을 제공합니다. 상업 법률, 지적 재산권, 민사 소송에 특화되어 있습니다.	ykkmape@naver.com	1046896575	\N	{국민의힘,"국회의원 예비후보",변호사,"청주시 상당구"}	2024-01-15 04:41:44	2024-01-15 04:41:44	t	t
b27a276b-b093-443b-91fd-22d71d273379	62ee5b22-cd13-4cb1-bdcf-f2976f9328fd	신관숙	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/faf5c269-f962-4127-abe5-ed9ad90647dd.jpg	창의적이고 전략적인 사고를 바탕으로 브랜드의 가치를 높이는 마케팅 전문가입니다. 소셜 미디어, 콘텐츠 마케팅, 시장 분석 분야에서 경험을 쌓았습니다.	sw-rose@hanmail.net	01031568630	\N	{"건강보험료 ",보험,자동차보험,"현대해상 "}	2024-03-15 10:22:55	2024-03-15 10:22:55	t	t
b56ba2e3-8cf5-4c13-af77-66309807c83e	7258a2ce-894f-4ce1-a260-84a7452f4d22	이윤경	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/bc887322-ce18-42fd-a0dd-334aa1770e6d.jpg	감정과 이야기를 시각적 언어로 표현하는 전문 예술가입니다. 다양한 매체와 스타일을 실험하며, 창의력과 예술적 통찰력을 공유합니다.	rebio@naver.com	01077717693	\N	{메디컬,소재기술,아트테크,하이테크}	2023-11-21 05:24:57	2023-11-21 05:24:57	t	t
d6e62e2a-5612-4713-90f8-360679daf0ee	481f84ac-0826-476a-8bf5-7ebf33a13fc5	장재석 	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/93bee4d0-59a3-44f4-b888-765378d7be06.jpg	시디즈 듀오백 파트라 베스툴 전문점          사무용가구 사무용의자                           쇼핑몰 www.beroso.co.kr 	fur1199@naver.com	01090314411	\N	{사무용가구,"사무용의자 ",시디즈,퍼시스}	2024-02-21 06:10:06	2024-02-21 06:10:06	t	t
24740f24-84c1-4c34-b0fb-1cae5ba653bf	a3135e59-6d69-4b85-aba6-44192a01ccbc	김진우	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/804e73ba-7dd1-46de-95d7-64cd6eb4ccbb.jpg	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	jshalal@naver.com	1051213223010	\N	{관광,무역,인증}	2023-11-27 10:06:19	2023-11-27 10:06:19	t	t
243b376b-b99d-4669-ada2-8cef16c93909	c6872d71-bd61-4a1a-bcdb-ba79f37b1283		https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/283a7b46-2efc-47f5-8003-a79b97eb60ee.jpg		3247534905	\N	\N	{}	2023-12-30 01:40:33	2023-12-30 01:40:33	t	t
f0c644ba-d285-43f5-8318-13e593ec2c53	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	최대원	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/5e87ab96-bd26-45aa-beb2-04db78318215.jpg	인테리어 관련 원상복구공사와 철거 구조물 해체 전문으로 소독,방역,준공청소 영역까지 확대 예정입니다	himchanpnd@naver.com	01042568787	\N	{원상복구,인테리어,철거,폐기물처리}	2023-11-23 08:15:39	2023-11-23 08:15:39	t	t
400fc582-65d9-41bb-b8c9-8f08655b61dd	3970a38d-c005-44fe-9b79-e89b7b8a5ea5	이승엽	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/0bd5fc7d-3395-4395-aa15-31e59054e5d7.jpg	성공한 기업보단 소중한 기업을 만들어가는 제이디메디컬입니다.	jdmedical337@naver.com	01084887111	\N	{병원컨설팅,안과,의료기기,헬스케어}	2024-02-21 06:10:16	2024-02-21 06:10:16	t	t
370e2a14-3f92-438e-8baa-6feca14be40c	50d29d7c-59ad-4e31-a3d6-10dcba8aac51	arjay millarada	\N	I am a professional artist who expresses emotions and stories through visual language. I experiment with various mediums and styles, sharing creativity and artistic insight.	rjmillarada0@gmail.com	9155306548	\N	{54321}	2024-03-14 18:06:49	2024-03-14 18:06:49	t	t
79b25163-4bc3-4efa-9405-97946b80356e	77b4ebfa-74e3-42b8-ad8d-d363edac853c	PARK MANDALL 	\N	최신 IT 기술과 트렌드에 정통한 IT 전문가입니다. 클라우드 컴퓨팅, 사이버 보안, 데이터 분석 분야에서 두각을 나타내며, 디지털 혁신을 추구합니다.	mandallp@naver.com	01048378880	\N	{MDP}	2024-03-25 05:58:41	2024-03-25 05:58:41	t	t
792fbdfe-1d0d-49f2-b486-0d8b394dd19c	a7d213e7-d304-4dd2-8cc3-3fa811ef6036	최경숙	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	5-ogam@naver.com	1062540994	\N	{의류}	2024-03-25 11:35:11	2024-03-25 11:35:11	t	t
8a742c7d-ae21-4f42-bf77-709c31dbc3de	eab0bcf1-82f3-40db-82fb-ace10ee4a383	손민재	\N	감정과 이야기를 시각적 언어로 표현하는 전문 디자이너입니다. 다양한 매체와 스타일을 실험하며, 창의력과 예술적 통찰력을 공유합니다.	edwin0424@naver.com	1091735306	\N	{gui,ui,ux}	2024-10-02 00:45:46	2024-10-02 00:45:46	t	t
0b7a6767-f1b4-4b87-9522-fda179495133	d745dfe7-443b-4cee-9e17-e01f01880878	Emmanuella	\N		emmanuellaomorodion56@gmail.com	7038682403	\N	{123456}	2024-11-13 02:47:54	2024-11-13 02:47:54	t	t
70b0a54f-3bde-4b33-9c67-df52fbd2d0cb	bc27b7f0-3bff-47ca-8876-97151f97b2a7	이재호	\N	혁신적인 기술 솔루션을 개발하는 데 열정적인 기계 엔지니어입니다. 지속 가능한 설계와 효율적인 프로세스 개선에 중점을 두고 있으며, 새로운 기술 도전을 즐깁니다.	oilgate@hanmail.net	01047683396	\N	{해피셀}	2024-03-26 12:52:01	2024-03-26 12:52:01	t	t
eb0d823a-9bd5-402a-9380-425ca43b91cc	c8bcb4ae-3a32-4ffc-a896-9f7221ae11d7	phúnghĩa	\N		honguyenhaphuong.12213@gmail.com	3256710084	\N	{63}	2024-04-05 07:20:24	2024-04-05 07:20:24	t	t
c01e5e85-b4c4-4269-ac39-c8ab3866f2f5	4ca77b2f-5b11-4d04-af2a-d4a74adbd726	김현수	\N	최신 IT 기술과 트렌드에 정통한 IT 전문가입니다. 클라우드 컴퓨팅, 사이버 보안, 데이터 분석 분야에서 두각을 나타내며, 디지털 혁신을 추구합니다.	minilock0730@naver.com	01074743615	\N	{엔지니어링}	2024-05-07 04:47:38	2024-05-07 04:47:38	t	t
aed2745c-e74f-4e36-964c-cb4f1155bda7	60c80b7f-06ff-4c7c-963b-f9c4d0c62cb3	최성희 	\N		choish129@naver.com	01026852755	\N	{건강}	2023-12-24 02:28:42	2023-12-24 02:28:42	t	t
56248e43-bdc4-474c-9088-e59bbf7f6dcd	48101c5e-8026-4206-9b7e-bb3c01018b75	백상현	\N	법률 분야에서의 깊은 지식과 7년의 실무 경험을 바탕으로, 복잡한 법적 문제에 대한 명확하고 실용적인 해결책을 제공합니다. 기업 법률 자문, 지적 재산권, 소송 등에 특화되어 있습니다.	sanghyun.paik@hylaw.co.kr	1087283383	\N	{민사,법무,변호사,상사}	2024-02-26 11:29:54	2024-02-26 11:29:54	t	t
e7e08f58-98f8-49b0-baf1-084b7cec3b9e	3f5d7d88-4e88-4702-b00b-882f8c113729	국승호	\N	현대적이고 지속 가능한 건축 디자인에 중점을 두는 창의적인 건축가입니다. 공간의 아름다움과 기능성을 결합하여 고객의 꿈을 실현시키고자 합니다.	rnrtmdgh1111@gmail.com	01057022875	\N	{건축}	2024-09-10 09:23:01	2024-09-10 09:23:01	t	t
411b0e6d-d0a2-4689-99ac-94578303ea47	870f1c96-feab-4030-a0eb-c7aaa005248f	Joseph Kim	\N	학생들의 가능성을 최대한 발휘할 수 있도록 돕는 열정적인 교사입니다. 혁신적인 교육 방법과 기술을 통해 학습 경험을 향상시키고자 합니다.	young10201948@gmail.com	93107023223	\N	{LA광명교회,목사}	2024-10-15 23:44:58	2024-10-15 23:44:58	t	t
b136a18f-a711-438e-b8c8-77e041b9635f	09c032d0-cae3-4508-a75f-f6fd9730c14b	이정야	\N	전통과 혁신을 결합한 요리로 사람들의 마음을 사로잡는 프로페셔널 셰프입니다. 맛과 건강, 미학이 조화를 이루는 요리를 추구합니다.	ball1119@naver.com	01022718600	\N	{요리사}	2024-04-03 06:08:11	2024-04-03 06:08:11	t	t
18d3ce69-424b-414f-95ad-9528755a1fdf	d3aead05-5719-4e8b-b40e-3850f87f4f13	bittu mukherjee	\N	I am a marketing expert who enhances the value of brands through creative and strategic thinking. I have gained experience in social media, content marketing, and market analysis.	mukharjeebittu0@gmail.com	7718691167	\N	{336157}	2024-07-11 08:20:12	2024-07-11 08:20:12	t	t
1472c0b2-4005-4897-97ea-5f66be50d6ce	03486acc-4946-4fb4-8df7-ed3c4ab9716e	서길원	\N	통신 서비스	3390105080	01037706259	\N	{SKB,회사}	2024-03-15 09:15:24	2024-03-15 09:15:24	t	t
cf5dee58-67a5-4222-82c6-627bafdcdfce	7b962db5-8fc5-4b0f-82ea-4c3728add8a5	Lilibeth Cabigo Diocson 	\N	I am a marketing expert who enhances the value of brands through creative and strategic thinking. I have gained experience in social media, content marketing, and market analysis.	hxhh4286@gmail.com	+639310625936	\N	{"Banana 🍌"}	2024-04-04 05:11:11	2024-04-04 05:11:11	t	t
c4b72f51-d669-428f-bf51-30a243a8086b	33e4fe8e-974a-48cd-ab78-22dd2e3155ad	d.iaineh ryngnga	\N		diainehryngnga@gmall.com	9863244017	\N	{iaineh}	2024-05-24 12:01:24	2024-05-24 12:01:24	t	t
fd8da4c3-3b99-4a62-bcd7-7f9162d9e260	0450904b-3317-451f-86fd-9e606db4186f	이문원	\N	절세의 노하우 절세귀신	eava21@daum.net	01093209515	\N	{법인세,상속세,세금}	2024-02-20 09:26:17	2024-02-20 09:26:17	t	t
e15e276b-ca9e-429b-80ad-ee1dac16813c	6ed9c1d5-d62c-44ac-b999-1ea238f6f7a4	이연주	\N	전통과 혁신을 결합한 요리로 사람들의 마음을 사로잡는 프로페셔널 셰프입니다. 맛과 건강, 미학이 조화를 이루는 요리를 추구합니다.	Telimy@hanmail.net	01023708286	\N	{요식업}	2024-03-13 09:20:11	2024-03-13 09:20:11	t	t
214e079c-777a-4385-93bd-7c6384699a49	c17ad9e2-f932-4dd7-950a-2bb25a9b0772	SAM UEL KANG0	\N	창의적이고 전략적인 사고를 바탕으로 브랜드의 가치를 높이는 마케팅 전문가입니다. 소셜 미디어, 콘텐츠 마케팅, 시장 분석 분야에서 경험을 쌓았습니다.	samuelkang213@gmail.com	2132638303	\N	{"애국자협회 ",여행,"음악 "}	2024-11-01 00:10:41	2024-11-01 00:10:41	t	t
16cbcbe3-1d51-40f1-b029-9d139726a40a	5efc6baa-40ff-406f-aab6-3cd7e48a7f26	김혜경	\N	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	hyek8700jj@naver.com	01089278700	\N	{귀금속판매}	2023-11-23 08:37:08	2023-11-23 08:37:08	t	t
2559b4fb-f1d3-4c33-b7c7-4be4f616277c	bd389783-9d15-4d6e-a184-5e5f04282628	조미경	\N		hub0633@gmail.com	01049240633	\N	{주부}	2024-05-16 23:28:51	2024-05-16 23:28:51	t	t
b11443d5-88a3-420d-9d0b-db990e663073	b9325221-963e-4909-8a81-6d00f3b1e7e6	박나연	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/99da31eb-76a0-4519-9b7c-ac581f49a83c.jpg	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	sumimaya@naver.com	01099493572	\N	{CEO플랜,보험,인력파견,자동차보험}	2024-03-20 12:10:06	2024-03-20 12:10:06	t	t
944f2d03-9c0d-40eb-8acf-e3cb2f03fb91	317cf77d-0e89-49b2-82f0-b20073914c0c	김명식	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/1a0115e2-b69d-4246-8437-3440d27be1c9.jpg	뉴욕일보 기자	petersplan@daum.net	1097619717	\N	{기자,뉴스,뉴욕,한류}	2024-09-20 05:16:32	2024-09-20 05:16:32	t	t
7bd3f613-e8c7-44ef-914f-c454d634d3b7	4742c248-e7ae-4e74-b513-a66f6f86a66f	남성우	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/c80a084c-8812-485e-b4cb-839cbed2865f.jpg	*거위털제품 컨설턴트\n*차가버섯 전문\n	jssupply@hanmail.net	01037077016	\N	{"거위털이불 패드",스님거위털옷,스님전용신발,차가버섯}	2023-11-23 08:15:33	2023-11-23 08:15:33	t	t
577e376e-f869-43c7-98e0-334acbaa14c2	e667a7c4-c9a8-4e66-9401-ac2577b19aec	박병각	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/466f2ab7-3627-4e7f-a458-3a57ce7a3d79.jpg		altofarm@naver.com	01052453888	\N	{ESG,귀농귀촌,산촌,유기농}	2024-01-15 01:02:33	2024-01-15 01:02:33	t	t
cfaf1e00-b4e1-4368-8715-ad00f90cde9a	a1d9d15d-9674-4992-a112-44dbb8d0dff4		https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/4bb3e2d7-4cbb-46b3-9548-b8fbf15b5388.jpg		4freemoneys@gmail.com	\N	\N	{}	2023-11-19 09:43:07	2023-11-19 09:43:07	t	t
f2a974c7-c918-48f8-a476-992f9d5a007f	c1667389-c459-4ecc-a759-cd2b0d69d687	박선옥	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/42951817-0f7a-41ae-a3d2-f76593ddfc42.jpg	- 미래융합기술경영학 \n- 블록체인기술 활용 플랫폼 개발\n- 기술.경영,각 분야 전문가마이데이터 \n[구독알림.전자신분회원증.전자지갑]\n	sunouk5281@naver.com	01064266641	\N	{"미래산업육성 농촌이 답이다.",미래융합기술경영,블록체인기술,"어플 프로다오"}	2023-11-15 08:38:04	2023-11-15 08:38:04	t	t
f1717448-77eb-4c37-93f6-d1a17f80e208	19ab8ef6-2d97-43c6-9b8d-d8763bab7242	원혜숙	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/7674163e-ea83-4137-96ad-2414a36d4966.jpg	글로벌 Biz센터중역,Founder\n글로벌Prodao 센터지원중역\nSMQI부원장,EKNews MKG.\n지식서비스&컨설팅대학원,ESG\n ISO9001/14001/45001국제심사원\n(PA)및 컨설턴트\n ESG,마케팅/유통전문가등\n	hl1axp@daum.net	01092893373	\N	{"DAO 센터,PRODAO","ISO,ESG","마케팅,수출,해외진출",컨설팅}	2024-01-11 05:23:48	2024-01-11 05:23:48	t	t
0706b4be-5247-4a1d-a057-e53ff6796054	c583a589-c6c8-4cfd-9470-d0a445109ef9	주식회사 테크코드	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/3f929445-dd3e-4024-852e-ae50bc59a7c5.jpg	이차전지 배터리관리시스템플랫폼 전문기업주식회사 테크코드	dgkang@techcode.co.kr	\N	\N	{이차전지}	2023-11-28 01:36:10	2023-11-28 01:36:10	t	t
042e4c00-507e-48b7-a77a-2bf2ebc86304	a1980849-8063-40f4-93e8-4de3842911b0	사단법인 도전한국인본부	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/611349c7-35de-43ee-ae8e-7d37396b03d5.jpg	사단법인 도전한국인본부	choyk4340@daum.net	\N	\N	{}	2023-12-01 03:18:33	2023-12-01 03:18:33	t	t
e54fa05a-9b7e-41b8-bae7-7375e6b94fbe	dab9453b-a30d-44ec-a414-132e953c2408	테스트기관	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/4177e9ec-2278-495b-9d8a-2d8fe6f2e2dd.jpg	Welcome! On the official channel of the National OO Science Institute, we share the latest research results and scientific discoveries related to environmental protection and sustainable development. Join us in our efforts for the betterment of the planet. Our research provides insights into climate change, ecosystem preservation, and environmental policies, exploring ways to improve the Earths environment.	icncastcw@gmail.com	010-1234-5678	\N	{MyData,"AI exercising",Blockchain,Deeplearning}	2023-11-13 01:49:29	2025-02-24 16:40:33.17	t	t
17de6ad0-e05c-40e6-aa3e-33e9bd0cf9ca	8a5b931e-b073-4af9-a916-4b214183a825	KWON ILSUP	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/f4f9b01c-30ec-47c7-bfd0-fa176bbe43d5.jpg	비전을 현실로 만드는 데 탁월한 능력을 가진 자립경제 프로젝트 컨설티드입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	ourbizstory@gmail.com	1077148289	\N	{비트코인,암호화폐,재테크,투자}	2024-12-19 08:38:50	2024-12-19 08:38:50	t	t
8434778e-8b3d-4075-adbc-78f6d492d775	679443db-8000-4a0b-9fda-92d3e021a062	안규선		전세계300곳의글로벌Dao/Prodao센터구축후 글로벌비지니스활성화추진.2028년도매출3천억달성목표2033년 매출10조목표로추진중	smqi9000@daum.net	1090067000	\N	{ISO컨설팅.인증.ESG경영.안전보건.중대재해처벌법,마케팅.수출지원(온라인.SNS등),생산.제조.경영.창업지도.영업.유통지원등,자금투자유치.정책자금.R&D자금.창업자금등}	2024-04-03 12:28:58	2024-04-03 12:28:58	t	t
65b4ee98-d72c-4d74-99c8-b0550ac67c1e	9895ba06-7ac4-44a6-987d-6595615801f3	owbdgdhdidvfoeifhvchxucbhx	\N	I am an experienced internist with over 10 years in the medical field. I prioritize patients health and always stay informed about the latest medical research and treatments. I look forward to sharing knowledge for a healthy life.	gandalianne5@gmail.com	3164955356956.908N31464989897	\N	{pebfhfidhfhyxkdhfv}	2024-04-16 13:06:56	2024-04-16 13:06:56	t	t
d61e0ec9-26a3-4d61-9f78-0be4b6bca64d	2c161160-a3de-4af8-b178-11700da1ed54	shivprakash Saini 	\N	मैं एक उत्साही शिक्षक हूं जो छात्रों को उनकी पूरी क्षमता महसूस करने में मदद करता है। मैं नवीन शैक्षिक तरीकों और प्रौद्योगिकी के माध्यम से सीखने के अनुभवों को बढ़ाने का लक्ष्य रखता हूं।	shivprakashsainisaini@gmail.com	9610141053	\N	{boolie,"Lakhimpur ","saini ","shivprakash "}	2024-07-10 15:55:29	2024-07-10 15:55:29	t	t
29d3aebc-d881-4e0e-8928-540263d58503	0cab1976-8937-46ee-8a8d-9e3d831d258b	김희원 	\N	전통과 혁신을 결합한 요리로 사람들의 마음을 사로잡는 프로페셔널 셰프입니다. 맛과 건강, 미학이 조화를 이루는 요리를 추구합니다.	3363081423	01077221673	\N	{건강}	2024-02-26 11:31:06	2024-02-26 11:31:06	t	t
e3bac4c3-e18f-4b94-8ef8-f9c7b3c98d0d	5ddcc4e4-ee30-48b1-939a-09439b14e6dd	pacocastrellon	\N	I am a marketing expert who enhances the value of brands through creative and strategic thinking. I have gained experience in social media, content marketing, and market analysis.		2139247967	\N	{"Héctor "}	2024-10-15 19:24:15	2024-10-15 19:24:15	t	t
04db0e98-7cee-4b07-a058-cfdc9ec26d8e	5ceefda3-21ca-41e9-8280-66b5b8805e4a	Ernest Angelo babagay 	\N	maritime 	akosiyorie@gmail.com	9935965899	\N	{gengge,hakdog,huhahaha,snoop}	2024-03-26 11:25:40	2024-03-26 11:25:40	t	t
e970f004-af21-4dec-b3be-e67318cd564f	a1468102-4c03-47f4-a390-cc625f636017		\N		3206687463	\N	\N	{항노화}	2023-12-02 12:10:57	2023-12-02 12:10:57	t	t
92aecc7d-0a7d-40e7-a80f-aa344b996f68	f3173f6b-71d2-47c1-9768-4ed28d2ee620	신안경영품질원	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/c887ee45-41c4-4304-8c89-c3816f8a0f19.jpg	신안경영품질원은1999년3월설립후약25년간국내.해외기업.기관.지자체.그룹사.중소기업.창업기업.대학BI등2000여개이상 마케팅.수출.자금투자유치.창업,STARTUP지원및ISO.국제안전보건중대재해대응시스템.해외규격.ESG경영.지속가능경영보고서.정부R&D정책과제발굴지원.100여개국 해외진출건등컨설팅자문.교육등을추진한실적을보유한 기관임	smqi9000@daum.net	\N	\N	{"ISO9001,14001,45001,ESG,중대재해처벌법등","경영.창업,종합컨설팅.자문및 교육.강의","자금투자유치.정책자금.M&A,Funding","해외바이어발굴.수출,마케팅.판로개척"}	2024-03-21 05:32:21	2024-03-21 05:32:21	t	t
bf213daf-808c-4707-ac4e-37a74db0e68f	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	영재산업	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/a52a3891-bfa0-4587-a75e-33c795bfd19f.jpg	영재산업: 다회용기 세척\n              전문 렌탈\n              장례식장\n              지역 축제	mhpaak@hanmail.net	\N	\N	{"다회용기 렌탈","다회용기 세척",장례식장,지역축제}	2023-11-24 03:34:41	2023-11-24 03:34:41	t	t
e08ee564-a792-4d3e-b775-5ca9be49ed16	835889ef-7e95-4dc9-9930-c517ec555496	고려물산	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/8b320f7b-6f63-4197-8f07-c6f761a181e0.jpg	맞춤형 의료기기 납품\n오픈병원 컨설팅	sunouk5281@naver.com	\N	\N	{병원,병원컨설팅,약국,의료기기납품}	2023-11-22 02:32:35	2023-11-22 02:32:35	t	t
fe5ed374-4adf-4c4e-a9c8-11ea9c391336	f3a78141-9a77-4b27-998d-d2b4d366e088	yun hee kang		Bank Branch Manager	3761593346	3233834449	\N	{"Branch Manager (대출상담 통장개설)","Los Angeles","Orange County","PCB Bank"}	2024-10-22 20:08:39	2024-10-22 20:08:39	t	t
34bc6839-8316-41e9-8571-1f032b5c2792	454a1603-bd8c-4a65-a89f-b8cedd28dd76	ON SAFE STATIONS CORP	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/fb948de3-d6d4-4e23-abd6-faabf3c13d09.jpg	전세게(prodao)미주 지역센터 관계자로 북미지역과 남미시장및 캐러비안연안국을 연결하고.각지역의 투자유치와 글로벌 제휴확대룰 통한 각지점의 비지니스지원등......	withindopaul@gmail.com	\N	\N	{"광고및 마케팅",영업지원,"투자유치및 지사오픈"}	2024-10-19 09:50:31	2024-10-19 09:50:31	t	t
709a2709-d788-45c0-977c-0c66b368a390	8b4f4e5f-3cf7-4790-ad3b-90f52d6c381b	남기섭	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/cd566101-8112-43c8-bfda-11d385463941.jpg	강화도어수리 전문가	3216712228	01086928572	\N	{"강화도어수리 ",문고장,문출장수리,유리문수리}	2023-12-09 10:01:55	2023-12-09 10:01:55	t	t
10262db9-3b30-4bb4-9680-91a4b1f9d7c8	1b4707dd-eaff-4276-8e8e-2c25fccd068d	강길주	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/fdbb07e6-9cc8-4dec-8d4e-9f634d7d51d9.jpg	비전을 현실로 만드는 데 탁월한 능력을 가진 사업가입니다. 혁신적인 아이디어와 강력한 사업 전략으로 새로운 시장을 개척하고 있습니다.	kang8742@naver.com	01043428742	\N	{보안}	2024-06-26 03:45:18	2024-06-26 03:45:18	t	t
f6298326-d71c-4799-b25c-0512d4d12357	c88e824b-4488-4d90-a69c-cfb61fbe4791	구은제	https://prd-prodao.s3.ap-northeast-2.amazonaws.com/profile/4adc5b9a-cbeb-47d1-944a-48ef8a24eb82.jpg	대중문화의 아이콘으로서, 연기와 음악 분야에서 다방면으로 활동하며 팬들의 사랑을 받고 있는 연예인입니다. 새로운 도전을 두려워하지 않으며, 예술을 통해 사람들에게 긍정적인 영향을 끼치기 위해 노력합니다.	kudosa@naver.com	01056065774	\N	{Ai작곡편곡강사,가수,작곡가,편곡가}	2024-09-30 04:00:45	2024-09-30 04:00:45	t	t
\.


--
-- Data for Name: persona_subscriber; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.persona_subscriber (id, persona_id, subscriber_id, is_paid, status, created_at, updated_at) FROM stdin;
b27a662e-30ed-4766-9118-c6164a798d8b	c1667389-c459-4ecc-a759-cd2b0d69d687	be269914-8f65-4e4c-b3c5-b02313f8b4ac	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b099c1f2-237f-43ce-b81e-3d304fe20625	8fd92c37-ee30-48c5-9758-5b27c3768deb	835889ef-7e95-4dc9-9930-c517ec555496	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
ef646709-0d85-4ed6-ac39-f2cd5528668f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	835889ef-7e95-4dc9-9930-c517ec555496	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7cc0f784-a590-49e3-9841-bafbdc0d0c35	8b9c80e4-3072-4dab-85a6-36e310fae6ef	012e0de3-ba65-4fd4-9a9a-f127d09672aa	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e9b287eb-1db3-40be-9c51-189c02ea2eb8	dae9be5f-69f8-4aba-8707-3974bd4edf02	28058267-5877-4bc2-a880-395176bd6b22	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
9bde1220-d9d2-4645-9d57-87a15490c346	75bc07bb-6b7a-4414-b064-9f0f7c086217	28058267-5877-4bc2-a880-395176bd6b22	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
9e745793-9314-4863-8c33-b84f8ec0da4a	a6138b49-27ca-485f-ad57-12f6ed08e94b	28058267-5877-4bc2-a880-395176bd6b22	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7b81a7d5-4235-4fde-a69d-82de453f1b21	4742c248-e7ae-4e74-b513-a66f6f86a66f	28058267-5877-4bc2-a880-395176bd6b22	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7fd515b0-cdc6-4f06-8ff7-4b70bab9384a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	7e2a2c9f-ceee-43a9-8c22-b0e99af67bf0	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
4f28fd31-2438-4ac9-a1ad-6c9975a511de	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	8812812f-8bbf-4ae2-914a-b8cae24cdbcc	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
f32c5205-f386-4406-a806-81cf12417e6d	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	5846ade9-c2a3-4042-b036-4a0e3e88a907	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
58318c5c-b315-4264-93b3-3ae0094664e6	29a63532-c5b1-4ebb-bba4-9a22abdd986c	3e969c04-e8bf-4376-a556-2a039627e19f	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
1a82a63d-5583-4c34-8380-c037ce22cfaa	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	a9a5f83f-167c-4e62-b4f0-ed7a123d3990	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
d50e039e-5e49-4252-b401-2bc8f99c7459	583dcdbe-fbdd-4ecf-800d-831c7f7716f9	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
d8212d47-40b2-4d62-9fda-1a0adf41c416	1e2957ac-522b-4d7a-bc6b-5c33ca78ecde	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b7986f50-4800-4254-bac1-c87e6bb6d678	c662510d-a483-4da8-b9c4-96f2bb450a40	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b7bc04e4-2ec6-4eee-bf8b-bc0c0bc68eb2	728cb098-b1db-410e-94a4-d08a630d8076	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
47da8d1a-afe6-472e-a1cc-e48c1a4df367	c2d8d0d1-43dc-4d39-9170-071ff5bf0cb2	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b25dabbd-29bf-47b0-b749-e745d987dde1	5efc6baa-40ff-406f-aab6-3cd7e48a7f26	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7e944e63-9381-4fbb-b2bf-a4e2ca40ad47	dae9be5f-69f8-4aba-8707-3974bd4edf02	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a958fda2-1332-4293-955c-5840327844a9	fb06de97-b722-4281-99cf-482d421bd4b0	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
5b310ba8-0c9f-48d6-babc-47e99aef12d2	75bc07bb-6b7a-4414-b064-9f0f7c086217	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
fcd68c26-36cb-490d-bf5c-48a0df11bd3a	a6138b49-27ca-485f-ad57-12f6ed08e94b	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
960c04ca-d1aa-4783-8b3b-6038dfa79e18	db049daa-59cb-425e-bdd9-c6dbbdff5b95	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
fbda09b0-438a-4f84-99d6-799dfc2562f3	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
2da1fc1c-6dfe-4f33-a759-640e23be5f4a	3ffbd728-c91d-40c5-8bb2-b45e93c1ff6f	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a822a0b6-7b9b-4aba-b38d-a79aa8c3a407	a5375a3b-6bcf-4d38-ad41-d0f132461966	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
bc4410c3-6b28-4388-9bf1-c47b02f5394a	ceb2e076-e8e4-4f5e-a944-e1d423c62834	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7ad3f43c-3fee-4b67-af20-1ad53da9930c	5ed7695e-c900-4690-ab29-d4ecbc00d945	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
f36d7ae4-9821-4b9a-800e-2bcedfe35e68	481f84ac-0826-476a-8bf5-7ebf33a13fc5	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e9436888-e108-4307-bc74-326cc9bfee54	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
0bfc3ca3-7941-4d84-91d2-6c930ec6fa70	3970a38d-c005-44fe-9b79-e89b7b8a5ea5	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
fade0949-7e5a-4f98-976a-106bde8cff45	b720f98f-9a0c-43e7-958b-9855a27a7c71	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
158df658-5d60-4e0d-ae9a-dcf324fa6d89	82897173-7157-4508-9557-9e6700c0dc4d	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e1c8afdf-3e05-436c-864d-51f174694c3a	42e3166f-a80a-4120-b00f-22224f3248b1	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
5610ed02-35dd-42f4-8912-828e5c79b6ce	eccfca5a-fe79-422a-86a9-00514d1a84f9	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e5bcd4c5-bcf7-43b8-bb36-331b5179981e	87b40694-4414-4841-925a-176a00c7826a	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
ea316eff-0d34-4f33-b3db-0ad5e992afe5	04383a3e-b5cf-4875-99a7-fdd746e9cab0	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e754c562-bb89-4611-bb00-da72ce2ba6c7	04c83856-9ff0-475a-b2cd-db05406b84a3	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7b17286b-7d0d-4cb9-a3cd-ea0a31daf81f	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
bc2fbf89-6602-4826-9f0e-0754fa1d765f	b370e760-5bed-4ade-8488-fe7c4c972e04	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
f9b60ed7-aba3-4595-b3c2-986ad1e1cc84	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
da900415-469b-463b-b850-59dff0ef9ec3	b9325221-963e-4909-8a81-6d00f3b1e7e6	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
1453fd04-ffe0-4c52-823c-dd6e562e26b3	77d688de-9a29-4e5f-a453-9479a9fd7f8d	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
8fc02533-2c99-4645-b6af-d85ff849b92a	28058267-5877-4bc2-a880-395176bd6b22	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
61d773bf-59ba-44f0-9765-a0ed97f52e27	5b316a00-25b2-4fd7-8796-5dbb7f51f948	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a5d1838e-00b5-4ff0-a9db-ccba434af04b	dae9be5f-69f8-4aba-8707-3974bd4edf02	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
07612c38-ebff-4486-8e97-4a39b84c09ec	82de6c86-64f8-4b2f-afb3-ad42f3064102	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
1519147b-13bb-4db6-afb6-2f2d50f35c53	76437582-061c-4b94-9873-a4e3b6b8c787	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
427e6829-fd9c-45e6-a117-16c61f67b7b7	36fa3c27-a0c6-4407-a386-a0b57cbbd453	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a9d20999-31ee-4a2d-b6bf-20c84af1689a	fb06de97-b722-4281-99cf-482d421bd4b0	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
1bb8deb2-4044-4445-a3e9-e95c8ed60e25	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
58369a9d-62cc-40c2-8d88-aa341df92e8f	6c50a910-149e-4247-af57-91342ca69c26	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e2afa94b-4955-4dc4-86e8-023bd38b3d41	a6138b49-27ca-485f-ad57-12f6ed08e94b	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b68e7809-b2ef-4b95-a64f-26156c1f26b2	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
5a430bbe-0cde-4ade-ac72-e3a8c8da517d	5ed7695e-c900-4690-ab29-d4ecbc00d945	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
fd8a3db9-4173-46c2-aae5-1019c34d495e	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7530c2d1-1612-4ca4-a11b-e238dd459944	42e3166f-a80a-4120-b00f-22224f3248b1	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
8cc1eb60-4f08-4cb6-9786-ad348b020bb8	87b40694-4414-4841-925a-176a00c7826a	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
70d191e6-cb8f-45fe-b2b5-ed2c6017cd76	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
3f700b44-584d-467d-8cc1-06a183b4f610	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
8bd5f88d-846b-4227-b416-0dee35d144f8	4742c248-e7ae-4e74-b513-a66f6f86a66f	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
09a8a7a3-4934-4c5b-b9a2-d1e4b7d52dfe	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b9ab2de2-5c79-42df-9618-5cb41c0574cc	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	5431a241-78ce-4b21-b128-28dea9f8fae9	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e41b8b57-7b28-4811-9105-818539072479	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c53ce851-fa9d-41ad-a7e1-416cb7b166fe	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
d65f0115-5ca6-4b5b-b45a-b9323e221c78	82897173-7157-4508-9557-9e6700c0dc4d	c53ce851-fa9d-41ad-a7e1-416cb7b166fe	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
c847a099-6599-431a-ae0a-5899ab4faad7	48d1c50e-0ed4-4355-8b30-37ed358badcc	c53ce851-fa9d-41ad-a7e1-416cb7b166fe	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
9d10760a-902c-453a-a9c2-dc5f29b8bd88	b9325221-963e-4909-8a81-6d00f3b1e7e6	c53ce851-fa9d-41ad-a7e1-416cb7b166fe	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
cde6bc47-d21c-4ec3-98eb-38f3f0830eb2	a8af0e64-0ac6-46fb-99f1-6da08eeab725	f3173f6b-71d2-47c1-9768-4ed28d2ee620	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
44a5b13e-ba7f-44f8-ba2b-ec341b768873	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	f3173f6b-71d2-47c1-9768-4ed28d2ee620	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
49989688-343b-46a8-b9d4-37b8991f2c99	5e837acd-dae2-4186-b57c-ae70ee945f8a	f3173f6b-71d2-47c1-9768-4ed28d2ee620	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
3e3ed451-06d2-4729-a564-16fc49d0c09d	36829335-1ae2-4400-86b9-84fd4bf2de32	f3173f6b-71d2-47c1-9768-4ed28d2ee620	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7df84a48-a7d7-4d2b-899f-2a078a5aadb1	b3aa0f67-975e-4e8e-a7e5-8f82817802cd	f3173f6b-71d2-47c1-9768-4ed28d2ee620	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
c36e9ddd-b8ff-414c-b178-96343e4648d5	a2e3eb4f-c4e3-4f3c-bfdd-2ca2c6f4b9ed	f3173f6b-71d2-47c1-9768-4ed28d2ee620	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b0fa63b5-68fd-4346-94a0-deca7830721e	c1667389-c459-4ecc-a759-cd2b0d69d687	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
d4e395ff-4f81-4c05-bc8f-efb04b3fbbaa	7e2a2c9f-ceee-43a9-8c22-b0e99af67bf0	dab9453b-a30d-44ec-a414-132e953c2408	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
6039bbe6-5dad-4322-a951-edbfb203fe6a	3e969c04-e8bf-4376-a556-2a039627e19f	dab9453b-a30d-44ec-a414-132e953c2408	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
037b90ee-e25a-45e7-a7c8-c82ac85f17cf	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	dab9453b-a30d-44ec-a414-132e953c2408	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
9c119a6e-7d7b-4415-955b-0d84522194cb	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	dab9453b-a30d-44ec-a414-132e953c2408	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
745c4a89-9b75-48bb-a1e9-5dd11e72af8a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c1e73591-e3aa-4c35-842b-6e5ef3a4ac55	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
69232fcd-e8ad-4e3a-bd97-6136b7e9f5a8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a50270ed-2e54-4d7c-9e5e-e44eda23062e	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
cdcd9ee6-a91f-4bf5-9fdf-37dfb20b7989	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	5fb9c23d-5236-4675-8c9b-537ea30e248f	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
ffe7cbfb-15ef-42b9-9b27-b1985873b1eb	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	efaa39f8-49da-4aed-93e9-e2ea217fc9b8	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
11224e03-b5b9-425f-929f-f48f3b32e955	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	1aa37920-edce-42e7-98eb-4c32345cc71a	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
9e03f2ef-0ac3-4c41-b87b-23a892257879	dae9be5f-69f8-4aba-8707-3974bd4edf02	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b507678b-51b1-4da5-9cea-d2b67d3bdd3c	75bc07bb-6b7a-4414-b064-9f0f7c086217	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
403ff41a-8ccb-4aee-b01f-c23fc74ca47b	45f81bc7-ff24-498d-9104-18da7e5643f8	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a9080a7e-7d59-409c-a513-b139f5c010d4	0da6fe92-db44-40da-854c-a84be86ab8d4	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
0496f3f3-dbb6-4d2a-ad07-9183722d956d	ad927edf-b643-49c7-bb35-ce93c40e25f9	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
07c6fca6-ddfa-4ff4-8d92-c2aa034ab04a	04383a3e-b5cf-4875-99a7-fdd746e9cab0	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
d074d4c9-d77e-484c-9032-f2d1eea74f61	04c83856-9ff0-475a-b2cd-db05406b84a3	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
d8f5f711-340c-48c0-bf4c-43749ea37c88	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
abda89ff-5e0b-4840-9686-5dfe9077540a	d15bfb61-8af0-49af-af82-24696cd922a9	699de247-c0c8-4a8b-bae8-6ba24d9489c1	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
5b40af6b-df4a-40d3-a809-9c691445eddd	dae9be5f-69f8-4aba-8707-3974bd4edf02	c2d8d0d1-43dc-4d39-9170-071ff5bf0cb2	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
f8d8d893-49d8-4808-b5e7-8e9ae63378b2	0da6fe92-db44-40da-854c-a84be86ab8d4	c2d8d0d1-43dc-4d39-9170-071ff5bf0cb2	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
866393bf-bc19-4058-bb2b-44f7a510993b	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	c2d8d0d1-43dc-4d39-9170-071ff5bf0cb2	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
262f6407-3e13-4fd6-b244-7617e04c111c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	204d395b-19aa-483d-ace2-1fe096cf0c7a	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
35be3418-e3cf-4647-8897-4b1706c70155	87b40694-4414-4841-925a-176a00c7826a	204d395b-19aa-483d-ace2-1fe096cf0c7a	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
57335900-60fa-48e4-8204-340be3274557	dae9be5f-69f8-4aba-8707-3974bd4edf02	5efc6baa-40ff-406f-aab6-3cd7e48a7f26	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
ef180f9b-6b99-4ec3-b65f-b6f9c4b2dd8b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	9c4c3855-f8c8-4567-b5f9-db4c8d90b4e5	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
37e794ad-b707-4fab-bcd2-396652050432	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	5b316a00-25b2-4fd7-8796-5dbb7f51f948	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
ddb19461-b994-4c1f-9769-0b77f37d10f6	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	b475c6de-61e8-4434-8e6c-5b7de040c4d0	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
ad70959a-9f4c-45b6-b6fc-d4a07b7963f3	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	d15bfb61-8af0-49af-af82-24696cd922a9	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
94050d4d-4fba-428e-95c3-327c9d1b502b	204d395b-19aa-483d-ace2-1fe096cf0c7a	3d328497-971a-4cca-b0e6-6d959503bac0	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
210a3ca2-3f90-4e55-9c80-1ddbc2534ac1	3d328497-971a-4cca-b0e6-6d959503bac0	3d328497-971a-4cca-b0e6-6d959503bac0	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b3028255-00d5-4745-866d-c730c2f0d6ad	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	3d328497-971a-4cca-b0e6-6d959503bac0	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
f9de7118-9cc9-4ad1-ac84-4adc94afc78c	e53c3d28-bad0-465a-9b49-e0209ff0793c	e53c3d28-bad0-465a-9b49-e0209ff0793c	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7801b362-0e53-45d8-9f33-298b726210d0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	e53c3d28-bad0-465a-9b49-e0209ff0793c	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
1b0f8100-9244-4186-83e4-9d65101a469d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	e471db4b-ef29-4670-9730-3101f90741ab	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
fc005ffa-c71a-4f05-b03a-5cd375f14d93	3a3e0676-66e8-487f-8eba-e64eefe2bf2f	8b6bb28b-3a33-4499-8d67-2bb589dfb8d8	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
2fe2386a-ccaf-4e22-a1c7-3896bd30f27c	39144bf1-9a12-4d6d-a814-b769473d158f	8b6bb28b-3a33-4499-8d67-2bb589dfb8d8	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e647096e-f267-46c1-9f50-06b4ce6db87e	e93e5575-697d-4814-bc66-66b6d5d08f2d	8b6bb28b-3a33-4499-8d67-2bb589dfb8d8	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b966be26-a96f-4c03-8da4-11aabb75085c	e93e5575-697d-4814-bc66-66b6d5d08f2d	6fc7cc75-200e-49fe-935e-79111fb8948e	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
81001918-4c72-4cde-bc9d-4aeabdc8b4e9	36fa3c27-a0c6-4407-a386-a0b57cbbd453	dae9be5f-69f8-4aba-8707-3974bd4edf02	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b41523c4-0921-478a-a009-d8de28e7a680	75bc07bb-6b7a-4414-b064-9f0f7c086217	dae9be5f-69f8-4aba-8707-3974bd4edf02	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
33085889-7a25-42d4-b04e-b70c55115f67	a6138b49-27ca-485f-ad57-12f6ed08e94b	dae9be5f-69f8-4aba-8707-3974bd4edf02	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b33ac145-0a98-4434-8a26-5417b8696c43	eccfca5a-fe79-422a-86a9-00514d1a84f9	dae9be5f-69f8-4aba-8707-3974bd4edf02	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
9e8caba7-f81b-47c6-91f1-a18f6027b6e5	87b40694-4414-4841-925a-176a00c7826a	dae9be5f-69f8-4aba-8707-3974bd4edf02	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
0ce5f287-3bbc-492b-8b82-6e5918489265	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	dae9be5f-69f8-4aba-8707-3974bd4edf02	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b1e14586-f4ac-4603-b9f9-7d1a73095e41	4742c248-e7ae-4e74-b513-a66f6f86a66f	dae9be5f-69f8-4aba-8707-3974bd4edf02	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
4534001c-3835-48ee-96b6-d8c2f052354c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	82de6c86-64f8-4b2f-afb3-ad42f3064102	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
ffea701d-4bc9-4d77-a03c-7946e6c20803	4bd2dff5-6f63-4ad3-a9ee-61219df00045	bf0d2a55-ea51-4de8-bdfb-0e13d2fee800	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
4404b7ff-9edf-4e03-a2ce-f26c8d1fb332	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	f7578885-4640-41c2-9831-c994c131ab57	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
53bd217a-3ffe-4233-b697-da6a778c9711	583dcdbe-fbdd-4ecf-800d-831c7f7716f9	0ff90b8d-2766-423f-aee7-0393dae688ea	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
1ca98d84-b813-4ea4-a199-b5a18118cabd	1e2957ac-522b-4d7a-bc6b-5c33ca78ecde	0ff90b8d-2766-423f-aee7-0393dae688ea	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
234c8821-3a30-4783-a4bd-194cee0947af	437a268e-e28e-4d15-b50f-3190fff9acaf	0ff90b8d-2766-423f-aee7-0393dae688ea	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
6587814d-55ca-4b39-926f-672b86f517d4	cf6d3ef6-631e-43f5-8ed7-2554c4bc570e	0ff90b8d-2766-423f-aee7-0393dae688ea	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
33fd8268-4338-4d2a-8713-80da80d0df5a	3e969c04-e8bf-4376-a556-2a039627e19f	8f2abc6e-f4cf-4ce0-81fe-6a326079d556	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
baf89b23-b115-4323-8f24-cf07b47e00b5	8b9c80e4-3072-4dab-85a6-36e310fae6ef	8f2abc6e-f4cf-4ce0-81fe-6a326079d556	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
1d260600-b29b-4207-92c4-b6e625d520ca	29a63532-c5b1-4ebb-bba4-9a22abdd986c	8f2abc6e-f4cf-4ce0-81fe-6a326079d556	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
6e02bcac-3887-4d08-9fd3-0f93c0251b41	c1667389-c459-4ecc-a759-cd2b0d69d687	8f2abc6e-f4cf-4ce0-81fe-6a326079d556	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
31060228-7765-4ee9-b52f-8a1adfe7d0c1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	abfbdf7e-6cb4-4977-82ef-93211e950a6c	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
780ab114-7dd7-48df-ae02-77a0ba377a48	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	76437582-061c-4b94-9873-a4e3b6b8c787	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
104a80ca-e27c-4309-95c9-a3d692c9e77d	dae9be5f-69f8-4aba-8707-3974bd4edf02	36fa3c27-a0c6-4407-a386-a0b57cbbd453	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
cf61c79d-f043-4536-accd-1bd750af4fcb	75bc07bb-6b7a-4414-b064-9f0f7c086217	36fa3c27-a0c6-4407-a386-a0b57cbbd453	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
c75f5457-c7a8-4caa-9e9d-c0b9b355c279	4742c248-e7ae-4e74-b513-a66f6f86a66f	36fa3c27-a0c6-4407-a386-a0b57cbbd453	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
48638419-999a-49b1-85d1-13cbdfeff110	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	b651ec49-f0b6-40b6-87b9-af90f919e1c0	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7cf3921f-93ed-42b0-9b87-c362e8899273	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	a9a3eae9-470b-4e07-ac58-37a0d62d0ada	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e5fbb227-c707-471b-b61d-27fe0a4b9534	6781d49e-0a52-407a-bbd9-57152fa52741	a9a3eae9-470b-4e07-ac58-37a0d62d0ada	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
8e327a15-dabb-467a-bf97-e18611d3cc35	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	704659f3-e212-472b-951d-80c1d942b506	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
ee96f96d-e7fc-4e72-8608-9955c79fdf9e	631da6d3-9081-4d4d-8f17-98f6f1e128c4	704659f3-e212-472b-951d-80c1d942b506	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
6a29c284-8b95-4195-a99e-421cd08f9e37	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	66324a2e-a1aa-41ae-ad82-1e3edb50b082	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
6f2ea97f-32d4-404b-a5c8-c001886acc42	cdfe543c-a78e-4dbc-ba5b-f3a8e6aaf43a	c75d3de2-68b2-41b1-ad03-687393e3eca1	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
2e41d220-4298-4422-ba0c-df04fb71e04a	5431a241-78ce-4b21-b128-28dea9f8fae9	8aad06a4-5b48-41bf-8bff-e965cd620dc2	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
6d518f51-c52d-447c-ae8d-81735f26760b	a6138b49-27ca-485f-ad57-12f6ed08e94b	fb06de97-b722-4281-99cf-482d421bd4b0	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
5c90293f-61e6-4c86-9e22-65f8356efde6	4bd2dff5-6f63-4ad3-a9ee-61219df00045	4bd2dff5-6f63-4ad3-a9ee-61219df00045	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
153cddb2-1cf2-4940-8139-01fdb122451d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	4bd2dff5-6f63-4ad3-a9ee-61219df00045	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
6abeedd2-b832-443e-9458-e453b51cbfa7	dae9be5f-69f8-4aba-8707-3974bd4edf02	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
9471de90-160b-49e9-8436-26807d972dce	36fa3c27-a0c6-4407-a386-a0b57cbbd453	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
fe6e31c0-786b-476c-bee9-3e3827f35293	45f81bc7-ff24-498d-9104-18da7e5643f8	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
d8ba1262-6a53-43f5-9db3-7933f3932534	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
809d36d6-0866-4f7c-a840-d3aa80b49545	a6138b49-27ca-485f-ad57-12f6ed08e94b	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
1e56c08f-5460-45d8-9f29-0f4d36bfeb87	5ed7695e-c900-4690-ab29-d4ecbc00d945	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e22d4d9c-eedf-4a5b-a80e-d5fad13e384c	04383a3e-b5cf-4875-99a7-fdd746e9cab0	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
d70c2608-f842-4c59-9d58-b292edda08de	04c83856-9ff0-475a-b2cd-db05406b84a3	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
31baee52-2dcb-4595-a6eb-2fc543301097	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
d4052028-8fa0-4428-a6b6-2726c83e267c	4742c248-e7ae-4e74-b513-a66f6f86a66f	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
eda75b5c-4d96-4d91-9c82-02fb565429e3	728cb098-b1db-410e-94a4-d08a630d8076	45f81bc7-ff24-498d-9104-18da7e5643f8	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
9197d63c-2208-492d-9f64-ca30008c4bf1	75bc07bb-6b7a-4414-b064-9f0f7c086217	45f81bc7-ff24-498d-9104-18da7e5643f8	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
275cbb9f-1f4c-45e4-99e0-1918a996b063	a6138b49-27ca-485f-ad57-12f6ed08e94b	45f81bc7-ff24-498d-9104-18da7e5643f8	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
de5e8d0f-7f88-4fb0-a39f-1130d6d17ed7	ad927edf-b643-49c7-bb35-ce93c40e25f9	45f81bc7-ff24-498d-9104-18da7e5643f8	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
ce49d8d4-34c6-4680-9086-a9b276be75fe	04383a3e-b5cf-4875-99a7-fdd746e9cab0	45f81bc7-ff24-498d-9104-18da7e5643f8	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
14af7efe-1c22-4d1a-8429-f46b454b1dcf	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	838a9ef3-af3e-4655-99b5-a06134155c07	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
96fe328e-7000-422e-8a29-51e20d119a41	28058267-5877-4bc2-a880-395176bd6b22	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
0b5a61e1-27de-4a56-9c6d-f5092b93656e	8812812f-8bbf-4ae2-914a-b8cae24cdbcc	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a7b57435-8ad0-4dc6-9103-ca0dd49a5957	583dcdbe-fbdd-4ecf-800d-831c7f7716f9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
382bc9c0-40aa-471b-9f80-1b4f4fb0087e	e9c970a7-cd3b-452e-b6f7-70b9d9d60148	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
6278c932-8e79-4dc7-9d40-b06484df0f1b	3e969c04-e8bf-4376-a556-2a039627e19f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
da02d57f-76ca-4381-8c9b-4da282432c64	e23dd0b2-7699-4b27-9b31-7966d2d7376a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
496db962-e603-4a99-a6f5-b72e0009caed	e5b526bd-4554-4b99-bf91-204c2583a5fa	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
4b235a94-5511-425a-bf2c-5803a29b9553	5431a241-78ce-4b21-b128-28dea9f8fae9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
166c1a68-f4f3-4bda-89b0-686b8755e6ef	47e2ce69-9af9-4b6a-8c32-c1ef3bb659e1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
9788cdef-d67c-4cb6-b419-9a30608ca170	c53ce851-fa9d-41ad-a7e1-416cb7b166fe	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
4c3af75d-781c-43b8-adda-18d49c35da61	dab9453b-a30d-44ec-a414-132e953c2408	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
ff70fde8-d465-4ffe-a40f-7b3438fa37a4	1e2957ac-522b-4d7a-bc6b-5c33ca78ecde	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
72f429e1-816d-4794-a216-d91add60f927	eab0bcf1-82f3-40db-82fb-ace10ee4a383	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e330c23e-c27b-42bf-ac5f-566c1d44fdc7	c1fbb481-dd2c-4585-9b7c-06d180d77d2d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
0004d9bc-b736-4cb9-a08e-85fce8aff766	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
23d1998a-3493-427b-8139-745c0d10b87f	d0104fdf-dc7c-451c-8f1f-3f9abb4de8e9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7eba490a-40ff-4714-8a2f-da2f3fcde806	5fb9c23d-5236-4675-8c9b-537ea30e248f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
ef02d4e6-9a5a-44ad-a2db-ef71e70e3aad	1aa37920-edce-42e7-98eb-4c32345cc71a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
aebc7fd7-eec9-42cb-8aa9-bda40ea68414	69fc4171-6fad-4eaa-a382-8994f76b1f8a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
2e71d713-b02f-486a-833c-dbcb3847eb30	c662510d-a483-4da8-b9c4-96f2bb450a40	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
d07ade8c-3761-4e0f-a10f-a2d7e2abdb55	c97bb436-c55e-4222-a494-49af4ac02b31	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
56f553b3-075a-4043-b0a0-9093fd31dbfb	728cb098-b1db-410e-94a4-d08a630d8076	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b98dfca6-677e-4e16-a083-a2af41412e9d	5e27148a-c486-4282-9cc5-7ec352cd411b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
af52f086-1ef0-42b2-a760-9357073b4a7a	b108c58a-4722-4bb6-bf8e-d3486b06d900	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
43a51eba-330e-4eec-b803-e072e5e2c439	407ae14a-060d-4d91-89d1-39535ab93b0a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7104a2f5-bb4d-445d-881e-c656186b52e4	ccd77641-e05b-4160-8b88-90f763fd56cd	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
d405235a-44a6-44f4-9c6e-e3fc828a47b0	c3e729df-b864-488f-950e-b828d01ab4e0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
0b6c93c7-e7e5-479b-ad44-e3b39126e902	539dd60d-44d6-4808-a75d-976f4ff14489	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
18c2acc8-5cbd-4f5e-a0c8-dfc61358fe9b	4cdac558-f594-40ab-9bd7-2d3a30f344d8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
54efcacc-e342-400e-8f78-8c25cf5648e8	c2d8d0d1-43dc-4d39-9170-071ff5bf0cb2	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
9f65a938-326d-4ae2-a821-96ea3de42ed4	204d395b-19aa-483d-ace2-1fe096cf0c7a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
3af33b60-a951-480f-b7ad-dbaf7fdd958f	48101c5e-8026-4206-9b7e-bb3c01018b75	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
27176024-d1cc-4254-91ed-9613fa1779df	cf1e383e-42f9-4548-a737-ffa464a2a1e4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
6274c8ca-08ab-4be2-b1e7-6095c3bb7663	7b962db5-8fc5-4b0f-82ea-4c3728add8a5	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b406c848-5688-4671-a304-7ca63c6811db	45aa8b28-c678-4e4a-9352-27ab690df852	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
ddbf7389-1dea-4788-924b-d7a7da86d499	437a268e-e28e-4d15-b50f-3190fff9acaf	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
db2a5818-725c-4f80-bc9e-a949dd3759de	5efc6baa-40ff-406f-aab6-3cd7e48a7f26	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
515d752d-7ae0-43a5-bfd9-4ebff21d4568	9c4c3855-f8c8-4567-b5f9-db4c8d90b4e5	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b6657f5b-6229-4779-a5f0-5ae97da14527	9bdf6f88-144e-4836-9d28-a1e6715e47e6	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
41f761d9-aafc-48c7-84d1-edc33b700841	5b316a00-25b2-4fd7-8796-5dbb7f51f948	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
d77b80b9-5b70-43d3-8acb-d694513cf265	2fc63575-ed81-4633-9117-b8fcb774cf85	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
f4311c6c-a8b6-4249-a18d-3339ab32322c	d15bfb61-8af0-49af-af82-24696cd922a9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b8e30b19-ca01-4e31-9892-80b4dc5d76fd	1543db57-9c36-4a03-b917-401ada53eb22	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
5139a210-4a12-4de5-ade4-f1981c8d4382	3d328497-971a-4cca-b0e6-6d959503bac0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
c5533426-151a-45a3-a9e1-a9d81a533f67	e53c3d28-bad0-465a-9b49-e0209ff0793c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a651ba21-07a8-4804-b0b5-5d383639f4b1	e471db4b-ef29-4670-9730-3101f90741ab	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
6329ed15-bdb8-4792-9cb3-7c64251187c3	8b6bb28b-3a33-4499-8d67-2bb589dfb8d8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
5836827f-950b-4547-83bf-458b5c436006	6fc7cc75-200e-49fe-935e-79111fb8948e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e2d67d9a-1c26-4ac0-814f-a72a71ff7787	3c7cd7ce-dcc5-439d-ae39-00f31f02030d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
725135cb-09f8-461a-a155-ac54f2fcf3db	60c1c053-6438-451b-9772-4525172235d0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
1459b1a0-c00c-4be0-8932-c9f43b704b7b	4088dc01-b5cc-4127-98cd-93debca761df	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
d16d5741-a41d-4f78-889e-dce3334ec7b9	80d50a82-65db-4ce9-bf3e-e679c14b6765	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
403c1fbe-1b2e-4c1b-9a4f-13712bb79f0a	dae9be5f-69f8-4aba-8707-3974bd4edf02	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
221babfe-79e2-44a2-a587-a8e8d1197d8d	b998f6fd-4ed6-46ac-a68a-cac842099b5a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
11308106-a44e-41f8-bc0d-29658dbe9fe0	82de6c86-64f8-4b2f-afb3-ad42f3064102	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7d1d9774-3336-416f-ac84-6d52be02f127	f7578885-4640-41c2-9831-c994c131ab57	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
0ec99d5e-5d23-4ea1-8975-5b639914a9f3	ac2d044e-0c82-4e7c-bc7f-2781191a1148	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
54546f06-031a-4b32-856e-db04d48b4452	4fa50c02-239d-4274-b782-0286c6a1b05b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
688b9882-41cf-48c7-8e72-da0c8f1d2927	63d512ee-b850-4993-b486-e5494d188bfe	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
f4b14952-4b84-496e-8aca-3d60a7b123a7	dbc18365-0064-48a1-a511-f11f56929643	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
6e3b364a-7351-45d2-8ce9-740406679f04	0ff90b8d-2766-423f-aee7-0393dae688ea	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
4a2a52f7-ebf7-4ab2-8106-d1a835ed4344	1349490b-955e-4a0b-b00b-c392d1cb71c1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
06295ed5-81bd-4109-83db-82044fa80b27	abfbdf7e-6cb4-4977-82ef-93211e950a6c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
457d913b-e3b1-4a66-a344-d1d98098c0d9	76437582-061c-4b94-9873-a4e3b6b8c787	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
dfe8d70f-708f-42b6-8a74-e93424c483dd	2c161160-a3de-4af8-b178-11700da1ed54	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a5317a84-4cce-44c0-8af3-5f3fc0873d40	d99d51b7-3349-4bf6-8803-618705c95d2d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
41f818dc-a780-44af-adbc-be81ecb10279	0cab1976-8937-46ee-8a8d-9e3d831d258b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
39eff43f-faae-4762-bdff-3fc56fed685d	5ddcc4e4-ee30-48b1-939a-09439b14e6dd	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
dbd93fbd-a037-41fe-8d23-8df727cc1a15	36fa3c27-a0c6-4407-a386-a0b57cbbd453	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
5b63d5bd-e2eb-484c-bd0f-ecabc3f2a961	b651ec49-f0b6-40b6-87b9-af90f919e1c0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a35c12b6-e33e-40ad-9eb6-323461351f63	a9a3eae9-470b-4e07-ac58-37a0d62d0ada	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e0315bb2-887b-4332-adbe-002bbea4982b	1bd86dd9-872f-4a68-8602-a60813df56c8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
d892e96a-570d-462b-9482-0743b7aa956a	704659f3-e212-472b-951d-80c1d942b506	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
011e7ba0-f920-452c-a56d-1e7dd3dc340e	60aaec3d-f58b-40c4-8ecc-f12c307faf17	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
616977ff-96c5-4af2-900e-f3eaacced709	12f68791-85a0-41c8-8b5d-e80943e321da	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b92cfe24-4730-4116-a1e9-475cf6bf168d	998a1f5c-0ce8-43d0-addb-c6861ab126d9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
c3986462-1702-4573-a61d-200c2a7f98ca	78587ca2-7caf-4b23-a0b0-16abff115c30	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
775d1f4e-8b8f-4636-934f-f39cdfbfb739	c75d3de2-68b2-41b1-ad03-687393e3eca1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
22c45e14-6ed1-4ae5-869d-6ceb8972c1b0	6895b079-41da-4c80-9b03-a13205bca38d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
f9962e14-be5e-44f9-8f4d-f0a4b658d443	688d0ae3-2734-46f8-94ba-26314aeec7c9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
6cce6eca-10e6-44ac-ab33-a4b1132a45aa	04a73285-3f3c-433f-917d-15f913b0737a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
ed20a3af-d413-4611-a1e3-01a843028e8a	fb06de97-b722-4281-99cf-482d421bd4b0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
3b2fdf60-088f-4873-a75a-697fdd3af244	4bd2dff5-6f63-4ad3-a9ee-61219df00045	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
da70b8a1-e419-4eea-9b6c-d0b1d6b16ab8	8490695f-9b65-4b5a-b9ee-2a0987b921dd	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7ad43ee9-1913-4402-9a3a-51ccd91178a8	75bc07bb-6b7a-4414-b064-9f0f7c086217	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
5593adf2-94a7-4f1d-9742-9185a1c6c1cf	45f81bc7-ff24-498d-9104-18da7e5643f8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
0cf59325-5b6c-45ab-99fd-c8c0d43a3f12	4e2bc8e4-d7fa-4757-adec-22c5c62d9b69	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
fcdad51f-0d84-481a-9624-39a4ff1b402e	8b9c80e4-3072-4dab-85a6-36e310fae6ef	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
0759ab70-832a-4039-ad57-8070988b682e	706ae8d3-4398-4f3a-b0c4-d2476d6e9d97	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e5e5eb09-2e0f-4582-88c6-69b4386c579f	0da6fe92-db44-40da-854c-a84be86ab8d4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
675ba3c0-09f3-42bc-9149-371e7dd33366	6c50a910-149e-4247-af57-91342ca69c26	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
3c44230a-3931-476f-98d4-5a891f608246	67c41f98-232b-4c1a-ba47-348bc540c17a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a7e8bd44-f9aa-4da0-8207-880d7decb1dc	ac8046ab-5699-4eda-bde8-056ccc1dcda0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
28a8bc2d-5644-4052-9e14-b946cc7a1529	a6138b49-27ca-485f-ad57-12f6ed08e94b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
54383a9f-cadc-4a38-be51-46802b6b6c96	2ddcfb31-7ace-442b-9cf9-eb1966e09627	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a505b6f8-1946-4fa9-b678-ba2c2f562425	e1d0121d-7fc5-424b-860e-065f92776ca1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
dff0682b-58b7-4a86-bbe4-bd70a474245e	9079e6fb-d198-4c34-a483-39df60af375b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e4a23a44-6acc-444b-b20a-7ea6e9b380af	0be157db-7f72-4e13-9c10-5b3a30bebd76	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
83e9381d-b72f-4e75-8614-4f6872b74594	d05bf38b-f898-4dfc-adcc-dce47a90a1c7	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
f4b35b22-4c89-48ff-9adf-05a825a56361	d20a6a07-b621-4dd3-a202-78ac56696c2c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
5c012e4d-4ddb-4e7f-9f4a-fb4f4eca195b	12f8683d-d1eb-4e71-b60f-75df4e0f8169	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
bcbf2dee-76fc-4e64-a8f8-0e916ecfd090	db049daa-59cb-425e-bdd9-c6dbbdff5b95	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
23416117-d6ca-492d-98e1-5d90194793d6	1595e4da-60d8-4646-8dcc-c761e435937e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
81faa05f-0fc4-4f30-bad5-ee3bac7848ee	fc57deea-20e3-4959-bb07-ce80c36b7a8c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
c7642319-a4eb-487a-b85b-440445672bad	ff42b26e-122c-4b16-b896-f06c990c2c01	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
2edf0eda-db1b-4697-ad68-4281d5d83870	1a88ebc2-fa9e-4566-9043-3904425b19ea	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
750d8b62-5950-4373-bb35-e99c20bb1c65	cf6d3ef6-631e-43f5-8ed7-2554c4bc570e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
fda28962-171a-4d55-a497-944c1a7b9915	bd9d47bf-0c6a-41ef-8fa7-9924e9cc868d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
2ad259a4-6fa5-429e-b1c9-4009e938c54f	f270fd28-1c02-46bf-ac9c-8179ed1185bb	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b16298c1-2bf0-403b-9381-985220915778	ba7cf405-2477-4369-97ef-ed720e0686b6	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
df0ebe06-c7d2-4cb9-933c-5354e3d46076	e0161890-fc0a-40a7-b14c-0bf1d40cf3d5	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
8fe8bf86-b615-4b81-bb9f-67a04c0dadd8	61b3566e-f3e2-4116-824b-0be7e6d5f9b8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
18ac09a6-2b70-4226-827f-a3fef91adf81	8d376618-ce43-42a3-aa6e-4a7a3cd11f36	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a6d74c40-39dd-4414-be49-bfbf100a0818	3a3e0676-66e8-487f-8eba-e64eefe2bf2f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
ec0291a8-18a0-40be-9534-846b88ac930d	bec4ca37-50c4-46ea-9840-a0228ce9df38	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
24c2964c-c55d-4049-81da-eec838656982	c2a418bd-aae3-479b-8d28-dc4a3fafb5e4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
2edfae1f-90a3-4ff2-9d6d-af91c43dc42c	d751f28d-f47d-4486-8ff8-94358cdf53f7	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
19bab0bf-9280-4a22-b098-2accec6bf9f8	d8e42301-a8b5-4708-87c6-440ca9acd37e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
9d1b3135-e06f-4408-af86-ce8f460b7c50	06b9b48a-abaa-4d24-8ee9-d94d5ab0ec66	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
1d89f6c1-3f98-4e3d-b4f9-3e1690cf7924	631da6d3-9081-4d4d-8f17-98f6f1e128c4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
4724ec53-e657-49e8-9a76-c4947232af16	1a550834-b834-45c1-a899-392a50b5ee7d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
25f4ac47-02bc-4321-abda-2620f1969a7b	d2feda35-cf48-4d50-9db4-5d5cab9a96bd	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
18bc1e7e-55d2-4260-ae64-5a76bcb92db6	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
51027788-5959-411d-bdee-3b63f2741f13	8ecd4380-5e50-4e97-ba2a-255ce4c2c4e1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
d2d49a61-72a1-4359-88f1-7540b614714a	39144bf1-9a12-4d6d-a814-b769473d158f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
fd92980c-421e-4a27-b352-4d7899fbb2fb	9c575b13-2b96-4e73-8ae6-21267b4cf871	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
89a8d9e2-185f-42de-a204-643a59420956	e93e5575-697d-4814-bc66-66b6d5d08f2d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
c4571b90-e0c3-4a6f-a4be-26400e960ec1	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
430e5b1a-84e7-442c-b4c3-8b0baeb3a776	3ffbd728-c91d-40c5-8bb2-b45e93c1ff6f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
84e39243-5cf5-43ae-a201-837ba3cd67a6	cdfe543c-a78e-4dbc-ba5b-f3a8e6aaf43a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
dc547a8f-47b4-4d19-8d19-a5ce546721b3	a5375a3b-6bcf-4d38-ad41-d0f132461966	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
1cb9b38b-54cf-4f7d-b982-dec262918ccf	6ffb9390-3177-4546-993c-4b4b225bad8e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
2fb7ae84-f257-4764-841e-93a0fd7b35e3	c2a554a7-8f5e-4f75-a4cb-115cb59a4f75	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7ab884fc-3521-4f83-b340-047686bfabd6	ceb2e076-e8e4-4f5e-a944-e1d423c62834	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
44ac640e-2d53-410a-9319-3aae38e04833	4c850cce-3170-46ea-9669-f891b4bad0da	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
c2c0460a-ced6-4590-bad5-1514c5ec5930	5ed7695e-c900-4690-ab29-d4ecbc00d945	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
89f96925-7676-4eee-b9b3-2dcd480e7250	62ee5b22-cd13-4cb1-bdcf-f2976f9328fd	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
c4d9ff57-0c82-446c-bb3e-409b7fc47e57	bdc0c353-4bb0-42dc-aa6c-a00669fa03dc	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
338cdda8-9121-499f-b2c1-75768e6e15a0	a1d9d15d-9674-4992-a112-44dbb8d0dff4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a345db16-da94-48eb-86ea-43c8fd77da82	b7c71dec-b765-4ab4-845a-042585452059	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
1ae5116b-2ee5-46c8-97d3-8fa42e54c919	c1dbe57f-98a3-4a7a-b19e-73086799fcdd	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
218c5946-67ec-4971-acdc-fbe4ee80d5b8	fcf287b3-077c-40fd-8f4f-50ddf266fd4a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
45d9b5d0-952b-40fa-825e-0816757858a3	7258a2ce-894f-4ce1-a260-84a7452f4d22	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a3ac9f1b-290d-4eda-a481-2ef20d6e61fa	04ed257c-7497-4592-8157-d7526ebdbfcb	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
51d52a50-c318-4a18-96f0-f54ca0a750cc	481f84ac-0826-476a-8bf5-7ebf33a13fc5	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7f26dde1-8396-44b2-8415-4278c7dab193	1ce7f618-ad5a-4831-8ab7-941266b34f24	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
f0d5560d-d6d0-4628-be53-76e5a54cb54b	a3135e59-6d69-4b85-aba6-44192a01ccbc	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
0bf7f7f4-c469-48a4-b635-a9997bea547c	71ce6255-8c70-4d98-8f03-17b1f88d5f10	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
edbc2975-bded-4a59-9fc2-2679cb389f60	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
20b50d53-a616-4fd1-833e-bb1000c83cce	a2e32bac-cab2-4eb8-a43e-9dfda0f1ca48	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
ec3353f3-570d-4b0f-afe1-6d72f653f223	780cd261-4746-4bc4-90c6-9457ad08308f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
53a8126f-4ac8-4806-b27d-4e3bf52c28c0	3970a38d-c005-44fe-9b79-e89b7b8a5ea5	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7aa4d963-7cb7-406b-b903-87577b061a54	5b277fc8-1da0-4867-beae-f6a8e72f490e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e73a01dd-562e-4a51-a23a-726c3d515b1e	b720f98f-9a0c-43e7-958b-9855a27a7c71	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
5f20528c-a08b-477e-9caf-7e0802d7437b	82897173-7157-4508-9557-9e6700c0dc4d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
adc727a5-9366-4348-9640-fd7937db6a79	a1468102-4c03-47f4-a390-cc625f636017	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a64abb6f-9090-482c-9ff8-3dee7742a2dc	376225dd-5419-4aab-862c-25bd9e67f5df	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
c0cc1575-9033-4c9e-a7b1-321fdf6f130a	b7068e6f-0513-47a6-82d5-a67333d69e31	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b9f8685c-3fe1-42da-9400-60f24031cf2b	7a2ca438-8b6c-492c-8fbb-797c9e4e7e1b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
761cb682-1753-4053-9597-547a970a511b	8b4f4e5f-3cf7-4790-ad3b-90f52d6c381b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
83d7c993-ee37-4064-a14d-48c72050e015	1b4707dd-eaff-4276-8e8e-2c25fccd068d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
3d816b11-1735-4b27-b420-8aef8002952e	24b51865-5001-43e3-8b06-f791014a9954	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a6c91128-e25d-4163-ae18-8dffbe6381a0	62cd660d-f79a-414d-b7a9-ddba6338048d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b441160e-91b1-41ae-a4d3-c9c7f36cb91b	eccfca5a-fe79-422a-86a9-00514d1a84f9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a1966e6d-8523-425d-9b38-b48e6a8903c6	0e691109-aac1-47b0-9727-c9078860a89f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
6d87b4e3-0552-4957-9bd1-764a541705ca	87b40694-4414-4841-925a-176a00c7826a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
94e5f131-77c3-4adb-bfcf-9c4fd7d49668	a7d7d2b7-8389-4a67-91e3-7aaf6940bf49	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
836fdf6a-260c-4207-b233-fef007a8aa93	b3aa0f67-975e-4e8e-a7e5-8f82817802cd	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
51a0f84f-9125-4d33-abff-ce2b4d89ecf5	6781d49e-0a52-407a-bbd9-57152fa52741	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
83c791e0-6530-471d-8ed4-16f967fe3e46	05f1ea88-de99-48ad-b7cc-38ed173ba5f6	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
3de4857f-ca77-446c-97c7-77d6d7f96420	f578ba4f-f883-4dd2-b920-6614af947bd4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
4838e9d7-0486-46ac-9e1d-155e7643e6ee	17eb1c1d-7c3d-487a-8fea-baff32b2937c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
424d2faf-9103-40d3-a434-0383f4a907d4	04383a3e-b5cf-4875-99a7-fdd746e9cab0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
1f86cba5-acc0-448f-a56c-fe9388965581	04c83856-9ff0-475a-b2cd-db05406b84a3	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e3b59ded-6c45-4dc3-93e1-e6e8dc611e76	63b91840-aeb7-4558-a952-9e23e7217c1c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
0d2182fa-8ee2-4cfa-af9c-008d1dedab77	05ed794e-f094-4a48-91b8-211b37ab3d4f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
3337e3d2-6b80-4989-a5b0-8c1a286eb54e	48d1c50e-0ed4-4355-8b30-37ed358badcc	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
54f59a9b-cfcc-4777-970f-7be644ebe8b9	cfb0a68c-2135-4df7-ba69-3421c2a01173	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
9b2713df-c55c-4052-9c00-2e76ef4667b5	1a613180-d253-411c-b05e-9087bb2537a2	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
bf14d170-74d3-4d51-b008-4726eaff742a	072c2418-239b-4944-93f8-da9eb88be608	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
248a75f3-8719-458d-9939-e2756c61b275	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
daa49660-2b27-4744-aa12-8e6ed1267b06	aca0f31b-c1da-441e-8568-e7c13b498797	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b62f6d2b-0675-438e-ad16-15a487bda8ea	55343256-1601-423a-b1a4-3d467d2b64c6	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
68fd603b-921f-42c9-9d73-360c1ebf250f	4f5a91b8-5ae2-4451-8595-e30b2f37474e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7f42dc84-b16e-4c24-97c8-565331ee8eec	691a7808-92eb-4fce-a618-d51867429491	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
38f471b6-62bb-4f31-8918-be6bca5aa6bf	a38b5915-0abf-4faf-9807-79a55151dab3	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
975a2759-6421-47f5-b5c6-16e017c7cf80	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
25e574aa-4493-4f11-bc6b-ff2372617717	9533dac5-4510-48db-9cb7-3ae25c3c7ad4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
030dbe07-e574-40aa-b242-59a776ab0b69	b370e760-5bed-4ade-8488-fe7c4c972e04	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
fc8e1140-0e73-4f2f-aef6-a48be661ff81	c88e824b-4488-4d90-a69c-cfb61fbe4791	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
581cad32-a078-47fd-9f1c-09649bab2dff	07ee028a-1e71-400d-a185-39dc4299803c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7bbf0208-99ae-409b-a584-2f1ed5c0c20e	50d7763f-3b95-4adb-917f-04fdaf9d88c3	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
ce08599c-111e-4782-bf2a-7b10f5c92399	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
5ad0c447-a1c7-4ee5-836d-dd0fca122031	b9325221-963e-4909-8a81-6d00f3b1e7e6	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
38123a62-e4eb-4390-aadd-6dea99f57a2e	317cf77d-0e89-49b2-82f0-b20073914c0c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
77c5b3a0-dc29-441d-940d-e833ed245b54	6c98251c-b1f6-4af0-96f7-37b08b66a067	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
9fb58c18-5a82-4c4f-a56c-953e8f017b7a	4742c248-e7ae-4e74-b513-a66f6f86a66f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
6d4f1ca3-be85-4bf8-9f09-c4e63d3d5978	da338792-0065-494a-960b-662d367ec669	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
88c809da-ae5a-4c07-b453-1674783bc568	c1667389-c459-4ecc-a759-cd2b0d69d687	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
fb7a9fc0-402c-4695-9575-2c85f5edf32b	19ab8ef6-2d97-43c6-9b8d-d8763bab7242	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
4e65aaca-e168-40cb-8ac0-9badf19df894	38bc0ed2-b6f8-43ab-8c00-4881911d0a64	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
4fd67152-0eed-4b04-b3b9-30c4d5ebac08	77d688de-9a29-4e5f-a453-9479a9fd7f8d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
d7ecce8c-ea3c-4c2f-a50e-e44ff5ad114c	8a5b931e-b073-4af9-a916-4b214183a825	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
dfacff09-1807-412d-8d43-e8fa0b16a68f	2eba665b-39d7-41a9-bb0a-f6b5e9d8063f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e7c54a4b-8207-4fff-b8e8-48a5b82ca01e	b558d227-6709-4505-8753-991479735966	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
2bd8b3de-5670-4852-b2de-51ca0e1a0502	e489a5af-6a15-467b-97e8-f144421961bc	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
57a7439c-77d2-470f-b246-137a996a39cc	f3a78141-9a77-4b27-998d-d2b4d366e088	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
57f9331f-e0c5-419b-b026-4b54ae044c78	679443db-8000-4a0b-9fda-92d3e021a062	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
13dfc5ff-10bc-4b60-be05-b337f9a3f2f6	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
148fcac2-a5ba-4d64-a032-475ecdd1bbeb	8812812f-8bbf-4ae2-914a-b8cae24cdbcc	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
367fa131-c1be-4161-9637-0fcb1d0c54cd	9bdf6f88-144e-4836-9d28-a1e6715e47e6	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
2ac29361-dbd9-4606-bb75-e960f6194862	e471db4b-ef29-4670-9730-3101f90741ab	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
ee647026-a550-41e5-bfb0-ebd27be75571	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
1d35fcb1-a0c3-4db1-9e7b-910f6935fb6f	29a63532-c5b1-4ebb-bba4-9a22abdd986c	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
05bd3844-8d96-43e3-babc-91b450b18afd	7258a2ce-894f-4ce1-a260-84a7452f4d22	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b0547c88-992d-4c3c-9f5f-7d9e315d9171	c1667389-c459-4ecc-a759-cd2b0d69d687	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
14e8c50a-c64b-4999-a27b-758c8a9528b2	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
9f06dda7-1f6d-4754-8713-4b17992f2dbc	728cb098-b1db-410e-94a4-d08a630d8076	0da6fe92-db44-40da-854c-a84be86ab8d4	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
fd2071a9-b973-4bb7-bf96-db3092ad583d	dae9be5f-69f8-4aba-8707-3974bd4edf02	0da6fe92-db44-40da-854c-a84be86ab8d4	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a3e6d1fe-d8bb-4217-b8d8-afbd507540bc	75bc07bb-6b7a-4414-b064-9f0f7c086217	0da6fe92-db44-40da-854c-a84be86ab8d4	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
25a8879d-014d-4d09-b6a3-f21202b811f0	a6138b49-27ca-485f-ad57-12f6ed08e94b	0da6fe92-db44-40da-854c-a84be86ab8d4	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
6b47d9c3-6a63-4445-99a0-312c26d2ffe5	04383a3e-b5cf-4875-99a7-fdd746e9cab0	0da6fe92-db44-40da-854c-a84be86ab8d4	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
0a9c890d-952e-433d-8ebc-9f873a526d66	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	0da6fe92-db44-40da-854c-a84be86ab8d4	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
1142c6c4-fadc-4d2d-97da-8c2f3f4362b6	4742c248-e7ae-4e74-b513-a66f6f86a66f	0da6fe92-db44-40da-854c-a84be86ab8d4	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
52cc8dfc-ade5-438a-8448-60fc2832caf5	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	6c50a910-149e-4247-af57-91342ca69c26	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b4fde70b-19dd-4ddd-8960-041b6ed86787	3e969c04-e8bf-4376-a556-2a039627e19f	29a63532-c5b1-4ebb-bba4-9a22abdd986c	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
1cc91a7a-2471-4975-91c0-fdeff4a29ac8	20115650-29ba-44fa-9861-99c990caa5b1	29a63532-c5b1-4ebb-bba4-9a22abdd986c	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a54ba990-3e0f-4449-919f-edf90c7858ac	3e969c04-e8bf-4376-a556-2a039627e19f	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
eb3b6f00-be95-4016-aaf9-2fbe5d6d83c5	5431a241-78ce-4b21-b128-28dea9f8fae9	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
ddbd02e0-9149-44c0-a669-aed72534cb7f	e471db4b-ef29-4670-9730-3101f90741ab	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
0a67f28d-41ac-4d81-b9d7-a091bda92bb6	8b9c80e4-3072-4dab-85a6-36e310fae6ef	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
164d5f1e-febf-42b6-a1b4-5a7b475e6cff	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a13a8e5c-399c-47a8-a2fe-a35294b01ee3	dae9be5f-69f8-4aba-8707-3974bd4edf02	a6138b49-27ca-485f-ad57-12f6ed08e94b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
265dcc2e-e4c2-4d8c-8e1d-cab9d174fbb4	75bc07bb-6b7a-4414-b064-9f0f7c086217	a6138b49-27ca-485f-ad57-12f6ed08e94b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
bd89bb37-0c92-4022-9b27-067ff6708c4a	4742c248-e7ae-4e74-b513-a66f6f86a66f	a6138b49-27ca-485f-ad57-12f6ed08e94b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
f9a0dcb5-5a41-4452-a59e-da8d7fb682ba	c1fbb481-dd2c-4585-9b7c-06d180d77d2d	d05bf38b-f898-4dfc-adcc-dce47a90a1c7	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
fb2907db-542b-43ac-a274-270cea4a0e69	5b316a00-25b2-4fd7-8796-5dbb7f51f948	d05bf38b-f898-4dfc-adcc-dce47a90a1c7	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
96e8ece8-231a-43db-be67-22a6b01adbc6	7e2a2c9f-ceee-43a9-8c22-b0e99af67bf0	1fc5df4c-5ca6-44aa-b3ab-fb93987f7b9b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
c387f44e-a01b-4ee3-932c-af8afc9cabcb	f270fd28-1c02-46bf-ac9c-8179ed1185bb	1fc5df4c-5ca6-44aa-b3ab-fb93987f7b9b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
6117e5b6-4bcf-4ccf-8400-c4c217174579	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	fc57deea-20e3-4959-bb07-ce80c36b7a8c	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
9189bd9e-8298-4095-b947-49fd27967190	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	1a88ebc2-fa9e-4566-9043-3904425b19ea	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
5e3124c5-099b-4ab9-911f-888f50cd524b	1543db57-9c36-4a03-b917-401ada53eb22	bd9d47bf-0c6a-41ef-8fa7-9924e9cc868d	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
fe7d539c-3b1f-4581-994b-2d473d37fbef	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	bd9d47bf-0c6a-41ef-8fa7-9924e9cc868d	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
73a42cdd-b26d-4619-9095-3ad304ff1403	d99d51b7-3349-4bf6-8803-618705c95d2d	3e284f6f-181a-4fee-9eaa-89cc745094aa	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
01250b61-bbbe-43fd-a132-22f150d97a07	b651ec49-f0b6-40b6-87b9-af90f919e1c0	f270fd28-1c02-46bf-ac9c-8179ed1185bb	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e7631d88-88de-4bfd-b4be-3fff67ae6af6	704659f3-e212-472b-951d-80c1d942b506	f270fd28-1c02-46bf-ac9c-8179ed1185bb	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
8fe50fcc-7b02-4b46-b779-877677818db3	7ac0b7d7-3b98-4439-89e7-79026ae3b3ad	f270fd28-1c02-46bf-ac9c-8179ed1185bb	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
5518798c-ebd9-4b70-a961-75772bbb6694	631da6d3-9081-4d4d-8f17-98f6f1e128c4	f270fd28-1c02-46bf-ac9c-8179ed1185bb	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
6b949da5-2a27-4597-bf7f-4f679d3a032b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c2a418bd-aae3-479b-8d28-dc4a3fafb5e4	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
5c1b22d3-3783-4cc5-bb15-e304d8b2ceeb	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	d751f28d-f47d-4486-8ff8-94358cdf53f7	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
90494789-5326-4f58-a75b-eb565bc99603	704659f3-e212-472b-951d-80c1d942b506	631da6d3-9081-4d4d-8f17-98f6f1e128c4	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e52d9810-f4f5-43ed-a6a9-53c512cc1389	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	631da6d3-9081-4d4d-8f17-98f6f1e128c4	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
35ab9a56-b188-4c8f-beec-eafdcc63a40f	28058267-5877-4bc2-a880-395176bd6b22	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
644772d1-7a2e-413c-b0f8-9026d4dbc3ec	dae9be5f-69f8-4aba-8707-3974bd4edf02	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
051b0cab-7f4f-4d21-b0a4-715a2a641601	fb06de97-b722-4281-99cf-482d421bd4b0	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
05a6a44c-8d85-432c-acc6-b24e666e57db	a6138b49-27ca-485f-ad57-12f6ed08e94b	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
90908ea8-01f9-4556-bb4c-9983d934a7a5	3a3e0676-66e8-487f-8eba-e64eefe2bf2f	39144bf1-9a12-4d6d-a814-b769473d158f	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
648f0ac2-fe86-4e6c-8741-c73e609faa20	e93e5575-697d-4814-bc66-66b6d5d08f2d	39144bf1-9a12-4d6d-a814-b769473d158f	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
14b01520-c5d0-4296-8aa5-b69eadb1a4cb	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	9c575b13-2b96-4e73-8ae6-21267b4cf871	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
05e40b28-a976-4c98-a952-f6ed2d06d6c1	c1667389-c459-4ecc-a759-cd2b0d69d687	9c575b13-2b96-4e73-8ae6-21267b4cf871	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
d17cc691-97ff-4fbc-b1b9-1b4b814f4576	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	e93e5575-697d-4814-bc66-66b6d5d08f2d	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
5ea1f1f8-18fc-4ffc-9537-0ab770faf980	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
593d838d-8724-4c86-940e-b695de4bce0e	ff42b26e-122c-4b16-b896-f06c990c2c01	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
24ba1de4-e8c6-42f9-a9a5-fad6412b2590	f270fd28-1c02-46bf-ac9c-8179ed1185bb	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
1179bd9c-35e6-40dc-816a-fce2ce817b1f	c2a418bd-aae3-479b-8d28-dc4a3fafb5e4	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
cbca18f4-1cbe-485f-98a1-905943f384a2	d2feda35-cf48-4d50-9db4-5d5cab9a96bd	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
90332812-b431-4d50-9d9c-c942ae0eb0b9	4f5a91b8-5ae2-4451-8595-e30b2f37474e	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e3eb9822-613e-41e5-9b29-f723ba158dd3	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	0134d7aa-9f38-4e9c-a172-f94415e1beb2	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
4493a012-9f92-449a-bd17-f341702af4c1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	cdfe543c-a78e-4dbc-ba5b-f3a8e6aaf43a	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
8588247e-2c15-40b2-a090-fac154a50942	1a88ebc2-fa9e-4566-9043-3904425b19ea	cdfe543c-a78e-4dbc-ba5b-f3a8e6aaf43a	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
9db284e6-add2-4fff-93bd-b3619c3324b4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	6ffb9390-3177-4546-993c-4b4b225bad8e	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
419c14e1-0f45-4108-9d1c-2c59a0558c10	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	4c850cce-3170-46ea-9669-f891b4bad0da	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
832b18ef-bbec-42f6-b8c9-b5ce30c6c566	dae9be5f-69f8-4aba-8707-3974bd4edf02	5ed7695e-c900-4690-ab29-d4ecbc00d945	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
bc046b3d-8102-434d-a821-2e6cc62ba878	4742c248-e7ae-4e74-b513-a66f6f86a66f	5ed7695e-c900-4690-ab29-d4ecbc00d945	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
01713906-55d1-4636-a1eb-9a6428647327	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	d98e1f37-38da-41b7-9ad1-9301b0fc0b50	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a1519146-4328-42d6-99c4-4b657b04aed0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	62ee5b22-cd13-4cb1-bdcf-f2976f9328fd	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
c0564ea1-a1a0-4386-bf7a-6769aac122a2	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	fcf287b3-077c-40fd-8f4f-50ddf266fd4a	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e571e69a-b466-4d7e-a644-3edcbb10b786	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	7258a2ce-894f-4ce1-a260-84a7452f4d22	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
78b35688-e242-4934-b8d0-e3f7e3d66332	d15bfb61-8af0-49af-af82-24696cd922a9	7258a2ce-894f-4ce1-a260-84a7452f4d22	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
4ed5a98e-bf9b-4640-b038-d0571e1b8d9b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	7258a2ce-894f-4ce1-a260-84a7452f4d22	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
69302718-8cd2-4034-b027-c9de8cd74432	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	1ce7f618-ad5a-4831-8ab7-941266b34f24	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
85a342f9-b662-4d1b-a62f-6d26ca7cb6c3	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	6928567c-2b25-4834-8ebf-27800deb240e	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
cd56b9a1-b4d1-4ae9-a197-7138b197defb	63b91840-aeb7-4558-a952-9e23e7217c1c	6928567c-2b25-4834-8ebf-27800deb240e	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
085d60fc-a198-41e7-ac26-5437e88fde88	8e7e993f-54f9-40d5-8bea-ae16768cbe27	b0457fb7-5638-4a0f-bbc2-688005ef2ae5	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
ddeb7329-dd97-48d9-bd1a-dd11a7366534	c662510d-a483-4da8-b9c4-96f2bb450a40	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
4dedc2c1-98f9-46b0-899c-f24378014d1a	dae9be5f-69f8-4aba-8707-3974bd4edf02	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
169c2dc4-185e-4d8a-96be-31e79c78c674	ac2d044e-0c82-4e7c-bc7f-2781191a1148	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b7f78054-eddc-4252-8931-6eff6b2c351a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
ed15893b-7b41-4568-a716-a60ce1ccad9c	a6138b49-27ca-485f-ad57-12f6ed08e94b	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
16222337-ee7d-47f9-b022-54d13d77f878	2ddcfb31-7ace-442b-9cf9-eb1966e09627	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
4f1332b2-b6c5-453d-a98e-072da2761d93	87b40694-4414-4841-925a-176a00c7826a	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
cfebd99b-bae2-4137-bca8-ffa3f3ef5f4e	4742c248-e7ae-4e74-b513-a66f6f86a66f	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7f27d937-db6b-4177-82ab-2ec67c6f555c	c1667389-c459-4ecc-a759-cd2b0d69d687	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
c5c21dc9-e617-400e-a7ae-ae3fd7b31368	0da6fe92-db44-40da-854c-a84be86ab8d4	3970a38d-c005-44fe-9b79-e89b7b8a5ea5	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
3a340950-6a8b-45c7-81a9-fe0ffd2d9e22	d99d51b7-3349-4bf6-8803-618705c95d2d	e617cb11-6363-43d1-8754-b0aa2d004810	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
51bf51dc-c30c-4569-9804-7ce010d6d16a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	5b277fc8-1da0-4867-beae-f6a8e72f490e	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
441303e1-173a-4d03-b648-2d554ce3e2b0	728cb098-b1db-410e-94a4-d08a630d8076	b720f98f-9a0c-43e7-958b-9855a27a7c71	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
f955e73e-4176-4075-b607-caa6855bbd51	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	16c03ecc-7936-4614-b272-58cfb2288da8	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
14725c39-fb4d-4ced-840b-60b04e94f12d	39144bf1-9a12-4d6d-a814-b769473d158f	66b771c6-9028-44eb-83e5-1ae8d757688d	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b6355dd8-97cb-4880-85a6-04589414c426	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	b7068e6f-0513-47a6-82d5-a67333d69e31	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
df004042-838f-401d-856c-6c3aca97bd91	c1667389-c459-4ecc-a759-cd2b0d69d687	8b4f4e5f-3cf7-4790-ad3b-90f52d6c381b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b580caf7-f51c-41e4-aab1-b532a99b5be0	5b316a00-25b2-4fd7-8796-5dbb7f51f948	1b4707dd-eaff-4276-8e8e-2c25fccd068d	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e2f522ae-b135-4b44-9270-1d053bdef0f9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	1b4707dd-eaff-4276-8e8e-2c25fccd068d	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
359e4332-5ccf-4df7-9d70-8b3bd1d0f104	d05bf38b-f898-4dfc-adcc-dce47a90a1c7	1b4707dd-eaff-4276-8e8e-2c25fccd068d	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
d8252ece-1dce-416d-80b7-9402f8216f26	75bc07bb-6b7a-4414-b064-9f0f7c086217	ad927edf-b643-49c7-bb35-ce93c40e25f9	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b55f26da-f579-4f9e-9c81-795ca2d19ebe	45f81bc7-ff24-498d-9104-18da7e5643f8	ad927edf-b643-49c7-bb35-ce93c40e25f9	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
0bd6f03f-e9ce-451a-b774-ffb0dd037284	dae9be5f-69f8-4aba-8707-3974bd4edf02	87b40694-4414-4841-925a-176a00c7826a	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
709a8dff-49cd-4bf2-8789-fb6a22d4801b	75bc07bb-6b7a-4414-b064-9f0f7c086217	87b40694-4414-4841-925a-176a00c7826a	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
61a1a985-d7af-4aa5-b71c-004766b6ae5a	a6138b49-27ca-485f-ad57-12f6ed08e94b	87b40694-4414-4841-925a-176a00c7826a	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
61f1b902-2109-445b-83d5-cbf71f8dc806	4742c248-e7ae-4e74-b513-a66f6f86a66f	87b40694-4414-4841-925a-176a00c7826a	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7ca3a8b6-2ea5-454e-b82e-1c703faad018	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	b3aa0f67-975e-4e8e-a7e5-8f82817802cd	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a9aaea42-10e1-4fa8-a83f-d87737a75404	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	b3aa0f67-975e-4e8e-a7e5-8f82817802cd	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
5f893787-b66b-4f13-9903-6fe515747f48	a9a3eae9-470b-4e07-ac58-37a0d62d0ada	6781d49e-0a52-407a-bbd9-57152fa52741	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e0df0fa3-5045-49c7-908b-c3ca768fa062	0da6fe92-db44-40da-854c-a84be86ab8d4	6781d49e-0a52-407a-bbd9-57152fa52741	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
f5f187b4-4d0e-4626-81d8-1339dd67d51a	a6138b49-27ca-485f-ad57-12f6ed08e94b	6781d49e-0a52-407a-bbd9-57152fa52741	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
34d2a1dd-52bf-43bc-9a85-e1581810a7a0	e1d0121d-7fc5-424b-860e-065f92776ca1	6781d49e-0a52-407a-bbd9-57152fa52741	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
be654970-41a2-4e36-8c80-16c2ba2dd17c	82897173-7157-4508-9557-9e6700c0dc4d	6781d49e-0a52-407a-bbd9-57152fa52741	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a83b3711-dbcd-4209-8f8b-11b8faf8f809	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	05f1ea88-de99-48ad-b7cc-38ed173ba5f6	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
38469821-4faa-47cb-8904-9da2f9674099	7258a2ce-894f-4ce1-a260-84a7452f4d22	05f1ea88-de99-48ad-b7cc-38ed173ba5f6	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
39dd82fe-18d3-4fcf-bcd5-8c3dd4d5ced0	d99d51b7-3349-4bf6-8803-618705c95d2d	f578ba4f-f883-4dd2-b920-6614af947bd4	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
172b9109-f36a-41ec-8eef-78f6ddccbaa9	ff42b26e-122c-4b16-b896-f06c990c2c01	f578ba4f-f883-4dd2-b920-6614af947bd4	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
bd36bfbb-eb21-4605-99bc-ba9f68f2b33a	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	f578ba4f-f883-4dd2-b920-6614af947bd4	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7b886578-94c4-4461-8121-9b48eb016889	728cb098-b1db-410e-94a4-d08a630d8076	04383a3e-b5cf-4875-99a7-fdd746e9cab0	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
bf49c5c4-6fdc-49fe-95b0-cab5d41d98f1	75bc07bb-6b7a-4414-b064-9f0f7c086217	04383a3e-b5cf-4875-99a7-fdd746e9cab0	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
0d563fb4-0881-45d9-b1a1-cd811eee26a7	45f81bc7-ff24-498d-9104-18da7e5643f8	04383a3e-b5cf-4875-99a7-fdd746e9cab0	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e2f7907b-7eef-419e-a8eb-9da7d0c1cd2a	0da6fe92-db44-40da-854c-a84be86ab8d4	04383a3e-b5cf-4875-99a7-fdd746e9cab0	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
6873b916-1275-43ed-ba93-12c5bd1958b0	ad927edf-b643-49c7-bb35-ce93c40e25f9	04383a3e-b5cf-4875-99a7-fdd746e9cab0	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
9e70f494-d6dc-43c1-aa14-410fd4105728	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	04383a3e-b5cf-4875-99a7-fdd746e9cab0	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
666d24a6-3fee-413b-b931-71b96a038cb0	dae9be5f-69f8-4aba-8707-3974bd4edf02	04c83856-9ff0-475a-b2cd-db05406b84a3	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
e83cdd2a-78d7-4867-bc27-e9b4028d0b2c	0da6fe92-db44-40da-854c-a84be86ab8d4	04c83856-9ff0-475a-b2cd-db05406b84a3	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
bc6471af-6b79-490d-bde9-6f3ac352c602	a6138b49-27ca-485f-ad57-12f6ed08e94b	04c83856-9ff0-475a-b2cd-db05406b84a3	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a1d00f5f-ec99-480f-8437-6014189ba6de	4742c248-e7ae-4e74-b513-a66f6f86a66f	04c83856-9ff0-475a-b2cd-db05406b84a3	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
2a53ad7b-78a9-4ce6-b928-1ffe109f1e0c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	48d1c50e-0ed4-4355-8b30-37ed358badcc	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
122fe77e-41da-4961-904c-eb029bf676e8	75bc07bb-6b7a-4414-b064-9f0f7c086217	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
03d61500-3412-4d21-8667-0832cc6f9d8b	a6138b49-27ca-485f-ad57-12f6ed08e94b	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a8c54dc4-4bf4-4079-b838-dc4c26bcc652	4742c248-e7ae-4e74-b513-a66f6f86a66f	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
d74acdd5-f709-45fc-8fd5-958ef1ebbf2f	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	a2e3eb4f-c4e3-4f3c-bfdd-2ca2c6f4b9ed	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
01911cef-d7b5-4a82-bb80-7f840051b371	b6fefa89-914a-4a89-bda8-e03a77dfbba2	55343256-1601-423a-b1a4-3d467d2b64c6	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b67959f9-980e-43b5-acd0-dcd8a205d20b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	691a7808-92eb-4fce-a618-d51867429491	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
3bdf1591-a058-44bd-a388-85248ca94bd0	7258a2ce-894f-4ce1-a260-84a7452f4d22	691a7808-92eb-4fce-a618-d51867429491	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
8ad6612a-13d5-4e6f-abcb-afe1f7c92666	5846ade9-c2a3-4042-b036-4a0e3e88a907	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
1c48fbcf-c088-45c1-a544-ff79bb2d4741	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
6b7f5b87-21e8-4893-9e0b-a3bdbdc2359c	5e27148a-c486-4282-9cc5-7ec352cd411b	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
c6b22abe-f09e-471f-8525-5a3b959a4f90	3d328497-971a-4cca-b0e6-6d959503bac0	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
f85c32e0-3d3c-4fbc-9f69-b9f1e3308fe4	e471db4b-ef29-4670-9730-3101f90741ab	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
76b38dc2-670e-473d-92ff-fcd970bffe57	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
3884c7d0-fec2-4f3e-8867-3c145347a29c	5e837acd-dae2-4186-b57c-ae70ee945f8a	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
c2f161e1-f28e-4f71-a07c-f9ef28082234	19ab8ef6-2d97-43c6-9b8d-d8763bab7242	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b7b6f6e4-636c-4293-aa0f-19117bca8e15	78587ca2-7caf-4b23-a0b0-16abff115c30	07ee028a-1e71-400d-a185-39dc4299803c	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
5910e683-42c6-4a0b-bc95-1aeba8758d63	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	07ee028a-1e71-400d-a185-39dc4299803c	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
f77d3b1c-6328-4e01-8177-e8e539501729	19ab8ef6-2d97-43c6-9b8d-d8763bab7242	07ee028a-1e71-400d-a185-39dc4299803c	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
c04c5e5c-850e-4d41-8349-96a0de31b046	dae9be5f-69f8-4aba-8707-3974bd4edf02	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
72822b95-1af2-49d3-b387-d56db49e9291	75bc07bb-6b7a-4414-b064-9f0f7c086217	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
cce812f9-6b0d-43b7-a2ff-6eda1f420338	a6138b49-27ca-485f-ad57-12f6ed08e94b	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
c8f98b95-337e-47e5-bc51-6c774a7de2f5	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a099124d-8593-44dd-914a-276343a2c2e9	4742c248-e7ae-4e74-b513-a66f6f86a66f	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
22fd5d61-902f-4937-8b36-39fe9153f9f0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	b9325221-963e-4909-8a81-6d00f3b1e7e6	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
21adc283-c8d1-4056-9593-a20e99d1d0bd	45aa8b28-c678-4e4a-9352-27ab690df852	317cf77d-0e89-49b2-82f0-b20073914c0c	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
3becac35-238d-49fe-bc83-30ff19b5459b	45f81bc7-ff24-498d-9104-18da7e5643f8	317cf77d-0e89-49b2-82f0-b20073914c0c	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
81119a9d-417e-4ea7-bae7-5e4d16cbbae9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	317cf77d-0e89-49b2-82f0-b20073914c0c	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
f0d47e25-1818-4acf-8410-e3a50387fa9e	7258a2ce-894f-4ce1-a260-84a7452f4d22	317cf77d-0e89-49b2-82f0-b20073914c0c	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
0190d2c7-f098-4eea-bf44-583acebb13b4	dae9be5f-69f8-4aba-8707-3974bd4edf02	4742c248-e7ae-4e74-b513-a66f6f86a66f	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
0bc75e9e-8dfa-4c1b-8da0-629be766ec68	75bc07bb-6b7a-4414-b064-9f0f7c086217	4742c248-e7ae-4e74-b513-a66f6f86a66f	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7cef30df-a620-45da-81b1-10fff4c2c139	691a7808-92eb-4fce-a618-d51867429491	86304602-3f40-481d-9a36-9a61a6289bf6	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
4c6d9175-bc4d-4afa-962e-fb579a443482	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
3bebab38-6412-4e94-98a3-84cd010d4b87	9c575b13-2b96-4e73-8ae6-21267b4cf871	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
89e706e1-fd5c-4016-be1b-c0b9d9f9cf71	7258a2ce-894f-4ce1-a260-84a7452f4d22	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a7fb555c-0152-4571-91fc-c3971ce173be	8b4f4e5f-3cf7-4790-ad3b-90f52d6c381b	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
09f6b3c4-dd97-42f5-afe3-ba2c6403cbf8	a7d7d2b7-8389-4a67-91e3-7aaf6940bf49	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
8682becf-241f-4e75-b1d3-663292edb965	5e27148a-c486-4282-9cc5-7ec352cd411b	19ab8ef6-2d97-43c6-9b8d-d8763bab7242	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7c6bbc91-8505-4fc3-b0a0-fef23790ece8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	19ab8ef6-2d97-43c6-9b8d-d8763bab7242	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b5c23740-dcb8-4c9a-9f18-8376f7f51781	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	19ab8ef6-2d97-43c6-9b8d-d8763bab7242	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
650843dc-1edf-44e0-bbba-253b9a6d6aec	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	8a5b931e-b073-4af9-a916-4b214183a825	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
09a9441b-e51e-4b86-9b75-0220b11a3b27	f270fd28-1c02-46bf-ac9c-8179ed1185bb	f3a78141-9a77-4b27-998d-d2b4d366e088	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
f8ec8887-7e48-44c4-8d38-166dc064cce9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	679443db-8000-4a0b-9fda-92d3e021a062	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
03d7206a-013d-48be-b1cb-6e44652261d5	a2e3eb4f-c4e3-4f3c-bfdd-2ca2c6f4b9ed	679443db-8000-4a0b-9fda-92d3e021a062	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
048cf6de-29bf-49fb-ac0f-1bf5db00132c	c17ad9e2-f932-4dd7-950a-2bb25a9b0772	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
023a3b7e-d51e-407b-bdb7-e67784ca96a0	8afbe459-f864-4ad6-98b5-595ac422f0ef	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b9ee2e19-7f43-48f4-8acb-c8af490380e2	b651ec49-f0b6-40b6-87b9-af90f919e1c0	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
3950549a-d303-4c6c-afd9-8e1d7c8c9f2e	704659f3-e212-472b-951d-80c1d942b506	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
4a4f53bf-a763-442e-a24d-48e26c1aff16	9079e6fb-d198-4c34-a483-39df60af375b	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
b2f39b1c-5e56-457b-81d2-7be81ddc4c2f	1595e4da-60d8-4646-8dcc-c761e435937e	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
6ff01707-e7e4-45a6-8166-179854d9c128	f270fd28-1c02-46bf-ac9c-8179ed1185bb	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
51690e7b-bbd3-40c2-ab39-cfaa66d29613	61b3566e-f3e2-4116-824b-0be7e6d5f9b8	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
17fe7b5d-4dbd-404d-85ab-e4b4c7f9ee30	631da6d3-9081-4d4d-8f17-98f6f1e128c4	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
68da2458-cd66-45e8-8d85-f3468115462a	f3a78141-9a77-4b27-998d-d2b4d366e088	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
56e4bc43-ef12-4a22-b30b-3aeb99f5ef99	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	109a4ba1-3456-4dcc-bc80-8f2bdd904da1	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
51e2b85e-0b4e-4ae1-8b58-5e9ac18b2cc0	012e0de3-ba65-4fd4-9a9a-f127d09672aa	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
07a49d38-2c0d-447b-916a-baaa65889df8	3e969c04-e8bf-4376-a556-2a039627e19f	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a12acfcf-d6fd-43dc-9e03-e8e2e17412a7	5e27148a-c486-4282-9cc5-7ec352cd411b	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
31785d6c-863d-497c-9ebc-0024b3681aef	5efc6baa-40ff-406f-aab6-3cd7e48a7f26	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7156f272-0808-4bb7-8c65-11b274e34ac6	38735eef-62f6-418b-a02d-14bc0f491031	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
8a6ccfac-7559-4cef-b095-597bb88e1763	339b8bf1-7cb8-4726-9ccd-f76faf83482d	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
da1c894a-5bf6-44d0-be54-96d60e562859	76437582-061c-4b94-9873-a4e3b6b8c787	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
a2c381e6-aa4e-4428-9c85-06403c529f07	78587ca2-7caf-4b23-a0b0-16abff115c30	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
abd2a686-ba27-455d-b51f-85f48a4af591	44a938f5-b9c0-4e10-aab1-bbabd979710e	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
c8f5a5da-ff55-4ed6-813b-3a6d10e81e10	c6872d71-bd61-4a1a-bcdb-ba79f37b1283	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
9f73cba5-b716-40d7-ad6e-6e5be6bf9024	fb06de97-b722-4281-99cf-482d421bd4b0	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
d8d00311-3268-4556-bd69-2cb9d7919fc4	4bd2dff5-6f63-4ad3-a9ee-61219df00045	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
d77ddd1f-3868-4a5e-b2b8-8f7e788bf890	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
7b91bd77-ca78-4c93-9ca0-e20cc63fbee8	8b9c80e4-3072-4dab-85a6-36e310fae6ef	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
74e42bbe-d82e-422c-af52-f5da16bde710	0da6fe92-db44-40da-854c-a84be86ab8d4	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
81293bad-0b5a-46b8-b08d-5db64541c354	29a63532-c5b1-4ebb-bba4-9a22abdd986c	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
20e13f58-e025-48af-9119-1f25540536f8	f2c5ae55-0e05-4127-b286-efc6fb88b4a1	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
f09f2627-5109-499b-963f-ac12bd38ab33	7a19a677-5c7e-4efa-99aa-2d7a536f4ba9	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
1c2aa2ac-4dd0-4ccf-b0f6-645b3a3776fb	9c575b13-2b96-4e73-8ae6-21267b4cf871	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
1b1067a1-465d-4b6f-96a7-6895681e3e1d	e93e5575-697d-4814-bc66-66b6d5d08f2d	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
dec61f82-4ece-4272-9e41-21ec062f8ae4	0134d7aa-9f38-4e9c-a172-f94415e1beb2	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
1cfe6164-3e31-4897-b966-e11c24c0aa65	c2a554a7-8f5e-4f75-a4cb-115cb59a4f75	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
50859b33-ee4b-420e-a9fb-27b7c93187d6	04ed257c-7497-4592-8157-d7526ebdbfcb	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
056880c8-7cc7-4a72-acca-f41b344ec951	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
de54afb6-9b98-48a7-ad1d-352551e904e3	97839cd4-0327-4209-b3a0-09744b78c944	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
9056da38-36c7-4299-b15c-a611e5c17cd2	ad927edf-b643-49c7-bb35-ce93c40e25f9	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
127d11c1-f517-4c84-8224-57edfd85a109	20115650-29ba-44fa-9861-99c990caa5b1	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
aabfcfd2-237f-41d0-8110-10c8a7369121	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
59a7e700-8acd-4bd0-b666-c2f10aec120a	0e243923-c4e6-4bf0-ae19-c0a5545f33c4	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
f4cee310-52e3-4409-935a-e0d2b2159e17	691a7808-92eb-4fce-a618-d51867429491	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
6ad15c3a-53af-4104-939d-b14d10c2786a	48a7ded3-0e70-425b-b587-8139188fb234	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
046d8996-ff99-45a0-8f18-48ab6394c29f	c1667389-c459-4ecc-a759-cd2b0d69d687	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
0ef1139f-197b-48f4-92a5-9058b8f93af0	7de32a97-e650-4e19-87e8-0040927e6844	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:51:46.901	2025-02-19 08:13:04.465
41a75545-f153-435e-8708-fb12219fe937	c1667389-c459-4ecc-a759-cd2b0d69d687	be269914-8f65-4e4c-b3c5-b02313f8b4ac	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a63f887c-9d30-48c8-8826-4dbc1a164da0	8fd92c37-ee30-48c5-9758-5b27c3768deb	835889ef-7e95-4dc9-9930-c517ec555496	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c8834486-bab6-45be-93b9-e37e6214790a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	835889ef-7e95-4dc9-9930-c517ec555496	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a8f777cc-d7a4-41a0-930a-bf51ae56f4f8	8b9c80e4-3072-4dab-85a6-36e310fae6ef	012e0de3-ba65-4fd4-9a9a-f127d09672aa	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
02280ca5-7830-410c-8c2d-205675a5e43e	dae9be5f-69f8-4aba-8707-3974bd4edf02	28058267-5877-4bc2-a880-395176bd6b22	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
219c3e42-294c-4579-8b12-39dd4d4ab90c	75bc07bb-6b7a-4414-b064-9f0f7c086217	28058267-5877-4bc2-a880-395176bd6b22	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f71ccb21-0e28-486f-a675-25085e5ccac2	a6138b49-27ca-485f-ad57-12f6ed08e94b	28058267-5877-4bc2-a880-395176bd6b22	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
951f815b-134b-4c3c-a3c0-a8fe93c12fb4	4742c248-e7ae-4e74-b513-a66f6f86a66f	28058267-5877-4bc2-a880-395176bd6b22	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
94905cd9-c7bc-4ac2-a13b-76301f1f1df6	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	7e2a2c9f-ceee-43a9-8c22-b0e99af67bf0	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
2c27c30d-2369-4ff2-be6d-35eb5fe1abe3	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	8812812f-8bbf-4ae2-914a-b8cae24cdbcc	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
ccc178d8-977e-430c-b0fe-c57f8469056c	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	5846ade9-c2a3-4042-b036-4a0e3e88a907	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c1f87f52-6ec2-4ea3-9688-52be57193644	29a63532-c5b1-4ebb-bba4-9a22abdd986c	3e969c04-e8bf-4376-a556-2a039627e19f	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
9ca74edb-c235-4397-af3a-428f3c29a5d1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	a9a5f83f-167c-4e62-b4f0-ed7a123d3990	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
dfc4d3a7-f10e-4a6c-9abc-be3b74c1e8c4	583dcdbe-fbdd-4ecf-800d-831c7f7716f9	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
5bca43e6-8a92-4cf7-b69c-15aedb162d30	1e2957ac-522b-4d7a-bc6b-5c33ca78ecde	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
4d93bd49-5399-4fa7-b754-eaef1f5108d5	c662510d-a483-4da8-b9c4-96f2bb450a40	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
8030aec4-58a1-4870-a703-ee9e51fb6190	728cb098-b1db-410e-94a4-d08a630d8076	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
9c07ebad-05dc-4199-9717-4322e1b2e50a	c2d8d0d1-43dc-4d39-9170-071ff5bf0cb2	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
6a3b85f5-3380-47e1-a9ff-9cac00da6834	5efc6baa-40ff-406f-aab6-3cd7e48a7f26	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
3a323b92-42b4-41cb-b2c6-33489c53486d	dae9be5f-69f8-4aba-8707-3974bd4edf02	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
7c9bfb71-097d-4a0b-92a1-85b2d865894a	fb06de97-b722-4281-99cf-482d421bd4b0	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f7e2e0df-62e6-4ad4-8453-3eed59631e3e	75bc07bb-6b7a-4414-b064-9f0f7c086217	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c7e47f4f-830c-4bdf-8a93-448eeddf3b3e	a6138b49-27ca-485f-ad57-12f6ed08e94b	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
01eaa2fa-9949-4c9d-9c81-8730a516f6c9	db049daa-59cb-425e-bdd9-c6dbbdff5b95	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
e0dc41e2-2a0b-4321-afe3-8e4243ed00a7	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
e2051c9d-24e8-471c-abe1-c45a025c952d	3ffbd728-c91d-40c5-8bb2-b45e93c1ff6f	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
93ce8ce2-3df7-4e3b-851b-893be5fa7b4d	a5375a3b-6bcf-4d38-ad41-d0f132461966	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f95b8168-a96d-4467-a1f6-66a1d1493751	ceb2e076-e8e4-4f5e-a944-e1d423c62834	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c3aab178-25dd-432b-bf77-c11951e250d9	5ed7695e-c900-4690-ab29-d4ecbc00d945	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
dfce4c92-1e7c-40b7-b127-64282c0118f3	481f84ac-0826-476a-8bf5-7ebf33a13fc5	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c25bb08d-b8f5-47b8-b808-7b2423557897	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
726cdfe4-bfe6-425a-bddf-fdb953303871	3970a38d-c005-44fe-9b79-e89b7b8a5ea5	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
73befaff-3399-40aa-8208-af7b436fa5a6	b720f98f-9a0c-43e7-958b-9855a27a7c71	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
153b5fe7-b7fd-4721-b78a-b746c0b20465	82897173-7157-4508-9557-9e6700c0dc4d	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
04c0e8b2-13ad-4a03-b804-97d5018b1967	42e3166f-a80a-4120-b00f-22224f3248b1	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f1150274-ed91-4988-96a4-1665a3ddfca5	eccfca5a-fe79-422a-86a9-00514d1a84f9	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
9c79b2ef-614f-40f7-8385-4f282d6ce276	87b40694-4414-4841-925a-176a00c7826a	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
6d90c02d-c0d9-46b1-bd99-22dfc48d68f5	04383a3e-b5cf-4875-99a7-fdd746e9cab0	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
4c99b806-1bf8-4713-968d-6790d2e5ad8e	04c83856-9ff0-475a-b2cd-db05406b84a3	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
3f1b98ee-69ae-4a78-ab37-792bd868a60a	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
852d134a-c1d2-4b2e-b482-b102463ed4f8	b370e760-5bed-4ade-8488-fe7c4c972e04	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f62a3138-33b8-48db-b768-4fdaf4be79a9	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
7088e549-a2ce-47c0-88ab-ea6bc5c8ac7c	b9325221-963e-4909-8a81-6d00f3b1e7e6	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
ea3ba422-9a99-4880-be0b-1e80bdee176e	77d688de-9a29-4e5f-a453-9479a9fd7f8d	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c7914c20-b74b-4ae7-b879-06fa91574389	28058267-5877-4bc2-a880-395176bd6b22	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
cd001547-2ea5-403b-baa7-787da15f510c	5b316a00-25b2-4fd7-8796-5dbb7f51f948	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
5ec17c06-a0cb-4817-a4bb-bd21159664cc	dae9be5f-69f8-4aba-8707-3974bd4edf02	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
495db58b-b0fb-43fc-ac7b-e269700cb8b1	82de6c86-64f8-4b2f-afb3-ad42f3064102	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
96218802-f8db-4361-b6fd-70bc17a9ab05	76437582-061c-4b94-9873-a4e3b6b8c787	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
aac21b86-8f44-45e6-9bc2-9e6ee7614b9c	36fa3c27-a0c6-4407-a386-a0b57cbbd453	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
9fd48498-0ad2-41e9-9537-cb7001dc9d28	fb06de97-b722-4281-99cf-482d421bd4b0	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
505aa2e8-c726-42c9-8a25-ebade64eeebb	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
653156a6-7d14-483d-9496-d1143afb65b2	6c50a910-149e-4247-af57-91342ca69c26	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
5c4921a5-f9ff-4659-ac7b-3499adbc5a37	a6138b49-27ca-485f-ad57-12f6ed08e94b	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
55beeb51-67a6-4f26-8240-1afe260cfd5b	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
befb8523-6f3e-4c29-a7b4-9a56da6f518c	5ed7695e-c900-4690-ab29-d4ecbc00d945	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
3a32e56b-aded-4de1-94f3-c584c8b118b6	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
d50e8c39-3b51-46e2-b08d-919196b44b9a	42e3166f-a80a-4120-b00f-22224f3248b1	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
43017f03-6eb5-419b-9de0-5650bbee01ad	87b40694-4414-4841-925a-176a00c7826a	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
13999e60-f9c2-4c37-8d98-912480932ad2	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
9b299c48-46c7-4763-a503-02731b3614ba	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
25d767b9-925f-4040-9f26-56e162b6b63f	4742c248-e7ae-4e74-b513-a66f6f86a66f	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
d1794cc6-30a5-49eb-b3d4-33ce159f7c54	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
6df882d4-4956-44dc-bde8-f6b429c6a202	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	5431a241-78ce-4b21-b128-28dea9f8fae9	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
87c32ef0-f64c-4188-b011-aa099950f608	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c53ce851-fa9d-41ad-a7e1-416cb7b166fe	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
097e40ca-6376-40b6-9fc7-a56578a3b66c	82897173-7157-4508-9557-9e6700c0dc4d	c53ce851-fa9d-41ad-a7e1-416cb7b166fe	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
20b85459-cecc-47b3-b8d9-641a38d25b8a	48d1c50e-0ed4-4355-8b30-37ed358badcc	c53ce851-fa9d-41ad-a7e1-416cb7b166fe	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
05a493df-3d96-4e95-8a02-9a0df66ad934	b9325221-963e-4909-8a81-6d00f3b1e7e6	c53ce851-fa9d-41ad-a7e1-416cb7b166fe	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
eae7a35a-da31-4571-b8bd-7f2c4ce4ce0e	a8af0e64-0ac6-46fb-99f1-6da08eeab725	f3173f6b-71d2-47c1-9768-4ed28d2ee620	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
22cfa61d-fc2e-44cc-9628-8449269ab478	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	f3173f6b-71d2-47c1-9768-4ed28d2ee620	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
54ae6637-a872-46ec-89c6-6a9851b844b4	5e837acd-dae2-4186-b57c-ae70ee945f8a	f3173f6b-71d2-47c1-9768-4ed28d2ee620	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
4d03273a-cea7-473d-97ad-a91d7cd4f579	36829335-1ae2-4400-86b9-84fd4bf2de32	f3173f6b-71d2-47c1-9768-4ed28d2ee620	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
54a45435-5265-4572-a0e6-5abccf87f21e	b3aa0f67-975e-4e8e-a7e5-8f82817802cd	f3173f6b-71d2-47c1-9768-4ed28d2ee620	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
3d8030ad-8307-4af3-b16d-2d7713fdd0a5	a2e3eb4f-c4e3-4f3c-bfdd-2ca2c6f4b9ed	f3173f6b-71d2-47c1-9768-4ed28d2ee620	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
ae8aa665-657b-4b04-85a8-14044f6575d7	c1667389-c459-4ecc-a759-cd2b0d69d687	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
1c5e872b-9b8a-4454-b4a1-5c09045aa9db	7e2a2c9f-ceee-43a9-8c22-b0e99af67bf0	dab9453b-a30d-44ec-a414-132e953c2408	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
edec6f72-87ba-4fb0-bccf-7bb780a8a951	3e969c04-e8bf-4376-a556-2a039627e19f	dab9453b-a30d-44ec-a414-132e953c2408	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
4803a4c6-2bdf-45f5-b6a4-0e88611cc5f0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	dab9453b-a30d-44ec-a414-132e953c2408	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
ea213264-f0c4-448f-a495-cf4886a9565f	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	dab9453b-a30d-44ec-a414-132e953c2408	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
ea4cbefc-7e53-492e-8985-d840536a19ee	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c1e73591-e3aa-4c35-842b-6e5ef3a4ac55	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
677a30b0-b246-44b8-bb37-49ea9c54ccb5	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
fdd5460a-ec08-4046-9dec-cce5c37ad79a	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
5c7f7a82-7b56-4743-b01f-5ef3a2513abd	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	5fb9c23d-5236-4675-8c9b-537ea30e248f	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
4618f65f-878e-4fde-9b60-24de3189514c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	efaa39f8-49da-4aed-93e9-e2ea217fc9b8	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
25b098ce-65a1-43e6-bde1-c20cc2c0f6da	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	1aa37920-edce-42e7-98eb-4c32345cc71a	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
5d04c90e-8d5a-4ff3-8d96-691a37e806f1	dae9be5f-69f8-4aba-8707-3974bd4edf02	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
cc486a2c-b400-4b3d-b445-06b4840ddd6d	75bc07bb-6b7a-4414-b064-9f0f7c086217	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
0dbe4681-f2c2-4fa6-bbfb-e307625d152c	45f81bc7-ff24-498d-9104-18da7e5643f8	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
1da65b48-fbe4-4528-9ed3-e9128052cb7c	0da6fe92-db44-40da-854c-a84be86ab8d4	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
16a12a9f-e120-44a3-9780-8faf03b9d4ca	ad927edf-b643-49c7-bb35-ce93c40e25f9	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
16d50a66-bae7-426a-9f87-5daf5c3484bd	04383a3e-b5cf-4875-99a7-fdd746e9cab0	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
4309ba26-b1ae-4864-b029-3f3fde248050	04c83856-9ff0-475a-b2cd-db05406b84a3	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
551e00c4-534d-4356-9f13-ced0bb2724fb	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
8a5aed1a-463e-42f3-89e9-9f7e8ee26d2b	d15bfb61-8af0-49af-af82-24696cd922a9	699de247-c0c8-4a8b-bae8-6ba24d9489c1	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
ce545be2-d5c9-4175-b88b-b44a1e360d70	dae9be5f-69f8-4aba-8707-3974bd4edf02	c2d8d0d1-43dc-4d39-9170-071ff5bf0cb2	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
dd37e86e-1c96-4b98-b1b9-98677e687ea5	0da6fe92-db44-40da-854c-a84be86ab8d4	c2d8d0d1-43dc-4d39-9170-071ff5bf0cb2	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
d4ec1e1c-b102-43b6-9dd9-3b547612ff78	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	c2d8d0d1-43dc-4d39-9170-071ff5bf0cb2	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
853c1ce5-9daa-4fb5-89da-4f95b0098dcf	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	204d395b-19aa-483d-ace2-1fe096cf0c7a	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
8dba0961-51ad-494b-b9a3-53a17529a921	87b40694-4414-4841-925a-176a00c7826a	204d395b-19aa-483d-ace2-1fe096cf0c7a	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
cd64f0b1-ab05-44ca-90ec-892303428418	dae9be5f-69f8-4aba-8707-3974bd4edf02	5efc6baa-40ff-406f-aab6-3cd7e48a7f26	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
279b836f-fe36-49c4-a2d4-a2c141009463	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	9c4c3855-f8c8-4567-b5f9-db4c8d90b4e5	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
12627f78-c822-4415-90dc-6b2846f725d3	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	5b316a00-25b2-4fd7-8796-5dbb7f51f948	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
de8f32a6-15fe-4429-9161-420006c00d2b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	b475c6de-61e8-4434-8e6c-5b7de040c4d0	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
ad68f842-a553-41ce-8657-15fc55aa5eee	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	d15bfb61-8af0-49af-af82-24696cd922a9	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
52bed78c-a6fc-4d95-a539-fee102b9e8d6	204d395b-19aa-483d-ace2-1fe096cf0c7a	3d328497-971a-4cca-b0e6-6d959503bac0	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
629715b3-ebd6-4bad-b63d-3d28b10ef3ed	3d328497-971a-4cca-b0e6-6d959503bac0	3d328497-971a-4cca-b0e6-6d959503bac0	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
ed49f488-b847-406d-b86e-6d93608e9fbb	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	3d328497-971a-4cca-b0e6-6d959503bac0	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
4cf72f95-ef0b-47e7-a0db-0fb10f6f4529	e53c3d28-bad0-465a-9b49-e0209ff0793c	e53c3d28-bad0-465a-9b49-e0209ff0793c	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
b6b551f4-0a92-47da-9932-3c983bacf861	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	e53c3d28-bad0-465a-9b49-e0209ff0793c	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
b389fc32-c0d8-4912-abc4-1e6e0f226168	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	e471db4b-ef29-4670-9730-3101f90741ab	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
2e46d176-93be-4684-94f5-4fc7d52ba7fd	3a3e0676-66e8-487f-8eba-e64eefe2bf2f	8b6bb28b-3a33-4499-8d67-2bb589dfb8d8	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
ac182cc1-fc20-4fe2-a312-f61a708b1b19	39144bf1-9a12-4d6d-a814-b769473d158f	8b6bb28b-3a33-4499-8d67-2bb589dfb8d8	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
cbc92346-9fe1-4dc3-837f-9e09a4938409	e93e5575-697d-4814-bc66-66b6d5d08f2d	8b6bb28b-3a33-4499-8d67-2bb589dfb8d8	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
93bd324b-5cee-4fb7-ad82-58a762519ed4	e93e5575-697d-4814-bc66-66b6d5d08f2d	6fc7cc75-200e-49fe-935e-79111fb8948e	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
b6d012a6-a4d7-4c6e-9aed-682bce71d794	36fa3c27-a0c6-4407-a386-a0b57cbbd453	dae9be5f-69f8-4aba-8707-3974bd4edf02	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f5b78692-f79a-497c-8a94-0d739f2fed2f	75bc07bb-6b7a-4414-b064-9f0f7c086217	dae9be5f-69f8-4aba-8707-3974bd4edf02	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f6e682f5-ba96-4c0f-a666-d3744254f33a	a6138b49-27ca-485f-ad57-12f6ed08e94b	dae9be5f-69f8-4aba-8707-3974bd4edf02	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
4c1e1c7a-18e6-47f0-9cdb-2d6aaa35c6f7	eccfca5a-fe79-422a-86a9-00514d1a84f9	dae9be5f-69f8-4aba-8707-3974bd4edf02	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
b0de867e-9d9c-40d5-98ba-d645bf986f42	87b40694-4414-4841-925a-176a00c7826a	dae9be5f-69f8-4aba-8707-3974bd4edf02	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
291afc29-5992-4d90-97dc-5fa8ce7d8df9	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	dae9be5f-69f8-4aba-8707-3974bd4edf02	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
62fe57ff-ebf5-4307-ae61-d58da083323b	4742c248-e7ae-4e74-b513-a66f6f86a66f	dae9be5f-69f8-4aba-8707-3974bd4edf02	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
0ad5a663-4b89-4fd3-a456-8be55a7dba3c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	82de6c86-64f8-4b2f-afb3-ad42f3064102	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
06b42513-ff94-41ff-89ef-0951e82a4629	4bd2dff5-6f63-4ad3-a9ee-61219df00045	bf0d2a55-ea51-4de8-bdfb-0e13d2fee800	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
855209b8-40b9-4f6a-9ce6-584eaa735f08	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	f7578885-4640-41c2-9831-c994c131ab57	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
208709b2-670b-4d9d-9032-d33a3d191f08	583dcdbe-fbdd-4ecf-800d-831c7f7716f9	0ff90b8d-2766-423f-aee7-0393dae688ea	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
cef5e101-6cb4-47e8-bb14-71b98a54e398	1e2957ac-522b-4d7a-bc6b-5c33ca78ecde	0ff90b8d-2766-423f-aee7-0393dae688ea	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
255cd651-f0c8-4534-83aa-5e0555f5c5f6	437a268e-e28e-4d15-b50f-3190fff9acaf	0ff90b8d-2766-423f-aee7-0393dae688ea	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
ddef80f2-e12b-4b4b-a360-5ec8a775b0f8	cf6d3ef6-631e-43f5-8ed7-2554c4bc570e	0ff90b8d-2766-423f-aee7-0393dae688ea	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
ef43dc64-191e-46ee-9eb6-b310546f941e	3e969c04-e8bf-4376-a556-2a039627e19f	8f2abc6e-f4cf-4ce0-81fe-6a326079d556	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
9e8f0eb8-1005-4a9e-8bc7-596177de0ae1	8b9c80e4-3072-4dab-85a6-36e310fae6ef	8f2abc6e-f4cf-4ce0-81fe-6a326079d556	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c79d76cb-9d7d-4812-b0dd-b8a193cc25f4	29a63532-c5b1-4ebb-bba4-9a22abdd986c	8f2abc6e-f4cf-4ce0-81fe-6a326079d556	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c1560299-4ad5-4b59-9980-0b232160ac9e	c1667389-c459-4ecc-a759-cd2b0d69d687	8f2abc6e-f4cf-4ce0-81fe-6a326079d556	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
cc459cdf-200e-4887-939a-1374f1611aa8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	abfbdf7e-6cb4-4977-82ef-93211e950a6c	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
9f2c7a14-69e1-424a-ac56-955680dd6e6c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	76437582-061c-4b94-9873-a4e3b6b8c787	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
1f4ce5ac-c79a-4083-bb3f-66714e4992d6	dae9be5f-69f8-4aba-8707-3974bd4edf02	36fa3c27-a0c6-4407-a386-a0b57cbbd453	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
8a799d0a-1804-4e54-a717-9595d163245d	75bc07bb-6b7a-4414-b064-9f0f7c086217	36fa3c27-a0c6-4407-a386-a0b57cbbd453	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
69295a0c-33ff-45b3-9448-4dd6cb1f00b9	4742c248-e7ae-4e74-b513-a66f6f86a66f	36fa3c27-a0c6-4407-a386-a0b57cbbd453	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
7c2f6361-323d-4ae9-abca-9177b64aa3fb	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	b651ec49-f0b6-40b6-87b9-af90f919e1c0	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
0b9110fe-90bb-46bf-b15d-8bba83948e01	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	a9a3eae9-470b-4e07-ac58-37a0d62d0ada	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
6d1a1cc8-9323-4ca1-a990-c1fc635d9f7d	6781d49e-0a52-407a-bbd9-57152fa52741	a9a3eae9-470b-4e07-ac58-37a0d62d0ada	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
23adc7d7-4d34-4469-9a27-0e65bc79e704	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	704659f3-e212-472b-951d-80c1d942b506	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
30ebf640-0cbd-4dcb-b9fd-9a0ae70e9750	631da6d3-9081-4d4d-8f17-98f6f1e128c4	704659f3-e212-472b-951d-80c1d942b506	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a4cdf69f-c061-4d30-8e11-0e2c84465549	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	66324a2e-a1aa-41ae-ad82-1e3edb50b082	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
eb08c5a0-daf5-4a49-a327-a6cb43cbe3af	cdfe543c-a78e-4dbc-ba5b-f3a8e6aaf43a	c75d3de2-68b2-41b1-ad03-687393e3eca1	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
87693eb9-ba9b-4795-ab7b-342b13ecdbef	5431a241-78ce-4b21-b128-28dea9f8fae9	8aad06a4-5b48-41bf-8bff-e965cd620dc2	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
e4a31730-6d36-4bf6-803d-55d18b2c0290	a6138b49-27ca-485f-ad57-12f6ed08e94b	fb06de97-b722-4281-99cf-482d421bd4b0	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
48c4d430-a83a-49fa-8b59-e31569a2b9f8	4bd2dff5-6f63-4ad3-a9ee-61219df00045	4bd2dff5-6f63-4ad3-a9ee-61219df00045	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f6549888-baac-48db-afc8-b1f4509d095c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	4bd2dff5-6f63-4ad3-a9ee-61219df00045	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
86542ec5-d001-48bf-a103-86fafd132ec5	dae9be5f-69f8-4aba-8707-3974bd4edf02	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
d7626134-2af9-4c54-98d5-75d540e33a5c	36fa3c27-a0c6-4407-a386-a0b57cbbd453	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c03defe1-e5bf-4af5-8c7c-eacc4f38a17b	45f81bc7-ff24-498d-9104-18da7e5643f8	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
b9d8df05-38bf-499e-a633-6e1ad30ba11a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
1eab2a1c-655f-4eac-8691-79aed62eb4b6	a6138b49-27ca-485f-ad57-12f6ed08e94b	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
8da43093-a81d-48c6-9adb-aa4aa2a22f5c	5ed7695e-c900-4690-ab29-d4ecbc00d945	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
dad8815f-e11e-4771-b1fc-8dab000ff48c	04383a3e-b5cf-4875-99a7-fdd746e9cab0	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
3dffbfb3-a9d2-4207-a476-683d708a91ee	04c83856-9ff0-475a-b2cd-db05406b84a3	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
462c65cb-5cde-4d7b-9ca1-24cd7f489738	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
5167065a-2471-457a-ac56-4fa02bee0876	4742c248-e7ae-4e74-b513-a66f6f86a66f	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
baaa6a66-e661-4735-aeec-7d5e49027582	728cb098-b1db-410e-94a4-d08a630d8076	45f81bc7-ff24-498d-9104-18da7e5643f8	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f8cd135c-38c1-49fe-8b71-10e11ee09d97	75bc07bb-6b7a-4414-b064-9f0f7c086217	45f81bc7-ff24-498d-9104-18da7e5643f8	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
836bce4e-838e-40d9-81d4-984794a55109	a6138b49-27ca-485f-ad57-12f6ed08e94b	45f81bc7-ff24-498d-9104-18da7e5643f8	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
df33b1c2-02c6-492c-9558-4081890de4fe	ad927edf-b643-49c7-bb35-ce93c40e25f9	45f81bc7-ff24-498d-9104-18da7e5643f8	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a6cffa03-d61b-4f7c-91c4-e1726af1f2bb	04383a3e-b5cf-4875-99a7-fdd746e9cab0	45f81bc7-ff24-498d-9104-18da7e5643f8	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
0906d0f5-7c9a-49cc-9256-98628cce0db1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	838a9ef3-af3e-4655-99b5-a06134155c07	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
9a12625d-9f64-41fa-ba61-934aa262baea	28058267-5877-4bc2-a880-395176bd6b22	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
166772dc-cc41-4e04-96fd-ffe8a71d83de	8812812f-8bbf-4ae2-914a-b8cae24cdbcc	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
74d2c2f0-1793-4c85-9ae8-eda1a1b2e640	583dcdbe-fbdd-4ecf-800d-831c7f7716f9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
64a77c74-7028-44f5-b263-344b72279841	e9c970a7-cd3b-452e-b6f7-70b9d9d60148	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
576ccbb3-7cc0-428c-a9d4-4f57b61142da	3e969c04-e8bf-4376-a556-2a039627e19f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
cbdc085e-3996-4dc0-80c6-fa397b1e728d	e23dd0b2-7699-4b27-9b31-7966d2d7376a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f0ac612c-2ce9-401d-b76c-4f7348914a11	e5b526bd-4554-4b99-bf91-204c2583a5fa	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
aded81a3-9be5-4711-98d7-ea1844969a2c	5431a241-78ce-4b21-b128-28dea9f8fae9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
8deb21e3-fd96-466b-9f82-2f4f7ac8a397	47e2ce69-9af9-4b6a-8c32-c1ef3bb659e1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f9e84f42-c94f-40ba-aaf8-f22c71b5db0e	c53ce851-fa9d-41ad-a7e1-416cb7b166fe	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
00bace1d-b433-48ff-b14f-965cc81356a2	dab9453b-a30d-44ec-a414-132e953c2408	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f1bc92d6-bbc1-4782-9587-94ccf30d23cc	1e2957ac-522b-4d7a-bc6b-5c33ca78ecde	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
188be736-2bb1-4339-aef3-5a715335a7ed	eab0bcf1-82f3-40db-82fb-ace10ee4a383	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
7f9b4e1c-d09d-4bc8-90ea-213e6b51f8fe	c1fbb481-dd2c-4585-9b7c-06d180d77d2d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
e3730679-ab5c-449e-ba7a-f6b769f12352	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
e89a3286-b6d3-4c23-bf83-271b13084c47	d0104fdf-dc7c-451c-8f1f-3f9abb4de8e9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a8665f2b-9d66-41f3-9a1b-d3d8d89366dc	5fb9c23d-5236-4675-8c9b-537ea30e248f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
9cfc9b95-57be-4b37-8a13-20156349bb81	1aa37920-edce-42e7-98eb-4c32345cc71a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
ccf4066d-9489-4143-b9b8-c39e1f43ba2f	69fc4171-6fad-4eaa-a382-8994f76b1f8a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
572a8c0e-09fa-4c86-b612-6827393a92b3	c662510d-a483-4da8-b9c4-96f2bb450a40	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
4a42cb49-4695-4ea4-b3fc-d44bffaf40d3	c97bb436-c55e-4222-a494-49af4ac02b31	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
7382957f-4f09-41d3-85bb-915c3a352b5e	728cb098-b1db-410e-94a4-d08a630d8076	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
e517a3de-15c6-44f2-a9c4-734876975060	5e27148a-c486-4282-9cc5-7ec352cd411b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
74c5dd90-7463-48a3-ab27-cb794e818654	b108c58a-4722-4bb6-bf8e-d3486b06d900	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
9a2c89d5-ce5b-42cb-8122-3e47a640b8f8	407ae14a-060d-4d91-89d1-39535ab93b0a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
4115821c-7c44-4803-b0c9-cc0b58597dad	ccd77641-e05b-4160-8b88-90f763fd56cd	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
17812936-9f03-476a-88a9-46fc29f3e398	c3e729df-b864-488f-950e-b828d01ab4e0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
22cdab06-10e4-4efa-85ec-97f33cd5ef7e	539dd60d-44d6-4808-a75d-976f4ff14489	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
eeaa6da4-51da-4b90-b225-43d6b3680d43	4cdac558-f594-40ab-9bd7-2d3a30f344d8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
27dae918-511c-4318-86a8-dfa602eb8738	c2d8d0d1-43dc-4d39-9170-071ff5bf0cb2	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
84a6e57d-5ca3-4690-990c-1bdb65182da3	204d395b-19aa-483d-ace2-1fe096cf0c7a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
3033975f-24c1-46a6-802c-90e09ebd457d	48101c5e-8026-4206-9b7e-bb3c01018b75	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
362c875a-a821-4f53-b6ef-02df6cd874dc	cf1e383e-42f9-4548-a737-ffa464a2a1e4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
6a0a0f09-736e-4aef-92b7-cea6358e5fc4	7b962db5-8fc5-4b0f-82ea-4c3728add8a5	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
b0b60bac-7762-499c-a778-93f04699196e	45aa8b28-c678-4e4a-9352-27ab690df852	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
0179f88e-f7fa-450f-a384-6eaa90228c1e	437a268e-e28e-4d15-b50f-3190fff9acaf	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
9e81b9fc-10b7-4b1a-91b6-350bfd011c15	5efc6baa-40ff-406f-aab6-3cd7e48a7f26	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c52e23f1-1442-4d09-bdef-5574cff4dee9	9c4c3855-f8c8-4567-b5f9-db4c8d90b4e5	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
4166dc0c-2f9f-4164-a915-c07663399130	9bdf6f88-144e-4836-9d28-a1e6715e47e6	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c7d197d2-af71-4393-9c5e-49fba39392d3	5b316a00-25b2-4fd7-8796-5dbb7f51f948	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
2707e5a0-a022-4cc2-860f-0dbbc5bf4ea1	2fc63575-ed81-4633-9117-b8fcb774cf85	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
cc9506e9-58c3-4ded-b3e6-9c40758c016c	d15bfb61-8af0-49af-af82-24696cd922a9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
3050b2f4-0731-4390-af74-f8c8ae2965b4	1543db57-9c36-4a03-b917-401ada53eb22	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
cb8c3c3a-0d1a-4e2c-a649-cfa2e0f7a08d	3d328497-971a-4cca-b0e6-6d959503bac0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a152258e-1919-4c86-8946-4bd13719e1b3	e53c3d28-bad0-465a-9b49-e0209ff0793c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
cd5a4568-e08a-4bb6-b64c-375dee890710	e471db4b-ef29-4670-9730-3101f90741ab	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
025b9753-3b2d-4d3e-96d2-d5dfa290d818	8b6bb28b-3a33-4499-8d67-2bb589dfb8d8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f0cccb02-35ed-4425-a55a-f40a3e8a517e	6fc7cc75-200e-49fe-935e-79111fb8948e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
6769d241-8181-4c5f-af12-d63fe5d4aad1	3c7cd7ce-dcc5-439d-ae39-00f31f02030d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
96202615-b2a5-4efe-98a7-a55a6355f479	60c1c053-6438-451b-9772-4525172235d0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c751abff-2f3c-4a09-97ad-a4b910c539f4	4088dc01-b5cc-4127-98cd-93debca761df	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c5fcf3ee-ab71-4edd-83fd-f6ea25177869	80d50a82-65db-4ce9-bf3e-e679c14b6765	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
79be1423-59f9-4ef0-a176-8e0b120d9baf	dae9be5f-69f8-4aba-8707-3974bd4edf02	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
05c21c52-7bb6-419b-8dfb-07d2064a7b87	b998f6fd-4ed6-46ac-a68a-cac842099b5a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
67312308-2aa9-40fd-b3bd-14898a5a3fed	82de6c86-64f8-4b2f-afb3-ad42f3064102	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
ccde5e17-65aa-4359-af7e-12a0a93c51e5	f7578885-4640-41c2-9831-c994c131ab57	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
3cc47ebf-6ece-45b6-9e5d-810bd29ccf52	ac2d044e-0c82-4e7c-bc7f-2781191a1148	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
52091384-5663-43d9-8f8e-454c547fa517	4fa50c02-239d-4274-b782-0286c6a1b05b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
da460839-91f3-48f5-a569-d495c8c92a54	63d512ee-b850-4993-b486-e5494d188bfe	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
299825a5-a98c-4cda-a77c-aa2f46b1189a	dbc18365-0064-48a1-a511-f11f56929643	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
e1e392b5-587d-4c9c-a369-df553b1c0f2b	0ff90b8d-2766-423f-aee7-0393dae688ea	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
db8bf200-ec8e-4834-8891-99dc0bdf27ad	1349490b-955e-4a0b-b00b-c392d1cb71c1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
90feec61-82be-4561-a22b-a7e2b5a6c055	abfbdf7e-6cb4-4977-82ef-93211e950a6c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
9fb596c0-f4c9-4b9b-a55b-3d3e664a0d23	76437582-061c-4b94-9873-a4e3b6b8c787	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
62702ca2-5b87-4d01-93e2-1671f3ae8f3a	2c161160-a3de-4af8-b178-11700da1ed54	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
7bce10a9-7a8c-4530-a479-210a13113896	d99d51b7-3349-4bf6-8803-618705c95d2d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
08377dac-71ff-4ec3-84dd-1048dced161d	0cab1976-8937-46ee-8a8d-9e3d831d258b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a909cb92-a032-44d9-b4d0-72e7d948dd1b	5ddcc4e4-ee30-48b1-939a-09439b14e6dd	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
5563263b-9a37-4756-8789-238c62c36e1a	36fa3c27-a0c6-4407-a386-a0b57cbbd453	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
fc55c5b3-a0e5-4d3c-a97d-10cd0e100fb1	b651ec49-f0b6-40b6-87b9-af90f919e1c0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
e3b956bb-b7ba-4239-be07-2834667cdda1	a9a3eae9-470b-4e07-ac58-37a0d62d0ada	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
9ab8209e-97ff-422d-9d5e-43dd18379688	1bd86dd9-872f-4a68-8602-a60813df56c8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
8b622463-d3e1-4c7b-82bc-fe07c4333be9	704659f3-e212-472b-951d-80c1d942b506	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
3c309c7c-f7a8-4635-a740-138655d386ed	60aaec3d-f58b-40c4-8ecc-f12c307faf17	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
4f31ab55-5242-4d11-a939-2e31159aa834	12f68791-85a0-41c8-8b5d-e80943e321da	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
5eaaa50b-83aa-422f-8402-72d574ab14f2	998a1f5c-0ce8-43d0-addb-c6861ab126d9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
624e3cfd-6a5c-408c-8854-f63cc4f69db3	78587ca2-7caf-4b23-a0b0-16abff115c30	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
cea5115d-8594-4a51-82dc-7d2a29cdebc3	c75d3de2-68b2-41b1-ad03-687393e3eca1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
30b4c357-efed-4273-b372-b203984d93f3	6895b079-41da-4c80-9b03-a13205bca38d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f7132681-465c-447b-8447-a6731b09d3a2	688d0ae3-2734-46f8-94ba-26314aeec7c9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a7826bbc-daa0-4d85-8dd0-03f70fcb4450	04a73285-3f3c-433f-917d-15f913b0737a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
5976a341-ef06-413e-9730-e300cb407299	fb06de97-b722-4281-99cf-482d421bd4b0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
ff1d29f1-e577-4a95-bd64-516066c5a118	4bd2dff5-6f63-4ad3-a9ee-61219df00045	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
6a3be8a5-d739-4710-a98e-e660cccd2c37	8490695f-9b65-4b5a-b9ee-2a0987b921dd	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
d0a2e7b3-83fa-4dc5-b270-2549e1658663	75bc07bb-6b7a-4414-b064-9f0f7c086217	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f268a3b6-746f-4637-b1d2-5e3ef370c697	45f81bc7-ff24-498d-9104-18da7e5643f8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
23152eb2-5b75-4bf2-a4e8-010c52cc8e32	4e2bc8e4-d7fa-4757-adec-22c5c62d9b69	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f5af9fe0-432c-4661-8213-c8dcb3cb770d	8b9c80e4-3072-4dab-85a6-36e310fae6ef	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
3778c44b-c073-43d2-9e5e-ef67b1fe90ec	706ae8d3-4398-4f3a-b0c4-d2476d6e9d97	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
524209f6-4ecd-421e-ba3d-86304adf47db	0da6fe92-db44-40da-854c-a84be86ab8d4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f4536e1e-d8a7-40a0-a53d-515f0275336b	6c50a910-149e-4247-af57-91342ca69c26	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a675f1c4-d5be-451b-b050-745c7dfab9ec	67c41f98-232b-4c1a-ba47-348bc540c17a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
18562aea-9d04-4d94-8006-8c621239eed3	ac8046ab-5699-4eda-bde8-056ccc1dcda0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
90078ea0-3637-4c03-8046-dec74f28c7c8	a6138b49-27ca-485f-ad57-12f6ed08e94b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
75a890de-f111-4d5b-9b89-8edcd96fe0d0	2ddcfb31-7ace-442b-9cf9-eb1966e09627	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
2df0b2dc-0c9a-4261-90d8-e7cc6bfe1d3a	e1d0121d-7fc5-424b-860e-065f92776ca1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
31be3e0a-7083-4a64-ac73-da3f2268e5bd	9079e6fb-d198-4c34-a483-39df60af375b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
184531f0-0db6-407c-a571-e69ae2857953	0be157db-7f72-4e13-9c10-5b3a30bebd76	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
579a1958-48b5-41ed-a8b9-1e6bb4bbab87	d05bf38b-f898-4dfc-adcc-dce47a90a1c7	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
64168ae4-4ecc-4588-962b-9c8258d7c9f5	d20a6a07-b621-4dd3-a202-78ac56696c2c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
38673785-3b07-466d-b82b-3f45770e0103	12f8683d-d1eb-4e71-b60f-75df4e0f8169	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
dda1b474-d429-4879-8704-6afe15b24b4b	db049daa-59cb-425e-bdd9-c6dbbdff5b95	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a47f071b-d0c4-4ffc-9768-438d7a77dbee	1595e4da-60d8-4646-8dcc-c761e435937e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
dc61757b-170e-4300-b317-84130db36522	fc57deea-20e3-4959-bb07-ce80c36b7a8c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c769b4d5-c5c6-40ff-ad1d-1a983a707977	ff42b26e-122c-4b16-b896-f06c990c2c01	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
9e1ab1b7-d517-431c-8643-85eb34650730	1a88ebc2-fa9e-4566-9043-3904425b19ea	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f106c690-e2cd-4433-a744-f9db6a45289c	cf6d3ef6-631e-43f5-8ed7-2554c4bc570e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
3544d7f4-bce6-4b25-9227-5bed1010b677	bd9d47bf-0c6a-41ef-8fa7-9924e9cc868d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
9e9436e3-f3f7-4efd-ae82-ac365ad0453b	f270fd28-1c02-46bf-ac9c-8179ed1185bb	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
fbaf46d3-dd35-400f-984d-14c50c1b9d15	ba7cf405-2477-4369-97ef-ed720e0686b6	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
128f4a98-0eea-49d8-abe8-b52b4c2a871b	e0161890-fc0a-40a7-b14c-0bf1d40cf3d5	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
311eee14-17a1-4a95-8784-cea08678aca8	61b3566e-f3e2-4116-824b-0be7e6d5f9b8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
0fe2f1f0-4590-4cef-8245-f00293179214	8d376618-ce43-42a3-aa6e-4a7a3cd11f36	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
28ade6ef-fc6f-489a-8d53-b327fb854fff	3a3e0676-66e8-487f-8eba-e64eefe2bf2f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
353b645d-8c16-4b75-a47f-0092d8506660	bec4ca37-50c4-46ea-9840-a0228ce9df38	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
db8d93d3-9d79-4945-9c71-f67224019884	c2a418bd-aae3-479b-8d28-dc4a3fafb5e4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f29d189f-06bc-4784-95a7-b14051763bc9	d751f28d-f47d-4486-8ff8-94358cdf53f7	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
fb8894e7-ff0c-4a8f-9026-dae35a54b4e3	d8e42301-a8b5-4708-87c6-440ca9acd37e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
b8925259-5c10-447b-bb63-c5dbfc483cd3	06b9b48a-abaa-4d24-8ee9-d94d5ab0ec66	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
62e2c64a-c123-416f-a44e-b07bc0bbb3dd	631da6d3-9081-4d4d-8f17-98f6f1e128c4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
d1c6f3fc-1381-40f0-9bc3-96445ca86924	1a550834-b834-45c1-a899-392a50b5ee7d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
4681979f-771c-4452-b2a2-9633730c1e9b	d2feda35-cf48-4d50-9db4-5d5cab9a96bd	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
e4639c76-052b-42f7-9985-6239173e2c30	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
8881bb83-245d-4890-92e0-97a119bf7ce7	8ecd4380-5e50-4e97-ba2a-255ce4c2c4e1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
d3fd6a3f-578a-49ec-89ed-a77f59ad38eb	39144bf1-9a12-4d6d-a814-b769473d158f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c2206fdb-1343-48ad-8eea-becc839ece7a	9c575b13-2b96-4e73-8ae6-21267b4cf871	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
910c21f8-68a1-4df9-9e8a-a2a174708f0c	e93e5575-697d-4814-bc66-66b6d5d08f2d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c3b99b25-49a2-4c4f-ae1e-2a66162c9f40	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
ecf0a6ef-19b0-478e-8a7b-2dc3dc32f6d8	3ffbd728-c91d-40c5-8bb2-b45e93c1ff6f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
feaa6f35-630b-4244-8a3f-65c4075ffba4	cdfe543c-a78e-4dbc-ba5b-f3a8e6aaf43a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a9bac92d-4272-4b23-853a-e96186d04436	a5375a3b-6bcf-4d38-ad41-d0f132461966	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
e1ca9a21-faf3-43c3-b8bc-3d4e1136f1fe	6ffb9390-3177-4546-993c-4b4b225bad8e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
48bed560-d064-41fa-8efa-26bc4cee38cc	c2a554a7-8f5e-4f75-a4cb-115cb59a4f75	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
6587a268-7719-4adc-9129-b1c859f140b3	ceb2e076-e8e4-4f5e-a944-e1d423c62834	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f98965d9-af74-4e01-b530-87c7b32ac2a7	4c850cce-3170-46ea-9669-f891b4bad0da	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
df69965b-d121-4a73-95ce-da4aa93e44a5	5ed7695e-c900-4690-ab29-d4ecbc00d945	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
e3acb97c-4fac-4f97-810b-0aee612719b1	62ee5b22-cd13-4cb1-bdcf-f2976f9328fd	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
45ec5f92-390f-4814-92fa-7249909221ba	bdc0c353-4bb0-42dc-aa6c-a00669fa03dc	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
0ee83d24-3b4c-48d8-88d6-5131b5dad2af	a1d9d15d-9674-4992-a112-44dbb8d0dff4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
d05973ca-299d-42e7-aba6-22d457daf7ab	b7c71dec-b765-4ab4-845a-042585452059	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
48b8af5f-428b-4606-b24d-54f1c2d543ef	c1dbe57f-98a3-4a7a-b19e-73086799fcdd	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
51875c20-ba8f-4ce7-a370-e60dcdfc8588	fcf287b3-077c-40fd-8f4f-50ddf266fd4a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
acb6495d-eb15-46cc-9435-fc8227486d9c	7258a2ce-894f-4ce1-a260-84a7452f4d22	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
43d9c115-2ba4-4d37-a236-110cf83a4903	04ed257c-7497-4592-8157-d7526ebdbfcb	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
d76f4b1b-477e-416f-ae4d-53fd1a118e25	481f84ac-0826-476a-8bf5-7ebf33a13fc5	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
bd09601d-6c31-4cd3-b7ed-a926ac640acd	1ce7f618-ad5a-4831-8ab7-941266b34f24	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
2b40b44b-0846-49b8-9ec6-c3c67a948d5b	a3135e59-6d69-4b85-aba6-44192a01ccbc	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a4600580-affb-4f74-afca-8f4baf9da2b5	71ce6255-8c70-4d98-8f03-17b1f88d5f10	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
e1613051-e319-4937-bb54-2697c1732819	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
b889cd3d-b4fe-4024-879a-def556115854	a2e32bac-cab2-4eb8-a43e-9dfda0f1ca48	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
7c9bccfb-f200-4e00-a4a9-8548f746051e	780cd261-4746-4bc4-90c6-9457ad08308f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
91188f7a-f63e-42ca-aa14-c7fde3a363a1	3970a38d-c005-44fe-9b79-e89b7b8a5ea5	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f6adb33d-334c-4175-a8a9-a333dd008a10	5b277fc8-1da0-4867-beae-f6a8e72f490e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
672d352b-b2da-4f39-a289-34e28115d448	b720f98f-9a0c-43e7-958b-9855a27a7c71	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
33a45f32-0fb9-4e0b-94e4-69d0b3a6324a	82897173-7157-4508-9557-9e6700c0dc4d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c6d73951-bdf3-47f8-b41e-d926b798ec5d	a1468102-4c03-47f4-a390-cc625f636017	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
0d4baa1f-bd94-428c-a4a3-4633011d811a	376225dd-5419-4aab-862c-25bd9e67f5df	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
fd994679-bde6-4306-af35-b00419976893	b7068e6f-0513-47a6-82d5-a67333d69e31	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
07cbfc57-bfcc-4f69-9c9e-df3dd35d1de8	7a2ca438-8b6c-492c-8fbb-797c9e4e7e1b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
508a87a0-fac8-49b0-9414-d8aa3e9c759c	8b4f4e5f-3cf7-4790-ad3b-90f52d6c381b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
32d055b7-daf6-4244-9e6c-3b7b0e5f5121	1b4707dd-eaff-4276-8e8e-2c25fccd068d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
1303df78-4b0d-4ca9-9253-0363bfb07909	24b51865-5001-43e3-8b06-f791014a9954	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
fc33b53f-aa82-4483-858d-6ce6749b9487	62cd660d-f79a-414d-b7a9-ddba6338048d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
fe0c2c5d-81f5-4b38-abef-8bdc37bb31fd	eccfca5a-fe79-422a-86a9-00514d1a84f9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
d8f3c225-a5d4-4480-b7e0-c926c35a3b79	0e691109-aac1-47b0-9727-c9078860a89f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
7358a3b3-3ef7-4a4a-8794-c030157d0f75	87b40694-4414-4841-925a-176a00c7826a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c1fd03bb-5a78-403b-8901-62e63a533dcb	a7d7d2b7-8389-4a67-91e3-7aaf6940bf49	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a65f5269-f598-4d6e-b570-f166fbeb3c67	b3aa0f67-975e-4e8e-a7e5-8f82817802cd	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
81968dbd-e65f-46ba-9761-3840f255c290	6781d49e-0a52-407a-bbd9-57152fa52741	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
6775fe31-e442-4522-b2e5-c9f32af6b8ce	05f1ea88-de99-48ad-b7cc-38ed173ba5f6	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
3799b760-af69-44e1-b924-b0fe28aea395	f578ba4f-f883-4dd2-b920-6614af947bd4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
fbe85d33-4d5b-45dd-aeda-f79d80419328	17eb1c1d-7c3d-487a-8fea-baff32b2937c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
2bb8d76e-af3c-47ab-8166-b3fd05330299	04383a3e-b5cf-4875-99a7-fdd746e9cab0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
5f1310c1-1dde-46ed-8124-ea5035f8cfb2	04c83856-9ff0-475a-b2cd-db05406b84a3	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
68e3f33c-dddb-4da8-b37c-cca0eca72948	63b91840-aeb7-4558-a952-9e23e7217c1c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
79237db8-92a7-4824-9e8e-3671cbb4596d	05ed794e-f094-4a48-91b8-211b37ab3d4f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
041fde39-59ff-4691-9d92-63dff2e9af1f	48d1c50e-0ed4-4355-8b30-37ed358badcc	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
d736e8a0-7035-422d-8b3d-96d2c9a597bf	cfb0a68c-2135-4df7-ba69-3421c2a01173	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
b859457c-249a-4c9c-b6a0-ec977ff7abb5	1a613180-d253-411c-b05e-9087bb2537a2	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
84b2bbe1-b5c4-4cf3-819b-79c9aaaf388d	072c2418-239b-4944-93f8-da9eb88be608	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f1de9933-e3a7-4b1b-985a-98441bbbb6c1	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
7b754825-2224-404d-9e5e-d49f1c783db9	aca0f31b-c1da-441e-8568-e7c13b498797	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
b6519439-0358-4753-adf2-f13dac1a754a	55343256-1601-423a-b1a4-3d467d2b64c6	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
11f7135d-1d61-4fca-9475-fbcac3503efc	4f5a91b8-5ae2-4451-8595-e30b2f37474e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
b3a0dcac-aec2-49fc-9cca-afd4ce63a51e	691a7808-92eb-4fce-a618-d51867429491	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
12264b2a-7b57-4529-862e-9489abaf7c8d	a38b5915-0abf-4faf-9807-79a55151dab3	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
9d24792a-ed3b-4e70-b920-ee76430c0410	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
138d8fa9-aa09-4c58-b619-a0cf939ac637	9533dac5-4510-48db-9cb7-3ae25c3c7ad4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
cf84c4d4-44dc-482e-a87e-72ed422c0905	b370e760-5bed-4ade-8488-fe7c4c972e04	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
7ce12ea9-88da-43a7-b91b-63c74a53a76d	c88e824b-4488-4d90-a69c-cfb61fbe4791	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
6da3a1ae-18ac-4672-b456-2a82987586fb	07ee028a-1e71-400d-a185-39dc4299803c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a5daf790-47e7-4be5-ae08-c822f412298c	50d7763f-3b95-4adb-917f-04fdaf9d88c3	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c09cb763-cbdf-40a2-a1b1-e82c447c8389	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
e598b213-95bc-466c-b94b-f56af8a6b7ae	b9325221-963e-4909-8a81-6d00f3b1e7e6	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
32c3b295-4c53-441a-8834-94253f3bfe0e	317cf77d-0e89-49b2-82f0-b20073914c0c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
902a55c5-7be7-44ef-aa80-64bfafb1eb60	6c98251c-b1f6-4af0-96f7-37b08b66a067	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
bdb11025-976c-4e71-be86-7a97b216f2d5	4742c248-e7ae-4e74-b513-a66f6f86a66f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
ecc58009-cba9-4627-939f-a3d6538dcff5	da338792-0065-494a-960b-662d367ec669	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
d0d1acf1-cfb9-49d1-bd21-f53319c8d6df	c1667389-c459-4ecc-a759-cd2b0d69d687	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
2954cb5c-2283-4575-a9c4-703fec105e0d	19ab8ef6-2d97-43c6-9b8d-d8763bab7242	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
d1807f45-3c62-4d9c-8e81-700169ae4b4f	38bc0ed2-b6f8-43ab-8c00-4881911d0a64	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
acdd8adf-b1c5-4c7a-a155-43fbf356829f	77d688de-9a29-4e5f-a453-9479a9fd7f8d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
b5b0314a-cfc9-4f3b-b121-52437e2071f9	8a5b931e-b073-4af9-a916-4b214183a825	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
26715cc9-80ab-4437-b9bd-8021e7671402	2eba665b-39d7-41a9-bb0a-f6b5e9d8063f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
35353f3f-23c6-4458-9e06-90d9f05b5b2d	b558d227-6709-4505-8753-991479735966	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
e9d7b401-dcc8-4afe-8987-251914f22623	e489a5af-6a15-467b-97e8-f144421961bc	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
4080d638-93d6-48b9-aefa-9f233847fc2d	f3a78141-9a77-4b27-998d-d2b4d366e088	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
03fe2be1-894a-4447-9d61-778dbe257412	679443db-8000-4a0b-9fda-92d3e021a062	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
36ae66a9-c1ce-4845-822a-10db3f18b521	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
417fb6a2-9c36-4729-ba65-77d973947c71	8812812f-8bbf-4ae2-914a-b8cae24cdbcc	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
9cbc8bcb-908c-468c-ad3b-5fa5f37c7be9	9bdf6f88-144e-4836-9d28-a1e6715e47e6	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
d13c3325-9794-4b86-8f19-2b1fd0405660	e471db4b-ef29-4670-9730-3101f90741ab	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
66749ab3-1063-4983-8331-4058813804f8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
0d6c602c-c058-41f7-9d2f-50b03f76824d	29a63532-c5b1-4ebb-bba4-9a22abdd986c	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
ebad229a-4784-4d03-8e09-f5bc94c87c02	7258a2ce-894f-4ce1-a260-84a7452f4d22	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a20e3c63-5751-4794-a397-c6f46b40bdea	c1667389-c459-4ecc-a759-cd2b0d69d687	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
321befb7-8315-4fe1-b794-bf3e20c8f466	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
908507b2-cf17-49b5-87cb-f39c77526d4c	728cb098-b1db-410e-94a4-d08a630d8076	0da6fe92-db44-40da-854c-a84be86ab8d4	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
9ddbb5db-f441-4201-b8b7-e8cede34eab4	dae9be5f-69f8-4aba-8707-3974bd4edf02	0da6fe92-db44-40da-854c-a84be86ab8d4	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
07c02e03-06f6-48b2-b4c8-cc483cd7fa22	75bc07bb-6b7a-4414-b064-9f0f7c086217	0da6fe92-db44-40da-854c-a84be86ab8d4	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a8461a56-4a97-47b1-9d77-97d5d50a920d	a6138b49-27ca-485f-ad57-12f6ed08e94b	0da6fe92-db44-40da-854c-a84be86ab8d4	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
43492ab7-4c66-40c5-a67d-7836a8dbad63	04383a3e-b5cf-4875-99a7-fdd746e9cab0	0da6fe92-db44-40da-854c-a84be86ab8d4	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
2e92d630-f270-4c03-85cc-5d5ae83bb1e3	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	0da6fe92-db44-40da-854c-a84be86ab8d4	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
67a82b1f-14be-4a40-83a5-02bd32df4242	4742c248-e7ae-4e74-b513-a66f6f86a66f	0da6fe92-db44-40da-854c-a84be86ab8d4	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
9280d4b0-2274-459d-b4eb-c7a688e2aeb0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	6c50a910-149e-4247-af57-91342ca69c26	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
d5179c92-c62f-4b12-b8a6-61997f415846	3e969c04-e8bf-4376-a556-2a039627e19f	29a63532-c5b1-4ebb-bba4-9a22abdd986c	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
b446d549-e3e7-4810-aacc-c9e2809703a1	20115650-29ba-44fa-9861-99c990caa5b1	29a63532-c5b1-4ebb-bba4-9a22abdd986c	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
3bd7f2bd-c7ee-4f03-966b-7a56a5a0f15c	3e969c04-e8bf-4376-a556-2a039627e19f	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
1550e006-80bb-47e1-9688-b5f5c4e926ca	5431a241-78ce-4b21-b128-28dea9f8fae9	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
d7119ed2-135a-4b04-bc3d-365c4c4dfd2a	e471db4b-ef29-4670-9730-3101f90741ab	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
346bcaa1-3f6c-43e7-8769-4f8d941fbf6f	8b9c80e4-3072-4dab-85a6-36e310fae6ef	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
03d5010c-56b0-4cec-8267-3bad4207cf0a	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
dc6d5fe2-f76e-4fa8-8ba0-c7de7b3044bb	dae9be5f-69f8-4aba-8707-3974bd4edf02	a6138b49-27ca-485f-ad57-12f6ed08e94b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
4ea0d914-8a8a-4939-a65d-395b326e8ce7	75bc07bb-6b7a-4414-b064-9f0f7c086217	a6138b49-27ca-485f-ad57-12f6ed08e94b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
295950e1-a6db-4b39-b184-51c0ab1f2c5c	4742c248-e7ae-4e74-b513-a66f6f86a66f	a6138b49-27ca-485f-ad57-12f6ed08e94b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
12b60812-52cb-4376-8614-fc9d60318195	c1fbb481-dd2c-4585-9b7c-06d180d77d2d	d05bf38b-f898-4dfc-adcc-dce47a90a1c7	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
05f5269d-ab9b-4736-84e5-e7cd7b4d3c04	5b316a00-25b2-4fd7-8796-5dbb7f51f948	d05bf38b-f898-4dfc-adcc-dce47a90a1c7	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
aa00e7de-4521-4723-9b8b-0389af0a8a27	7e2a2c9f-ceee-43a9-8c22-b0e99af67bf0	1fc5df4c-5ca6-44aa-b3ab-fb93987f7b9b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
7532a786-ef10-49cf-8efd-d6e84ec75dac	f270fd28-1c02-46bf-ac9c-8179ed1185bb	1fc5df4c-5ca6-44aa-b3ab-fb93987f7b9b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a195b53e-90dc-4c59-a50f-b8cfa55ac72c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	fc57deea-20e3-4959-bb07-ce80c36b7a8c	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
41fc1168-dd51-41e4-9a1b-f58f85305f0d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	1a88ebc2-fa9e-4566-9043-3904425b19ea	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
2582bd08-be60-45fc-8f60-628d0349bbe5	1543db57-9c36-4a03-b917-401ada53eb22	bd9d47bf-0c6a-41ef-8fa7-9924e9cc868d	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
32fb1bcc-19f0-44db-98d9-42059697e2fc	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	bd9d47bf-0c6a-41ef-8fa7-9924e9cc868d	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
65acab32-b335-419d-a3c6-6c88202d6aab	d99d51b7-3349-4bf6-8803-618705c95d2d	3e284f6f-181a-4fee-9eaa-89cc745094aa	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
2a0e3470-54f1-4fd1-91d0-f13bb91ba5a4	b651ec49-f0b6-40b6-87b9-af90f919e1c0	f270fd28-1c02-46bf-ac9c-8179ed1185bb	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
386be33b-e975-4fbc-8fd8-4594fc9d0116	704659f3-e212-472b-951d-80c1d942b506	f270fd28-1c02-46bf-ac9c-8179ed1185bb	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
8ad0bfda-861b-4aa7-8989-7727fccf3cde	7ac0b7d7-3b98-4439-89e7-79026ae3b3ad	f270fd28-1c02-46bf-ac9c-8179ed1185bb	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
953a6ac7-ab5a-4b15-a13b-25beb240274f	631da6d3-9081-4d4d-8f17-98f6f1e128c4	f270fd28-1c02-46bf-ac9c-8179ed1185bb	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
43047f59-989e-43c3-bb00-cc63dcc824ca	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c2a418bd-aae3-479b-8d28-dc4a3fafb5e4	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
34486aec-a939-4670-ba72-f89d5329e17c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	d751f28d-f47d-4486-8ff8-94358cdf53f7	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
2cdbf3f3-6c4f-4f61-9248-98a2140d8d50	704659f3-e212-472b-951d-80c1d942b506	631da6d3-9081-4d4d-8f17-98f6f1e128c4	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
b6d3da9e-426f-4689-9ac8-19dff1eb765f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	631da6d3-9081-4d4d-8f17-98f6f1e128c4	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
b9bc449e-4563-4315-9dea-c4a7ea5a836a	28058267-5877-4bc2-a880-395176bd6b22	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
31ea54b6-b58a-47d4-97c2-413ef1eb105a	dae9be5f-69f8-4aba-8707-3974bd4edf02	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
1fe87311-5e82-4a95-9251-8cf2c7da3e76	fb06de97-b722-4281-99cf-482d421bd4b0	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
bca91495-0f2b-4cbd-81d8-e05430478c24	a6138b49-27ca-485f-ad57-12f6ed08e94b	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
1c448ed0-3b40-4e09-8561-87653af2f37b	3a3e0676-66e8-487f-8eba-e64eefe2bf2f	39144bf1-9a12-4d6d-a814-b769473d158f	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
884072b1-178a-42c6-bc96-15cd13643504	e93e5575-697d-4814-bc66-66b6d5d08f2d	39144bf1-9a12-4d6d-a814-b769473d158f	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a2120242-589a-4ec4-87fd-6f3b2fe4e4d9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	9c575b13-2b96-4e73-8ae6-21267b4cf871	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
5642a59b-acf1-4cf1-94bf-4fefe2e833ce	c1667389-c459-4ecc-a759-cd2b0d69d687	9c575b13-2b96-4e73-8ae6-21267b4cf871	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
369dc17c-2ced-45e4-ba72-af562f8556d4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	e93e5575-697d-4814-bc66-66b6d5d08f2d	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
6d347c5c-ea99-42a6-9ec5-019a0c3d5ac2	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
ce48feff-d73b-4347-874b-010a7c2df680	ff42b26e-122c-4b16-b896-f06c990c2c01	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
fa8356ab-c5e3-423b-91d0-fbea0ca4baf8	f270fd28-1c02-46bf-ac9c-8179ed1185bb	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
1f74574e-1661-42b8-ac30-a832399645c4	c2a418bd-aae3-479b-8d28-dc4a3fafb5e4	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
385bd384-b2ee-4a29-9a86-db207732954d	d2feda35-cf48-4d50-9db4-5d5cab9a96bd	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
8101ba0d-93c0-4fd6-8018-a8f64bc46dd0	4f5a91b8-5ae2-4451-8595-e30b2f37474e	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
d6e6f4a4-dea9-4049-9355-3f49d52c0358	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	0134d7aa-9f38-4e9c-a172-f94415e1beb2	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
bab27256-628e-43ed-b18a-f466976e99ef	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	cdfe543c-a78e-4dbc-ba5b-f3a8e6aaf43a	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
d427b921-d939-4dff-9da6-f6682f50dd43	1a88ebc2-fa9e-4566-9043-3904425b19ea	cdfe543c-a78e-4dbc-ba5b-f3a8e6aaf43a	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
b22738a4-7f4b-46f1-a54b-b5e5f65e6787	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	6ffb9390-3177-4546-993c-4b4b225bad8e	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
8576c7d3-aac8-46f6-99c0-2069247e06c8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	4c850cce-3170-46ea-9669-f891b4bad0da	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
594cea58-c645-4e0f-94f5-f87eecea64bb	dae9be5f-69f8-4aba-8707-3974bd4edf02	5ed7695e-c900-4690-ab29-d4ecbc00d945	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
29606fd4-00a0-43e3-8b16-7668530ee558	4742c248-e7ae-4e74-b513-a66f6f86a66f	5ed7695e-c900-4690-ab29-d4ecbc00d945	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
b714a7c1-2de4-4c1a-af43-b9f8aad974fa	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	d98e1f37-38da-41b7-9ad1-9301b0fc0b50	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
458d17cd-c87e-4372-a974-aea7e875f692	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	62ee5b22-cd13-4cb1-bdcf-f2976f9328fd	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
d600fca1-8188-4240-ac28-feff2e8703e3	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	fcf287b3-077c-40fd-8f4f-50ddf266fd4a	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
99226dc7-e898-4c78-b853-0e09f982672f	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	7258a2ce-894f-4ce1-a260-84a7452f4d22	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
15b2130f-2720-450b-a73e-0e6054c12159	d15bfb61-8af0-49af-af82-24696cd922a9	7258a2ce-894f-4ce1-a260-84a7452f4d22	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
958461df-69e6-495b-8ac0-74641f39e9b5	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	7258a2ce-894f-4ce1-a260-84a7452f4d22	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
48342fb6-68a4-498c-a97b-6e101deb0bb3	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	1ce7f618-ad5a-4831-8ab7-941266b34f24	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
7598903f-8035-4399-8391-1009d5201e31	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	6928567c-2b25-4834-8ebf-27800deb240e	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
abee766d-0887-43d2-990a-bb24542588d4	63b91840-aeb7-4558-a952-9e23e7217c1c	6928567c-2b25-4834-8ebf-27800deb240e	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
84cd8603-3b16-470e-9bd2-6fad9888904c	8e7e993f-54f9-40d5-8bea-ae16768cbe27	b0457fb7-5638-4a0f-bbc2-688005ef2ae5	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
43a11ab0-8c6c-43fb-a0c7-f827a1ba0437	c662510d-a483-4da8-b9c4-96f2bb450a40	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
33684710-6457-41c1-8505-8eb128020099	dae9be5f-69f8-4aba-8707-3974bd4edf02	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
6f605d2e-a526-4d33-9e23-f1fb9beff18a	ac2d044e-0c82-4e7c-bc7f-2781191a1148	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
470cb4c8-1c0b-484b-90d5-f944ab910c65	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
0ee4dd19-5106-45ad-8958-f891192ef495	a6138b49-27ca-485f-ad57-12f6ed08e94b	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c7de60bf-d026-4343-9726-6fef4baba5c5	2ddcfb31-7ace-442b-9cf9-eb1966e09627	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
1839fb41-3fc5-40c6-ae54-9d1ae08ae13b	87b40694-4414-4841-925a-176a00c7826a	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c99a4c66-4999-4e1a-a6da-9b2224902a1b	4742c248-e7ae-4e74-b513-a66f6f86a66f	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
253f46c0-5c50-4a7f-9d57-1590a9ed5fea	c1667389-c459-4ecc-a759-cd2b0d69d687	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
e83ba73b-11e8-4992-9798-013a18aa7ad4	0da6fe92-db44-40da-854c-a84be86ab8d4	3970a38d-c005-44fe-9b79-e89b7b8a5ea5	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
92c0e022-264f-40b6-b202-9fa39c9ed0f0	d99d51b7-3349-4bf6-8803-618705c95d2d	e617cb11-6363-43d1-8754-b0aa2d004810	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
23463bcf-3b41-4bab-9394-021c92794d1e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	5b277fc8-1da0-4867-beae-f6a8e72f490e	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
5b2185e6-1492-4c35-9a25-0f5db5f0fc0a	728cb098-b1db-410e-94a4-d08a630d8076	b720f98f-9a0c-43e7-958b-9855a27a7c71	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
38cc1baf-fc56-4737-9094-f35bf209a42d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	16c03ecc-7936-4614-b272-58cfb2288da8	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
116184e1-c14d-4269-8d9e-3953077f17e8	39144bf1-9a12-4d6d-a814-b769473d158f	66b771c6-9028-44eb-83e5-1ae8d757688d	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
e62a4f29-3921-44e6-9800-887847570d4f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	b7068e6f-0513-47a6-82d5-a67333d69e31	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
2ba0c5be-75ec-49e7-ae07-b61827dd27be	c1667389-c459-4ecc-a759-cd2b0d69d687	8b4f4e5f-3cf7-4790-ad3b-90f52d6c381b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a4c88c24-c76f-4ba1-be62-f6c6ded608dd	5b316a00-25b2-4fd7-8796-5dbb7f51f948	1b4707dd-eaff-4276-8e8e-2c25fccd068d	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
99459d5d-eac8-4915-87cd-8c430b8cc51e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	1b4707dd-eaff-4276-8e8e-2c25fccd068d	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c500addb-6950-4347-83a1-3a790e9312e1	d05bf38b-f898-4dfc-adcc-dce47a90a1c7	1b4707dd-eaff-4276-8e8e-2c25fccd068d	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
5d3f923a-d0cb-44ea-a5aa-287f8e7c1fb4	75bc07bb-6b7a-4414-b064-9f0f7c086217	ad927edf-b643-49c7-bb35-ce93c40e25f9	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
8d5bcb8e-e4df-4a5c-908b-c87451cc38f1	45f81bc7-ff24-498d-9104-18da7e5643f8	ad927edf-b643-49c7-bb35-ce93c40e25f9	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
72eb2429-ddb5-4df4-959b-dc9f45e3b815	dae9be5f-69f8-4aba-8707-3974bd4edf02	87b40694-4414-4841-925a-176a00c7826a	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
406544eb-6c5f-4d9e-b0dd-effee757831c	75bc07bb-6b7a-4414-b064-9f0f7c086217	87b40694-4414-4841-925a-176a00c7826a	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
17a9d420-3ba5-449e-9dc4-504034f18274	a6138b49-27ca-485f-ad57-12f6ed08e94b	87b40694-4414-4841-925a-176a00c7826a	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
07117ac8-89f9-44da-ba29-1432e07ee6bc	4742c248-e7ae-4e74-b513-a66f6f86a66f	87b40694-4414-4841-925a-176a00c7826a	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
2482049e-fdba-4c32-b108-ede7cd970a1a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	b3aa0f67-975e-4e8e-a7e5-8f82817802cd	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
79a7e715-d232-4729-a7b7-0fa53245fd1d	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	b3aa0f67-975e-4e8e-a7e5-8f82817802cd	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
2881aa5b-935f-4619-b597-0e673ba1997e	a9a3eae9-470b-4e07-ac58-37a0d62d0ada	6781d49e-0a52-407a-bbd9-57152fa52741	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
889c48ed-65fa-43ef-80c6-08e85f341d6c	0da6fe92-db44-40da-854c-a84be86ab8d4	6781d49e-0a52-407a-bbd9-57152fa52741	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c0111309-2664-4d94-9295-7dbf77653cc9	a6138b49-27ca-485f-ad57-12f6ed08e94b	6781d49e-0a52-407a-bbd9-57152fa52741	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
fdc2036d-2195-4a4a-bf25-bb9b022a45a2	e1d0121d-7fc5-424b-860e-065f92776ca1	6781d49e-0a52-407a-bbd9-57152fa52741	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f7108455-09c0-46b9-be67-7f973ee08934	82897173-7157-4508-9557-9e6700c0dc4d	6781d49e-0a52-407a-bbd9-57152fa52741	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
dcdf5369-4869-40ee-8c25-78347155c9cf	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	05f1ea88-de99-48ad-b7cc-38ed173ba5f6	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a6669616-667d-4c7c-a15e-800aa20d3e91	7258a2ce-894f-4ce1-a260-84a7452f4d22	05f1ea88-de99-48ad-b7cc-38ed173ba5f6	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
616cc53e-48f1-4599-9bbe-143b1e26751d	d99d51b7-3349-4bf6-8803-618705c95d2d	f578ba4f-f883-4dd2-b920-6614af947bd4	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
4c0e0058-0cdc-4281-860e-fc43e6cc4c8b	ff42b26e-122c-4b16-b896-f06c990c2c01	f578ba4f-f883-4dd2-b920-6614af947bd4	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
fceed99c-e8b5-465e-bf9f-aa7af79ee7e6	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	f578ba4f-f883-4dd2-b920-6614af947bd4	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
509cd940-fc8f-45ad-bdbd-0d9ce196439d	728cb098-b1db-410e-94a4-d08a630d8076	04383a3e-b5cf-4875-99a7-fdd746e9cab0	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
19b29be4-5c42-48f8-b11e-8c41b8a347c9	75bc07bb-6b7a-4414-b064-9f0f7c086217	04383a3e-b5cf-4875-99a7-fdd746e9cab0	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
be76669e-7a84-41b2-9507-1fc4468328fe	45f81bc7-ff24-498d-9104-18da7e5643f8	04383a3e-b5cf-4875-99a7-fdd746e9cab0	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
22483987-2d49-446b-bd5c-8eb14933621e	0da6fe92-db44-40da-854c-a84be86ab8d4	04383a3e-b5cf-4875-99a7-fdd746e9cab0	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f6181f57-7a49-4fba-ad3b-3786a3b77532	ad927edf-b643-49c7-bb35-ce93c40e25f9	04383a3e-b5cf-4875-99a7-fdd746e9cab0	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
0cc7f5ca-099d-4d8f-a7bc-5ac6a8034e5f	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	04383a3e-b5cf-4875-99a7-fdd746e9cab0	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
df356118-d79e-4765-acfc-7eff141cc583	dae9be5f-69f8-4aba-8707-3974bd4edf02	04c83856-9ff0-475a-b2cd-db05406b84a3	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a48be6b5-458b-416c-9107-9c4dc1aa8157	0da6fe92-db44-40da-854c-a84be86ab8d4	04c83856-9ff0-475a-b2cd-db05406b84a3	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
cf525ad9-c195-41a4-b0a1-c5ba1eabec96	a6138b49-27ca-485f-ad57-12f6ed08e94b	04c83856-9ff0-475a-b2cd-db05406b84a3	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
b7fd5056-a86c-4371-a92f-5dcd8be5ce23	4742c248-e7ae-4e74-b513-a66f6f86a66f	04c83856-9ff0-475a-b2cd-db05406b84a3	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
02842716-e335-46b8-8b27-e14c4fae9632	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	48d1c50e-0ed4-4355-8b30-37ed358badcc	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
2cb8f4c5-2f20-4776-9a34-0d926f457b82	75bc07bb-6b7a-4414-b064-9f0f7c086217	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
6242dd91-d91f-4848-a4ce-fcc371af16b4	a6138b49-27ca-485f-ad57-12f6ed08e94b	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
fa56bda0-b39f-4775-9050-9b7d8a57b983	4742c248-e7ae-4e74-b513-a66f6f86a66f	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
1364186d-8add-4f9e-af4e-72e91e7ff70b	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	a2e3eb4f-c4e3-4f3c-bfdd-2ca2c6f4b9ed	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
8dfbae04-23e2-40f3-9ad8-c2ae361375e7	b6fefa89-914a-4a89-bda8-e03a77dfbba2	55343256-1601-423a-b1a4-3d467d2b64c6	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
5f285eb2-a022-4436-bed0-993798f576af	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	691a7808-92eb-4fce-a618-d51867429491	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
484ad2df-98f3-4a7d-930c-0b36626c9869	7258a2ce-894f-4ce1-a260-84a7452f4d22	691a7808-92eb-4fce-a618-d51867429491	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
b4c3fc72-5e7b-4eaf-8e57-9072319714b0	5846ade9-c2a3-4042-b036-4a0e3e88a907	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
1b21f0ed-5910-4c42-b9a3-4843264fc669	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
19acffbe-5807-47e3-bf04-03c07a3bc9d4	5e27148a-c486-4282-9cc5-7ec352cd411b	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
e751cc32-e34f-44a3-9d5b-7a58db74e09d	3d328497-971a-4cca-b0e6-6d959503bac0	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
582524b1-05a9-4ab7-880b-ff2826885f14	e471db4b-ef29-4670-9730-3101f90741ab	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
d982d107-ad5e-433f-a7a4-8c94249a3e11	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
1f634d12-f2a1-47a3-b1d7-2baa5ffb0404	5e837acd-dae2-4186-b57c-ae70ee945f8a	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
96fd67a8-7953-486e-964d-093cf15cc4af	19ab8ef6-2d97-43c6-9b8d-d8763bab7242	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
b8f98195-7540-4179-b22a-8da70abac0db	78587ca2-7caf-4b23-a0b0-16abff115c30	07ee028a-1e71-400d-a185-39dc4299803c	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
91df7eec-77d1-4bff-9df5-cc5192c90799	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	07ee028a-1e71-400d-a185-39dc4299803c	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f3daf724-e879-496b-8fed-870955e7bef7	19ab8ef6-2d97-43c6-9b8d-d8763bab7242	07ee028a-1e71-400d-a185-39dc4299803c	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
31b2cbb0-4699-47b3-9d18-4b00f8fea96c	dae9be5f-69f8-4aba-8707-3974bd4edf02	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
ed086877-e064-4c4f-bb82-ff3f01e2229e	75bc07bb-6b7a-4414-b064-9f0f7c086217	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a25d5ffa-cd9c-4431-b69a-66ee6bbc1253	a6138b49-27ca-485f-ad57-12f6ed08e94b	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
fedf81cd-673e-4515-a00c-331f47795a12	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
6e9e9463-e7e2-4819-80cf-86eccee55905	4742c248-e7ae-4e74-b513-a66f6f86a66f	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
2277acb9-5d3c-414a-a08c-2776e68becdd	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	b9325221-963e-4909-8a81-6d00f3b1e7e6	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a416bf0c-c79b-47ea-956e-b3e43a1d64cf	45aa8b28-c678-4e4a-9352-27ab690df852	317cf77d-0e89-49b2-82f0-b20073914c0c	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
732f7a4a-5263-45e6-b9d5-d1b088aac2ad	45f81bc7-ff24-498d-9104-18da7e5643f8	317cf77d-0e89-49b2-82f0-b20073914c0c	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
ae3ec241-100a-424a-8280-6925063343a0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	317cf77d-0e89-49b2-82f0-b20073914c0c	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
b0128139-06e3-438c-8226-ca4b159c858f	7258a2ce-894f-4ce1-a260-84a7452f4d22	317cf77d-0e89-49b2-82f0-b20073914c0c	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
e9a91876-a874-4d47-9b09-b748e259cccf	dae9be5f-69f8-4aba-8707-3974bd4edf02	4742c248-e7ae-4e74-b513-a66f6f86a66f	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
51253e9f-ed3a-4dcc-a53f-fdd7641beaec	75bc07bb-6b7a-4414-b064-9f0f7c086217	4742c248-e7ae-4e74-b513-a66f6f86a66f	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
cb4492f0-96d3-4aa2-931a-735e24206d78	691a7808-92eb-4fce-a618-d51867429491	86304602-3f40-481d-9a36-9a61a6289bf6	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
2bc06204-8347-4e98-bbfb-79cc4972b824	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
75808f42-f4fe-42bc-aff9-b952c86546dc	9c575b13-2b96-4e73-8ae6-21267b4cf871	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
1f6810a9-d6b2-4550-8e11-82051caf2358	7258a2ce-894f-4ce1-a260-84a7452f4d22	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
29dc07f3-dc69-4951-8583-7191fbd28dd2	8b4f4e5f-3cf7-4790-ad3b-90f52d6c381b	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
733c0ae2-3c8e-4e70-a3f8-56314112fd1f	a7d7d2b7-8389-4a67-91e3-7aaf6940bf49	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
3f5a92e3-241f-430a-8b60-92216700cbbf	5e27148a-c486-4282-9cc5-7ec352cd411b	19ab8ef6-2d97-43c6-9b8d-d8763bab7242	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
752fab52-f263-4e56-9bf2-e9359e74b843	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	19ab8ef6-2d97-43c6-9b8d-d8763bab7242	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
13180724-ce65-4a59-9294-987dda7d44ec	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	19ab8ef6-2d97-43c6-9b8d-d8763bab7242	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
0eb8a2b9-4389-416d-8d44-19980cbbdb03	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	8a5b931e-b073-4af9-a916-4b214183a825	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
4b2fddb6-5481-4fbf-b0dd-11016a31806e	f270fd28-1c02-46bf-ac9c-8179ed1185bb	f3a78141-9a77-4b27-998d-d2b4d366e088	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f1643157-4608-4854-93e4-668a9fdb6b73	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	679443db-8000-4a0b-9fda-92d3e021a062	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
7434f7f1-b6ec-404e-9d72-4c748005c5c9	a2e3eb4f-c4e3-4f3c-bfdd-2ca2c6f4b9ed	679443db-8000-4a0b-9fda-92d3e021a062	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
2daced96-c196-4f4f-948b-e486b223a46d	c17ad9e2-f932-4dd7-950a-2bb25a9b0772	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
13b50610-d27a-4491-948a-942ece17e85d	8afbe459-f864-4ad6-98b5-595ac422f0ef	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
af84d3aa-71da-4c91-b0e8-29d470706ac0	b651ec49-f0b6-40b6-87b9-af90f919e1c0	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
ab741a73-10c1-43cc-b15e-bef3f3968ea7	704659f3-e212-472b-951d-80c1d942b506	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a2d7e8b5-a2d0-46ca-80d1-6a416a07dac5	9079e6fb-d198-4c34-a483-39df60af375b	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
65e9bb06-eefe-4464-8c55-842f17998f34	1595e4da-60d8-4646-8dcc-c761e435937e	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
6de3e97f-f142-4e06-a905-01ac261a71a2	f270fd28-1c02-46bf-ac9c-8179ed1185bb	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
5e62c153-4c50-4055-82e4-b5d55afc804d	61b3566e-f3e2-4116-824b-0be7e6d5f9b8	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a80cfa6e-a637-48c3-aca6-1a8982243a68	631da6d3-9081-4d4d-8f17-98f6f1e128c4	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
6c20753c-cd23-4907-a1cb-07006cd852ae	f3a78141-9a77-4b27-998d-d2b4d366e088	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
e5c83a1f-b900-402f-8e2a-1703138bc390	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	109a4ba1-3456-4dcc-bc80-8f2bdd904da1	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
40fddab9-6b5d-4852-811b-0615f5d0d114	012e0de3-ba65-4fd4-9a9a-f127d09672aa	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c9649250-1b3c-481c-8b6a-c69175d25f9d	3e969c04-e8bf-4376-a556-2a039627e19f	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
701cdf8c-94d1-4eb8-850d-b55104cd9135	5e27148a-c486-4282-9cc5-7ec352cd411b	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f68212c7-8597-44d9-8656-43d364a569a5	5efc6baa-40ff-406f-aab6-3cd7e48a7f26	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
fbf2de2d-3dc2-4a46-8beb-d6b09b1f826b	38735eef-62f6-418b-a02d-14bc0f491031	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
c92f6cf5-b4ee-44e4-b41d-84f790635864	339b8bf1-7cb8-4726-9ccd-f76faf83482d	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
592781d5-7897-4a1f-a827-3f176bfd479e	76437582-061c-4b94-9873-a4e3b6b8c787	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
a7b00963-d333-4267-9117-9971159c0369	78587ca2-7caf-4b23-a0b0-16abff115c30	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
57df574c-414f-4dd6-8abb-a97d42318bfa	44a938f5-b9c0-4e10-aab1-bbabd979710e	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
2c65d7ea-dc97-44d1-b36f-91298198fac4	c6872d71-bd61-4a1a-bcdb-ba79f37b1283	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
2e39261e-03d8-448b-b59d-84e573361e28	fb06de97-b722-4281-99cf-482d421bd4b0	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
f549e49b-3fb9-49dd-8966-433a25cc2dca	4bd2dff5-6f63-4ad3-a9ee-61219df00045	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
785d051b-e484-4aac-aebe-ff9af5b5e6b1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
871f23fc-938a-48a3-b5d7-5170f6f04774	8b9c80e4-3072-4dab-85a6-36e310fae6ef	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
63796fad-5f5e-4ce6-97c9-e26189c23c58	0da6fe92-db44-40da-854c-a84be86ab8d4	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
20ca8a97-2375-4d87-9d97-79113e498ea6	29a63532-c5b1-4ebb-bba4-9a22abdd986c	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
3a0ae533-4b9a-4344-9f33-e8864c30ff70	f2c5ae55-0e05-4127-b286-efc6fb88b4a1	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
99121deb-4995-4ae9-a25f-d5b9f9e2fca1	7a19a677-5c7e-4efa-99aa-2d7a536f4ba9	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
b34e8a22-3e7a-45c9-b76c-27a4c96f9f5a	9c575b13-2b96-4e73-8ae6-21267b4cf871	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
416b2632-5c94-4641-adba-37d663c1d242	e93e5575-697d-4814-bc66-66b6d5d08f2d	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
73c4df23-c22e-4085-8b38-9f5806bd69f8	0134d7aa-9f38-4e9c-a172-f94415e1beb2	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
de67b9cf-e7b4-46d9-8ca4-e65316b1e86b	c2a554a7-8f5e-4f75-a4cb-115cb59a4f75	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
5772c634-ca0d-47f3-822e-5194d7bff88c	04ed257c-7497-4592-8157-d7526ebdbfcb	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
8017fc1a-1feb-46ef-8edd-0167f0ba0346	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
4d99a72b-1ab6-45df-804d-21527a4eddc1	97839cd4-0327-4209-b3a0-09744b78c944	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
2d0e52f4-052f-4e87-85d7-30d04bd7f5be	ad927edf-b643-49c7-bb35-ce93c40e25f9	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
1e65e27d-542d-4ebf-b71c-ead0be1c7fff	20115650-29ba-44fa-9861-99c990caa5b1	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
34685aef-c9b3-41c7-9eea-4eabd8ee740e	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
3ed20fb6-d7a8-48f2-b8d7-1b6b74c4b67e	0e243923-c4e6-4bf0-ae19-c0a5545f33c4	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
2ff25f03-e4f2-4c62-9cf8-6162550308ec	691a7808-92eb-4fce-a618-d51867429491	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
bc7add76-8884-4dd1-b7d9-f8fea7e760a5	48a7ded3-0e70-425b-b587-8139188fb234	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
547fdef0-0862-4713-b00d-6147b87df4a6	c1667389-c459-4ecc-a759-cd2b0d69d687	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
e25ddd7a-5366-47f8-b91d-138b30e6af81	7de32a97-e650-4e19-87e8-0040927e6844	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 04:57:30.179	2025-02-19 08:13:04.465
52b9188d-7cdb-4195-bb26-93bdc841a4eb	c1667389-c459-4ecc-a759-cd2b0d69d687	be269914-8f65-4e4c-b3c5-b02313f8b4ac	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
450f4579-50d7-4dc2-b336-3321749b2feb	8fd92c37-ee30-48c5-9758-5b27c3768deb	835889ef-7e95-4dc9-9930-c517ec555496	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
aae85a2c-877c-44db-aea7-b0999533b119	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	835889ef-7e95-4dc9-9930-c517ec555496	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8d78c7af-828e-4261-b125-e26553db8401	8b9c80e4-3072-4dab-85a6-36e310fae6ef	012e0de3-ba65-4fd4-9a9a-f127d09672aa	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
c277779f-2b35-419c-b686-8a9ec7b46f97	dae9be5f-69f8-4aba-8707-3974bd4edf02	28058267-5877-4bc2-a880-395176bd6b22	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e8918978-8392-4796-ab0f-89fa9519dfa8	75bc07bb-6b7a-4414-b064-9f0f7c086217	28058267-5877-4bc2-a880-395176bd6b22	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
7c078bdd-3065-48a1-82d8-a31ff21f920a	a6138b49-27ca-485f-ad57-12f6ed08e94b	28058267-5877-4bc2-a880-395176bd6b22	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
f9c60db7-e709-4956-a6a3-a109a35ab518	4742c248-e7ae-4e74-b513-a66f6f86a66f	28058267-5877-4bc2-a880-395176bd6b22	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
87bd2822-581b-4ba0-844b-9878ff8691af	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	7e2a2c9f-ceee-43a9-8c22-b0e99af67bf0	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
365e2393-b0f9-4e19-94d7-c1e38dd28a7f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	8812812f-8bbf-4ae2-914a-b8cae24cdbcc	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
c81d68b1-1a60-4f9a-a65f-647640ebbf2c	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	5846ade9-c2a3-4042-b036-4a0e3e88a907	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8c41b96a-073c-4e5e-ac60-73b5cf377ba1	29a63532-c5b1-4ebb-bba4-9a22abdd986c	3e969c04-e8bf-4376-a556-2a039627e19f	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
73e8c0d8-aa2c-4f1d-b667-cac08ab5a629	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	a9a5f83f-167c-4e62-b4f0-ed7a123d3990	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8935e037-a73f-4ff0-8750-472b64d02da3	583dcdbe-fbdd-4ecf-800d-831c7f7716f9	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
dc8b2881-0bd0-4be1-96ad-e64977ad82d3	1e2957ac-522b-4d7a-bc6b-5c33ca78ecde	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
bd94c719-8fc4-4ef0-9001-633abfca965a	c662510d-a483-4da8-b9c4-96f2bb450a40	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
640819d5-124f-4be9-ba3d-2a0b74a718f9	728cb098-b1db-410e-94a4-d08a630d8076	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
0ee83ce6-b2d9-4c11-9712-067fc8458d3b	c2d8d0d1-43dc-4d39-9170-071ff5bf0cb2	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
656c92bf-38f0-449f-91f0-c07f298c0d45	5efc6baa-40ff-406f-aab6-3cd7e48a7f26	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
9951cb4f-90d8-4052-b5d0-c0b2bbbce9a2	dae9be5f-69f8-4aba-8707-3974bd4edf02	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
0c65b66b-d721-47e7-82fe-c23630dcf44e	fb06de97-b722-4281-99cf-482d421bd4b0	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
6a0b4956-0d97-444d-b290-8f441115179e	75bc07bb-6b7a-4414-b064-9f0f7c086217	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
80b949b0-1791-498c-b0a0-4d45c871b85f	a6138b49-27ca-485f-ad57-12f6ed08e94b	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8bb51f0c-2fa1-475c-bfd4-a17b08534f2e	db049daa-59cb-425e-bdd9-c6dbbdff5b95	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ed36923f-c889-4c2c-a8ee-81afd118ec79	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
a90edb59-fdaa-4f6d-9d45-12c4825d8705	3ffbd728-c91d-40c5-8bb2-b45e93c1ff6f	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
05d2b641-3be1-4c28-8ba6-391f3525d196	a5375a3b-6bcf-4d38-ad41-d0f132461966	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
b2678336-e825-4058-8cb7-11f29c2ef583	ceb2e076-e8e4-4f5e-a944-e1d423c62834	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
5f773c07-0865-4e71-844d-8a87762d779c	5ed7695e-c900-4690-ab29-d4ecbc00d945	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
0c049b47-df03-4e04-9587-d2f15e58900d	481f84ac-0826-476a-8bf5-7ebf33a13fc5	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
14be324b-8050-429b-bbca-ff8d28cab8be	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
788fa8a8-34d0-4986-90ca-01faa42913e8	3970a38d-c005-44fe-9b79-e89b7b8a5ea5	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ee09a805-67b2-4715-9a90-26425f002c6a	b720f98f-9a0c-43e7-958b-9855a27a7c71	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
cb8acdef-8baf-46b0-8933-72434022dd2f	82897173-7157-4508-9557-9e6700c0dc4d	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8b44eedc-4f6e-4af5-bfc1-3d4e1e892b3a	42e3166f-a80a-4120-b00f-22224f3248b1	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
2724d3c8-cdf0-4c03-8c25-69b8e74ea213	eccfca5a-fe79-422a-86a9-00514d1a84f9	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e32a230c-69f5-402c-b34a-777e27cdd652	87b40694-4414-4841-925a-176a00c7826a	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
dbe3afce-a87a-436a-896a-480df5dedc94	04383a3e-b5cf-4875-99a7-fdd746e9cab0	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
3e68864c-08e4-4c9d-b130-6090b2f316da	04c83856-9ff0-475a-b2cd-db05406b84a3	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
bbe12cfa-f588-4be8-9b9d-fc9c3dc15fd6	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e930236e-41f2-4210-b932-e707d17b6b05	b370e760-5bed-4ade-8488-fe7c4c972e04	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
c6ddf39e-7153-426a-b162-bd908d488bb0	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
decb0057-bde8-4b0e-9b02-c53ba2f1ada6	b9325221-963e-4909-8a81-6d00f3b1e7e6	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
531da5b8-45f5-4ab6-96a7-c9b0c9f6a84e	77d688de-9a29-4e5f-a453-9479a9fd7f8d	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
758d0187-d61d-4a52-91fc-30d1a142b621	28058267-5877-4bc2-a880-395176bd6b22	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
2477a18c-66ae-489d-a4fd-a97336b4e86b	5b316a00-25b2-4fd7-8796-5dbb7f51f948	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
9a0a2661-12cc-41ed-a724-8673ac596099	dae9be5f-69f8-4aba-8707-3974bd4edf02	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
d0e4a664-3656-4870-996d-73ce4faee18b	82de6c86-64f8-4b2f-afb3-ad42f3064102	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
aac5497e-17f2-4043-9a3a-777380cf7b2d	76437582-061c-4b94-9873-a4e3b6b8c787	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e6a3373d-041d-4946-ba4b-280d696a8fb9	36fa3c27-a0c6-4407-a386-a0b57cbbd453	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
4bb0e1f3-5f3e-45ff-8083-43f2c857f1e5	fb06de97-b722-4281-99cf-482d421bd4b0	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
960566b1-822b-4bea-9666-be2910b69098	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
179bc209-9295-49b8-b459-4705948d4733	6c50a910-149e-4247-af57-91342ca69c26	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
302bb9fb-1e4f-4afe-8f78-75b605fdd5bd	a6138b49-27ca-485f-ad57-12f6ed08e94b	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
91dd87bf-0098-4ed2-adb5-e9e2eff656d1	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
48f3e2cd-1e32-4e5f-a0f1-10efa8e2d649	5ed7695e-c900-4690-ab29-d4ecbc00d945	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
3e972c97-350f-430a-8578-a004b6392581	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
287079fa-8c60-4895-861f-ea798f012123	42e3166f-a80a-4120-b00f-22224f3248b1	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
d0877128-e892-4094-92b1-5744058cfc06	87b40694-4414-4841-925a-176a00c7826a	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
96166624-394c-431d-83a1-f730d00902cc	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
6d9dd9c9-44ce-4e69-942f-a22fbc4d5ef3	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
cb053736-cbf1-4259-95e2-9b0208f39faf	4742c248-e7ae-4e74-b513-a66f6f86a66f	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e4d897de-4224-478c-8eaf-7b792843efa2	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	e703bd05-a781-41ce-82b6-e0221018d631	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
9db2c88b-0c94-4b7f-93e7-cddff3b30e94	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	5431a241-78ce-4b21-b128-28dea9f8fae9	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
6b1365f8-c548-4752-a3a2-240b2fd8688a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c53ce851-fa9d-41ad-a7e1-416cb7b166fe	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
3b8a5fd0-90bf-45a7-bf74-3cea379ab8ab	82897173-7157-4508-9557-9e6700c0dc4d	c53ce851-fa9d-41ad-a7e1-416cb7b166fe	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
41fe1f6f-e112-4529-b3cb-2893fb54a3f5	48d1c50e-0ed4-4355-8b30-37ed358badcc	c53ce851-fa9d-41ad-a7e1-416cb7b166fe	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
f446e991-a44e-4cca-bb36-1e93efeba545	b9325221-963e-4909-8a81-6d00f3b1e7e6	c53ce851-fa9d-41ad-a7e1-416cb7b166fe	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
c940e224-9217-4252-9c0d-6b112a1183d1	a8af0e64-0ac6-46fb-99f1-6da08eeab725	f3173f6b-71d2-47c1-9768-4ed28d2ee620	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
d9465ad2-efc0-4e72-b39c-67f61948bb28	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	f3173f6b-71d2-47c1-9768-4ed28d2ee620	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
57f049ef-0c22-4e81-875c-9fe50c9bc0c1	5e837acd-dae2-4186-b57c-ae70ee945f8a	f3173f6b-71d2-47c1-9768-4ed28d2ee620	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
a64ccb4b-82da-42d4-9f4b-5e39f3d035dc	36829335-1ae2-4400-86b9-84fd4bf2de32	f3173f6b-71d2-47c1-9768-4ed28d2ee620	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
4a6cf8f7-95b7-4979-aaee-c3b387ca9438	b3aa0f67-975e-4e8e-a7e5-8f82817802cd	f3173f6b-71d2-47c1-9768-4ed28d2ee620	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
59a8b310-31a2-4bdc-aba1-6ba044e0dfef	a2e3eb4f-c4e3-4f3c-bfdd-2ca2c6f4b9ed	f3173f6b-71d2-47c1-9768-4ed28d2ee620	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
a8aadfce-bf12-4279-aff8-beb70ffd38ff	c1667389-c459-4ecc-a759-cd2b0d69d687	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
85b5012c-1447-40c5-adb9-e338084d81b0	7e2a2c9f-ceee-43a9-8c22-b0e99af67bf0	dab9453b-a30d-44ec-a414-132e953c2408	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
642d14ff-cc28-4ae3-a0e3-347cff6ddcb8	3e969c04-e8bf-4376-a556-2a039627e19f	dab9453b-a30d-44ec-a414-132e953c2408	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
87ff4b99-a320-487d-952f-278f68f409c9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	dab9453b-a30d-44ec-a414-132e953c2408	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
56d65d7c-149c-44b1-af7b-db15f6147d2c	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	dab9453b-a30d-44ec-a414-132e953c2408	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
0f59c2cf-aaad-4948-8bd0-2a4f187d325a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c1e73591-e3aa-4c35-842b-6e5ef3a4ac55	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
c79a3773-2c22-4ded-a6e0-e2fb5b9256de	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8921782b-d03c-4629-8238-ff12eaf6837c	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
7642fd70-ad5c-494f-ad30-3f08be488ff1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	5fb9c23d-5236-4675-8c9b-537ea30e248f	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
b283c90c-9272-433e-8261-112c11470520	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	efaa39f8-49da-4aed-93e9-e2ea217fc9b8	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
4c31ec61-3ebe-4ca3-8dda-570ab8bcc976	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	1aa37920-edce-42e7-98eb-4c32345cc71a	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
40566c99-a307-4e38-a50e-6ffc4d3f6d19	dae9be5f-69f8-4aba-8707-3974bd4edf02	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
a530b35f-3a12-4dc5-a3e8-0b747d8e58fd	75bc07bb-6b7a-4414-b064-9f0f7c086217	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
be586235-387a-403c-8afc-851846a3d922	45f81bc7-ff24-498d-9104-18da7e5643f8	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
b180e67f-e6f4-43fc-b20a-a9fc88b8a633	0da6fe92-db44-40da-854c-a84be86ab8d4	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
19d1eade-b8ac-4b82-a80e-7025d3db4827	ad927edf-b643-49c7-bb35-ce93c40e25f9	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
74c65fb1-e8b7-4496-9e79-080a365e80d5	04383a3e-b5cf-4875-99a7-fdd746e9cab0	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
f876a15d-1e0e-4eba-b8f7-e7b36d6db57d	04c83856-9ff0-475a-b2cd-db05406b84a3	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
099ddf59-df36-4242-95aa-3c1a27cc7dcd	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	728cb098-b1db-410e-94a4-d08a630d8076	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ada8151d-33f9-4e52-b059-caa8c8f29462	d15bfb61-8af0-49af-af82-24696cd922a9	699de247-c0c8-4a8b-bae8-6ba24d9489c1	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
b07299e1-dd3b-4b62-9806-689bcbdf5552	dae9be5f-69f8-4aba-8707-3974bd4edf02	c2d8d0d1-43dc-4d39-9170-071ff5bf0cb2	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e3d2afcf-e78b-4f63-9447-2875d7012358	0da6fe92-db44-40da-854c-a84be86ab8d4	c2d8d0d1-43dc-4d39-9170-071ff5bf0cb2	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
bdb87c69-7d71-412f-bf80-2759856e01e5	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	c2d8d0d1-43dc-4d39-9170-071ff5bf0cb2	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
d0619d6c-d074-487a-a8c9-a1c29e4c3fe1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	204d395b-19aa-483d-ace2-1fe096cf0c7a	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
af7228f1-e10f-4c09-8764-7f0a6f7032a9	87b40694-4414-4841-925a-176a00c7826a	204d395b-19aa-483d-ace2-1fe096cf0c7a	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
d2034d78-9531-447f-badb-43b7df743330	dae9be5f-69f8-4aba-8707-3974bd4edf02	5efc6baa-40ff-406f-aab6-3cd7e48a7f26	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
47e0bdda-e54a-43c0-b9d9-aa8fc686c55b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	9c4c3855-f8c8-4567-b5f9-db4c8d90b4e5	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
81ad78a6-10e8-40e4-8e1d-13f094a85d7c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	5b316a00-25b2-4fd7-8796-5dbb7f51f948	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
6178a510-d9d1-48ca-a5e4-9a4ac753293d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	b475c6de-61e8-4434-8e6c-5b7de040c4d0	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
9eb56937-152f-4df0-81d1-6ec6fd07767b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	d15bfb61-8af0-49af-af82-24696cd922a9	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
51803fa3-ef97-4a85-8612-0b5cb419359f	204d395b-19aa-483d-ace2-1fe096cf0c7a	3d328497-971a-4cca-b0e6-6d959503bac0	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
febc25e7-bf03-4c10-a415-7a00741eeb9f	3d328497-971a-4cca-b0e6-6d959503bac0	3d328497-971a-4cca-b0e6-6d959503bac0	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
aed73ae6-bb2f-40a7-a533-2dc28213603c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	3d328497-971a-4cca-b0e6-6d959503bac0	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
50e6ca69-4ec0-404f-bb20-0eddbe6ab4f7	e53c3d28-bad0-465a-9b49-e0209ff0793c	e53c3d28-bad0-465a-9b49-e0209ff0793c	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
f04df35a-fe87-4485-9fe5-2b8dbcff039d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	e53c3d28-bad0-465a-9b49-e0209ff0793c	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ee7c895f-c739-4e3e-b2ea-c3a6e048424a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	e471db4b-ef29-4670-9730-3101f90741ab	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
07fc53de-0cf4-48f0-ad6e-5763b5274e38	3a3e0676-66e8-487f-8eba-e64eefe2bf2f	8b6bb28b-3a33-4499-8d67-2bb589dfb8d8	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8d6e185d-f765-44fa-8550-b45513aa882e	39144bf1-9a12-4d6d-a814-b769473d158f	8b6bb28b-3a33-4499-8d67-2bb589dfb8d8	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
1ddaf79e-aeea-4617-ac3b-7fefd4d6a35d	e93e5575-697d-4814-bc66-66b6d5d08f2d	8b6bb28b-3a33-4499-8d67-2bb589dfb8d8	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
47101fd6-f61a-47ac-ac08-d3440859ba4a	e93e5575-697d-4814-bc66-66b6d5d08f2d	6fc7cc75-200e-49fe-935e-79111fb8948e	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
d7c71c2a-ea9b-4ee3-86bc-17d0a84667a3	36fa3c27-a0c6-4407-a386-a0b57cbbd453	dae9be5f-69f8-4aba-8707-3974bd4edf02	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
41327676-2214-42cb-ac3e-44a5cd91d974	75bc07bb-6b7a-4414-b064-9f0f7c086217	dae9be5f-69f8-4aba-8707-3974bd4edf02	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
aae18cbc-5960-479c-a247-9f7acc89ad50	a6138b49-27ca-485f-ad57-12f6ed08e94b	dae9be5f-69f8-4aba-8707-3974bd4edf02	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
fbea7e75-6d81-477b-80b6-187bd03565ec	eccfca5a-fe79-422a-86a9-00514d1a84f9	dae9be5f-69f8-4aba-8707-3974bd4edf02	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
4ed42cc2-bbf8-4815-b6c5-bf5a55e7f67b	87b40694-4414-4841-925a-176a00c7826a	dae9be5f-69f8-4aba-8707-3974bd4edf02	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
9a89139c-b98b-44ba-8a3a-bf52eb52c2df	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	dae9be5f-69f8-4aba-8707-3974bd4edf02	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
fb207908-a53c-41ce-9857-a9dfadb15868	4742c248-e7ae-4e74-b513-a66f6f86a66f	dae9be5f-69f8-4aba-8707-3974bd4edf02	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
2103590e-a0ef-43e2-b7d1-817609824030	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	82de6c86-64f8-4b2f-afb3-ad42f3064102	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
c09e56bd-6d01-4027-96b3-32ff3de11aca	4bd2dff5-6f63-4ad3-a9ee-61219df00045	bf0d2a55-ea51-4de8-bdfb-0e13d2fee800	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
26b3872f-e2e7-4eda-8353-99dd4a5bedd3	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	f7578885-4640-41c2-9831-c994c131ab57	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
1eb47ec1-353d-4747-944d-b31cf4ee8152	583dcdbe-fbdd-4ecf-800d-831c7f7716f9	0ff90b8d-2766-423f-aee7-0393dae688ea	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
44873130-2e9d-47c3-8964-ef898e59b21c	1e2957ac-522b-4d7a-bc6b-5c33ca78ecde	0ff90b8d-2766-423f-aee7-0393dae688ea	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
5c40c45b-ae5f-4fdc-b851-2ef345642394	437a268e-e28e-4d15-b50f-3190fff9acaf	0ff90b8d-2766-423f-aee7-0393dae688ea	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ad92b661-5635-4365-90c4-adc84a684e6b	cf6d3ef6-631e-43f5-8ed7-2554c4bc570e	0ff90b8d-2766-423f-aee7-0393dae688ea	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
db8ab0fe-0ec3-4bad-b33d-8157e76676f6	3e969c04-e8bf-4376-a556-2a039627e19f	8f2abc6e-f4cf-4ce0-81fe-6a326079d556	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
462d4dd0-06ac-41c7-8252-ed95d78c6310	8b9c80e4-3072-4dab-85a6-36e310fae6ef	8f2abc6e-f4cf-4ce0-81fe-6a326079d556	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
66bc7445-04a6-4927-99ba-b77c8aca3003	29a63532-c5b1-4ebb-bba4-9a22abdd986c	8f2abc6e-f4cf-4ce0-81fe-6a326079d556	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ae15b48b-9ed3-4340-856d-d638117847bd	c1667389-c459-4ecc-a759-cd2b0d69d687	8f2abc6e-f4cf-4ce0-81fe-6a326079d556	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
130151b3-08a4-4854-b766-bbdc8c58d235	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	abfbdf7e-6cb4-4977-82ef-93211e950a6c	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
51825933-9d86-4764-be86-0d0e70126a72	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	76437582-061c-4b94-9873-a4e3b6b8c787	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
c8f61f05-eaa7-40a0-87f9-657ea3dd6e0d	dae9be5f-69f8-4aba-8707-3974bd4edf02	36fa3c27-a0c6-4407-a386-a0b57cbbd453	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
66bb5834-33d6-4397-981b-8dcfe05a7d37	75bc07bb-6b7a-4414-b064-9f0f7c086217	36fa3c27-a0c6-4407-a386-a0b57cbbd453	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
48fcbc83-4f70-461b-ae55-9f6910415a47	4742c248-e7ae-4e74-b513-a66f6f86a66f	36fa3c27-a0c6-4407-a386-a0b57cbbd453	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
2bcee759-9015-4aec-9a1e-c2aabe1f0f94	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	b651ec49-f0b6-40b6-87b9-af90f919e1c0	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e36fa349-317c-4aa2-a6e1-facda41a1b7d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	a9a3eae9-470b-4e07-ac58-37a0d62d0ada	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
d2d6cf4f-28f8-4ceb-99a0-920bb1ddc51d	6781d49e-0a52-407a-bbd9-57152fa52741	a9a3eae9-470b-4e07-ac58-37a0d62d0ada	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
bfe2caf6-a5fe-4d1d-a7f3-465f6eb7882e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	704659f3-e212-472b-951d-80c1d942b506	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
58eb23fe-f324-4844-a2a3-fceb8c0bb09c	631da6d3-9081-4d4d-8f17-98f6f1e128c4	704659f3-e212-472b-951d-80c1d942b506	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8328f70b-b050-4d09-9546-2ce89e74a164	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	66324a2e-a1aa-41ae-ad82-1e3edb50b082	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
db96f6d7-9385-405c-8c11-ea7f5f1b3147	cdfe543c-a78e-4dbc-ba5b-f3a8e6aaf43a	c75d3de2-68b2-41b1-ad03-687393e3eca1	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
389c9de2-3bd1-4b49-ba48-3b00cc61e69c	5431a241-78ce-4b21-b128-28dea9f8fae9	8aad06a4-5b48-41bf-8bff-e965cd620dc2	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
fa160039-ba44-465a-9d7d-85c6ca6efc95	a6138b49-27ca-485f-ad57-12f6ed08e94b	fb06de97-b722-4281-99cf-482d421bd4b0	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
714da689-3ca4-4077-abd2-0f770c11e52d	4bd2dff5-6f63-4ad3-a9ee-61219df00045	4bd2dff5-6f63-4ad3-a9ee-61219df00045	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8efec2a7-a698-434d-ac91-2172a2024f34	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	4bd2dff5-6f63-4ad3-a9ee-61219df00045	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
4eceb396-e778-4730-8b53-0fed30e34f66	dae9be5f-69f8-4aba-8707-3974bd4edf02	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
912f3dad-adb1-4355-9389-6d724e04733a	36fa3c27-a0c6-4407-a386-a0b57cbbd453	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
67822ca9-0a9e-4c3e-80c0-b78a0a52ade5	45f81bc7-ff24-498d-9104-18da7e5643f8	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
6a3f0078-0a75-420b-8fcf-7e776e17fa27	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ba830475-a22f-46e0-ac99-18927f3df8c5	a6138b49-27ca-485f-ad57-12f6ed08e94b	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
b5d16339-03d2-4ff9-b2de-084d3b1b2202	5ed7695e-c900-4690-ab29-d4ecbc00d945	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
120c2cbd-8031-413d-b669-c8a0b2114eb3	04383a3e-b5cf-4875-99a7-fdd746e9cab0	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
a171658e-299f-45a2-bfbb-6b2c44c1fd26	04c83856-9ff0-475a-b2cd-db05406b84a3	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
86eae2fb-a2cf-441a-8bbb-75ed1565779f	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
48a0d278-395e-492e-977d-12e165d0b18a	4742c248-e7ae-4e74-b513-a66f6f86a66f	75bc07bb-6b7a-4414-b064-9f0f7c086217	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
5d2ecfdc-8c9c-488b-9d4c-453a903bbf16	728cb098-b1db-410e-94a4-d08a630d8076	45f81bc7-ff24-498d-9104-18da7e5643f8	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ddfc4ef3-55cc-4332-bd14-76f4a483cd89	75bc07bb-6b7a-4414-b064-9f0f7c086217	45f81bc7-ff24-498d-9104-18da7e5643f8	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
7950e4bd-0380-4ac5-8690-2a349e8f4f0e	a6138b49-27ca-485f-ad57-12f6ed08e94b	45f81bc7-ff24-498d-9104-18da7e5643f8	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
56e1c609-6be1-43e5-a473-70d3419f214e	ad927edf-b643-49c7-bb35-ce93c40e25f9	45f81bc7-ff24-498d-9104-18da7e5643f8	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
c626912f-282c-4d28-9511-4600a55813bd	04383a3e-b5cf-4875-99a7-fdd746e9cab0	45f81bc7-ff24-498d-9104-18da7e5643f8	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
0f505145-7cbd-413a-9980-e81306b3d140	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	838a9ef3-af3e-4655-99b5-a06134155c07	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
3c4ee6d8-2265-4b37-8cda-442e7793c915	28058267-5877-4bc2-a880-395176bd6b22	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
52dce9cf-0e35-41b4-9be3-d5c46b22c843	8812812f-8bbf-4ae2-914a-b8cae24cdbcc	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
432de633-87f7-4a26-acb7-96ecbf48fe85	583dcdbe-fbdd-4ecf-800d-831c7f7716f9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
221634ec-281f-497b-8f57-739f1fba2fad	e9c970a7-cd3b-452e-b6f7-70b9d9d60148	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
83a355a1-cf02-4457-8647-b99046f581ae	3e969c04-e8bf-4376-a556-2a039627e19f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
b9a3b834-9570-45af-917a-f9652e16c8d3	e23dd0b2-7699-4b27-9b31-7966d2d7376a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
389b5a68-5077-4c35-988a-127f6ccb4c40	e5b526bd-4554-4b99-bf91-204c2583a5fa	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
91229ff8-786c-4243-b76f-8d2ea8df7356	5431a241-78ce-4b21-b128-28dea9f8fae9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
f0634e8e-00da-441e-bd90-01036f431ba4	47e2ce69-9af9-4b6a-8c32-c1ef3bb659e1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
4788f6ca-c363-4880-b2f3-733628804f15	c53ce851-fa9d-41ad-a7e1-416cb7b166fe	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
3be411c6-9ed1-4f5e-a4ff-3c9a43961ceb	dab9453b-a30d-44ec-a414-132e953c2408	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
70eabaab-05c9-4add-aba2-9ddcaa082fbb	1e2957ac-522b-4d7a-bc6b-5c33ca78ecde	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
efc146cd-e89e-4f01-9292-d96fcb9408bd	eab0bcf1-82f3-40db-82fb-ace10ee4a383	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
4da14901-02f6-4877-b376-ace36789fa7a	c1fbb481-dd2c-4585-9b7c-06d180d77d2d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
b26aac33-11ca-4a75-a89a-d3c1b5d16a55	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e79cc10c-34f3-4951-ba92-5a36670f6c79	d0104fdf-dc7c-451c-8f1f-3f9abb4de8e9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
841a1331-fc93-4525-8452-f89e97a2e874	5fb9c23d-5236-4675-8c9b-537ea30e248f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
f2773e13-2e69-476d-9310-8d972dcb9034	1aa37920-edce-42e7-98eb-4c32345cc71a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
47075849-a971-4a73-b9a8-2ce1b9c28e2d	69fc4171-6fad-4eaa-a382-8994f76b1f8a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
089d24a5-896d-4a92-ba1c-aebae0efe08d	c662510d-a483-4da8-b9c4-96f2bb450a40	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
f3c9c3d9-94c1-441c-b0a2-1e240ef28d7b	c97bb436-c55e-4222-a494-49af4ac02b31	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
f0dec21c-77c5-41b0-87ac-8e688c770ad3	728cb098-b1db-410e-94a4-d08a630d8076	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
87bc887c-d7ea-46ac-b3b5-1921b7c12a07	5e27148a-c486-4282-9cc5-7ec352cd411b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ef6ab65f-ea30-4d26-a353-4a445f395d25	b108c58a-4722-4bb6-bf8e-d3486b06d900	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
256f3f07-cb81-49a5-9d16-e14d1ba1a109	407ae14a-060d-4d91-89d1-39535ab93b0a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ec8f79ed-6493-4beb-bfb0-c4bbd9533d78	ccd77641-e05b-4160-8b88-90f763fd56cd	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
6e6ef0da-b7d3-4315-aa93-b251dcf50ae1	c3e729df-b864-488f-950e-b828d01ab4e0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8749387a-35dd-4d8a-a071-ec9741d8f67e	539dd60d-44d6-4808-a75d-976f4ff14489	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
6f31669b-abc2-4c1f-9098-4803cfeab9a3	4cdac558-f594-40ab-9bd7-2d3a30f344d8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
2387e146-dd36-4173-a932-32cf923ddd8d	c2d8d0d1-43dc-4d39-9170-071ff5bf0cb2	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
b9b58dd6-ad7d-4511-93f0-ff53b2d93ed5	204d395b-19aa-483d-ace2-1fe096cf0c7a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8a6a32d4-4235-433d-9779-7b5599b53957	48101c5e-8026-4206-9b7e-bb3c01018b75	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
9c1430b3-425e-4658-b691-35c1800fed07	cf1e383e-42f9-4548-a737-ffa464a2a1e4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
22bb3705-56bf-435c-a12b-f335d71777ec	7b962db5-8fc5-4b0f-82ea-4c3728add8a5	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
2aa26939-77c9-4ebd-8616-1ef9a06d785c	45aa8b28-c678-4e4a-9352-27ab690df852	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
de4d39b1-24a8-4225-bff7-119a442b8eea	437a268e-e28e-4d15-b50f-3190fff9acaf	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
c927fd09-3bb4-4e5c-bd69-53a4f86e2847	5efc6baa-40ff-406f-aab6-3cd7e48a7f26	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
a67b9ec0-f612-4630-b0aa-0f954eff9f55	9c4c3855-f8c8-4567-b5f9-db4c8d90b4e5	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8c91bb52-d421-4179-9238-b6c486e7edfa	9bdf6f88-144e-4836-9d28-a1e6715e47e6	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
a563582e-2767-4dd9-993d-ae9b86c8fd4a	5b316a00-25b2-4fd7-8796-5dbb7f51f948	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
50b39548-aae0-4520-93c0-99768d1336f5	2fc63575-ed81-4633-9117-b8fcb774cf85	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
9cd3ec29-85ef-4c11-8bb4-fdd98b75bb0f	d15bfb61-8af0-49af-af82-24696cd922a9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
f02e5528-d628-4e3a-8f49-22b57aef179c	1543db57-9c36-4a03-b917-401ada53eb22	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e4411008-19fa-40fd-aba7-b957b217662d	3d328497-971a-4cca-b0e6-6d959503bac0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
a20f8964-21b5-4bf0-810a-ac3b73271290	e53c3d28-bad0-465a-9b49-e0209ff0793c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ec3871a1-884d-459e-a189-caa4ea3f5094	e471db4b-ef29-4670-9730-3101f90741ab	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
37fef1fc-833b-4e4c-8755-3a7a8fe99628	8b6bb28b-3a33-4499-8d67-2bb589dfb8d8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
a5053638-b0ef-4253-b1a1-369c83305bbc	6fc7cc75-200e-49fe-935e-79111fb8948e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
a1adfc91-3b09-4da9-a18f-b3f640b357bc	3c7cd7ce-dcc5-439d-ae39-00f31f02030d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
f8a6ab08-6021-4db1-a495-1710bcd008a7	60c1c053-6438-451b-9772-4525172235d0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
2613dfc5-a39f-48b8-910b-f5d2cc5ab367	4088dc01-b5cc-4127-98cd-93debca761df	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
4f5a30be-7481-46ab-ae0e-75865c24f3db	80d50a82-65db-4ce9-bf3e-e679c14b6765	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
fe37e309-5859-46ef-98d2-7999e1cd67bb	dae9be5f-69f8-4aba-8707-3974bd4edf02	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
f6e0842c-9d3a-4ff0-a788-1f95746b93f2	b998f6fd-4ed6-46ac-a68a-cac842099b5a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ba6cd581-4a13-4376-ad59-18c45f37da97	82de6c86-64f8-4b2f-afb3-ad42f3064102	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
7b9226ce-6742-48b2-bc3f-378bc78b8dc6	f7578885-4640-41c2-9831-c994c131ab57	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
edd11340-5308-4c5e-a3e2-d7b70fc5a3fb	ac2d044e-0c82-4e7c-bc7f-2781191a1148	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
391047e0-07a4-4208-b323-026c36129232	4fa50c02-239d-4274-b782-0286c6a1b05b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
a2c45962-740f-4633-ad4f-bb5fd02c91bc	63d512ee-b850-4993-b486-e5494d188bfe	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e32365b6-eaf8-4975-be9d-2a91c3d33015	dbc18365-0064-48a1-a511-f11f56929643	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8a8e172d-b521-4b28-8847-9150aa16b775	0ff90b8d-2766-423f-aee7-0393dae688ea	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
031d990f-3964-41db-a650-ddc72a3d3f9a	1349490b-955e-4a0b-b00b-c392d1cb71c1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
5913b599-1652-40b3-b942-1f67ea01df0a	abfbdf7e-6cb4-4977-82ef-93211e950a6c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
c87d9cd8-34d9-40e5-a85e-e2b79a1413bf	76437582-061c-4b94-9873-a4e3b6b8c787	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
5f211eec-56ce-4b30-93d4-d6b87239457d	2c161160-a3de-4af8-b178-11700da1ed54	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
3dfe2b87-114f-40fb-a53f-e8eedb76556c	d99d51b7-3349-4bf6-8803-618705c95d2d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
780fd549-8a87-4450-a0d6-222cd66d18aa	0cab1976-8937-46ee-8a8d-9e3d831d258b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
d8c6e563-f3c4-463b-a6cd-db68b6ca0c69	5ddcc4e4-ee30-48b1-939a-09439b14e6dd	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
5f4695ca-e1ea-4d46-9ef0-37c703699d24	36fa3c27-a0c6-4407-a386-a0b57cbbd453	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e452b241-154c-42fe-aec9-6b27b44ca9e7	b651ec49-f0b6-40b6-87b9-af90f919e1c0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
a67716aa-edbf-4163-a2ee-48b7b4261e25	a9a3eae9-470b-4e07-ac58-37a0d62d0ada	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
cbbc51d5-1abc-47aa-9113-a7b8173d6989	1bd86dd9-872f-4a68-8602-a60813df56c8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e69e6c8e-b63a-43fa-b87a-9b8245f57301	704659f3-e212-472b-951d-80c1d942b506	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
edac126b-3714-47a6-8474-c162d0886d45	60aaec3d-f58b-40c4-8ecc-f12c307faf17	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
c3866308-e65d-4f98-9ca2-506922832654	12f68791-85a0-41c8-8b5d-e80943e321da	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
87cef2cf-b44b-4d0c-871e-9766a76f391a	998a1f5c-0ce8-43d0-addb-c6861ab126d9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
303ae255-7c80-4ba1-86fc-ee35f0f221de	78587ca2-7caf-4b23-a0b0-16abff115c30	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
09740b9f-0a15-4e91-bbfc-4f300c1daeb5	c75d3de2-68b2-41b1-ad03-687393e3eca1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
bcb4fa30-b76c-4b0a-b5f4-0e16441cdf25	6895b079-41da-4c80-9b03-a13205bca38d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
567b5a96-9c13-494c-bc2f-2bde822c26c8	688d0ae3-2734-46f8-94ba-26314aeec7c9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
364ba6c7-ef34-4a64-bed0-834eac9bdd06	04a73285-3f3c-433f-917d-15f913b0737a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
921860f3-7e24-46c3-ba9d-7dc7c98ac1f1	fb06de97-b722-4281-99cf-482d421bd4b0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
c3ba2a2a-3ea5-4199-a2cc-440c514712e2	4bd2dff5-6f63-4ad3-a9ee-61219df00045	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ef6e86ee-3af2-429d-b6e0-391652583457	8490695f-9b65-4b5a-b9ee-2a0987b921dd	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
a733cb44-5630-4b02-98d2-4e0f0d110f1d	75bc07bb-6b7a-4414-b064-9f0f7c086217	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
63ead403-40ad-473a-8cce-7827b07d2e4d	45f81bc7-ff24-498d-9104-18da7e5643f8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
99926b51-d2a3-4457-85e8-3bf533d1d1e4	4e2bc8e4-d7fa-4757-adec-22c5c62d9b69	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
4fb6654c-415b-4bf7-9c42-ce1b95731e82	8b9c80e4-3072-4dab-85a6-36e310fae6ef	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
61e44e42-87a3-42f1-ae7b-d363de0aaa18	706ae8d3-4398-4f3a-b0c4-d2476d6e9d97	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
b38b5fb9-b1db-4500-817b-4ba28b24de49	0da6fe92-db44-40da-854c-a84be86ab8d4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
6e0d8bb6-67a6-4ade-9068-7bcbb156ec32	6c50a910-149e-4247-af57-91342ca69c26	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
dbd85777-f1ef-4603-882d-380135dc06a6	67c41f98-232b-4c1a-ba47-348bc540c17a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
5948dcbd-faba-474a-a533-af96cc0afbc6	ac8046ab-5699-4eda-bde8-056ccc1dcda0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
72301d36-c3e1-4060-9b95-f916961ee64f	a6138b49-27ca-485f-ad57-12f6ed08e94b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
41796818-0a0d-4366-896d-8841e5346780	2ddcfb31-7ace-442b-9cf9-eb1966e09627	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e7078792-9471-40c9-bbb7-53768232b471	e1d0121d-7fc5-424b-860e-065f92776ca1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
3bd0b360-f5d3-4ae0-a057-ee65f211f9a9	9079e6fb-d198-4c34-a483-39df60af375b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
08f10ace-e2d7-4504-b017-af2fd51fb0c0	0be157db-7f72-4e13-9c10-5b3a30bebd76	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
fbe825c6-90af-4084-b8aa-d52c44ff01b5	d05bf38b-f898-4dfc-adcc-dce47a90a1c7	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
93d27a0d-cc0d-46eb-9166-2847457ee270	d20a6a07-b621-4dd3-a202-78ac56696c2c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
1c8290fe-3b12-4073-b794-2278ed625f57	12f8683d-d1eb-4e71-b60f-75df4e0f8169	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
bda110c3-0b2c-448b-afe6-bdc46bd19177	db049daa-59cb-425e-bdd9-c6dbbdff5b95	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
33c9a716-f740-4fd9-b227-0a237455de75	1595e4da-60d8-4646-8dcc-c761e435937e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
4d30198a-7ca3-415e-b090-a65a3d07f9b0	fc57deea-20e3-4959-bb07-ce80c36b7a8c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
213321f5-c541-40eb-87a7-2a7e1565f17b	ff42b26e-122c-4b16-b896-f06c990c2c01	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
881cbb8f-5d19-45a3-a654-b17c5d56a191	1a88ebc2-fa9e-4566-9043-3904425b19ea	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
39ae28f6-a8e1-4297-a33e-d0f969f4b1b0	cf6d3ef6-631e-43f5-8ed7-2554c4bc570e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
c1dbd3a2-985a-45d2-8f5f-d0b8fe966dd1	bd9d47bf-0c6a-41ef-8fa7-9924e9cc868d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
dcaf16b0-c31d-4b55-b9b9-5884c31d4421	f270fd28-1c02-46bf-ac9c-8179ed1185bb	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
125b620e-fa81-4de7-b721-6afd24185894	ba7cf405-2477-4369-97ef-ed720e0686b6	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
3b5b9c8b-1050-40d8-b1a6-112337aba1f7	e0161890-fc0a-40a7-b14c-0bf1d40cf3d5	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
4c63bcd0-f2ca-4584-b384-7fcfad248532	61b3566e-f3e2-4116-824b-0be7e6d5f9b8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
b71bf9b6-5d26-4997-8d31-9fedf4040d4e	8d376618-ce43-42a3-aa6e-4a7a3cd11f36	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
062933c7-994a-48ab-9bd7-48fb9cf6d17c	3a3e0676-66e8-487f-8eba-e64eefe2bf2f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
1484aae2-9f21-4f1e-9e93-4875d6fa400c	bec4ca37-50c4-46ea-9840-a0228ce9df38	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
a4061166-1500-4469-825c-531a6b2ea7f7	c2a418bd-aae3-479b-8d28-dc4a3fafb5e4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
7220b842-3a47-479e-8144-49c36b0457b7	d751f28d-f47d-4486-8ff8-94358cdf53f7	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
2a766634-c122-4420-bbee-5c74816072b7	d8e42301-a8b5-4708-87c6-440ca9acd37e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
80d42119-cbab-4173-a7c1-21adaffb61bd	06b9b48a-abaa-4d24-8ee9-d94d5ab0ec66	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
5e1534ce-c20b-4b8e-9140-395dae2edc7f	631da6d3-9081-4d4d-8f17-98f6f1e128c4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
47f6608b-39fe-4a20-a874-356e232de308	1a550834-b834-45c1-a899-392a50b5ee7d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e9aea0bb-3e2c-4ed8-8f12-15ea75058445	d2feda35-cf48-4d50-9db4-5d5cab9a96bd	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
64fea5f8-a5fa-400e-9f91-a7a309241496	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
fa93ca43-49f1-4dd4-8372-93e4dc17bed2	8ecd4380-5e50-4e97-ba2a-255ce4c2c4e1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
dbe5e5e5-a64c-46f4-bbbc-d5a4512de1ae	39144bf1-9a12-4d6d-a814-b769473d158f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
abf4abce-7ff4-4857-8a90-7fbbea701514	9c575b13-2b96-4e73-8ae6-21267b4cf871	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
11f9f2af-a8d1-4403-bc4f-d40486938376	e93e5575-697d-4814-bc66-66b6d5d08f2d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
44534795-d914-4974-bff5-9c98a14d9674	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
243a872e-5fe3-4697-8953-14c88777a1f9	3ffbd728-c91d-40c5-8bb2-b45e93c1ff6f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
59d73feb-eb2d-43ba-a677-0f461f1eecc8	cdfe543c-a78e-4dbc-ba5b-f3a8e6aaf43a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e9d226dd-338f-41ac-b736-9b89c46e807d	a5375a3b-6bcf-4d38-ad41-d0f132461966	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
2f88b648-a5f7-484b-bfbe-697e11eca975	6ffb9390-3177-4546-993c-4b4b225bad8e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
85599aef-bf2e-4599-8886-edba601b610d	c2a554a7-8f5e-4f75-a4cb-115cb59a4f75	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
46dba507-cfd1-4d2a-8b36-b26f24f1cc00	ceb2e076-e8e4-4f5e-a944-e1d423c62834	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
f44c3cab-a3cc-4e1b-bc02-a0c333b1a46d	4c850cce-3170-46ea-9669-f891b4bad0da	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
418c8bdf-1c2e-43b6-b267-1e923ffc688d	5ed7695e-c900-4690-ab29-d4ecbc00d945	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
14938a94-abaa-43f8-a10a-c275ff99169f	62ee5b22-cd13-4cb1-bdcf-f2976f9328fd	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
26e4b31b-44d1-487a-b437-113dec18d817	bdc0c353-4bb0-42dc-aa6c-a00669fa03dc	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
90f5842c-cdb1-42be-a161-731e5c87432b	a1d9d15d-9674-4992-a112-44dbb8d0dff4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
492b52d1-8f1e-4ead-a49f-52528b128e2a	b7c71dec-b765-4ab4-845a-042585452059	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
3b631fc6-5068-4cdd-8c2d-49af229031a5	c1dbe57f-98a3-4a7a-b19e-73086799fcdd	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
bd7a8d0d-1b6f-4bbb-a2fe-560b0ffc94bb	fcf287b3-077c-40fd-8f4f-50ddf266fd4a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
c196db64-14ff-421f-9df3-4ecdd671ea72	7258a2ce-894f-4ce1-a260-84a7452f4d22	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
a9dbef1f-0147-4187-8cda-1fe6fc4fc479	04ed257c-7497-4592-8157-d7526ebdbfcb	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
00825c67-2881-4230-b406-15c8a54763e9	481f84ac-0826-476a-8bf5-7ebf33a13fc5	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
1a8fa4c6-1077-46f8-b038-09f57c2fff44	1ce7f618-ad5a-4831-8ab7-941266b34f24	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
69de878c-e984-4937-9a6f-801eb962071f	a3135e59-6d69-4b85-aba6-44192a01ccbc	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
17636cef-2a6f-451e-be35-8460b0329b1b	71ce6255-8c70-4d98-8f03-17b1f88d5f10	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
1c1a8a40-bdd3-47bb-b803-6174368cc86e	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
18b36606-5faa-46d5-8b9b-6b149fac403b	a2e32bac-cab2-4eb8-a43e-9dfda0f1ca48	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e4056455-0489-443b-ac58-00c77bb35989	780cd261-4746-4bc4-90c6-9457ad08308f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
53471b06-521c-40c1-a78c-4ed8fdab5954	3970a38d-c005-44fe-9b79-e89b7b8a5ea5	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
d694eee2-3e21-4385-a6e5-f0c077ff674d	5b277fc8-1da0-4867-beae-f6a8e72f490e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8f54fed0-6785-4052-86b3-cb3de5c3c7bc	b720f98f-9a0c-43e7-958b-9855a27a7c71	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
b7f28632-59e7-4443-860c-d922cd7ada01	82897173-7157-4508-9557-9e6700c0dc4d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
1b95dc80-dab1-4e4a-a8a9-c4ea5b32cc7f	a1468102-4c03-47f4-a390-cc625f636017	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
a561eacc-2106-4fb2-8225-72b5587a89d3	376225dd-5419-4aab-862c-25bd9e67f5df	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
2567719c-4ec4-4296-9eca-034f9d91fc61	b7068e6f-0513-47a6-82d5-a67333d69e31	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
fe547f5e-2bdf-4b51-a750-a3344aa31cdb	7a2ca438-8b6c-492c-8fbb-797c9e4e7e1b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
6e285a87-087a-4948-aafb-8d7c740587ab	8b4f4e5f-3cf7-4790-ad3b-90f52d6c381b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
000dd8cd-32de-464b-9278-26de1406d46b	1b4707dd-eaff-4276-8e8e-2c25fccd068d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
d4bf6dba-b33c-4e11-b8dd-fd545f407b8e	24b51865-5001-43e3-8b06-f791014a9954	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
4e0c3b50-8663-44ce-996f-7d5d6687841a	62cd660d-f79a-414d-b7a9-ddba6338048d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
2843c0b9-2525-4992-9513-6a9b3c4f773e	eccfca5a-fe79-422a-86a9-00514d1a84f9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
95863f8c-330f-4278-b860-bb543d03d5c9	0e691109-aac1-47b0-9727-c9078860a89f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
19cade2c-7617-4584-9ab7-7cb7bef4c89f	87b40694-4414-4841-925a-176a00c7826a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
9e2276b5-594b-46b0-9597-43773da2b689	a7d7d2b7-8389-4a67-91e3-7aaf6940bf49	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
c07aef0c-6287-48fe-b37d-180430fd8f32	b3aa0f67-975e-4e8e-a7e5-8f82817802cd	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
c261daae-0968-442f-8ac1-49fbc6a094d5	6781d49e-0a52-407a-bbd9-57152fa52741	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
5dfdac40-087c-4bf8-9c1d-bf16ce549e40	05f1ea88-de99-48ad-b7cc-38ed173ba5f6	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
1743d804-079b-488f-b9a3-92518edbfbe2	f578ba4f-f883-4dd2-b920-6614af947bd4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8fae038b-f9e2-4a1b-9024-35dbeda55167	17eb1c1d-7c3d-487a-8fea-baff32b2937c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
c49ff55b-fff1-4114-81ec-dad2478a3210	04383a3e-b5cf-4875-99a7-fdd746e9cab0	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
78ae5d5c-050d-4fde-84fe-8223bbbe3e6d	04c83856-9ff0-475a-b2cd-db05406b84a3	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
85235bc7-ca98-41fa-a995-5d5690a8b3c3	63b91840-aeb7-4558-a952-9e23e7217c1c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
bde081b6-7a17-4196-b91c-91852e93c405	05ed794e-f094-4a48-91b8-211b37ab3d4f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
45bd3af8-7156-4f36-bbb5-3215223ccd05	48d1c50e-0ed4-4355-8b30-37ed358badcc	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
b86c635a-47df-4db6-96d2-c1f1a29a3320	cfb0a68c-2135-4df7-ba69-3421c2a01173	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
bae00517-a91a-4523-bf59-476c57815991	1a613180-d253-411c-b05e-9087bb2537a2	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
fde442da-99ae-4dc4-8e8e-7d086294a362	072c2418-239b-4944-93f8-da9eb88be608	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
2f9e0b97-ccab-48ee-a587-551e7664258b	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
4bf23a7c-ffc3-42a4-abd8-b601e5291f6d	aca0f31b-c1da-441e-8568-e7c13b498797	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
d7b02722-87f1-468a-bd18-73afd9bb68ff	55343256-1601-423a-b1a4-3d467d2b64c6	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ac3b41bd-da07-4fb2-b10b-9a2004c3c5bb	4f5a91b8-5ae2-4451-8595-e30b2f37474e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
6fe4e3d9-4a1f-488c-b1d6-aba151b1451d	691a7808-92eb-4fce-a618-d51867429491	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
65e25daf-1bcd-431d-8025-4dd8055712cf	a38b5915-0abf-4faf-9807-79a55151dab3	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
aa5d7574-9b47-42f2-a229-4afddcf8ed5e	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
a338151c-e251-416c-bdbd-6de087c714e9	9533dac5-4510-48db-9cb7-3ae25c3c7ad4	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
85733c1e-8b07-48ef-8b78-197001a0cbe9	b370e760-5bed-4ade-8488-fe7c4c972e04	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8073a290-cd19-4948-bcf8-2536dd415198	c88e824b-4488-4d90-a69c-cfb61fbe4791	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
9b3d3237-1b34-42c0-88ce-dff8e48bdb94	07ee028a-1e71-400d-a185-39dc4299803c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
6d5f6c09-cdb7-465f-ac7e-3bb990b2821b	50d7763f-3b95-4adb-917f-04fdaf9d88c3	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
49921f14-250c-420a-92a6-f0b94ed24761	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
d506335a-1ced-415e-a505-a585ae8eca55	b9325221-963e-4909-8a81-6d00f3b1e7e6	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
07e47c8f-ba2a-4b6a-a7a2-a3fdc626c958	317cf77d-0e89-49b2-82f0-b20073914c0c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
651fc475-999e-4a3f-a62c-8dcf551e2ddb	6c98251c-b1f6-4af0-96f7-37b08b66a067	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
d96aff99-9428-432e-8744-756aa8ab6aa7	4742c248-e7ae-4e74-b513-a66f6f86a66f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
80b7aeed-5b44-4b09-860a-fd8b60d49677	da338792-0065-494a-960b-662d367ec669	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
53d30013-316d-4d76-807d-87b5c5402130	c1667389-c459-4ecc-a759-cd2b0d69d687	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
1abdef67-eb2a-40f4-9507-12ad893f7bd4	19ab8ef6-2d97-43c6-9b8d-d8763bab7242	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
76df60e2-0712-480a-8a9e-4f4fa5c670a5	38bc0ed2-b6f8-43ab-8c00-4881911d0a64	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
749d7f87-d698-4414-9574-e10abaf63018	77d688de-9a29-4e5f-a453-9479a9fd7f8d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
3a4750b2-f93a-4795-a260-0243c5c522ea	8a5b931e-b073-4af9-a916-4b214183a825	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
0a2a24c9-4590-4666-8cf0-12e201347a32	2eba665b-39d7-41a9-bb0a-f6b5e9d8063f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
3636ba44-df91-4bb2-be40-a4ae4c882257	b558d227-6709-4505-8753-991479735966	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
2c6fb23b-2ab8-4357-bc5a-3b1e2c5037c9	e489a5af-6a15-467b-97e8-f144421961bc	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
d2187297-e313-4bf7-998c-b2a16168b8b6	f3a78141-9a77-4b27-998d-d2b4d366e088	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
a48ef059-0cf6-4d1e-bd33-82fedd6f55bb	679443db-8000-4a0b-9fda-92d3e021a062	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
aeabe195-d422-456c-a3f4-a79e729d7556	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
f3013153-9f7b-413c-8ef2-2025c0ebc5ff	8812812f-8bbf-4ae2-914a-b8cae24cdbcc	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
9f09fada-c678-426f-b898-ca7f5f1495f8	9bdf6f88-144e-4836-9d28-a1e6715e47e6	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
80042910-1dcd-4b9d-8e43-58167c1b3739	e471db4b-ef29-4670-9730-3101f90741ab	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
688f69dd-b16d-41bf-8623-72e8be6fff1b	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
89c8f776-daf5-40d5-9fc1-94460e8dfc52	29a63532-c5b1-4ebb-bba4-9a22abdd986c	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8f591ad8-c1cb-421a-b76f-1bac20f599ec	7258a2ce-894f-4ce1-a260-84a7452f4d22	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
115dd7b8-492b-457b-b477-30f850343e01	c1667389-c459-4ecc-a759-cd2b0d69d687	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
60d4c096-0537-4ca4-925b-5931bdd959de	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ee1b09de-af5e-4c1b-8c82-e3350d8b2dfa	728cb098-b1db-410e-94a4-d08a630d8076	0da6fe92-db44-40da-854c-a84be86ab8d4	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
0ac4409d-e5c4-46d3-a122-3bd17dd82a89	dae9be5f-69f8-4aba-8707-3974bd4edf02	0da6fe92-db44-40da-854c-a84be86ab8d4	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
640285c6-ab40-4720-8409-73d737c13caf	75bc07bb-6b7a-4414-b064-9f0f7c086217	0da6fe92-db44-40da-854c-a84be86ab8d4	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
c7e5f3c4-dbcb-43eb-8fd4-310237649d73	a6138b49-27ca-485f-ad57-12f6ed08e94b	0da6fe92-db44-40da-854c-a84be86ab8d4	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8d5a9287-3abc-4552-b52e-77c161f33a66	04383a3e-b5cf-4875-99a7-fdd746e9cab0	0da6fe92-db44-40da-854c-a84be86ab8d4	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
9b21d51a-fe24-4927-9625-d5b248417416	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	0da6fe92-db44-40da-854c-a84be86ab8d4	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
2d357de5-059f-4e8c-8064-7aa6f4f399f0	4742c248-e7ae-4e74-b513-a66f6f86a66f	0da6fe92-db44-40da-854c-a84be86ab8d4	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
0a02f23a-a901-4e60-9433-9e76ccea5ef1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	6c50a910-149e-4247-af57-91342ca69c26	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
afa69d98-182b-4730-8952-cca7efc0e1a7	3e969c04-e8bf-4376-a556-2a039627e19f	29a63532-c5b1-4ebb-bba4-9a22abdd986c	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8d6b3c56-2ad1-4a2b-92ea-a4b617138107	20115650-29ba-44fa-9861-99c990caa5b1	29a63532-c5b1-4ebb-bba4-9a22abdd986c	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ccb9b7f1-1cce-43ab-8860-a4f1bca74579	3e969c04-e8bf-4376-a556-2a039627e19f	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
5131ab53-57d5-470e-a39f-3b80de786907	5431a241-78ce-4b21-b128-28dea9f8fae9	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
770c3deb-356d-476c-a851-860734b3baea	e471db4b-ef29-4670-9730-3101f90741ab	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
4ce996ad-573c-427f-ad36-b27c0c93f387	8b9c80e4-3072-4dab-85a6-36e310fae6ef	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ed7eabbb-8484-406e-998d-d3c777a0d66a	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
c3f6b809-0166-40d6-8dae-9e62b9fd8baa	dae9be5f-69f8-4aba-8707-3974bd4edf02	a6138b49-27ca-485f-ad57-12f6ed08e94b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
d2fe7449-8415-44fa-9c72-3a338aecb101	75bc07bb-6b7a-4414-b064-9f0f7c086217	a6138b49-27ca-485f-ad57-12f6ed08e94b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
531b075f-5d2e-4904-be17-c85368271801	4742c248-e7ae-4e74-b513-a66f6f86a66f	a6138b49-27ca-485f-ad57-12f6ed08e94b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
69efa3ee-eaff-4a19-a050-6f86877a30d5	c1fbb481-dd2c-4585-9b7c-06d180d77d2d	d05bf38b-f898-4dfc-adcc-dce47a90a1c7	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
2e554518-6283-48eb-a342-1dc092afdb7d	5b316a00-25b2-4fd7-8796-5dbb7f51f948	d05bf38b-f898-4dfc-adcc-dce47a90a1c7	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e0e39b2c-e274-47b1-abd0-317f21151f04	7e2a2c9f-ceee-43a9-8c22-b0e99af67bf0	1fc5df4c-5ca6-44aa-b3ab-fb93987f7b9b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
068109ac-5371-4176-9ddb-5f84142f1b67	f270fd28-1c02-46bf-ac9c-8179ed1185bb	1fc5df4c-5ca6-44aa-b3ab-fb93987f7b9b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
27563af8-daa2-4a4a-8869-557f9c959f7e	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	fc57deea-20e3-4959-bb07-ce80c36b7a8c	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
3e625550-4c48-4a8f-88ad-f43d9c60f656	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	1a88ebc2-fa9e-4566-9043-3904425b19ea	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
f970d761-7398-4a49-a599-4aec7a52e780	1543db57-9c36-4a03-b917-401ada53eb22	bd9d47bf-0c6a-41ef-8fa7-9924e9cc868d	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
bb609d47-0b7f-460b-8f55-40ed62b2882a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	bd9d47bf-0c6a-41ef-8fa7-9924e9cc868d	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
4e02b862-74a4-47b2-b57c-52345bdb3e47	d99d51b7-3349-4bf6-8803-618705c95d2d	3e284f6f-181a-4fee-9eaa-89cc745094aa	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
5abe0e76-8b64-4933-9fae-4232152ca46c	b651ec49-f0b6-40b6-87b9-af90f919e1c0	f270fd28-1c02-46bf-ac9c-8179ed1185bb	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
48cb9eb9-58d0-4201-ac74-f94a6f2a1d96	704659f3-e212-472b-951d-80c1d942b506	f270fd28-1c02-46bf-ac9c-8179ed1185bb	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
d65b883c-557f-4e20-8ae9-0aba29123e5c	7ac0b7d7-3b98-4439-89e7-79026ae3b3ad	f270fd28-1c02-46bf-ac9c-8179ed1185bb	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
fb7e8ef0-9abc-4eb1-9524-2fdf425867e4	631da6d3-9081-4d4d-8f17-98f6f1e128c4	f270fd28-1c02-46bf-ac9c-8179ed1185bb	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
c10948f3-deb7-4346-b3c6-e9199b48a6c3	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c2a418bd-aae3-479b-8d28-dc4a3fafb5e4	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
aa48174a-9f94-4ead-b85f-65bf3b889a20	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	d751f28d-f47d-4486-8ff8-94358cdf53f7	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ac4e7ebd-085b-440d-ae29-8524eb1dadb5	704659f3-e212-472b-951d-80c1d942b506	631da6d3-9081-4d4d-8f17-98f6f1e128c4	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
23240016-2c88-4764-b7d4-19e70dedfd12	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	631da6d3-9081-4d4d-8f17-98f6f1e128c4	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e8eaac98-acb6-4e1b-94ea-a7ee096ef11a	28058267-5877-4bc2-a880-395176bd6b22	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
85166d00-5c82-4e07-a29c-d5de71f71214	dae9be5f-69f8-4aba-8707-3974bd4edf02	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
0f0b2bcf-b581-4ef4-9acc-671dc5cf7259	fb06de97-b722-4281-99cf-482d421bd4b0	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
50053475-cb76-46f6-80e6-c574726e4258	a6138b49-27ca-485f-ad57-12f6ed08e94b	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
589af6d3-8a29-456c-b03c-d498c0933207	3a3e0676-66e8-487f-8eba-e64eefe2bf2f	39144bf1-9a12-4d6d-a814-b769473d158f	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8a814ad0-fe4e-4fac-a785-ad3e95eab4e8	e93e5575-697d-4814-bc66-66b6d5d08f2d	39144bf1-9a12-4d6d-a814-b769473d158f	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
9c1a19a5-dcbf-4c3e-b365-00238d7b7da1	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	9c575b13-2b96-4e73-8ae6-21267b4cf871	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ff942f7d-41a5-415f-bbb8-f1331f89bad8	c1667389-c459-4ecc-a759-cd2b0d69d687	9c575b13-2b96-4e73-8ae6-21267b4cf871	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
6a3af9bb-d7a8-435d-bc68-8ffb50bcd0e9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	e93e5575-697d-4814-bc66-66b6d5d08f2d	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
81af3ba8-cf23-418a-abdf-9552d2a18771	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
b2f6b932-da56-45d1-b5e9-d4820130d794	ff42b26e-122c-4b16-b896-f06c990c2c01	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
a70bea94-f625-4b7e-9a1f-eefcb867c652	f270fd28-1c02-46bf-ac9c-8179ed1185bb	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
7e2f8151-7fb5-492d-b645-e632a0dafa26	c2a418bd-aae3-479b-8d28-dc4a3fafb5e4	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
9bbd2916-32fe-49f0-a6b1-056de5e7882b	d2feda35-cf48-4d50-9db4-5d5cab9a96bd	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
19fa6dd6-2c82-4d25-9cdc-7f031bc92fee	4f5a91b8-5ae2-4451-8595-e30b2f37474e	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
0fa72a22-1a12-4834-bfa3-f0fe19a6d17a	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	0134d7aa-9f38-4e9c-a172-f94415e1beb2	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
fe7406e4-6b84-4ce2-afcd-46376f8f1b88	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	cdfe543c-a78e-4dbc-ba5b-f3a8e6aaf43a	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
b1214c56-7b43-41ba-bed0-a8d6d5652a9e	1a88ebc2-fa9e-4566-9043-3904425b19ea	cdfe543c-a78e-4dbc-ba5b-f3a8e6aaf43a	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
921dbb02-da04-429a-9c34-ee7c36162b93	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	6ffb9390-3177-4546-993c-4b4b225bad8e	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ee0ba861-0b1b-410c-8919-fd8f291a908d	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	4c850cce-3170-46ea-9669-f891b4bad0da	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
94e9a379-a63c-4f07-bcb1-25626fd4a1a5	dae9be5f-69f8-4aba-8707-3974bd4edf02	5ed7695e-c900-4690-ab29-d4ecbc00d945	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
2ab7b607-14fb-4fb5-b9b1-e62ae169ff2b	4742c248-e7ae-4e74-b513-a66f6f86a66f	5ed7695e-c900-4690-ab29-d4ecbc00d945	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
0f1e38c3-5850-4474-bf6c-917233be476c	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	d98e1f37-38da-41b7-9ad1-9301b0fc0b50	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
40623d26-bfd7-4761-95ff-4ec7ddb63a90	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	62ee5b22-cd13-4cb1-bdcf-f2976f9328fd	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
2af6c315-e066-4b0e-818f-c79c3b63a0b8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	fcf287b3-077c-40fd-8f4f-50ddf266fd4a	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
095563b3-3fdd-4cb1-90a3-f4a4bf0a0c70	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	7258a2ce-894f-4ce1-a260-84a7452f4d22	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
6fac018f-c1d3-49e9-8c94-d5a0e66045bf	d15bfb61-8af0-49af-af82-24696cd922a9	7258a2ce-894f-4ce1-a260-84a7452f4d22	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
6787c5af-96e3-4e59-a5df-f38f9e736c39	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	7258a2ce-894f-4ce1-a260-84a7452f4d22	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e38c5902-cd38-47ae-be80-e2dceee03a61	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	1ce7f618-ad5a-4831-8ab7-941266b34f24	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
6849cd8c-9d57-4498-b116-244b0c0c71fa	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	6928567c-2b25-4834-8ebf-27800deb240e	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
2db80a91-9497-47bc-a2b1-7be9a8841d54	63b91840-aeb7-4558-a952-9e23e7217c1c	6928567c-2b25-4834-8ebf-27800deb240e	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8ca40379-4596-4762-a8be-72f074c58d8f	8e7e993f-54f9-40d5-8bea-ae16768cbe27	b0457fb7-5638-4a0f-bbc2-688005ef2ae5	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
6be799f7-2ca2-4b2f-af7f-033a062cc2cc	c662510d-a483-4da8-b9c4-96f2bb450a40	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
d3d24b3a-ee79-42f4-9d61-cc06a3b6ed91	dae9be5f-69f8-4aba-8707-3974bd4edf02	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
05659ee5-4e30-44c8-851d-0b329edf97c0	ac2d044e-0c82-4e7c-bc7f-2781191a1148	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
5ba14044-9b3d-47b8-aed9-3ec619615629	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
3888f0ad-c25b-444f-ae40-bb07030fd25d	a6138b49-27ca-485f-ad57-12f6ed08e94b	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
6f4c8451-45e8-40fb-af42-d487878e0cec	2ddcfb31-7ace-442b-9cf9-eb1966e09627	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ebaf8851-1204-4e45-a7fc-64421672a31a	87b40694-4414-4841-925a-176a00c7826a	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
603b1f7c-1170-4664-8d20-4dbd07f8961e	4742c248-e7ae-4e74-b513-a66f6f86a66f	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
1c8e5200-248c-49c0-b01c-c347c29fec43	c1667389-c459-4ecc-a759-cd2b0d69d687	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
cd480b8a-7855-4c0e-abb4-0e309ca20aa3	0da6fe92-db44-40da-854c-a84be86ab8d4	3970a38d-c005-44fe-9b79-e89b7b8a5ea5	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ee921308-53e0-4602-8551-34cbed9b671a	d99d51b7-3349-4bf6-8803-618705c95d2d	e617cb11-6363-43d1-8754-b0aa2d004810	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ef80cb4b-7ae7-4cb1-8076-311f729e2c3f	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	5b277fc8-1da0-4867-beae-f6a8e72f490e	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
f0e39130-b341-4834-b854-25285710e8b0	728cb098-b1db-410e-94a4-d08a630d8076	b720f98f-9a0c-43e7-958b-9855a27a7c71	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
0f96223f-05bd-482f-b05b-e336c2d05123	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	16c03ecc-7936-4614-b272-58cfb2288da8	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
54a7c189-5ec2-4d83-be2e-4e0bbd6b62af	39144bf1-9a12-4d6d-a814-b769473d158f	66b771c6-9028-44eb-83e5-1ae8d757688d	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
50417bd6-382e-48ca-8b7c-2a5b23b17507	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	b7068e6f-0513-47a6-82d5-a67333d69e31	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
22769f8e-27d2-4975-98b1-49d77b5357d5	c1667389-c459-4ecc-a759-cd2b0d69d687	8b4f4e5f-3cf7-4790-ad3b-90f52d6c381b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
5a333600-f3ce-4b00-87b3-2359552346b2	5b316a00-25b2-4fd7-8796-5dbb7f51f948	1b4707dd-eaff-4276-8e8e-2c25fccd068d	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
bd4c7d75-e2f4-4fb9-8333-984bd07f4b78	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	1b4707dd-eaff-4276-8e8e-2c25fccd068d	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e17e5fc6-e622-48f1-aa90-85ea595d591f	d05bf38b-f898-4dfc-adcc-dce47a90a1c7	1b4707dd-eaff-4276-8e8e-2c25fccd068d	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
74dda249-4587-43f5-bdc4-edc25ce34284	75bc07bb-6b7a-4414-b064-9f0f7c086217	ad927edf-b643-49c7-bb35-ce93c40e25f9	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
70588bab-4dab-433f-9318-8430d8137542	45f81bc7-ff24-498d-9104-18da7e5643f8	ad927edf-b643-49c7-bb35-ce93c40e25f9	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
6dc62675-21f3-4026-9591-3a080464ac99	dae9be5f-69f8-4aba-8707-3974bd4edf02	87b40694-4414-4841-925a-176a00c7826a	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
7b04862f-4a36-40b0-a915-0d0ce47ceffe	75bc07bb-6b7a-4414-b064-9f0f7c086217	87b40694-4414-4841-925a-176a00c7826a	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
418993d9-6899-4f7b-abce-5727f9971fbc	a6138b49-27ca-485f-ad57-12f6ed08e94b	87b40694-4414-4841-925a-176a00c7826a	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
d9a5788a-e0ee-4400-9457-f7b1a08b126d	4742c248-e7ae-4e74-b513-a66f6f86a66f	87b40694-4414-4841-925a-176a00c7826a	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
dcfcb396-4c97-46e0-bf5d-4b260e0dbc16	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	b3aa0f67-975e-4e8e-a7e5-8f82817802cd	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
63e88045-9ee4-4fdf-8d75-ce08d63398ff	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	b3aa0f67-975e-4e8e-a7e5-8f82817802cd	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8c51de0c-cea6-42f2-83e4-71738d4c5c7e	a9a3eae9-470b-4e07-ac58-37a0d62d0ada	6781d49e-0a52-407a-bbd9-57152fa52741	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
5d08f27e-7b05-4048-b249-258423fb6464	0da6fe92-db44-40da-854c-a84be86ab8d4	6781d49e-0a52-407a-bbd9-57152fa52741	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
484637d1-4d61-4ae8-87c0-ad6416ab2311	a6138b49-27ca-485f-ad57-12f6ed08e94b	6781d49e-0a52-407a-bbd9-57152fa52741	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
995c9487-656b-4bf6-ab20-9c39e6fccad8	e1d0121d-7fc5-424b-860e-065f92776ca1	6781d49e-0a52-407a-bbd9-57152fa52741	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
9f188deb-4f06-4ab8-8120-58d9461e2a8a	82897173-7157-4508-9557-9e6700c0dc4d	6781d49e-0a52-407a-bbd9-57152fa52741	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
235235e4-02b9-4c2f-b9f2-ee4076fda6ef	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	05f1ea88-de99-48ad-b7cc-38ed173ba5f6	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
2297e1ca-35ef-4f4d-8240-d8aca31cd0d3	7258a2ce-894f-4ce1-a260-84a7452f4d22	05f1ea88-de99-48ad-b7cc-38ed173ba5f6	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e9d67d4d-1732-4a9e-b043-7d7efd204b2d	d99d51b7-3349-4bf6-8803-618705c95d2d	f578ba4f-f883-4dd2-b920-6614af947bd4	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
55d0839a-bb3e-4a8c-be04-fa216fd1476d	ff42b26e-122c-4b16-b896-f06c990c2c01	f578ba4f-f883-4dd2-b920-6614af947bd4	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
a10a3483-d441-4aca-8f84-f541cb196142	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	f578ba4f-f883-4dd2-b920-6614af947bd4	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
77a0ec17-3161-41df-afc3-c8c19111c9fe	728cb098-b1db-410e-94a4-d08a630d8076	04383a3e-b5cf-4875-99a7-fdd746e9cab0	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
bef76ccd-f2c3-4eb8-9c89-b435f005cfcb	75bc07bb-6b7a-4414-b064-9f0f7c086217	04383a3e-b5cf-4875-99a7-fdd746e9cab0	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
19269cc8-a120-4b9a-b717-6011b9390baa	45f81bc7-ff24-498d-9104-18da7e5643f8	04383a3e-b5cf-4875-99a7-fdd746e9cab0	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
97e15bbe-3611-42bd-ba6c-e25932c154c0	0da6fe92-db44-40da-854c-a84be86ab8d4	04383a3e-b5cf-4875-99a7-fdd746e9cab0	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
d49484b6-478c-44c7-9a56-f1b520bcab82	ad927edf-b643-49c7-bb35-ce93c40e25f9	04383a3e-b5cf-4875-99a7-fdd746e9cab0	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
138a26a7-cea3-41d9-92a3-0cac16d6120e	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	04383a3e-b5cf-4875-99a7-fdd746e9cab0	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
769de231-680c-4048-a218-7253975198f2	dae9be5f-69f8-4aba-8707-3974bd4edf02	04c83856-9ff0-475a-b2cd-db05406b84a3	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8fca48bc-3ce4-4f7e-a81a-094cb6e97d2f	0da6fe92-db44-40da-854c-a84be86ab8d4	04c83856-9ff0-475a-b2cd-db05406b84a3	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8af4b0a2-c653-48df-8fd4-f795a91d1738	a6138b49-27ca-485f-ad57-12f6ed08e94b	04c83856-9ff0-475a-b2cd-db05406b84a3	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e7d2396e-200b-4f24-8dc3-7e138ebc9fdb	4742c248-e7ae-4e74-b513-a66f6f86a66f	04c83856-9ff0-475a-b2cd-db05406b84a3	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
d5151715-ee1b-4282-85a5-43f54933c3a7	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	48d1c50e-0ed4-4355-8b30-37ed358badcc	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8d0952bc-20aa-431f-a92f-573b55ea6c13	75bc07bb-6b7a-4414-b064-9f0f7c086217	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
73c2a03d-3b23-4bf4-9e7d-878f2731ac3a	a6138b49-27ca-485f-ad57-12f6ed08e94b	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
74ded9e3-6778-4bf8-8664-00fbe66f3aea	4742c248-e7ae-4e74-b513-a66f6f86a66f	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
b9c6800e-18a8-45bc-aa31-56fd921edfb5	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	a2e3eb4f-c4e3-4f3c-bfdd-2ca2c6f4b9ed	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
f36cb586-ff99-400e-9ec5-8ae027ff4d10	b6fefa89-914a-4a89-bda8-e03a77dfbba2	55343256-1601-423a-b1a4-3d467d2b64c6	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
04bf46d6-5b7d-45b1-adb7-20b2b54822d9	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	691a7808-92eb-4fce-a618-d51867429491	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
51f2ffcd-e168-4abb-b5ef-3a587a22dfad	7258a2ce-894f-4ce1-a260-84a7452f4d22	691a7808-92eb-4fce-a618-d51867429491	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
4c2a4979-50aa-47fe-aa86-8829ac9ff078	5846ade9-c2a3-4042-b036-4a0e3e88a907	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
cd37c85a-b258-447c-803d-d79be8bef55f	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
297a1c39-7f8d-47ee-a13a-3d758d57e633	5e27148a-c486-4282-9cc5-7ec352cd411b	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
190f4d27-5755-48c8-aea1-b1f98e1e9c4e	3d328497-971a-4cca-b0e6-6d959503bac0	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e857cead-5f24-4bcf-b401-0974a7277bc8	e471db4b-ef29-4670-9730-3101f90741ab	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
4b572d2d-1923-4342-8d9d-8f2e9312c428	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
f61387ef-2787-43ec-8c6d-49bf1150f51f	5e837acd-dae2-4186-b57c-ae70ee945f8a	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
70a76fbb-f46f-47ff-93f2-a29545191e4d	19ab8ef6-2d97-43c6-9b8d-d8763bab7242	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e50c90de-eee9-4fed-a883-7588c1d31e1a	78587ca2-7caf-4b23-a0b0-16abff115c30	07ee028a-1e71-400d-a185-39dc4299803c	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
5a59249b-4306-42c9-a988-e91b622d7593	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	07ee028a-1e71-400d-a185-39dc4299803c	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
dc5b2918-79b6-49bb-9ac3-b9bca4d8209a	19ab8ef6-2d97-43c6-9b8d-d8763bab7242	07ee028a-1e71-400d-a185-39dc4299803c	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e5b7874a-fc6a-487a-994c-c2356ec29b30	dae9be5f-69f8-4aba-8707-3974bd4edf02	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
4f7a335c-6392-485b-8899-f782d9905bf5	75bc07bb-6b7a-4414-b064-9f0f7c086217	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
3cf39903-76fa-4811-83d6-21f2dbf4b8ea	a6138b49-27ca-485f-ad57-12f6ed08e94b	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
22057b97-58ec-4dda-9216-a1ffe6c2acd7	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
f415a1e8-72cc-491a-abe9-34d8c0b47da6	4742c248-e7ae-4e74-b513-a66f6f86a66f	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
453936b9-999e-445c-aed9-b93ab1d4b740	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	b9325221-963e-4909-8a81-6d00f3b1e7e6	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
a0a255a2-cc43-44cd-bf46-d216e2640907	45aa8b28-c678-4e4a-9352-27ab690df852	317cf77d-0e89-49b2-82f0-b20073914c0c	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
81938edf-1743-423f-83a4-363700067fab	45f81bc7-ff24-498d-9104-18da7e5643f8	317cf77d-0e89-49b2-82f0-b20073914c0c	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
efa1b2e3-f285-4251-bca9-59a33cd745d8	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	317cf77d-0e89-49b2-82f0-b20073914c0c	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
7315cf33-5c02-4708-b53f-eb9f572f0333	7258a2ce-894f-4ce1-a260-84a7452f4d22	317cf77d-0e89-49b2-82f0-b20073914c0c	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
a84786d8-6128-41b6-8530-75eb2168df61	dae9be5f-69f8-4aba-8707-3974bd4edf02	4742c248-e7ae-4e74-b513-a66f6f86a66f	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
70721daf-3f05-4530-94c2-009197eefba8	75bc07bb-6b7a-4414-b064-9f0f7c086217	4742c248-e7ae-4e74-b513-a66f6f86a66f	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
47f3e957-dafb-46dc-851c-97024d607bc6	691a7808-92eb-4fce-a618-d51867429491	86304602-3f40-481d-9a36-9a61a6289bf6	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
68b44120-97ec-44db-905c-ead3f822b42a	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
33b216cf-b3eb-4550-b2ad-56a66970a889	9c575b13-2b96-4e73-8ae6-21267b4cf871	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
9cf43025-cb3b-40e3-808a-5279deda68cc	7258a2ce-894f-4ce1-a260-84a7452f4d22	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8dfcf15b-1dfc-40e6-b3dc-32b52c3ce8e7	8b4f4e5f-3cf7-4790-ad3b-90f52d6c381b	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
3c2b7f65-ad35-484d-a9ff-6ce343788e03	a7d7d2b7-8389-4a67-91e3-7aaf6940bf49	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
c45b0a88-4b3d-4be6-b1c0-82e64749a940	5e27148a-c486-4282-9cc5-7ec352cd411b	19ab8ef6-2d97-43c6-9b8d-d8763bab7242	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
20f108f0-6210-49db-b456-0ffd0ca6eb47	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	19ab8ef6-2d97-43c6-9b8d-d8763bab7242	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
f8f0c697-e995-4e52-9344-f01a5c6576ea	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	19ab8ef6-2d97-43c6-9b8d-d8763bab7242	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
2a3f2bb7-6dd4-47b1-a2f1-435c2461f800	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	8a5b931e-b073-4af9-a916-4b214183a825	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
7470939d-931f-42de-94cb-666954d689c4	f270fd28-1c02-46bf-ac9c-8179ed1185bb	f3a78141-9a77-4b27-998d-d2b4d366e088	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
c51b9a9f-34a5-4992-b0e2-6f81869b9a27	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	679443db-8000-4a0b-9fda-92d3e021a062	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
0c9850e7-69af-40bd-a069-209798c6634e	a2e3eb4f-c4e3-4f3c-bfdd-2ca2c6f4b9ed	679443db-8000-4a0b-9fda-92d3e021a062	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
4e41f88b-95b0-4328-9b99-323cb29e7427	c17ad9e2-f932-4dd7-950a-2bb25a9b0772	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
958be0d7-b104-4353-a3fa-c66bd56731f4	8afbe459-f864-4ad6-98b5-595ac422f0ef	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
2700302a-8493-4261-b92c-a73504b2a0aa	b651ec49-f0b6-40b6-87b9-af90f919e1c0	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
bb197391-6d50-4b2f-862a-f94d81df5076	704659f3-e212-472b-951d-80c1d942b506	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
cc16ebc5-30c1-41f2-9e1e-e838bfe3f4a3	9079e6fb-d198-4c34-a483-39df60af375b	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
3f7262e4-d64f-4e76-9e93-36162ba859b7	1595e4da-60d8-4646-8dcc-c761e435937e	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
6c19189c-f2de-4d35-97bf-09c086787703	f270fd28-1c02-46bf-ac9c-8179ed1185bb	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
b7fe95d7-8b14-4fee-b231-469efcc62af8	61b3566e-f3e2-4116-824b-0be7e6d5f9b8	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
78d68575-0b66-4cee-a4fe-3a3081bef365	631da6d3-9081-4d4d-8f17-98f6f1e128c4	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
6a1a23ea-ffe7-4fa2-8feb-6c441960e3a8	f3a78141-9a77-4b27-998d-d2b4d366e088	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
84614c8b-2049-4cb8-a555-c839fb7b4da9	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	109a4ba1-3456-4dcc-bc80-8f2bdd904da1	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
88627ab7-2210-49e9-8777-18be482738f2	012e0de3-ba65-4fd4-9a9a-f127d09672aa	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
9ab4b939-a1d0-4da8-af24-c3249897c26a	3e969c04-e8bf-4376-a556-2a039627e19f	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
4ce91e39-e55b-4d56-85a2-2d16bc6ce55a	5e27148a-c486-4282-9cc5-7ec352cd411b	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
134c7e7a-3761-4200-80ff-17eb5fc0048a	5efc6baa-40ff-406f-aab6-3cd7e48a7f26	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
d215bac1-4b96-43b3-952b-edd8198c0f6d	38735eef-62f6-418b-a02d-14bc0f491031	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
c7f2b3e7-ac6e-4883-9493-3a48e82b12ce	339b8bf1-7cb8-4726-9ccd-f76faf83482d	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
1818ce64-63e3-48af-a78f-9111b68a0578	76437582-061c-4b94-9873-a4e3b6b8c787	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
7f12f700-8110-46fa-9bee-7205983918e5	78587ca2-7caf-4b23-a0b0-16abff115c30	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
0b7fd367-52ee-47ad-af30-61bd3a50fe97	44a938f5-b9c0-4e10-aab1-bbabd979710e	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
14927cd1-5131-4def-8d52-5cc70d91a5ba	c6872d71-bd61-4a1a-bcdb-ba79f37b1283	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
663f67ae-6f07-48a0-b9d7-6e65f52bced4	fb06de97-b722-4281-99cf-482d421bd4b0	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
f00be9bf-6cf6-4785-b207-0ac39f2951d1	4bd2dff5-6f63-4ad3-a9ee-61219df00045	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
d26df63a-e1a4-4810-bc86-52cec3c1c1ea	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
4ad6ef65-b46d-4023-ac28-ec813846aecf	8b9c80e4-3072-4dab-85a6-36e310fae6ef	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e4bc8a0b-55af-4ed3-9f17-6596ee862afc	0da6fe92-db44-40da-854c-a84be86ab8d4	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8edc7161-5366-49ff-a33c-ce32123d9f6e	29a63532-c5b1-4ebb-bba4-9a22abdd986c	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8b6e2166-6191-44f2-8379-00423189e4b8	f2c5ae55-0e05-4127-b286-efc6fb88b4a1	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
4f442f51-0a32-43f2-b30a-720b1cdd2214	7a19a677-5c7e-4efa-99aa-2d7a536f4ba9	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
592e589b-d418-4460-809c-c140f434aa45	9c575b13-2b96-4e73-8ae6-21267b4cf871	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
84ea3819-88f7-476a-a8b5-7638a23bc672	e93e5575-697d-4814-bc66-66b6d5d08f2d	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
ce6e9685-b1d0-46d2-850a-6965cf3f4ed9	0134d7aa-9f38-4e9c-a172-f94415e1beb2	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
cca7d0e4-a017-4556-a85f-91e45db58c22	c2a554a7-8f5e-4f75-a4cb-115cb59a4f75	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
f044bfdd-f4ec-486c-878d-10f597afa896	04ed257c-7497-4592-8157-d7526ebdbfcb	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
089d2cf9-5642-4de0-8df9-09e6e29d4e56	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
8cfb67db-12f8-46de-8cd9-2ed83b23b7bc	97839cd4-0327-4209-b3a0-09744b78c944	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
b7e9f3ef-0077-4eae-8741-8e8be930f72b	ad927edf-b643-49c7-bb35-ce93c40e25f9	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
685c4088-e6f9-4099-ad40-932e3d42df9d	20115650-29ba-44fa-9861-99c990caa5b1	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
e2d0b030-0810-4b1d-9c0d-e89e10606441	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
4edea1e1-7070-4479-a785-908d80d3266a	0e243923-c4e6-4bf0-ae19-c0a5545f33c4	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
18329aa2-3650-4f36-8d63-771a879871a7	691a7808-92eb-4fce-a618-d51867429491	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
a07694a4-1c9c-40cb-a36b-5bd4a1c3b150	48a7ded3-0e70-425b-b587-8139188fb234	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
dc13275c-6dab-4c4d-bba7-7d905a3d6b51	c1667389-c459-4ecc-a759-cd2b0d69d687	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
f34f903d-f6fb-46ff-9cbe-b28c487aaf74	7de32a97-e650-4e19-87e8-0040927e6844	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	approved	2025-02-19 05:13:00.567	2025-02-19 08:13:04.465
\.


--
-- Data for Name: post; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.post (id, is_ad, ad_fee_balance, ad_issuer_id, ad_attribute, ad_link, author_id, owner_id, content, value, media_urls, up_vote_ids, down_vote_ids, created_at, updated_at) FROM stdin;
ccbdbf37-e018-4b83-95eb-7b577d708b80	f	\N	\N	\N	\N	3e969c04-e8bf-4376-a556-2a039627e19f	3e969c04-e8bf-4376-a556-2a039627e19f	hi	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/fe4118d6-34af-4000-b358-c9f6b0cab53c.jpg}	{}	{}	2023-11-13 02:13:56	2023-11-13 02:13:56
d455f395-edd8-4c89-8618-6cc9f272fdff	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	GLF 방문. 	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/ec9ed4b4-e244-4cad-9117-8d926be5d99c.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9358dc6b-1d63-4931-8a8f-81af47a7f71d.jpg}	{}	{}	2024-10-28 21:53:48	2024-10-28 21:53:48
1055c220-6e81-49aa-8a74-ae952ebc17ac	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	미동부 뉴욕주 GLF 방문.프로다오 & 로드스타 MOU 체결	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/f30a36cb-d2b6-4f7a-bc45-22f51cc2dc12.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/99ba7313-8405-4fea-8d96-a4ffc2bb6916.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/14cbd02b-aeaf-49bc-b540-0d6e31c8c87b.jpg}	{}	{}	2024-10-28 21:53:49	2024-10-28 21:53:49
4a8ae486-d880-48e6-a631-aca996a7f666	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	프로다오 & 로드스타 LOI	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/ead6cf18-cdbc-48a7-ae30-76f4052ddbcf.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6946223f-e825-44a9-bc4a-196654eb1d5c.jpg}	{}	{}	2024-10-30 22:02:12	2024-10-30 22:02:12
6b48db09-a9d0-4df6-bd46-e13998b4573e	f	\N	\N	\N	\N	8a5b931e-b073-4af9-a916-4b214183a825	8a5b931e-b073-4af9-a916-4b214183a825	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/5991ce39-ae5d-4739-956c-d88f4b733935.jpg}	{}	{}	2024-12-19 10:33:11	2024-12-19 10:33:11
202ceaa9-6bd9-4f72-b880-4a65366c3055	f	\N	\N	\N	\N	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d424e9bc-d20b-4ca6-bba2-8adcee3d37f8.jpg}	{}	{}	2023-11-24 04:13:20	2023-11-24 04:13:20
4691776a-b3c5-464e-bf44-5c9bbff448d6	f	\N	\N	\N	\N	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/35445d8a-5d9a-42fa-b01c-1a446a8156a6.jpg}	{}	{}	2023-11-24 04:14:14	2023-11-24 04:14:14
c75e1cf4-dc65-49a1-a2ee-363e0bc60453	f	\N	\N	\N	\N	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d1183a5a-ee21-44f6-8ae9-a3495b4ad76e.jpg}	{}	{}	2023-11-24 04:14:39	2023-11-24 04:14:39
23015ab0-143c-4138-aeab-a7311d2a500c	f	\N	\N	\N	\N	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/45d6cdbe-3492-42db-89b8-625d024c158d.jpg}	{}	{}	2023-11-24 04:15:09	2023-11-24 04:15:09
b59bd9e5-eade-4298-b923-a55d80f6ebe8	f	\N	\N	\N	\N	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/373fed56-3ab2-4907-a5dd-6eb766a2b5c0.jpg}	{}	{}	2023-11-24 04:15:50	2023-11-24 04:15:50
0d37185b-7ccb-4e98-a58a-6f7b9d3ee661	f	\N	\N	\N	\N	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d225ba7b-8b59-48d4-9da3-178315f2861b.jpg}	{}	{}	2023-11-24 04:16:08	2023-11-24 04:16:08
258f46cf-f3ea-4a6a-9416-4dd299489d98	f	\N	\N	\N	\N	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/646ddb0f-ca2d-4e4b-b151-a6a6e1cf48e2.jpg}	{}	{}	2023-11-24 04:19:57	2023-11-24 04:19:57
456da8b0-6946-4647-86e3-8da2c57aa862	f	\N	\N	\N	\N	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/b5ee9c9f-2a91-4cef-a3e6-3b42023ddbd2.jpg}	{}	{}	2023-11-24 04:20:18	2023-11-24 04:20:18
c980e9f5-cf8d-468e-b720-d72d5c505f0e	f	\N	\N	\N	\N	691a7808-92eb-4fce-a618-d51867429491	691a7808-92eb-4fce-a618-d51867429491	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6643c6a0-deeb-4067-8b53-b2eff753ea8b.jpg}	{}	{}	2023-11-25 05:00:10	2023-11-25 05:00:10
78a9429f-33e4-4cd3-8ae6-21d80c3e09ac	f	\N	\N	\N	\N	3e969c04-e8bf-4376-a556-2a039627e19f	3e969c04-e8bf-4376-a556-2a039627e19f	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d9bdbdca-7b73-464b-83eb-204bc3fa59df.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d9bdbdca-7b73-464b-83eb-204bc3fa59df.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/663f27bc-a2cf-4c7b-a19e-13778781aff2.jpg}	{}	{}	2023-11-27 06:54:22	2023-11-27 06:54:22
f843b33d-f4dc-4f32-9257-40bd3cbd9936	f	\N	\N	\N	\N	3e969c04-e8bf-4376-a556-2a039627e19f	3e969c04-e8bf-4376-a556-2a039627e19f	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/695ed31c-9ac8-4e0d-87d0-86a0d0a91d36.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/695ed31c-9ac8-4e0d-87d0-86a0d0a91d36.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/cfe88b79-2964-494a-8705-a2210a5b1688.jpg}	{}	{}	2023-11-27 06:54:22	2023-11-27 06:54:22
95ee9547-6615-4898-a160-e12f7c3c663e	f	\N	\N	\N	\N	3e969c04-e8bf-4376-a556-2a039627e19f	3e969c04-e8bf-4376-a556-2a039627e19f	사진테스트	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/adfed3eb-fd28-4d1a-a179-efb1b132c0a5.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6220d00f-9bfe-477a-adad-d617615f892d.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/1f39a0a7-0f84-42ac-9ee0-330c62557d10.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c8552547-f164-46d8-a32b-87f2d56a1e8f.jpg}	{}	{}	2023-11-27 06:55:58	2023-11-27 06:55:58
5eb4b13e-6ed5-44b7-9557-71c0f7b5aee7	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/4afb1636-1195-443d-9477-6a197d476519.jpg}	{}	{}	2023-11-27 09:05:36	2023-11-27 09:05:36
71880a93-7105-4a83-8762-a1f666df716a	f	\N	\N	\N	\N	3e969c04-e8bf-4376-a556-2a039627e19f	3e969c04-e8bf-4376-a556-2a039627e19f	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/43429688-6b2a-413c-bc8d-e70d0ec5611d.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/2d56d088-443b-4f35-9f0b-ef53370d0259.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/4cd4ffa5-0634-4015-ac0e-85d5a1b20bf4.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6a3df040-57ce-42d0-b0fb-129da3679c59.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/43429688-6b2a-413c-bc8d-e70d0ec5611d.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/43429688-6b2a-413c-bc8d-e70d0ec5611d.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/43429688-6b2a-413c-bc8d-e70d0ec5611d.jpg}	{}	{}	2023-11-27 06:57:20	2023-11-27 06:57:20
90da3bc1-d408-4476-9637-3c6b8491a816	f	\N	\N	\N	\N	82de6c86-64f8-4b2f-afb3-ad42f3064102	82de6c86-64f8-4b2f-afb3-ad42f3064102	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/64021557-e855-4e12-9bd2-d939e5c1d9fc.jpg}	{}	{}	2023-11-28 01:31:04	2023-11-28 01:31:04
400b9b8c-ed64-4608-9eea-0b692febaa81	f	\N	\N	\N	\N	82de6c86-64f8-4b2f-afb3-ad42f3064102	82de6c86-64f8-4b2f-afb3-ad42f3064102	\N	0	{https://youtu.be/cBfp82GB6sg?si=L9x-35cWHY0wgDQ5}	{}	{}	2023-11-28 01:32:01	2023-11-28 01:32:01
eb39ec53-3dcc-4910-b317-5c695b623bde	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	남서울대학교 방문	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/47d69812-ea2b-4a9c-b249-13b26a230f10.jpg}	{}	{}	2023-11-28 03:36:48	2023-11-28 03:36:48
a3f59612-0c9d-41d1-80de-65ad5474ba8a	f	\N	\N	\N	\N	012e0de3-ba65-4fd4-9a9a-f127d09672aa	012e0de3-ba65-4fd4-9a9a-f127d09672aa	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e303be82-60dc-483e-9f04-a5f2a6d2df04.jpg}	{}	{}	2023-11-28 09:17:11	2023-11-28 09:17:11
87c86e8d-2637-4119-ac53-deecf827d8cc	f	\N	\N	\N	\N	012e0de3-ba65-4fd4-9a9a-f127d09672aa	012e0de3-ba65-4fd4-9a9a-f127d09672aa	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d2a5ffeb-9dc3-4573-bf08-2af18160bf5c.jpg}	{}	{}	2023-11-28 09:19:04	2023-11-28 09:19:04
f1663d2d-8c3c-4fd6-bb44-7961e46c9925	f	\N	\N	\N	\N	012e0de3-ba65-4fd4-9a9a-f127d09672aa	012e0de3-ba65-4fd4-9a9a-f127d09672aa	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d68627a4-4e59-4b1e-baa9-d04b6595d9ca.jpg}	{}	{}	2023-11-29 07:23:56	2023-11-29 07:23:56
b6d3b69b-9a86-41fe-84fa-57907bf611bf	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	이화여자대학교 방문	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/37390cf4-5be8-496c-b0c5-b9c9248c8323.jpg}	{}	{}	2023-11-30 01:55:03	2023-11-30 01:55:03
df557ab3-1802-4050-b959-113379e9f7f8	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	이화여자대학교 스벅에서	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c9a0c434-787d-488c-979a-d674f61ad3af.jpg}	{}	{}	2023-11-30 03:23:45	2023-11-30 03:23:45
70843aa7-324c-4f7e-81bf-51e35aedc159	f	\N	\N	\N	\N	f7578885-4640-41c2-9831-c994c131ab57	f7578885-4640-41c2-9831-c994c131ab57	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/547ca4f2-461d-4078-bea9-b5ea7ad75636.jpg}	{}	{}	2023-12-01 03:36:04	2023-12-01 03:36:04
5644a9f9-1574-4de2-9767-d7d01d2fd683	f	\N	\N	\N	\N	48d1c50e-0ed4-4355-8b30-37ed358badcc	48d1c50e-0ed4-4355-8b30-37ed358badcc	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c2e2a688-8daa-46a4-8b65-deedaec3214f.jpg}	{}	{}	2023-12-04 11:18:35	2023-12-04 11:18:35
2e18ff5c-657b-4c15-8c38-f988fe6ad99c	f	\N	\N	\N	\N	48d1c50e-0ed4-4355-8b30-37ed358badcc	48d1c50e-0ed4-4355-8b30-37ed358badcc	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/f64c108b-f9df-481e-ae96-a5c8833107fe.jpg}	{}	{}	2023-12-04 11:19:16	2023-12-04 11:19:16
d732cd9d-c98f-406f-9542-dae372a7163e	f	\N	\N	\N	\N	48d1c50e-0ed4-4355-8b30-37ed358badcc	48d1c50e-0ed4-4355-8b30-37ed358badcc	\N	0	{https://youtu.be/Y2XSH2k4WbE?si=0GDcP-kJMW-JH-HM,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6fd94395-f3a3-492a-b19a-b1d8b9355327.jpg}	{}	{}	2023-12-04 11:21:56	2023-12-04 11:21:56
a9e192be-6b8e-486d-8549-b7ed7acbdc39	f	\N	\N	\N	\N	48d1c50e-0ed4-4355-8b30-37ed358badcc	48d1c50e-0ed4-4355-8b30-37ed358badcc	\N	0	{https://youtu.be/Y2XSH2k4WbE?si=0GDcP-kJMW-JH-HM,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/42c9085c-8a33-462c-8e69-9caeed6fd9a5.jpg}	{}	{}	2023-12-04 11:23:40	2023-12-04 11:23:40
ffdee577-3c55-4f3d-b701-76588a3ee851	f	\N	\N	\N	\N	3e969c04-e8bf-4376-a556-2a039627e19f	3e969c04-e8bf-4376-a556-2a039627e19f	유튜브	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/03685a44-0f0d-4e87-a25f-ae8bb75e65f7.png}	{}	{}	2023-12-05 04:21:26	2023-12-05 04:21:26
d54769b0-1fe7-4265-aa17-38f1ac61ed5a	f	\N	\N	\N	\N	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e6783eb4-0160-491a-a172-498bbe4cb1a2.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/7ccbcc76-1f3a-41fb-8bf4-2e43cd7c76c6.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/80e4889d-ef74-4898-b945-cdcde5284c3c.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/664065ec-24f7-48b8-a3f5-0ca18b938a07.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c22a39e8-b289-4f40-9c4f-b3975d9353bf.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9537f2ba-2e95-4bb2-bb58-5cf97b2bf2f9.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d894a096-29c1-4899-9476-3c7c8667864f.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6660e51c-1372-4043-badd-6f7e549cd78e.jpg}	{}	{}	2023-12-05 10:12:38	2023-12-05 10:12:38
17363fff-10df-4666-a4ba-91cd6c84843f	f	\N	\N	\N	\N	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	6e6d2b1b-8db4-4b5c-8bb7-d170b3587f6b	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c6481018-0cd7-4c5a-99b2-196cf23e2f0b.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/4ccf8085-87ef-4033-86f4-09bbdb017cea.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/7f29f0b0-1e56-48bd-b8e2-c80067d8a6ee.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/ad0d8ecd-9714-4454-924a-505a3f934bbe.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/809cfcae-ca0f-4e81-8d7f-8abcc8283d58.jpg}	{}	{}	2023-12-05 10:24:29	2023-12-05 10:24:29
9ec85239-0e0a-4f5c-8d10-1f319582b15c	f	\N	\N	\N	\N	c1667389-c459-4ecc-a759-cd2b0d69d687	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a46d289d-a7db-4cdf-9b2d-730d9f068f57.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/900f9b95-fe13-410f-98cb-da182b9c334f.jpg}	{}	{}	2023-12-06 07:13:55	2023-12-06 07:13:55
ed2d089e-13e2-4bf7-9cb3-6011010145eb	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	충청북도 블록체인 6주년 혁신컨퍼런스	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/54066df2-f4ec-48e2-a9be-5ccbfb4853a2.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/4f1e2745-f4d4-4225-9a2a-f2b4822fa9e0.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/b070ce76-ec32-442e-948b-ef8480b2d0d5.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/be4b5033-5f39-44bc-a5f9-870f61d7d7ae.jpg}	{}	{}	2023-12-06 07:15:42	2023-12-06 07:15:42
5b358ab8-9d00-4bf6-b23c-f9b8de3f3420	f	\N	\N	\N	\N	c583a589-c6c8-4cfd-9470-d0a445109ef9	c583a589-c6c8-4cfd-9470-d0a445109ef9	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/ff1b1b30-8ff8-49d8-aa5b-bb8d9770ed68.jpg}	{}	{}	2023-12-06 09:52:29	2023-12-06 09:52:29
dfa6543b-b76e-48db-b8bd-362c86a07efd	f	\N	\N	\N	\N	c1667389-c459-4ecc-a759-cd2b0d69d687	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/5d2838f5-5a5a-49e1-baf3-d28c8e8e30b2.jpg}	{}	{}	2023-12-06 13:18:58	2023-12-06 13:18:58
61fb4787-5d76-45f8-8b5c-baea0e263357	f	\N	\N	\N	\N	4bd2dff5-6f63-4ad3-a9ee-61219df00045	4bd2dff5-6f63-4ad3-a9ee-61219df00045	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9fe352f6-9eb3-4a1f-b884-fb11536e9bf3.heic}	{}	{}	2023-12-07 09:21:52	2023-12-07 09:21:52
e29894b5-9b8c-4a31-9fdf-19863f7e873a	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	대한상공회의소 베트남지사	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e068daf1-3987-4a75-a28d-fd41fc8c15c4.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/7362bd32-09fe-4300-ac84-b21d9293173a.jpg}	{}	{}	2023-12-07 09:30:48	2023-12-07 09:30:48
d7ea60fa-7951-40c3-8358-524c3719a9a3	f	\N	\N	\N	\N	4bd2dff5-6f63-4ad3-a9ee-61219df00045	4bd2dff5-6f63-4ad3-a9ee-61219df00045	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d19da33c-0753-455d-855e-f9ec2c45dfa0.heic}	{}	{}	2023-12-07 09:32:19	2023-12-07 09:32:19
c2d92f26-6aaf-4379-ad2c-ca114117e232	f	\N	\N	\N	\N	4bd2dff5-6f63-4ad3-a9ee-61219df00045	4bd2dff5-6f63-4ad3-a9ee-61219df00045	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/8fb14256-7950-4a5c-80d0-28f84c7411cd.heic}	{}	{}	2023-12-07 09:35:05	2023-12-07 09:35:05
fb4cfb26-52f3-42f1-b8d6-e0ad0ea1035d	f	\N	\N	\N	\N	c583a589-c6c8-4cfd-9470-d0a445109ef9	c583a589-c6c8-4cfd-9470-d0a445109ef9	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/02b831d5-d631-42ec-82c9-91524e0dd496.jpg}	{}	{}	2023-12-07 09:39:15	2023-12-07 09:39:15
a12f32fb-cfe8-4c4c-aca5-8a0524daa754	f	\N	\N	\N	\N	c583a589-c6c8-4cfd-9470-d0a445109ef9	c583a589-c6c8-4cfd-9470-d0a445109ef9	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/19066869-4485-4ea8-9e87-4e1fe55a9835.jpg}	{}	{}	2023-12-07 09:39:35	2023-12-07 09:39:35
cafac0eb-1299-44f0-8dcc-bde999dda685	f	\N	\N	\N	\N	c583a589-c6c8-4cfd-9470-d0a445109ef9	c583a589-c6c8-4cfd-9470-d0a445109ef9	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9fd08e33-f1e1-4c0b-a8ab-6a75b5454836.jpg}	{}	{}	2023-12-07 09:40:32	2023-12-07 09:40:32
05e8af8f-244d-430c-b2e5-ec7f51ff8331	f	\N	\N	\N	\N	c583a589-c6c8-4cfd-9470-d0a445109ef9	c583a589-c6c8-4cfd-9470-d0a445109ef9	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/664bb79b-6fa1-49a7-ad6f-4fb536dc1d87.jpg}	{}	{}	2023-12-07 09:41:28	2023-12-07 09:41:28
01b39285-8bdd-443f-9b3e-58099d948506	f	\N	\N	\N	\N	c583a589-c6c8-4cfd-9470-d0a445109ef9	c583a589-c6c8-4cfd-9470-d0a445109ef9	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/49813519-05d7-49d5-9d20-e2e8747da9a3.jpg}	{}	{}	2023-12-07 09:42:13	2023-12-07 09:42:13
a1792984-a278-4bf5-bac3-9885a5fb909c	f	\N	\N	\N	\N	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/5e2eec3f-1ffa-4f65-9301-1a1e9ac6cb7f.jpg}	{}	{}	2023-12-08 03:54:35	2023-12-08 03:54:35
d5420f7a-f9b0-4689-b8f7-b380987b3d35	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	과학기술정보통신부/한국인터넷진흥원2023년 블록체인 수요,공급자 협의체 <ABLE> 제3차 공급기업 발표.	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a09f1e48-9f25-456a-889b-1fcc58af2168.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/5871f093-f9c8-4ea7-9183-bea68153e276.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/611be63e-9578-4727-9f56-dde4a80c2ea2.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6006247e-3c3a-4721-a388-4fa4e0b4c7f2.jpg}	{}	{}	2023-12-08 08:35:11	2023-12-08 08:35:11
7a965c90-7e4e-4603-a858-025cebd571c5	f	\N	\N	\N	\N	c1667389-c459-4ecc-a759-cd2b0d69d687	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/cb258980-9323-438d-8046-7e6ff50ab53b.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/27b98812-fee7-44fe-9137-7e7d6b0e95ec.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/0acf0f33-8fe1-4647-96f6-7b088f81220a.jpg}	{}	{}	2023-12-08 09:19:27	2023-12-08 09:19:27
1e56c370-575e-4613-8c88-42d0e0b5aea1	f	\N	\N	\N	\N	c1667389-c459-4ecc-a759-cd2b0d69d687	c1667389-c459-4ecc-a759-cd2b0d69d687	핑크볼모임 23. 12.9  3시 그곳에 가고싶다.	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/4fe4875d-9dc0-4767-9a72-9b284ecd3586.jpg}	{}	{}	2023-12-09 10:16:34	2023-12-09 10:16:34
1b8715c8-27c3-43a8-8ad9-e2f5f864c21c	f	\N	\N	\N	\N	8b4f4e5f-3cf7-4790-ad3b-90f52d6c381b	8b4f4e5f-3cf7-4790-ad3b-90f52d6c381b	23.12. 3  안성 힌지교체,  유리문수리	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d3fbfd84-ccdb-487b-b827-bc077f45a5bd.jpg}	{}	{}	2023-12-09 10:33:58	2023-12-09 10:33:58
04da7ca7-db3f-4cd6-902a-db70c7c52c61	f	\N	\N	\N	\N	8b4f4e5f-3cf7-4790-ad3b-90f52d6c381b	8b4f4e5f-3cf7-4790-ad3b-90f52d6c381b	23.12.8  청천 수리전 수리후	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/eae4d58d-ca4d-4045-9142-ad8d57cd739a.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/8d9a8929-d3bd-457d-bc1f-28d99325b493.jpg}	{}	{}	2023-12-09 10:37:26	2023-12-09 10:37:26
5190029a-8da1-4232-ba7d-cd354bafd725	f	\N	\N	\N	\N	a1468102-4c03-47f4-a390-cc625f636017	a1468102-4c03-47f4-a390-cc625f636017	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/8c34b61c-edf3-49e4-9bc7-277f31e99b54.jpg}	{}	{}	2023-12-12 10:53:48	2023-12-12 10:53:48
2f23463d-b4b7-4623-8788-1fef189ff8fe	f	\N	\N	\N	\N	a9a3eae9-470b-4e07-ac58-37a0d62d0ada	a9a3eae9-470b-4e07-ac58-37a0d62d0ada	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/652f42bd-e04b-40c8-88f2-21d162eff54e.jpg}	{}	{}	2023-12-13 07:50:11	2023-12-13 07:50:11
050c14d7-3e6e-444c-a2d5-89a4e7d31fbe	f	\N	\N	\N	\N	dab9453b-a30d-44ec-a414-132e953c2408	dab9453b-a30d-44ec-a414-132e953c2408	https://www.youtube.com/live/JzS99HTyQxU?si=n8tlYFBaMlxjMOqY	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/7321c14b-3dd8-4ad4-9138-38ea207bc6e3.png}	{}	{}	2023-12-21 01:59:15	2023-12-21 01:59:15
e5b5e775-1038-474c-87e7-3846f1163a30	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	서울경제인협회 창립10주년	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a9f9be6e-4c36-45e0-ac2a-1d1b48aff7b0.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/dde2af0e-c554-4c70-82a0-7fcea5962d8f.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/083a1ebd-4cf9-44ad-87cc-5559cc2e4c1d.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/40ad7120-05e0-468f-b321-0aa199c671a2.jpg}	{}	{}	2023-12-13 07:58:14	2023-12-13 07:58:14
c910d7a9-a186-4643-9638-a14cad9c8365	f	\N	\N	\N	\N	a9a3eae9-470b-4e07-ac58-37a0d62d0ada	a9a3eae9-470b-4e07-ac58-37a0d62d0ada	\N	0	{https://youtu.be/xwPfoE123JQ?si=m2hiQhskNzylthYe,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/738990e2-f287-458a-993d-93e213058d77.jpg}	{}	{}	2023-12-13 08:03:03	2023-12-13 08:03:03
f8a4776f-cbcc-4958-889e-51391d270a65	f	\N	\N	\N	\N	e703bd05-a781-41ce-82b6-e0221018d631	e703bd05-a781-41ce-82b6-e0221018d631	[2023.12.13 ]서울경제인협회 합창단 공연 더시즈 공연 	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/af70b153-1d15-4c96-a093-8db5d1642921.jpg}	{}	{}	2023-12-13 11:16:44	2023-12-13 11:16:44
460c9071-60e4-4f0a-9d92-c6028041f87c	f	\N	\N	\N	\N	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	ㅁㅁㅁㅁㅁ	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/cb1e761b-5243-41eb-b3fa-cae8761381a3.mp4}	{}	{}	2023-12-22 05:31:05	2023-12-22 05:31:05
8371ddb4-6cb9-4608-ae95-b7cb58936761	f	\N	\N	\N	\N	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/07e38df0-c1dd-4ab4-bc02-59c45f2d1a83.png}	{}	{}	2023-12-22 05:32:43	2023-12-22 05:32:43
c07a1875-e410-4b38-99dc-defc9ca1ab60	f	\N	\N	\N	\N	75bc07bb-6b7a-4414-b064-9f0f7c086217	75bc07bb-6b7a-4414-b064-9f0f7c086217	한강이 보이는 지식산업센터분양 아이에스비즈타워	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c1dc0a54-a376-4904-b5d6-485c86e8b4b5.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/bb522614-15c0-4eee-8876-50d745ca0db0.jpg}	{}	{}	2023-11-23 07:35:27	2023-11-23 07:35:27
e692d1eb-de9a-4a00-869b-f154912db8a1	f	\N	\N	\N	\N	87b40694-4414-4841-925a-176a00c7826a	87b40694-4414-4841-925a-176a00c7826a	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/ec7968a7-50ea-4f29-a0a9-f879c10c9ef5.jpg}	{}	{}	2023-11-23 08:45:13	2023-11-23 08:45:13
77afab56-2442-4a7b-a6c8-0f643860344f	f	\N	\N	\N	\N	4742c248-e7ae-4e74-b513-a66f6f86a66f	4742c248-e7ae-4e74-b513-a66f6f86a66f	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/718bc1f9-b903-4a6e-8c45-c0bfd363657d.jpg}	{}	{}	2023-11-23 08:45:52	2023-11-23 08:45:52
fee8f3a9-8740-4a40-b05a-435c748b4b95	f	\N	\N	\N	\N	a6138b49-27ca-485f-ad57-12f6ed08e94b	a6138b49-27ca-485f-ad57-12f6ed08e94b	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/0b93ad8f-7163-4154-8ef1-62304a91b503.jpg}	{}	{}	2023-11-23 08:46:11	2023-11-23 08:46:11
4ca93d57-2709-41b6-8d2b-d83fa4901dc9	f	\N	\N	\N	\N	4742c248-e7ae-4e74-b513-a66f6f86a66f	4742c248-e7ae-4e74-b513-a66f6f86a66f	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a2a8e622-235b-4dab-ab27-a01f0996b981.jpg}	{}	{}	2023-11-23 08:46:14	2023-11-23 08:46:14
f4b0847f-5f6b-4f3d-accc-a67775997579	f	\N	\N	\N	\N	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/666f4bbd-3cb4-4fbb-91cb-a0bdd137cbe4.jpg}	{}	{}	2023-11-23 08:46:33	2023-11-23 08:46:33
1177ef06-612c-4e4c-a4e2-533a0007314c	f	\N	\N	\N	\N	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	3a219ef4-e0ad-48a8-bcf8-d25e5295aec8	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/ec3befea-d039-4e78-9d0d-ad49507dad45.jpg}	{}	{}	2023-11-23 08:48:17	2023-11-23 08:48:17
e89a3f66-c128-4414-9d84-fdee77ee0dc9	f	\N	\N	\N	\N	a6138b49-27ca-485f-ad57-12f6ed08e94b	a6138b49-27ca-485f-ad57-12f6ed08e94b	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/0eb99106-c9a5-4444-b2cb-584cfbe1af01.jpg}	{}	{}	2023-11-23 08:48:31	2023-11-23 08:48:31
42642155-25ba-4167-a1f9-fd7e68c0d306	f	\N	\N	\N	\N	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	abedc5ad-cf70-4df3-b8e8-1a1448a8546c	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/02d76950-cf67-4e5d-86b6-c1bbce533e11.jpg}	{}	{}	2023-11-23 08:48:50	2023-11-23 08:48:50
205883a0-9a94-42aa-8c75-5b517dfe2384	f	\N	\N	\N	\N	28058267-5877-4bc2-a880-395176bd6b22	28058267-5877-4bc2-a880-395176bd6b22	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9b5a6785-357e-4e76-a445-6d0cc4d3b63f.jpg,https://www.google.com/url?sa=t&source=web&rct=j&opi=89978449&url=https://caravanpark.kr/&ved=2ahUKEwi8irSn3tmCAxWwk1YBHf7bA3UQFnoECAkQAQ&usg=AOvVaw0hAlIwmopzQKPERv-u7CsU}	{}	{}	2023-11-23 08:49:01	2023-11-23 08:49:01
af921796-26b6-4d10-800a-4853b9093fb3	f	\N	\N	\N	\N	5ed7695e-c900-4690-ab29-d4ecbc00d945	5ed7695e-c900-4690-ab29-d4ecbc00d945	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d0f4bc5f-c1b6-46c8-9ebe-11a418047ed7.jpg}	{}	{}	2023-11-23 08:49:11	2023-11-23 08:49:11
6ccb82f6-38ae-4c62-b072-8045cad922dc	f	\N	\N	\N	\N	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a6cb25bf-b766-4860-88e6-df5c976bebd8.jpg}	{}	{}	2023-11-23 08:50:54	2023-11-23 08:50:54
80ea3165-6abd-440d-84d2-bc794e66e087	f	\N	\N	\N	\N	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	ca837bc7-fd9c-4c3f-b3ae-338ea3756bca	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/1b5c5fc7-3db9-47c0-96ec-9372d5b14444.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/f2a31253-54c3-4f1a-8940-72b3ab78d0c1.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/cfa21c3a-4fea-424d-bc10-5c99fd3a1b2b.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/aa153e82-88ae-40b9-a7ee-e76b9858ec8e.jpg}	{}	{}	2023-11-23 08:50:56	2023-11-23 08:50:56
724ea4b0-a9d5-46a8-a010-9a1fd24582bb	f	\N	\N	\N	\N	dae9be5f-69f8-4aba-8707-3974bd4edf02	dae9be5f-69f8-4aba-8707-3974bd4edf02	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/997eeabd-7ef4-46e7-92b8-ce42c044a017.jpg}	{}	{}	2023-11-23 09:10:00	2023-11-23 09:10:00
96c8fddd-4ada-4d66-8aac-82e807df2b00	f	\N	\N	\N	\N	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	1c0b7660-f78c-48c9-a2c3-7407d58db1c7	\N	0	{https://youtu.be/w0_VcOdetm0?si=_85vJpy9QEiL3nHD}	{}	{}	2023-11-23 09:10:08	2023-11-23 09:10:08
c679dd0e-d1ee-4e88-bb0e-932420c6960a	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	서울경제인협회 임원단	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/3f3da109-74d6-4f4d-9aee-c19c5d4b3736.jpg}	{}	{}	2023-11-23 23:19:46	2023-11-23 23:19:46
d33592e6-5485-40b3-9ea0-f3a9833f0b2e	f	\N	\N	\N	\N	e703bd05-a781-41ce-82b6-e0221018d631	e703bd05-a781-41ce-82b6-e0221018d631	서울경제인협회 지회장 및 사무총장 임원회의	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/32ca48a2-882a-4adb-86ac-753442d81911.jpg}	{}	{}	2023-11-23 23:21:10	2023-11-23 23:21:10
e8f30269-3b2d-418c-b0e5-bca39a6663c2	f	\N	\N	\N	\N	c1667389-c459-4ecc-a759-cd2b0d69d687	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/7662ee65-85c6-46c2-8d9f-c712f054401e.jpg}	{}	{}	2023-11-24 01:27:33	2023-11-24 01:27:33
babe47f3-bce6-4536-b262-f5ec62339c28	f	\N	\N	\N	\N	691a7808-92eb-4fce-a618-d51867429491	691a7808-92eb-4fce-a618-d51867429491	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/4fce2966-c08c-4059-ac26-dae7356a7418.jpg}	{}	{}	2023-11-24 02:25:16	2023-11-24 02:25:16
01a622b3-f99d-4c54-82f1-2b401b56a6cf	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	PRODAO Logo	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/1775dbad-99c2-4565-8403-d803bb5d3f4d.jpg}	{}	{}	2023-11-24 02:58:14	2023-11-24 02:58:14
49902079-fd28-400b-9c8c-52464c8ce2b0	f	\N	\N	\N	\N	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/40742b5c-072c-4c79-95c3-ca54958b7e18.jpg}	{}	{}	2023-11-24 04:12:08	2023-11-24 04:12:08
9d5cd418-5b19-4101-91d6-1c6e0baecdd3	f	\N	\N	\N	\N	3e969c04-e8bf-4376-a556-2a039627e19f	3e969c04-e8bf-4376-a556-2a039627e19f	사진	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d13d7bae-4a2e-4b8b-9055-5ab52abd5293.png}	{}	{}	2023-11-13 01:52:48	2023-11-13 01:52:48
6873fbb3-be67-4cd4-953c-d7143aafe465	f	\N	\N	\N	\N	3e969c04-e8bf-4376-a556-2a039627e19f	3e969c04-e8bf-4376-a556-2a039627e19f	ㅎㅎ	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/055fc2b6-8e21-4cf0-9fd4-ce10ed21bd1b.png}	{}	{}	2023-11-13 01:54:18	2023-11-13 01:54:18
3381c063-4129-4778-a7a9-655722fccb45	f	\N	\N	\N	\N	3e969c04-e8bf-4376-a556-2a039627e19f	3e969c04-e8bf-4376-a556-2a039627e19f	사진	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/72124ab1-fedc-4831-a81e-059a6ec004f8.png}	{}	{}	2023-11-13 02:31:09	2023-11-13 02:31:09
560ed72e-66bb-4daf-aacf-d9bffd2876ea	f	\N	\N	\N	\N	dab9453b-a30d-44ec-a414-132e953c2408	dab9453b-a30d-44ec-a414-132e953c2408	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/8d36885b-a4cc-46f3-a20b-00daa2690570.jpg}	{}	{}	2023-11-13 02:37:10	2023-11-13 02:37:10
6918b68d-264a-49a7-bed3-409cde6e6846	f	\N	\N	\N	\N	8b9c80e4-3072-4dab-85a6-36e310fae6ef	8b9c80e4-3072-4dab-85a6-36e310fae6ef	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/74daa01f-edd9-4cfe-9e0d-61a72a4fda1f.jpg}	{}	{}	2023-11-13 03:37:48	2023-11-13 03:37:48
f74e5fc0-00dd-4a06-a332-d846630d03dc	f	\N	\N	\N	\N	8b9c80e4-3072-4dab-85a6-36e310fae6ef	8b9c80e4-3072-4dab-85a6-36e310fae6ef	코더스	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6be90e0b-ef09-4c21-ae53-1a658abf532a.jpg}	{}	{}	2023-11-13 03:37:51	2023-11-13 03:37:51
54d9c4b7-1ae9-4c5d-b67f-ed4c778c185d	f	\N	\N	\N	\N	3e969c04-e8bf-4376-a556-2a039627e19f	3e969c04-e8bf-4376-a556-2a039627e19f	ㅎ	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/793e4b86-8e07-444a-999e-bdab4405a279.png}	{}	{}	2023-11-14 00:14:24	2023-11-14 00:14:24
2d845038-1341-486d-b0f4-bcce11b96b27	f	\N	\N	\N	\N	3e969c04-e8bf-4376-a556-2a039627e19f	3e969c04-e8bf-4376-a556-2a039627e19f	Tt	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/10a8b2e1-7275-4abb-a119-95df6f9e3553.png}	{}	{}	2023-11-14 00:26:18	2023-11-14 00:26:18
09eee556-f94c-42b7-841a-e9fff2f047b9	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/5c1fbd76-f276-4729-aa33-b3f5a4956a4c.jpg}	{}	{}	2023-11-14 12:48:57	2023-11-14 12:48:57
a644307d-c0ef-4a75-9da0-8377834b59b3	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/5b04aad3-e250-4b1e-8aed-17ccf3948ef5.jpg}	{}	{}	2023-11-15 02:56:18	2023-11-15 02:56:18
800f026c-a0bc-42f8-a3a7-b98595ad5f36	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/f8355c06-2147-4106-b643-b5c6d159e36b.jpg}	{}	{}	2023-11-15 04:42:17	2023-11-15 04:42:17
4ea417ff-cabb-48b1-94f6-1c6aee848ad7	f	\N	\N	\N	\N	c1667389-c459-4ecc-a759-cd2b0d69d687	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/836f788d-c01c-48e9-9ae6-ca64516b8f1f.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9b4b00f5-613c-46e7-a62a-5afd4cd763fd.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/dcc0f2ec-ec08-4f73-bf07-ecdf166a5f08.jpg}	{}	{}	2023-11-16 01:40:48	2023-11-16 01:40:48
40421a68-1660-4dd6-911d-d3e5db345224	f	\N	\N	\N	\N	3ffbd728-c91d-40c5-8bb2-b45e93c1ff6f	3ffbd728-c91d-40c5-8bb2-b45e93c1ff6f	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/f7d16c37-7d84-4b82-b396-9c148caeed72.jpg}	{}	{}	2023-11-18 05:18:26	2023-11-18 05:18:26
1b805cd2-3cc7-442a-be3b-0975ebf0eb87	f	\N	\N	\N	\N	3ffbd728-c91d-40c5-8bb2-b45e93c1ff6f	3ffbd728-c91d-40c5-8bb2-b45e93c1ff6f	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a67a67ff-bb1e-4d25-8cec-4ab94e72a11f.jpg}	{}	{}	2023-11-18 05:18:47	2023-11-18 05:18:47
033d862d-30a7-4fae-ad2a-7beaa3b6558b	f	\N	\N	\N	\N	c1667389-c459-4ecc-a759-cd2b0d69d687	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6f9ff331-4d46-4ed9-ba8b-fc926585d702.jpg}	{}	{}	2023-11-20 00:37:10	2023-11-20 00:37:10
81de18c0-1870-401f-9ea0-c8336cda7da8	f	\N	\N	\N	\N	c1667389-c459-4ecc-a759-cd2b0d69d687	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/5a4159fe-a833-43e7-88de-b81a99689fe0.jpg}	{}	{}	2023-11-20 00:37:36	2023-11-20 00:37:36
cb891970-88f8-4052-b62e-7460c65ed15f	f	\N	\N	\N	\N	8fd92c37-ee30-48c5-9758-5b27c3768deb	8fd92c37-ee30-48c5-9758-5b27c3768deb	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6e9f7e9d-e374-4e8f-99de-aaee9db537b5.jpg}	{}	{}	2023-11-21 03:19:43	2023-11-21 03:19:43
701853d2-4494-4d34-9dd1-1d8aff60c9d0	f	\N	\N	\N	\N	e703bd05-a781-41ce-82b6-e0221018d631	e703bd05-a781-41ce-82b6-e0221018d631	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/314658ec-1b4c-4176-aeb3-d01fa7c32431.jpg}	{}	{}	2023-11-23 05:43:38	2023-11-23 05:43:38
b752de69-e658-42e5-abe3-e6a085e3a061	f	\N	\N	\N	\N	c1667389-c459-4ecc-a759-cd2b0d69d687	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/db7d4963-a595-48bc-9423-ecc42197abf6.jpg}	{}	{}	2023-11-23 05:52:39	2023-11-23 05:52:39
295df4dc-f765-4755-81ca-490bb506a7b0	f	\N	\N	\N	\N	c1667389-c459-4ecc-a759-cd2b0d69d687	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e2a0bb0c-020a-4637-8e2d-5945b238ad4b.jpg}	{}	{}	2023-11-23 05:52:48	2023-11-23 05:52:48
13c05925-250f-436a-8915-00df1bb66766	f	\N	\N	\N	\N	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/661ffbff-a8c4-479a-98b8-33d1d18a1cc1.jpg}	{}	{}	2023-11-24 04:12:42	2023-11-24 04:12:42
b8869f08-314e-45a0-839e-13b53c98ab84	f	\N	\N	\N	\N	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	89612df6-d726-4d5a-97f8-dee7b9fe2bfd	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/5cee2fea-33fc-4557-b1f2-fc991ee8ea96.jpg}	{}	{}	2023-11-24 04:13:03	2023-11-24 04:13:03
142e3d16-a816-4714-a1af-522dd6caff83	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	충북 블록체인 기술융합 스페이스	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d02d0663-4e60-4663-85ec-63cf3338a9b7.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9e4f4d45-3fe3-4235-8c33-8844b12bf3dd.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/15254dc7-0d94-489e-adde-db10a5dc17e7.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/01fd9f35-c88f-4f80-84de-7d6d802d2752.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/234c2f98-160b-4580-bf72-3d982bd18260.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/f5214ce5-574e-43b8-96fd-ac95fc041e4c.jpg}	{}	{}	2023-12-14 01:13:00	2023-12-14 01:13:00
e4717168-b411-40d8-97a6-d181865630c3	f	\N	\N	\N	\N	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	사무실	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/3a0aa28e-d2ba-44e9-a216-858d9b9becb7.mp4}	{}	{}	2023-12-15 00:13:20	2023-12-15 00:13:20
6abc934f-a282-40b5-ad77-26105e141998	f	\N	\N	\N	\N	7a19a677-5c7e-4efa-99aa-2d7a536f4ba9	7a19a677-5c7e-4efa-99aa-2d7a536f4ba9	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a6189d1f-b93f-4e6f-9e78-3453f893cb46.jpg}	{}	{}	2024-01-16 02:50:39	2024-01-16 02:50:39
76f29da8-27e9-435f-8eaa-d0d8642dd17b	f	\N	\N	\N	\N	c1667389-c459-4ecc-a759-cd2b0d69d687	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/5e2863af-acb2-4293-a086-4cefbe933a52.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/2143a8de-5346-4352-a2a6-ea9ed64ba558.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/f913c099-2799-4640-9627-04eb7cfe7bb4.jpg}	{}	{}	2023-12-15 01:25:04	2023-12-15 01:25:04
916dbe78-fd09-471a-abcc-0d6b36edf858	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	Branch (office)[프로다오충북] 블록체인 기술융합 스페이스	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e5f67c4f-e0b0-45e8-99b7-261d91214f53.jpg}	{}	{}	2023-12-16 05:08:47	2023-12-16 05:08:47
4613d144-84d4-42de-adf9-43539c2d7df7	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	HQ PRODAO USA 4554 BELL BLVD APT 1 BAYSIDE, NY 11361-3384	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/5b6f2f1c-e2a5-4802-96bd-de7ccb160add.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c6816763-9fbc-4bec-b1d3-dd73c5f27c4d.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9402ae34-ffa6-4fdf-bf15-c4dedd8a5e5c.jpg}	{}	{}	2023-12-16 07:20:49	2023-12-16 07:20:49
8bc7f8cb-c6f2-403a-b147-9632f90b4fa6	f	\N	\N	\N	\N	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/f7f375a1-09e1-4c4c-bdfe-a26ba96c7d85.jpg}	{}	{}	2023-12-18 06:06:43	2023-12-18 06:06:43
c80ccceb-112e-419b-bdb1-6efc7d31dd2e	f	\N	\N	\N	\N	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/80b2ec47-7e1e-44d1-ad6d-6ecb5f1f151a.jpg}	{}	{}	2023-12-18 06:09:49	2023-12-18 06:09:49
6d52298c-bc17-4d2e-9fa7-22b279a08288	f	\N	\N	\N	\N	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	https://m.youtube.com/watch?v=cWGchCZ0S6k	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/13a1050d-8809-494f-a830-249a14e47694.jpg}	{}	{}	2023-12-19 00:13:20	2023-12-19 00:13:20
823cb106-b5a0-477b-a107-1eb59e86d43f	f	\N	\N	\N	\N	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	d26f7e0e-4df0-40b0-90c6-3b4b15bcf52b	http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/07b02143-6ee5-494f-9a97-e246e99a8ffd.jpg}	{}	{}	2023-12-19 00:56:27	2023-12-19 00:56:27
9f7236a1-5008-4170-b8c4-27d3b6ff6514	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	한국과학기술정보연구원(서울) ASTI 리더스 포럼(호텔ICC대전)	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/bf4526f2-943d-4316-8e3e-5bbe095b457b.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/316e28eb-31a5-424f-93e4-afe5ff4e2690.jpg}	{}	{}	2023-12-19 04:15:42	2023-12-19 04:15:42
d42515d9-fc21-4bb2-90a4-35da4d096b7d	f	\N	\N	\N	\N	7a19a677-5c7e-4efa-99aa-2d7a536f4ba9	7a19a677-5c7e-4efa-99aa-2d7a536f4ba9	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d93f21ee-5224-44a2-a669-22d6f7c931f8.jpg}	{}	{}	2023-12-21 02:18:38	2023-12-21 02:18:38
ff3ec0d0-509b-4fb0-9fc6-4c912054b995	f	\N	\N	\N	\N	7a19a677-5c7e-4efa-99aa-2d7a536f4ba9	7a19a677-5c7e-4efa-99aa-2d7a536f4ba9	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/dee82026-9809-46fb-9478-51cce82424ce.jpg}	{}	{}	2023-12-21 02:33:53	2023-12-21 02:33:53
d6d6f4c3-9292-4aff-95c7-82f8e755b2e9	f	\N	\N	\N	\N	76437582-061c-4b94-9873-a4e3b6b8c787	76437582-061c-4b94-9873-a4e3b6b8c787	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a8b7fdf4-95c9-4529-b956-ba928158e115.jpg}	{}	{}	2023-12-21 13:39:59	2023-12-21 13:39:59
6cf007ac-ffd3-4f44-afe4-55b9e99b4979	f	\N	\N	\N	\N	d15bfb61-8af0-49af-af82-24696cd922a9	d15bfb61-8af0-49af-af82-24696cd922a9	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9b6da312-a990-4a1c-8a80-71058e981082.jpg}	{}	{}	2023-12-22 04:02:57	2023-12-22 04:02:57
97cdaafd-6101-44af-8afb-f4085a62e201	f	\N	\N	\N	\N	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/58080865-5d83-4139-8617-5038004cbda5.jpg}	{}	{}	2024-01-09 05:17:39	2024-01-09 05:17:39
9e2d222e-57ad-4143-a50a-5c2e6332dbb5	f	\N	\N	\N	\N	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	5e65cb32-7a62-46ae-916d-db5d3b6ffbc3	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/09508cb7-a92c-4bf7-986c-42ea7c043701.jpg}	{}	{}	2024-01-09 05:19:36	2024-01-09 05:19:36
5b957933-e519-441c-b39f-631b8767c8df	f	\N	\N	\N	\N	be269914-8f65-4e4c-b3c5-b02313f8b4ac	be269914-8f65-4e4c-b3c5-b02313f8b4ac	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c7d2e7cc-366a-4088-ba95-16ad98c28613.jpg}	{}	{}	2024-01-10 14:59:43	2024-01-10 14:59:43
43719df4-940b-4b39-b885-6afa966c02cf	f	\N	\N	\N	\N	699de247-c0c8-4a8b-bae8-6ba24d9489c1	699de247-c0c8-4a8b-bae8-6ba24d9489c1	테스트	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d5368773-88f4-4fae-9c18-f28de78c1f4f.jpg}	{}	{}	2024-03-29 05:51:42	2024-03-29 05:51:42
f582bc03-5a23-424e-b2ec-b5d98f40714a	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	라이베리아 금광 채굴작업 1톤 15그램 함량	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e237d655-d58a-4c88-96fb-209d79265bf9.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/08a7fd48-bb51-4d2c-b8fe-62431c9ae580.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/047e6e7b-fc6e-4c64-aab5-94bb970325e9.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a0b9c1c0-c6b2-4c7a-803e-dd6528120d8b.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d9695cd9-8748-4d0a-976a-2a7c2ea6617d.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9e94c137-66c5-4587-8ea4-cc368f7dec05.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/f61dbe5e-36e7-424c-a4f7-5f4e6fed9578.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/cef61865-bea7-4e38-a71b-53b3e4a34372.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/cec97c9b-18d1-42d8-a643-bdb5c992ab61.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c37db332-4652-4706-8325-5b79d4ad6aa6.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/0c539bc9-3c3c-476c-a055-f11333b9449c.mp4,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/82ed0dd4-b4f9-46d5-a74b-2a9b95671eed.mp4}	{}	{}	2023-12-22 05:29:50	2023-12-22 05:29:50
b8d71587-2c23-48e2-8183-ef638b0d3309	f	\N	\N	\N	\N	5b277fc8-1da0-4867-beae-f6a8e72f490e	5b277fc8-1da0-4867-beae-f6a8e72f490e	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/05c3897d-f31d-4d75-9caa-62bb04a94140.jpg}	{}	{}	2023-12-23 12:34:10	2023-12-23 12:34:10
43272cd4-6240-4436-b0ab-1287f25153d4	f	\N	\N	\N	\N	c1667389-c459-4ecc-a759-cd2b0d69d687	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/47700d9f-b19e-4386-b4c4-9e7719af6af9.jpg}	{}	{}	2023-12-23 13:00:00	2023-12-23 13:00:00
07999cef-d369-4fa5-b3f4-9bf6dc36874f	f	\N	\N	\N	\N	c1667389-c459-4ecc-a759-cd2b0d69d687	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c2762371-2662-478e-b930-656acb3cb439.jpg}	{}	{}	2023-12-23 13:00:01	2023-12-23 13:00:01
18b6be04-ff0b-49db-9268-110ddde33cf5	f	\N	\N	\N	\N	b6fefa89-914a-4a89-bda8-e03a77dfbba2	b6fefa89-914a-4a89-bda8-e03a77dfbba2	3선이상 세대교체	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e404abed-88c1-4ed0-9150-10ae16705bfc.jpg}	{}	{}	2024-01-16 12:07:24	2024-01-16 12:07:24
cc4578ea-d837-4d57-91f1-5e4cd2c5b425	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	대한가수협회 회장 이자연 가요데뷔 40주년 기념	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6a8b3097-366b-488f-ac31-697483457c43.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/fbc7c951-dd3c-4307-820c-1f18735ae908.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6cfd5faf-a821-49ed-b975-89ba3492f774.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/458fa177-89f0-42ed-a285-bc29371e5a99.mp4,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6cb6f60e-4a08-4a19-af90-6ba2c96bdc5b.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/22502fbc-f049-40dd-81a4-095f70f33e0a.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/fd1a956c-d6fb-4a00-9910-ccb0844b4d74.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/ca3de060-1ddc-40b0-b98e-65be04cb70f1.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e14627d8-eb52-48a1-801d-f36fc11d4d89.jpg}	{}	{}	2023-12-25 09:09:13	2023-12-25 09:09:13
e924b74b-6a95-41d0-a77e-2787ddd8a3b6	f	\N	\N	\N	\N	5b316a00-25b2-4fd7-8796-5dbb7f51f948	5b316a00-25b2-4fd7-8796-5dbb7f51f948	LF Food 냉동창고	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9fb71b00-f247-42ea-bf05-3b94fbe551d9.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/82cb9212-f693-40bf-bed5-6ac4703ead14.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/2747fa07-8b8e-443b-accc-07cb9837be34.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e3fb8896-2ce8-42f0-a3ac-177155921e12.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/7ea1128b-835a-41e6-a802-f2f23b04f244.jpg}	{}	{}	2023-12-26 04:07:15	2023-12-26 04:07:15
f333b0ca-fbc3-468d-915d-0a43b2b59e20	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	[포토존] PRODAO 충북 블록체인 기술융합 스페이스	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c6f9eb83-bcd0-4f64-879a-a3c17a99ae3c.jpg}	{}	{}	2023-12-27 02:12:41	2023-12-27 02:12:41
a99439eb-5b0d-48d0-bfe0-61504bd558b7	f	\N	\N	\N	\N	691a7808-92eb-4fce-a618-d51867429491	691a7808-92eb-4fce-a618-d51867429491	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/0620adb3-116b-4d3a-8073-1296d22eeb7e.jpg}	{}	{}	2023-12-27 06:02:48	2023-12-27 06:02:48
49e88c88-8126-47d7-8c2a-83af004f00fe	f	\N	\N	\N	\N	16c03ecc-7936-4614-b272-58cfb2288da8	16c03ecc-7936-4614-b272-58cfb2288da8	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6f3931dd-545c-4eea-8b1d-ac80a021d274.mp4}	{}	{}	2023-12-30 15:05:20	2023-12-30 15:05:20
d7dd2b10-94e0-402c-a732-c6c45f791bc9	f	\N	\N	\N	\N	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/076e4675-d0f2-402b-839d-61e7d8c25a60.jpg}	{}	{}	2024-01-03 03:09:04	2024-01-03 03:09:04
22f14ab2-4b8e-4271-8fbf-bdd47699b899	f	\N	\N	\N	\N	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/ac4a8a93-4030-4bf0-92b5-16858868fa44.jpg}	{}	{}	2024-01-03 03:09:22	2024-01-03 03:09:22
cbdf5918-cadf-4542-9427-af5856fc0325	f	\N	\N	\N	\N	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c08c8c24-976b-4c61-b5dc-1fdc45e67a23.jpg}	{}	{}	2024-01-03 03:09:29	2024-01-03 03:09:29
cf20e645-87a5-46d5-a83c-22489b387e65	f	\N	\N	\N	\N	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	https://www.youtube.com/watch?v=JTX-ojwd4sk	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/87fbe231-63bb-45cb-9aa3-083adf407a74.png}	{}	{}	2024-01-03 03:11:04	2024-01-03 03:11:04
a7d9a831-fc3c-4b19-b236-8f018e488e78	f	\N	\N	\N	\N	dab9453b-a30d-44ec-a414-132e953c2408	dab9453b-a30d-44ec-a414-132e953c2408	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/f61b8e34-253e-44a4-8b9e-14fc080e7201.png}	{}	{}	2024-01-04 02:21:12	2024-01-04 02:21:12
76aac280-9e7a-4891-8756-5baa707709aa	f	\N	\N	\N	\N	dab9453b-a30d-44ec-a414-132e953c2408	dab9453b-a30d-44ec-a414-132e953c2408	https://www.youtube.com/watch?v=Q-UYtk9eKwk&list=PLWvaUZFoAtV86NlEomj687FvlI0OTCZK0	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/63eea6f0-8231-426a-b2d4-bd0553b7d846.png}	{}	{}	2024-01-04 02:21:58	2024-01-04 02:21:58
7c25f8d7-47ee-483f-8b83-39a6b5e52356	f	\N	\N	\N	\N	7a19a677-5c7e-4efa-99aa-2d7a536f4ba9	7a19a677-5c7e-4efa-99aa-2d7a536f4ba9	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/b71ad654-d5fe-43ab-b72e-858aed72f3f9.png}	{}	{}	2024-01-15 07:13:02	2024-01-15 07:13:02
742ae172-d20b-42d8-9648-78313fd9560f	f	\N	\N	\N	\N	9c575b13-2b96-4e73-8ae6-21267b4cf871	9c575b13-2b96-4e73-8ae6-21267b4cf871	인정 받고 싶은 만큼 인정하라 맑은고을 시민행동 가입신청서	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/8b8a9c51-109b-41fc-bf48-ca89f3754119.jpg}	{}	{}	2024-01-15 08:06:38	2024-01-15 08:06:38
c675ed21-0576-4711-88c1-bc5f8d77d3e2	f	\N	\N	\N	\N	b6fefa89-914a-4a89-bda8-e03a77dfbba2	b6fefa89-914a-4a89-bda8-e03a77dfbba2	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9d39b646-1e59-4032-9e30-0ceaa6ca4180.jpg}	{}	{}	2024-01-15 15:16:50	2024-01-15 15:16:50
9041849d-f882-4f5a-bd4c-8ed174d6438b	f	\N	\N	\N	\N	b6fefa89-914a-4a89-bda8-e03a77dfbba2	b6fefa89-914a-4a89-bda8-e03a77dfbba2	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6096a6ac-e0cb-4e33-8c3f-871e83dc07ce.jpg}	{}	{}	2024-01-15 15:17:08	2024-01-15 15:17:08
1557d335-d90d-45a1-b0e1-23b3a2a258e5	f	\N	\N	\N	\N	b6fefa89-914a-4a89-bda8-e03a77dfbba2	b6fefa89-914a-4a89-bda8-e03a77dfbba2	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/3584111f-9ab8-42df-96bc-e5b73b166f3d.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/67886547-316e-46ad-8bcc-7573d019c912.jpg}	{}	{}	2024-01-15 15:20:59	2024-01-15 15:20:59
1b797ef6-b4b2-4705-b730-6db32af3ded6	f	\N	\N	\N	\N	abfbdf7e-6cb4-4977-82ef-93211e950a6c	abfbdf7e-6cb4-4977-82ef-93211e950a6c	Breakfast Seminar of the Korea Industrial Technology Promotion Association	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/0e343609-f5d4-4f76-afc0-5baf333550c4.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9cf8e8c3-5507-4793-890f-bff52f8dabbf.jpg}	{}	{}	2024-01-18 00:28:37	2024-01-18 00:28:37
385e34c6-6055-4d4b-a3ee-ef77c9f30636	f	\N	\N	\N	\N	55343256-1601-423a-b1a4-3d467d2b64c6	55343256-1601-423a-b1a4-3d467d2b64c6	테	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/959fa11f-d78a-4f32-9f0c-608b43fd6d09.jpg}	{}	{}	2024-01-30 11:19:04	2024-01-30 11:19:04
d99acd92-87c8-4c08-a453-ed9fbd01e1ff	f	\N	\N	\N	\N	f2478ee5-cf2e-4ec2-b312-24aaee25c6b5	f2478ee5-cf2e-4ec2-b312-24aaee25c6b5	Khang	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/44ba8cce-b7e2-477d-a560-e30501c3f276.jpg}	{}	{}	2024-03-14 13:36:04	2024-03-14 13:36:04
e3cd0054-3001-4b22-8ec9-d6817861ef38	f	\N	\N	\N	\N	7d469a31-f327-4656-8f0e-d9906a26a8e3	7d469a31-f327-4656-8f0e-d9906a26a8e3	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/3c2fe39e-553b-4b21-8da4-0e1833f22521.jpg}	{}	{}	2024-02-17 06:40:37	2024-02-17 06:40:37
a260e078-f97b-41a9-9718-d95f40292302	f	\N	\N	\N	\N	5dc09e11-8310-4e6b-a8fc-250aadd1e2b2	5dc09e11-8310-4e6b-a8fc-250aadd1e2b2	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/895736a9-0a42-4dcb-8811-e7ce6f9acd07.png}	{}	{}	2024-02-18 23:51:20	2024-02-18 23:51:20
2a0af671-9f25-4b94-9c27-ed0e3d6a1a10	f	\N	\N	\N	\N	5dc09e11-8310-4e6b-a8fc-250aadd1e2b2	5dc09e11-8310-4e6b-a8fc-250aadd1e2b2	2024-제1차 세종대&산학연 조찬포럼 안내	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a13353c5-bc37-4c69-b237-167c37f97ff3.jpg}	{}	{}	2024-02-19 00:04:33	2024-02-19 00:04:33
287a5a8f-2df8-4674-ba40-7db1c8cb236d	f	\N	\N	\N	\N	8812812f-8bbf-4ae2-914a-b8cae24cdbcc	8812812f-8bbf-4ae2-914a-b8cae24cdbcc	테스트 미디어 입니다	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c1b63d5d-6802-443a-aecd-22a4ebbc9005.jpg}	{}	{}	2024-02-19 07:06:16	2024-02-19 07:06:16
56f588c1-eb5a-46c3-bb37-6a3bf03cea05	f	\N	\N	\N	\N	45f81bc7-ff24-498d-9104-18da7e5643f8	45f81bc7-ff24-498d-9104-18da7e5643f8	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/db379022-ed25-4580-a62f-901842e2c4c6.jpg}	{}	{}	2024-02-19 08:29:40	2024-02-19 08:29:40
2046bab4-8827-43c1-acac-810410fc8a11	f	\N	\N	\N	\N	8f2abc6e-f4cf-4ce0-81fe-6a326079d556	8f2abc6e-f4cf-4ce0-81fe-6a326079d556	ㅎㅎ ㅎㅎㅎ\nㅎㅎㅎㅎㅎ	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/895736a9-0a42-4dcb-8811-e7ce6f9acd07.png,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/895736a9-0a42-4dcb-8811-e7ce6f9acd07.png}	{}	{}	2024-02-08 01:06:39	2025-02-24 18:01:35.901
0a6b672d-cd57-4dbf-becb-e2fb0ffcb54f	f	\N	\N	\N	\N	e93e5575-697d-4814-bc66-66b6d5d08f2d	e93e5575-697d-4814-bc66-66b6d5d08f2d	국방사이버안보포럼	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/307733e4-5ca7-4268-9b6e-cc24b8310be9.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/80b8ce3c-1cd3-465f-8589-3e0f89c63675.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/1d8aefbf-795d-479f-bb1a-b6bf8a30ee04.jpg}	{}	{}	2024-02-27 00:11:38	2024-02-27 00:11:38
40360781-2eb0-485f-9508-158588f29c95	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	세종 국방사이버안보포럼 PRODAO 서비스 발표 http://www.gukbangnews.com/news/articleView.html?idxno=7256.	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d8be7bf5-2841-4019-8e8d-23535e22339b.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/2553773a-ae59-48ab-ad84-02d194a66078.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/455bbefe-ce7f-4688-b8a3-de85da6ab69a.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6350e920-a796-4e01-97bd-a2afc72c840d.jpg}	{}	{}	2024-02-27 00:27:58	2024-02-27 00:27:58
8c948167-aece-4110-9268-dfbcbd4a16f7	f	\N	\N	\N	\N	0134d7aa-9f38-4e9c-a172-f94415e1beb2	0134d7aa-9f38-4e9c-a172-f94415e1beb2	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/ecfeb7cd-45d4-46a0-970b-24591bf41836.png}	{}	{}	2024-03-05 00:48:58	2024-03-05 00:48:58
38479cff-d688-4501-9499-a287c06bdf50	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	제72회 산기협 조찬세미나. 기업의Gen AI활용방안	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/15979788-2ca7-4ee7-9952-cd6681461e25.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/ed6cfe0f-f05a-4674-99a7-34c767133540.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c5bffcc1-7d5a-4c92-86ef-7807c2d4e3ab.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/fa3b3363-f47e-4996-a424-7242dc6da47c.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/91d6d73b-f2ab-45f9-b686-1f23aa0241b9.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/2fef4e30-0b5c-4566-a6de-ded15d52cef6.jpg}	{}	{}	2024-03-13 22:23:19	2024-03-13 22:23:19
c00cc2d7-6c55-4523-8ed8-1899253de54d	f	\N	\N	\N	\N	7b936d81-9eab-4f66-9f44-f8bfdae9c846	\N	테스트	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/92d6d7f1-6a90-417e-b29d-f48af88fb336.jpg}	{}	{}	2024-06-16 14:10:46	2024-06-16 14:10:46
f4440e14-ea0b-4797-b1bd-e192063312f8	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	2024 SaaS 개발지원사업 CSP설명회	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/301dafa0-816a-4e29-b463-f898775b6f2b.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/2c3573f1-0674-4bb5-b976-a0942167d74f.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/ae97dbb2-cc75-47c5-97bb-819a8a572867.jpg}	{}	{}	2024-03-14 01:10:45	2024-03-14 01:10:45
57fa6c92-4e21-44ab-bbc7-d92b27d96c74	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	블록체인 NFT기반 디지털자산 정품 품질보증서, 원산지 증명서 발급 서비스 실시.	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/4794750e-416a-43d3-b45a-42005199ec87.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/91d2de6c-711e-4a95-b9d3-0170ef6e98a1.jpg}	{}	{}	2024-03-14 01:23:28	2024-03-14 01:23:28
843fdaa1-dfc2-44f7-9665-fa5a9f688239	f	\N	\N	\N	\N	f2478ee5-cf2e-4ec2-b312-24aaee25c6b5	f2478ee5-cf2e-4ec2-b312-24aaee25c6b5	Khang	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/8f13ca9a-8958-4320-bdea-f4b743a56f28.jpg}	{}	{}	2024-03-14 13:36:04	2024-03-14 13:36:04
7fe38c14-2b3d-4fe6-a3a9-86f750d01301	f	\N	\N	\N	\N	62ee5b22-cd13-4cb1-bdcf-f2976f9328fd	62ee5b22-cd13-4cb1-bdcf-f2976f9328fd	상품	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a68fa75c-023d-431e-b94b-aff0af793d1f.jpg}	{}	{}	2024-03-15 10:29:11	2024-03-15 10:29:11
a1473dc2-ab12-460d-aaae-c16cb962bdb4	f	\N	\N	\N	\N	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	4cafe7b7-4cd7-44db-a0fc-6b4521ee5967	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/63442828-9e09-467b-ba8a-1ec7efcb6100.jpg}	{}	{}	2024-03-20 00:35:40	2024-03-20 00:35:40
cf9727e3-7046-4123-8c8b-fe30c9328472	f	\N	\N	\N	\N	5b316a00-25b2-4fd7-8796-5dbb7f51f948	5b316a00-25b2-4fd7-8796-5dbb7f51f948	KISA UTM구축	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/03b43d6c-301c-4d41-a283-87b7dc54418e.jpg}	{}	{}	2024-03-20 02:37:49	2024-03-20 02:37:49
77d4b61f-12a7-4e60-91bd-cc70e3440198	f	\N	\N	\N	\N	5b316a00-25b2-4fd7-8796-5dbb7f51f948	5b316a00-25b2-4fd7-8796-5dbb7f51f948	소닉월 파트너 세미나 참석후 디너	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d69ec433-0093-41f3-9ac6-5a2b374e593b.jpg}	{}	{}	2024-03-20 02:40:18	2024-03-20 02:40:18
1935ea9d-3df3-42d5-8d7a-1fcdc43ed168	f	\N	\N	\N	\N	5b316a00-25b2-4fd7-8796-5dbb7f51f948	5b316a00-25b2-4fd7-8796-5dbb7f51f948	스마트 팜 구축 사례	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/2e33fbbd-44f1-44f7-b133-bcba31a9a526.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/cbcf05be-ec78-4660-bf19-c265d04ef056.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c2580abe-5943-4aff-9cd7-cd0ced6176bb.mp4}	{}	{}	2024-03-20 02:42:24	2024-03-20 02:42:24
2fecbf99-3baa-448f-a501-415611307734	f	\N	\N	\N	\N	b9325221-963e-4909-8a81-6d00f3b1e7e6	b9325221-963e-4909-8a81-6d00f3b1e7e6	반갑습니다.	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/14a374d6-5761-49ae-9fbf-05d867d36217.jpg}	{}	{}	2024-03-20 12:17:04	2024-03-20 12:17:04
2119a51a-7c54-4eb4-8d17-cd0bf7da6c7e	f	\N	\N	\N	\N	b9325221-963e-4909-8a81-6d00f3b1e7e6	b9325221-963e-4909-8a81-6d00f3b1e7e6	테스트	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/8f9f0882-9721-4933-953f-06d2ff2cb7fa.jpg}	{}	{}	2024-03-20 12:27:50	2024-03-20 12:27:50
cdb1834d-1575-4d43-be2b-b5b9c8a429b1	f	\N	\N	\N	\N	39144bf1-9a12-4d6d-a814-b769473d158f	39144bf1-9a12-4d6d-a814-b769473d158f	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/b95803c4-b026-4265-82f4-5f460edc2b7a.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e5fd6aee-d22b-4c4b-8909-918c60b459ac.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/dbe1cf32-18ef-4847-8b4a-f10d861c1ba3.jpg}	{}	{}	2024-03-20 13:39:17	2024-03-20 13:39:17
380eea77-099f-4dd7-a07b-aa1d9e1b6a06	f	\N	\N	\N	\N	39144bf1-9a12-4d6d-a814-b769473d158f	39144bf1-9a12-4d6d-a814-b769473d158f	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/199bc88f-8642-4317-854b-a76d3340ccb2.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9189fc5a-e0aa-4037-afec-96805771529f.jpg}	{}	{}	2024-03-20 13:40:11	2024-03-20 13:40:11
2820acd6-4a90-497b-b1e3-460ae817a9b8	f	\N	\N	\N	\N	abfbdf7e-6cb4-4977-82ef-93211e950a6c	abfbdf7e-6cb4-4977-82ef-93211e950a6c	How to Live 100 Times Better	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/681fbe49-1cb1-4276-8f5c-1882606befdf.jpg}	{}	{}	2024-03-20 23:28:09	2024-03-20 23:28:09
03451fbb-676d-4fb4-b7fb-9798e8143339	f	\N	\N	\N	\N	abfbdf7e-6cb4-4977-82ef-93211e950a6c	abfbdf7e-6cb4-4977-82ef-93211e950a6c	Seoul National University MBA Luncheon Special Lecture	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/b250a9e6-8ddb-4a2b-8b48-b475f2dfa815.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c8e5cb6c-42ce-4b3b-829e-9d0e6733eaa1.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/320bf76a-f807-4969-9370-c174a3de9388.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c9f60be8-99f6-4e9c-a6b4-f7e5fd6d5f9b.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/7ed92364-fb5e-4793-89ed-3b12e6e1854a.jpg}	{}	{}	2024-03-20 23:29:44	2024-03-20 23:29:44
1124ca70-fdc0-479c-996d-8607fddb4154	f	\N	\N	\N	\N	abfbdf7e-6cb4-4977-82ef-93211e950a6c	abfbdf7e-6cb4-4977-82ef-93211e950a6c	General position, R&D position	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/0df29c17-2c16-48d8-a4e0-892c680f8461.png}	{}	{}	2024-03-20 23:31:58	2024-03-20 23:31:58
6eb60b77-766a-4228-9d07-02af171c9e83	f	\N	\N	\N	\N	20115650-29ba-44fa-9861-99c990caa5b1	20115650-29ba-44fa-9861-99c990caa5b1	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9add7149-0955-4009-8b12-d8d2eeed0881.png}	{}	{}	2024-03-27 00:38:34	2024-03-27 00:38:34
e79bc7f5-3c69-432f-9e34-445a02cd226b	f	\N	\N	\N	\N	abfbdf7e-6cb4-4977-82ef-93211e950a6c	abfbdf7e-6cb4-4977-82ef-93211e950a6c	Breakfast Seminar of the Korea Industrial Technology Promotion Association	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e41e2f03-e05b-492e-889f-d80734a2a763.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/3e6f5c5b-8a29-4174-a05d-3cc2337b8e21.jpg}	{}	{}	2024-03-20 23:33:51	2024-03-20 23:33:51
5e57693a-94a0-4287-81ae-d9cc6a427d66	f	\N	\N	\N	\N	69e01f2b-91dd-4f35-9830-4cc59ed58d57	69e01f2b-91dd-4f35-9830-4cc59ed58d57	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/03ba77aa-148a-4090-8ff0-592b48f07000.png,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/1e85602c-55ba-4ad5-b9b9-0e3cb7c85627.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e2217f36-7352-4014-9366-193a91d2f636.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/b0a8ab62-f93b-4205-80f0-7b278f148485.jpg}	{}	{}	2024-04-11 06:01:22	2024-04-11 06:01:22
592fa727-ff66-4db8-af05-13eed511bf14	f	\N	\N	\N	\N	abfbdf7e-6cb4-4977-82ef-93211e950a6c	abfbdf7e-6cb4-4977-82ef-93211e950a6c	2024 CPS briefing session on SaaS development support project	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e906407f-07c7-4ac8-8fee-aa3fa3c5d511.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/5694b8ac-b000-4b54-8a71-1740f3f35d57.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/01282dc0-65c1-41b2-a0ba-5d11230d8c6c.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/dacab83f-dc9c-4642-ba7f-93c6bfffb2ab.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/2cce240f-4aef-4600-abd1-acdfc098ee53.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/73513054-09dc-4279-b902-936ff826e8d1.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/f4aa2a7f-c713-498c-9a0c-01cdc162ccc6.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/164a955a-cd5d-43db-af1b-429fc5a63f67.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e0afc2bd-9162-48ad-bff6-91f063df5f97.jpg}	{}	{}	2024-03-20 23:34:41	2024-03-20 23:34:41
d7a85e5e-571b-4795-883a-b35e883e474b	f	\N	\N	\N	\N	d20a6a07-b621-4dd3-a202-78ac56696c2c	d20a6a07-b621-4dd3-a202-78ac56696c2c	스마트 청진기	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/7b26d129-7617-47c8-a9fb-2ba422b32f63.png}	{}	{}	2024-04-07 08:11:36	2024-04-07 08:11:36
e0c3c15f-df07-4d68-99ad-26fb71802baf	f	\N	\N	\N	\N	abfbdf7e-6cb4-4977-82ef-93211e950a6c	abfbdf7e-6cb4-4977-82ef-93211e950a6c	Seoul National University Breakfast Meeting	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/cbeea3ee-87d2-4435-8976-184148fbb4cf.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d7210910-d290-4a00-af8e-1f752602dfc1.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/99cd42d8-a8eb-4cd3-81c2-65e8db5f224b.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e20e9983-82a8-4106-8d56-6490c1c64c8f.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a8440f84-76dc-4423-8b37-bb7da4c8016c.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/56c8e8ed-42bc-41d4-bfa2-9711dc7d1e9d.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/8030b27c-2ab7-4407-ac16-dc392035cb85.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/0c3a2c4a-ff8e-4810-b66f-6d4562a74e01.jpg}	{}	{}	2024-03-20 23:39:09	2024-03-20 23:39:09
4456bca4-353b-485b-8c3f-d94d9870d1f1	f	\N	\N	\N	\N	abfbdf7e-6cb4-4977-82ef-93211e950a6c	abfbdf7e-6cb4-4977-82ef-93211e950a6c	SNU AMP Golf Club	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/258b0b58-0f1b-459e-8d4d-3536112b2348.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/b8eafa5a-91a0-481f-abc2-09b5bd1b5faa.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/3b9d40e3-a6d7-45bf-a9c5-f2f2476e8f06.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/507e4520-c95d-4533-b809-ed193b993790.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/f7a17bbb-3baa-414c-867d-48712e6ac3b8.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c8415a18-d6b9-4f12-bb10-f95324e44eef.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/67ff568a-b362-4a99-b171-a81519c766b0.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9bb847d0-6b46-4105-b10a-d2a835f395f8.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/1c1bb0fd-a0d3-4f7e-a835-2a0e845c570a.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/b55980cb-b133-444b-847d-152aacdfb3ea.jpg}	{}	{}	2024-03-20 23:45:10	2024-03-20 23:45:10
e23836fa-0880-4fda-bf73-e23bdcca75d8	f	\N	\N	\N	\N	f3173f6b-71d2-47c1-9768-4ed28d2ee620	f3173f6b-71d2-47c1-9768-4ed28d2ee620	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/0deb7258-860f-4b82-9572-c59899d69b2c.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/21ee01ea-ad6c-4ce7-90b6-a1136462c64c.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/dc1e6006-2ce7-4521-8f8c-b38cbbd846b6.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/7a5f0a3f-6d6e-427d-b2b0-e1c46848326f.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/ddbc8564-b404-482b-93a6-8b728ab93591.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/b81ae37d-5fd2-465a-8793-cbd8dcb343cd.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a2bea132-a6a0-4dd0-989d-a123b1dba7b8.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/686973a3-ffa0-440c-b58a-72c26033472d.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/f940713e-5440-4279-9248-e6819d568627.jpg}	{}	{}	2024-03-21 06:03:59	2024-03-21 06:03:59
a3d67959-00b6-4e94-8b56-8ed916d4818a	f	\N	\N	\N	\N	c53ce851-fa9d-41ad-a7e1-416cb7b166fe	c53ce851-fa9d-41ad-a7e1-416cb7b166fe	테스트	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/3a53c3b6-7494-430d-9653-9df20e4c1357.jpg}	{}	{}	2024-03-22 07:30:24	2024-03-22 07:30:24
eff2de81-13ce-4905-9c31-5c707e0ac8c9	f	\N	\N	\N	\N	d15bfb61-8af0-49af-af82-24696cd922a9	d15bfb61-8af0-49af-af82-24696cd922a9	테스트	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/87f1b885-eb8a-443c-b66e-a445e5d1aa9e.jpg}	{}	{}	2024-03-23 04:35:54	2024-03-23 04:35:54
764c8de9-a8cd-449d-b4ec-6886133146c8	f	\N	\N	\N	\N	691a7808-92eb-4fce-a618-d51867429491	691a7808-92eb-4fce-a618-d51867429491	홍제폭포	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6f1d3955-7dc3-48d3-b4d9-371f8036ab14.jpg}	{}	{}	2024-03-23 08:29:48	2024-03-23 08:29:48
49c483c2-af22-4c3c-bd47-2f7e581e0a31	f	\N	\N	\N	\N	20115650-29ba-44fa-9861-99c990caa5b1	20115650-29ba-44fa-9861-99c990caa5b1	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/7eddfb3a-a7a5-48e4-820a-1fe55b55041a.png}	{}	{}	2024-03-27 00:37:51	2024-03-27 00:37:51
8ec11893-4173-491f-90e7-f6b6d9441f6c	f	\N	\N	\N	\N	20115650-29ba-44fa-9861-99c990caa5b1	20115650-29ba-44fa-9861-99c990caa5b1	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/31850036-24c3-44ed-b94c-6ee1a49bfa20.png}	{}	{}	2024-03-27 00:38:12	2024-03-27 00:38:12
a75dac6e-af70-4dd3-a452-54070708fda2	f	\N	\N	\N	\N	20115650-29ba-44fa-9861-99c990caa5b1	20115650-29ba-44fa-9861-99c990caa5b1	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/19a1e190-e486-4a4c-90d6-ae58f07b3a53.png}	{}	{}	2024-03-27 00:38:20	2024-03-27 00:38:20
0f7893aa-c09c-4228-af13-f1c4eaca6cca	f	\N	\N	\N	\N	20115650-29ba-44fa-9861-99c990caa5b1	20115650-29ba-44fa-9861-99c990caa5b1	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e8c85a32-68c3-4895-b0d1-76aa7b73fc4f.png}	{}	{}	2024-03-27 00:38:26	2024-03-27 00:38:26
28572bc8-f8be-49f3-a483-341cc960ffff	f	\N	\N	\N	\N	07ee028a-1e71-400d-a185-39dc4299803c	07ee028a-1e71-400d-a185-39dc4299803c	테스트	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d800531c-7b27-4d93-98a6-65deb7d349ab.jpg}	{}	{}	2024-03-27 13:21:20	2024-03-27 13:21:20
64d81fad-c939-4e49-b72d-c47ffb87fd8d	f	\N	\N	\N	\N	c1667389-c459-4ecc-a759-cd2b0d69d687	c1667389-c459-4ecc-a759-cd2b0d69d687	아메리카노 5000 비오는 날	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/2cdd642e-0f43-4946-b137-3c96461414a9.jpg}	{}	{}	2024-03-28 06:50:56	2024-03-28 06:50:56
5b3f4347-0a27-4f4c-8ff5-b5ebc6ab1840	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	신기술 동향과 산학연 협력의 장 세종 국방사이버안보포럼 국방신문	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/677661d7-0fae-4fc8-beb9-c7ebda7a4369.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/8e5d3221-52d9-4a05-9258-81c4e90f05ed.jpg}	{}	{}	2024-04-15 21:56:26	2024-04-15 21:56:26
e4c0858e-c499-49c5-817a-2fa13e06bdbd	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	PRODAO EU Trade Mark 라이센스 취득.등록번호: 018950624, 등록일자: 2024-03-09	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/7e728283-bdad-4507-972d-631313417772.jpg}	{}	{}	2024-04-18 22:50:09	2024-04-18 22:50:09
3ba6f9f4-c940-4869-a858-d35dbacf7279	f	\N	\N	\N	\N	7258a2ce-894f-4ce1-a260-84a7452f4d22	7258a2ce-894f-4ce1-a260-84a7452f4d22	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/759120d3-2f74-4656-aac8-22b87d1d87f2.jpg}	{}	{}	2024-04-22 03:57:15	2024-04-22 03:57:15
6c280842-230e-4d77-adfa-62b845d288ee	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	2024년 초거대 AI정부지원사업 설명회	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/91cdf505-64df-4ba7-838d-037d772c4cf9.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/003ccb91-296a-4b9c-975c-0cbbaf0b489e.jpg}	{}	{}	2024-04-30 05:00:01	2024-04-30 05:00:01
704d685b-c15e-471c-99ca-9d94de159c74	f	\N	\N	\N	\N	6781d49e-0a52-407a-bbd9-57152fa52741	6781d49e-0a52-407a-bbd9-57152fa52741	재생토너 제조및 판매	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/3a5f6b2f-5b95-4013-b0bd-efb3675ab0a5.jpg}	{}	{}	2024-05-02 10:24:35	2024-05-02 10:24:35
dbcaae22-d24d-44b4-a4ff-3d44a6cae3df	f	\N	\N	\N	\N	6781d49e-0a52-407a-bbd9-57152fa52741	6781d49e-0a52-407a-bbd9-57152fa52741	LG전자 B2B 전문점	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/83535343-1c86-47ff-8d57-1eba12fa4037.jpg}	{}	{}	2024-05-03 08:40:06	2024-05-03 08:40:06
b5172b5e-4720-4a6b-abfc-1214dc93fae0	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	프로다오 충북 청주지사 들렸다 점심에 명암저수지 르 투어 카페에서.	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/afecd41b-ea0b-4a2e-9d5d-1343ca1c5301.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/1d276047-bd19-45e3-89b9-8ed71a57d1c5.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/ca74db76-2e56-4020-8f22-035bc1c8dd53.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/3a77d1fa-cd54-45a7-81af-6d448f0b5c69.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6357d5fc-08ab-466b-9226-b23b0933c445.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a204697d-8b96-451c-bf7d-f189e44d0f86.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/b93cd982-b4ff-48ee-af85-f056226fed92.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9fe59377-21db-4bd1-a974-a35ea6b5bbba.jpg}	{}	{}	2024-05-06 02:39:44	2024-05-06 02:39:44
f5bbaf5a-4e1a-410e-9761-e8a0041b45d0	f	\N	\N	\N	\N	39144bf1-9a12-4d6d-a814-b769473d158f	39144bf1-9a12-4d6d-a814-b769473d158f	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/b674263f-21e5-4bee-aa88-66b41ef4e304.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/7abfb667-5a35-4591-bef1-44d3351d53b9.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/74a31f10-792f-48eb-a877-c48587b8f3cf.jpg}	{}	{}	2024-05-06 07:24:02	2024-05-06 07:24:02
410c8dd0-64e5-4572-a59b-bc547e04b3b6	f	\N	\N	\N	\N	39144bf1-9a12-4d6d-a814-b769473d158f	39144bf1-9a12-4d6d-a814-b769473d158f	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/0b8ea215-0fda-4494-821c-8b454015dd3b.jpg}	{}	{}	2024-05-06 07:24:34	2024-05-06 07:24:34
37f7bd3d-1dfc-42e5-837d-77c1aa3a91d5	f	\N	\N	\N	\N	691a7808-92eb-4fce-a618-d51867429491	691a7808-92eb-4fce-a618-d51867429491	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/56a85872-ee59-49a1-9a17-3829bacff92e.jpg}	{}	{}	2024-05-06 11:42:59	2024-05-06 11:42:59
e9415f87-aeb2-4287-b8cc-96352512a3a2	f	\N	\N	\N	\N	1543db57-9c36-4a03-b917-401ada53eb22	1543db57-9c36-4a03-b917-401ada53eb22	김동운	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9ee5c67e-cffa-4301-be8a-fec3d099e99f.png}	{}	{}	2024-05-08 01:28:31	2024-05-08 01:28:31
f42ae565-a8b1-4e85-ab28-847fd78e04e9	f	\N	\N	\N	\N	5b316a00-25b2-4fd7-8796-5dbb7f51f948	5b316a00-25b2-4fd7-8796-5dbb7f51f948	불법주차를 기가 막히게 햇네요! 운전자가 안보임..문학경기장 교육중에....	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a0a86b13-035d-4b34-9990-7dca19656080.heic}	{}	{}	2024-05-09 03:25:56	2024-05-09 03:25:56
9a1919bd-8926-47d7-816d-b1b073f32d85	f	\N	\N	\N	\N	1a25e573-3158-4107-bc5b-765cdd926261	1a25e573-3158-4107-bc5b-765cdd926261	Ram stiy	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e023e215-cacd-4a91-8e95-32b110435a03.png}	{}	{}	2024-05-10 08:08:44	2024-05-10 08:08:44
357c089a-f357-49fd-a4e6-195d363c2783	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	제목	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/64ea6efe-600e-4340-b1a8-82e97a4fb588.jpg}	{}	{}	2024-05-19 02:42:47	2024-05-19 02:42:47
6b3c72fd-e9f5-4982-ade2-c038faf4cbee	f	\N	\N	\N	\N	a8af0e64-0ac6-46fb-99f1-6da08eeab725	a8af0e64-0ac6-46fb-99f1-6da08eeab725	키재니아트	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d10a67fc-ea58-4dd1-905f-34553bcfaa49.png}	{}	{}	2024-05-23 13:18:43	2024-05-23 13:18:43
9b7fa87f-11ce-4c9d-ade7-ce7b3b771bd4	f	\N	\N	\N	\N	26714e45-c467-4ca3-9075-e205a203fe52	26714e45-c467-4ca3-9075-e205a203fe52	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/84f982cd-bb66-4fd4-aa5a-ad497f62789d.jpg}	{}	{}	2024-06-02 08:12:34	2024-06-02 08:12:34
e34db164-175a-4a41-b33b-5fd94cd64774	f	\N	\N	\N	\N	c1667389-c459-4ecc-a759-cd2b0d69d687	c1667389-c459-4ecc-a759-cd2b0d69d687	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e56cd5c6-1fce-4be6-a975-1d6ff009ed99.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/3984ae12-f730-44c4-9083-978af94a6821.jpg}	{}	{}	2024-06-05 01:34:10	2024-06-05 01:34:10
c9161785-17fd-4a63-ad3b-757bdcc31668	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	일산 원마운트 스노우파크	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/ccf241c9-967e-4d44-b383-0f105ddc6fa4.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/1bbcb324-88f2-4920-aa06-d8c4ce365230.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/22080cad-bd81-4ad7-abc6-513b9ccc82e2.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/4c220c8d-6b77-40af-adb2-3657e8b2b2fb.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/f1759eb6-563b-4fb2-aa92-a3180edc5230.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d61d5f5c-657e-41ae-93cc-54dedc1db1ca.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/57a83d44-5a72-45b4-9521-d171080434cb.jpg}	{}	{}	2024-06-19 02:46:25	2024-06-19 02:46:25
0b2961ab-b1e6-4eb5-8c78-5b6708c28868	f	\N	\N	\N	\N	7258a2ce-894f-4ce1-a260-84a7452f4d22	7258a2ce-894f-4ce1-a260-84a7452f4d22	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/cae6c2ed-ee2c-4547-948c-6451caa6bc5d.jpg}	{}	{}	2024-06-20 06:40:20	2024-06-20 06:40:20
0d5a33f8-4940-401c-8a25-c98855a9f1e0	f	\N	\N	\N	\N	d05bf38b-f898-4dfc-adcc-dce47a90a1c7	d05bf38b-f898-4dfc-adcc-dce47a90a1c7	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/932c07d0-1f6a-47c7-8c3f-57e7a8e3b25b.png}	{}	{}	2024-06-26 04:14:40	2024-06-26 04:14:40
a3a74215-f4ec-4b9d-af1d-cc4c06339b38	f	\N	\N	\N	\N	1bd86dd9-872f-4a68-8602-a60813df56c8	1bd86dd9-872f-4a68-8602-a60813df56c8	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/5b9ebf2a-dbab-456d-8c5c-9a930227484a.png,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/2654aeea-0695-45c7-8bcc-aaa8043524a1.png,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/b047b844-02a9-465f-9d9c-925acceeafdf.png}	{}	{}	2024-06-26 10:33:23	2024-06-26 10:33:23
e95eb1cd-b6ce-4610-ac55-2936dfd8343c	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	PRODAO	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/3b68115d-245a-4e2b-a360-8840b7bf597a.jpg}	{}	{}	2024-06-27 02:00:04	2024-06-27 02:00:04
f799d15b-53ee-4f58-ba7b-02df7ea97661	f	\N	\N	\N	\N	5dc09e11-8310-4e6b-a8fc-250aadd1e2b2	5dc09e11-8310-4e6b-a8fc-250aadd1e2b2	2024.6월 정기 세미나	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/13d6e98a-d004-4543-ac57-a63f35b316dd.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6f162f1c-eb15-4045-8124-f8ce23ec7467.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/1dc21a3b-6f1d-41a8-ad01-93c0609ca223.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/2ec040a8-786c-4598-9845-d6db636b8716.jpg}	{}	{}	2024-06-28 01:25:26	2024-06-28 01:25:26
a37a47b7-ac91-4187-9c3f-3f544dea7416	f	\N	\N	\N	\N	5dc09e11-8310-4e6b-a8fc-250aadd1e2b2	5dc09e11-8310-4e6b-a8fc-250aadd1e2b2	2024년 6월 정기 세미나	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/2ff6e35f-08a6-49b9-93dc-c69998152fa0.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/14ff7e4d-0dd3-4e9d-a274-43844e5a6064.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a9acca5e-f02d-4910-b904-a778b449e517.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/02e49297-2a3a-4063-854f-4e3d7eb9c4a9.jpg}	{}	{}	2024-06-28 01:27:06	2024-06-28 01:27:06
fa218dbb-c956-4996-900a-17cc4bb3bc6a	f	\N	\N	\N	\N	39144bf1-9a12-4d6d-a814-b769473d158f	39144bf1-9a12-4d6d-a814-b769473d158f	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/989028f8-44d3-4570-9840-e37b59ab3bce.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/13c2a159-f5f1-4d77-b3fb-ecaf6ea330a3.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e6f8334c-b45b-4d56-acf6-bd63df46dc62.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d2f8707e-c7be-42f8-bb04-5d70b9326f63.jpg}	{}	{}	2024-06-29 12:47:07	2024-06-29 12:47:07
1a7b4d3a-3c9b-47a0-bc9d-325cfdf19fec	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	2024 1차 ABLE 정례회의	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d8c034fb-76f8-4b26-a580-50f48c04208a.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e1f0dc46-3c81-4cdb-a15f-b2de0029b5bf.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/3e30418f-ad45-4cde-ac57-ec734f00649f.jpg}	{}	{}	2024-07-02 05:27:10	2024-07-02 05:27:10
deafa47f-4177-41f9-aff2-555778f121db	f	\N	\N	\N	\N	317cf77d-0e89-49b2-82f0-b20073914c0c	317cf77d-0e89-49b2-82f0-b20073914c0c	뉴스	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e8d4fee3-8f01-4d6c-ba04-a48a623f6b7f.png}	{}	{}	2024-09-20 05:21:44	2024-09-20 05:21:44
f7b3b0f8-c1a7-4d5d-b6c2-45cc78822059	f	\N	\N	\N	\N	1b4707dd-eaff-4276-8e8e-2c25fccd068d	1b4707dd-eaff-4276-8e8e-2c25fccd068d	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/b1d08e56-b6fc-4f2b-86d9-7805150b3471.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a3b69367-9c70-47fd-b51c-ff3c3d244a2c.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/01022ce6-7dbe-4860-be8c-83fd7f0cdd7e.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/79a31ee1-474f-4b61-a6bb-d75b259c047b.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/37c9f504-0400-4e0e-a125-5cb41c9071b5.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/fd58ffb5-a9d6-4a45-a7e6-e3013427a9ca.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/51f6b01a-e504-42ca-9939-baff92bc82fe.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/f7453c07-655a-48ce-a94d-93caa02808d6.jpg}	{}	{}	2024-07-12 07:19:00	2024-07-12 07:19:00
fb70325a-db98-450c-b9ec-e61951d1d318	f	\N	\N	\N	\N	7b936d81-9eab-4f66-9f44-f8bfdae9c846	\N	GOOGLE ML BOOTCAMP 참여 2024.06.24~	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/ceb785e2-68cd-4959-8f47-40b17f5cd5ec.png}	{}	{}	2024-07-06 09:27:01	2024-07-06 09:27:01
c4efee09-d4f1-4e64-af4c-dcbc046b7617	f	\N	\N	\N	\N	dab9453b-a30d-44ec-a414-132e953c2408	dab9453b-a30d-44ec-a414-132e953c2408	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/03148f9d-147a-450e-a297-20d2bf8f9176.jpg}	{}	{}	2024-08-07 00:24:32	2024-08-07 00:24:32
619120fc-8aa7-47b5-b980-a89c00461d82	f	\N	\N	\N	\N	dab9453b-a30d-44ec-a414-132e953c2408	dab9453b-a30d-44ec-a414-132e953c2408	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/8b6455b9-e06e-46d8-a201-99468dc8d16b.jpg}	{}	{}	2024-08-07 00:32:36	2024-08-07 00:32:36
3fbfdd85-b331-498f-8ccf-a8721fdc6444	f	\N	\N	\N	\N	7e2a2c9f-ceee-43a9-8c22-b0e99af67bf0	7e2a2c9f-ceee-43a9-8c22-b0e99af67bf0	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/79bf7c40-5063-4899-af14-7cd5eeff1cee.jpg}	{}	{}	2024-08-07 00:33:36	2024-08-07 00:33:36
d6137fda-cde7-4238-9024-486c658b3b99	f	\N	\N	\N	\N	c01b8fb5-23b9-4268-9cb5-c5213d2e6590	c01b8fb5-23b9-4268-9cb5-c5213d2e6590	Virendra Kumar goutam 	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6cf79192-b819-4c3f-8a43-4ae717af2ba7.mp4,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6cf79192-b819-4c3f-8a43-4ae717af2ba7.mp4,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a0f4a9fd-2ba6-4ab7-8214-0da67595b80d.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/aa728138-7cd1-447f-a5de-c697982f50e0.png}	{}	{}	2024-08-14 12:26:30	2024-08-14 12:26:30
da5f9242-f55e-47be-8de9-7eb767b8c4db	f	\N	\N	\N	\N	d751f28d-f47d-4486-8ff8-94358cdf53f7	d751f28d-f47d-4486-8ff8-94358cdf53f7	2024년 여름휴가	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/b2382a8c-074d-47a4-981f-07fc8d90dbd8.jpg}	{}	{}	2024-08-16 08:29:49	2024-08-16 08:29:49
a3abca15-5bfe-4695-8594-89ef61de6eb4	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	PRODAO Ball Marker	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/3dad1353-6eeb-4b9a-9bab-63e56a275b03.jpg}	{}	{}	2024-08-26 06:07:29	2024-08-26 06:07:29
985995c1-5030-4445-8820-a9e3abe1f7e0	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	PRODAO Certificate of Registration From INTELLECTUAL PROPERTY OFFICE THE PHILIPPINES	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/bdb8c05e-eeb7-46f5-a898-9d9354e3f5a6.jpg}	{}	{}	2024-08-28 03:47:14	2024-08-28 03:47:14
6cafeffd-2b48-4e8b-bd26-f8b94a6e6566	f	\N	\N	\N	\N	39144bf1-9a12-4d6d-a814-b769473d158f	39144bf1-9a12-4d6d-a814-b769473d158f	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/7fdd8e04-f2eb-43b6-a40a-6bcaf5291d11.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/38b5b2f5-cd7c-421f-948c-5dc5c69111e8.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/0080d158-cf79-47bc-ab49-efb6fecf65b6.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/aa093f2e-f946-4dbc-9e8a-4ba19b28a7e2.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/337c6be9-f723-4d67-9502-cfb63e9a0284.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/f73230fd-86d5-4c25-bc43-3308476b7bcb.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/2135a41c-208b-4a12-b783-2564ab616306.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/4240a4c7-9974-4839-9942-7c331af8c6d4.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/bf112f6c-a8e1-4ad4-b7e3-86251678f846.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/4df2cafd-32c4-46f3-a405-9e5b0bb89017.jpg}	{}	{}	2024-08-29 23:46:51	2024-08-29 23:46:51
9a2a31dd-608a-4ce4-bcd8-27cc46ff22a6	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	PRODAO, 뉴욕일보, 뉴욕엑스포 MOU, 신안경영품질원/Allserdao	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/fc61358b-4155-4746-843d-f04b0573b589.jpg}	{}	{}	2024-08-30 04:17:21	2024-08-30 04:17:21
e94ceb32-c95f-46bb-b6f5-ecae8e056e20	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	2024-4차 세종 국방사이버안보포럼.	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/83f41f4e-f8ac-481e-8be3-2686ff82dc5a.jpg}	{}	{}	2024-09-09 22:42:12	2024-09-09 22:42:12
6fc2b9ba-aa52-42d7-9d99-365f61ed15ae	f	\N	\N	\N	\N	3d328497-971a-4cca-b0e6-6d959503bac0	3d328497-971a-4cca-b0e6-6d959503bac0	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/2a1d761a-090d-48e7-8f48-9b39b4430b0d.jpg}	{}	{}	2024-09-10 08:13:01	2024-09-10 08:13:01
6c43556f-c51c-47f2-aac8-bbd8a78f72bc	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/61a79aec-fe9a-402b-8167-4689d83bd595.jpg}	{}	{}	2024-09-28 12:58:44	2024-09-28 12:58:44
aaeeda75-35e1-41e5-8995-74f7cf4748c7	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/76a8ab48-4ed7-4dc1-a182-ca5039935cc0.jpg}	{}	{}	2024-09-28 21:02:56	2024-09-28 21:02:56
eaf2bf52-697a-4311-a409-90a6abeaf069	f	\N	\N	\N	\N	7b936d81-9eab-4f66-9f44-f8bfdae9c846	\N	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/dff54362-f95d-4faa-883f-bbafe8409899.jpg}	{}	{}	2024-09-19 15:51:28	2024-09-19 15:51:28
9e845cc7-6dfc-487d-9b0e-fb06aad0933b	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/84349e97-bc78-4241-9dcb-5eec40184529.jpg}	{}	{}	2024-09-28 21:04:26	2024-09-28 21:04:26
ea711b33-7dfb-4005-910f-d0e369bae886	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	글로벌 안양성문 비즈센터 오픈	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/3c18f6db-addb-451e-89b6-76fce205d5d4.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/237218c5-61bb-4ef2-80cf-2708d3095c02.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/31e90ea0-10a2-48ee-a606-3bae303f413c.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d9974005-2db0-4fdf-b07f-d503c84c62fc.jpg}	{}	{}	2024-09-30 03:08:35	2024-09-30 03:08:35
3423cb25-6fdc-46bd-93b7-767d501b9799	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	글로벌 안양성문 비즈센터	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/524bd746-1a9a-4d3b-ba33-3a43e5aa1ef3.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/569bbcbd-ae51-49ca-9028-6ebfd261b2d8.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/499e2be1-baac-4d8e-b7ac-40b1747c37b8.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/978123c5-6d08-44fe-b0e7-8cf9e23456f2.jpg}	{}	{}	2024-09-30 03:08:36	2024-09-30 03:08:36
4e3046a5-3ecb-4c64-a43a-6725f7200c98	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	바로셀로나 Blockchain For All 전시회 준비로 숙소 주변 현지도착 154	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d42ee141-8add-4c3d-a74a-4a91c20f91b3.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a7dabb71-80a2-44eb-a455-f90733fc3c3a.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6b058469-54c2-4888-ae37-4643190122b2.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/574d3852-567f-4483-ba08-a114be1d4364.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e5730203-238a-41e6-925d-004245c6f327.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/51534238-3a50-4e4f-82f4-8cd82346b106.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9b24ef47-8509-404f-9fac-66ea701681a9.jpg}	{}	{}	2024-10-01 20:30:45	2024-10-01 20:30:45
a1661365-0869-45ca-87b8-267d88925093	f	\N	\N	\N	\N	c88e824b-4488-4d90-a69c-cfb61fbe4791	c88e824b-4488-4d90-a69c-cfb61fbe4791	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/2600a328-89e1-4090-9d87-ffd60ac12ae5.jpg}	{}	{}	2024-10-02 13:14:37	2024-10-02 13:14:37
ebd62db1-e26e-433c-8389-e42f84e4ec1e	f	\N	\N	\N	\N	c88e824b-4488-4d90-a69c-cfb61fbe4791	c88e824b-4488-4d90-a69c-cfb61fbe4791	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/1d66068f-8c93-48a7-bc1c-f97417e27aae.jpg}	{}	{}	2024-10-02 13:15:03	2024-10-02 13:15:03
f511d4c9-d25e-4bb1-b0b2-91fded5d57c2	f	\N	\N	\N	\N	c88e824b-4488-4d90-a69c-cfb61fbe4791	c88e824b-4488-4d90-a69c-cfb61fbe4791	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/1df2bf30-f7a1-4f57-8bbc-842074a49bf7.jpg}	{}	{}	2024-10-02 13:15:29	2024-10-02 13:15:29
23d3d44a-93f2-4c3c-8d5f-28b7b99bee84	f	\N	\N	\N	\N	c88e824b-4488-4d90-a69c-cfb61fbe4791	c88e824b-4488-4d90-a69c-cfb61fbe4791	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/ab48d184-ff73-4644-8134-0f427a8b0426.jpg}	{}	{}	2024-10-02 13:16:02	2024-10-02 13:16:02
590a6f35-d8d1-4ced-b4e3-a52dd70fe95c	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	프로다오 와인 병에 직접 그림을 그려 글로벌에 수출	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c9fd6407-d5a5-4f46-b69d-6ae3c5a2f7fe.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/ac7e6dbe-d87e-4daf-9573-13845b29bb7c.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/3ff10e80-7c6c-4e59-b026-b5be3433170f.jpg}	{}	{}	2024-10-03 09:16:45	2024-10-03 09:16:45
3670d74b-4562-42c9-b35f-c299e78b92a8	f	\N	\N	\N	\N	f270fd28-1c02-46bf-ac9c-8179ed1185bb	f270fd28-1c02-46bf-ac9c-8179ed1185bb	prodao LA 모임	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/f2f830f1-c54d-4b2f-8b83-a2eb5b5c40ad.jpg}	{}	{}	2024-10-14 22:16:12	2024-10-14 22:16:12
5677a540-5d48-441a-82ed-de0232577ed0	f	\N	\N	\N	\N	407ae14a-060d-4d91-89d1-39535ab93b0a	407ae14a-060d-4d91-89d1-39535ab93b0a	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/3960d560-fb89-42a3-9b7b-ca25227b7ba0.jpg}	{}	{}	2024-10-14 22:26:48	2024-10-14 22:26:48
87c6e956-5043-450b-b283-c009575e38fd	f	\N	\N	\N	\N	f270fd28-1c02-46bf-ac9c-8179ed1185bb	f270fd28-1c02-46bf-ac9c-8179ed1185bb	meeting ch	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/85533f95-10bb-4c52-94ae-e5a330a5dd92.jpg}	{}	{}	2024-10-14 23:41:50	2024-10-14 23:41:50
f1ed7f99-c182-4871-86e9-a23d2e939f94	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	Tijuana's PRODUCE INC. LA 본사 방문,미전역 51개주 물류 전문업	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/7e44890e-477b-4609-ad74-010cac0ed1ed.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/bc436cd1-5c66-4635-b0c8-d5e49ba0c2f1.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/dad93829-6f34-4611-bfda-d580f7e3acaa.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/2a028c7e-847e-499f-966b-2eaf11c54235.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/49337572-7134-4a47-bce3-1c2a89c21289.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e0802569-88af-435f-86d9-2d9918765973.jpg}	{}	{}	2024-10-15 20:56:24	2024-10-15 20:56:24
b501b6ef-0457-4092-8621-73237b98e3c4	f	\N	\N	\N	\N	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	Test	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6cd9a4c3-8761-49e8-909f-269c7c4907a3.jpg}	{}	{}	2024-10-15 23:44:27	2024-10-15 23:44:27
f5e14ff9-b0f9-4e0d-b80a-0642c02c7c05	f	\N	\N	\N	\N	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	Test	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c692435e-ad39-4da0-83e1-e9c43f498bb7.jpg}	{}	{}	2024-10-15 23:44:27	2024-10-15 23:44:27
01271f93-e83e-4d93-82c5-4c1e62f64054	f	\N	\N	\N	\N	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	7c4109d1-4cbc-46ba-894e-a0e9fc824ed4	Test	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/00c7378a-2ab7-4a4f-9132-1ac7a9e28f17.jpg}	{}	{}	2024-10-15 23:44:27	2024-10-15 23:44:27
80575225-e75c-4a2a-ad5a-f9ba5ab5868a	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	KOTRA 미국 로스앤젤레스 무역관 방문	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6544f732-c978-44a2-9e8b-fa0beffa7c39.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e6cb10c5-3215-4da0-a3bf-00df08869cf4.jpg}	{}	{}	2024-10-18 18:11:16	2024-10-18 18:11:16
5c39cb9a-748a-4167-9077-7b931be2bad7	f	\N	\N	\N	\N	f270fd28-1c02-46bf-ac9c-8179ed1185bb	f270fd28-1c02-46bf-ac9c-8179ed1185bb	coffee meeting	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/f54a2f8c-83d7-4ae9-bd07-03ef3fb0c7f7.jpg}	{}	{}	2024-10-22 21:10:56	2024-10-22 21:10:56
2b041ccb-2dab-4f13-af4e-300a38857c54	f	\N	\N	\N	\N	eab0bcf1-82f3-40db-82fb-ace10ee4a383	eab0bcf1-82f3-40db-82fb-ace10ee4a383	저작권	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/db8208ad-6cab-481b-a8e1-9a5260f721e8.jpg}	{}	{}	2024-10-25 04:15:33	2024-10-25 04:15:33
40c358e0-3aa1-4452-a75f-408f4a71f284	f	\N	\N	\N	\N	eab0bcf1-82f3-40db-82fb-ace10ee4a383	eab0bcf1-82f3-40db-82fb-ace10ee4a383	저작권	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/12dc2049-9c58-4275-b734-95e946bc43ae.jpg}	{}	{}	2024-10-25 04:15:34	2024-10-25 04:15:34
ba52f468-90da-4702-ad5a-65c214f9fa59	f	\N	\N	\N	\N	f270fd28-1c02-46bf-ac9c-8179ed1185bb	f270fd28-1c02-46bf-ac9c-8179ed1185bb	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9aac1d25-0237-4969-88b7-e75cf73ac688.jpg}	{}	{}	2024-10-25 15:20:42	2024-10-25 15:20:42
e1bb9d85-1265-4308-bce1-ab45cc5588f5	f	\N	\N	\N	\N	f270fd28-1c02-46bf-ac9c-8179ed1185bb	f270fd28-1c02-46bf-ac9c-8179ed1185bb	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/20dd3d2c-ec7e-4ea2-b0a7-5eae18328db2.jpg}	{}	{}	2024-10-25 15:21:47	2024-10-25 15:21:47
a569bbe3-85d3-4481-9f2d-a49a6f87faf1	f	\N	\N	\N	\N	454a1603-bd8c-4a65-a89f-b8cedd28dd76	454a1603-bd8c-4a65-a89f-b8cedd28dd76	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d4572a27-75af-42e1-9f06-7fbe9b29e8ee.jpg}	{}	{}	2024-10-27 16:00:14	2024-10-27 16:00:14
ff2f8180-4b97-471c-866a-1b4e8aee7948	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	맨하튼허드슨엣지빌딩 103층	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/498d5311-45ba-4dea-bdcf-015fe7ddf221.jpg}	{}	{}	2024-10-31 22:41:05	2024-10-31 22:41:05
27f1e4cf-5fcb-4dad-b388-e18eb8c57643	f	\N	\N	\N	\N	05f1ea88-de99-48ad-b7cc-38ed173ba5f6	05f1ea88-de99-48ad-b7cc-38ed173ba5f6	작품명 My pathway 2024년 10월24일	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a314750b-c743-424a-a283-9d4b40aeb54d.jpg}	{}	{}	2024-11-02 18:25:27	2024-11-02 18:25:27
40dba853-87fa-4762-b19d-d3da5b4c23f8	f	\N	\N	\N	\N	072c2418-239b-4944-93f8-da9eb88be608	072c2418-239b-4944-93f8-da9eb88be608	Test picture	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/951396ee-5fe1-45b3-a366-14579e6bb1d8.jpg}	{}	{}	2024-11-05 23:39:17	2024-11-05 23:39:17
cb401369-812d-485b-a7b8-6897a82a11b1	f	\N	\N	\N	\N	072c2418-239b-4944-93f8-da9eb88be608	072c2418-239b-4944-93f8-da9eb88be608	Test picture	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9e645673-e6b3-471e-95e7-9d21aae43283.jpg}	{}	{}	2024-11-05 23:39:17	2024-11-05 23:39:17
9e100a56-979f-41ff-a516-85a7d10c485c	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	프로다오 일본	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/8e7170ba-d475-4cd6-8cbf-6f1a5e93637d.jpg}	{}	{}	2024-11-13 01:00:58	2024-11-13 01:00:58
269fef16-4f23-4786-b93c-c9df6c2242c4	f	\N	\N	\N	\N	7258a2ce-894f-4ce1-a260-84a7452f4d22	7258a2ce-894f-4ce1-a260-84a7452f4d22	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/3faa8a90-dc19-4823-96c5-686530be406d.jpg}	{}	{}	2024-11-23 11:59:53	2024-11-23 11:59:53
69d7e6dc-24a4-4f34-8624-435b92bdafd3	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	프로다오, 충북대학교 융합기술경영혁신센터 업무협력협약 https://www.gukjenews.com/news/articleView.html?idxno=3164452 	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/cbf418fd-fd6e-46d2-8272-c2d2b5c2e70e.jpg}	{}	{}	2024-12-17 09:55:25	2024-12-17 09:55:25
e6c6fefe-9a8b-4dc7-8e44-c0b9d091695d	f	\N	\N	\N	\N	f578ba4f-f883-4dd2-b920-6614af947bd4	f578ba4f-f883-4dd2-b920-6614af947bd4	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d22c4bd6-2766-4ab7-9ab7-5cbfa7ff5413.jpg}	{}	{}	2024-12-19 04:50:09	2024-12-19 04:50:09
b389d8b0-f5fd-48f5-98fd-d03baf193970	f	\N	\N	\N	\N	8a5b931e-b073-4af9-a916-4b214183a825	8a5b931e-b073-4af9-a916-4b214183a825	암호화폐	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/08d50422-f5cf-4a68-a824-3ac9580050fd.jpg}	{}	{}	2024-12-19 10:34:17	2024-12-19 10:34:17
e0ed5c13-52cf-4ad6-8290-25d46d6141e4	f	\N	\N	\N	\N	8a5b931e-b073-4af9-a916-4b214183a825	8a5b931e-b073-4af9-a916-4b214183a825	블록체인	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9dead3b0-13bb-4eb7-84dc-5a2cf3d6be7e.jpg}	{}	{}	2024-12-19 10:35:38	2024-12-19 10:35:38
2f9b7805-b531-4f55-8307-bf9ca06ea6ef	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	뉴욕일보 오프라인 신문보도 자료 미 뉴저지주 포트리 커뮤니티 센터에서.	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/73c3555d-800f-4f18-9f00-80a01f280893.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c59e1d05-a710-408d-aacb-d5140c02e67b.jpg}	{}	{}	2024-10-25 14:28:54	2024-10-25 14:28:54
02a65baf-b959-452c-8c97-ba5cec0cb231	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	자유의 여신상은 미국을 대표하는 상징적인 조각상으로, 뉴욕 항구 입구의 리버티 섬에 위치해 있습니다. 프랑스에서 미국 독립 100주년을 기념하여 선물한 이 조각상은 자유, 민주주의, 그리고 이민의 상징으로 전 세계적으로 알려져 있습니다.	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/55ceabf0-3507-49f9-93ea-7ead67706149.jpg}	{}	{}	2024-11-02 18:02:51	2024-11-02 18:02:51
83f8f5ef-90f0-47a3-8919-6af9f831b8be	f	\N	\N	\N	\N	7b936d81-9eab-4f66-9f44-f8bfdae9c846	\N	대표님과 커피한잔	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/0620874f-db46-483e-a859-5a70c8b28316.jpg}	{}	{}	2024-07-23 05:19:10	2024-07-23 05:19:10
95631af8-2876-4653-9ef1-81502455f201	f	\N	\N	\N	\N	7b936d81-9eab-4f66-9f44-f8bfdae9c846	\N	메세지 테스트	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/1ac10141-197d-4142-bc11-fb660a0af3e1.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/38b2a758-ea65-44bb-b4e8-56509bdf4030.jpg}	{}	{}	2024-07-24 03:46:46	2024-07-24 03:46:46
7fba6cc7-b501-47b2-9353-cc33f86452ca	f	\N	\N	\N	\N	8a5b931e-b073-4af9-a916-4b214183a825	8a5b931e-b073-4af9-a916-4b214183a825	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/3e3daaf5-cb75-4e49-8270-633a5c95c9fa.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/475cb023-0451-4905-ba69-a69868d33f09.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/bbc22325-731d-41de-92b5-bcd404bfdf5d.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c21e3615-90f4-485f-a450-35237afd12f3.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/8974fb13-8875-40de-bb14-4acddf44bab8.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/3980fb19-4ade-4207-9a82-a65c4e0aa137.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c08b910e-d0ce-4f5f-8aa1-c0c06893baa4.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/eaa3b941-d330-433c-83d2-6de80aa6a010.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e2100adb-37db-4964-8c80-811fdd1eb455.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/1a56685b-fb8b-47e9-ae57-316d43370667.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c5c7fdd0-279f-472f-a19d-75c7f6cefd2f.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a26e7ec3-b5b7-4d4e-bfc7-718c9c429530.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/60fd63f3-b134-4373-864a-083b50a8c862.jpg}	{}	{}	2024-12-19 10:28:59	2024-12-19 10:28:59
4d33480d-baba-4838-891c-467fefae9c21	f	\N	\N	\N	\N	8a5b931e-b073-4af9-a916-4b214183a825	8a5b931e-b073-4af9-a916-4b214183a825	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e1023af9-d50c-4b9b-8893-14db2935112c.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/8ec41228-d050-4d9a-aae4-f6a616e9e1bb.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/38ae397b-2b0b-43cc-b97f-6ab99ec20447.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/61035352-51e9-499e-8d62-cbc3d7b32191.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a9083da8-da6e-4c78-a776-861b746d49f7.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9fffc0ff-6d51-46f0-a3b3-d12b0e4c9c2e.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a8cc9807-8eb2-4a66-bc1a-e08a8febfcdb.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/226b5a1d-5bdb-4d83-8d11-642055060c41.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/0e2fd5c9-28bf-4e6b-9ada-dd3a9048b8cf.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/1bcb8e16-74b9-4f52-8eb8-7c53430d12fb.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/0dea3590-cbcc-4396-9c15-625517ea760b.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d7edc3fe-81d3-4ae2-ac85-ac615e140843.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d4017e65-5c4b-499e-b037-441fe8b55692.jpg}	{}	{}	2024-12-19 10:28:59	2024-12-19 10:28:59
a4d94eff-2146-49b1-94a3-1a614e16642f	f	\N	\N	\N	\N	8a5b931e-b073-4af9-a916-4b214183a825	8a5b931e-b073-4af9-a916-4b214183a825	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/87be5bce-52e6-41ac-b256-61cb4922ae7d.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/df40a83d-4597-4c96-b780-e0621da86c27.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/65a6b71c-caba-4af1-bda7-663be37eb1c9.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c5305d34-c094-4be0-b27f-04d04dfffa24.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/a9103d68-d448-4c21-a016-0f2301128908.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/670baa38-5f31-4d02-bb8f-cc652b743b8d.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/ba2047a5-6c12-46ab-9235-8e51677b4c00.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/1effdc6f-98f6-4d23-9e7d-255648f9c0b3.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/46b44063-c14e-4a58-a5be-0dc6d33d6305.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/581edf3e-6599-4b78-83b5-f301cc0c0030.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/17385804-deee-40dc-8d97-7b456b8721a3.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/b8826f4a-228a-4f3e-a2d4-ed2d166747fb.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/ab030f59-0d80-4f3e-8a17-eac414b68e0f.jpg}	{}	{}	2024-12-19 10:28:59	2024-12-19 10:28:59
1055b731-5605-4e82-9060-bc5137225443	f	\N	\N	\N	\N	4c850cce-3170-46ea-9669-f891b4bad0da	4c850cce-3170-46ea-9669-f891b4bad0da	테스트	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/ad6d71c2-7ee5-4491-b291-9becb1bc292a.jpg}	{}	{}	2024-09-22 06:31:49	2024-09-22 06:31:49
269d7bcb-1b56-4ed9-8590-503f690db3dd	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	맨하튼 크루즈 터미널, 항공모함	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/82495ae4-6122-4be1-a55b-511acb6d9966.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/460f1983-e77f-49f0-bb49-2210a4cb77c2.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/5f425a74-be65-4c9a-8a9c-3726dd31e5ca.jpg}	{}	{}	2024-10-31 19:42:38	2024-10-31 19:42:38
8ea114e3-49b2-42c1-a8ba-cb2226cbc05e	f	\N	\N	\N	\N	8a5b931e-b073-4af9-a916-4b214183a825	8a5b931e-b073-4af9-a916-4b214183a825	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/79a297f1-4d9a-4fd4-81a0-84135f3f86a9.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/91560b17-bae4-4f1a-95ba-4983c2dcdd59.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d7145dcd-57d1-49fc-90c4-cc61bd6934b7.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/df40195f-a87e-49a8-9b94-dbcb287f3aa8.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/0619a0b7-f6e9-40f4-bc5b-1f46685417a6.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/1151ce0a-5397-499b-8841-21b4239bbc1e.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/eac12fee-8581-45bd-b613-e33b87df81ea.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/9c3e60a4-c6fe-492c-bbd0-11bb0c415658.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c7e14a54-b2b5-44a8-bf74-7d51b9f1b65a.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/3022935b-6c50-49d9-9d01-39341a29b5ac.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/ea82253e-a593-4872-9bb3-54610f970f44.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/56356337-7920-43e5-864e-1fce22efe456.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/7a181312-e399-4cac-8a62-e856dd935e35.jpg}	{}	{}	2024-12-19 10:28:59	2024-12-19 10:28:59
747bec8d-a958-4903-a0a2-c1f0ccd92e1a	f	\N	\N	\N	\N	4c850cce-3170-46ea-9669-f891b4bad0da	4c850cce-3170-46ea-9669-f891b4bad0da	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/bc1fdaf8-344e-4880-9de1-a745413da8c6.jpg}	{}	{}	2025-01-05 03:35:48	2025-01-05 03:35:48
c06f59d1-e39f-47e7-9c35-dd82ba74eff2	f	\N	\N	\N	\N	7b936d81-9eab-4f66-9f44-f8bfdae9c846	\N	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/44c606a4-255c-41bc-84f7-d9d12857f39c.jpg}	{}	{}	2024-09-19 16:04:42	2024-09-19 16:04:42
f4493eac-5047-47ec-9784-ea907d0ac992	f	\N	\N	\N	\N	7b936d81-9eab-4f66-9f44-f8bfdae9c846	\N	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/10ec3cff-860a-4cdf-b137-4308fbdc668d.jpg}	{}	{}	2024-09-19 16:21:06	2024-09-19 16:21:06
621658f3-8961-4464-8860-a62c217ae8cd	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	제71회 산기협 조찬세미나 2024년  통상여건 및 세계경제 전망 온라인 방송 실시간 보기	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/896b3076-68d8-4c4e-9f2b-57b5507a7cc3.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/ec6bcee5-ca6e-4a8d-98c7-e826a11dfcc1.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/8c4cc261-ed40-4b2c-919d-63f0e8cacd20.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/d238d0b4-9ad9-47aa-8bee-006d1e987de6.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/80771490-32c5-4fef-9be7-cc1fc4479c1f.jpg}	{}	{}	2024-01-17 22:31:42	2024-01-17 22:31:42
43f48d1c-fbe4-467a-8f8a-465454c9609a	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	뉴욕 맨하튼 허긴스 리버	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/cd247987-a559-4747-8a19-6ff02e054245.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/bcd70b1b-b67f-4bbc-b81f-2e82c3f5ffd0.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/ab2e96e8-5cb1-4682-9161-b36afbb0d629.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/31cae293-94af-488e-b0b6-b5a1e649ac54.jpg}	{}	{}	2024-10-31 20:21:59	2024-10-31 20:21:59
da95c57d-a285-4597-8150-40b279e03d4f	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	바로셀로나 블록체인 FOR ALL 전시회 With DEXT FORCE 과기정통부, 정보통신산업진흥원 지원사업 BLOCKCHAIN FOR ALL in Barcelona, 3 ~ 5 OCTOBER, 2024 	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/6260d53a-8cd5-454d-af55-f14ed7833033.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/11236a07-d614-42c4-b07b-a6dda1f8a1c8.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/74828111-d94e-4525-a844-ab3ad0b20596.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c80aaa92-1a8f-40ee-98e7-84fa802b80c3.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/7879f506-78fc-402c-99a9-85aa6cfbbae1.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e748dad7-75cb-4be1-8129-fba767ac8c23.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/b8248503-4c28-42da-bd62-48998bbdad7e.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/1d45a1d3-3034-4484-b85c-e87cb2690aec.jpg}	{}	{}	2024-10-03 06:16:04	2024-10-03 06:16:04
a0e7dd55-863f-4d7b-a0a7-187e4f1b02e9	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	한미동맹협의회 3대 이취임식 밎 우정 기념 사업 선포식. 로버트 조 총재님, LA현지	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/02332b27-c751-46ae-ad71-d39d9c2e486d.jpg}	{}	{}	2024-10-19 21:23:17	2024-10-19 21:23:17
96bf6a6b-3607-429c-84a4-4536180e2b97	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	HOLLYWOOD, State of California	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/78c0585c-74c7-4c95-89c2-7fb28b944745.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/287d5057-2598-4f90-a21b-58ff0f3445ec.jpg}	{}	{}	2024-10-19 10:40:28	2024-10-19 10:40:28
942503b7-b1df-4432-8d72-5a6c4659777c	f	\N	\N	\N	\N	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	c43d7b3d-41ef-47a5-84e7-43d8b8b5d091	LA에서 뉴저지로 이동중 https://maps.app.goo.gl/zvuBxVKNhKFU9Qhd6	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/b7edc793-233b-46ba-8747-97c6f9d3ffca.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e1f500cd-c490-42e1-a436-f08c1db332ad.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/652200cc-f4e7-40af-8700-e8ace35e6991.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/1d4ba394-aa6c-4905-9df4-ad9c74ba40f6.jpg}	{}	{}	2024-10-24 23:51:28	2024-10-24 23:51:28
2245c7ae-2ed5-47ed-93d9-69ca45248073	f	\N	\N	\N	\N	7b936d81-9eab-4f66-9f44-f8bfdae9c846	\N	ㄹㄹ	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/e63a9518-d1c0-4ade-a20d-82f7fb683dfd.jpg}	{}	{}	2024-09-28 14:35:34	2024-09-28 14:35:34
306c6575-22de-4e28-b6d2-3e35b405df15	f	\N	\N	\N	\N	7b936d81-9eab-4f66-9f44-f8bfdae9c846	\N	ㄲㅎㅎㅎ	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/8394210d-1f2f-4e05-893d-2a9e000e0b10.jpg}	{}	{}	2024-09-28 14:48:35	2024-09-28 14:48:35
2dafbe8c-afdf-47d5-9cb2-0c82b559aa49	f	\N	\N	\N	\N	7b936d81-9eab-4f66-9f44-f8bfdae9c846	\N	ㅕ	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/c2cdac07-ce22-4b42-8ce7-adfef00c4cb1.jpg}	{}	{}	2024-09-28 22:19:34	2024-09-28 22:19:34
97e953e9-8f05-4a2c-96f1-3c82a1625747	f	\N	\N	\N	\N	4ed87d97-7769-4bdb-8686-c89536cedb23	\N	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/f86be213-e14e-4ee8-8515-c6dacd1757ab.jpg}	{}	{}	2024-08-03 11:14:17	2024-08-03 11:14:17
451f0a52-3d20-499a-873c-9e84a2f7ef4e	f	\N	\N	\N	\N	4ed87d97-7769-4bdb-8686-c89536cedb23	\N	\N	0	{https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/dc3fa03d-914b-439c-9522-e5e1aa5fdbc8.png,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/36670c3d-8f87-4329-b073-84a5eed66c3d.jpg,https://prd-prodao.s3.ap-northeast-2.amazonaws.com/media/dc3fa03d-914b-439c-9522-e5e1aa5fdbc8.png}	{}	{}	2024-06-25 04:44:40	2024-06-25 04:44:40
\.


--
-- Data for Name: wallet; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wallet (did, membership_type, created_at, updated_at, registration_source) FROM stdin;
X35UVE	free	2024-07-09 22:04:45+09	2024-07-09 22:04:45+09	partner_app
X3E5M6	free	2024-02-02 23:16:28+09	2024-02-02 23:16:28+09	partner_app
X4P2B3	free	2024-02-05 05:21:22+09	2024-02-05 05:21:22+09	partner_app
X4RO98	free	2024-07-10 06:20:00+09	2024-07-10 06:20:00+09	partner_app
X6SA8D	free	2024-02-20 19:10:27+09	2024-02-20 19:10:27+09	partner_app
X75UVE	free	2024-07-29 07:14:02+09	2024-07-29 07:14:02+09	partner_app
X8DJN1	free	2024-07-26 16:22:33+09	2024-07-26 16:22:33+09	partner_app
X8RO98	free	2024-07-30 14:00:07+09	2024-07-30 14:00:07+09	partner_app
XASA8D	free	2024-03-20 12:10:06+09	2024-03-20 12:10:06+09	partner_app
XB5UVE	free	2024-09-20 05:16:32+09	2024-09-20 05:16:32+09	partner_app
XBDJN1	free	2024-08-14 08:24:46+09	2024-08-14 08:24:46+09	partner_app
XC2MY4	free	2024-08-29 23:53:53+09	2024-08-29 23:53:53+09	partner_app
XCGRKB	free	2024-10-12 01:40:11+09	2024-10-12 01:40:11+09	partner_app
XGSA8D	free	2024-04-16 14:13:04+09	2024-04-16 14:13:04+09	partner_app
XHFRKB	free	2023-11-23 08:15:33+09	2023-11-23 08:15:33+09	partner_app
XI38X9	free	2024-05-13 04:11:58+09	2024-05-13 04:11:58+09	partner_app
XK4UVE	free	2024-02-03 17:52:54+09	2024-02-03 17:52:54+09	partner_app
XKE5M6	free	2024-06-11 04:33:52+09	2024-06-11 04:33:52+09	partner_app
XM1MY4	free	2024-02-06 23:17:43+09	2024-02-06 23:17:43+09	partner_app
XM38X9	free	2024-07-10 22:17:03+09	2024-07-10 22:17:03+09	partner_app
XME5M6	free	2024-07-09 21:26:49+09	2024-07-09 21:26:49+09	partner_app
XNCJN1	free	2024-02-17 05:17:15+09	2024-02-17 05:17:15+09	partner_app
XNFRKB	free	2024-02-19 16:20:38+09	2024-02-19 16:20:38+09	partner_app
XNSA8D	free	2024-07-14 05:58:39+09	2024-07-14 05:58:39+09	partner_app
XOQO98	free	2024-02-20 09:26:07+09	2024-02-20 09:26:07+09	partner_app
XQ4UVE	free	2024-03-13 08:20:44+09	2024-03-13 08:20:44+09	partner_app
XRFRKB	free	2024-03-14 07:54:32+09	2024-03-14 07:54:32+09	partner_app
XS38X9	free	2024-08-14 12:16:59+09	2024-08-14 12:16:59+09	partner_app
XU4UVE	free	2024-03-28 06:21:23+09	2024-03-28 06:21:23+09	partner_app
XVFRKB	free	2024-04-01 08:25:18+09	2024-04-01 08:25:18+09	partner_app
XVSA8D	free	2024-11-16 18:11:15+09	2024-11-16 18:11:15+09	partner_app
Y02MY4	free	2024-05-08 03:37:56+09	2024-05-08 03:37:56+09	partner_app
Y238X9	free	2024-01-15 01:02:33+09	2024-01-15 01:02:33+09	partner_app
Y35UVE	free	2024-07-09 23:29:02+09	2024-07-09 23:29:02+09	partner_app
Y42MY4	free	2024-07-09 20:53:47+09	2024-07-09 20:53:47+09	partner_app
Y438X9	free	2024-02-17 07:47:14+09	2024-02-17 07:47:14+09	partner_app
Y5GRKB	free	2024-07-13 15:31:11+09	2024-07-13 15:31:11+09	partner_app
Y638X9	free	2024-02-20 09:27:31+09	2024-02-20 09:27:31+09	partner_app
Y65UVE	free	2024-07-24 05:38:50+09	2024-07-24 05:38:50+09	partner_app
Y838X9	free	2024-03-12 10:54:32+09	2024-03-12 10:54:32+09	partner_app
Y938X9	free	2024-03-14 01:18:24+09	2024-03-14 01:18:24+09	partner_app
Y9E5M6	free	2024-03-13 05:29:31+09	2024-03-13 05:29:31+09	partner_app
Y9GRKB	free	2024-08-11 08:30:12+09	2024-08-11 08:30:12+09	partner_app
YB38X9	free	2024-03-23 13:06:56+09	2024-03-23 13:06:56+09	partner_app
YCSA8D	free	2024-03-26 22:30:55+09	2024-03-26 22:30:55+09	partner_app
YD5UVE	free	2024-12-03 22:21:55+09	2024-12-03 22:21:55+09	partner_app
YDDJN1	free	2024-09-29 03:16:32+09	2024-09-29 03:16:32+09	partner_app
YEE5M6	free	2024-04-02 11:11:59+09	2024-04-02 11:11:59+09	partner_app
YF38X9	free	2024-04-13 13:19:20+09	2024-04-13 13:19:20+09	partner_app
YG38X9	free	2024-04-15 22:46:55+09	2024-04-15 22:46:55+09	partner_app
YH1MY4	free	2023-11-15 08:38:04+09	2023-11-15 08:38:04+09	partner_app
YHE5M6	free	2024-04-17 12:52:20+09	2024-04-17 12:52:20+09	partner_app
YICJN1	free	2023-11-20 05:00:16+09	2023-11-20 05:00:16+09	partner_app
YKE5M6	free	2024-06-11 08:08:46+09	2024-06-11 08:08:46+09	partner_app
YKSA8D	free	2024-06-29 05:52:34+09	2024-06-29 05:52:34+09	partner_app
YLCJN1	free	2024-01-11 05:23:48+09	2024-01-11 05:23:48+09	partner_app
YMCJN1	free	2024-02-04 23:23:35+09	2024-02-04 23:23:35+09	partner_app
YMFRKB	free	2024-02-17 15:24:27+09	2024-02-17 15:24:27+09	partner_app
YP1MY4	free	2024-02-20 13:10:03+09	2024-02-20 13:10:03+09	partner_app
YP38X9	free	2024-07-27 15:57:43+09	2024-07-27 15:57:43+09	partner_app
YPQO98	free	2024-02-21 06:11:03+09	2024-02-21 06:11:03+09	partner_app
YQSA8D	free	2024-08-08 16:11:15+09	2024-08-08 16:11:15+09	partner_app
YS38X9	free	2024-08-14 12:55:43+09	2024-08-14 12:55:43+09	partner_app
YTCJN1	free	2024-03-15 04:09:00+09	2024-03-15 04:09:00+09	partner_app
YUQO98	free	2024-03-26 03:25:39+09	2024-03-26 03:25:39+09	partner_app
YV4UVE	free	2024-04-02 15:47:33+09	2024-04-02 15:47:33+09	partner_app
YVE5M6	free	2024-10-21 13:39:16+09	2024-10-21 13:39:16+09	partner_app
YW38X9	free	2024-12-19 08:38:50+09	2024-12-19 08:38:50+09	partner_app
Z02MY4	free	2024-05-08 07:23:03+09	2024-05-08 07:23:03+09	partner_app
Z0RO98	free	2024-05-10 20:31:48+09	2024-05-10 20:31:48+09	partner_app
Z12MY4	free	2024-05-17 02:14:31+09	2024-05-17 02:14:31+09	partner_app
Z22MY4	free	2024-06-07 06:49:37+09	2024-06-07 06:49:37+09	partner_app
Z2DJN1	free	2024-05-28 16:21:52+09	2024-05-28 16:21:52+09	partner_app
Z2GRKB	free	2024-06-27 08:20:36+09	2024-06-27 08:20:36+09	partner_app
Z2SA8D	free	2024-02-02 22:24:13+09	2024-02-02 22:24:13+09	partner_app
Z3GRKB	free	2024-07-09 20:08:06+09	2024-07-09 20:08:06+09	partner_app
Z52MY4	free	2024-07-11 17:10:00+09	2024-07-11 17:10:00+09	partner_app
Z5GRKB	free	2024-07-13 16:58:18+09	2024-07-13 16:58:18+09	partner_app
Z6RO98	free	2024-07-15 03:37:07+09	2024-07-15 03:37:07+09	partner_app
Z9GRKB	free	2024-08-11 12:16:37+09	2024-08-11 12:16:37+09	partner_app
ZA5UVE	free	2024-08-15 04:06:39+09	2024-08-15 04:06:39+09	partner_app
ZCDJN1	free	2024-08-15 11:06:18+09	2024-08-15 11:06:18+09	partner_app
ZERO98	free	2024-12-08 15:00:30+09	2024-12-08 15:00:30+09	partner_app
ZGE5M6	free	2024-04-14 23:02:35+09	2024-04-14 23:02:35+09	partner_app
ZHP2B3	free	2024-04-16 10:26:53+09	2024-04-16 10:26:53+09	partner_app
ZISA8D	free	2024-05-21 09:24:24+09	2024-05-21 09:24:24+09	partner_app
00GRKB	free	2024-05-07 15:05:53+09	2024-05-07 15:05:53+09	partner_app
00P2B3	free	2023-11-15 00:40:11+09	2023-11-15 00:40:11+09	partner_app
01P2B3	free	2023-11-23 08:15:32+09	2023-11-23 08:15:32+09	partner_app
022MY4	free	2024-05-17 10:30:57+09	2024-05-17 10:30:57+09	partner_app
02RO98	free	2024-05-26 16:10:33+09	2024-05-26 16:10:33+09	partner_app
032MY4	free	2024-06-08 11:40:22+09	2024-06-08 11:40:22+09	partner_app
002MY4	free	2024-04-16 14:04:51+09	2025-02-03 19:11:30.004+09	partner_app
04P2B3	free	2024-01-17 05:55:57+09	2024-01-17 05:55:57+09	partner_app
04RO98	free	2024-07-09 10:26:43+09	2024-07-09 10:26:43+09	partner_app
0538X9	free	2024-02-17 09:36:39+09	2024-02-17 09:36:39+09	partner_app
05GRKB	free	2024-07-11 08:48:51+09	2024-07-11 08:48:51+09	partner_app
05RO98	free	2024-07-10 10:38:26+09	2024-07-10 10:38:26+09	partner_app
065UVE	free	2024-07-15 01:50:43+09	2024-07-15 01:50:43+09	partner_app
06E5M6	free	2024-02-19 07:02:01+09	2024-02-19 07:02:01+09	partner_app
08RO98	free	2024-07-26 12:26:40+09	2024-07-26 12:26:40+09	partner_app
0CE5M6	free	2024-03-21 05:32:21+09	2024-03-21 05:32:21+09	partner_app
0CP2B3	free	2024-03-15 10:28:23+09	2024-03-15 10:28:23+09	partner_app
8ZD5M6	free	2023-11-13 00:03:17+09	2025-02-10 15:01:55.106+09	mobile_app
0D2MY4	free	2024-08-30 02:43:12+09	2024-08-30 02:43:12+09	partner_app
0I1MY4	free	2023-11-15 10:47:18+09	2023-11-15 10:47:18+09	partner_app
0I38X9	free	2024-04-30 21:27:47+09	2024-04-30 21:27:47+09	partner_app
0KSA8D	free	2024-06-10 06:46:23+09	2024-06-10 06:46:23+09	partner_app
0N4UVE	free	2024-02-19 11:51:01+09	2024-02-19 11:51:01+09	partner_app
0OFRKB	free	2024-02-19 19:22:02+09	2024-02-19 19:22:02+09	partner_app
0QE5M6	free	2024-07-23 11:20:40+09	2024-07-23 11:20:40+09	partner_app
0QFRKB	free	2024-02-26 22:59:27+09	2024-02-26 22:59:27+09	partner_app
0S4UVE	free	2024-03-14 23:28:06+09	2024-03-14 23:28:06+09	partner_app
0WCJN1	free	2024-03-26 09:10:04+09	2024-03-26 09:10:04+09	partner_app
0XFRKB	free	2024-04-04 15:23:50+09	2024-04-04 15:23:50+09	partner_app
0Y1MY4	free	2024-04-05 01:41:43+09	2024-04-05 01:41:43+09	partner_app
0Z4UVE	free	2024-04-18 10:44:20+09	2024-04-18 10:44:20+09	partner_app
10GRKB	free	2024-05-07 15:17:12+09	2024-05-07 15:17:12+09	partner_app
11E5M6	free	2023-11-24 03:34:41+09	2023-11-24 03:34:41+09	partner_app
13E5M6	free	2024-01-04 01:49:03+09	2024-01-04 01:49:03+09	partner_app
13GRKB	free	2024-06-27 08:22:30+09	2024-06-27 08:22:30+09	partner_app
13RO98	free	2024-06-17 08:55:50+09	2024-06-17 08:55:50+09	partner_app
14DJN1	free	2024-06-19 15:25:21+09	2024-06-19 15:25:21+09	partner_app
1538X9	free	2024-02-17 11:47:19+09	2024-02-17 11:47:19+09	partner_app
15GRKB	free	2024-07-11 16:48:02+09	2024-07-11 16:48:02+09	partner_app
195UVE	free	2024-08-09 07:07:34+09	2024-08-09 07:07:34+09	partner_app
19DJN1	free	2024-07-27 10:17:47+09	2024-07-27 10:17:47+09	partner_app
19GRKB	free	2024-08-08 12:31:06+09	2024-08-08 12:31:06+09	partner_app
1A2MY4	free	2024-08-08 14:34:52+09	2024-08-08 14:34:52+09	partner_app
1ADJN1	free	2024-08-03 19:22:57+09	2024-08-03 19:22:57+09	partner_app
1ASA8D	free	2024-03-14 12:42:51+09	2024-03-14 12:42:51+09	partner_app
1BE5M6	free	2024-03-14 15:26:21+09	2024-03-14 15:26:21+09	partner_app
1BSA8D	free	2024-03-21 01:23:57+09	2024-03-21 01:23:57+09	partner_app
1C5UVE	free	2024-09-25 14:03:22+09	2024-09-25 14:03:22+09	partner_app
1ESA8D	free	2024-04-02 08:46:25+09	2024-04-02 08:46:25+09	partner_app
1HQO98	free	2023-11-13 01:19:33+09	2023-11-13 01:19:33+09	partner_app
1JQO98	free	2023-11-28 03:31:10+09	2023-11-28 03:31:10+09	partner_app
1KE5M6	free	2024-05-24 14:57:06+09	2024-05-24 14:57:06+09	partner_app
1MCJN1	free	2024-01-14 06:29:07+09	2024-01-14 06:29:07+09	partner_app
1N38X9	free	2024-07-11 00:16:14+09	2024-07-11 00:16:14+09	partner_app
1P1MY4	free	2024-02-20 05:57:49+09	2024-02-20 05:57:49+09	partner_app
1P38X9	free	2024-07-16 02:00:43+09	2024-07-16 02:00:43+09	partner_app
1PQO98	free	2024-02-20 09:26:29+09	2024-02-20 09:26:29+09	partner_app
1R38X9	free	2024-08-08 10:41:14+09	2024-08-08 10:41:14+09	partner_app
1RCJN1	free	2024-02-21 16:31:07+09	2024-02-21 16:31:07+09	partner_app
1SFRKB	free	2024-03-14 10:14:19+09	2024-03-14 10:14:19+09	partner_app
1SQO98	free	2024-03-13 20:23:15+09	2024-03-13 20:23:15+09	partner_app
1TE5M6	free	2024-08-13 11:32:01+09	2024-08-13 11:32:01+09	partner_app
1UCJN1	free	2024-03-15 05:08:39+09	2024-03-15 05:08:39+09	partner_app
1W1MY4	free	2024-03-26 20:10:02+09	2024-03-26 20:10:02+09	partner_app
1W4UVE	free	2024-04-03 06:08:10+09	2024-04-03 06:08:10+09	partner_app
1WFRKB	free	2024-04-01 13:45:22+09	2024-04-01 13:45:22+09	partner_app
1XCJN1	free	2024-04-01 03:11:34+09	2024-04-01 03:11:34+09	partner_app
1XE5M6	free	2024-11-29 14:51:03+09	2024-11-29 14:51:03+09	partner_app
1XFRKB	free	2024-04-04 22:17:19+09	2024-04-04 22:17:19+09	partner_app
1YCJN1	free	2024-04-03 23:37:21+09	2024-04-03 23:37:21+09	partner_app
1ZRA8D	free	2023-11-16 02:31:07+09	2023-11-16 02:31:07+09	partner_app
21DJN1	free	2024-04-26 07:00:01+09	2024-04-26 07:00:01+09	partner_app
22GRKB	free	2024-06-06 16:50:17+09	2024-06-06 16:50:17+09	partner_app
24SA8D	free	2024-02-14 07:09:45+09	2024-02-14 07:09:45+09	partner_app
265UVE	free	2024-07-15 03:33:51+09	2024-07-15 03:33:51+09	partner_app
26DJN1	free	2024-07-10 22:54:14+09	2024-07-10 22:54:14+09	partner_app
272MY4	free	2024-07-14 07:35:05+09	2024-07-14 07:35:05+09	partner_app
285UVE	free	2024-07-30 14:26:28+09	2024-07-30 14:26:28+09	partner_app
2AE5M6	free	2024-03-13 09:17:50+09	2024-03-13 09:17:50+09	partner_app
2ASA8D	free	2024-03-14 13:27:51+09	2024-03-14 13:27:51+09	partner_app
2BP2B3	free	2024-03-14 09:06:30+09	2024-03-14 09:06:30+09	partner_app
2BSA8D	free	2024-03-21 04:40:35+09	2024-03-21 04:40:35+09	partner_app
2D2MY4	free	2024-09-02 03:55:33+09	2024-09-02 03:55:33+09	partner_app
2D38X9	free	2024-03-26 11:12:08+09	2024-03-26 11:12:08+09	partner_app
2DDJN1	free	2024-08-16 03:18:45+09	2024-08-16 03:18:45+09	partner_app
2FP2B3	free	2024-04-01 08:46:40+09	2024-04-01 08:46:40+09	partner_app
2IP2B3	free	2024-04-16 11:42:52+09	2024-04-16 11:42:52+09	partner_app
2KP2B3	free	2024-05-16 04:35:45+09	2024-05-16 04:35:45+09	partner_app
2KQO98	free	2023-12-12 11:21:47+09	2023-12-12 11:21:47+09	partner_app
2L1MY4	free	2023-12-26 02:42:26+09	2023-12-26 02:42:26+09	partner_app
2L38X9	free	2024-06-24 05:33:15+09	2024-06-24 05:33:15+09	partner_app
2LFRKB	free	2024-01-26 02:41:21+09	2024-01-26 02:41:21+09	partner_app
2OFRKB	free	2024-02-20 03:56:52+09	2024-02-20 03:56:52+09	partner_app
2Q4UVE	free	2024-03-09 02:09:51+09	2024-03-09 02:09:51+09	partner_app
2RSA8D	free	2024-08-09 01:41:58+09	2024-08-09 01:41:58+09	partner_app
2SFRKB	free	2024-03-14 10:27:17+09	2024-03-14 10:27:17+09	partner_app
2WP2B3	free	2024-10-12 02:50:44+09	2024-10-12 02:50:44+09	partner_app
2Y4UVE	free	2024-04-15 05:38:38+09	2024-04-15 05:38:38+09	partner_app
2Z4UVE	free	2024-04-18 10:44:30+09	2024-04-18 10:44:30+09	partner_app
30E5M6	free	2023-11-16 23:24:55+09	2023-11-16 23:24:55+09	partner_app
30P2B3	free	2023-11-15 04:38:36+09	2023-11-15 04:38:36+09	partner_app
312MY4	free	2024-05-09 15:32:48+09	2024-05-09 15:32:48+09	partner_app
31E5M6	free	2023-11-27 03:29:02+09	2023-11-27 03:29:02+09	partner_app
335UVE	free	2024-07-09 10:00:49+09	2024-07-09 10:00:49+09	partner_app
35DJN1	free	2024-07-09 19:28:18+09	2024-07-09 19:28:18+09	partner_app
39GRKB	free	2024-08-08 12:38:09+09	2024-08-08 12:38:09+09	partner_app
39RO98	free	2024-07-31 08:05:09+09	2024-07-31 08:05:09+09	partner_app
39SA8D	free	2024-03-13 06:58:02+09	2024-03-13 06:58:02+09	partner_app
3AGRKB	free	2024-08-12 08:34:39+09	2024-08-12 08:34:39+09	partner_app
3BE5M6	free	2024-03-14 18:06:49+09	2024-03-14 18:06:49+09	partner_app
3C38X9	free	2024-03-25 05:58:41+09	2024-03-25 05:58:41+09	partner_app
3C5UVE	free	2024-09-28 04:14:47+09	2024-09-28 04:14:47+09	partner_app
3DP2B3	free	2024-03-25 11:35:11+09	2024-03-25 11:35:11+09	partner_app
3EDJN1	free	2024-10-02 00:45:46+09	2024-10-02 00:45:46+09	partner_app
3EE5M6	free	2024-03-29 01:13:38+09	2024-03-29 01:13:38+09	partner_app
3EGRKB	free	2024-11-13 02:47:54+09	2024-11-13 02:47:54+09	partner_app
3EP2B3	free	2024-03-26 12:52:01+09	2024-03-26 12:52:01+09	partner_app
3FE5M6	free	2024-04-02 23:00:14+09	2024-04-02 23:00:14+09	partner_app
3FSA8D	free	2024-04-05 07:20:24+09	2024-04-05 07:20:24+09	partner_app
3G38X9	free	2024-04-14 05:47:20+09	2024-04-14 05:47:20+09	partner_app
3JP2B3	free	2024-05-07 04:47:38+09	2024-05-07 04:47:38+09	partner_app
3K4UVE	free	2024-01-09 05:09:41+09	2024-01-09 05:09:41+09	partner_app
3KFRKB	free	2023-12-24 02:28:42+09	2023-12-24 02:28:42+09	partner_app
3LCJN1	free	2023-12-16 10:22:48+09	2023-12-16 10:22:48+09	partner_app
3O38X9	free	2024-07-13 04:00:45+09	2024-07-13 04:00:45+09	partner_app
3Q1MY4	free	2024-02-21 01:58:50+09	2024-02-21 01:58:50+09	partner_app
3Q4UVE	free	2024-03-11 04:22:32+09	2024-03-11 04:22:32+09	partner_app
3QFRKB	free	2024-02-28 09:00:04+09	2024-02-28 09:00:04+09	partner_app
3TE5M6	free	2024-08-13 14:28:23+09	2024-08-13 14:28:23+09	partner_app
3TQO98	free	2024-03-15 04:54:55+09	2024-03-15 04:54:55+09	partner_app
3V1MY4	free	2024-03-25 13:23:39+09	2024-03-25 13:23:39+09	partner_app
3VCJN1	free	2024-03-23 23:16:08+09	2024-03-23 23:16:08+09	partner_app
3VE5M6	free	2024-09-25 05:32:44+09	2024-09-25 05:32:44+09	partner_app
3X38X9	free	2025-01-06 05:10:57+09	2025-01-06 05:10:57+09	partner_app
40E5M6	free	2023-11-17 03:38:16+09	2023-11-17 03:38:16+09	partner_app
43DJN1	free	2024-05-31 07:44:28+09	2024-05-31 07:44:28+09	partner_app
442MY4	free	2024-07-02 10:52:27+09	2024-07-02 10:52:27+09	partner_app
44GRKB	free	2024-07-09 20:57:58+09	2024-07-09 20:57:58+09	partner_app
44P2B3	free	2024-01-25 07:19:23+09	2024-01-25 07:19:23+09	partner_app
45RO98	free	2024-07-10 21:19:23+09	2024-07-10 21:19:23+09	partner_app
46P2B3	free	2024-02-17 15:56:00+09	2024-02-17 15:56:00+09	partner_app
46RO98	free	2024-07-12 12:14:45+09	2024-07-12 12:14:45+09	partner_app
4738X9	free	2024-02-20 12:07:07+09	2024-02-20 12:07:07+09	partner_app
48GRKB	free	2024-07-28 15:05:18+09	2024-07-28 15:05:18+09	partner_app
48RO98	free	2024-07-27 04:35:15+09	2024-07-27 04:35:15+09	partner_app
49E5M6	free	2024-03-09 00:02:15+09	2024-03-09 00:02:15+09	partner_app
4AE5M6	free	2024-03-13 10:26:13+09	2024-03-13 10:26:13+09	partner_app
4BRO98	free	2024-08-14 12:10:11+09	2024-08-14 12:10:11+09	partner_app
4CDJN1	free	2024-08-14 13:07:57+09	2024-08-14 13:07:57+09	partner_app
4HP2B3	free	2024-04-14 12:45:29+09	2024-04-14 12:45:29+09	partner_app
4HQO98	free	2023-11-13 01:49:29+09	2023-11-13 01:49:29+09	partner_app
4I38X9	free	2024-05-05 01:26:53+09	2024-05-05 01:26:53+09	partner_app
4J1MY4	free	2023-11-23 08:26:02+09	2023-11-23 08:26:02+09	partner_app
4KFRKB	free	2023-12-24 04:14:21+09	2023-12-24 04:14:21+09	partner_app
4L1MY4	free	2023-12-27 04:48:24+09	2023-12-27 04:48:24+09	partner_app
4LE5M6	free	2024-06-15 10:06:23+09	2024-06-15 10:06:23+09	partner_app
4ME5M6	free	2024-07-09 09:00:41+09	2024-07-09 09:00:41+09	partner_app
4NE5M6	free	2024-07-10 03:18:36+09	2024-07-10 03:18:36+09	partner_app
4Q4UVE	free	2024-03-12 07:12:54+09	2024-03-12 07:12:54+09	partner_app
4WCJN1	free	2024-03-26 10:52:02+09	2024-03-26 10:52:02+09	partner_app
4WP2B3	free	2024-10-14 21:48:37+09	2024-10-14 21:48:37+09	partner_app
4X38X9	free	2025-01-08 05:44:08+09	2025-01-08 05:44:08+09	partner_app
4Y1MY4	free	2024-04-05 03:40:58+09	2024-04-05 03:40:58+09	partner_app
50GRKB	free	2024-05-09 02:52:47+09	2024-05-09 02:52:47+09	partner_app
535UVE	free	2024-07-09 15:25:14+09	2024-07-09 15:25:14+09	partner_app
53DJN1	free	2024-05-31 22:48:30+09	2024-05-31 22:48:30+09	partner_app
5438X9	free	2024-02-06 03:28:20+09	2024-02-06 03:28:20+09	partner_app
54DJN1	free	2024-06-24 04:58:23+09	2024-06-24 04:58:23+09	partner_app
55DJN1	free	2024-07-09 19:32:57+09	2024-07-09 19:32:57+09	partner_app
55E5M6	free	2024-02-17 03:53:05+09	2024-02-17 03:53:05+09	partner_app
5838X9	free	2024-02-26 11:29:52+09	2024-02-26 11:29:52+09	partner_app
58P2B3	free	2024-02-20 12:54:22+09	2024-02-20 12:54:22+09	partner_app
592MY4	free	2024-07-29 03:34:43+09	2024-07-29 03:34:43+09	partner_app
595UVE	free	2024-08-09 16:54:56+09	2024-08-09 16:54:56+09	partner_app
5A2MY4	free	2024-08-08 18:35:37+09	2024-08-08 18:35:37+09	partner_app
5ARO98	free	2024-08-10 08:19:57+09	2024-08-10 08:19:57+09	partner_app
5B2MY4	free	2024-08-13 01:59:22+09	2024-08-13 01:59:22+09	partner_app
5BDJN1	free	2024-08-10 17:40:09+09	2024-08-10 17:40:09+09	partner_app
5BE5M6	free	2024-03-14 23:43:24+09	2024-03-14 23:43:24+09	partner_app
5DE5M6	free	2024-03-26 02:53:19+09	2024-03-26 02:53:19+09	partner_app
5DP2B3	free	2024-03-25 12:02:03+09	2024-03-25 12:02:03+09	partner_app
5ERO98	free	2024-11-05 23:36:29+09	2024-11-05 23:36:29+09	partner_app
5H38X9	free	2024-04-16 11:29:59+09	2024-04-16 11:29:59+09	partner_app
5HSA8D	free	2024-04-18 10:40:57+09	2024-04-18 10:40:57+09	partner_app
5I38X9	free	2024-05-07 03:20:29+09	2024-05-07 03:20:29+09	partner_app
5LSA8D	free	2024-07-09 08:26:08+09	2024-07-09 08:26:08+09	partner_app
5NP2B3	free	2024-07-09 20:34:55+09	2024-07-09 20:34:55+09	partner_app
5O38X9	free	2024-07-13 14:38:10+09	2024-07-13 14:38:10+09	partner_app
5P38X9	free	2024-07-16 11:05:18+09	2024-07-16 11:05:18+09	partner_app
5P4UVE	free	2024-02-21 06:42:58+09	2024-02-21 06:42:58+09	partner_app
5PCJN1	free	2024-02-19 15:34:10+09	2024-02-19 15:34:10+09	partner_app
5PP2B3	free	2024-07-14 00:00:11+09	2024-07-14 00:00:11+09	partner_app
5Q1MY4	free	2024-02-21 05:27:34+09	2024-02-21 05:27:34+09	partner_app
5R38X9	free	2024-08-08 11:40:58+09	2024-08-08 11:40:58+09	partner_app
5VQO98	free	2024-03-26 09:26:07+09	2024-03-26 09:26:07+09	partner_app
5XCJN1	free	2024-04-01 07:27:19+09	2024-04-01 07:27:19+09	partner_app
60DJN1	free	2024-04-16 05:37:00+09	2024-04-16 05:37:00+09	partner_app
60SA8D	free	2023-11-25 09:58:10+09	2023-11-25 09:58:10+09	partner_app
625UVE	free	2024-06-17 10:21:21+09	2024-06-17 10:21:21+09	partner_app
62GRKB	free	2024-06-10 03:05:07+09	2024-06-10 03:05:07+09	partner_app
63SA8D	free	2024-02-03 19:56:12+09	2024-02-03 19:56:12+09	partner_app
64E5M6	free	2024-02-04 03:52:41+09	2024-02-04 03:52:41+09	partner_app
66RO98	free	2024-07-12 16:55:27+09	2024-07-12 16:55:27+09	partner_app
6838X9	free	2024-02-26 11:29:54+09	2024-02-26 11:29:54+09	partner_app
695UVE	free	2024-08-10 00:39:46+09	2024-08-10 00:39:46+09	partner_app
6ARO98	free	2024-08-10 10:36:47+09	2024-08-10 10:36:47+09	partner_app
6CDJN1	free	2024-08-14 14:11:20+09	2024-08-14 14:11:20+09	partner_app
6D2MY4	free	2024-09-10 09:23:01+09	2024-09-10 09:23:01+09	partner_app
6DGRKB	free	2024-10-15 23:44:58+09	2024-10-15 23:44:58+09	partner_app
6FE5M6	free	2024-04-03 06:08:11+09	2024-04-03 06:08:11+09	partner_app
6FP2B3	free	2024-04-02 00:12:46+09	2024-04-02 00:12:46+09	partner_app
6FSA8D	free	2024-04-05 11:44:14+09	2024-04-05 11:44:14+09	partner_app
6G38X9	free	2024-04-14 12:33:01+09	2024-04-14 12:33:01+09	partner_app
6K38X9	free	2024-06-05 03:17:11+09	2024-06-05 03:17:11+09	partner_app
6KQO98	free	2023-12-14 10:11:16+09	2023-12-14 10:11:16+09	partner_app
6LCJN1	free	2023-12-18 09:54:46+09	2023-12-18 09:54:46+09	partner_app
6ME5M6	free	2024-07-09 10:00:19+09	2024-07-09 10:00:19+09	partner_app
6N38X9	free	2024-07-11 08:20:12+09	2024-07-11 08:20:12+09	partner_app
6QE5M6	free	2024-07-24 21:25:31+09	2024-07-24 21:25:31+09	partner_app
6QP2B3	free	2024-07-17 00:30:15+09	2024-07-17 00:30:15+09	partner_app
6TE5M6	free	2024-08-14 02:55:44+09	2024-08-14 02:55:44+09	partner_app
6TP2B3	free	2024-08-12 03:57:06+09	2024-08-12 03:57:06+09	partner_app
6TQO98	free	2024-03-15 09:15:24+09	2024-03-15 09:15:24+09	partner_app
6UE5M6	free	2024-08-15 04:35:27+09	2024-08-15 04:35:27+09	partner_app
6VQO98	free	2024-03-26 09:51:24+09	2024-03-26 09:51:24+09	partner_app
6YCJN1	free	2024-04-04 05:11:11+09	2024-04-04 05:11:11+09	partner_app
722MY4	free	2024-05-24 12:01:24+09	2024-05-24 12:01:24+09	partner_app
73SA8D	free	2024-02-03 23:07:21+09	2024-02-03 23:07:21+09	partner_app
75GRKB	free	2024-07-11 17:49:58+09	2024-07-11 17:49:58+09	partner_app
7638X9	free	2024-02-19 16:42:25+09	2024-02-19 16:42:25+09	partner_app
76P2B3	free	2024-02-17 17:23:03+09	2024-02-17 17:23:03+09	partner_app
76SA8D	free	2024-02-20 09:25:57+09	2024-02-20 09:25:57+09	partner_app
77E5M6	free	2024-02-20 09:26:17+09	2024-02-20 09:26:17+09	partner_app
77P2B3	free	2024-02-20 04:22:27+09	2024-02-20 04:22:27+09	partner_app
782MY4	free	2024-07-22 02:51:12+09	2024-07-22 02:51:12+09	partner_app
79SA8D	free	2024-03-13 09:20:11+09	2024-03-13 09:20:11+09	partner_app
7ADJN1	free	2024-08-08 11:08:27+09	2024-08-08 11:08:27+09	partner_app
7ARO98	free	2024-08-10 16:50:12+09	2024-08-10 16:50:12+09	partner_app
7BRO98	free	2024-08-14 12:59:18+09	2024-08-14 12:59:18+09	partner_app
7BSA8D	free	2024-03-21 05:34:59+09	2024-03-21 05:34:59+09	partner_app
7D5UVE	free	2024-11-01 00:10:41+09	2024-11-01 00:10:41+09	partner_app
7DE5M6	free	2024-03-26 04:18:31+09	2024-03-26 04:18:31+09	partner_app
7E38X9	free	2024-04-01 08:53:48+09	2024-04-01 08:53:48+09	partner_app
7FP2B3	free	2024-04-02 01:32:23+09	2024-04-02 01:32:23+09	partner_app
7J1MY4	free	2023-11-23 08:37:08+09	2023-11-23 08:37:08+09	partner_app
7J38X9	free	2024-05-16 23:28:51+09	2024-05-16 23:28:51+09	partner_app
7J4UVE	free	2023-12-13 02:02:05+09	2023-12-13 02:02:05+09	partner_app
7K38X9	free	2024-06-05 03:49:56+09	2024-06-05 03:49:56+09	partner_app
7K4UVE	free	2024-01-12 05:41:00+09	2024-01-12 05:41:00+09	partner_app
7KFRKB	free	2023-12-26 03:53:10+09	2023-12-26 03:53:10+09	partner_app
7MCJN1	free	2024-01-15 09:19:26+09	2024-01-15 09:19:26+09	partner_app
7MQO98	free	2024-02-05 03:32:21+09	2024-02-05 03:32:21+09	partner_app
7NE5M6	free	2024-07-10 08:05:04+09	2024-07-10 08:05:04+09	partner_app
7OFRKB	free	2024-02-20 06:19:48+09	2024-02-20 06:19:48+09	partner_app
7PSA8D	free	2024-07-24 09:16:11+09	2024-07-24 09:16:11+09	partner_app
7R1MY4	free	2024-03-06 06:14:23+09	2024-03-06 06:14:23+09	partner_app
7RCJN1	free	2024-02-26 11:28:24+09	2024-02-26 11:28:24+09	partner_app
7TFRKB	free	2024-03-21 00:50:45+09	2024-03-21 00:50:45+09	partner_app
7X1MY4	free	2024-04-02 11:37:43+09	2024-04-02 11:37:43+09	partner_app
7X4UVE	free	2024-04-08 05:39:56+09	2024-04-08 05:39:56+09	partner_app
7YCJN1	free	2024-04-04 06:43:55+09	2024-04-04 06:43:55+09	partner_app
80DJN1	free	2024-04-16 11:13:42+09	2024-04-16 11:13:42+09	partner_app
815UVE	free	2024-05-28 16:22:40+09	2024-05-28 16:22:40+09	partner_app
8238X9	free	2023-12-22 03:51:46+09	2023-12-22 03:51:46+09	partner_app
8738X9	free	2024-02-20 12:41:11+09	2024-02-20 12:41:11+09	partner_app
87E5M6	free	2024-02-20 09:26:26+09	2024-02-20 09:26:26+09	partner_app
885UVE	free	2024-07-31 15:02:13+09	2024-07-31 15:02:13+09	partner_app
89GRKB	free	2024-08-08 18:29:25+09	2024-08-08 18:29:25+09	partner_app
8A38X9	free	2024-03-14 09:38:44+09	2024-03-14 09:38:44+09	partner_app
8ADJN1	free	2024-08-08 11:31:59+09	2024-08-08 11:31:59+09	partner_app
8BSA8D	free	2024-03-21 06:25:22+09	2024-03-21 06:25:22+09	partner_app
8CRO98	free	2024-08-17 16:17:27+09	2024-08-17 16:17:27+09	partner_app
8D2MY4	free	2024-09-13 04:53:19+09	2024-09-13 04:53:19+09	partner_app
8DE5M6	free	2024-03-26 04:27:05+09	2024-03-26 04:27:05+09	partner_app
8DP2B3	free	2024-03-25 12:16:28+09	2024-03-25 12:16:28+09	partner_app
8EDJN1	free	2024-10-08 18:57:59+09	2024-10-08 18:57:59+09	partner_app
8F2MY4	free	2024-11-28 23:54:21+09	2024-11-28 23:54:21+09	partner_app
8FE5M6	free	2024-04-03 07:14:23+09	2024-04-03 07:14:23+09	partner_app
8FP2B3	free	2024-04-02 03:22:46+09	2024-04-02 03:22:46+09	partner_app
8IE5M6	free	2024-04-19 12:04:33+09	2024-04-19 12:04:33+09	partner_app
8JFRKB	free	2023-12-02 18:01:24+09	2023-12-02 18:01:24+09	partner_app
8JQO98	free	2023-11-30 02:40:09+09	2023-11-30 02:40:09+09	partner_app
8KQO98	free	2023-12-17 11:00:57+09	2023-12-17 11:00:57+09	partner_app
8L1MY4	free	2024-01-03 07:06:36+09	2024-01-03 07:06:36+09	partner_app
8L38X9	free	2024-06-27 08:22:05+09	2024-06-27 08:22:05+09	partner_app
8M38X9	free	2024-07-09 20:22:53+09	2024-07-09 20:22:53+09	partner_app
8MP2B3	free	2024-06-28 05:19:40+09	2024-06-28 05:19:40+09	partner_app
8QP2B3	free	2024-07-17 10:06:29+09	2024-07-17 10:06:29+09	partner_app
8R4UVE	free	2024-03-13 22:24:06+09	2024-03-13 22:24:06+09	partner_app
8TFRKB	free	2024-03-21 00:54:14+09	2024-03-21 00:54:14+09	partner_app
8V4UVE	free	2024-03-29 13:50:40+09	2024-03-29 13:50:40+09	partner_app
8X1MY4	free	2024-04-02 15:36:17+09	2024-04-02 15:36:17+09	partner_app
8X4UVE	free	2024-04-12 07:54:22+09	2024-04-12 07:54:22+09	partner_app
8Y1MY4	free	2024-04-05 08:13:23+09	2024-04-05 08:13:23+09	partner_app
90GRKB	free	2024-05-09 22:25:07+09	2024-05-09 22:25:07+09	partner_app
90P2B3	free	2023-11-15 12:07:03+09	2023-11-15 12:07:03+09	partner_app
9138X9	free	2023-12-02 06:58:28+09	2023-12-02 06:58:28+09	partner_app
935UVE	free	2024-07-09 16:52:41+09	2024-07-09 16:52:41+09	partner_app
93GRKB	free	2024-07-03 01:45:47+09	2024-07-03 01:45:47+09	partner_app
94E5M6	free	2024-02-04 10:27:58+09	2024-02-04 10:27:58+09	partner_app
95DJN1	free	2024-07-09 19:57:40+09	2024-07-09 19:57:40+09	partner_app
95GRKB	free	2024-07-11 22:18:10+09	2024-07-11 22:18:10+09	partner_app
9BSA8D	free	2024-03-21 08:18:56+09	2024-03-21 08:18:56+09	partner_app
9DDJN1	free	2024-08-25 08:02:30+09	2024-08-25 08:02:30+09	partner_app
9DP2B3	free	2024-03-25 12:25:28+09	2024-03-25 12:25:28+09	partner_app
9DSA8D	free	2024-03-29 06:36:51+09	2024-03-29 06:36:51+09	partner_app
9EGRKB	free	2024-11-21 23:00:14+09	2024-11-21 23:00:14+09	partner_app
9GDJN1	free	2025-01-09 23:07:21+09	2025-01-09 23:07:21+09	partner_app
9K38X9	free	2024-06-06 03:31:14+09	2024-06-06 03:31:14+09	partner_app
9O1MY4	free	2024-02-19 10:54:50+09	2024-02-19 10:54:50+09	partner_app
9PE5M6	free	2024-07-15 08:26:29+09	2024-07-15 08:26:29+09	partner_app
9PQO98	free	2024-02-20 10:33:13+09	2024-02-20 10:33:13+09	partner_app
9QQO98	free	2024-02-24 11:52:11+09	2024-02-24 11:52:11+09	partner_app
9S38X9	free	2024-08-11 16:28:16+09	2024-08-11 16:28:16+09	partner_app
9TSA8D	free	2024-08-15 04:34:28+09	2024-08-15 04:34:28+09	partner_app
9V1MY4	free	2024-03-26 00:21:21+09	2024-03-26 00:21:21+09	partner_app
9VFRKB	free	2024-03-27 19:40:48+09	2024-03-27 19:40:48+09	partner_app
9YCJN1	free	2024-04-04 10:26:56+09	2024-04-04 10:26:56+09	partner_app
9Z28X9	free	2023-11-15 07:49:26+09	2023-11-15 07:49:26+09	partner_app
A038X9	free	2023-11-23 08:15:37+09	2023-11-23 08:15:37+09	partner_app
A0RO98	free	2024-05-02 09:07:43+09	2024-05-02 09:07:43+09	partner_app
A0SA8D	free	2023-11-28 01:27:23+09	2023-11-28 01:27:23+09	partner_app
A1E5M6	free	2023-11-28 07:02:25+09	2023-11-28 07:02:25+09	partner_app
A22MY4	free	2024-05-24 16:33:32+09	2024-05-24 16:33:32+09	partner_app
A438X9	free	2024-02-07 02:03:14+09	2024-02-07 02:03:14+09	partner_app
A5DJN1	free	2024-07-09 20:02:41+09	2024-07-09 20:02:41+09	partner_app
A5RO98	free	2024-07-11 00:21:40+09	2024-07-11 00:21:40+09	partner_app
A6RO98	free	2024-07-13 00:56:34+09	2024-07-13 00:56:34+09	partner_app
A72MY4	free	2024-07-15 00:18:16+09	2024-07-15 00:18:16+09	partner_app
A9RO98	free	2024-08-08 10:52:17+09	2024-08-08 10:52:17+09	partner_app
AASA8D	free	2024-03-15 01:01:16+09	2024-03-15 01:01:16+09	partner_app
ACDJN1	free	2024-08-14 15:54:37+09	2024-08-14 15:54:37+09	partner_app
ADP2B3	free	2024-03-25 13:17:02+09	2024-03-25 13:17:02+09	partner_app
AE2MY4	free	2024-10-23 23:41:09+09	2024-10-23 23:41:09+09	partner_app
AFP2B3	free	2024-04-02 05:08:19+09	2024-04-02 05:08:19+09	partner_app
AFSA8D	free	2024-04-06 00:33:50+09	2024-04-06 00:33:50+09	partner_app
AGE5M6	free	2024-04-06 06:46:59+09	2024-04-06 06:46:59+09	partner_app
AGP2B3	free	2024-04-05 03:13:39+09	2024-04-05 03:13:39+09	partner_app
AI4UVE	free	2023-11-30 01:47:33+09	2023-11-30 01:47:33+09	partner_app
AIP2B3	free	2024-04-17 12:46:48+09	2024-04-17 12:46:48+09	partner_app
AJ38X9	free	2024-05-17 01:31:02+09	2024-05-17 01:31:02+09	partner_app
AJQO98	free	2023-12-01 03:19:52+09	2023-12-01 03:19:52+09	partner_app
AL38X9	free	2024-06-27 12:39:19+09	2024-06-27 12:39:19+09	partner_app
AMCJN1	free	2024-01-25 07:19:00+09	2024-01-25 07:19:00+09	partner_app
AMQO98	free	2024-02-05 05:49:17+09	2024-02-05 05:49:17+09	partner_app
AN38X9	free	2024-07-11 17:02:30+09	2024-07-11 17:02:30+09	partner_app
ANE5M6	free	2024-07-10 15:49:43+09	2024-07-10 15:49:43+09	partner_app
ANFRKB	free	2024-02-18 04:37:32+09	2024-02-18 04:37:32+09	partner_app
AOE5M6	free	2024-07-12 07:09:23+09	2024-07-12 07:09:23+09	partner_app
APCJN1	free	2024-02-19 16:23:16+09	2024-02-19 16:23:16+09	partner_app
AQ1MY4	free	2024-02-21 06:10:18+09	2024-02-21 06:10:18+09	partner_app
ARQO98	free	2024-03-12 12:20:43+09	2024-03-12 12:20:43+09	partner_app
ASQO98	free	2024-03-14 04:56:57+09	2024-03-14 04:56:57+09	partner_app
AT1MY4	free	2024-03-14 16:37:18+09	2024-03-14 16:37:18+09	partner_app
ATQO98	free	2024-03-15 10:27:33+09	2024-03-15 10:27:33+09	partner_app
AWQO98	free	2024-04-01 07:46:35+09	2024-04-01 07:46:35+09	partner_app
B0E5M6	free	2023-11-21 03:18:56+09	2023-11-21 03:18:56+09	partner_app
B0GRKB	free	2024-05-10 02:52:48+09	2024-05-10 02:52:48+09	partner_app
B15UVE	free	2024-05-30 16:41:05+09	2024-05-30 16:41:05+09	partner_app
B45UVE	free	2024-07-10 23:17:02+09	2024-07-10 23:17:02+09	partner_app
B52MY4	free	2024-07-10 02:37:52+09	2024-07-10 02:37:52+09	partner_app
B55UVE	free	2024-07-12 17:46:00+09	2024-07-12 17:46:00+09	partner_app
B5GRKB	free	2024-07-12 00:41:20+09	2024-07-12 00:41:20+09	partner_app
B5P2B3	free	2024-02-08 01:01:03+09	2024-02-08 01:01:03+09	partner_app
B7SA8D	free	2024-02-21 06:11:09+09	2024-02-21 06:11:09+09	partner_app
B8DJN1	free	2024-07-16 11:11:22+09	2024-07-16 11:11:22+09	partner_app
B8GRKB	free	2024-07-29 06:26:35+09	2024-07-29 06:26:35+09	partner_app
BAGRKB	free	2024-08-13 09:50:26+09	2024-08-13 09:50:26+09	partner_app
BCRO98	free	2024-08-22 15:45:18+09	2024-08-22 15:45:18+09	partner_app
BE2MY4	free	2024-10-24 14:49:02+09	2024-10-24 14:49:02+09	partner_app
BEGRKB	free	2024-11-27 23:50:03+09	2024-11-27 23:50:03+09	partner_app
BG38X9	free	2024-04-14 13:48:19+09	2024-04-14 13:48:19+09	partner_app
BG4UVE	free	2023-11-14 05:18:47+09	2023-11-14 05:18:47+09	partner_app
BH38X9	free	2024-04-16 13:06:56+09	2024-04-16 13:06:56+09	partner_app
BH4UVE	free	2023-11-22 04:26:41+09	2023-11-22 04:26:41+09	partner_app
BHSA8D	free	2024-04-18 10:45:09+09	2024-04-18 10:45:09+09	partner_app
BI4UVE	free	2023-11-30 02:27:41+09	2023-11-30 02:27:41+09	partner_app
BJFRKB	free	2023-12-04 08:27:32+09	2023-12-04 08:27:32+09	partner_app
BKCJN1	free	2023-12-02 05:56:23+09	2023-12-02 05:56:23+09	partner_app
BKQO98	free	2023-12-20 10:59:01+09	2023-12-20 10:59:01+09	partner_app
BLCJN1	free	2023-12-21 13:36:12+09	2023-12-21 13:36:12+09	partner_app
BNE5M6	free	2024-07-10 15:55:29+09	2024-07-10 15:55:29+09	partner_app
BNP2B3	free	2024-07-09 21:21:47+09	2024-07-09 21:21:47+09	partner_app
BPP2B3	free	2024-07-14 08:04:41+09	2024-07-14 08:04:41+09	partner_app
BQSA8D	free	2024-07-30 14:32:34+09	2024-07-30 14:32:34+09	partner_app
BR1MY4	free	2024-03-08 14:29:53+09	2024-03-08 14:29:53+09	partner_app
BRCJN1	free	2024-02-26 11:31:06+09	2024-02-26 11:31:06+09	partner_app
BRSA8D	free	2024-08-09 16:20:25+09	2024-08-09 16:20:25+09	partner_app
BSP2B3	free	2024-08-08 18:19:54+09	2024-08-08 18:19:54+09	partner_app
BTE5M6	free	2024-08-14 11:25:08+09	2024-08-14 11:25:08+09	partner_app
BV38X9	free	2024-10-15 19:24:15+09	2024-10-15 19:24:15+09	partner_app
BVQO98	free	2024-03-26 11:25:40+09	2024-03-26 11:25:40+09	partner_app
C038X9	free	2023-11-23 08:15:38+09	2023-11-23 08:15:38+09	partner_app
C138X9	free	2023-12-02 10:25:21+09	2023-12-02 10:25:21+09	partner_app
C2E5M6	free	2023-12-13 07:44:09+09	2023-12-13 07:44:09+09	partner_app
C3E5M6	free	2024-01-13 03:19:46+09	2024-01-13 03:19:46+09	partner_app
C3RO98	free	2024-06-26 09:51:08+09	2024-06-26 09:51:08+09	partner_app
C4E5M6	free	2024-02-05 02:42:04+09	2024-02-05 02:42:04+09	partner_app
C4P2B3	free	2024-02-02 22:30:50+09	2024-02-02 22:30:50+09	partner_app
C5GRKB	free	2024-07-12 00:55:14+09	2024-07-12 00:55:14+09	partner_app
C5SA8D	free	2024-02-19 13:16:48+09	2024-02-19 13:16:48+09	partner_app
C6E5M6	free	2024-02-19 14:15:48+09	2024-02-19 14:15:48+09	partner_app
C6GRKB	free	2024-07-14 18:19:24+09	2024-07-14 18:19:24+09	partner_app
C6P2B3	free	2024-02-18 03:11:46+09	2024-02-18 03:11:46+09	partner_app
C838X9	free	2024-02-28 11:42:30+09	2024-02-28 11:42:30+09	partner_app
C8P2B3	free	2024-02-21 02:15:22+09	2024-02-21 02:15:22+09	partner_app
C938X9	free	2024-03-12 23:21:07+09	2024-03-12 23:21:07+09	partner_app
CA38X9	free	2024-03-14 11:39:54+09	2024-03-14 11:39:54+09	partner_app
CARO98	free	2024-08-11 06:04:00+09	2024-08-11 06:04:00+09	partner_app
CASA8D	free	2024-03-15 02:20:13+09	2024-03-15 02:20:13+09	partner_app
CBE5M6	free	2024-03-15 05:08:14+09	2024-03-15 05:08:14+09	partner_app
CBP2B3	free	2024-03-14 12:38:58+09	2024-03-14 12:38:58+09	partner_app
CBRO98	free	2024-08-14 15:20:44+09	2024-08-14 15:20:44+09	partner_app
CCDJN1	free	2024-08-14 17:30:10+09	2024-08-14 17:30:10+09	partner_app
CD38X9	free	2024-03-26 16:49:30+09	2024-03-26 16:49:30+09	partner_app
CE5UVE	free	2024-12-22 01:17:47+09	2024-12-22 01:17:47+09	partner_app
CHP2B3	free	2024-04-14 19:59:10+09	2024-04-14 19:59:10+09	partner_app
CKP2B3	free	2024-05-23 02:35:54+09	2024-05-23 02:35:54+09	partner_app
CL1MY4	free	2024-01-06 01:18:48+09	2024-01-06 01:18:48+09	partner_app
CLE5M6	free	2024-06-18 15:19:24+09	2024-06-18 15:19:24+09	partner_app
CLFRKB	free	2024-02-03 16:15:08+09	2024-02-03 16:15:08+09	partner_app
CN1MY4	free	2024-02-17 03:36:06+09	2024-02-17 03:36:06+09	partner_app
CNQO98	free	2024-02-17 15:13:58+09	2024-02-17 15:13:58+09	partner_app
CO4UVE	free	2024-02-20 10:03:44+09	2024-02-20 10:03:44+09	partner_app
COSA8D	free	2024-07-15 04:50:50+09	2024-07-15 04:50:50+09	partner_app
CP4UVE	free	2024-02-22 05:44:03+09	2024-02-22 05:44:03+09	partner_app
CQP2B3	free	2024-07-18 09:01:05+09	2024-07-18 09:01:05+09	partner_app
CQSA8D	free	2024-07-30 14:36:46+09	2024-07-30 14:36:46+09	partner_app
CRFRKB	free	2024-03-13 07:25:32+09	2024-03-13 07:25:32+09	partner_app
CUCJN1	free	2024-03-16 03:02:32+09	2024-03-16 03:02:32+09	partner_app
CV1MY4	free	2024-03-26 01:37:38+09	2024-03-26 01:37:38+09	partner_app
CVFRKB	free	2024-03-28 04:49:41+09	2024-03-28 04:49:41+09	partner_app
CVP2B3	free	2024-09-07 02:11:12+09	2024-09-07 02:11:12+09	partner_app
CXQO98	free	2024-04-04 09:46:25+09	2024-04-04 09:46:25+09	partner_app
CY4UVE	free	2024-04-16 02:46:30+09	2024-04-16 02:46:30+09	partner_app
D0DJN1	free	2024-04-16 12:37:46+09	2024-04-16 12:37:46+09	partner_app
D1SA8D	free	2023-12-12 03:49:50+09	2023-12-12 03:49:50+09	partner_app
D2E5M6	free	2023-12-13 23:59:44+09	2023-12-13 23:59:44+09	partner_app
D2GRKB	free	2024-06-13 03:22:43+09	2024-06-13 03:22:43+09	partner_app
D3P2B3	free	2023-12-30 01:40:33+09	2023-12-30 01:40:33+09	partner_app
D5E5M6	free	2024-02-17 07:25:06+09	2024-02-17 07:25:06+09	partner_app
D6P2B3	free	2024-02-18 04:24:39+09	2024-02-18 04:24:39+09	partner_app
D82MY4	free	2024-07-24 14:00:40+09	2024-07-24 14:00:40+09	partner_app
DAE5M6	free	2024-03-14 00:46:10+09	2024-03-14 00:46:10+09	partner_app
DBSA8D	free	2024-03-22 06:50:53+09	2024-03-22 06:50:53+09	partner_app
DCSA8D	free	2024-03-26 05:18:50+09	2024-03-26 05:18:50+09	partner_app
DE38X9	free	2024-04-02 04:58:04+09	2024-04-02 04:58:04+09	partner_app
DFSA8D	free	2024-04-06 06:21:51+09	2024-04-06 06:21:51+09	partner_app
DGE5M6	free	2024-04-12 12:31:11+09	2024-04-12 12:31:11+09	partner_app
DIE5M6	free	2024-04-25 12:27:10+09	2024-04-25 12:27:10+09	partner_app
DIP2B3	free	2024-04-17 12:51:47+09	2024-04-17 12:51:47+09	partner_app
DJ38X9	free	2024-05-17 11:14:02+09	2024-05-17 11:14:02+09	partner_app
DJCJN1	free	2023-11-23 08:15:37+09	2023-11-23 08:15:37+09	partner_app
DK1MY4	free	2023-12-07 09:16:11+09	2023-12-07 09:16:11+09	partner_app
DL38X9	free	2024-06-28 09:43:11+09	2024-06-28 09:43:11+09	partner_app
DLCJN1	free	2023-12-23 10:23:17+09	2023-12-23 10:23:17+09	partner_app
DM1MY4	free	2024-02-04 01:55:06+09	2024-02-04 01:55:06+09	partner_app
DMCJN1	free	2024-01-25 09:17:52+09	2024-01-25 09:17:52+09	partner_app
DOE5M6	free	2024-07-12 16:53:08+09	2024-07-12 16:53:08+09	partner_app
DQ4UVE	free	2024-03-12 12:03:19+09	2024-03-12 12:03:19+09	partner_app
DQFRKB	free	2024-03-07 13:33:44+09	2024-03-07 13:33:44+09	partner_app
DS1MY4	free	2024-03-13 10:59:35+09	2024-03-13 10:59:35+09	partner_app
DSCJN1	free	2024-03-12 22:42:03+09	2024-03-12 22:42:03+09	partner_app
DUCJN1	free	2024-03-17 02:31:35+09	2024-03-17 02:31:35+09	partner_app
DVP2B3	free	2024-09-09 01:57:28+09	2024-09-09 01:57:28+09	partner_app
DY4UVE	free	2024-04-16 04:01:12+09	2024-04-16 04:01:12+09	partner_app
DYQO98	free	2024-04-14 08:59:31+09	2024-04-14 08:59:31+09	partner_app
E05UVE	free	2024-05-15 10:37:26+09	2024-05-15 10:37:26+09	partner_app
E0P2B3	free	2023-11-16 04:48:09+09	2023-11-16 04:48:09+09	partner_app
E1P2B3	free	2023-11-23 08:26:34+09	2023-11-23 08:26:34+09	partner_app
E22MY4	free	2024-05-26 00:32:05+09	2024-05-26 00:32:05+09	partner_app
E438X9	free	2024-02-08 00:06:36+09	2024-02-08 00:06:36+09	partner_app
E5GRKB	free	2024-07-12 01:32:37+09	2024-07-12 01:32:37+09	partner_app
E6SA8D	free	2024-02-20 09:26:29+09	2024-02-20 09:26:29+09	partner_app
E738X9	free	2024-02-21 00:26:39+09	2024-02-21 00:26:39+09	partner_app
E838X9	free	2024-03-02 07:51:53+09	2024-03-02 07:51:53+09	partner_app
E8GRKB	free	2024-07-29 09:02:10+09	2024-07-29 09:02:10+09	partner_app
E8RO98	free	2024-07-28 03:55:27+09	2024-07-28 03:55:27+09	partner_app
E9GRKB	free	2024-08-09 04:36:45+09	2024-08-09 04:36:45+09	partner_app
EADJN1	free	2024-08-08 12:33:47+09	2024-08-08 12:33:47+09	partner_app
EBGRKB	free	2024-08-15 03:36:37+09	2024-08-15 03:36:37+09	partner_app
EC5UVE	free	2024-10-03 10:16:30+09	2024-10-03 10:16:30+09	partner_app
ECDJN1	free	2024-08-14 17:42:09+09	2024-08-14 17:42:09+09	partner_app
ED2MY4	free	2024-09-26 08:16:32+09	2024-09-26 08:16:32+09	partner_app
EG4UVE	free	2023-11-14 12:39:54+09	2023-11-14 12:39:54+09	partner_app
EH1MY4	free	2023-11-11 01:05:03+09	2023-11-11 01:05:03+09	partner_app
EHSA8D	free	2024-04-21 09:41:24+09	2024-04-21 09:41:24+09	partner_app
EIQO98	free	2023-11-23 08:15:33+09	2023-11-23 08:15:33+09	partner_app
EKQO98	free	2023-12-21 10:00:13+09	2023-12-21 10:00:13+09	partner_app
ELE5M6	free	2024-06-20 09:07:25+09	2024-06-20 09:07:25+09	partner_app
EO4UVE	free	2024-02-20 10:33:14+09	2024-02-20 10:33:14+09	partner_app
EOP2B3	free	2024-07-12 00:21:14+09	2024-07-12 00:21:14+09	partner_app
EOSA8D	free	2024-07-15 12:04:36+09	2024-07-15 12:04:36+09	partner_app
EPP2B3	free	2024-07-14 16:38:19+09	2024-07-14 16:38:19+09	partner_app
ET4UVE	free	2024-03-25 05:42:56+09	2024-03-25 05:42:56+09	partner_app
EU1MY4	free	2024-03-21 13:55:15+09	2024-03-21 13:55:15+09	partner_app
EVFRKB	free	2024-03-28 08:34:23+09	2024-03-28 08:34:23+09	partner_app
EWCJN1	free	2024-03-26 14:38:42+09	2024-03-26 14:38:42+09	partner_app
EYRA8D	free	2023-11-13 01:25:04+09	2023-11-13 01:25:04+09	partner_app
F0GRKB	free	2024-05-10 08:00:44+09	2024-05-10 08:00:44+09	partner_app
F2GRKB	free	2024-06-15 09:53:27+09	2024-06-15 09:53:27+09	partner_app
F3P2B3	free	2024-01-03 00:53:45+09	2024-01-03 00:53:45+09	partner_app
F538X9	free	2024-02-18 01:14:19+09	2024-02-18 01:14:19+09	partner_app
F6SA8D	free	2024-02-20 09:26:36+09	2024-02-20 09:26:36+09	partner_app
F7SA8D	free	2024-02-21 12:18:24+09	2024-02-21 12:18:24+09	partner_app
F9E5M6	free	2024-03-12 11:24:40+09	2024-03-12 11:24:40+09	partner_app
FD5UVE	free	2024-11-11 22:26:04+09	2024-11-11 22:26:04+09	partner_app
FF38X9	free	2024-04-05 03:40:34+09	2024-04-05 03:40:34+09	partner_app
FFE5M6	free	2024-04-04 01:37:58+09	2024-04-04 01:37:58+09	partner_app
FI1MY4	free	2023-11-19 09:10:00+09	2023-11-19 09:10:00+09	partner_app
FI4UVE	free	2023-12-01 07:57:50+09	2023-12-01 07:57:50+09	partner_app
FJCJN1	free	2023-11-23 08:15:37+09	2023-11-23 08:15:37+09	partner_app
FKCJN1	free	2023-12-02 08:51:37+09	2023-12-02 08:51:37+09	partner_app
FLQO98	free	2024-01-25 07:19:22+09	2024-01-25 07:19:22+09	partner_app
FN4UVE	free	2024-02-19 15:54:10+09	2024-02-19 15:54:10+09	partner_app
FNSA8D	free	2024-07-12 12:06:28+09	2024-07-12 12:06:28+09	partner_app
FO1MY4	free	2024-02-19 13:15:31+09	2024-02-19 13:15:31+09	partner_app
FPSA8D	free	2024-07-26 19:56:09+09	2024-07-26 19:56:09+09	partner_app
FQCJN1	free	2024-02-20 13:20:13+09	2024-02-20 13:20:13+09	partner_app
FSQO98	free	2024-03-14 09:31:21+09	2024-03-14 09:31:21+09	partner_app
FT1MY4	free	2024-03-15 01:21:05+09	2024-03-15 01:21:05+09	partner_app
FWE5M6	free	2024-11-06 09:14:33+09	2024-11-06 09:14:33+09	partner_app
FXE5M6	free	2024-12-20 09:24:21+09	2024-12-20 09:24:21+09	partner_app
FYCJN1	free	2024-04-05 01:06:15+09	2024-04-05 01:06:15+09	partner_app
FYFRKB	free	2024-04-15 02:06:58+09	2024-04-15 02:06:58+09	partner_app
G05UVE	free	2024-05-16 00:55:14+09	2024-05-16 00:55:14+09	partner_app
G0E5M6	free	2023-11-22 23:26:01+09	2023-11-22 23:26:01+09	partner_app
G4E5M6	free	2024-02-05 04:55:53+09	2024-02-05 04:55:53+09	partner_app
G4SA8D	free	2024-02-17 07:21:12+09	2024-02-17 07:21:12+09	partner_app
G6RO98	free	2024-07-13 17:38:59+09	2024-07-13 17:38:59+09	partner_app
G938X9	free	2024-03-13 00:41:43+09	2024-03-13 00:41:43+09	partner_app
G9E5M6	free	2024-03-12 11:29:55+09	2024-03-12 11:29:55+09	partner_app
G9RO98	free	2024-08-08 11:58:03+09	2024-08-08 11:58:03+09	partner_app
GARO98	free	2024-08-11 16:26:45+09	2024-08-11 16:26:45+09	partner_app
GB2MY4	free	2024-08-14 08:24:21+09	2024-08-14 08:24:21+09	partner_app
GCRO98	free	2024-08-26 06:36:59+09	2024-08-26 06:36:59+09	partner_app
GEDJN1	free	2024-10-15 20:13:57+09	2024-10-15 20:13:57+09	partner_app
GEE5M6	free	2024-04-01 07:04:13+09	2024-04-01 07:04:13+09	partner_app
GEGRKB	free	2024-12-05 05:34:56+09	2024-12-05 05:34:56+09	partner_app
GFE5M6	free	2024-04-04 04:37:18+09	2024-04-04 04:37:18+09	partner_app
GH38X9	free	2024-04-17 12:50:50+09	2024-04-17 12:50:50+09	partner_app
GL4UVE	free	2024-02-06 02:10:49+09	2024-02-06 02:10:49+09	partner_app
GN4UVE	free	2024-02-19 15:56:56+09	2024-02-19 15:56:56+09	partner_app
GO38X9	free	2024-07-14 08:43:39+09	2024-07-14 08:43:39+09	partner_app
GOSA8D	free	2024-07-15 14:35:33+09	2024-07-15 14:35:33+09	partner_app
GPFRKB	free	2024-02-21 06:10:20+09	2024-02-21 06:10:20+09	partner_app
GQ38X9	free	2024-07-28 19:04:07+09	2024-07-28 19:04:07+09	partner_app
GQ4UVE	free	2024-03-12 15:34:18+09	2024-03-12 15:34:18+09	partner_app
GQE5M6	free	2024-07-27 21:59:04+09	2024-07-27 21:59:04+09	partner_app
GRQO98	free	2024-03-12 21:27:09+09	2024-03-12 21:27:09+09	partner_app
GSE5M6	free	2024-08-10 16:56:13+09	2024-08-10 16:56:13+09	partner_app
GTP2B3	free	2024-08-13 10:50:10+09	2024-08-13 10:50:10+09	partner_app
GU4UVE	free	2024-03-26 11:53:19+09	2024-03-26 11:53:19+09	partner_app
GUQO98	free	2024-03-25 11:38:07+09	2024-03-25 11:38:07+09	partner_app
GWE5M6	free	2024-11-07 01:25:31+09	2024-11-07 01:25:31+09	partner_app
GWFRKB	free	2024-04-03 02:54:45+09	2024-04-03 02:54:45+09	partner_app
GWP2B3	free	2024-10-23 19:07:03+09	2024-10-23 19:07:03+09	partner_app
GZ28X9	free	2023-11-15 23:25:31+09	2023-11-15 23:25:31+09	partner_app
H05UVE	free	2024-05-16 03:47:56+09	2024-05-16 03:47:56+09	partner_app
H1RO98	free	2024-05-17 01:05:05+09	2024-05-17 01:05:05+09	partner_app
H2E5M6	free	2023-12-17 13:25:14+09	2023-12-17 13:25:14+09	partner_app
H2GRKB	free	2024-06-15 10:35:43+09	2024-06-15 10:35:43+09	partner_app
H5SA8D	free	2024-02-19 14:49:29+09	2024-02-19 14:49:29+09	partner_app
H638X9	free	2024-02-20 07:04:41+09	2024-02-20 07:04:41+09	partner_app
H8RO98	free	2024-07-28 12:46:59+09	2024-07-28 12:46:59+09	partner_app
H92MY4	free	2024-07-30 15:51:45+09	2024-07-30 15:51:45+09	partner_app
H95UVE	free	2024-08-11 06:27:48+09	2024-08-11 06:27:48+09	partner_app
H9DJN1	free	2024-07-28 16:22:56+09	2024-07-28 16:22:56+09	partner_app
HAE5M6	free	2024-03-14 04:27:29+09	2024-03-14 04:27:29+09	partner_app
HDRO98	free	2024-10-14 22:17:30+09	2024-10-14 22:17:30+09	partner_app
HEGRKB	free	2024-12-05 09:29:11+09	2024-12-05 09:29:11+09	partner_app
HFP2B3	free	2024-04-02 15:41:02+09	2024-04-02 15:41:02+09	partner_app
HG4UVE	free	2023-11-15 01:39:00+09	2023-11-15 01:39:00+09	partner_app
HJ38X9	free	2024-05-24 11:26:41+09	2024-05-24 11:26:41+09	partner_app
HKFRKB	free	2024-01-06 12:32:53+09	2024-01-06 12:32:53+09	partner_app
HMCJN1	free	2024-01-30 11:53:01+09	2024-01-30 11:53:01+09	partner_app
HO1MY4	free	2024-02-19 13:40:07+09	2024-02-19 13:40:07+09	partner_app
HO38X9	free	2024-07-14 11:02:55+09	2024-07-14 11:02:55+09	partner_app
HOCJN1	free	2024-02-17 22:30:56+09	2024-02-17 22:30:56+09	partner_app
HPFRKB	free	2024-02-21 06:10:48+09	2024-02-21 06:10:48+09	partner_app
HPP2B3	free	2024-07-14 18:31:29+09	2024-07-14 18:31:29+09	partner_app
HR1MY4	free	2024-03-12 07:49:04+09	2024-03-12 07:49:04+09	partner_app
HS4UVE	free	2024-03-15 10:31:12+09	2024-03-15 10:31:12+09	partner_app
HT4UVE	free	2024-03-25 07:25:47+09	2024-03-25 07:25:47+09	partner_app
HTSA8D	free	2024-08-16 03:00:23+09	2024-08-16 03:00:23+09	partner_app
HUE5M6	free	2024-08-18 02:51:20+09	2024-08-18 02:51:20+09	partner_app
HUSA8D	free	2024-10-01 03:51:37+09	2024-10-01 03:51:37+09	partner_app
HZCJN1	free	2024-04-14 15:10:14+09	2024-04-14 15:10:14+09	partner_app
HZFRKB	free	2024-04-18 10:44:21+09	2024-04-18 10:44:21+09	partner_app
I1DJN1	free	2024-05-09 03:32:06+09	2024-05-09 03:32:06+09	partner_app
I338X9	free	2024-02-03 01:46:40+09	2024-02-03 01:46:40+09	partner_app
I4GRKB	free	2024-07-10 08:04:56+09	2024-07-10 08:04:56+09	partner_app
I5DJN1	free	2024-07-09 21:00:24+09	2024-07-09 21:00:24+09	partner_app
I5SA8D	free	2024-02-19 14:51:55+09	2024-02-19 14:51:55+09	partner_app
I6DJN1	free	2024-07-11 17:29:28+09	2024-07-11 17:29:28+09	partner_app
I7P2B3	free	2024-02-20 09:25:57+09	2024-02-20 09:25:57+09	partner_app
I7SA8D	free	2024-02-22 04:57:38+09	2024-02-22 04:57:38+09	partner_app
I82MY4	free	2024-07-26 16:40:26+09	2024-07-26 16:40:26+09	partner_app
I838X9	free	2024-03-06 00:34:49+09	2024-03-06 00:34:49+09	partner_app
I8DJN1	free	2024-07-18 03:44:18+09	2024-07-18 03:44:18+09	partner_app
I9DJN1	free	2024-07-28 16:27:44+09	2024-07-28 16:27:44+09	partner_app
I9GRKB	free	2024-08-09 15:35:43+09	2024-08-09 15:35:43+09	partner_app
I9P2B3	free	2024-03-08 01:04:20+09	2024-03-08 01:04:20+09	partner_app
IB2MY4	free	2024-08-14 10:49:08+09	2024-08-14 10:49:08+09	partner_app
IC2MY4	free	2024-08-15 09:54:50+09	2024-08-15 09:54:50+09	partner_app
IC38X9	free	2024-03-25 15:52:56+09	2024-03-25 15:52:56+09	partner_app
ICRO98	free	2024-08-30 00:10:15+09	2024-08-30 00:10:15+09	partner_app
IE2MY4	free	2024-10-30 22:30:42+09	2024-10-30 22:30:42+09	partner_app
IERO98	free	2024-11-12 17:04:11+09	2024-11-12 17:04:11+09	partner_app
IFDJN1	free	2024-11-19 07:06:33+09	2024-11-19 07:06:33+09	partner_app
IJSA8D	free	2024-05-29 13:27:40+09	2024-05-29 13:27:40+09	partner_app
ILSA8D	free	2024-07-09 17:59:28+09	2024-07-09 17:59:28+09	partner_app
IM38X9	free	2024-07-09 21:34:58+09	2024-07-09 21:34:58+09	partner_app
IMCJN1	free	2024-02-02 01:06:49+09	2024-02-02 01:06:49+09	partner_app
IO1MY4	free	2024-02-19 13:47:06+09	2024-02-19 13:47:06+09	partner_app
IOCJN1	free	2024-02-17 23:14:59+09	2024-02-17 23:14:59+09	partner_app
IP38X9	free	2024-07-19 21:07:55+09	2024-07-19 21:07:55+09	partner_app
IQ4UVE	free	2024-03-12 18:03:04+09	2024-03-12 18:03:04+09	partner_app
IQE5M6	free	2024-07-27 22:32:11+09	2024-07-27 22:32:11+09	partner_app
IR1MY4	free	2024-03-12 09:00:03+09	2024-03-12 09:00:03+09	partner_app
IRQO98	free	2024-03-12 22:52:12+09	2024-03-12 22:52:12+09	partner_app
IS1MY4	free	2024-03-13 21:09:40+09	2024-03-13 21:09:40+09	partner_app
IT4UVE	free	2024-03-25 09:15:14+09	2024-03-25 09:15:14+09	partner_app
IUCJN1	free	2024-03-21 00:50:41+09	2024-03-21 00:50:41+09	partner_app
IUSA8D	free	2024-10-01 18:41:17+09	2024-10-01 18:41:17+09	partner_app
IV1MY4	free	2024-03-26 06:14:52+09	2024-03-26 06:14:52+09	partner_app
IVSA8D	free	2024-11-06 00:05:21+09	2024-11-06 00:05:21+09	partner_app
IZ4UVE	free	2024-05-07 03:29:58+09	2024-05-07 03:29:58+09	partner_app
J0DJN1	free	2024-04-17 12:49:58+09	2024-04-17 12:49:58+09	partner_app
J45UVE	free	2024-07-11 08:40:35+09	2024-07-11 08:40:35+09	partner_app
J5SA8D	free	2024-02-19 14:56:01+09	2024-02-19 14:56:01+09	partner_app
J72MY4	free	2024-07-15 12:58:35+09	2024-07-15 12:58:35+09	partner_app
J85UVE	free	2024-08-08 11:45:23+09	2024-08-08 11:45:23+09	partner_app
JA2MY4	free	2024-08-10 01:30:37+09	2024-08-10 01:30:37+09	partner_app
JAGRKB	free	2024-08-14 07:42:33+09	2024-08-14 07:42:33+09	partner_app
JB38X9	free	2024-03-21 05:27:23+09	2024-03-21 05:27:23+09	partner_app
JFDJN1	free	2024-11-20 18:58:03+09	2024-11-20 18:58:03+09	partner_app
JGP2B3	free	2024-04-05 12:34:45+09	2024-04-05 12:34:45+09	partner_app
JGSA8D	free	2024-04-15 23:26:57+09	2024-04-15 23:26:57+09	partner_app
JIE5M6	free	2024-05-03 16:56:19+09	2024-05-03 16:56:19+09	partner_app
JJ1MY4	free	2023-11-28 07:11:10+09	2023-11-28 07:11:10+09	partner_app
JKP2B3	free	2024-05-24 19:57:04+09	2024-05-24 19:57:04+09	partner_app
JMQO98	free	2024-02-07 02:24:01+09	2024-02-07 02:24:01+09	partner_app
JPSA8D	free	2024-07-27 17:52:14+09	2024-07-27 17:52:14+09	partner_app
JR1MY4	free	2024-03-12 09:37:13+09	2024-03-12 09:37:13+09	partner_app
JRCJN1	free	2024-03-04 06:11:13+09	2024-03-04 06:11:13+09	partner_app
JRP2B3	free	2024-07-29 09:19:15+09	2024-07-29 09:19:15+09	partner_app
JSE5M6	free	2024-08-11 05:05:55+09	2024-08-11 05:05:55+09	partner_app
JTSA8D	free	2024-08-16 08:10:22+09	2024-08-16 08:10:22+09	partner_app
JU1MY4	free	2024-03-22 08:30:41+09	2024-03-22 08:30:41+09	partner_app
JXFRKB	free	2024-04-06 02:19:58+09	2024-04-06 02:19:58+09	partner_app
JXP2B3	free	2024-12-04 23:53:06+09	2024-12-04 23:53:06+09	partner_app
K2E5M6	free	2023-12-21 00:46:01+09	2023-12-21 00:46:01+09	partner_app
K2P2B3	free	2023-12-06 09:16:47+09	2023-12-06 09:16:47+09	partner_app
KASA8D	free	2024-03-15 10:26:12+09	2024-03-15 10:26:12+09	partner_app
KBSA8D	free	2024-03-24 04:44:05+09	2024-03-24 04:44:05+09	partner_app
KCE5M6	free	2024-03-25 07:24:39+09	2024-03-25 07:24:39+09	partner_app
KEGRKB	free	2024-12-09 19:33:04+09	2024-12-09 19:33:04+09	partner_app
KFDJN1	free	2024-11-20 23:08:34+09	2024-11-20 23:08:34+09	partner_app
KGE5M6	free	2024-04-14 08:10:15+09	2024-04-14 08:10:15+09	partner_app
KH4UVE	free	2023-11-23 08:15:36+09	2023-11-23 08:15:36+09	partner_app
KIFRKB	free	2023-11-28 03:21:41+09	2023-11-28 03:21:41+09	partner_app
KKE5M6	free	2024-06-03 05:33:37+09	2024-06-03 05:33:37+09	partner_app
KME5M6	free	2024-07-09 19:55:55+09	2024-07-09 19:55:55+09	partner_app
KMFRKB	free	2024-02-17 04:15:57+09	2024-02-17 04:15:57+09	partner_app
KMSA8D	free	2024-07-10 23:45:03+09	2024-07-10 23:45:03+09	partner_app
KNE5M6	free	2024-07-11 04:24:26+09	2024-07-11 04:24:26+09	partner_app
KNQO98	free	2024-02-17 20:11:28+09	2024-02-17 20:11:28+09	partner_app
KOE5M6	free	2024-07-13 06:06:55+09	2024-07-13 06:06:55+09	partner_app
KOP2B3	free	2024-07-12 03:51:48+09	2024-07-12 03:51:48+09	partner_app
KPFRKB	free	2024-02-21 06:12:55+09	2024-02-21 06:12:55+09	partner_app
KQE5M6	free	2024-07-28 00:00:35+09	2024-07-28 00:00:35+09	partner_app
KRFRKB	free	2024-03-13 17:33:24+09	2024-03-13 17:33:24+09	partner_app
KV4UVE	free	2024-04-01 09:11:13+09	2024-04-01 09:11:13+09	partner_app
KVFRKB	free	2024-03-29 11:27:23+09	2024-03-29 11:27:23+09	partner_app
KVP2B3	free	2024-09-25 10:08:22+09	2024-09-25 10:08:22+09	partner_app
KY4UVE	free	2024-04-16 12:01:36+09	2024-04-16 12:01:36+09	partner_app
KYQO98	free	2024-04-14 14:21:41+09	2024-04-14 14:21:41+09	partner_app
KZ28X9	free	2023-11-16 05:20:28+09	2023-11-16 05:20:28+09	partner_app
L0P2B3	free	2023-11-17 09:35:09+09	2023-11-17 09:35:09+09	partner_app
L1E5M6	free	2023-12-02 04:29:37+09	2023-12-02 04:29:37+09	partner_app
L2SA8D	free	2024-01-15 07:22:21+09	2024-01-15 07:22:21+09	partner_app
L3E5M6	free	2024-01-18 00:23:43+09	2024-01-18 00:23:43+09	partner_app
L8DJN1	free	2024-07-18 11:48:16+09	2024-07-18 11:48:16+09	partner_app
LB38X9	free	2024-03-21 05:33:22+09	2024-03-21 05:33:22+09	partner_app
LBSA8D	free	2024-03-24 05:33:47+09	2024-03-24 05:33:47+09	partner_app
LCRO98	free	2024-08-30 02:43:31+09	2024-08-30 02:43:31+09	partner_app
LDE5M6	free	2024-03-26 12:01:13+09	2024-03-26 12:01:13+09	partner_app
LDRO98	free	2024-10-15 23:28:45+09	2024-10-15 23:28:45+09	partner_app
LEGRKB	free	2024-12-10 09:30:00+09	2024-12-10 09:30:00+09	partner_app
LESA8D	free	2024-04-04 04:39:10+09	2024-04-04 04:39:10+09	partner_app
LF2MY4	free	2024-12-19 06:30:59+09	2024-12-19 06:30:59+09	partner_app
LF38X9	free	2024-04-05 09:16:33+09	2024-04-05 09:16:33+09	partner_app
LG38X9	free	2024-04-14 23:55:19+09	2024-04-14 23:55:19+09	partner_app
LHSA8D	free	2024-04-30 23:08:59+09	2024-04-30 23:08:59+09	partner_app
LJ1MY4	free	2023-11-29 06:28:44+09	2023-11-29 06:28:44+09	partner_app
LJP2B3	free	2024-05-10 15:03:50+09	2024-05-10 15:03:50+09	partner_app
LKCJN1	free	2023-12-03 03:07:22+09	2023-12-03 03:07:22+09	partner_app
LM1MY4	free	2024-02-05 03:15:21+09	2024-02-05 03:15:21+09	partner_app
LM4UVE	free	2024-02-17 16:00:59+09	2024-02-17 16:00:59+09	partner_app
LN4UVE	free	2024-02-19 21:00:59+09	2024-02-19 21:00:59+09	partner_app
LNCJN1	free	2024-02-14 03:22:04+09	2024-02-14 03:22:04+09	partner_app
LNSA8D	free	2024-07-13 00:35:07+09	2024-07-13 00:35:07+09	partner_app
LOP2B3	free	2024-07-12 04:17:23+09	2024-07-12 04:17:23+09	partner_app
LQQO98	free	2024-02-29 03:08:30+09	2024-02-29 03:08:30+09	partner_app
LR1MY4	free	2024-03-12 10:38:31+09	2024-03-12 10:38:31+09	partner_app
LSQO98	free	2024-03-14 11:57:30+09	2024-03-14 11:57:30+09	partner_app
LUSA8D	free	2024-10-03 08:36:28+09	2024-10-03 08:36:28+09	partner_app
LV38X9	free	2024-10-23 19:31:05+09	2024-10-23 19:31:05+09	partner_app
LWFRKB	free	2024-04-03 10:49:20+09	2024-04-03 10:49:20+09	partner_app
LYCJN1	free	2024-04-05 05:44:07+09	2024-04-05 05:44:07+09	partner_app
LYFRKB	free	2024-04-15 14:39:51+09	2024-04-15 14:39:51+09	partner_app
M0P2B3	free	2023-11-18 05:12:20+09	2023-11-18 05:12:20+09	partner_app
M12MY4	free	2024-05-13 21:51:35+09	2024-05-13 21:51:35+09	partner_app
M1RO98	free	2024-05-18 15:24:05+09	2024-05-18 15:24:05+09	partner_app
M2DJN1	free	2024-05-24 11:50:22+09	2024-05-24 11:50:22+09	partner_app
M2SA8D	free	2024-01-15 07:48:04+09	2024-01-15 07:48:04+09	partner_app
M3GRKB	free	2024-07-09 15:35:28+09	2024-07-09 15:35:28+09	partner_app
M438X9	free	2024-02-16 11:10:58+09	2024-02-16 11:10:58+09	partner_app
M4DJN1	free	2024-07-04 12:25:17+09	2024-07-04 12:25:17+09	partner_app
M4SA8D	free	2024-02-17 14:33:17+09	2024-02-17 14:33:17+09	partner_app
M6P2B3	free	2024-02-19 12:57:47+09	2024-02-19 12:57:47+09	partner_app
M8GRKB	free	2024-07-30 17:26:11+09	2024-07-30 17:26:11+09	partner_app
M9DJN1	free	2024-07-29 06:10:57+09	2024-07-29 06:10:57+09	partner_app
MARO98	free	2024-08-12 15:15:07+09	2024-08-12 15:15:07+09	partner_app
MBDJN1	free	2024-08-13 06:53:19+09	2024-08-13 06:53:19+09	partner_app
MBE5M6	free	2024-03-15 13:06:49+09	2024-03-15 13:06:49+09	partner_app
MEP2B3	free	2024-03-29 11:17:46+09	2024-03-29 11:17:46+09	partner_app
MG38X9	free	2024-04-15 00:30:42+09	2024-04-15 00:30:42+09	partner_app
MI38X9	free	2024-05-10 05:28:10+09	2024-05-10 05:28:10+09	partner_app
MI4UVE	free	2023-12-02 07:14:23+09	2023-12-02 07:14:23+09	partner_app
MLP2B3	free	2024-06-15 15:40:28+09	2024-06-15 15:40:28+09	partner_app
MMFRKB	free	2024-02-17 05:57:45+09	2024-02-17 05:57:45+09	partner_app
MOQO98	free	2024-02-20 06:09:56+09	2024-02-20 06:09:56+09	partner_app
MQCJN1	free	2024-02-21 06:09:52+09	2024-02-21 06:09:52+09	partner_app
MRE5M6	free	2024-08-08 11:43:02+09	2024-08-08 11:43:02+09	partner_app
MRQO98	free	2024-03-13 00:24:04+09	2024-03-13 00:24:04+09	partner_app
MRSA8D	free	2024-08-11 00:25:02+09	2024-08-11 00:25:02+09	partner_app
MS38X9	free	2024-08-13 12:39:11+09	2024-08-13 12:39:11+09	partner_app
MTSA8D	free	2024-08-19 16:08:30+09	2024-08-19 16:08:30+09	partner_app
MU38X9	free	2024-09-22 06:23:51+09	2024-09-22 06:23:51+09	partner_app
MVFRKB	free	2024-03-29 11:35:48+09	2024-03-29 11:35:48+09	partner_app
MXP2B3	free	2024-12-08 11:13:15+09	2024-12-08 11:13:15+09	partner_app
MYCJN1	free	2024-04-05 06:17:47+09	2024-04-05 06:17:47+09	partner_app
MYFRKB	free	2024-04-15 15:00:02+09	2024-04-15 15:00:02+09	partner_app
MZ28X9	free	2023-11-16 23:24:44+09	2023-11-16 23:24:44+09	partner_app
MZD5M6	free	2023-11-15 01:39:13+09	2023-11-15 01:39:13+09	partner_app
MZRA8D	free	2023-11-23 08:15:10+09	2023-11-23 08:15:10+09	partner_app
N02MY4	free	2024-04-30 03:22:18+09	2024-04-30 03:22:18+09	partner_app
N0GRKB	free	2024-05-13 00:17:26+09	2024-05-13 00:17:26+09	partner_app
N1P2B3	free	2023-11-28 01:36:10+09	2023-11-28 01:36:10+09	partner_app
N2GRKB	free	2024-06-17 16:52:46+09	2024-06-17 16:52:46+09	partner_app
N32MY4	free	2024-06-21 03:40:20+09	2024-06-21 03:40:20+09	partner_app
N4DJN1	free	2024-07-08 11:48:16+09	2024-07-08 11:48:16+09	partner_app
N4E5M6	free	2024-02-06 15:04:10+09	2024-02-06 15:04:10+09	partner_app
N5DJN1	free	2024-07-09 21:36:08+09	2024-07-09 21:36:08+09	partner_app
N5E5M6	free	2024-02-17 15:28:19+09	2024-02-17 15:28:19+09	partner_app
N75UVE	free	2024-07-28 14:50:33+09	2024-07-28 14:50:33+09	partner_app
N8RO98	free	2024-07-28 16:47:59+09	2024-07-28 16:47:59+09	partner_app
NARO98	free	2024-08-12 16:24:13+09	2024-08-12 16:24:13+09	partner_app
NC38X9	free	2024-03-26 00:33:44+09	2024-03-26 00:33:44+09	partner_app
NCGRKB	free	2024-09-30 02:06:40+09	2024-09-30 02:06:40+09	partner_app
NGE5M6	free	2024-04-14 12:34:36+09	2024-04-14 12:34:36+09	partner_app
NHQO98	free	2023-11-15 15:02:31+09	2023-11-15 15:02:31+09	partner_app
NL1MY4	free	2024-01-15 04:41:44+09	2024-01-15 04:41:44+09	partner_app
NLFRKB	free	2024-02-05 01:19:24+09	2024-02-05 01:19:24+09	partner_app
NMFRKB	free	2024-02-17 06:37:52+09	2024-02-17 06:37:52+09	partner_app
NN1MY4	free	2024-02-17 08:20:14+09	2024-02-17 08:20:14+09	partner_app
NOCJN1	free	2024-02-19 04:40:13+09	2024-02-19 04:40:13+09	partner_app
NPCJN1	free	2024-02-20 09:13:04+09	2024-02-20 09:13:04+09	partner_app
NPSA8D	free	2024-07-27 23:21:00+09	2024-07-27 23:21:00+09	partner_app
NQ1MY4	free	2024-02-22 05:06:24+09	2024-02-22 05:06:24+09	partner_app
NQE5M6	free	2024-07-28 04:51:14+09	2024-07-28 04:51:14+09	partner_app
NR38X9	free	2024-08-09 04:38:47+09	2024-08-09 04:38:47+09	partner_app
NRQO98	free	2024-03-13 00:31:52+09	2024-03-13 00:31:52+09	partner_app
NT1MY4	free	2024-03-15 10:22:55+09	2024-03-15 10:22:55+09	partner_app
NUSA8D	free	2024-10-06 09:46:51+09	2024-10-06 09:46:51+09	partner_app
NV1MY4	free	2024-03-26 10:00:59+09	2024-03-26 10:00:59+09	partner_app
NVE5M6	free	2024-10-12 19:29:29+09	2024-10-12 19:29:29+09	partner_app
O0DJN1	free	2024-04-17 23:05:20+09	2024-04-17 23:05:20+09	partner_app
O0GRKB	free	2024-05-13 02:16:03+09	2024-05-13 02:16:03+09	partner_app
O0P2B3	free	2023-11-19 09:43:07+09	2023-11-19 09:43:07+09	partner_app
O338X9	free	2024-02-04 00:20:23+09	2024-02-04 00:20:23+09	partner_app
O3GRKB	free	2024-07-09 16:15:45+09	2024-07-09 16:15:45+09	partner_app
O42MY4	free	2024-07-09 19:29:15+09	2024-07-09 19:29:15+09	partner_app
O4E5M6	free	2024-02-06 18:57:25+09	2024-02-06 18:57:25+09	partner_app
O4P2B3	free	2024-02-04 08:16:26+09	2024-02-04 08:16:26+09	partner_app
O4RO98	free	2024-07-09 21:26:24+09	2024-07-09 21:26:24+09	partner_app
O638X9	free	2024-02-20 09:25:59+09	2024-02-20 09:25:59+09	partner_app
OCDJN1	free	2024-08-15 02:12:58+09	2024-08-15 02:12:58+09	partner_app
OD2MY4	free	2024-10-03 07:45:10+09	2024-10-03 07:45:10+09	partner_app
OD38X9	free	2024-03-29 05:34:11+09	2024-03-29 05:34:11+09	partner_app
OD5UVE	free	2024-11-15 01:41:44+09	2024-11-15 01:41:44+09	partner_app
ODE5M6	free	2024-03-26 14:09:45+09	2024-03-26 14:09:45+09	partner_app
ODSA8D	free	2024-04-01 08:18:30+09	2024-04-01 08:18:30+09	partner_app
OG38X9	free	2024-04-15 04:39:05+09	2024-04-15 04:39:05+09	partner_app
OHFRKB	free	2023-11-21 05:24:57+09	2023-11-21 05:24:57+09	partner_app
OI38X9	free	2024-05-10 09:18:41+09	2024-05-10 09:18:41+09	partner_app
OJE5M6	free	2024-05-17 00:02:46+09	2024-05-17 00:02:46+09	partner_app
OKE5M6	free	2024-06-05 06:08:24+09	2024-06-05 06:08:24+09	partner_app
OL4UVE	free	2024-02-07 04:31:27+09	2024-02-07 04:31:27+09	partner_app
OLP2B3	free	2024-06-16 07:21:51+09	2024-06-16 07:21:51+09	partner_app
OMQO98	free	2024-02-13 07:23:00+09	2024-02-13 07:23:00+09	partner_app
ONCJN1	free	2024-02-14 12:05:17+09	2024-02-14 12:05:17+09	partner_app
OOFRKB	free	2024-02-20 09:26:42+09	2024-02-20 09:26:42+09	partner_app
OOSA8D	free	2024-07-16 09:29:51+09	2024-07-16 09:29:51+09	partner_app
OQCJN1	free	2024-02-21 06:10:06+09	2024-02-21 06:10:06+09	partner_app
OS1MY4	free	2024-03-14 04:05:16+09	2024-03-14 04:05:16+09	partner_app
OT38X9	free	2024-08-15 04:19:05+09	2024-08-15 04:19:05+09	partner_app
OVP2B3	free	2024-09-29 02:39:48+09	2024-09-29 02:39:48+09	partner_app
OVQO98	free	2024-03-27 09:09:17+09	2024-03-27 09:09:17+09	partner_app
OWP2B3	free	2024-10-27 14:01:07+09	2024-10-27 14:01:07+09	partner_app
P038X9	free	2023-11-27 10:06:19+09	2023-11-27 10:06:19+09	partner_app
P15UVE	free	2024-06-09 11:10:47+09	2024-06-09 11:10:47+09	partner_app
P1SA8D	free	2023-12-21 02:22:50+09	2023-12-21 02:22:50+09	partner_app
P35UVE	free	2024-07-09 20:58:46+09	2024-07-09 20:58:46+09	partner_app
P45UVE	free	2024-07-11 17:21:24+09	2024-07-11 17:21:24+09	partner_app
P4SA8D	free	2024-02-17 15:14:55+09	2024-02-17 15:14:55+09	partner_app
P538X9	free	2024-02-19 12:50:55+09	2024-02-19 12:50:55+09	partner_app
P8DJN1	free	2024-07-23 19:24:45+09	2024-07-23 19:24:45+09	partner_app
P95UVE	free	2024-08-12 12:47:50+09	2024-08-12 12:47:50+09	partner_app
PADJN1	free	2024-08-09 04:27:07+09	2024-08-09 04:27:07+09	partner_app
PB2MY4	free	2024-08-14 14:06:33+09	2024-08-14 14:06:33+09	partner_app
PBP2B3	free	2024-03-15 04:01:51+09	2024-03-15 04:01:51+09	partner_app
PDRO98	free	2024-10-19 09:50:31+09	2024-10-19 09:50:31+09	partner_app
PF38X9	free	2024-04-05 23:01:30+09	2024-04-05 23:01:30+09	partner_app
PG38X9	free	2024-04-15 05:36:09+09	2024-04-15 05:36:09+09	partner_app
PGE5M6	free	2024-04-14 13:01:29+09	2024-04-14 13:01:29+09	partner_app
PGFRKB	free	2023-11-14 02:34:30+09	2023-11-14 02:34:30+09	partner_app
PH4UVE	free	2023-11-23 08:15:39+09	2023-11-23 08:15:39+09	partner_app
PHFRKB	free	2023-11-21 14:04:01+09	2023-11-21 14:04:01+09	partner_app
PICJN1	free	2023-11-16 07:34:48+09	2023-11-16 07:34:48+09	partner_app
PJ1MY4	free	2023-12-01 03:18:33+09	2023-12-01 03:18:33+09	partner_app
PKCJN1	free	2023-12-04 09:28:27+09	2023-12-04 09:28:27+09	partner_app
PKP2B3	free	2024-05-26 17:15:26+09	2024-05-26 17:15:26+09	partner_app
PKSA8D	free	2024-06-27 03:39:56+09	2024-06-27 03:39:56+09	partner_app
PL4UVE	free	2024-02-07 17:56:11+09	2024-02-07 17:56:11+09	partner_app
POP2B3	free	2024-07-12 06:41:51+09	2024-07-12 06:41:51+09	partner_app
PPCJN1	free	2024-02-20 09:25:52+09	2024-02-20 09:25:52+09	partner_app
PPE5M6	free	2024-07-16 17:34:58+09	2024-07-16 17:34:58+09	partner_app
PPSA8D	free	2024-07-28 03:33:24+09	2024-07-28 03:33:24+09	partner_app
PQ4UVE	free	2024-03-13 00:09:21+09	2024-03-13 00:09:21+09	partner_app
PQCJN1	free	2024-02-21 06:10:16+09	2024-02-21 06:10:16+09	partner_app
PRQO98	free	2024-03-13 00:46:25+09	2024-03-13 00:46:25+09	partner_app
PS38X9	free	2024-08-14 02:00:35+09	2024-08-14 02:00:35+09	partner_app
PT1MY4	free	2024-03-15 10:26:22+09	2024-03-15 10:26:22+09	partner_app
PTE5M6	free	2024-08-14 17:40:17+09	2024-08-14 17:40:17+09	partner_app
PTFRKB	free	2024-03-23 10:15:46+09	2024-03-23 10:15:46+09	partner_app
PUP2B3	free	2024-08-15 07:21:18+09	2024-08-15 07:21:18+09	partner_app
PUQO98	free	2024-03-25 15:11:08+09	2024-03-25 15:11:08+09	partner_app
PVP2B3	free	2024-09-29 03:16:18+09	2024-09-29 03:16:18+09	partner_app
PYFRKB	free	2024-04-15 22:25:47+09	2024-04-15 22:25:47+09	partner_app
Q0DJN1	free	2024-04-18 10:43:47+09	2024-04-18 10:43:47+09	partner_app
Q138X9	free	2023-12-08 06:23:57+09	2023-12-08 06:23:57+09	partner_app
Q238X9	free	2024-01-06 12:37:20+09	2024-01-06 12:37:20+09	partner_app
Q2E5M6	free	2023-12-23 12:27:12+09	2023-12-23 12:27:12+09	partner_app
Q438X9	free	2024-02-17 04:09:52+09	2024-02-17 04:09:52+09	partner_app
Q5E5M6	free	2024-02-17 17:17:28+09	2024-02-17 17:17:28+09	partner_app
Q6GRKB	free	2024-07-15 15:38:37+09	2024-07-15 15:38:37+09	partner_app
Q6SA8D	free	2024-02-20 12:27:02+09	2024-02-20 12:27:02+09	partner_app
Q8E5M6	free	2024-02-27 00:09:21+09	2024-02-27 00:09:21+09	partner_app
Q8GRKB	free	2024-08-05 16:14:44+09	2024-08-05 16:14:44+09	partner_app
Q8P2B3	free	2024-02-21 07:05:00+09	2024-02-21 07:05:00+09	partner_app
Q938X9	free	2024-03-13 15:29:49+09	2024-03-13 15:29:49+09	partner_app
QCE5M6	free	2024-03-25 12:13:53+09	2024-03-25 12:13:53+09	partner_app
QCP2B3	free	2024-03-22 08:28:55+09	2024-03-22 08:28:55+09	partner_app
QCSA8D	free	2024-03-26 12:48:45+09	2024-03-26 12:48:45+09	partner_app
QE2MY4	free	2024-11-08 01:09:06+09	2024-11-08 01:09:06+09	partner_app
QERO98	free	2024-11-25 13:18:52+09	2024-11-25 13:18:52+09	partner_app
QESA8D	free	2024-04-04 11:24:35+09	2024-04-04 11:24:35+09	partner_app
QFE5M6	free	2024-04-05 00:44:20+09	2024-04-05 00:44:20+09	partner_app
QFP2B3	free	2024-04-03 11:32:18+09	2024-04-03 11:32:18+09	partner_app
QGFRKB	free	2023-11-14 04:31:51+09	2023-11-14 04:31:51+09	partner_app
QHE5M6	free	2024-04-16 12:57:34+09	2024-04-16 12:57:34+09	partner_app
QI4UVE	free	2023-12-02 12:10:57+09	2023-12-02 12:10:57+09	partner_app
QJP2B3	free	2024-05-12 16:09:12+09	2024-05-12 16:09:12+09	partner_app
QJQO98	free	2023-12-04 06:12:30+09	2023-12-04 06:12:30+09	partner_app
QKP2B3	free	2024-05-26 17:20:19+09	2024-05-26 17:20:19+09	partner_app
QKQO98	free	2023-12-30 14:54:55+09	2023-12-30 14:54:55+09	partner_app
QKSA8D	free	2024-06-27 08:20:01+09	2024-06-27 08:20:01+09	partner_app
QLFRKB	free	2024-02-05 03:19:03+09	2024-02-05 03:19:03+09	partner_app
QN38X9	free	2024-07-12 04:21:46+09	2024-07-12 04:21:46+09	partner_app
QOE5M6	free	2024-07-14 01:53:48+09	2024-07-14 01:53:48+09	partner_app
QR4UVE	free	2024-03-14 12:11:29+09	2024-03-14 12:11:29+09	partner_app
QTSA8D	free	2024-08-25 08:02:34+09	2024-08-25 08:02:34+09	partner_app
QUCJN1	free	2024-03-21 05:33:28+09	2024-03-21 05:33:28+09	partner_app
QVCJN1	free	2024-03-26 00:28:26+09	2024-03-26 00:28:26+09	partner_app
QVQO98	free	2024-03-28 01:06:36+09	2024-03-28 01:06:36+09	partner_app
QWFRKB	free	2024-04-04 01:20:36+09	2024-04-04 01:20:36+09	partner_app
QWSA8D	free	2025-01-14 17:10:35+09	2025-01-14 17:10:35+09	partner_app
QX4UVE	free	2024-04-14 15:15:23+09	2024-04-14 15:15:23+09	partner_app
QXP2B3	free	2024-12-12 23:02:57+09	2024-12-12 23:02:57+09	partner_app
QYQO98	free	2024-04-14 21:25:31+09	2024-04-14 21:25:31+09	partner_app
R0DJN1	free	2024-04-18 10:43:56+09	2024-04-18 10:43:56+09	partner_app
R0GRKB	free	2024-05-14 05:08:43+09	2024-05-14 05:08:43+09	partner_app
R138X9	free	2023-12-09 10:01:55+09	2023-12-09 10:01:55+09	partner_app
R22MY4	free	2024-06-02 08:09:16+09	2024-06-02 08:09:16+09	partner_app
R32MY4	free	2024-06-26 03:45:18+09	2024-06-26 03:45:18+09	partner_app
R3E5M6	free	2024-01-29 01:29:48+09	2024-01-29 01:29:48+09	partner_app
R42MY4	free	2024-07-09 19:47:07+09	2024-07-09 19:47:07+09	partner_app
R4DJN1	free	2024-07-09 08:44:31+09	2024-07-09 08:44:31+09	partner_app
R6GRKB	free	2024-07-16 00:21:58+09	2024-07-16 00:21:58+09	partner_app
R6RO98	free	2024-07-14 17:24:12+09	2024-07-14 17:24:12+09	partner_app
R6SA8D	free	2024-02-20 12:27:07+09	2024-02-20 12:27:07+09	partner_app
R72MY4	free	2024-07-16 04:02:49+09	2024-07-16 04:02:49+09	partner_app
R7DJN1	free	2024-07-15 00:42:55+09	2024-07-15 00:42:55+09	partner_app
R9E5M6	free	2024-03-12 23:04:37+09	2024-03-12 23:04:37+09	partner_app
RASA8D	free	2024-03-15 19:19:31+09	2024-03-15 19:19:31+09	partner_app
RB5UVE	free	2024-09-05 16:35:51+09	2024-09-05 16:35:51+09	partner_app
RC5UVE	free	2024-10-19 09:48:11+09	2024-10-19 09:48:11+09	partner_app
RD38X9	free	2024-03-29 11:23:26+09	2024-03-29 11:23:26+09	partner_app
REP2B3	free	2024-03-29 11:42:04+09	2024-03-29 11:42:04+09	partner_app
RG38X9	free	2024-04-15 07:31:40+09	2024-04-15 07:31:40+09	partner_app
RH4UVE	free	2023-11-23 08:15:50+09	2023-11-23 08:15:50+09	partner_app
RHQO98	free	2023-11-16 04:57:19+09	2023-11-16 04:57:19+09	partner_app
RLQO98	free	2024-02-03 10:24:37+09	2024-02-03 10:24:37+09	partner_app
RM1MY4	free	2024-02-05 17:08:45+09	2024-02-05 17:08:45+09	partner_app
RMP2B3	free	2024-07-09 15:45:09+09	2024-07-09 15:45:09+09	partner_app
RN1MY4	free	2024-02-17 15:13:39+09	2024-02-17 15:13:39+09	partner_app
RNCJN1	free	2024-02-17 00:50:56+09	2024-02-17 00:50:56+09	partner_app
ROCJN1	free	2024-02-19 11:35:44+09	2024-02-19 11:35:44+09	partner_app
ROE5M6	free	2024-07-14 02:57:49+09	2024-07-14 02:57:49+09	partner_app
ROFRKB	free	2024-02-20 09:32:03+09	2024-02-20 09:32:03+09	partner_app
RPE5M6	free	2024-07-17 05:28:38+09	2024-07-17 05:28:38+09	partner_app
RQCJN1	free	2024-02-21 06:10:20+09	2024-02-21 06:10:20+09	partner_app
RR1MY4	free	2024-03-12 13:17:59+09	2024-03-12 13:17:59+09	partner_app
RR4UVE	free	2024-03-14 12:13:03+09	2024-03-14 12:13:03+09	partner_app
RRFRKB	free	2024-03-14 03:01:17+09	2024-03-14 03:01:17+09	partner_app
RS1MY4	free	2024-03-14 06:08:47+09	2024-03-14 06:08:47+09	partner_app
RUQO98	free	2024-03-25 16:39:56+09	2024-03-25 16:39:56+09	partner_app
RV38X9	free	2024-10-26 20:16:16+09	2024-10-26 20:16:16+09	partner_app
RV4UVE	free	2024-04-02 05:41:57+09	2024-04-02 05:41:57+09	partner_app
RVQO98	free	2024-03-28 04:38:15+09	2024-03-28 04:38:15+09	partner_app
RX4UVE	free	2024-04-14 16:33:21+09	2024-04-14 16:33:21+09	partner_app
RXP2B3	free	2024-12-13 22:54:04+09	2024-12-13 22:54:04+09	partner_app
RZQO98	free	2024-04-17 18:23:44+09	2024-04-17 18:23:44+09	partner_app
RZRA8D	free	2023-11-23 08:15:35+09	2023-11-23 08:15:35+09	partner_app
S0GRKB	free	2024-05-14 18:58:45+09	2024-05-14 18:58:45+09	partner_app
S138X9	free	2023-12-09 10:02:20+09	2023-12-09 10:02:20+09	partner_app
S1RO98	free	2024-05-24 12:20:46+09	2024-05-24 12:20:46+09	partner_app
S238X9	free	2024-01-10 04:07:54+09	2024-01-10 04:07:54+09	partner_app
S2GRKB	free	2024-06-21 06:01:28+09	2024-06-21 06:01:28+09	partner_app
S2RO98	free	2024-06-12 05:17:20+09	2024-06-12 05:17:20+09	partner_app
S3RO98	free	2024-07-09 08:23:43+09	2024-07-09 08:23:43+09	partner_app
S45UVE	free	2024-07-11 20:36:03+09	2024-07-11 20:36:03+09	partner_app
S5GRKB	free	2024-07-12 18:45:16+09	2024-07-12 18:45:16+09	partner_app
S6GRKB	free	2024-07-16 00:29:06+09	2024-07-16 00:29:06+09	partner_app
S7E5M6	free	2024-02-20 13:33:53+09	2024-02-20 13:33:53+09	partner_app
S8GRKB	free	2024-08-08 07:46:35+09	2024-08-08 07:46:35+09	partner_app
S8P2B3	free	2024-02-21 12:54:13+09	2024-02-21 12:54:13+09	partner_app
S9P2B3	free	2024-03-12 09:38:44+09	2024-03-12 09:38:44+09	partner_app
SADJN1	free	2024-08-09 05:30:08+09	2024-08-09 05:30:08+09	partner_app
SBE5M6	free	2024-03-20 11:16:43+09	2024-03-20 11:16:43+09	partner_app
SC2MY4	free	2024-08-24 17:22:08+09	2024-08-24 17:22:08+09	partner_app
SEDJN1	free	2024-10-24 17:16:39+09	2024-10-24 17:16:39+09	partner_app
SFP2B3	free	2024-04-03 21:51:46+09	2024-04-03 21:51:46+09	partner_app
SHP2B3	free	2024-04-15 17:30:34+09	2024-04-15 17:30:34+09	partner_app
SI38X9	free	2024-05-11 02:41:23+09	2024-05-11 02:41:23+09	partner_app
SIE5M6	free	2024-05-08 15:21:37+09	2024-05-08 15:21:37+09	partner_app
SIP2B3	free	2024-04-25 06:28:46+09	2024-04-25 06:28:46+09	partner_app
SN38X9	free	2024-07-12 05:29:32+09	2024-07-12 05:29:32+09	partner_app
SN4UVE	free	2024-02-20 06:37:13+09	2024-02-20 06:37:13+09	partner_app
SNE5M6	free	2024-07-11 17:15:23+09	2024-07-11 17:15:23+09	partner_app
SPSA8D	free	2024-07-28 09:52:49+09	2024-07-28 09:52:49+09	partner_app
ST38X9	free	2024-08-15 07:12:44+09	2024-08-15 07:12:44+09	partner_app
SUQO98	free	2024-03-25 22:20:24+09	2024-03-25 22:20:24+09	partner_app
SV4UVE	free	2024-04-02 07:02:13+09	2024-04-02 07:02:13+09	partner_app
SWP2B3	free	2024-11-02 18:15:54+09	2024-11-02 18:15:54+09	partner_app
SXFRKB	free	2024-04-13 16:24:43+09	2024-04-13 16:24:43+09	partner_app
SXP2B3	free	2024-12-19 04:36:09+09	2024-12-19 04:36:09+09	partner_app
SYCJN1	free	2024-04-05 15:26:15+09	2024-04-05 15:26:15+09	partner_app
T0GRKB	free	2024-05-15 10:12:33+09	2024-05-15 10:12:33+09	partner_app
T0RO98	free	2024-05-10 05:07:25+09	2024-05-10 05:07:25+09	partner_app
T22MY4	free	2024-06-03 15:41:13+09	2024-06-03 15:41:13+09	partner_app
T238X9	free	2024-01-10 10:56:14+09	2024-01-10 10:56:14+09	partner_app
T4DJN1	free	2024-07-09 09:06:16+09	2024-07-09 09:06:16+09	partner_app
T52MY4	free	2024-07-11 07:45:15+09	2024-07-11 07:45:15+09	partner_app
T5RO98	free	2024-07-12 01:19:04+09	2024-07-12 01:19:04+09	partner_app
T7DJN1	free	2024-07-15 01:56:34+09	2024-07-15 01:56:34+09	partner_app
T7GRKB	free	2024-07-27 22:21:47+09	2024-07-27 22:21:47+09	partner_app
T7P2B3	free	2024-02-20 09:27:17+09	2024-02-20 09:27:17+09	partner_app
T7SA8D	free	2024-02-26 23:04:43+09	2024-02-26 23:04:43+09	partner_app
TB2MY4	free	2024-08-14 15:39:14+09	2024-08-14 15:39:14+09	partner_app
TBRO98	free	2024-08-15 03:25:03+09	2024-08-15 03:25:03+09	partner_app
TCSA8D	free	2024-03-26 14:18:10+09	2024-03-26 14:18:10+09	partner_app
TD38X9	free	2024-03-29 11:31:10+09	2024-03-29 11:31:10+09	partner_app
TDGRKB	free	2024-11-07 21:02:07+09	2024-11-07 21:02:07+09	partner_app
TEGRKB	free	2024-12-28 06:30:52+09	2024-12-28 06:30:52+09	partner_app
TFE5M6	free	2024-04-05 02:13:01+09	2024-04-05 02:13:01+09	partner_app
TGFRKB	free	2023-11-14 06:03:45+09	2023-11-14 06:03:45+09	partner_app
TH4UVE	free	2023-11-23 08:26:06+09	2023-11-23 08:26:06+09	partner_app
TKP2B3	free	2024-05-29 12:15:40+09	2024-05-29 12:15:40+09	partner_app
TM38X9	free	2024-07-10 12:08:29+09	2024-07-10 12:08:29+09	partner_app
TMQO98	free	2024-02-16 09:11:01+09	2024-02-16 09:11:01+09	partner_app
TP4UVE	free	2024-03-05 13:44:30+09	2024-03-05 13:44:30+09	partner_app
TPE5M6	free	2024-07-17 18:13:54+09	2024-07-17 18:13:54+09	partner_app
TPP2B3	free	2024-07-15 15:21:07+09	2024-07-15 15:21:07+09	partner_app
TR1MY4	free	2024-03-12 16:02:22+09	2024-03-12 16:02:22+09	partner_app
TRCJN1	free	2024-03-09 00:46:39+09	2024-03-09 00:46:39+09	partner_app
TUFRKB	free	2024-03-26 11:10:56+09	2024-03-26 11:10:56+09	partner_app
TV38X9	free	2024-10-28 03:56:08+09	2024-10-28 03:56:08+09	partner_app
TX4UVE	free	2024-04-14 20:26:54+09	2024-04-14 20:26:54+09	partner_app
TXFRKB	free	2024-04-13 19:40:51+09	2024-04-13 19:40:51+09	partner_app
TZ28X9	free	2023-11-20 00:26:55+09	2023-11-20 00:26:55+09	partner_app
U0E5M6	free	2023-11-23 08:15:49+09	2023-11-23 08:15:49+09	partner_app
U0P2B3	free	2023-11-22 02:32:35+09	2023-11-22 02:32:35+09	partner_app
U1GRKB	free	2024-06-02 05:00:22+09	2024-06-02 05:00:22+09	partner_app
U3GRKB	free	2024-07-09 19:41:30+09	2024-07-09 19:41:30+09	partner_app
U3RO98	free	2024-07-09 08:43:06+09	2024-07-09 08:43:06+09	partner_app
U6GRKB	free	2024-07-16 03:22:51+09	2024-07-16 03:22:51+09	partner_app
UASA8D	free	2024-03-17 23:48:02+09	2024-03-17 23:48:02+09	partner_app
UEDJN1	free	2024-10-26 16:48:33+09	2024-10-26 16:48:33+09	partner_app
UEGRKB	free	2024-12-29 04:43:10+09	2024-12-29 04:43:10+09	partner_app
UEP2B3	free	2024-04-01 04:58:53+09	2024-04-01 04:58:53+09	partner_app
UFSA8D	free	2024-04-14 13:36:46+09	2024-04-14 13:36:46+09	partner_app
UJ1MY4	free	2023-12-02 05:50:40+09	2023-12-02 05:50:40+09	partner_app
UJQO98	free	2023-12-04 11:08:05+09	2023-12-04 11:08:05+09	partner_app
UKQO98	free	2024-01-04 03:11:35+09	2024-01-04 03:11:35+09	partner_app
UM1MY4	free	2024-02-06 15:03:43+09	2024-02-06 15:03:43+09	partner_app
UN4UVE	free	2024-02-20 08:07:48+09	2024-02-20 08:07:48+09	partner_app
UNFRKB	free	2024-02-19 15:53:55+09	2024-02-19 15:53:55+09	partner_app
UNQO98	free	2024-02-19 11:14:29+09	2024-02-19 11:14:29+09	partner_app
UPCJN1	free	2024-02-20 09:26:09+09	2024-02-20 09:26:09+09	partner_app
UPFRKB	free	2024-02-24 21:50:22+09	2024-02-24 21:50:22+09	partner_app
UUSA8D	free	2024-10-14 22:17:43+09	2024-10-14 22:17:43+09	partner_app
UXFRKB	free	2024-04-14 02:33:33+09	2024-04-14 02:33:33+09	partner_app
UZ4UVE	free	2024-05-10 01:45:48+09	2024-05-10 01:45:48+09	partner_app
UZD5M6	free	2023-11-15 13:54:26+09	2023-11-15 13:54:26+09	partner_app
V1E5M6	free	2023-12-02 14:46:37+09	2023-12-02 14:46:37+09	partner_app
V2DJN1	free	2024-05-26 01:27:50+09	2024-05-26 01:27:50+09	partner_app
V3DJN1	free	2024-06-15 18:17:58+09	2024-06-15 18:17:58+09	partner_app
V538X9	free	2024-02-19 14:02:47+09	2024-02-19 14:02:47+09	partner_app
V6DJN1	free	2024-07-12 04:26:43+09	2024-07-12 04:26:43+09	partner_app
V8DJN1	free	2024-07-26 06:16:40+09	2024-07-26 06:16:40+09	partner_app
V938X9	free	2024-03-13 21:28:01+09	2024-03-13 21:28:01+09	partner_app
V9SA8D	free	2024-03-14 11:11:53+09	2024-03-14 11:11:53+09	partner_app
VAGRKB	free	2024-08-14 15:05:17+09	2024-08-14 15:05:17+09	partner_app
VASA8D	free	2024-03-19 10:39:07+09	2024-03-19 10:39:07+09	partner_app
VB2MY4	free	2024-08-14 16:58:53+09	2024-08-14 16:58:53+09	partner_app
VB5UVE	free	2024-09-11 23:45:30+09	2024-09-11 23:45:30+09	partner_app
VC38X9	free	2024-03-26 08:16:14+09	2024-03-26 08:16:14+09	partner_app
VCDJN1	free	2024-08-15 04:44:57+09	2024-08-15 04:44:57+09	partner_app
VCSA8D	free	2024-03-26 16:01:05+09	2024-03-26 16:01:05+09	partner_app
VDE5M6	free	2024-03-27 06:53:37+09	2024-03-27 06:53:37+09	partner_app
VEP2B3	free	2024-04-01 06:59:23+09	2024-04-01 06:59:23+09	partner_app
VGP2B3	free	2024-04-13 14:16:33+09	2024-04-13 14:16:33+09	partner_app
VH38X9	free	2024-04-22 05:47:15+09	2024-04-22 05:47:15+09	partner_app
VHCJN1	free	2023-11-13 00:02:44+09	2023-11-13 00:02:44+09	partner_app
VHFRKB	free	2023-11-23 08:15:29+09	2023-11-23 08:15:29+09	partner_app
VJQO98	free	2023-12-06 01:14:49+09	2023-12-06 01:14:49+09	partner_app
VKSA8D	free	2024-06-28 01:36:31+09	2024-06-28 01:36:31+09	partner_app
VL4UVE	free	2024-02-14 07:12:18+09	2024-02-14 07:12:18+09	partner_app
VLE5M6	free	2024-06-30 10:28:25+09	2024-06-30 10:28:25+09	partner_app
VLSA8D	free	2024-07-09 20:57:52+09	2024-07-09 20:57:52+09	partner_app
VMCJN1	free	2024-02-04 05:43:34+09	2024-02-04 05:43:34+09	partner_app
VNCJN1	free	2024-02-17 04:11:41+09	2024-02-17 04:11:41+09	partner_app
VO4UVE	free	2024-02-21 06:10:04+09	2024-02-21 06:10:04+09	partner_app
VOFRKB	free	2024-02-20 12:00:02+09	2024-02-20 12:00:02+09	partner_app
VPE5M6	free	2024-07-18 08:46:15+09	2024-07-18 08:46:15+09	partner_app
VR4UVE	free	2024-03-14 13:29:17+09	2024-03-14 13:29:17+09	partner_app
VSFRKB	free	2024-03-15 10:27:51+09	2024-03-15 10:27:51+09	partner_app
VSSA8D	free	2024-08-14 17:45:20+09	2024-08-14 17:45:20+09	partner_app
VTSA8D	free	2024-08-30 01:32:23+09	2024-08-30 01:32:23+09	partner_app
VUCJN1	free	2024-03-22 00:06:40+09	2024-03-22 00:06:40+09	partner_app
VVFRKB	free	2024-04-01 08:18:16+09	2024-04-01 08:18:16+09	partner_app
VX1MY4	free	2024-04-04 12:28:52+09	2024-04-04 12:28:52+09	partner_app
VXCJN1	free	2024-04-03 06:56:42+09	2024-04-03 06:56:42+09	partner_app
VYRA8D	free	2023-11-15 10:00:49+09	2023-11-15 10:00:49+09	partner_app
VZ1MY4	free	2024-04-16 11:47:25+09	2024-04-16 11:47:25+09	partner_app
W038X9	free	2023-11-29 05:32:36+09	2023-11-29 05:32:36+09	partner_app
W1RO98	free	2024-05-25 02:33:53+09	2024-05-25 02:33:53+09	partner_app
W2SA8D	free	2024-01-30 11:16:20+09	2024-01-30 11:16:20+09	partner_app
W35UVE	free	2024-07-09 21:53:58+09	2024-07-09 21:53:58+09	partner_app
W3P2B3	free	2024-01-15 06:38:05+09	2024-01-15 06:38:05+09	partner_app
W5SA8D	free	2024-02-20 04:36:55+09	2024-02-20 04:36:55+09	partner_app
W6P2B3	free	2024-02-19 15:16:07+09	2024-02-19 15:16:07+09	partner_app
W72MY4	free	2024-07-16 11:45:18+09	2024-07-16 11:45:18+09	partner_app
W75UVE	free	2024-07-29 06:34:27+09	2024-07-29 06:34:27+09	partner_app
W7RO98	free	2024-07-24 10:13:06+09	2024-07-24 10:13:06+09	partner_app
W8E5M6	free	2024-03-04 16:26:45+09	2024-03-04 16:26:45+09	partner_app
W8RO98	free	2024-07-29 12:27:08+09	2024-07-29 12:27:08+09	partner_app
WADJN1	free	2024-08-09 16:27:30+09	2024-08-09 16:27:30+09	partner_app
WARO98	free	2024-08-13 14:44:13+09	2024-08-13 14:44:13+09	partner_app
WB38X9	free	2024-03-22 11:41:11+09	2024-03-22 11:41:11+09	partner_app
WCE5M6	free	2024-03-25 13:38:19+09	2024-03-25 13:38:19+09	partner_app
WH1MY4	free	2023-11-15 06:46:04+09	2023-11-15 06:46:04+09	partner_app
WH4UVE	free	2023-11-24 02:22:00+09	2023-11-24 02:22:00+09	partner_app
WI4UVE	free	2023-12-04 08:51:51+09	2023-12-04 08:51:51+09	partner_app
WIE5M6	free	2024-05-09 20:27:43+09	2024-05-09 20:27:43+09	partner_app
WIFRKB	free	2023-12-01 09:49:34+09	2023-12-01 09:49:34+09	partner_app
WIQO98	free	2023-11-27 08:31:21+09	2023-11-27 08:31:21+09	partner_app
WJ1MY4	free	2023-12-02 06:12:27+09	2023-12-02 06:12:27+09	partner_app
WN4UVE	free	2024-02-20 09:25:51+09	2024-02-20 09:25:51+09	partner_app
WP4UVE	free	2024-03-06 21:20:14+09	2024-03-06 21:20:14+09	partner_app
WPFRKB	free	2024-02-26 11:28:42+09	2024-02-26 11:28:42+09	partner_app
WQSA8D	free	2024-08-08 12:48:05+09	2024-08-08 12:48:05+09	partner_app
WR38X9	free	2024-08-10 06:33:03+09	2024-08-10 06:33:03+09	partner_app
WR4UVE	free	2024-03-14 13:31:21+09	2024-03-14 13:31:21+09	partner_app
WRFRKB	free	2024-03-14 06:45:11+09	2024-03-14 06:45:11+09	partner_app
WRSA8D	free	2024-08-12 10:21:28+09	2024-08-12 10:21:28+09	partner_app
WSE5M6	free	2024-08-12 17:21:06+09	2024-08-12 17:21:06+09	partner_app
WSSA8D	free	2024-08-14 18:16:54+09	2024-08-14 18:16:54+09	partner_app
WT38X9	free	2024-08-15 14:22:39+09	2024-08-15 14:22:39+09	partner_app
WU38X9	free	2024-09-30 04:00:45+09	2024-09-30 04:00:45+09	partner_app
WUCJN1	free	2024-03-22 05:00:27+09	2024-03-22 05:00:27+09	partner_app
WVE5M6	free	2024-10-19 09:49:28+09	2024-10-19 09:49:28+09	partner_app
WX4UVE	free	2024-04-14 23:42:48+09	2024-04-14 23:42:48+09	partner_app
WYCJN1	free	2024-04-06 04:17:38+09	2024-04-06 04:17:38+09	partner_app
WZ4UVE	free	2024-05-10 04:14:59+09	2024-05-10 04:14:59+09	partner_app
WZCJN1	free	2024-04-15 09:13:57+09	2024-04-15 09:13:57+09	partner_app
WZO2B3	free	2023-11-14 05:27:34+09	2023-11-14 05:27:34+09	partner_app
X0DJN1	free	2024-04-20 13:06:36+09	2024-04-20 13:06:36+09	partner_app
X0P2B3	free	2023-11-23 07:21:41+09	2023-11-23 07:21:41+09	partner_app
X0SA8D	free	2023-12-02 11:11:42+09	2023-12-02 11:11:42+09	partner_app
X1DJN1	free	2024-05-11 08:13:27+09	2024-05-11 08:13:27+09	partner_app
X1RO98	free	2024-05-25 15:58:42+09	2024-05-25 15:58:42+09	partner_app
X1SA8D	free	2023-12-26 01:45:59+09	2023-12-26 01:45:59+09	partner_app
ZJP2B3	free	2024-05-16 00:29:53+09	2024-05-16 00:29:53+09	partner_app
ZKE5M6	free	2024-06-12 01:10:19+09	2024-06-12 01:10:19+09	partner_app
ZNP2B3	free	2024-07-11 02:03:36+09	2024-07-11 02:03:36+09	partner_app
ZQ38X9	free	2024-08-07 23:23:48+09	2024-08-07 23:23:48+09	partner_app
ZQFRKB	free	2024-03-12 18:05:40+09	2024-03-12 18:05:40+09	partner_app
ZRQO98	free	2024-03-13 16:19:09+09	2024-03-13 16:19:09+09	partner_app
ZU1MY4	free	2024-03-25 12:16:14+09	2024-03-25 12:16:14+09	partner_app
ZVE5M6	free	2024-10-22 20:08:39+09	2024-10-22 20:08:39+09	partner_app
ZXCJN1	free	2024-04-03 12:28:58+09	2024-04-03 12:28:58+09	partner_app
ZZCJN1	free	2024-04-15 15:32:35+09	2024-04-15 15:32:35+09	partner_app
ZZO2B3	free	2023-11-14 14:40:57+09	2023-11-14 14:40:57+09	partner_app
did:prodao:0xmaster	free	2025-02-25 00:59:43.793+09	2025-02-25 00:59:43.793+09	mobile_app
did:prodao:0x6a1f4c356fc8a736c3af102d16d223b15e08f3cc	free	2025-03-07 16:19:31.098+09	2025-03-07 16:19:31.098+09	mobile_app
\.


--
-- Name: admin admin_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.admin
    ADD CONSTRAINT admin_pkey PRIMARY KEY (id);


--
-- Name: business_individual_info business_individual_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business_individual_info
    ADD CONSTRAINT business_individual_info_pkey PRIMARY KEY (id);


--
-- Name: business_organization_info business_organization_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business_organization_info
    ADD CONSTRAINT business_organization_info_pkey PRIMARY KEY (id);


--
-- Name: business_organization_region_info business_organization_region_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business_organization_region_info
    ADD CONSTRAINT business_organization_region_info_pkey PRIMARY KEY (id);


--
-- Name: comment comment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (id);


--
-- Name: persona_member persona_member_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona_member
    ADD CONSTRAINT persona_member_pkey PRIMARY KEY (id);


--
-- Name: persona persona_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona
    ADD CONSTRAINT persona_pkey PRIMARY KEY (id);


--
-- Name: persona_profile persona_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona_profile
    ADD CONSTRAINT persona_profile_pkey PRIMARY KEY (id);


--
-- Name: persona_subscriber persona_subscriber_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona_subscriber
    ADD CONSTRAINT persona_subscriber_pkey PRIMARY KEY (id);


--
-- Name: post post_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post
    ADD CONSTRAINT post_pkey PRIMARY KEY (id);


--
-- Name: wallet wallet_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wallet
    ADD CONSTRAINT wallet_pkey PRIMARY KEY (did);


--
-- Name: admin_token_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX admin_token_idx ON public.admin USING btree (token);


--
-- Name: admin_token_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX admin_token_key ON public.admin USING btree (token);


--
-- Name: admin_username_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX admin_username_key ON public.admin USING btree (username);


--
-- Name: business_individual_info_persona_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX business_individual_info_persona_id_key ON public.business_individual_info USING btree (persona_id);


--
-- Name: business_organization_info_persona_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX business_organization_info_persona_id_key ON public.business_organization_info USING btree (persona_id);


--
-- Name: comment_author_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX comment_author_id_idx ON public.comment USING btree (author_id);


--
-- Name: comment_post_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX comment_post_id_idx ON public.comment USING btree (post_id);


--
-- Name: persona_profile_persona_id_key; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX persona_profile_persona_id_key ON public.persona_profile USING btree (persona_id);


--
-- Name: post_author_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX post_author_id_idx ON public.post USING btree (author_id);


--
-- Name: post_owner_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX post_owner_id_idx ON public.post USING btree (owner_id);


--
-- Name: business_individual_info business_individual_info_persona_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business_individual_info
    ADD CONSTRAINT business_individual_info_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.persona(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: business_organization_info business_organization_info_persona_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business_organization_info
    ADD CONSTRAINT business_organization_info_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.persona(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: business_organization_region_info business_organization_region_info_organization_info_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.business_organization_region_info
    ADD CONSTRAINT business_organization_region_info_organization_info_id_fkey FOREIGN KEY (organization_info_id) REFERENCES public.business_organization_info(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: comment comment_author_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_author_id_fkey FOREIGN KEY (author_id) REFERENCES public.persona(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: comment comment_post_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.comment
    ADD CONSTRAINT comment_post_id_fkey FOREIGN KEY (post_id) REFERENCES public.post(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: persona persona_did_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona
    ADD CONSTRAINT persona_did_fkey FOREIGN KEY (did) REFERENCES public.wallet(did) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: persona_member persona_member_member_persona_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona_member
    ADD CONSTRAINT persona_member_member_persona_id_fkey FOREIGN KEY (member_persona_id) REFERENCES public.persona(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: persona_member persona_member_persona_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona_member
    ADD CONSTRAINT persona_member_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.persona(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: persona_profile persona_profile_persona_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona_profile
    ADD CONSTRAINT persona_profile_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.persona(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: persona_subscriber persona_subscriber_persona_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona_subscriber
    ADD CONSTRAINT persona_subscriber_persona_id_fkey FOREIGN KEY (persona_id) REFERENCES public.persona(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: persona_subscriber persona_subscriber_subscriber_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.persona_subscriber
    ADD CONSTRAINT persona_subscriber_subscriber_id_fkey FOREIGN KEY (subscriber_id) REFERENCES public.persona(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: post post_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.post
    ADD CONSTRAINT post_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.persona(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

